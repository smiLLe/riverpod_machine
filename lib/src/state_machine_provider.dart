import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod/riverpod.dart';

part 'scheduler.dart';
part 'state_machine_provider/base.dart';
part 'state_machine_provider/auto_dispose.dart';
part 'state_machine_provider/builder.dart';

part 'state_machine_provider.freezed.dart';

typedef OnEnterState<State, S extends State, Event> = void Function(
    StateSelf<State, S, Event> self);

typedef MachineStart<State, Event> = void Function();
typedef MachineStop<State, Event> = void Function();
typedef MachineSend<State, Event> = void Function(Event event);

mixin MachineMixin<State, Event>
    on ProviderElementBase<StateMachineStatus<State, Event>> {
  late final State initialState;
  final List<StateNode<State, State, Event>> states = [];
  final Scheduler scheduler = Scheduler()..initialize();

  StateMachineStatus<State, Event> get initialStatus =>
      StateMachineStatus<State, Event>.notStarted(start: start);
  StateSelf<State, State, Event>? inState;
  late StateMachineStatus<State, Event> status;
  String get type;

  StateNode<State, State, Event> getNode(State state) {
    return states.firstWhere(
      (node) => node.isState(state),
      orElse: () => throw Exception('State "$state" not found in "$type" '),
    );
  }

  @override
  void dispose() {
    cancelCurrent();
    scheduler.dispose();
    states.clear();
    super.dispose();
  }

  void cancelCurrent() {
    inState?.dispose();
    inState = null;
  }

  void transition(State state) {
    cancelCurrent();
    final node = getNode(state);
    inState = node.getConfig(this);
    status = StateMachineStatus<State, Event>.running(
      state: state,
      send: send,
      canSend: canSend,
      stop: stop,
    );
    node.enterState(inState!);
    this.state = status;
  }

  bool canSend(Event event) => status.map(
        notStarted: (_) => false,
        stopped: (_) => false,
        running: (running) {
          final candidate = inState?._candidate(event);
          return null != candidate;
        },
      );

  void send(Event event) {
    status.map(
      notStarted: (notStarted) {
        assert(false, 'Cannot send event to "$type" while it is not running');
      },
      stopped: (stopped) {
        assert(false, 'Cannot send event to "$type" while it is stopped');
      },
      running: (running) {
        final candidate = inState?._candidate(event);
        if (null == candidate) return;
        candidate._cb(event);
      },
    );
  }

  void start() => status.map(
        running: (running) {
          assert(false, 'Cannot start $type because it is already running');
        },
        notStarted: (notStarted) => scheduler.schedule(() {
          transition(initialState);
        }),
        stopped: (stopped) => scheduler.schedule(() {
          transition(initialState);
        }),
      );

  void stop() => status.map(
        notStarted: (_) {
          assert(false,
              '$type cannot be stopped because it has not been started, yet');
        },
        stopped: (stopped) {
          assert(false, '$type cannot be stopped because it is stopped');
        },
        running: (running) {
          cancelCurrent();
          state = status = StateMachineStatus<State, Event>.stopped(
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

  StateSelf<State, S, Event> getConfig(MachineMixin<State, Event> machine) =>
      StateSelf<State, S, Event>(machine);

  void enterState(StateSelf<State, S, Event> self) {
    _cb(self);
  }

  bool isState(dynamic obj) => obj is S;
}

class _EventCb<Event, E extends Event> {
  _EventCb(this._cb);

  final void Function(Event event) _cb;
  bool isCandidate(Event obj) => obj is E;
}

class StateSelf<State, S extends State, Event> {
  StateSelf(this._machine);

  MachineMixin<State, Event>? _machine;
  final List<void Function()> _onExit = [];
  final List<_EventCb<Event, Event>> _onEvent = [];

  void dispose() {
    _machine = null;
    _onEvent.clear();
    _onExit
      ..forEach((disposer) => disposer())
      ..clear();
  }

  _EventCb<Event, Event>? _candidate(Event event) {
    return _onEvent.firstWhereOrNull((element) => element.isCandidate(event));
  }

  /// When leaving the current state, execute the callback.
  /// This is especially useful for cleaning up async processes.
  /// If the state is no longer active and this function is called, it will
  /// automatically and immediately execute [cb]
  void onExit(void Function() cb) {
    if (null != _machine) {
      _onExit.add(cb);
    } else {
      cb();
    }
  }

  /// Register a new listener for specific event.
  /// Listening for events is the way on how code can communicate
  /// with the [StateMachine].
  void onEvent<E extends Event>(void Function(E event) cb) {
    assert(null != _machine,
        'Trying to add event callback $E in $S which is no longer active');

    _onEvent.add(_EventCb<Event, E>((event) => cb(event as E)));
  }

  /// Check whether the current state can still transition to another state.
  /// This method is especially useful for async code that is execute in an
  /// [MachineProviderRef.onState].
  bool canTransition(State state) {
    if (null == _machine) return false;
    return _machine!.status.map(
      notStarted: (notStarted) => false,
      stopped: (stopped) => false,
      running: (running) => true,
    );
  }

  /// Transition from the current state to another state.
  /// This will leave the current state and will execute all [StateSelf.onExit] callbacks.
  void transition(State state) {
    assert(null != _machine,
        'Trying to transition to $state in $S which is no longer active');
    if (null != _machine) {
      _machine!.scheduler.schedule(() {
        if (this != _machine?.inState) return;
        _machine!.transition(state);
      });
    }
  }
}
