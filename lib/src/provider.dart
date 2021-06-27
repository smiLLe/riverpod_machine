part of 'machine.dart';

abstract class MachineProviderRef<State, Event> implements ProviderRefBase {
  /// Adding a state to the [StateMachine].
  /// The given callback will always execute when the state is entered.
  ///
  /// This method must only be called while the provider is being created.
  void onState<S extends State>(OnEnterState<State, S, Event> cb);
}

class MachineProviderElement<State, Event>
    extends ProviderElementBase<StateMachine<State, Event>>
    implements MachineProviderRef<State, Event> {
  MachineProviderElement(ProviderBase<StateMachine<State, Event>> provider)
      : super(provider);

  final List<StateNode<State, State, Event>> _states = [];

  @override
  void onState<S extends State>(OnEnterState<State, S, Event> cb) {
    _states.add(StateNode<State, S, Event>(cb));
  }
}

class _StateMachineProvider<State, Event>
    extends AlwaysAliveProviderBase<StateMachine<State, Event>> {
  _StateMachineProvider(this._create, {String? name}) : super(name);
  final Create<StateMachine<State, Event>, MachineProviderRef<State, Event>>
      _create;

  @override
  StateMachine<State, Event> create(MachineProviderRef<State, Event> ref) =>
      _create(ref);

  @override
  bool recreateShouldNotify(StateMachine<State, Event> previousState,
      StateMachine<State, Event> newState) {
    return previousState != newState;
  }

  @override
  MachineProviderElement<State, Event> createElement() =>
      MachineProviderElement(this);
}

class StateMachineProvider<State, Event>
    extends AlwaysAliveProviderBase<StateMachineStatus<State, Event>> {
  StateMachineProvider(this._create, {String? name}) : super(name);

  static const family = StateMachineProviderFamilyBuilder();
  static const autoDispose = AutoDisposeStateMachineProviderBuilder();
  static const autoDisposeFamily =
      AutoDisposeStateMachineProviderFamilyBuilder();

  final Create<State, MachineProviderRef<State, Event>> _create;

  late final _StateMachineProvider<State, Event> machine =
      _StateMachineProvider<State, Event>((ref) {
    final scheduler = ref.watch(_$scheduler);
    final ele = ref as MachineProviderElement<State, Event>;
    final initialState = _create(ref);
    return StateMachine<State, Event>(initialState, ele._states, scheduler);
  });

  @override
  StateMachineStatus<State, Event> create(
      covariant ProviderRef<StateMachineStatus<State, Event>> ref) {
    final m = ref.watch(machine);
    StateMachineStatus<State, Event>? initial;
    ref.onDispose(m._notifier.addListener((state) {
      if (null == initial) {
        initial = state;
      } else {
        ref.state = state;
      }
    }));

    return initial!;
  }

  @override
  ProviderElement<StateMachineStatus<State, Event>> createElement() =>
      ProviderElement(this);

  @override
  bool recreateShouldNotify(
    StateMachineStatus<State, Event> previousState,
    StateMachineStatus<State, Event> newState,
  ) {
    return true;
  }
}

class StateMachineProviderFamily<State, Event, Arg> extends Family<
    StateMachineStatus<State, Event>, Arg, StateMachineProvider<State, Event>> {
  StateMachineProviderFamily(this._create, {String? name}) : super(name);

  final FamilyCreate<State, MachineProviderRef<State, Event>, Arg> _create;

  @override
  StateMachineProvider<State, Event> create(Arg argument) {
    return StateMachineProvider<State, Event>(
      (ref) => _create(ref, argument),
      name: name,
    );
  }
}

class StateMachineProviderFamilyBuilder {
  const StateMachineProviderFamilyBuilder();

  /// {@macro riverpod.family}
  StateMachineProviderFamily<State, Event, Arg> call<State, Event, Arg>(
    FamilyCreate<State, MachineProviderRef<State, Event>, Arg> create, {
    String? name,
  }) {
    return StateMachineProviderFamily(create, name: name);
  }
}
