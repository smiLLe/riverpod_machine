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

  _NotStarted<State, Event> notStarted<State, Event>() {
    return _NotStarted<State, Event>();
  }

  _Stopped<State, Event> stopped<State, Event>({required State lastState}) {
    return _Stopped<State, Event>(
      lastState: lastState,
    );
  }

  _Running<State, Event> running<State, Event>({required State state}) {
    return _Running<State, Event>(
      state: state,
    );
  }
}

/// @nodoc
const $StateMachineStatus = _$StateMachineStatusTearOff();

/// @nodoc
mixin _$StateMachineStatus<State, Event> {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() notStarted,
    required TResult Function(State lastState) stopped,
    required TResult Function(State state) running,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? notStarted,
    TResult Function(State lastState)? stopped,
    TResult Function(State state)? running,
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
}

/// @nodoc

class _$_NotStarted<State, Event> implements _NotStarted<State, Event> {
  _$_NotStarted();

  @override
  String toString() {
    return 'StateMachineStatus<$State, $Event>.notStarted()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) || (other is _NotStarted<State, Event>);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() notStarted,
    required TResult Function(State lastState) stopped,
    required TResult Function(State state) running,
  }) {
    return notStarted();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? notStarted,
    TResult Function(State lastState)? stopped,
    TResult Function(State state)? running,
    required TResult orElse(),
  }) {
    if (notStarted != null) {
      return notStarted();
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
  factory _NotStarted() = _$_NotStarted<State, Event>;
}

/// @nodoc
abstract class _$StoppedCopyWith<State, Event, $Res> {
  factory _$StoppedCopyWith(_Stopped<State, Event> value,
          $Res Function(_Stopped<State, Event>) then) =
      __$StoppedCopyWithImpl<State, Event, $Res>;
  $Res call({State lastState});
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
  }) {
    return _then(_Stopped<State, Event>(
      lastState: lastState == freezed
          ? _value.lastState
          : lastState // ignore: cast_nullable_to_non_nullable
              as State,
    ));
  }
}

/// @nodoc

class _$_Stopped<State, Event> implements _Stopped<State, Event> {
  _$_Stopped({required this.lastState});

  @override
  final State lastState;

  @override
  String toString() {
    return 'StateMachineStatus<$State, $Event>.stopped(lastState: $lastState)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _Stopped<State, Event> &&
            (identical(other.lastState, lastState) ||
                const DeepCollectionEquality()
                    .equals(other.lastState, lastState)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(lastState);

  @JsonKey(ignore: true)
  @override
  _$StoppedCopyWith<State, Event, _Stopped<State, Event>> get copyWith =>
      __$StoppedCopyWithImpl<State, Event, _Stopped<State, Event>>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() notStarted,
    required TResult Function(State lastState) stopped,
    required TResult Function(State state) running,
  }) {
    return stopped(lastState);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? notStarted,
    TResult Function(State lastState)? stopped,
    TResult Function(State state)? running,
    required TResult orElse(),
  }) {
    if (stopped != null) {
      return stopped(lastState);
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
  factory _Stopped({required State lastState}) = _$_Stopped<State, Event>;

  State get lastState => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  _$StoppedCopyWith<State, Event, _Stopped<State, Event>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$RunningCopyWith<State, Event, $Res> {
  factory _$RunningCopyWith(_Running<State, Event> value,
          $Res Function(_Running<State, Event>) then) =
      __$RunningCopyWithImpl<State, Event, $Res>;
  $Res call({State state});
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
  }) {
    return _then(_Running<State, Event>(
      state: state == freezed
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as State,
    ));
  }
}

/// @nodoc

class _$_Running<State, Event> implements _Running<State, Event> {
  _$_Running({required this.state});

  @override
  final State state;

  @override
  String toString() {
    return 'StateMachineStatus<$State, $Event>.running(state: $state)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _Running<State, Event> &&
            (identical(other.state, state) ||
                const DeepCollectionEquality().equals(other.state, state)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(state);

  @JsonKey(ignore: true)
  @override
  _$RunningCopyWith<State, Event, _Running<State, Event>> get copyWith =>
      __$RunningCopyWithImpl<State, Event, _Running<State, Event>>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() notStarted,
    required TResult Function(State lastState) stopped,
    required TResult Function(State state) running,
  }) {
    return running(state);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? notStarted,
    TResult Function(State lastState)? stopped,
    TResult Function(State state)? running,
    required TResult orElse(),
  }) {
    if (running != null) {
      return running(state);
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
  factory _Running({required State state}) = _$_Running<State, Event>;

  State get state => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  _$RunningCopyWith<State, Event, _Running<State, Event>> get copyWith =>
      throw _privateConstructorUsedError;
}
