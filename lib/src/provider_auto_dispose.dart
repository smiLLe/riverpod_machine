part of 'machine.dart';

abstract class AutoDisposeMachineProviderRef<State, Event>
    implements AutoDisposeProviderRefBase {
  /// Adding a state to the [StateMachine].
  /// The given callback will always execute when the state is entered.
  ///
  /// This method must only be called while the provider is being created.
  void onState<S extends State>(OnEnterState<State, S, Event> cb);
}

class AutoDisposeStateMachineProvider<State, Event>
    extends AlwaysAliveProviderBase<StateMachineStatus<State, Event>> {
  AutoDisposeStateMachineProvider(this._create, {String? name}) : super(name);

  final Create<State, AutoDisposeMachineProviderRef<State, Event>> _create;

  late final _AutoDisposeStateMachineProvider<State, Event> machine =
      _AutoDisposeStateMachineProvider<State, Event>((ref) {
    final scheduler = ref.watch(_$scheduler);
    final ele = ref as AutoDisposeMachineProviderElement<State, Event>;
    final initialState = _create(ref);
    return StateMachine<State, Event>(initialState, ele._states, scheduler);
  });

  @override
  StateMachineStatus<State, Event> create(
      covariant AutoDisposeProviderRef<StateMachineStatus<State, Event>> ref) {
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
  bool recreateShouldNotify(
    StateMachineStatus<State, Event> previousState,
    StateMachineStatus<State, Event> newState,
  ) {
    return true;
  }

  @override
  AutoDisposeProviderElement<StateMachineStatus<State, Event>> createElement() {
    return AutoDisposeProviderElement(this);
  }
}

class AutoDisposeMachineProviderElement<State, Event>
    extends AutoDisposeProviderElementBase<StateMachine<State, Event>>
    implements AutoDisposeMachineProviderRef<State, Event> {
  AutoDisposeMachineProviderElement(
      ProviderBase<StateMachine<State, Event>> provider)
      : super(provider);

  final List<StateNode<State, State, Event>> _states = [];

  @override
  void onState<S extends State>(OnEnterState<State, S, Event> cb) {
    _states.add(StateNode<State, S, Event>(cb));
  }
}

class _AutoDisposeStateMachineProvider<State, Event>
    extends AutoDisposeProviderBase<StateMachine<State, Event>> {
  _AutoDisposeStateMachineProvider(this._create, {String? name}) : super(name);
  final Create<StateMachine<State, Event>,
      AutoDisposeMachineProviderRef<State, Event>> _create;

  @override
  StateMachine<State, Event> create(
          AutoDisposeMachineProviderRef<State, Event> ref) =>
      _create(ref);

  @override
  bool recreateShouldNotify(StateMachine<State, Event> previousState,
      StateMachine<State, Event> newState) {
    return previousState != newState;
  }

  @override
  AutoDisposeMachineProviderElement<State, Event> createElement() =>
      AutoDisposeMachineProviderElement(this);
}

class AutoDisposeStateMachineProviderFamily<State, Event, Arg> extends Family<
    StateMachineStatus<State, Event>,
    Arg,
    AutoDisposeStateMachineProvider<State, Event>> {
  AutoDisposeStateMachineProviderFamily(this._create, {String? name})
      : super(name);

  final FamilyCreate<State, AutoDisposeMachineProviderRef<State, Event>, Arg>
      _create;

  @override
  AutoDisposeStateMachineProvider<State, Event> create(Arg argument) {
    return AutoDisposeStateMachineProvider<State, Event>(
      (ref) => _create(ref, argument),
      name: name,
    );
  }
}

class AutoDisposeStateMachineProviderBuilder {
  const AutoDisposeStateMachineProviderBuilder();

  /// {@macro riverpod.autoDispose}
  AutoDisposeStateMachineProvider<State, Event> call<State, Event>(
    Create<State, AutoDisposeMachineProviderRef<State, Event>> create, {
    String? name,
  }) {
    return AutoDisposeStateMachineProvider(create, name: name);
  }
}

class AutoDisposeStateMachineProviderFamilyBuilder {
  const AutoDisposeStateMachineProviderFamilyBuilder();

  /// {@macro riverpod.family}
  AutoDisposeStateMachineProviderFamily<State, Event, Arg>
      call<State, Event, Arg>(
    FamilyCreate<State, AutoDisposeMachineProviderRef<State, Event>, Arg>
        create, {
    String? name,
  }) {
    return AutoDisposeStateMachineProviderFamily(create, name: name);
  }
}
