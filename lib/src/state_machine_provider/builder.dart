part of '../state_machine_provider.dart';

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

class AutoDisposeStateMachineProviderBuilder {
  const AutoDisposeStateMachineProviderBuilder();

  AutoDisposeStateMachineProvider<State, Event> call<State, Event>(
    Create<State, AutoDisposeMachineProviderRef<State, Event>> create, {
    String? name,
  }) {
    return AutoDisposeStateMachineProvider(create, name: name);
  }
}

class AutoDisposeStateMachineProviderFamilyBuilder {
  const AutoDisposeStateMachineProviderFamilyBuilder();

  AutoDisposeStateMachineProviderFamily<State, Event, Arg>
      call<State, Event, Arg>(
    FamilyCreate<State, AutoDisposeMachineProviderRef<State, Event>, Arg>
        create, {
    String? name,
  }) {
    return AutoDisposeStateMachineProviderFamily(create, name: name);
  }
}
