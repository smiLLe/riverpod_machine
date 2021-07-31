import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod/riverpod.dart';
import '../machine.dart';
import 'builder.dart';

class _MachineProvider<StateValue, Event>
    extends AlwaysAliveProviderBase<Machine<StateValue, Event>> {
  _MachineProvider(this._create, {required String? name})
      : super(name == null ? null : '$name.machine');

  final Create<StateValue, MachineProviderRef<StateValue, Event>> _create;

  @override
  Machine<StateValue, Event> create(MachineProviderRef<StateValue, Event> ref) {
    final _ref = ref as MachineProviderElement<StateValue, Event>;
    final initial = _create(ref);

    final machine = Machine<StateValue, Event>(
      initialStateValue: initial,
      states: _ref._states,
      autostart: _ref._autostart,
      name: toString(),
    );
    ref.onDispose(machine.dispose);
    return machine;
  }

  @override
  bool recreateShouldNotify(Machine<StateValue, Event> previousState,
      Machine<StateValue, Event> newState) {
    return true;
  }

  @override
  MachineProviderElement<StateValue, Event> createElement() =>
      MachineProviderElement<StateValue, Event>(this);

  @override
  void setupOverride(SetupOverride setup) =>
      throw UnsupportedError('Cannot override MachineProvider.notifier');
}

abstract class MachineProviderRef<StateValue, Event>
    implements ProviderRefBase {
  /// Adding a state to the [StateMachine].
  /// The given callback will always execute when the state is entered.
  ///
  /// This method must only be called while the provider is being created.
  void onState<S extends StateValue>(OnEnterState<StateValue, S, Event> cb);

  /// Automatically start the Machine in running status.
  /// It takes the state returned by the providers body as the initial state
  void startAsRunning();
}

class MachineProviderElement<StateValue, Event>
    extends ProviderElementBase<Machine<StateValue, Event>>
    implements MachineProviderRef<StateValue, Event> {
  MachineProviderElement(ProviderBase<Machine<StateValue, Event>> provider)
      : super(provider);

  final List<StateNode<StateValue, Event>> _states = [];
  bool _autostart = false;

  @override
  void onState<S extends StateValue>(OnEnterState<StateValue, S, Event> cb) {
    _states.add(StateNode<StateValue, Event>(
      enter: (state) => cb(state as ActiveState<StateValue, S, Event>),
      isState: (dynamic obj) => obj is S,
      createState: (m, v) => ActiveState<StateValue, S, Event>(
        enterState: v as S,
        machine: m,
      ),
    ));
  }

  @override
  void startAsRunning() => _autostart = true;
}

@sealed
class StateMachineProvider<StateValue, Event>
    extends AlwaysAliveProviderBase<MachineStatus<StateValue, Event>>
    with StateMachineProviderMixin<StateValue, Event> {
  StateMachineProvider(this._create, {String? name}) : super(name);

  static const family = StateMachineProviderFamilyBuilder();
  static const autoDispose = AutoDisposeStateMachineProviderBuilder();
  static const autoDisposeFamily =
      AutoDisposeStateMachineProviderFamilyBuilder();

  final Create<StateValue, MachineProviderRef<StateValue, Event>> _create;

  @override
  late final AlwaysAliveProviderBase<Machine<StateValue, Event>> _machine =
      _MachineProvider<StateValue, Event>(_create, name: name);

  @override
  late final AlwaysAliveProviderBase<MachineSend<Event>> send =
      Provider<MachineSend<Event>>((ref) => ref.watch(_machine).send);

  @override
  MachineStatus<StateValue, Event> create(
      ProviderElementBase<MachineStatus<StateValue, Event>> ref) {
    final machine = ref.watch(_machine);

    void listener(MachineStatus<StateValue, Event> newState) {
      ref.state = newState;
    }

    final removeListener = machine.addListener(listener);
    ref.onDispose(removeListener);

    return ref.state;
  }

  @override
  bool recreateShouldNotify(MachineStatus<StateValue, Event> previousState,
      MachineStatus<StateValue, Event> newState) {
    return true;
  }

  Override overrideWithProvider(
    StateMachineProvider<Machine<StateValue, Event>,
            MachineStatus<StateValue, Event>>
        provider,
  ) {
    return ProviderOverride((setup) {
      setup(origin: _machine, override: provider._machine);
      setup(origin: send, override: provider.send);
      setup(origin: this, override: this);
    });
  }

  @override
  ProviderElementBase<MachineStatus<StateValue, Event>> createElement() =>
      ProviderElement(this);
}

mixin StateMachineProviderMixin<StateValue, Event>
    on ProviderBase<MachineStatus<StateValue, Event>> {
  ProviderBase<Machine<StateValue, Event>> get _machine;
  ProviderBase<MachineSend<Event>> get send;

  @override
  void setupOverride(SetupOverride setup) {
    setup(origin: this, override: this);
    setup(origin: _machine, override: _machine);
    setup(origin: send, override: send);
  }
}

@sealed
class StateMachineProviderFamily<StateValue, Event, Arg> extends Family<
    MachineStatus<StateValue, Event>,
    Arg,
    StateMachineProvider<StateValue, Event>> {
  StateMachineProviderFamily(this._create, {String? name}) : super(name);

  final FamilyCreate<StateValue, MachineProviderRef<StateValue, Event>, Arg>
      _create;

  @override
  StateMachineProvider<StateValue, Event> create(
    Arg argument,
  ) {
    final provider = StateMachineProvider<StateValue, Event>(
      (ref) => _create(ref, argument),
      name: name,
    );

    registerProvider(provider._machine, argument);

    return provider;
  }

  Override overrideWithProvider(
    StateMachineProvider<StateValue, Event> Function(Arg argument) override,
  ) {
    return FamilyOverride<Arg>(
      this,
      (arg, setup) {
        final provider = call(arg);
        setup(origin: provider._machine, override: override(arg)._machine);
        setup(origin: provider.send, override: override(arg).send);
        setup(origin: provider, override: provider);
      },
    );
  }

  @override
  void setupOverride(Arg argument, SetupOverride setup) {
    final provider = call(argument);
    setup(origin: provider, override: provider);
    setup(origin: provider._machine, override: provider._machine);
    setup(origin: provider.send, override: provider.send);
  }
}
