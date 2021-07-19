import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod/riverpod.dart';

part 'state_machine_provider.freezed.dart';

typedef OnEnterState<StateValue, S extends StateValue, Event> = void Function(
    ActiveState<StateValue, S, Event> self);

typedef MachineSend<State, Event> = void Function(Event event);

@freezed
class StateMachine<StateValue, Event> with _$StateMachine<StateValue, Event> {
  factory StateMachine({
    required CurrentState<StateValue, Event> state,
    required MachineSend<StateValue, Event> send,
  }) = _StateMachine<StateValue, Event>;
}

@freezed
class CurrentState<StateValue, Event> with _$CurrentState<StateValue, Event> {
  factory CurrentState({
    required StateValue value,
  }) = _CurrentState<StateValue, Event>;
}

mixin StateMachineImpl<StateValue, Event>
    on ProviderElementBase<StateMachine<StateValue, Event>> {
  final List<StateNode<StateValue, StateValue, Event>> states = [];
  ActiveState<StateValue, StateValue, Event>? activeState;
  String get type;

  @override
  void dispose() {
    reset();
    super.dispose();
  }

  StateNode<StateValue, StateValue, Event> getNode(StateValue value) {
    return states.firstWhere(
      (node) => node.isState(value),
      orElse: () =>
          throw Exception('StateValue "$value" not found in "$type" '),
    );
  }

  void reset() {
    activeState?.dispose();
    activeState = null;
    states.clear();
  }

  void transition(StateValue value) {
    activeState?.dispose();
    activeState = null;

    enter(value);
  }

  void enter(StateValue value) {
    final created = getNode(value).createState(this, value);

    if (created == activeState) {
      state = StateMachine<StateValue, Event>(
        state: CurrentState<StateValue, Event>(value: value),
        send: send,
      );
    }
  }

  void send(Event event) {
    final candidate = activeState?._candidate(event);
    if (null == candidate) return;
    candidate._cb(event);
  }
}

class StateNode<StateValue, S extends StateValue, Event> {
  StateNode(this.enter);

  final OnEnterState<StateValue, S, Event> enter;

  ActiveState<StateValue, S, Event> createState(
      StateMachineImpl<StateValue, Event> machine, S value) {
    final active = ActiveState<StateValue, S, Event>(
      machine: machine,
      enterState: value,
    );
    machine.activeState = active;
    enter(active);
    return active;
  }

  bool isState(dynamic obj) => obj is S;
}

class _EventCb<Event, E extends Event> {
  _EventCb(this._cb);

  final void Function(Event event) _cb;
  bool isCandidate(Event obj) => obj is E;
}

class ActiveState<StateValue, S extends StateValue, Event> {
  ActiveState({
    required StateMachineImpl<StateValue, Event> machine,
    required this.enterState,
  }) : _machine = machine;

  final StateMachineImpl<StateValue, Event> _machine;
  final List<void Function()> _onExit = [];
  final List<_EventCb<Event, Event>> _onEvent = [];

  /// The state when entered
  final S enterState;

  void dispose() {
    _onExit
      ..forEach((exitCb) => exitCb())
      ..clear();
    _onEvent.clear();
  }

  _EventCb<Event, Event>? _candidate(Event event) {
    return _onEvent.firstWhereOrNull((element) => element.isCandidate(event));
  }

  /// Transition to another state. This can only be called once in the current state.
  /// Subsequent calls are ignored.
  void transition(StateValue value) {
    assert(canTransition(),
        'Cannot transition to StateValue "$value" because the active state is no longer active');

    if (!canTransition()) return;

    _machine.transition(value);
  }

  /// Execute the callback given when leaving the state.
  /// Calls are immediately executed after state has been left.
  void onExit(void Function() cb) {
    assert(canTransition(),
        'Cannot add an exit callback because the active state is no longer active');
    if (!canTransition()) return;
    _onExit.add(cb);
  }

  /// Attach an event to the current active state. This way one may communicate with the
  /// StateMachine from outside.
  /// Usually this is where a [transition] should happen.
  void onEvent<E extends Event>(void Function(E event) cb) {
    assert(canTransition(),
        'Cannot add an event callback because the active state is no longer active');
    if (!canTransition()) return;
    _onEvent.add(_EventCb<Event, E>((event) => cb(event as E)));
  }

  /// Check if it is possible to transition.
  bool canTransition() => _machine.activeState == this;
}
