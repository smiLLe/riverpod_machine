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
      {required void Function() start}) {
    return MachineNotStarted<State, Event>(
      start: start,
    );
  }

  MachineStopped<State, Event> stopped<State, Event>(
      {required State lastState, required void Function() start}) {
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
    required TResult Function(void Function() start) notStarted,
    required TResult Function(State lastState, void Function() start) stopped,
    required TResult Function(State state, void Function(Event) send,
            bool Function(Event) canSend, void Function() stop)
        running,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(void Function() start)? notStarted,
    TResult Function(State lastState, void Function() start)? stopped,
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
  $Res call({void Function() start});
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
              as void Function(),
    ));
  }
}

/// @nodoc

class _$MachineNotStarted<State, Event>
    implements MachineNotStarted<State, Event> {
  _$MachineNotStarted({required this.start});

  @override
  final void Function() start;

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
    required TResult Function(void Function() start) notStarted,
    required TResult Function(State lastState, void Function() start) stopped,
    required TResult Function(State state, void Function(Event) send,
            bool Function(Event) canSend, void Function() stop)
        running,
  }) {
    return notStarted(start);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(void Function() start)? notStarted,
    TResult Function(State lastState, void Function() start)? stopped,
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
  factory MachineNotStarted({required void Function() start}) =
      _$MachineNotStarted<State, Event>;

  void Function() get start => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MachineNotStartedCopyWith<State, Event, MachineNotStarted<State, Event>>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MachineStoppedCopyWith<State, Event, $Res> {
  factory $MachineStoppedCopyWith(MachineStopped<State, Event> value,
          $Res Function(MachineStopped<State, Event>) then) =
      _$MachineStoppedCopyWithImpl<State, Event, $Res>;
  $Res call({State lastState, void Function() start});
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
              as void Function(),
    ));
  }
}

/// @nodoc

class _$MachineStopped<State, Event> implements MachineStopped<State, Event> {
  _$MachineStopped({required this.lastState, required this.start});

  @override
  final State lastState;
  @override
  final void Function() start;

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
    required TResult Function(void Function() start) notStarted,
    required TResult Function(State lastState, void Function() start) stopped,
    required TResult Function(State state, void Function(Event) send,
            bool Function(Event) canSend, void Function() stop)
        running,
  }) {
    return stopped(lastState, start);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(void Function() start)? notStarted,
    TResult Function(State lastState, void Function() start)? stopped,
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
      required void Function() start}) = _$MachineStopped<State, Event>;

  State get lastState => throw _privateConstructorUsedError;
  void Function() get start => throw _privateConstructorUsedError;
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
  final void Function(Event) send;
  @override
  final bool Function(Event) canSend;
  @override
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
    required TResult Function(void Function() start) notStarted,
    required TResult Function(State lastState, void Function() start) stopped,
    required TResult Function(State state, void Function(Event) send,
            bool Function(Event) canSend, void Function() stop)
        running,
  }) {
    return running(state, send, canSend, stop);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(void Function() start)? notStarted,
    TResult Function(State lastState, void Function() start)? stopped,
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
  void Function(Event) get send => throw _privateConstructorUsedError;
  bool Function(Event) get canSend => throw _privateConstructorUsedError;
  void Function() get stop => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MachineRunningCopyWith<State, Event, MachineRunning<State, Event>>
      get copyWith => throw _privateConstructorUsedError;
}
