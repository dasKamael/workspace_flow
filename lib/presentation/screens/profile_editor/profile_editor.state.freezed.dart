// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profile_editor.state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ProfileEditorState {

 String get name; List<BlockedItem> get items; int? get profileId; bool get isLoaded;/// Deleting is blocked while only one profile exists.
 bool get canDelete;
/// Create a copy of ProfileEditorState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProfileEditorStateCopyWith<ProfileEditorState> get copyWith => _$ProfileEditorStateCopyWithImpl<ProfileEditorState>(this as ProfileEditorState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProfileEditorState&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.profileId, profileId) || other.profileId == profileId)&&(identical(other.isLoaded, isLoaded) || other.isLoaded == isLoaded)&&(identical(other.canDelete, canDelete) || other.canDelete == canDelete));
}


@override
int get hashCode => Object.hash(runtimeType,name,const DeepCollectionEquality().hash(items),profileId,isLoaded,canDelete);

@override
String toString() {
  return 'ProfileEditorState(name: $name, items: $items, profileId: $profileId, isLoaded: $isLoaded, canDelete: $canDelete)';
}


}

/// @nodoc
abstract mixin class $ProfileEditorStateCopyWith<$Res>  {
  factory $ProfileEditorStateCopyWith(ProfileEditorState value, $Res Function(ProfileEditorState) _then) = _$ProfileEditorStateCopyWithImpl;
@useResult
$Res call({
 String name, List<BlockedItem> items, int? profileId, bool isLoaded, bool canDelete
});




}
/// @nodoc
class _$ProfileEditorStateCopyWithImpl<$Res>
    implements $ProfileEditorStateCopyWith<$Res> {
  _$ProfileEditorStateCopyWithImpl(this._self, this._then);

  final ProfileEditorState _self;
  final $Res Function(ProfileEditorState) _then;

/// Create a copy of ProfileEditorState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? items = null,Object? profileId = freezed,Object? isLoaded = null,Object? canDelete = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<BlockedItem>,profileId: freezed == profileId ? _self.profileId : profileId // ignore: cast_nullable_to_non_nullable
as int?,isLoaded: null == isLoaded ? _self.isLoaded : isLoaded // ignore: cast_nullable_to_non_nullable
as bool,canDelete: null == canDelete ? _self.canDelete : canDelete // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ProfileEditorState].
extension ProfileEditorStatePatterns on ProfileEditorState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProfileEditorState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProfileEditorState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProfileEditorState value)  $default,){
final _that = this;
switch (_that) {
case _ProfileEditorState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProfileEditorState value)?  $default,){
final _that = this;
switch (_that) {
case _ProfileEditorState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  List<BlockedItem> items,  int? profileId,  bool isLoaded,  bool canDelete)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProfileEditorState() when $default != null:
return $default(_that.name,_that.items,_that.profileId,_that.isLoaded,_that.canDelete);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  List<BlockedItem> items,  int? profileId,  bool isLoaded,  bool canDelete)  $default,) {final _that = this;
switch (_that) {
case _ProfileEditorState():
return $default(_that.name,_that.items,_that.profileId,_that.isLoaded,_that.canDelete);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  List<BlockedItem> items,  int? profileId,  bool isLoaded,  bool canDelete)?  $default,) {final _that = this;
switch (_that) {
case _ProfileEditorState() when $default != null:
return $default(_that.name,_that.items,_that.profileId,_that.isLoaded,_that.canDelete);case _:
  return null;

}
}

}

/// @nodoc


class _ProfileEditorState extends ProfileEditorState {
  const _ProfileEditorState({this.name = '', final  List<BlockedItem> items = const [], this.profileId, this.isLoaded = false, this.canDelete = false}): _items = items,super._();
  

@override@JsonKey() final  String name;
 final  List<BlockedItem> _items;
@override@JsonKey() List<BlockedItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override final  int? profileId;
@override@JsonKey() final  bool isLoaded;
/// Deleting is blocked while only one profile exists.
@override@JsonKey() final  bool canDelete;

/// Create a copy of ProfileEditorState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProfileEditorStateCopyWith<_ProfileEditorState> get copyWith => __$ProfileEditorStateCopyWithImpl<_ProfileEditorState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProfileEditorState&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.profileId, profileId) || other.profileId == profileId)&&(identical(other.isLoaded, isLoaded) || other.isLoaded == isLoaded)&&(identical(other.canDelete, canDelete) || other.canDelete == canDelete));
}


@override
int get hashCode => Object.hash(runtimeType,name,const DeepCollectionEquality().hash(_items),profileId,isLoaded,canDelete);

@override
String toString() {
  return 'ProfileEditorState(name: $name, items: $items, profileId: $profileId, isLoaded: $isLoaded, canDelete: $canDelete)';
}


}

/// @nodoc
abstract mixin class _$ProfileEditorStateCopyWith<$Res> implements $ProfileEditorStateCopyWith<$Res> {
  factory _$ProfileEditorStateCopyWith(_ProfileEditorState value, $Res Function(_ProfileEditorState) _then) = __$ProfileEditorStateCopyWithImpl;
@override @useResult
$Res call({
 String name, List<BlockedItem> items, int? profileId, bool isLoaded, bool canDelete
});




}
/// @nodoc
class __$ProfileEditorStateCopyWithImpl<$Res>
    implements _$ProfileEditorStateCopyWith<$Res> {
  __$ProfileEditorStateCopyWithImpl(this._self, this._then);

  final _ProfileEditorState _self;
  final $Res Function(_ProfileEditorState) _then;

/// Create a copy of ProfileEditorState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? items = null,Object? profileId = freezed,Object? isLoaded = null,Object? canDelete = null,}) {
  return _then(_ProfileEditorState(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<BlockedItem>,profileId: freezed == profileId ? _self.profileId : profileId // ignore: cast_nullable_to_non_nullable
as int?,isLoaded: null == isLoaded ? _self.isLoaded : isLoaded // ignore: cast_nullable_to_non_nullable
as bool,canDelete: null == canDelete ? _self.canDelete : canDelete // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
