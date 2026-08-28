// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'focus_preset.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FocusPreset {

 String get id; int get minutes;
/// Create a copy of FocusPreset
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FocusPresetCopyWith<FocusPreset> get copyWith => _$FocusPresetCopyWithImpl<FocusPreset>(this as FocusPreset, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FocusPreset&&(identical(other.id, id) || other.id == id)&&(identical(other.minutes, minutes) || other.minutes == minutes));
}


@override
int get hashCode => Object.hash(runtimeType,id,minutes);

@override
String toString() {
  return 'FocusPreset(id: $id, minutes: $minutes)';
}


}

/// @nodoc
abstract mixin class $FocusPresetCopyWith<$Res>  {
  factory $FocusPresetCopyWith(FocusPreset value, $Res Function(FocusPreset) _then) = _$FocusPresetCopyWithImpl;
@useResult
$Res call({
 String id, int minutes
});




}
/// @nodoc
class _$FocusPresetCopyWithImpl<$Res>
    implements $FocusPresetCopyWith<$Res> {
  _$FocusPresetCopyWithImpl(this._self, this._then);

  final FocusPreset _self;
  final $Res Function(FocusPreset) _then;

/// Create a copy of FocusPreset
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? minutes = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,minutes: null == minutes ? _self.minutes : minutes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [FocusPreset].
extension FocusPresetPatterns on FocusPreset {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FocusPreset value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FocusPreset() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FocusPreset value)  $default,){
final _that = this;
switch (_that) {
case _FocusPreset():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FocusPreset value)?  $default,){
final _that = this;
switch (_that) {
case _FocusPreset() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  int minutes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FocusPreset() when $default != null:
return $default(_that.id,_that.minutes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  int minutes)  $default,) {final _that = this;
switch (_that) {
case _FocusPreset():
return $default(_that.id,_that.minutes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  int minutes)?  $default,) {final _that = this;
switch (_that) {
case _FocusPreset() when $default != null:
return $default(_that.id,_that.minutes);case _:
  return null;

}
}

}

/// @nodoc


class _FocusPreset extends FocusPreset {
  const _FocusPreset({required this.id, required this.minutes}): super._();
  

@override final  String id;
@override final  int minutes;

/// Create a copy of FocusPreset
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FocusPresetCopyWith<_FocusPreset> get copyWith => __$FocusPresetCopyWithImpl<_FocusPreset>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FocusPreset&&(identical(other.id, id) || other.id == id)&&(identical(other.minutes, minutes) || other.minutes == minutes));
}


@override
int get hashCode => Object.hash(runtimeType,id,minutes);

@override
String toString() {
  return 'FocusPreset(id: $id, minutes: $minutes)';
}


}

/// @nodoc
abstract mixin class _$FocusPresetCopyWith<$Res> implements $FocusPresetCopyWith<$Res> {
  factory _$FocusPresetCopyWith(_FocusPreset value, $Res Function(_FocusPreset) _then) = __$FocusPresetCopyWithImpl;
@override @useResult
$Res call({
 String id, int minutes
});




}
/// @nodoc
class __$FocusPresetCopyWithImpl<$Res>
    implements _$FocusPresetCopyWith<$Res> {
  __$FocusPresetCopyWithImpl(this._self, this._then);

  final _FocusPreset _self;
  final $Res Function(_FocusPreset) _then;

/// Create a copy of FocusPreset
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? minutes = null,}) {
  return _then(_FocusPreset(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,minutes: null == minutes ? _self.minutes : minutes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
