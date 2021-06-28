import 'package:flutter/cupertino.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod/riverpod.dart';
import 'package:collection/collection.dart';

part 'scheduler.dart';
part 'provider.dart';
part 'provider_auto_dispose.dart';

part 'machine.freezed.dart';

Type _typeOf<T>() => T;

final _$scheduler = Provider<Scheduler>((_) => Scheduler()..initialize());

@freezed
class StateMachineStatus<State, Event> with _$StateMachineStatus<State, Event> {
  factory StateMachineStatus.notStarted({
    required void Function() start,
  }) = _NotStarted<State, Event>;

  factory StateMachineStatus.stopped({
    required State lastState,
    required void Function() start,
  }) = _Stopped<State, Event>;

  factory StateMachineStatus.running({
    required State state,
    required void Function(Event event) send,
    required bool Function(Event event) canSend,
    required void Function() stop,
  }) = _Running<State, Event>;
}

class StateNode<State, S extends State, Event> {
  StateNode(this._cb);

  final OnEnterState<State, S, Event> _cb;

  NodeConfig<State, S, Event> getConfig(
          MachineProviderElement<State, Event> machine) =>
      NodeConfig<State, S, Event>(machine);

  void enterState(NodeConfig<State, S, Event> cfg) {
    _cb(cfg);
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

  MachineProviderElement<State, Event>? _machine;
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
    return _machine!.state.map(
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
      final cur = _machine!._current;
      _machine!._scheduler.schedule(() {
        if (cur != _machine?._current) return;
        _machine!._transition(state);
      });
    }
  }
}

typedef OnEnterState<State, S extends State, Event> = void Function(
    NodeConfig<State, S, Event> cfg);

// class _StateMachineNotifier<State, Event>
//     extends StateNotifier<StateMachineStatus<State, Event>> {
//   _StateMachineNotifier(StateMachineStatus<State, Event> state) : super(state);

//   @override
//   set state(StateMachineStatus<State, Event> state) => super.state = state;

//   @override
//   get state => super.state;
// }

// class StateMachine<State, Event> {
//   StateMachine(this.initialState, this._states, this._scheduler);

//   final State initialState;
//   final List<StateNode<State, State, Event>> _states;
//   final Scheduler _scheduler;
//   final _notifier = _StateMachineNotifier<State, Event>(
//       StateMachineStatus<State, Event>.notStarted());

//   String get _type => "${_typeOf<StateMachine<State, Event>>()}";

//   NodeConfig<State, State, Event>? _current;

//   /// Disposing the [StateMachine] will also call [StateMachine.stop].
//   void dispose() {
//     stop();
//     _notifier.dispose();
//   }

//   StateNode<State, State, Event> _getNode(State state) {
//     return _states.firstWhere(
//       (node) => node.isState(state),
//       orElse: () => throw Exception('State "$state" not found in "$_type" '),
//     );
//   }

//   void _cancelCurrent() {
//     _current?.dispose();
//     _current = null;
//   }

//   void _transition(State state) {
//     _cancelCurrent();
//     final node = _getNode(state);
//     _current = node.getConfig(this);
//     _notifier.state = StateMachineStatus<State, Event>.running(state: state);
//     node.enterState(_current!);
//   }

//   /// Check whether it is possible to send an event to the [StateMachine].
//   /// This will return false if machine is not running or the current active state
//   /// has no event listener
//   bool canSend(Event event) => _notifier.state.map(
//         notStarted: (_) => false,
//         stopped: (_) => false,
//         running: (running) {
//           final candidate = _current?._candidate(event);
//           return null != candidate;
//         },
//       );

//   /// Send and event to the machine and trigger all event listeners that subscribe
//   /// to the given event in the current active state.
//   void send(Event event) {
//     _notifier.state.map(
//       notStarted: (notStarted) {
//         assert(false, 'Cannot send event to "$_type" while it is not running');
//       },
//       stopped: (stopped) {
//         assert(false, 'Cannot send event to "$_type" while it is stopped');
//       },
//       running: (running) {
//         final candidate = _current?._candidate(event);
//         if (null == candidate) return;
//         candidate._cb(event);
//       },
//     );
//   }

//   /// Start the [StateMachine]. This will allow to send events.
//   /// It will also enter the initial state.
//   void start() => _notifier.state.map(
//         running: (running) {
//           assert(false, 'Cannot start $_type because it is already running');
//         },
//         notStarted: (notStarted) => _scheduler.schedule(() {
//           _transition(initialState);
//         }),
//         stopped: (stopped) => _scheduler.schedule(() {
//           _transition(initialState);
//         }),
//       );

//   /// Stop the [StateMachine]. It will no longer be possible to send events.
//   /// It will also exit the current state.
//   void stop() => _notifier.state.map(
//         notStarted: (_) {
//           assert(false,
//               '$_type cannot be stopped because it has not been started, yet');
//         },
//         stopped: (stopped) {
//           assert(false, '$_type cannot be stopped because it is stopped');
//         },
//         running: (running) {
//           _cancelCurrent();
//           _notifier.state = StateMachineStatus<State, Event>.stopped(
//               lastState: running.state);
//         },
//       );
// }
