// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'blocked_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BlockedItem {

 int get id; String get name; BlockedItemKind get kind; bool get enabled;
/// Create a copy of BlockedItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BlockedItemCopyWith<BlockedItem> get copyWith => _$BlockedItemCopyWithImpl<BlockedItem>(this as BlockedItem, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BlockedItem&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.enabled, enabled) || other.enabled == enabled));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,kind,enabled);

@override
String toString() {
  return 'BlockedItem(id: $id, name: $name, kind: $kind, enabled: $enabled)';
}


}

/// @nodoc
abstract mixin class $BlockedItemCopyWith<$Res>  {
  factory $BlockedItemCopyWith(BlockedItem value, $Res Function(BlockedItem) _then) = _$BlockedItemCopyWithImpl;
@useResult
$Res call({
 int id, String name, BlockedItemKind kind, bool enabled
});




}
/// @nodoc
class _$BlockedItemCopyWithImpl<$Res>
    implements $BlockedItemCopyWith<$Res> {
  _$BlockedItemCopyWithImpl(this._self, this._then);

  final BlockedItem _self;
  final $Res Function(BlockedItem) _then;

/// Create a copy of BlockedItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? kind = null,Object? enabled = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as BlockedItemKind,enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [BlockedItem].
extension BlockedItemPatterns on BlockedItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BlockedItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BlockedItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BlockedItem value)  $default,){
final _that = this;
switch (_that) {
case _BlockedItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BlockedItem value)?  $default,){
final _that = this;
switch (_that) {
case _BlockedItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  BlockedItemKind kind,  bool enabled)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BlockedItem() when $default != null:
return $default(_that.id,_that.name,_that.kind,_that.enabled);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  BlockedItemKind kind,  bool enabled)  $default,) {final _that = this;
switch (_that) {
case _BlockedItem():
return $default(_that.id,_that.name,_that.kind,_that.enabled);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  BlockedItemKind kind,  bool enabled)?  $default,) {final _that = this;
switch (_that) {
case _BlockedItem() when $default != null:
return $default(_that.id,_that.name,_that.kind,_that.enabled);case _:
  return null;

}
}

}

/// @nodoc


class _BlockedItem implements BlockedItem {
  const _BlockedItem({required this.id, required this.name, required this.kind, this.enabled = true});
  

@override final  int id;
@override final  String name;
@override final  BlockedItemKind kind;
@override@JsonKey() final  bool enabled;

/// Create a copy of BlockedItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BlockedItemCopyWith<_BlockedItem> get copyWith => __$BlockedItemCopyWithImpl<_BlockedItem>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BlockedItem&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.enabled, enabled) || other.enabled == enabled));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,kind,enabled);

@override
String toString() {
  return 'BlockedItem(id: $id, name: $name, kind: $kind, enabled: $enabled)';
}


}

/// @nodoc
abstract mixin class _$BlockedItemCopyWith<$Res> implements $BlockedItemCopyWith<$Res> {
  factory _$BlockedItemCopyWith(_BlockedItem value, $Res Function(_BlockedItem) _then) = __$BlockedItemCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, BlockedItemKind kind, bool enabled
});




}
/// @nodoc
class __$BlockedItemCopyWithImpl<$Res>
    implements _$BlockedItemCopyWith<$Res> {
  __$BlockedItemCopyWithImpl(this._self, this._then);

  final _BlockedItem _self;
  final $Res Function(_BlockedItem) _then;

/// Create a copy of BlockedItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? kind = null,Object? enabled = null,}) {
  return _then(_BlockedItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as BlockedItemKind,enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
