part of '../state_machine_provider.dart';

abstract class MachineProviderRef<State, Event> implements ProviderRefBase {
  /// Adding a state to the [StateMachine].
  /// The given callback will always execute when the state is entered.
  ///
  /// This method must only be called while the provider is being created.
  void onState<S extends State>(OnEnterState<State, S, Event> cb);
}

class MachineProviderElement<State, Event>
    extends ProviderElementBase<StateMachineStatus<State, Event>>
    with MachineMixin<State, Event>
    implements MachineProviderRef<State, Event> {
  MachineProviderElement(
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
@sealed
class StateMachineProvider<State, Event>
    extends AlwaysAliveProviderBase<StateMachineStatus<State, Event>> {
  StateMachineProvider(this._create, {String? name}) : super(name);

  static const family = StateMachineProviderFamilyBuilder();
  static const autoDispose = AutoDisposeStateMachineProviderBuilder();
  static const autoDisposeFamily =
      AutoDisposeStateMachineProviderFamilyBuilder();

  final Create<State, MachineProviderRef<State, Event>> _create;

  @override
  StateMachineStatus<State, Event> create(
      MachineProviderRef<State, Event> ref) {
    final ele = ref as MachineProviderElement<State, Event>;
    if (!ele.initialized) {
      ele.initialized = true;
      ele.initialState = _create(ref);
      ele.currentStatus = ele.initialStatus;

      return ele.initialStatus;
    }
    return ele.state;
  }

  @override
  MachineProviderElement<State, Event> createElement() =>
      MachineProviderElement(this);

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
