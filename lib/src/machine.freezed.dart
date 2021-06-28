// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides

part of 'machine.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$StateMachineStatusTearOff {
  const _$StateMachineStatusTearOff();

  _NotStarted<State, Event> notStarted<State, Event>(
      {required void Function() start}) {
    return _NotStarted<State, Event>(
      start: start,
    );
  }

  _Stopped<State, Event> stopped<State, Event>(
      {required State lastState, required void Function() start}) {
    return _Stopped<State, Event>(
      lastState: lastState,
      start: start,
    );
  }

  _Running<State, Event> running<State, Event>(
      {required State state,
      required void Function(Event) send,
      required bool Function(Event) canSend,
      required void Function() stop}) {
    return _Running<State, Event>(
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
    required TResult Function(_NotStarted<State, Event> value) notStarted,
    required TResult Function(_Stopped<State, Event> value) stopped,
    required TResult Function(_Running<State, Event> value) running,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_NotStarted<State, Event> value)? notStarted,
    TResult Function(_Stopped<State, Event> value)? stopped,
    TResult Function(_Running<State, Event> value)? running,
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
abstract class _$NotStartedCopyWith<State, Event, $Res> {
  factory _$NotStartedCopyWith(_NotStarted<State, Event> value,
          $Res Function(_NotStarted<State, Event>) then) =
      __$NotStartedCopyWithImpl<State, Event, $Res>;
  $Res call({void Function() start});
}

/// @nodoc
class __$NotStartedCopyWithImpl<State, Event, $Res>
    extends _$StateMachineStatusCopyWithImpl<State, Event, $Res>
    implements _$NotStartedCopyWith<State, Event, $Res> {
  __$NotStartedCopyWithImpl(_NotStarted<State, Event> _value,
      $Res Function(_NotStarted<State, Event>) _then)
      : super(_value, (v) => _then(v as _NotStarted<State, Event>));

  @override
  _NotStarted<State, Event> get _value =>
      super._value as _NotStarted<State, Event>;

  @override
  $Res call({
    Object? start = freezed,
  }) {
    return _then(_NotStarted<State, Event>(
      start: start == freezed
          ? _value.start
          : start // ignore: cast_nullable_to_non_nullable
              as void Function(),
    ));
  }
}

/// @nodoc

class _$_NotStarted<State, Event> implements _NotStarted<State, Event> {
  _$_NotStarted({required this.start});

  @override
  final void Function() start;

  @override
  String toString() {
    return 'StateMachineStatus<$State, $Event>.notStarted(start: $start)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _NotStarted<State, Event> &&
            (identical(other.start, start) ||
                const DeepCollectionEquality().equals(other.start, start)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(start);

  @JsonKey(ignore: true)
  @override
  _$NotStartedCopyWith<State, Event, _NotStarted<State, Event>> get copyWith =>
      __$NotStartedCopyWithImpl<State, Event, _NotStarted<State, Event>>(
          this, _$identity);

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
    required TResult Function(_NotStarted<State, Event> value) notStarted,
    required TResult Function(_Stopped<State, Event> value) stopped,
    required TResult Function(_Running<State, Event> value) running,
  }) {
    return notStarted(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_NotStarted<State, Event> value)? notStarted,
    TResult Function(_Stopped<State, Event> value)? stopped,
    TResult Function(_Running<State, Event> value)? running,
    required TResult orElse(),
  }) {
    if (notStarted != null) {
      return notStarted(this);
    }
    return orElse();
  }
}

abstract class _NotStarted<State, Event>
    implements StateMachineStatus<State, Event> {
  factory _NotStarted({required void Function() start}) =
      _$_NotStarted<State, Event>;

  void Function() get start => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  _$NotStartedCopyWith<State, Event, _NotStarted<State, Event>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$StoppedCopyWith<State, Event, $Res> {
  factory _$StoppedCopyWith(_Stopped<State, Event> value,
          $Res Function(_Stopped<State, Event>) then) =
      __$StoppedCopyWithImpl<State, Event, $Res>;
  $Res call({State lastState, void Function() start});
}

/// @nodoc
class __$StoppedCopyWithImpl<State, Event, $Res>
    extends _$StateMachineStatusCopyWithImpl<State, Event, $Res>
    implements _$StoppedCopyWith<State, Event, $Res> {
  __$StoppedCopyWithImpl(_Stopped<State, Event> _value,
      $Res Function(_Stopped<State, Event>) _then)
      : super(_value, (v) => _then(v as _Stopped<State, Event>));

  @override
  _Stopped<State, Event> get _value => super._value as _Stopped<State, Event>;

  @override
  $Res call({
    Object? lastState = freezed,
    Object? start = freezed,
  }) {
    return _then(_Stopped<State, Event>(
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

class _$_Stopped<State, Event> implements _Stopped<State, Event> {
  _$_Stopped({required this.lastState, required this.start});

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
        (other is _Stopped<State, Event> &&
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
  _$StoppedCopyWith<State, Event, _Stopped<State, Event>> get copyWith =>
      __$StoppedCopyWithImpl<State, Event, _Stopped<State, Event>>(
          this, _$identity);

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
    required TResult Function(_NotStarted<State, Event> value) notStarted,
    required TResult Function(_Stopped<State, Event> value) stopped,
    required TResult Function(_Running<State, Event> value) running,
  }) {
    return stopped(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_NotStarted<State, Event> value)? notStarted,
    TResult Function(_Stopped<State, Event> value)? stopped,
    TResult Function(_Running<State, Event> value)? running,
    required TResult orElse(),
  }) {
    if (stopped != null) {
      return stopped(this);
    }
    return orElse();
  }
}

abstract class _Stopped<State, Event>
    implements StateMachineStatus<State, Event> {
  factory _Stopped({required State lastState, required void Function() start}) =
      _$_Stopped<State, Event>;

  State get lastState => throw _privateConstructorUsedError;
  void Function() get start => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  _$StoppedCopyWith<State, Event, _Stopped<State, Event>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$RunningCopyWith<State, Event, $Res> {
  factory _$RunningCopyWith(_Running<State, Event> value,
          $Res Function(_Running<State, Event>) then) =
      __$RunningCopyWithImpl<State, Event, $Res>;
  $Res call(
      {State state,
      void Function(Event) send,
      bool Function(Event) canSend,
      void Function() stop});
}

/// @nodoc
class __$RunningCopyWithImpl<State, Event, $Res>
    extends _$StateMachineStatusCopyWithImpl<State, Event, $Res>
    implements _$RunningCopyWith<State, Event, $Res> {
  __$RunningCopyWithImpl(_Running<State, Event> _value,
      $Res Function(_Running<State, Event>) _then)
      : super(_value, (v) => _then(v as _Running<State, Event>));

  @override
  _Running<State, Event> get _value => super._value as _Running<State, Event>;

  @override
  $Res call({
    Object? state = freezed,
    Object? send = freezed,
    Object? canSend = freezed,
    Object? stop = freezed,
  }) {
    return _then(_Running<State, Event>(
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

class _$_Running<State, Event> implements _Running<State, Event> {
  _$_Running(
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
        (other is _Running<State, Event> &&
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
  _$RunningCopyWith<State, Event, _Running<State, Event>> get copyWith =>
      __$RunningCopyWithImpl<State, Event, _Running<State, Event>>(
          this, _$identity);

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
    required TResult Function(_NotStarted<State, Event> value) notStarted,
    required TResult Function(_Stopped<State, Event> value) stopped,
    required TResult Function(_Running<State, Event> value) running,
  }) {
    return running(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_NotStarted<State, Event> value)? notStarted,
    TResult Function(_Stopped<State, Event> value)? stopped,
    TResult Function(_Running<State, Event> value)? running,
    required TResult orElse(),
  }) {
    if (running != null) {
      return running(this);
    }
    return orElse();
  }
}

abstract class _Running<State, Event>
    implements StateMachineStatus<State, Event> {
  factory _Running(
      {required State state,
      required void Function(Event) send,
      required bool Function(Event) canSend,
      required void Function() stop}) = _$_Running<State, Event>;

  State get state => throw _privateConstructorUsedError;
  void Function(Event) get send => throw _privateConstructorUsedError;
  bool Function(Event) get canSend => throw _privateConstructorUsedError;
  void Function() get stop => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  _$RunningCopyWith<State, Event, _Running<State, Event>> get copyWith =>
      throw _privateConstructorUsedError;
}
