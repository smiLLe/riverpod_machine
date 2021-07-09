import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod/riverpod.dart';

part 'scheduler.dart';
part 'state_machine_provider/base.dart';
part 'state_machine_provider/auto_dispose.dart';
part 'state_machine_provider/builder.dart';

part 'state_machine_provider.freezed.dart';

typedef OnEnterState<State, S extends State, Event> = void Function(
    StateSelf<State, S, Event> self);

typedef SessionId = int;

typedef MachineStart<State, Event> = void Function({State? state});
typedef MachineStop<State, Event> = void Function();
typedef MachineSend<State, Event> = void Function(Event event);

mixin MachineMixin<State, Event>
    on ProviderElementBase<StateMachineStatus<State, Event>> {
  late final State initialState;
  final List<StateNode<State, State, Event>> states = [];

  StateMachineStatus<State, Event> get initialStatus =>
      StateMachineStatus<State, Event>.notStarted(start: start);
  StateNode<State, State, Event>? activeNode;
  SessionId sessionId = 0;
  bool initialized = false;
  String get type;

  late StateMachineStatus<State, Event> currentStatus;

  StateNode<State, State, Event> getNode(State state) {
    return states.firstWhere(
      (node) => node.isState(state),
      orElse: () => throw Exception('State "$state" not found in "$type" '),
    );
  }

  @override
  StateMachineStatus<State, Event> get state => currentStatus;

  @override
  void dispose() {
    activeNode?.becomeInactive();
    activeNode = null;
    states.clear();
    super.dispose();
  }

  void transition(State state) {
    activeNode?.becomeInactive();

    sessionId += 1;
    final _sId = sessionId;

    final prevStatus = currentStatus;
    currentStatus = StateMachineStatus<State, Event>.running(
      state: state,
      send: send,
      canSend: canSend,
      stop: stop,
    );

    activeNode = getNode(state);
    activeNode!.becomeActive(_sId, this, prevStatus, state);

    if (_sId == sessionId) {
      this.state = currentStatus;
    }
  }

  bool canSend(Event event) => currentStatus.map(
        notStarted: (_) => false,
        stopped: (_) => false,
        running: (running) {
          final candidate = activeNode?._candidate(event);
          return null != candidate;
        },
      );

  void send(Event event) {
    currentStatus.map(
      notStarted: (notStarted) {
        assert(false, 'Cannot send event to "$type" while it is not running');
      },
      stopped: (stopped) {
        assert(false, 'Cannot send event to "$type" while it is stopped');
      },
      running: (running) {
        final candidate = activeNode?._candidate(event);
        if (null == candidate) return;
        candidate._cb(event);
      },
    );
  }

  void start({State? state}) => currentStatus.map(
        running: (running) {
          assert(false, 'Cannot start $type because it is already running');
        },
        notStarted: (notStarted) => transition(state ?? initialState),
        stopped: (stopped) => transition(state ?? initialState),
      );

  void stop() => currentStatus.map(
        notStarted: (_) {
          assert(false,
              '$type cannot be stopped because it has not been started, yet');
        },
        stopped: (stopped) {
          assert(false, '$type cannot be stopped because it is stopped');
        },
        running: (running) {
          activeNode?.becomeInactive();
          activeNode = null;
          state = currentStatus = StateMachineStatus<State, Event>.stopped(
            lastState: running.state,
            start: start,
          );
        },
      );
}

/// The Status of a [StateMachineProvider]
@freezed
class StateMachineStatus<State, Event> with _$StateMachineStatus<State, Event> {
  /// The default initial Status of a StateMachine. Indicates that the StateMachine
  /// has never been started or stopped before. It is not possible to send events
  /// to the StateMachine
  factory StateMachineStatus.notStarted({
    /// Start the StateMachine. This will allow to send events.
    /// It will also enter the initial state.
    required MachineStart<State, Event> start,
  }) = MachineNotStarted<State, Event>;

  /// StateMachine has been stopped. It is no longer possible to send events to
  /// Machine.
  factory StateMachineStatus.stopped({
    /// the last State the StateMachine was in.
    required State lastState,

    /// Start the StateMachine. This will allow to send events.
    /// It will also enter the initial state.
    required MachineStart<State, Event> start,
  }) = MachineStopped<State, Event>;

  /// StateMachine is in an active Status. States can change and it is possible
  /// to send events to the StateMachine
  factory StateMachineStatus.running({
    required State state,

    /// Send and event to the machine and trigger all event listeners that subscribe
    /// to the given event in the current active state.
    required MachineSend<State, Event> send,

    /// Check whether it is possible to send an event to the StateMachine.
    /// This will return false if machine is not running or the current active state
    /// has no event listener
    required bool Function(Event event) canSend,

    /// Stop the [StateMachine]. It will no longer be possible to send events.
    /// It will also exit the current state.
    required MachineStop<State, Event> stop,
  }) = MachineRunning<State, Event>;
}

class StateNode<State, S extends State, Event> {
  StateNode(this._cb);

  final OnEnterState<State, S, Event> _cb;

  final List<void Function()> _onExit = [];
  final List<_EventCb<Event, Event>> _onEvent = [];

  _EventCb<Event, Event>? _candidate(Event event) {
    return _onEvent.firstWhereOrNull((element) => element.isCandidate(event));
  }

  void becomeActive(SessionId sId, MachineMixin<State, Event> machine,
      StateMachineStatus<State, Event> prevStatus, S state) {
    _cb(StateSelf<State, S, Event>(
      currentState: state,
      previousStatus: prevStatus,
      transition: (State state) {
        if (sId == machine.sessionId) {
          machine.transition(state);
        }
      },
      onEvent: <E extends Event>(void Function(E event) cb) {
        if (sId == machine.sessionId) {
          _onEvent.add(_EventCb<Event, E>((event) => cb(event as E)));
        }
      },
      onExit: (void Function() cb) {
        if (sId == machine.sessionId) {
          _onExit.add(cb);
        } else {
          cb();
        }
      },
      canTransition: (State s) {
        if (sId != machine.sessionId) {
          return false;
        }
        return machine.currentStatus.map(
          notStarted: (notStarted) => false,
          stopped: (stopped) => false,
          running: (running) => machine.activeNode == this,
        );
      },
    ));
  }

  void becomeInactive() {
    _onExit
      ..forEach((exitCb) => exitCb())
      ..clear();
    _onEvent.clear();
  }

  bool isState(dynamic obj) => obj is S;
}

class _EventCb<Event, E extends Event> {
  _EventCb(this._cb);

  final void Function(Event event) _cb;
  bool isCandidate(Event obj) => obj is E;
}

@freezed
class StateSelf<State, S extends State, Event>
    with _$StateSelf<State, S, Event> {
  factory StateSelf({
    /// [StateMachineStatus] that was active before the current.
    required final StateMachineStatus<State, Event> previousStatus,

    /// The state when entered
    required S currentState,

    /// Transition to another state. This can only be called once in the current state.
    /// Subsequent calls are ignored.
    required void Function(State state) transition,

    /// Execute the callback given when leaving the state.
    /// Calls are immediately executed after state has been left.
    required void Function(void Function() cb) onExit,

    /// Attach an event to the current active state. This way one may communicate with the
    /// StateMachine from outside.
    /// Usually this is where a [transition] should happen.
    required void Function<E extends Event>(void Function(E event) cb) onEvent,

    /// Check if it is possible to transition.
    required bool Function(State state) canTransition,
  }) = _StateSelf<State, S, Event>;
}
