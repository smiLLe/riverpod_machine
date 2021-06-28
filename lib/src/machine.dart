import 'package:flutter/cupertino.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod/riverpod.dart';
import 'package:collection/collection.dart';

part 'scheduler.dart';
part 'provider.dart';
part 'provider_auto_dispose.dart';

part 'machine.freezed.dart';

@freezed
class StateMachineStatus<State, Event> with _$StateMachineStatus<State, Event> {
  factory StateMachineStatus.notStarted({
    required void Function() start,
  }) = MachineNotStarted<State, Event>;

  factory StateMachineStatus.stopped({
    required State lastState,
    required void Function() start,
  }) = MachineStopped<State, Event>;

  factory StateMachineStatus.running({
    required State state,
    required void Function(Event event) send,
    required bool Function(Event event) canSend,
    required void Function() stop,
  }) = MachineRunning<State, Event>;
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
