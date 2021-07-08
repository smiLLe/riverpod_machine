// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides

part of 'state_machine_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$StateMachineStatusTearOff {
  const _$StateMachineStatusTearOff();

  MachineNotStarted<State, Event> notStarted<State, Event>(
      {required void Function({State? state}) start}) {
    return MachineNotStarted<State, Event>(
      start: start,
    );
  }

  MachineStopped<State, Event> stopped<State, Event>(
      {required State lastState,
      required void Function({State? state}) start}) {
    return MachineStopped<State, Event>(
      lastState: lastState,
      start: start,
    );
  }

  MachineRunning<State, Event> running<State, Event>(
      {required State state,
      required void Function(Event) send,
      required bool Function(Event) canSend,
      required void Function() stop}) {
    return MachineRunning<State, Event>(
      state: state,
      send: send,
      canSend: canSend,
      stop: stop,
    );
  }
}

/// @nodoc
const $StateMachineStatus = _$StateMachineStatusTearOff();

/// @nodoc
mixin _$StateMachineStatus<State, Event> {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(void Function({State? state}) start) notStarted,
    required TResult Function(
            State lastState, void Function({State? state}) start)
        stopped,
    required TResult Function(State state, void Function(Event) send,
            bool Function(Event) canSend, void Function() stop)
        running,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(void Function({State? state}) start)? notStarted,
    TResult Function(State lastState, void Function({State? state}) start)?
        stopped,
    TResult Function(State state, void Function(Event) send,
            bool Function(Event) canSend, void Function() stop)?
        running,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(MachineNotStarted<State, Event> value) notStarted,
    required TResult Function(MachineStopped<State, Event> value) stopped,
    required TResult Function(MachineRunning<State, Event> value) running,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(MachineNotStarted<State, Event> value)? notStarted,
    TResult Function(MachineStopped<State, Event> value)? stopped,
    TResult Function(MachineRunning<State, Event> value)? running,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StateMachineStatusCopyWith<State, Event, $Res> {
  factory $StateMachineStatusCopyWith(StateMachineStatus<State, Event> value,
          $Res Function(StateMachineStatus<State, Event>) then) =
      _$StateMachineStatusCopyWithImpl<State, Event, $Res>;
}

/// @nodoc
class _$StateMachineStatusCopyWithImpl<State, Event, $Res>
    implements $StateMachineStatusCopyWith<State, Event, $Res> {
  _$StateMachineStatusCopyWithImpl(this._value, this._then);

  final StateMachineStatus<State, Event> _value;
  // ignore: unused_field
  final $Res Function(StateMachineStatus<State, Event>) _then;
}

/// @nodoc
abstract class $MachineNotStartedCopyWith<State, Event, $Res> {
  factory $MachineNotStartedCopyWith(MachineNotStarted<State, Event> value,
          $Res Function(MachineNotStarted<State, Event>) then) =
      _$MachineNotStartedCopyWithImpl<State, Event, $Res>;
  $Res call({void Function({State? state}) start});
}

/// @nodoc
class _$MachineNotStartedCopyWithImpl<State, Event, $Res>
    extends _$StateMachineStatusCopyWithImpl<State, Event, $Res>
    implements $MachineNotStartedCopyWith<State, Event, $Res> {
  _$MachineNotStartedCopyWithImpl(MachineNotStarted<State, Event> _value,
      $Res Function(MachineNotStarted<State, Event>) _then)
      : super(_value, (v) => _then(v as MachineNotStarted<State, Event>));

  @override
  MachineNotStarted<State, Event> get _value =>
      super._value as MachineNotStarted<State, Event>;

  @override
  $Res call({
    Object? start = freezed,
  }) {
    return _then(MachineNotStarted<State, Event>(
      start: start == freezed
          ? _value.start
          : start // ignore: cast_nullable_to_non_nullable
              as void Function({State? state}),
    ));
  }
}

/// @nodoc

class _$MachineNotStarted<State, Event>
    implements MachineNotStarted<State, Event> {
  _$MachineNotStarted({required this.start});

  @override

  /// Start the StateMachine. This will allow to send events.
  /// It will also enter the initial state.
  final void Function({State? state}) start;

  @override
  String toString() {
    return 'StateMachineStatus<$State, $Event>.notStarted(start: $start)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is MachineNotStarted<State, Event> &&
            (identical(other.start, start) ||
                const DeepCollectionEquality().equals(other.start, start)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(start);

  @JsonKey(ignore: true)
  @override
  $MachineNotStartedCopyWith<State, Event, MachineNotStarted<State, Event>>
      get copyWith => _$MachineNotStartedCopyWithImpl<State, Event,
          MachineNotStarted<State, Event>>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(void Function({State? state}) start) notStarted,
    required TResult Function(
            State lastState, void Function({State? state}) start)
        stopped,
    required TResult Function(State state, void Function(Event) send,
            bool Function(Event) canSend, void Function() stop)
        running,
  }) {
    return notStarted(start);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(void Function({State? state}) start)? notStarted,
    TResult Function(State lastState, void Function({State? state}) start)?
        stopped,
    TResult Function(State state, void Function(Event) send,
            bool Function(Event) canSend, void Function() stop)?
        running,
    required TResult orElse(),
  }) {
    if (notStarted != null) {
      return notStarted(start);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(MachineNotStarted<State, Event> value) notStarted,
    required TResult Function(MachineStopped<State, Event> value) stopped,
    required TResult Function(MachineRunning<State, Event> value) running,
  }) {
    return notStarted(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(MachineNotStarted<State, Event> value)? notStarted,
    TResult Function(MachineStopped<State, Event> value)? stopped,
    TResult Function(MachineRunning<State, Event> value)? running,
    required TResult orElse(),
  }) {
    if (notStarted != null) {
      return notStarted(this);
    }
    return orElse();
  }
}

abstract class MachineNotStarted<State, Event>
    implements StateMachineStatus<State, Event> {
  factory MachineNotStarted({required void Function({State? state}) start}) =
      _$MachineNotStarted<State, Event>;

  /// Start the StateMachine. This will allow to send events.
  /// It will also enter the initial state.
  void Function({State? state}) get start => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MachineNotStartedCopyWith<State, Event, MachineNotStarted<State, Event>>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MachineStoppedCopyWith<State, Event, $Res> {
  factory $MachineStoppedCopyWith(MachineStopped<State, Event> value,
          $Res Function(MachineStopped<State, Event>) then) =
      _$MachineStoppedCopyWithImpl<State, Event, $Res>;
  $Res call({State lastState, void Function({State? state}) start});
}

/// @nodoc
class _$MachineStoppedCopyWithImpl<State, Event, $Res>
    extends _$StateMachineStatusCopyWithImpl<State, Event, $Res>
    implements $MachineStoppedCopyWith<State, Event, $Res> {
  _$MachineStoppedCopyWithImpl(MachineStopped<State, Event> _value,
      $Res Function(MachineStopped<State, Event>) _then)
      : super(_value, (v) => _then(v as MachineStopped<State, Event>));

  @override
  MachineStopped<State, Event> get _value =>
      super._value as MachineStopped<State, Event>;

  @override
  $Res call({
    Object? lastState = freezed,
    Object? start = freezed,
  }) {
    return _then(MachineStopped<State, Event>(
      lastState: lastState == freezed
          ? _value.lastState
          : lastState // ignore: cast_nullable_to_non_nullable
              as State,
      start: start == freezed
          ? _value.start
          : start // ignore: cast_nullable_to_non_nullable
              as void Function({State? state}),
    ));
  }
}

/// @nodoc

class _$MachineStopped<State, Event> implements MachineStopped<State, Event> {
  _$MachineStopped({required this.lastState, required this.start});

  @override

  /// the last State the StateMachine was in.
  final State lastState;
  @override

  /// Start the StateMachine. This will allow to send events.
  /// It will also enter the initial state.
  final void Function({State? state}) start;

  @override
  String toString() {
    return 'StateMachineStatus<$State, $Event>.stopped(lastState: $lastState, start: $start)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is MachineStopped<State, Event> &&
            (identical(other.lastState, lastState) ||
                const DeepCollectionEquality()
                    .equals(other.lastState, lastState)) &&
            (identical(other.start, start) ||
                const DeepCollectionEquality().equals(other.start, start)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(lastState) ^
      const DeepCollectionEquality().hash(start);

  @JsonKey(ignore: true)
  @override
  $MachineStoppedCopyWith<State, Event, MachineStopped<State, Event>>
      get copyWith => _$MachineStoppedCopyWithImpl<State, Event,
          MachineStopped<State, Event>>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(void Function({State? state}) start) notStarted,
    required TResult Function(
            State lastState, void Function({State? state}) start)
        stopped,
    required TResult Function(State state, void Function(Event) send,
            bool Function(Event) canSend, void Function() stop)
        running,
  }) {
    return stopped(lastState, start);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(void Function({State? state}) start)? notStarted,
    TResult Function(State lastState, void Function({State? state}) start)?
        stopped,
    TResult Function(State state, void Function(Event) send,
            bool Function(Event) canSend, void Function() stop)?
        running,
    required TResult orElse(),
  }) {
    if (stopped != null) {
      return stopped(lastState, start);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(MachineNotStarted<State, Event> value) notStarted,
    required TResult Function(MachineStopped<State, Event> value) stopped,
    required TResult Function(MachineRunning<State, Event> value) running,
  }) {
    return stopped(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(MachineNotStarted<State, Event> value)? notStarted,
    TResult Function(MachineStopped<State, Event> value)? stopped,
    TResult Function(MachineRunning<State, Event> value)? running,
    required TResult orElse(),
  }) {
    if (stopped != null) {
      return stopped(this);
    }
    return orElse();
  }
}

abstract class MachineStopped<State, Event>
    implements StateMachineStatus<State, Event> {
  factory MachineStopped(
          {required State lastState,
          required void Function({State? state}) start}) =
      _$MachineStopped<State, Event>;

  /// the last State the StateMachine was in.
  State get lastState => throw _privateConstructorUsedError;

  /// Start the StateMachine. This will allow to send events.
  /// It will also enter the initial state.
  void Function({State? state}) get start => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MachineStoppedCopyWith<State, Event, MachineStopped<State, Event>>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MachineRunningCopyWith<State, Event, $Res> {
  factory $MachineRunningCopyWith(MachineRunning<State, Event> value,
          $Res Function(MachineRunning<State, Event>) then) =
      _$MachineRunningCopyWithImpl<State, Event, $Res>;
  $Res call(
      {State state,
      void Function(Event) send,
      bool Function(Event) canSend,
      void Function() stop});
}

/// @nodoc
class _$MachineRunningCopyWithImpl<State, Event, $Res>
    extends _$StateMachineStatusCopyWithImpl<State, Event, $Res>
    implements $MachineRunningCopyWith<State, Event, $Res> {
  _$MachineRunningCopyWithImpl(MachineRunning<State, Event> _value,
      $Res Function(MachineRunning<State, Event>) _then)
      : super(_value, (v) => _then(v as MachineRunning<State, Event>));

  @override
  MachineRunning<State, Event> get _value =>
      super._value as MachineRunning<State, Event>;

  @override
  $Res call({
    Object? state = freezed,
    Object? send = freezed,
    Object? canSend = freezed,
    Object? stop = freezed,
  }) {
    return _then(MachineRunning<State, Event>(
      state: state == freezed
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as State,
      send: send == freezed
          ? _value.send
          : send // ignore: cast_nullable_to_non_nullable
              as void Function(Event),
      canSend: canSend == freezed
          ? _value.canSend
          : canSend // ignore: cast_nullable_to_non_nullable
              as bool Function(Event),
      stop: stop == freezed
          ? _value.stop
          : stop // ignore: cast_nullable_to_non_nullable
              as void Function(),
    ));
  }
}

/// @nodoc

class _$MachineRunning<State, Event> implements MachineRunning<State, Event> {
  _$MachineRunning(
      {required this.state,
      required this.send,
      required this.canSend,
      required this.stop});

  @override
  final State state;
  @override

  /// Send and event to the machine and trigger all event listeners that subscribe
  /// to the given event in the current active state.
  final void Function(Event) send;
  @override

  /// Check whether it is possible to send an event to the StateMachine.
  /// This will return false if machine is not running or the current active state
  /// has no event listener
  final bool Function(Event) canSend;
  @override

  /// Stop the [StateMachine]. It will no longer be possible to send events.
  /// It will also exit the current state.
  final void Function() stop;

  @override
  String toString() {
    return 'StateMachineStatus<$State, $Event>.running(state: $state, send: $send, canSend: $canSend, stop: $stop)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is MachineRunning<State, Event> &&
            (identical(other.state, state) ||
                const DeepCollectionEquality().equals(other.state, state)) &&
            (identical(other.send, send) ||
                const DeepCollectionEquality().equals(other.send, send)) &&
            (identical(other.canSend, canSend) ||
                const DeepCollectionEquality()
                    .equals(other.canSend, canSend)) &&
            (identical(other.stop, stop) ||
                const DeepCollectionEquality().equals(other.stop, stop)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(state) ^
      const DeepCollectionEquality().hash(send) ^
      const DeepCollectionEquality().hash(canSend) ^
      const DeepCollectionEquality().hash(stop);

  @JsonKey(ignore: true)
  @override
  $MachineRunningCopyWith<State, Event, MachineRunning<State, Event>>
      get copyWith => _$MachineRunningCopyWithImpl<State, Event,
          MachineRunning<State, Event>>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(void Function({State? state}) start) notStarted,
    required TResult Function(
            State lastState, void Function({State? state}) start)
        stopped,
    required TResult Function(State state, void Function(Event) send,
            bool Function(Event) canSend, void Function() stop)
        running,
  }) {
    return running(state, send, canSend, stop);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(void Function({State? state}) start)? notStarted,
    TResult Function(State lastState, void Function({State? state}) start)?
        stopped,
    TResult Function(State state, void Function(Event) send,
            bool Function(Event) canSend, void Function() stop)?
        running,
    required TResult orElse(),
  }) {
    if (running != null) {
      return running(state, send, canSend, stop);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(MachineNotStarted<State, Event> value) notStarted,
    required TResult Function(MachineStopped<State, Event> value) stopped,
    required TResult Function(MachineRunning<State, Event> value) running,
  }) {
    return running(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(MachineNotStarted<State, Event> value)? notStarted,
    TResult Function(MachineStopped<State, Event> value)? stopped,
    TResult Function(MachineRunning<State, Event> value)? running,
    required TResult orElse(),
  }) {
    if (running != null) {
      return running(this);
    }
    return orElse();
  }
}

abstract class MachineRunning<State, Event>
    implements StateMachineStatus<State, Event> {
  factory MachineRunning(
      {required State state,
      required void Function(Event) send,
      required bool Function(Event) canSend,
      required void Function() stop}) = _$MachineRunning<State, Event>;

  State get state => throw _privateConstructorUsedError;

  /// Send and event to the machine and trigger all event listeners that subscribe
  /// to the given event in the current active state.
  void Function(Event) get send => throw _privateConstructorUsedError;

  /// Check whether it is possible to send an event to the StateMachine.
  /// This will return false if machine is not running or the current active state
  /// has no event listener
  bool Function(Event) get canSend => throw _privateConstructorUsedError;

  /// Stop the [StateMachine]. It will no longer be possible to send events.
  /// It will also exit the current state.
  void Function() get stop => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MachineRunningCopyWith<State, Event, MachineRunning<State, Event>>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
class _$StateSelfTearOff {
  const _$StateSelfTearOff();

  _StateSelf<State, S, Event> call<State, S extends State, Event>(
      {required StateMachineStatus<State, Event> previousStatus,
      required S currentState,
      required void Function(State) transition,
      required void Function(void Function()) onExit,
      required void Function<E extends Event>(void Function(E)) onEvent,
      required bool Function(State) canTransition}) {
    return _StateSelf<State, S, Event>(
      previousStatus: previousStatus,
      currentState: currentState,
      transition: transition,
      onExit: onExit,
      onEvent: onEvent,
      canTransition: canTransition,
    );
  }
}

/// @nodoc
const $StateSelf = _$StateSelfTearOff();

/// @nodoc
mixin _$StateSelf<State, S extends State, Event> {
  /// [StateMachineStatus] that was active before the current.
  StateMachineStatus<State, Event> get previousStatus =>
      throw _privateConstructorUsedError;

  /// The state when entered
  S get currentState => throw _privateConstructorUsedError;

  /// Transition to another state. This can only be called once in the current state.
  /// Subsequent calls are ignored.
  void Function(State) get transition => throw _privateConstructorUsedError;

  /// Execute the callback given when leaving the state.
  /// Calls are immediately executed after state has been left.
  void Function(void Function()) get onExit =>
      throw _privateConstructorUsedError;

  /// Attach an event to the current active state. This way one may communicate with the
  /// StateMachine from outside.
  /// Usually this is where a [transition] should happen.
  void Function<E extends Event>(void Function(E)) get onEvent =>
      throw _privateConstructorUsedError;

  /// Check if it is possible to transition.
  bool Function(State) get canTransition => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $StateSelfCopyWith<State, S, Event, StateSelf<State, S, Event>>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StateSelfCopyWith<State, S extends State, Event, $Res> {
  factory $StateSelfCopyWith(StateSelf<State, S, Event> value,
          $Res Function(StateSelf<State, S, Event>) then) =
      _$StateSelfCopyWithImpl<State, S, Event, $Res>;
  $Res call(
      {StateMachineStatus<State, Event> previousStatus,
      S currentState,
      void Function(State) transition,
      void Function(void Function()) onExit,
      void Function<E extends Event>(void Function(E)) onEvent,
      bool Function(State) canTransition});

  $StateMachineStatusCopyWith<State, Event, $Res> get previousStatus;
}

/// @nodoc
class _$StateSelfCopyWithImpl<State, S extends State, Event, $Res>
    implements $StateSelfCopyWith<State, S, Event, $Res> {
  _$StateSelfCopyWithImpl(this._value, this._then);

  final StateSelf<State, S, Event> _value;
  // ignore: unused_field
  final $Res Function(StateSelf<State, S, Event>) _then;

  @override
  $Res call({
    Object? previousStatus = freezed,
    Object? currentState = freezed,
    Object? transition = freezed,
    Object? onExit = freezed,
    Object? onEvent = freezed,
    Object? canTransition = freezed,
  }) {
    return _then(_value.copyWith(
      previousStatus: previousStatus == freezed
          ? _value.previousStatus
          : previousStatus // ignore: cast_nullable_to_non_nullable
              as StateMachineStatus<State, Event>,
      currentState: currentState == freezed
          ? _value.currentState
          : currentState // ignore: cast_nullable_to_non_nullable
              as S,
      transition: transition == freezed
          ? _value.transition
          : transition // ignore: cast_nullable_to_non_nullable
              as void Function(State),
      onExit: onExit == freezed
          ? _value.onExit
          : onExit // ignore: cast_nullable_to_non_nullable
              as void Function(void Function()),
      onEvent: onEvent == freezed
          ? _value.onEvent
          : onEvent // ignore: cast_nullable_to_non_nullable
              as void Function<E extends Event>(void Function(E)),
      canTransition: canTransition == freezed
          ? _value.canTransition
          : canTransition // ignore: cast_nullable_to_non_nullable
              as bool Function(State),
    ));
  }

  @override
  $StateMachineStatusCopyWith<State, Event, $Res> get previousStatus {
    return $StateMachineStatusCopyWith<State, Event, $Res>(
        _value.previousStatus, (value) {
      return _then(_value.copyWith(previousStatus: value));
    });
  }
}

/// @nodoc
abstract class _$StateSelfCopyWith<State, S extends State, Event, $Res>
    implements $StateSelfCopyWith<State, S, Event, $Res> {
  factory _$StateSelfCopyWith(_StateSelf<State, S, Event> value,
          $Res Function(_StateSelf<State, S, Event>) then) =
      __$StateSelfCopyWithImpl<State, S, Event, $Res>;
  @override
  $Res call(
      {StateMachineStatus<State, Event> previousStatus,
      S currentState,
      void Function(State) transition,
      void Function(void Function()) onExit,
      void Function<E extends Event>(void Function(E)) onEvent,
      bool Function(State) canTransition});

  @override
  $StateMachineStatusCopyWith<State, Event, $Res> get previousStatus;
}

/// @nodoc
class __$StateSelfCopyWithImpl<State, S extends State, Event, $Res>
    extends _$StateSelfCopyWithImpl<State, S, Event, $Res>
    implements _$StateSelfCopyWith<State, S, Event, $Res> {
  __$StateSelfCopyWithImpl(_StateSelf<State, S, Event> _value,
      $Res Function(_StateSelf<State, S, Event>) _then)
      : super(_value, (v) => _then(v as _StateSelf<State, S, Event>));

  @override
  _StateSelf<State, S, Event> get _value =>
      super._value as _StateSelf<State, S, Event>;

  @override
  $Res call({
    Object? previousStatus = freezed,
    Object? currentState = freezed,
    Object? transition = freezed,
    Object? onExit = freezed,
    Object? onEvent = freezed,
    Object? canTransition = freezed,
  }) {
    return _then(_StateSelf<State, S, Event>(
      previousStatus: previousStatus == freezed
          ? _value.previousStatus
          : previousStatus // ignore: cast_nullable_to_non_nullable
              as StateMachineStatus<State, Event>,
      currentState: currentState == freezed
          ? _value.currentState
          : currentState // ignore: cast_nullable_to_non_nullable
              as S,
      transition: transition == freezed
          ? _value.transition
          : transition // ignore: cast_nullable_to_non_nullable
              as void Function(State),
      onExit: onExit == freezed
          ? _value.onExit
          : onExit // ignore: cast_nullable_to_non_nullable
              as void Function(void Function()),
      onEvent: onEvent == freezed
          ? _value.onEvent
          : onEvent // ignore: cast_nullable_to_non_nullable
              as void Function<E extends Event>(void Function(E)),
      canTransition: canTransition == freezed
          ? _value.canTransition
          : canTransition // ignore: cast_nullable_to_non_nullable
              as bool Function(State),
    ));
  }
}

/// @nodoc

class _$_StateSelf<State, S extends State, Event>
    implements _StateSelf<State, S, Event> {
  _$_StateSelf(
      {required this.previousStatus,
      required this.currentState,
      required this.transition,
      required this.onExit,
      required this.onEvent,
      required this.canTransition});

  @override

  /// [StateMachineStatus] that was active before the current.
  final StateMachineStatus<State, Event> previousStatus;
  @override

  /// The state when entered
  final S currentState;
  @override

  /// Transition to another state. This can only be called once in the current state.
  /// Subsequent calls are ignored.
  final void Function(State) transition;
  @override

  /// Execute the callback given when leaving the state.
  /// Calls are immediately executed after state has been left.
  final void Function(void Function()) onExit;
  @override

  /// Attach an event to the current active state. This way one may communicate with the
  /// StateMachine from outside.
  /// Usually this is where a [transition] should happen.
  final void Function<E extends Event>(void Function(E)) onEvent;
  @override

  /// Check if it is possible to transition.
  final bool Function(State) canTransition;

  @override
  String toString() {
    return 'StateSelf<$State, $S, $Event>(previousStatus: $previousStatus, currentState: $currentState, transition: $transition, onExit: $onExit, onEvent: $onEvent, canTransition: $canTransition)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _StateSelf<State, S, Event> &&
            (identical(other.previousStatus, previousStatus) ||
                const DeepCollectionEquality()
                    .equals(other.previousStatus, previousStatus)) &&
            (identical(other.currentState, currentState) ||
                const DeepCollectionEquality()
                    .equals(other.currentState, currentState)) &&
            (identical(other.transition, transition) ||
                const DeepCollectionEquality()
                    .equals(other.transition, transition)) &&
            (identical(other.onExit, onExit) ||
                const DeepCollectionEquality().equals(other.onExit, onExit)) &&
            (identical(other.onEvent, onEvent) ||
                const DeepCollectionEquality()
                    .equals(other.onEvent, onEvent)) &&
            (identical(other.canTransition, canTransition) ||
                const DeepCollectionEquality()
                    .equals(other.canTransition, canTransition)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(previousStatus) ^
      const DeepCollectionEquality().hash(currentState) ^
      const DeepCollectionEquality().hash(transition) ^
      const DeepCollectionEquality().hash(onExit) ^
      const DeepCollectionEquality().hash(onEvent) ^
      const DeepCollectionEquality().hash(canTransition);

  @JsonKey(ignore: true)
  @override
  _$StateSelfCopyWith<State, S, Event, _StateSelf<State, S, Event>>
      get copyWith => __$StateSelfCopyWithImpl<State, S, Event,
          _StateSelf<State, S, Event>>(this, _$identity);
}

abstract class _StateSelf<State, S extends State, Event>
    implements StateSelf<State, S, Event> {
  factory _StateSelf(
          {required StateMachineStatus<State, Event> previousStatus,
          required S currentState,
          required void Function(State) transition,
          required void Function(void Function()) onExit,
          required void Function<E extends Event>(void Function(E)) onEvent,
          required bool Function(State) canTransition}) =
      _$_StateSelf<State, S, Event>;

  @override

  /// [StateMachineStatus] that was active before the current.
  StateMachineStatus<State, Event> get previousStatus =>
      throw _privateConstructorUsedError;
  @override

  /// The state when entered
  S get currentState => throw _privateConstructorUsedError;
  @override

  /// Transition to another state. This can only be called once in the current state.
  /// Subsequent calls are ignored.
  void Function(State) get transition => throw _privateConstructorUsedError;
  @override

  /// Execute the callback given when leaving the state.
  /// Calls are immediately executed after state has been left.
  void Function(void Function()) get onExit =>
      throw _privateConstructorUsedError;
  @override

  /// Attach an event to the current active state. This way one may communicate with the
  /// StateMachine from outside.
  /// Usually this is where a [transition] should happen.
  void Function<E extends Event>(void Function(E)) get onEvent =>
      throw _privateConstructorUsedError;
  @override

  /// Check if it is possible to transition.
  bool Function(State) get canTransition => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$StateSelfCopyWith<State, S, Event, _StateSelf<State, S, Event>>
      get copyWith => throw _privateConstructorUsedError;
}
