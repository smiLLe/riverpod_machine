import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod/riverpod.dart';

part 'scheduler.dart';
part 'state_machine_provider/base.dart';
part 'state_machine_provider/auto_dispose.dart';
part 'state_machine_provider/builder.dart';

part 'state_machine_provider.freezed.dart';

typedef OnEnterState<State, S extends State, Event> = void Function(
    NodeConfig<State, S, Event> cfg);

mixin MachineMixin<State, Event>
    on ProviderElementBase<StateMachineStatus<State, Event>> {
  late final State initialState;
  final List<StateNode<State, State, Event>> states = [];
  final Scheduler scheduler = Scheduler()..initialize();

  StateMachineStatus<State, Event> get initialStatus =>
      StateMachineStatus<State, Event>.notStarted(start: start);
  NodeConfig<State, State, Event>? current;
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
    state.maybeMap(
      orElse: () {},
      running: (running) {
        state = StateMachineStatus<State, Event>.stopped(
          lastState: running.state,
          start: start,
        );
      },
    );

    scheduler.dispose();
    states.clear();
    super.dispose();
  }

  void cancelCurrent() {
    current?.dispose();
    current = null;
  }

  void transition(State state) {
    cancelCurrent();
    final node = getNode(state);
    current = node.getConfig(this);
    this.state = StateMachineStatus<State, Event>.running(
      state: state,
      send: send,
      canSend: canSend,
      stop: stop,
    );
    node.enterState(current!);
  }

  /// Check whether it is possible to send an event to the [StateMachine].
  /// This will return false if machine is not running or the current active state
  /// has no event listener
  bool canSend(Event event) => state.map(
        notStarted: (_) => false,
        stopped: (_) => false,
        running: (running) {
          final candidate = current?._candidate(event);
          return null != candidate;
        },
      );

  /// Send and event to the machine and trigger all event listeners that subscribe
  /// to the given event in the current active state.
  void send(Event event) {
    state.map(
      notStarted: (notStarted) {
        assert(false, 'Cannot send event to "$type" while it is not running');
      },
      stopped: (stopped) {
        assert(false, 'Cannot send event to "$type" while it is stopped');
      },
      running: (running) {
        final candidate = current?._candidate(event);
        if (null == candidate) return;
        candidate._cb(event);
      },
    );
  }

  /// Start the [StateMachine]. This will allow to send events.
  /// It will also enter the initial state.
  void start() => state.map(
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

  /// Stop the [StateMachine]. It will no longer be possible to send events.
  /// It will also exit the current state.
  void stop() => state.map(
        notStarted: (_) {
          assert(false,
              '$type cannot be stopped because it has not been started, yet');
        },
        stopped: (stopped) {
          assert(false, '$type cannot be stopped because it is stopped');
        },
        running: (running) {
          cancelCurrent();
          state = StateMachineStatus<State, Event>.stopped(
            lastState: running.state,
            start: start,
          );
        },
      );
}

@freezed
class StateMachineStatus<State, Event> with _$StateMachineStatus<State, Event> {
  factory StateMachineStatus.notStarted({
    required void Function() start,
  }) = MachineNotStarted<State, Event>;

  factory StateMachineStatus.stopped({
    required State lastState,
    required void Function() start,
  }) = MachineStopped<State, Event>;

  factory StateMachineStatus.running({
    required State state,
    required void Function(Event event) send,
    required bool Function(Event event) canSend,
    required void Function() stop,
  }) = MachineRunning<State, Event>;
}

class StateNode<State, S extends State, Event> {
  StateNode(this._cb);

  final OnEnterState<State, S, Event> _cb;

  NodeConfig<State, S, Event> getConfig(MachineMixin<State, Event> machine) =>
      NodeConfig<State, S, Event>(machine);

  void enterState(NodeConfig<State, S, Event> cfg) {
    _cb(cfg);
  }

  bool isState(dynamic obj) => obj is S;
}

class _EventCb<Event, E extends Event> {
  _EventCb(this._cb);

  final void Function(Event event) _cb;
  bool isCandidate(Event obj) => obj is E;
}

class NodeConfig<State, S extends State, Event> {
  NodeConfig(this._machine);

  MachineMixin<State, Event>? _machine;
  final List<void Function()> _onLeave = [];
  final List<_EventCb<Event, Event>> _onEvent = [];

  void dispose() {
    _machine = null;
    _onEvent.clear();
    _onLeave
      ..forEach((disposer) => disposer())
      ..clear();
  }

  _EventCb<Event, Event>? _candidate(Event event) {
    return _onEvent.firstWhereOrNull((element) => element.isCandidate(event));
  }

  /// When leaving the current state, execute the callback.
  /// This is especially useful for cleaning up async processes.
  void onExit(void Function() cb) {
    if (null != _machine) {
      _onLeave.add(cb);
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
    return _machine!.state.map(
      notStarted: (notStarted) => false,
      stopped: (stopped) => false,
      running: (running) => true,
    );
  }

  /// Transition from the current state to another state.
  /// This will leave the current state and will execute all [NodeConfig.onExit] callbacks.
  void transition(State state) {
    assert(null != _machine,
        'Trying to transition to $state in $S which is no longer active');
    if (null != _machine) {
      final cur = _machine!.current;
      _machine!.scheduler.schedule(() {
        if (cur != _machine?.current) return;
        _machine!.transition(state);
      });
    }
  }
}
