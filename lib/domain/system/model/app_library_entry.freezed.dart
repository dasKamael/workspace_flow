// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_library_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AppLibraryEntry {

 String get name; String? get bundleId; String? get path; String? get url;
/// Create a copy of AppLibraryEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppLibraryEntryCopyWith<AppLibraryEntry> get copyWith => _$AppLibraryEntryCopyWithImpl<AppLibraryEntry>(this as AppLibraryEntry, _$identity);

  /// Serializes this AppLibraryEntry to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppLibraryEntry&&(identical(other.name, name) || other.name == name)&&(identical(other.bundleId, bundleId) || other.bundleId == bundleId)&&(identical(other.path, path) || other.path == path)&&(identical(other.url, url) || other.url == url));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,bundleId,path,url);

@override
String toString() {
  return 'AppLibraryEntry(name: $name, bundleId: $bundleId, path: $path, url: $url)';
}


}

/// @nodoc
abstract mixin class $AppLibraryEntryCopyWith<$Res>  {
  factory $AppLibraryEntryCopyWith(AppLibraryEntry value, $Res Function(AppLibraryEntry) _then) = _$AppLibraryEntryCopyWithImpl;
@useResult
$Res call({
 String name, String? bundleId, String? path, String? url
});




}
/// @nodoc
class _$AppLibraryEntryCopyWithImpl<$Res>
    implements $AppLibraryEntryCopyWith<$Res> {
  _$AppLibraryEntryCopyWithImpl(this._self, this._then);

  final AppLibraryEntry _self;
  final $Res Function(AppLibraryEntry) _then;

/// Create a copy of AppLibraryEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? bundleId = freezed,Object? path = freezed,Object? url = freezed,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,bundleId: freezed == bundleId ? _self.bundleId : bundleId // ignore: cast_nullable_to_non_nullable
as String?,path: freezed == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String?,url: freezed == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AppLibraryEntry].
extension AppLibraryEntryPatterns on AppLibraryEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppLibraryEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppLibraryEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppLibraryEntry value)  $default,){
final _that = this;
switch (_that) {
case _AppLibraryEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppLibraryEntry value)?  $default,){
final _that = this;
switch (_that) {
case _AppLibraryEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String? bundleId,  String? path,  String? url)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppLibraryEntry() when $default != null:
return $default(_that.name,_that.bundleId,_that.path,_that.url);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String? bundleId,  String? path,  String? url)  $default,) {final _that = this;
switch (_that) {
case _AppLibraryEntry():
return $default(_that.name,_that.bundleId,_that.path,_that.url);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String? bundleId,  String? path,  String? url)?  $default,) {final _that = this;
switch (_that) {
case _AppLibraryEntry() when $default != null:
return $default(_that.name,_that.bundleId,_that.path,_that.url);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AppLibraryEntry extends AppLibraryEntry {
  const _AppLibraryEntry({required this.name, this.bundleId, this.path, this.url}): super._();
  factory _AppLibraryEntry.fromJson(Map<String, dynamic> json) => _$AppLibraryEntryFromJson(json);

@override final  String name;
@override final  String? bundleId;
@override final  String? path;
@override final  String? url;

/// Create a copy of AppLibraryEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppLibraryEntryCopyWith<_AppLibraryEntry> get copyWith => __$AppLibraryEntryCopyWithImpl<_AppLibraryEntry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AppLibraryEntryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppLibraryEntry&&(identical(other.name, name) || other.name == name)&&(identical(other.bundleId, bundleId) || other.bundleId == bundleId)&&(identical(other.path, path) || other.path == path)&&(identical(other.url, url) || other.url == url));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,bundleId,path,url);

@override
String toString() {
  return 'AppLibraryEntry(name: $name, bundleId: $bundleId, path: $path, url: $url)';
}


}

/// @nodoc
abstract mixin class _$AppLibraryEntryCopyWith<$Res> implements $AppLibraryEntryCopyWith<$Res> {
  factory _$AppLibraryEntryCopyWith(_AppLibraryEntry value, $Res Function(_AppLibraryEntry) _then) = __$AppLibraryEntryCopyWithImpl;
@override @useResult
$Res call({
 String name, String? bundleId, String? path, String? url
});




}
/// @nodoc
class __$AppLibraryEntryCopyWithImpl<$Res>
    implements _$AppLibraryEntryCopyWith<$Res> {
  __$AppLibraryEntryCopyWithImpl(this._self, this._then);

  final _AppLibraryEntry _self;
  final $Res Function(_AppLibraryEntry) _then;

/// Create a copy of AppLibraryEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? bundleId = freezed,Object? path = freezed,Object? url = freezed,}) {
  return _then(_AppLibraryEntry(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,bundleId: freezed == bundleId ? _self.bundleId : bundleId // ignore: cast_nullable_to_non_nullable
as String?,path: freezed == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String?,url: freezed == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
