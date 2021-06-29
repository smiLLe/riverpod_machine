part of '../state_machine_provider.dart';

abstract class AutoDisposeMachineProviderRef<State, Event>
    implements AutoDisposeProviderRefBase, MachineProviderRef<State, Event> {}

class AutoDisposeMachineProviderElement<State, Event>
    extends AutoDisposeProviderElementBase<StateMachineStatus<State, Event>>
    with MachineMixin<State, Event>
    implements AutoDisposeMachineProviderRef<State, Event> {
  AutoDisposeMachineProviderElement(
      ProviderBase<StateMachineStatus<State, Event>> provider)
      : super(provider);

  @override
  String get type => provider.toString();

  @override
  void onState<S extends State>(OnEnterState<State, S, Event> cb) {
    states.add(StateNode<State, S, Event>(cb));
  }
}

// ignore: subtype_of_sealed_class
class AutoDisposeStateMachineProvider<State, Event>
    extends AutoDisposeProviderBase<StateMachineStatus<State, Event>> {
  AutoDisposeStateMachineProvider(this._create, {String? name}) : super(name);

  final Create<State, AutoDisposeMachineProviderRef<State, Event>> _create;

  @override
  StateMachineStatus<State, Event> create(
      AutoDisposeMachineProviderRef<State, Event> ref) {
    final ele = ref as AutoDisposeMachineProviderElement<State, Event>;
    ele.initialState = _create(ref);
    return ele.initialStatus;
  }

  @override
  AutoDisposeProviderElementBase<StateMachineStatus<State, Event>>
      createElement() {
    return AutoDisposeMachineProviderElement<State, Event>(this);
  }

  @override
  bool recreateShouldNotify(
    StateMachineStatus<State, Event> previousState,
    StateMachineStatus<State, Event> newState,
  ) {
    return true;
  }

  @override
  void Function(
    void Function({
      required ProviderBase origin,
      required ProviderBase override,
    })
        setup,
  ) get setupOverride => (setup) {
        setup(origin: this, override: this);
        // setup(origin: future, override: future);
        // setup(origin: Object(), override: Object());
      };
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
