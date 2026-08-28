// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'captured_window.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CapturedWindow {

 String get name; String get bundleId; double get x; double get y; double get width; double get height;
/// Create a copy of CapturedWindow
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CapturedWindowCopyWith<CapturedWindow> get copyWith => _$CapturedWindowCopyWithImpl<CapturedWindow>(this as CapturedWindow, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CapturedWindow&&(identical(other.name, name) || other.name == name)&&(identical(other.bundleId, bundleId) || other.bundleId == bundleId)&&(identical(other.x, x) || other.x == x)&&(identical(other.y, y) || other.y == y)&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height));
}


@override
int get hashCode => Object.hash(runtimeType,name,bundleId,x,y,width,height);

@override
String toString() {
  return 'CapturedWindow(name: $name, bundleId: $bundleId, x: $x, y: $y, width: $width, height: $height)';
}


}

/// @nodoc
abstract mixin class $CapturedWindowCopyWith<$Res>  {
  factory $CapturedWindowCopyWith(CapturedWindow value, $Res Function(CapturedWindow) _then) = _$CapturedWindowCopyWithImpl;
@useResult
$Res call({
 String name, String bundleId, double x, double y, double width, double height
});




}
/// @nodoc
class _$CapturedWindowCopyWithImpl<$Res>
    implements $CapturedWindowCopyWith<$Res> {
  _$CapturedWindowCopyWithImpl(this._self, this._then);

  final CapturedWindow _self;
  final $Res Function(CapturedWindow) _then;

/// Create a copy of CapturedWindow
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? bundleId = null,Object? x = null,Object? y = null,Object? width = null,Object? height = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,bundleId: null == bundleId ? _self.bundleId : bundleId // ignore: cast_nullable_to_non_nullable
as String,x: null == x ? _self.x : x // ignore: cast_nullable_to_non_nullable
as double,y: null == y ? _self.y : y // ignore: cast_nullable_to_non_nullable
as double,width: null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as double,height: null == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [CapturedWindow].
extension CapturedWindowPatterns on CapturedWindow {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CapturedWindow value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CapturedWindow() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CapturedWindow value)  $default,){
final _that = this;
switch (_that) {
case _CapturedWindow():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CapturedWindow value)?  $default,){
final _that = this;
switch (_that) {
case _CapturedWindow() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String bundleId,  double x,  double y,  double width,  double height)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CapturedWindow() when $default != null:
return $default(_that.name,_that.bundleId,_that.x,_that.y,_that.width,_that.height);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String bundleId,  double x,  double y,  double width,  double height)  $default,) {final _that = this;
switch (_that) {
case _CapturedWindow():
return $default(_that.name,_that.bundleId,_that.x,_that.y,_that.width,_that.height);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String bundleId,  double x,  double y,  double width,  double height)?  $default,) {final _that = this;
switch (_that) {
case _CapturedWindow() when $default != null:
return $default(_that.name,_that.bundleId,_that.x,_that.y,_that.width,_that.height);case _:
  return null;

}
}

}

/// @nodoc


class _CapturedWindow implements CapturedWindow {
  const _CapturedWindow({required this.name, required this.bundleId, required this.x, required this.y, required this.width, required this.height});
  

@override final  String name;
@override final  String bundleId;
@override final  double x;
@override final  double y;
@override final  double width;
@override final  double height;

/// Create a copy of CapturedWindow
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CapturedWindowCopyWith<_CapturedWindow> get copyWith => __$CapturedWindowCopyWithImpl<_CapturedWindow>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CapturedWindow&&(identical(other.name, name) || other.name == name)&&(identical(other.bundleId, bundleId) || other.bundleId == bundleId)&&(identical(other.x, x) || other.x == x)&&(identical(other.y, y) || other.y == y)&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height));
}


@override
int get hashCode => Object.hash(runtimeType,name,bundleId,x,y,width,height);

@override
String toString() {
  return 'CapturedWindow(name: $name, bundleId: $bundleId, x: $x, y: $y, width: $width, height: $height)';
}


}

/// @nodoc
abstract mixin class _$CapturedWindowCopyWith<$Res> implements $CapturedWindowCopyWith<$Res> {
  factory _$CapturedWindowCopyWith(_CapturedWindow value, $Res Function(_CapturedWindow) _then) = __$CapturedWindowCopyWithImpl;
@override @useResult
$Res call({
 String name, String bundleId, double x, double y, double width, double height
});




}
/// @nodoc
class __$CapturedWindowCopyWithImpl<$Res>
    implements _$CapturedWindowCopyWith<$Res> {
  __$CapturedWindowCopyWithImpl(this._self, this._then);

  final _CapturedWindow _self;
  final $Res Function(_CapturedWindow) _then;

/// Create a copy of CapturedWindow
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? bundleId = null,Object? x = null,Object? y = null,Object? width = null,Object? height = null,}) {
  return _then(_CapturedWindow(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,bundleId: null == bundleId ? _self.bundleId : bundleId // ignore: cast_nullable_to_non_nullable
as String,x: null == x ? _self.x : x // ignore: cast_nullable_to_non_nullable
as double,y: null == y ? _self.y : y // ignore: cast_nullable_to_non_nullable
as double,width: null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as double,height: null == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
