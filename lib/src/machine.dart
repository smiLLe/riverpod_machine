import 'package:flutter/cupertino.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod/riverpod.dart';
import 'package:collection/collection.dart';

part 'scheduler.dart';

part 'machine.freezed.dart';

Type _typeOf<T>() => T;

final _$scheduler = Provider<Scheduler>((_) => Scheduler()..initialize());

@freezed
class StateMachineStatus<State, Event> with _$StateMachineStatus<State, Event> {
  factory StateMachineStatus.notStarted() = _NotStarted<State, Event>;

  factory StateMachineStatus.stopped({
    required State lastState,
  }) = _Stopped<State, Event>;

  factory StateMachineStatus.running({
    required State state,
  }) = _Running<State, Event>;
}

class StateNode<State, S extends State, Event> {
  StateNode(this._cb);

  final OnEnterState<State, S, Event> _cb;

  NodeConfig<State, S, Event> enterState(StateMachine<State, Event> machine) {
    final cfg = NodeConfig<State, S, Event>(machine);
    _cb(cfg);
    return cfg;
  }

  bool isState(dynamic obj) => obj is S;
}

class _EventCb<Event, E extends Event> {
  _EventCb(this._cb);

  final void Function(Event event) _cb;
  bool isCandidate(Event obj) => obj is E;
}

class NodeConfig<State, S extends State, Event> {
  NodeConfig(this._machine);

  StateMachine<State, Event>? _machine;
  final List<void Function()> _onLeave = [];
  final List<_EventCb<Event, Event>> _onEvent = [];

  void dispose() {
    _machine = null;
    _onEvent.clear();
    _onLeave
      ..forEach((disposer) => disposer())
      ..clear();
  }

  _EventCb<Event, Event>? _candidate(Event event) {
    return _onEvent.firstWhereOrNull((element) => element.isCandidate(event));
  }

  /// When leaving the current state, execute the callback.
  /// This is especially useful for cleaning up async processes.
  void onExit(void Function() cb) {
    if (null != _machine) {
      _onLeave.add(cb);
    } else {
      cb();
    }
  }

  /// Register a new listener for specific event.
  /// Listening for events is the way on how code can communicate
  /// with the [StateMachine].
  void onEvent<E extends Event>(void Function(E event) cb) {
    assert(null != _machine,
        'Trying to add event callback $E in $S which is no longer active');

    _onEvent.add(_EventCb<Event, E>((event) => cb(event as E)));
  }

  /// Check whether the current state can still transition to another state.
  /// This method is especially useful for async code that is execute in an
  /// [MachineProviderRef.onState].
  bool canTransition(State state) {
    if (null == _machine) return false;
    return _machine!._notifier.state.map(
      notStarted: (notStarted) => false,
      stopped: (stopped) => false,
      running: (running) => true,
    );
  }

  /// Transition from the current state to another state.
  /// This will leave the current state and will execute all [NodeConfig.onExit] callbacks.
  void transition(State state) {
    assert(null != _machine,
        'Trying to transition to $state in $S which is no longer active');
    if (null != _machine) {
      _machine!._transition(state);
    }
  }
}

typedef OnEnterState<State, S extends State, Event> = void Function(
    NodeConfig<State, S, Event> cfg);

class _StateMachineNotifier<State, Event>
    extends StateNotifier<StateMachineStatus<State, Event>> {
  _StateMachineNotifier(StateMachineStatus<State, Event> state) : super(state);

  @override
  set state(StateMachineStatus<State, Event> state) => super.state = state;

  @override
  get state => super.state;
}

class StateMachine<State, Event> {
  StateMachine(this.initialState, this._states, this._scheduler);

  final State initialState;
  final List<StateNode<State, State, Event>> _states;
  final Scheduler _scheduler;
  final _notifier = _StateMachineNotifier<State, Event>(
      StateMachineStatus<State, Event>.notStarted());

  String get _type => "${_typeOf<StateMachine<State, Event>>()}";

  NodeConfig<State, State, Event>? _current;

  void dispose() {
    stop();
    _notifier.dispose();
  }

  StateNode<State, State, Event> _getNode(State state) {
    return _states.firstWhere(
      (node) => node.isState(state),
      orElse: () => throw Exception('State "$state" not found in "$_type" '),
    );
  }

  void _cancelCurrent() {
    _current?.dispose();
    _current = null;
  }

  void _transition(State state) {
    _scheduler.schedule(() {
      _cancelCurrent();
      final node = _getNode(state);
      _current = node.enterState(this);
      _notifier.state = StateMachineStatus<State, Event>.running(state: state);
    });
  }

  bool canSend(Event event) => _notifier.state.map(
        notStarted: (_) => false,
        stopped: (_) => false,
        running: (running) {
          final candidate = _current?._candidate(event);
          return null != candidate;
        },
      );

  void send(Event event) {
    _notifier.state.map(
      notStarted: (notStarted) {
        assert(() {
          // ignore: avoid_print
          print('Cannot send event to "$_type" while it is not running');
          return true;
        }(), '');
      },
      stopped: (stopped) {
        assert(() {
          // ignore: avoid_print
          print('Cannot send event to "$_type" while it is stopped');
          return true;
        }(), '');
      },
      running: (running) {
        final candidate = _current?._candidate(event);
        if (null == candidate) return;
        candidate._cb(event);
      },
    );
  }

  void start() => _notifier.state.map(
        running: (running) {
          assert(() {
            // ignore: avoid_print
            print('Cannot start $_type because it is already running');
            return true;
          }(), '');
        },
        notStarted: (notStarted) => _transition(initialState),
        stopped: (stopped) => _transition(initialState),
      );

  void stop() => _notifier.state.map(
        notStarted: (_) {
          assert(() {
            // ignore: avoid_print
            print(
                '$_type cannot be stopped because it has not been started, yet');
            return true;
          }(), '');
        },
        stopped: (stopped) {
          assert(() {
            // ignore: avoid_print
            print('$_type cannot be stopped because it is stopped');
            return true;
          }(), '');
        },
        running: (running) {
          _cancelCurrent();
          _notifier.state = StateMachineStatus<State, Event>.stopped(
              lastState: running.state);
        },
      );
}

abstract class MachineProviderRef<State, Event> implements ProviderRefBase {
  /// Adding a state to the [StateMachine].
  /// The given callback will always execute when the state is entered.
  ///
  /// This method must only be called while the provider is being created.
  void onState<S extends State>(OnEnterState<State, S, Event> cb);
}

class MachineProviderElement<State, Event>
    extends ProviderElementBase<StateMachine<State, Event>>
    implements MachineProviderRef<State, Event> {
  MachineProviderElement(ProviderBase<StateMachine<State, Event>> provider)
      : super(provider);

  final List<StateNode<State, State, Event>> _states = [];

  @override
  void onState<S extends State>(OnEnterState<State, S, Event> cb) {
    _states.add(StateNode<State, S, Event>(cb));
  }
}

class _StateMachineProvider<State, Event>
    extends AlwaysAliveProviderBase<StateMachine<State, Event>> {
  _StateMachineProvider(this._create, {String? name}) : super(name);
  final Create<StateMachine<State, Event>, MachineProviderRef<State, Event>>
      _create;

  @override
  StateMachine<State, Event> create(MachineProviderRef<State, Event> ref) =>
      _create(ref);

  @override
  bool recreateShouldNotify(StateMachine<State, Event> previousState,
      StateMachine<State, Event> newState) {
    return previousState != newState;
  }

  @override
  MachineProviderElement<State, Event> createElement() =>
      MachineProviderElement(this);
}

class StateMachineProvider<State, Event>
    extends AlwaysAliveProviderBase<StateMachineStatus<State, Event>> {
  StateMachineProvider(this._create, {String? name}) : super(name);

  final Create<State, MachineProviderRef<State, Event>> _create;

  late final _StateMachineProvider<State, Event> machine =
      _StateMachineProvider<State, Event>((ref) {
    final scheduler = ref.watch(_$scheduler);
    final ele = ref as MachineProviderElement<State, Event>;
    final initialState = _create(ref);
    return StateMachine<State, Event>(initialState, ele._states, scheduler);
  });

  @override
  StateMachineStatus<State, Event> create(
      covariant ProviderRef<StateMachineStatus<State, Event>> ref) {
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
  ProviderElement<StateMachineStatus<State, Event>> createElement() =>
      ProviderElement(this);

  @override
  bool recreateShouldNotify(
    StateMachineStatus<State, Event> previousState,
    StateMachineStatus<State, Event> newState,
  ) {
    return true;
  }
}
