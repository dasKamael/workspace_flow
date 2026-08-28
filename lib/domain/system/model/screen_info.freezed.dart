// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'screen_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ScreenInfo {

 int get index; double get visibleX; double get visibleY; double get visibleWidth; double get visibleHeight; bool get isMain; double? get diagonalInches;
/// Create a copy of ScreenInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScreenInfoCopyWith<ScreenInfo> get copyWith => _$ScreenInfoCopyWithImpl<ScreenInfo>(this as ScreenInfo, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScreenInfo&&(identical(other.index, index) || other.index == index)&&(identical(other.visibleX, visibleX) || other.visibleX == visibleX)&&(identical(other.visibleY, visibleY) || other.visibleY == visibleY)&&(identical(other.visibleWidth, visibleWidth) || other.visibleWidth == visibleWidth)&&(identical(other.visibleHeight, visibleHeight) || other.visibleHeight == visibleHeight)&&(identical(other.isMain, isMain) || other.isMain == isMain)&&(identical(other.diagonalInches, diagonalInches) || other.diagonalInches == diagonalInches));
}


@override
int get hashCode => Object.hash(runtimeType,index,visibleX,visibleY,visibleWidth,visibleHeight,isMain,diagonalInches);

@override
String toString() {
  return 'ScreenInfo(index: $index, visibleX: $visibleX, visibleY: $visibleY, visibleWidth: $visibleWidth, visibleHeight: $visibleHeight, isMain: $isMain, diagonalInches: $diagonalInches)';
}


}

/// @nodoc
abstract mixin class $ScreenInfoCopyWith<$Res>  {
  factory $ScreenInfoCopyWith(ScreenInfo value, $Res Function(ScreenInfo) _then) = _$ScreenInfoCopyWithImpl;
@useResult
$Res call({
 int index, double visibleX, double visibleY, double visibleWidth, double visibleHeight, bool isMain, double? diagonalInches
});




}
/// @nodoc
class _$ScreenInfoCopyWithImpl<$Res>
    implements $ScreenInfoCopyWith<$Res> {
  _$ScreenInfoCopyWithImpl(this._self, this._then);

  final ScreenInfo _self;
  final $Res Function(ScreenInfo) _then;

/// Create a copy of ScreenInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? index = null,Object? visibleX = null,Object? visibleY = null,Object? visibleWidth = null,Object? visibleHeight = null,Object? isMain = null,Object? diagonalInches = freezed,}) {
  return _then(_self.copyWith(
index: null == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int,visibleX: null == visibleX ? _self.visibleX : visibleX // ignore: cast_nullable_to_non_nullable
as double,visibleY: null == visibleY ? _self.visibleY : visibleY // ignore: cast_nullable_to_non_nullable
as double,visibleWidth: null == visibleWidth ? _self.visibleWidth : visibleWidth // ignore: cast_nullable_to_non_nullable
as double,visibleHeight: null == visibleHeight ? _self.visibleHeight : visibleHeight // ignore: cast_nullable_to_non_nullable
as double,isMain: null == isMain ? _self.isMain : isMain // ignore: cast_nullable_to_non_nullable
as bool,diagonalInches: freezed == diagonalInches ? _self.diagonalInches : diagonalInches // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [ScreenInfo].
extension ScreenInfoPatterns on ScreenInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ScreenInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ScreenInfo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ScreenInfo value)  $default,){
final _that = this;
switch (_that) {
case _ScreenInfo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ScreenInfo value)?  $default,){
final _that = this;
switch (_that) {
case _ScreenInfo() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int index,  double visibleX,  double visibleY,  double visibleWidth,  double visibleHeight,  bool isMain,  double? diagonalInches)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ScreenInfo() when $default != null:
return $default(_that.index,_that.visibleX,_that.visibleY,_that.visibleWidth,_that.visibleHeight,_that.isMain,_that.diagonalInches);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int index,  double visibleX,  double visibleY,  double visibleWidth,  double visibleHeight,  bool isMain,  double? diagonalInches)  $default,) {final _that = this;
switch (_that) {
case _ScreenInfo():
return $default(_that.index,_that.visibleX,_that.visibleY,_that.visibleWidth,_that.visibleHeight,_that.isMain,_that.diagonalInches);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int index,  double visibleX,  double visibleY,  double visibleWidth,  double visibleHeight,  bool isMain,  double? diagonalInches)?  $default,) {final _that = this;
switch (_that) {
case _ScreenInfo() when $default != null:
return $default(_that.index,_that.visibleX,_that.visibleY,_that.visibleWidth,_that.visibleHeight,_that.isMain,_that.diagonalInches);case _:
  return null;

}
}

}

/// @nodoc


class _ScreenInfo extends ScreenInfo {
  const _ScreenInfo({required this.index, required this.visibleX, required this.visibleY, required this.visibleWidth, required this.visibleHeight, required this.isMain, this.diagonalInches}): super._();
  

@override final  int index;
@override final  double visibleX;
@override final  double visibleY;
@override final  double visibleWidth;
@override final  double visibleHeight;
@override final  bool isMain;
@override final  double? diagonalInches;

/// Create a copy of ScreenInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ScreenInfoCopyWith<_ScreenInfo> get copyWith => __$ScreenInfoCopyWithImpl<_ScreenInfo>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ScreenInfo&&(identical(other.index, index) || other.index == index)&&(identical(other.visibleX, visibleX) || other.visibleX == visibleX)&&(identical(other.visibleY, visibleY) || other.visibleY == visibleY)&&(identical(other.visibleWidth, visibleWidth) || other.visibleWidth == visibleWidth)&&(identical(other.visibleHeight, visibleHeight) || other.visibleHeight == visibleHeight)&&(identical(other.isMain, isMain) || other.isMain == isMain)&&(identical(other.diagonalInches, diagonalInches) || other.diagonalInches == diagonalInches));
}


@override
int get hashCode => Object.hash(runtimeType,index,visibleX,visibleY,visibleWidth,visibleHeight,isMain,diagonalInches);

@override
String toString() {
  return 'ScreenInfo(index: $index, visibleX: $visibleX, visibleY: $visibleY, visibleWidth: $visibleWidth, visibleHeight: $visibleHeight, isMain: $isMain, diagonalInches: $diagonalInches)';
}


}

/// @nodoc
abstract mixin class _$ScreenInfoCopyWith<$Res> implements $ScreenInfoCopyWith<$Res> {
  factory _$ScreenInfoCopyWith(_ScreenInfo value, $Res Function(_ScreenInfo) _then) = __$ScreenInfoCopyWithImpl;
@override @useResult
$Res call({
 int index, double visibleX, double visibleY, double visibleWidth, double visibleHeight, bool isMain, double? diagonalInches
});




}
/// @nodoc
class __$ScreenInfoCopyWithImpl<$Res>
    implements _$ScreenInfoCopyWith<$Res> {
  __$ScreenInfoCopyWithImpl(this._self, this._then);

  final _ScreenInfo _self;
  final $Res Function(_ScreenInfo) _then;

/// Create a copy of ScreenInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? index = null,Object? visibleX = null,Object? visibleY = null,Object? visibleWidth = null,Object? visibleHeight = null,Object? isMain = null,Object? diagonalInches = freezed,}) {
  return _then(_ScreenInfo(
index: null == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int,visibleX: null == visibleX ? _self.visibleX : visibleX // ignore: cast_nullable_to_non_nullable
as double,visibleY: null == visibleY ? _self.visibleY : visibleY // ignore: cast_nullable_to_non_nullable
as double,visibleWidth: null == visibleWidth ? _self.visibleWidth : visibleWidth // ignore: cast_nullable_to_non_nullable
as double,visibleHeight: null == visibleHeight ? _self.visibleHeight : visibleHeight // ignore: cast_nullable_to_non_nullable
as double,isMain: null == isMain ? _self.isMain : isMain // ignore: cast_nullable_to_non_nullable
as bool,diagonalInches: freezed == diagonalInches ? _self.diagonalInches : diagonalInches // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}

// dart format on
