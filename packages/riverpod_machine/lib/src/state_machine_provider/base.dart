import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod/riverpod.dart';
import '../state_machine_provider.dart';
import 'builder.dart';

abstract class MachineProviderRef<StateValue, Event>
    implements ProviderRefBase {
  /// Adding a state to the [StateMachine].
  /// The given callback will always execute when the state is entered.
  ///
  /// This method must only be called while the provider is being created.
  void onState<S extends StateValue>(OnEnterState<StateValue, S, Event> cb);
}

class MachineProviderElement<StateValue, Event>
    extends ProviderElementBase<StateMachine<StateValue, Event>>
    with StateMachineImpl<StateValue, Event>
    implements MachineProviderRef<StateValue, Event> {
  MachineProviderElement(ProviderBase<StateMachine<StateValue, Event>> provider)
      : super(provider);

  @override
  String get type => provider.toString();

  @override
  void onState<S extends StateValue>(OnEnterState<StateValue, S, Event> cb) {
    states.add(StateNode<StateValue, S, Event>(cb));
  }
}

// ignore: subtype_of_sealed_class
@sealed
class StateMachineProvider<StateValue, Event>
    extends AlwaysAliveProviderBase<StateMachine<StateValue, Event>> {
  StateMachineProvider(this._create, {String? name}) : super(name);

  static const family = StateMachineProviderFamilyBuilder();
  static const autoDispose = AutoDisposeStateMachineProviderBuilder();
  static const autoDisposeFamily =
      AutoDisposeStateMachineProviderFamilyBuilder();

  final Create<StateValue, MachineProviderRef<StateValue, Event>> _create;

  @override
  StateMachine<StateValue, Event> create(
      MachineProviderRef<StateValue, Event> ref) {
    final ele = ref as MachineProviderElement<StateValue, Event>;
    ele.reset();
    ele.enter(_create(ref));
    return ele.state;
  }

  @override
  MachineProviderElement<StateValue, Event> createElement() =>
      MachineProviderElement(this);

  @override
  bool recreateShouldNotify(
    StateMachine<StateValue, Event> previousState,
    StateMachine<StateValue, Event> newState,
  ) {
    return true;
  }

  @override
  void setupOverride(
      void Function(
              {required ProviderBase origin, required ProviderBase override})
          setup) {
    setup(origin: this, override: this);
  }
}

class StateMachineProviderFamily<StateValue, Event, Arg> extends Family<
    StateMachine<StateValue, Event>,
    Arg,
    StateMachineProvider<StateValue, Event>> {
  StateMachineProviderFamily(this._create, {String? name}) : super(name);

  final FamilyCreate<StateValue, MachineProviderRef<StateValue, Event>, Arg>
      _create;

  @override
  StateMachineProvider<StateValue, Event> create(Arg argument) {
    return StateMachineProvider<StateValue, Event>(
      (ref) => _create(ref, argument),
      name: name,
    );
  }
}
