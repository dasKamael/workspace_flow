// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'blocker_profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BlockerProfile {

 int get id; String get name; List<BlockedItem> get items; int get sortOrder;
/// Create a copy of BlockerProfile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BlockerProfileCopyWith<BlockerProfile> get copyWith => _$BlockerProfileCopyWithImpl<BlockerProfile>(this as BlockerProfile, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BlockerProfile&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,const DeepCollectionEquality().hash(items),sortOrder);

@override
String toString() {
  return 'BlockerProfile(id: $id, name: $name, items: $items, sortOrder: $sortOrder)';
}


}

/// @nodoc
abstract mixin class $BlockerProfileCopyWith<$Res>  {
  factory $BlockerProfileCopyWith(BlockerProfile value, $Res Function(BlockerProfile) _then) = _$BlockerProfileCopyWithImpl;
@useResult
$Res call({
 int id, String name, List<BlockedItem> items, int sortOrder
});




}
/// @nodoc
class _$BlockerProfileCopyWithImpl<$Res>
    implements $BlockerProfileCopyWith<$Res> {
  _$BlockerProfileCopyWithImpl(this._self, this._then);

  final BlockerProfile _self;
  final $Res Function(BlockerProfile) _then;

/// Create a copy of BlockerProfile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? items = null,Object? sortOrder = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<BlockedItem>,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [BlockerProfile].
extension BlockerProfilePatterns on BlockerProfile {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BlockerProfile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BlockerProfile() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BlockerProfile value)  $default,){
final _that = this;
switch (_that) {
case _BlockerProfile():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BlockerProfile value)?  $default,){
final _that = this;
switch (_that) {
case _BlockerProfile() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  List<BlockedItem> items,  int sortOrder)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BlockerProfile() when $default != null:
return $default(_that.id,_that.name,_that.items,_that.sortOrder);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  List<BlockedItem> items,  int sortOrder)  $default,) {final _that = this;
switch (_that) {
case _BlockerProfile():
return $default(_that.id,_that.name,_that.items,_that.sortOrder);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  List<BlockedItem> items,  int sortOrder)?  $default,) {final _that = this;
switch (_that) {
case _BlockerProfile() when $default != null:
return $default(_that.id,_that.name,_that.items,_that.sortOrder);case _:
  return null;

}
}

}

/// @nodoc


class _BlockerProfile extends BlockerProfile {
  const _BlockerProfile({required this.id, required this.name, required final  List<BlockedItem> items, this.sortOrder = 0}): _items = items,super._();
  

@override final  int id;
@override final  String name;
 final  List<BlockedItem> _items;
@override List<BlockedItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override@JsonKey() final  int sortOrder;

/// Create a copy of BlockerProfile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BlockerProfileCopyWith<_BlockerProfile> get copyWith => __$BlockerProfileCopyWithImpl<_BlockerProfile>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BlockerProfile&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,const DeepCollectionEquality().hash(_items),sortOrder);

@override
String toString() {
  return 'BlockerProfile(id: $id, name: $name, items: $items, sortOrder: $sortOrder)';
}


}

/// @nodoc
abstract mixin class _$BlockerProfileCopyWith<$Res> implements $BlockerProfileCopyWith<$Res> {
  factory _$BlockerProfileCopyWith(_BlockerProfile value, $Res Function(_BlockerProfile) _then) = __$BlockerProfileCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, List<BlockedItem> items, int sortOrder
});




}
/// @nodoc
class __$BlockerProfileCopyWithImpl<$Res>
    implements _$BlockerProfileCopyWith<$Res> {
  __$BlockerProfileCopyWithImpl(this._self, this._then);

  final _BlockerProfile _self;
  final $Res Function(_BlockerProfile) _then;

/// Create a copy of BlockerProfile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? items = null,Object? sortOrder = null,}) {
  return _then(_BlockerProfile(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<BlockedItem>,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
