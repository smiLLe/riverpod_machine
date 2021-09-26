// import 'package:freezed_annotation/freezed_annotation.dart';
// import 'package:riverpod/riverpod.dart';

// import '../machine.dart';
// import 'base.dart';

// class _AutoDisposeMachineProvider<StateValue, Event>
//     extends AutoDisposeProviderBase<Machine<StateValue, Event>> {
//   _AutoDisposeMachineProvider(this._create, {required String? name})
//       : super(name == null ? null : '$name.machine');

//   final Create<StateValue, AutoDisposeMachineProviderRef<StateValue, Event>>
//       _create;

//   @override
//   Machine<StateValue, Event> create(
//       AutoDisposeMachineProviderRef<StateValue, Event> ref) {
//     final _ref = ref as AutoDisposeMachineProviderElement<StateValue, Event>;
//     final initial = _create(ref);

//     final machine = Machine<StateValue, Event>(
//       initialStateValue: initial,
//       states: _ref._states,
//       autostart: _ref._autostart,
//       name: toString(),
//     );
//     ref.onDispose(machine.dispose);
//     return machine;
//   }

//   @override
//   bool recreateShouldNotify(Machine<StateValue, Event> previousState,
//       Machine<StateValue, Event> newState) {
//     return true;
//   }

//   @override
//   AutoDisposeMachineProviderElement<StateValue, Event> createElement() {
//     return AutoDisposeMachineProviderElement<StateValue, Event>(this);
//   }

//   @override
//   void setupOverride(SetupOverride setup) => throw UnsupportedError(
//       'Cannot override AutoDisposeMachineProvide.notifier');
// }

// abstract class AutoDisposeMachineProviderRef<StateValue, Event>
//     implements AutoDisposeProviderRefBase {
//   /// Adding a state to the [StateMachine].
//   /// The given callback will always execute when the state is entered.
//   ///
//   /// This method must only be called while the provider is being created.
//   void onState<S extends StateValue>(OnEnterState<StateValue, S, Event> cb);

//   /// Automatically start the Machine in running status.
//   /// It takes the state returned by the providers body as the initial state
//   void startAsRunning();
// }

// class AutoDisposeMachineProviderElement<StateValue, Event>
//     extends AutoDisposeProviderElementBase<Machine<StateValue, Event>>
//     implements AutoDisposeMachineProviderRef<StateValue, Event> {
//   AutoDisposeMachineProviderElement(
//       ProviderBase<Machine<StateValue, Event>> provider)
//       : super(provider);

//   final List<StateNode<StateValue, Event>> _states = [];
//   bool _autostart = false;

//   @override
//   void onState<S extends StateValue>(OnEnterState<StateValue, S, Event> cb) {
//     _states.add(StateNode<StateValue, Event>(
//       enter: (state) => cb(state as ActiveState<StateValue, S, Event>),
//       isState: (dynamic obj) => obj is S,
//       createState: (m, v) => ActiveState<StateValue, S, Event>(
//         enterState: v as S,
//         machine: m,
//       ),
//     ));
//   }

//   @override
//   void startAsRunning() => _autostart = true;
// }

// @sealed
// class AutoDisposeStateMachineProvider<StateValue, Event>
//     extends AlwaysAliveProviderBase<MachineStatus<StateValue, Event>>
//     with StateMachineProviderMixin<StateValue, Event> {
//   AutoDisposeStateMachineProvider(this._create, {String? name}) : super(name);

//   // static const family = StateMachineProviderFamilyBuilder();
//   // static const autoDispose = AutoDisposeStateMachineProviderBuilder();
//   // static const autoDisposeFamily =
//   //     AutoDisposeStateMachineProviderFamilyBuilder();

//   final Create<StateValue, AutoDisposeMachineProviderRef<StateValue, Event>>
//       _create;

//   @override
//   late final AutoDisposeProviderBase<Machine<StateValue, Event>> _machine =
//       _AutoDisposeMachineProvider<StateValue, Event>(_create, name: name);

//   @override
//   late final AutoDisposeProviderBase<MachineSend<Event>> send =
//       AutoDisposeProvider<MachineSend<Event>>(
//           (ref) => ref.watch(_machine).send);

//   @override
//   MachineStatus<StateValue, Event> create(
//       ProviderElementBase<MachineStatus<StateValue, Event>> ref) {
//     final machine = ref.watch(_machine);

//     void listener(MachineStatus<StateValue, Event> newState) {
//       ref.state = newState;
//     }

//     final removeListener = machine.addListener(listener);
//     ref.onDispose(removeListener);

//     return ref.state;
//   }

//   @override
//   bool recreateShouldNotify(MachineStatus<StateValue, Event> previousState,
//       MachineStatus<StateValue, Event> newState) {
//     return true;
//   }

//   Override overrideWithProvider(
//     AutoDisposeStateMachineProvider<Machine<StateValue, Event>,
//             MachineStatus<StateValue, Event>>
//         provider,
//   ) {
//     return ProviderOverride((setup) {
//       setup(origin: _machine, override: provider._machine);
//       setup(origin: send, override: provider.send);
//       setup(origin: this, override: this);
//     });
//   }

//   @override
//   AutoDisposeProviderElementBase<MachineStatus<StateValue, Event>>
//       createElement() => AutoDisposeProviderElement(this);
// }

// @sealed
// class AutoDisposeStateMachineProviderFamily<StateValue, Event, Arg>
//     extends Family<MachineStatus<StateValue, Event>, Arg,
//         AutoDisposeStateMachineProvider<StateValue, Event>> {
//   AutoDisposeStateMachineProviderFamily(this._create, {String? name})
//       : super(name);

//   final FamilyCreate<StateValue,
//       AutoDisposeMachineProviderRef<StateValue, Event>, Arg> _create;

//   @override
//   AutoDisposeStateMachineProvider<StateValue, Event> create(
//     Arg argument,
//   ) {
//     final provider = AutoDisposeStateMachineProvider<StateValue, Event>(
//       (ref) => _create(ref, argument),
//       name: name,
//     );

//     registerProvider(provider._machine, argument);

//     return provider;
//   }

//   Override overrideWithProvider(
//     AutoDisposeStateMachineProvider<StateValue, Event> Function(Arg argument)
//         override,
//   ) {
//     return FamilyOverride<Arg>(
//       this,
//       (arg, setup) {
//         final provider = call(arg);
//         setup(origin: provider._machine, override: override(arg)._machine);
//         setup(origin: provider.send, override: override(arg).send);
//         setup(origin: provider, override: provider);
//       },
//     );
//   }

//   @override
//   void setupOverride(Arg argument, SetupOverride setup) {
//     final provider = call(argument);
//     setup(origin: provider, override: provider);
//     setup(origin: provider._machine, override: provider._machine);
//     setup(origin: provider.send, override: provider.send);
//   }
// }
