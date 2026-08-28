// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'project_window.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ProjectWindow {

 int get id; String get name; int get screenIndex; double get x; double get y; double get width; double get height; String? get bundleId; String? get url; int get sortOrder;
/// Create a copy of ProjectWindow
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProjectWindowCopyWith<ProjectWindow> get copyWith => _$ProjectWindowCopyWithImpl<ProjectWindow>(this as ProjectWindow, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProjectWindow&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.screenIndex, screenIndex) || other.screenIndex == screenIndex)&&(identical(other.x, x) || other.x == x)&&(identical(other.y, y) || other.y == y)&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height)&&(identical(other.bundleId, bundleId) || other.bundleId == bundleId)&&(identical(other.url, url) || other.url == url)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,screenIndex,x,y,width,height,bundleId,url,sortOrder);

@override
String toString() {
  return 'ProjectWindow(id: $id, name: $name, screenIndex: $screenIndex, x: $x, y: $y, width: $width, height: $height, bundleId: $bundleId, url: $url, sortOrder: $sortOrder)';
}


}

/// @nodoc
abstract mixin class $ProjectWindowCopyWith<$Res>  {
  factory $ProjectWindowCopyWith(ProjectWindow value, $Res Function(ProjectWindow) _then) = _$ProjectWindowCopyWithImpl;
@useResult
$Res call({
 int id, String name, int screenIndex, double x, double y, double width, double height, String? bundleId, String? url, int sortOrder
});




}
/// @nodoc
class _$ProjectWindowCopyWithImpl<$Res>
    implements $ProjectWindowCopyWith<$Res> {
  _$ProjectWindowCopyWithImpl(this._self, this._then);

  final ProjectWindow _self;
  final $Res Function(ProjectWindow) _then;

/// Create a copy of ProjectWindow
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? screenIndex = null,Object? x = null,Object? y = null,Object? width = null,Object? height = null,Object? bundleId = freezed,Object? url = freezed,Object? sortOrder = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,screenIndex: null == screenIndex ? _self.screenIndex : screenIndex // ignore: cast_nullable_to_non_nullable
as int,x: null == x ? _self.x : x // ignore: cast_nullable_to_non_nullable
as double,y: null == y ? _self.y : y // ignore: cast_nullable_to_non_nullable
as double,width: null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as double,height: null == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as double,bundleId: freezed == bundleId ? _self.bundleId : bundleId // ignore: cast_nullable_to_non_nullable
as String?,url: freezed == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String?,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ProjectWindow].
extension ProjectWindowPatterns on ProjectWindow {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProjectWindow value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProjectWindow() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProjectWindow value)  $default,){
final _that = this;
switch (_that) {
case _ProjectWindow():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProjectWindow value)?  $default,){
final _that = this;
switch (_that) {
case _ProjectWindow() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  int screenIndex,  double x,  double y,  double width,  double height,  String? bundleId,  String? url,  int sortOrder)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProjectWindow() when $default != null:
return $default(_that.id,_that.name,_that.screenIndex,_that.x,_that.y,_that.width,_that.height,_that.bundleId,_that.url,_that.sortOrder);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  int screenIndex,  double x,  double y,  double width,  double height,  String? bundleId,  String? url,  int sortOrder)  $default,) {final _that = this;
switch (_that) {
case _ProjectWindow():
return $default(_that.id,_that.name,_that.screenIndex,_that.x,_that.y,_that.width,_that.height,_that.bundleId,_that.url,_that.sortOrder);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  int screenIndex,  double x,  double y,  double width,  double height,  String? bundleId,  String? url,  int sortOrder)?  $default,) {final _that = this;
switch (_that) {
case _ProjectWindow() when $default != null:
return $default(_that.id,_that.name,_that.screenIndex,_that.x,_that.y,_that.width,_that.height,_that.bundleId,_that.url,_that.sortOrder);case _:
  return null;

}
}

}

/// @nodoc


class _ProjectWindow extends ProjectWindow {
  const _ProjectWindow({required this.id, required this.name, required this.screenIndex, required this.x, required this.y, required this.width, required this.height, this.bundleId, this.url, this.sortOrder = 0}): super._();
  

@override final  int id;
@override final  String name;
@override final  int screenIndex;
@override final  double x;
@override final  double y;
@override final  double width;
@override final  double height;
@override final  String? bundleId;
@override final  String? url;
@override@JsonKey() final  int sortOrder;

/// Create a copy of ProjectWindow
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProjectWindowCopyWith<_ProjectWindow> get copyWith => __$ProjectWindowCopyWithImpl<_ProjectWindow>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProjectWindow&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.screenIndex, screenIndex) || other.screenIndex == screenIndex)&&(identical(other.x, x) || other.x == x)&&(identical(other.y, y) || other.y == y)&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height)&&(identical(other.bundleId, bundleId) || other.bundleId == bundleId)&&(identical(other.url, url) || other.url == url)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,screenIndex,x,y,width,height,bundleId,url,sortOrder);

@override
String toString() {
  return 'ProjectWindow(id: $id, name: $name, screenIndex: $screenIndex, x: $x, y: $y, width: $width, height: $height, bundleId: $bundleId, url: $url, sortOrder: $sortOrder)';
}


}

/// @nodoc
abstract mixin class _$ProjectWindowCopyWith<$Res> implements $ProjectWindowCopyWith<$Res> {
  factory _$ProjectWindowCopyWith(_ProjectWindow value, $Res Function(_ProjectWindow) _then) = __$ProjectWindowCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, int screenIndex, double x, double y, double width, double height, String? bundleId, String? url, int sortOrder
});




}
/// @nodoc
class __$ProjectWindowCopyWithImpl<$Res>
    implements _$ProjectWindowCopyWith<$Res> {
  __$ProjectWindowCopyWithImpl(this._self, this._then);

  final _ProjectWindow _self;
  final $Res Function(_ProjectWindow) _then;

/// Create a copy of ProjectWindow
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? screenIndex = null,Object? x = null,Object? y = null,Object? width = null,Object? height = null,Object? bundleId = freezed,Object? url = freezed,Object? sortOrder = null,}) {
  return _then(_ProjectWindow(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,screenIndex: null == screenIndex ? _self.screenIndex : screenIndex // ignore: cast_nullable_to_non_nullable
as int,x: null == x ? _self.x : x // ignore: cast_nullable_to_non_nullable
as double,y: null == y ? _self.y : y // ignore: cast_nullable_to_non_nullable
as double,width: null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as double,height: null == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as double,bundleId: freezed == bundleId ? _self.bundleId : bundleId // ignore: cast_nullable_to_non_nullable
as String?,url: freezed == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String?,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
