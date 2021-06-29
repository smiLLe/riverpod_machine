part of 'machine.dart';

abstract class MachineProviderRef<State, Event> implements ProviderRefBase {
  /// Adding a state to the [StateMachine].
  /// The given callback will always execute when the state is entered.
  ///
  /// This method must only be called while the provider is being created.
  void onState<S extends State>(OnEnterState<State, S, Event> cb);
}

mixin MachineMixin<State, Event>
    on ProviderElementBase<StateMachineStatus<State, Event>> {
  late final State initialState;
  final List<StateNode<State, State, Event>> states = [];
  final Scheduler scheduler = Scheduler()..initialize();

  StateMachineStatus<State, Event> get initialStatus =>
      StateMachineStatus<State, Event>.notStarted(start: start);
  NodeConfig<State, State, Event>? current;
  String get type;

  StateNode<State, State, Event> getNode(State state) {
    return states.firstWhere(
      (node) => node.isState(state),
      orElse: () => throw Exception('State "$state" not found in "$type" '),
    );
  }

  @override
  void dispose() {
    cancelCurrent();
    state.maybeMap(
      orElse: () {},
      running: (running) {
        state = StateMachineStatus<State, Event>.stopped(
          lastState: running.state,
          start: start,
        );
      },
    );

    scheduler.dispose();
    states.clear();
    super.dispose();
  }

  void cancelCurrent() {
    current?.dispose();
    current = null;
  }

  void transition(State state) {
    cancelCurrent();
    final node = getNode(state);
    current = node.getConfig(this);
    this.state = StateMachineStatus<State, Event>.running(
      state: state,
      send: send,
      canSend: canSend,
      stop: stop,
    );
    node.enterState(current!);
  }

  /// Check whether it is possible to send an event to the [StateMachine].
  /// This will return false if machine is not running or the current active state
  /// has no event listener
  bool canSend(Event event) => state.map(
        notStarted: (_) => false,
        stopped: (_) => false,
        running: (running) {
          final candidate = current?._candidate(event);
          return null != candidate;
        },
      );

  /// Send and event to the machine and trigger all event listeners that subscribe
  /// to the given event in the current active state.
  void send(Event event) {
    state.map(
      notStarted: (notStarted) {
        assert(false, 'Cannot send event to "$type" while it is not running');
      },
      stopped: (stopped) {
        assert(false, 'Cannot send event to "$type" while it is stopped');
      },
      running: (running) {
        final candidate = current?._candidate(event);
        if (null == candidate) return;
        candidate._cb(event);
      },
    );
  }

  /// Start the [StateMachine]. This will allow to send events.
  /// It will also enter the initial state.
  void start() => state.map(
        running: (running) {
          assert(false, 'Cannot start $type because it is already running');
        },
        notStarted: (notStarted) => scheduler.schedule(() {
          transition(initialState);
        }),
        stopped: (stopped) => scheduler.schedule(() {
          transition(initialState);
        }),
      );

  /// Stop the [StateMachine]. It will no longer be possible to send events.
  /// It will also exit the current state.
  void stop() => state.map(
        notStarted: (_) {
          assert(false,
              '$type cannot be stopped because it has not been started, yet');
        },
        stopped: (stopped) {
          assert(false, '$type cannot be stopped because it is stopped');
        },
        running: (running) {
          cancelCurrent();
          state = StateMachineStatus<State, Event>.stopped(
            lastState: running.state,
            start: start,
          );
        },
      );
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
    ele.initialState = _create(ref);
    return ele.initialStatus;
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
