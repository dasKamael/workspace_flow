// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'window_snap.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$WindowSnap {

 double get x; double get y; double get width; double get height; List<double> get guidesX; List<double> get guidesY;
/// Create a copy of WindowSnap
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WindowSnapCopyWith<WindowSnap> get copyWith => _$WindowSnapCopyWithImpl<WindowSnap>(this as WindowSnap, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WindowSnap&&(identical(other.x, x) || other.x == x)&&(identical(other.y, y) || other.y == y)&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height)&&const DeepCollectionEquality().equals(other.guidesX, guidesX)&&const DeepCollectionEquality().equals(other.guidesY, guidesY));
}


@override
int get hashCode => Object.hash(runtimeType,x,y,width,height,const DeepCollectionEquality().hash(guidesX),const DeepCollectionEquality().hash(guidesY));

@override
String toString() {
  return 'WindowSnap(x: $x, y: $y, width: $width, height: $height, guidesX: $guidesX, guidesY: $guidesY)';
}


}

/// @nodoc
abstract mixin class $WindowSnapCopyWith<$Res>  {
  factory $WindowSnapCopyWith(WindowSnap value, $Res Function(WindowSnap) _then) = _$WindowSnapCopyWithImpl;
@useResult
$Res call({
 double x, double y, double width, double height, List<double> guidesX, List<double> guidesY
});




}
/// @nodoc
class _$WindowSnapCopyWithImpl<$Res>
    implements $WindowSnapCopyWith<$Res> {
  _$WindowSnapCopyWithImpl(this._self, this._then);

  final WindowSnap _self;
  final $Res Function(WindowSnap) _then;

/// Create a copy of WindowSnap
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? x = null,Object? y = null,Object? width = null,Object? height = null,Object? guidesX = null,Object? guidesY = null,}) {
  return _then(_self.copyWith(
x: null == x ? _self.x : x // ignore: cast_nullable_to_non_nullable
as double,y: null == y ? _self.y : y // ignore: cast_nullable_to_non_nullable
as double,width: null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as double,height: null == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as double,guidesX: null == guidesX ? _self.guidesX : guidesX // ignore: cast_nullable_to_non_nullable
as List<double>,guidesY: null == guidesY ? _self.guidesY : guidesY // ignore: cast_nullable_to_non_nullable
as List<double>,
  ));
}

}


/// Adds pattern-matching-related methods to [WindowSnap].
extension WindowSnapPatterns on WindowSnap {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WindowSnap value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WindowSnap() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WindowSnap value)  $default,){
final _that = this;
switch (_that) {
case _WindowSnap():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WindowSnap value)?  $default,){
final _that = this;
switch (_that) {
case _WindowSnap() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double x,  double y,  double width,  double height,  List<double> guidesX,  List<double> guidesY)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WindowSnap() when $default != null:
return $default(_that.x,_that.y,_that.width,_that.height,_that.guidesX,_that.guidesY);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double x,  double y,  double width,  double height,  List<double> guidesX,  List<double> guidesY)  $default,) {final _that = this;
switch (_that) {
case _WindowSnap():
return $default(_that.x,_that.y,_that.width,_that.height,_that.guidesX,_that.guidesY);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double x,  double y,  double width,  double height,  List<double> guidesX,  List<double> guidesY)?  $default,) {final _that = this;
switch (_that) {
case _WindowSnap() when $default != null:
return $default(_that.x,_that.y,_that.width,_that.height,_that.guidesX,_that.guidesY);case _:
  return null;

}
}

}

/// @nodoc


class _WindowSnap extends WindowSnap {
  const _WindowSnap({required this.x, required this.y, required this.width, required this.height, final  List<double> guidesX = const [], final  List<double> guidesY = const []}): _guidesX = guidesX,_guidesY = guidesY,super._();
  

@override final  double x;
@override final  double y;
@override final  double width;
@override final  double height;
 final  List<double> _guidesX;
@override@JsonKey() List<double> get guidesX {
  if (_guidesX is EqualUnmodifiableListView) return _guidesX;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_guidesX);
}

 final  List<double> _guidesY;
@override@JsonKey() List<double> get guidesY {
  if (_guidesY is EqualUnmodifiableListView) return _guidesY;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_guidesY);
}


/// Create a copy of WindowSnap
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WindowSnapCopyWith<_WindowSnap> get copyWith => __$WindowSnapCopyWithImpl<_WindowSnap>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WindowSnap&&(identical(other.x, x) || other.x == x)&&(identical(other.y, y) || other.y == y)&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height)&&const DeepCollectionEquality().equals(other._guidesX, _guidesX)&&const DeepCollectionEquality().equals(other._guidesY, _guidesY));
}


@override
int get hashCode => Object.hash(runtimeType,x,y,width,height,const DeepCollectionEquality().hash(_guidesX),const DeepCollectionEquality().hash(_guidesY));

@override
String toString() {
  return 'WindowSnap(x: $x, y: $y, width: $width, height: $height, guidesX: $guidesX, guidesY: $guidesY)';
}


}

/// @nodoc
abstract mixin class _$WindowSnapCopyWith<$Res> implements $WindowSnapCopyWith<$Res> {
  factory _$WindowSnapCopyWith(_WindowSnap value, $Res Function(_WindowSnap) _then) = __$WindowSnapCopyWithImpl;
@override @useResult
$Res call({
 double x, double y, double width, double height, List<double> guidesX, List<double> guidesY
});




}
/// @nodoc
class __$WindowSnapCopyWithImpl<$Res>
    implements _$WindowSnapCopyWith<$Res> {
  __$WindowSnapCopyWithImpl(this._self, this._then);

  final _WindowSnap _self;
  final $Res Function(_WindowSnap) _then;

/// Create a copy of WindowSnap
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? x = null,Object? y = null,Object? width = null,Object? height = null,Object? guidesX = null,Object? guidesY = null,}) {
  return _then(_WindowSnap(
x: null == x ? _self.x : x // ignore: cast_nullable_to_non_nullable
as double,y: null == y ? _self.y : y // ignore: cast_nullable_to_non_nullable
as double,width: null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as double,height: null == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as double,guidesX: null == guidesX ? _self._guidesX : guidesX // ignore: cast_nullable_to_non_nullable
as List<double>,guidesY: null == guidesY ? _self._guidesY : guidesY // ignore: cast_nullable_to_non_nullable
as List<double>,
  ));
}


}

// dart format on
