import 'package:riverpod/riverpod.dart';
import 'base.dart';
import 'auto_dispose.dart';

class StateMachineProviderFamilyBuilder {
  const StateMachineProviderFamilyBuilder();

  StateMachineProviderFamily<State, Event, Arg> call<State, Event, Arg>(
    FamilyCreate<State, MachineProviderRef<State, Event>, Arg> create, {
    String? name,
  }) {
    return StateMachineProviderFamily<State, Event, Arg>(create, name: name);
  }
}

class AutoDisposeStateMachineProviderBuilder {
  const AutoDisposeStateMachineProviderBuilder();

  AutoDisposeStateMachineProvider<State, Event> call<State, Event>(
    Create<State, AutoDisposeMachineProviderRef<State, Event>> create, {
    String? name,
  }) {
    return AutoDisposeStateMachineProvider<State, Event>(create, name: name);
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
    return AutoDisposeStateMachineProviderFamily<State, Event, Arg>(create,
        name: name);
  }
}
