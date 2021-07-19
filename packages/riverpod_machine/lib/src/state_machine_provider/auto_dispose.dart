import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod/riverpod.dart';
import '../state_machine_provider.dart';

abstract class AutoDisposeMachineProviderRef<StateValue, Event>
    implements AutoDisposeProviderRefBase {
  /// Adding a state to the [StateMachine].
  /// The given callback will always execute when the state is entered.
  ///
  /// This method must only be called while the provider is being created.
  void onState<S extends StateValue>(OnEnterState<StateValue, S, Event> cb);
}

class AutoDisposeMachineProviderElement<StateValue, Event>
    extends AutoDisposeProviderElementBase<StateMachine<StateValue, Event>>
    with StateMachineImpl<StateValue, Event>
    implements AutoDisposeMachineProviderRef<StateValue, Event> {
  AutoDisposeMachineProviderElement(
      ProviderBase<StateMachine<StateValue, Event>> provider)
      : super(provider);

  @override
  String get type => provider.toString();

  @override
  void onState<S extends StateValue>(OnEnterState<StateValue, S, Event> cb) {
    states.add(StateNode<StateValue, S, Event>(cb));
  }
}

// ignore: subtype_of_sealed_class
class AutoDisposeStateMachineProvider<StateValue, Event>
    extends AutoDisposeProviderBase<StateMachine<StateValue, Event>> {
  AutoDisposeStateMachineProvider(this._create, {String? name}) : super(name);

  final Create<StateValue, AutoDisposeMachineProviderRef<StateValue, Event>>
      _create;

  @override
  StateMachine<StateValue, Event> create(
      AutoDisposeMachineProviderRef<StateValue, Event> ref) {
    final ele = ref as AutoDisposeMachineProviderElement<StateValue, Event>;
    ele.reset();
    ele.enter(_create(ref));
    return ele.state;
  }

  @override
  AutoDisposeProviderElementBase<StateMachine<StateValue, Event>>
      createElement() {
    return AutoDisposeMachineProviderElement<StateValue, Event>(this);
  }

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

class AutoDisposeStateMachineProviderFamily<StateValue, Event, Arg>
    extends Family<StateMachine<StateValue, Event>, Arg,
        AutoDisposeStateMachineProvider<StateValue, Event>> {
  AutoDisposeStateMachineProviderFamily(this._create, {String? name})
      : super(name);

  final FamilyCreate<StateValue,
      AutoDisposeMachineProviderRef<StateValue, Event>, Arg> _create;

  @override
  AutoDisposeStateMachineProvider<StateValue, Event> create(Arg argument) {
    return AutoDisposeStateMachineProvider<StateValue, Event>(
      (ref) => _create(ref, argument),
      name: name,
    );
  }
}
