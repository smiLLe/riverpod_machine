import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod/riverpod.dart';

part 'machine.freezed.dart';

typedef OnEnterState<StateValue, S extends StateValue, Event> = void Function(
    ActiveState<StateValue, S, Event> self);
typedef MachineSend<Event> = void Function(Event event);

@freezed
class MachineStatus<StateValue, Event> with _$MachineStatus<StateValue, Event> {
  factory MachineStatus.idle() = MachineStatusIdle<StateValue, Event>;

  factory MachineStatus.stopped({
    required StateValue lastState,
  }) = MachineStatusStopped<StateValue, Event>;

  factory MachineStatus.running({
    required StateValue state,
  }) = MachineStatusRunning<StateValue, Event>;
}

class Machine<StateValue, Event>
    extends StateNotifier<MachineStatus<StateValue, Event>> {
  Machine({
    required this.initialStateValue,
    required this.states,
    String? name,
    bool autostart = false,
  })  : name = name ?? 'Machine',
        super(autostart
            ? MachineStatus<StateValue, Event>.running(state: initialStateValue)
            : MachineStatus<StateValue, Event>.idle());

  final StateValue initialStateValue;
  final List<StateNode<StateValue, Event>> states;
  final String name;
  ActiveState<StateValue, StateValue, Event>? activeState;

  @override
  void dispose() {
    activeState?.dispose();
    activeState = null;
    states.clear();
    super.dispose();
  }

  StateNode<StateValue, Event> getNode(StateValue value) {
    return states.firstWhere(
      (node) => node.isState(value),
      orElse: () =>
          throw Exception('StateValue "$value" not found in "$name" '),
    );
  }

  void transition(StateValue value) {
    final active = activeState;
    activeState = null;
    active?.dispose();

    final node = getNode(value);
    final newActiveState = node.createState(this, value);
    activeState = newActiveState;
    node.enter(newActiveState);
    if (newActiveState == activeState) {
      state = MachineStatus<StateValue, Event>.running(state: value);
    }
  }

  bool canSend(Event event) => state.map(
      idle: (_) => false,
      stopped: (_) => false,
      running: (running) => null != activeState?._candidate(event));

  void send(Event event) => state.map(
      idle: (idle) => throw StateError(
          'Trying to send event "$event" to "$name" which is not possible because it is in Idle status'),
      stopped: (stopped) => throw StateError(
          'Trying to send event "$event" to "$name" which is not possible because it is stopped'),
      running: (running) {
        final candidate = activeState?._candidate(event);
        if (null == candidate) return;
        candidate.handler(event);
      });

  void start({
    StateValue? stateValue,
  }) {
    state.maybeMap(
      running: (running) =>
          throw StateError('Trying to start "$name" which is already running'),
      orElse: () => transition(stateValue ?? initialStateValue),
    );
  }

  void stop() {
    activeState?.dispose();
    activeState = null;

    state.map(
        idle: (idle) => throw StateError(
            'Trying to stop "$name" is not possible because it is in Idle status'),
        stopped: (stopped) => throw StateError(
            'Trying to stop "$name" is not possible because it is already stopped'),
        running: (running) {
          state = MachineStatus<StateValue, Event>.stopped(
            lastState: running.state,
          );
        });
  }
}

@freezed
class StateNode<StateValue, Event> with _$StateNode<StateValue, Event> {
  factory StateNode({
    required void Function(ActiveState<StateValue, StateValue, Event> self)
        enter,
    required ActiveState<StateValue, StateValue, Event> Function(
      Machine<StateValue, Event> machine,
      StateValue value,
    )
        createState,
    required bool Function(dynamic obj) isState,
  }) = _StateNode<StateValue, Event>;
}

@freezed
class EventWrapper<Event> with _$EventWrapper<Event> {
  factory EventWrapper({
    required void Function(Event event) handler,
    required bool Function(Event obj) isCandidate,
  }) = _EventWrapper<Event>;
}

class ActiveState<StateValue, S, Event> {
  ActiveState({
    required Machine<StateValue, Event> machine,
    required this.enterState,
  }) : _machine = machine;

  final Machine<StateValue, Event> _machine;
  final List<void Function()> _onExit = [];
  final List<EventWrapper<Event>> _onEvent = [];

  /// The state when entered
  final S enterState;

  void dispose() {
    _onExit
      ..forEach((exitCb) => exitCb())
      ..clear();
    _onEvent.clear();
  }

  EventWrapper<Event>? _candidate(Event event) {
    return _onEvent.firstWhereOrNull((element) => element.isCandidate(event));
  }

  /// Transition to another state. This can only be called once in the current state.
  /// Subsequent calls are ignored.
  void transition(StateValue value) {
    if (!canTransition()) {
      throw StateError(
          'Cannot transition to StateValue "$value" because the active state is no longer active');
    }

    _machine.transition(value);
  }

  /// Execute the callback given when leaving the state.
  /// Calls are immediately executed after state has been left.
  void onExit(void Function() cb) {
    if (!canTransition()) {
      throw StateError(
          'Cannot add an exit callback because the active state is no longer active');
    }

    _onExit.add(cb);
  }

  /// Attach an event to the current active state. This way one may communicate with the
  /// StateMachine from outside.
  /// Usually this is where a [transition] should happen.
  void onEvent<E extends Event>(void Function(E event) cb) {
    if (!canTransition()) {
      throw StateError(
          'Cannot add an event callback because the active state is no longer active');
    }

    _onEvent.add(EventWrapper<Event>(
      handler: (event) => cb(event as E),
      isCandidate: (dynamic obj) => obj is E,
    ));
  }

  /// Check if it is possible to transition.
  bool canTransition() => _machine.activeState == this;
}
