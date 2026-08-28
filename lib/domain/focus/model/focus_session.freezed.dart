// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'focus_session.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FocusSession {

 int get minutes; int get secondsLeft; int get elapsed; bool get isRunning;/// Row id of the session currently being recorded, if any.
 int? get recordId;
/// Create a copy of FocusSession
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FocusSessionCopyWith<FocusSession> get copyWith => _$FocusSessionCopyWithImpl<FocusSession>(this as FocusSession, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FocusSession&&(identical(other.minutes, minutes) || other.minutes == minutes)&&(identical(other.secondsLeft, secondsLeft) || other.secondsLeft == secondsLeft)&&(identical(other.elapsed, elapsed) || other.elapsed == elapsed)&&(identical(other.isRunning, isRunning) || other.isRunning == isRunning)&&(identical(other.recordId, recordId) || other.recordId == recordId));
}


@override
int get hashCode => Object.hash(runtimeType,minutes,secondsLeft,elapsed,isRunning,recordId);

@override
String toString() {
  return 'FocusSession(minutes: $minutes, secondsLeft: $secondsLeft, elapsed: $elapsed, isRunning: $isRunning, recordId: $recordId)';
}


}

/// @nodoc
abstract mixin class $FocusSessionCopyWith<$Res>  {
  factory $FocusSessionCopyWith(FocusSession value, $Res Function(FocusSession) _then) = _$FocusSessionCopyWithImpl;
@useResult
$Res call({
 int minutes, int secondsLeft, int elapsed, bool isRunning, int? recordId
});




}
/// @nodoc
class _$FocusSessionCopyWithImpl<$Res>
    implements $FocusSessionCopyWith<$Res> {
  _$FocusSessionCopyWithImpl(this._self, this._then);

  final FocusSession _self;
  final $Res Function(FocusSession) _then;

/// Create a copy of FocusSession
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? minutes = null,Object? secondsLeft = null,Object? elapsed = null,Object? isRunning = null,Object? recordId = freezed,}) {
  return _then(_self.copyWith(
minutes: null == minutes ? _self.minutes : minutes // ignore: cast_nullable_to_non_nullable
as int,secondsLeft: null == secondsLeft ? _self.secondsLeft : secondsLeft // ignore: cast_nullable_to_non_nullable
as int,elapsed: null == elapsed ? _self.elapsed : elapsed // ignore: cast_nullable_to_non_nullable
as int,isRunning: null == isRunning ? _self.isRunning : isRunning // ignore: cast_nullable_to_non_nullable
as bool,recordId: freezed == recordId ? _self.recordId : recordId // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [FocusSession].
extension FocusSessionPatterns on FocusSession {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FocusSession value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FocusSession() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FocusSession value)  $default,){
final _that = this;
switch (_that) {
case _FocusSession():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FocusSession value)?  $default,){
final _that = this;
switch (_that) {
case _FocusSession() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int minutes,  int secondsLeft,  int elapsed,  bool isRunning,  int? recordId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FocusSession() when $default != null:
return $default(_that.minutes,_that.secondsLeft,_that.elapsed,_that.isRunning,_that.recordId);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int minutes,  int secondsLeft,  int elapsed,  bool isRunning,  int? recordId)  $default,) {final _that = this;
switch (_that) {
case _FocusSession():
return $default(_that.minutes,_that.secondsLeft,_that.elapsed,_that.isRunning,_that.recordId);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int minutes,  int secondsLeft,  int elapsed,  bool isRunning,  int? recordId)?  $default,) {final _that = this;
switch (_that) {
case _FocusSession() when $default != null:
return $default(_that.minutes,_that.secondsLeft,_that.elapsed,_that.isRunning,_that.recordId);case _:
  return null;

}
}

}

/// @nodoc


class _FocusSession extends FocusSession {
  const _FocusSession({this.minutes = kFocusDefaultMinutes, this.secondsLeft = kFocusDefaultMinutes * 60, this.elapsed = 0, this.isRunning = false, this.recordId}): super._();
  

@override@JsonKey() final  int minutes;
@override@JsonKey() final  int secondsLeft;
@override@JsonKey() final  int elapsed;
@override@JsonKey() final  bool isRunning;
/// Row id of the session currently being recorded, if any.
@override final  int? recordId;

/// Create a copy of FocusSession
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FocusSessionCopyWith<_FocusSession> get copyWith => __$FocusSessionCopyWithImpl<_FocusSession>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FocusSession&&(identical(other.minutes, minutes) || other.minutes == minutes)&&(identical(other.secondsLeft, secondsLeft) || other.secondsLeft == secondsLeft)&&(identical(other.elapsed, elapsed) || other.elapsed == elapsed)&&(identical(other.isRunning, isRunning) || other.isRunning == isRunning)&&(identical(other.recordId, recordId) || other.recordId == recordId));
}


@override
int get hashCode => Object.hash(runtimeType,minutes,secondsLeft,elapsed,isRunning,recordId);

@override
String toString() {
  return 'FocusSession(minutes: $minutes, secondsLeft: $secondsLeft, elapsed: $elapsed, isRunning: $isRunning, recordId: $recordId)';
}


}

/// @nodoc
abstract mixin class _$FocusSessionCopyWith<$Res> implements $FocusSessionCopyWith<$Res> {
  factory _$FocusSessionCopyWith(_FocusSession value, $Res Function(_FocusSession) _then) = __$FocusSessionCopyWithImpl;
@override @useResult
$Res call({
 int minutes, int secondsLeft, int elapsed, bool isRunning, int? recordId
});




}
/// @nodoc
class __$FocusSessionCopyWithImpl<$Res>
    implements _$FocusSessionCopyWith<$Res> {
  __$FocusSessionCopyWithImpl(this._self, this._then);

  final _FocusSession _self;
  final $Res Function(_FocusSession) _then;

/// Create a copy of FocusSession
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? minutes = null,Object? secondsLeft = null,Object? elapsed = null,Object? isRunning = null,Object? recordId = freezed,}) {
  return _then(_FocusSession(
minutes: null == minutes ? _self.minutes : minutes // ignore: cast_nullable_to_non_nullable
as int,secondsLeft: null == secondsLeft ? _self.secondsLeft : secondsLeft // ignore: cast_nullable_to_non_nullable
as int,elapsed: null == elapsed ? _self.elapsed : elapsed // ignore: cast_nullable_to_non_nullable
as int,isRunning: null == isRunning ? _self.isRunning : isRunning // ignore: cast_nullable_to_non_nullable
as bool,recordId: freezed == recordId ? _self.recordId : recordId // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
