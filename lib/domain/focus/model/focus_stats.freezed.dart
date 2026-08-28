// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'focus_stats.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FocusStats {

 int get sessionsToday; int get blockedToday;
/// Create a copy of FocusStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FocusStatsCopyWith<FocusStats> get copyWith => _$FocusStatsCopyWithImpl<FocusStats>(this as FocusStats, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FocusStats&&(identical(other.sessionsToday, sessionsToday) || other.sessionsToday == sessionsToday)&&(identical(other.blockedToday, blockedToday) || other.blockedToday == blockedToday));
}


@override
int get hashCode => Object.hash(runtimeType,sessionsToday,blockedToday);

@override
String toString() {
  return 'FocusStats(sessionsToday: $sessionsToday, blockedToday: $blockedToday)';
}


}

/// @nodoc
abstract mixin class $FocusStatsCopyWith<$Res>  {
  factory $FocusStatsCopyWith(FocusStats value, $Res Function(FocusStats) _then) = _$FocusStatsCopyWithImpl;
@useResult
$Res call({
 int sessionsToday, int blockedToday
});




}
/// @nodoc
class _$FocusStatsCopyWithImpl<$Res>
    implements $FocusStatsCopyWith<$Res> {
  _$FocusStatsCopyWithImpl(this._self, this._then);

  final FocusStats _self;
  final $Res Function(FocusStats) _then;

/// Create a copy of FocusStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sessionsToday = null,Object? blockedToday = null,}) {
  return _then(_self.copyWith(
sessionsToday: null == sessionsToday ? _self.sessionsToday : sessionsToday // ignore: cast_nullable_to_non_nullable
as int,blockedToday: null == blockedToday ? _self.blockedToday : blockedToday // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [FocusStats].
extension FocusStatsPatterns on FocusStats {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FocusStats value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FocusStats() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FocusStats value)  $default,){
final _that = this;
switch (_that) {
case _FocusStats():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FocusStats value)?  $default,){
final _that = this;
switch (_that) {
case _FocusStats() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int sessionsToday,  int blockedToday)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FocusStats() when $default != null:
return $default(_that.sessionsToday,_that.blockedToday);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int sessionsToday,  int blockedToday)  $default,) {final _that = this;
switch (_that) {
case _FocusStats():
return $default(_that.sessionsToday,_that.blockedToday);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int sessionsToday,  int blockedToday)?  $default,) {final _that = this;
switch (_that) {
case _FocusStats() when $default != null:
return $default(_that.sessionsToday,_that.blockedToday);case _:
  return null;

}
}

}

/// @nodoc


class _FocusStats implements FocusStats {
  const _FocusStats({this.sessionsToday = 0, this.blockedToday = 0});
  

@override@JsonKey() final  int sessionsToday;
@override@JsonKey() final  int blockedToday;

/// Create a copy of FocusStats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FocusStatsCopyWith<_FocusStats> get copyWith => __$FocusStatsCopyWithImpl<_FocusStats>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FocusStats&&(identical(other.sessionsToday, sessionsToday) || other.sessionsToday == sessionsToday)&&(identical(other.blockedToday, blockedToday) || other.blockedToday == blockedToday));
}


@override
int get hashCode => Object.hash(runtimeType,sessionsToday,blockedToday);

@override
String toString() {
  return 'FocusStats(sessionsToday: $sessionsToday, blockedToday: $blockedToday)';
}


}

/// @nodoc
abstract mixin class _$FocusStatsCopyWith<$Res> implements $FocusStatsCopyWith<$Res> {
  factory _$FocusStatsCopyWith(_FocusStats value, $Res Function(_FocusStats) _then) = __$FocusStatsCopyWithImpl;
@override @useResult
$Res call({
 int sessionsToday, int blockedToday
});




}
/// @nodoc
class __$FocusStatsCopyWithImpl<$Res>
    implements _$FocusStatsCopyWith<$Res> {
  __$FocusStatsCopyWithImpl(this._self, this._then);

  final _FocusStats _self;
  final $Res Function(_FocusStats) _then;

/// Create a copy of FocusStats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sessionsToday = null,Object? blockedToday = null,}) {
  return _then(_FocusStats(
sessionsToday: null == sessionsToday ? _self.sessionsToday : sessionsToday // ignore: cast_nullable_to_non_nullable
as int,blockedToday: null == blockedToday ? _self.blockedToday : blockedToday // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
