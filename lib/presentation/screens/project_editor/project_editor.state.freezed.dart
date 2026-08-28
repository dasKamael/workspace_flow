// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'project_editor.state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ProjectEditorState {

 String get name; List<ProjectWindow> get windows;/// Null while creating a new project.
 int? get projectId; bool get isLoaded;
/// Create a copy of ProjectEditorState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProjectEditorStateCopyWith<ProjectEditorState> get copyWith => _$ProjectEditorStateCopyWithImpl<ProjectEditorState>(this as ProjectEditorState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProjectEditorState&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other.windows, windows)&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.isLoaded, isLoaded) || other.isLoaded == isLoaded));
}


@override
int get hashCode => Object.hash(runtimeType,name,const DeepCollectionEquality().hash(windows),projectId,isLoaded);

@override
String toString() {
  return 'ProjectEditorState(name: $name, windows: $windows, projectId: $projectId, isLoaded: $isLoaded)';
}


}

/// @nodoc
abstract mixin class $ProjectEditorStateCopyWith<$Res>  {
  factory $ProjectEditorStateCopyWith(ProjectEditorState value, $Res Function(ProjectEditorState) _then) = _$ProjectEditorStateCopyWithImpl;
@useResult
$Res call({
 String name, List<ProjectWindow> windows, int? projectId, bool isLoaded
});




}
/// @nodoc
class _$ProjectEditorStateCopyWithImpl<$Res>
    implements $ProjectEditorStateCopyWith<$Res> {
  _$ProjectEditorStateCopyWithImpl(this._self, this._then);

  final ProjectEditorState _self;
  final $Res Function(ProjectEditorState) _then;

/// Create a copy of ProjectEditorState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? windows = null,Object? projectId = freezed,Object? isLoaded = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,windows: null == windows ? _self.windows : windows // ignore: cast_nullable_to_non_nullable
as List<ProjectWindow>,projectId: freezed == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as int?,isLoaded: null == isLoaded ? _self.isLoaded : isLoaded // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ProjectEditorState].
extension ProjectEditorStatePatterns on ProjectEditorState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProjectEditorState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProjectEditorState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProjectEditorState value)  $default,){
final _that = this;
switch (_that) {
case _ProjectEditorState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProjectEditorState value)?  $default,){
final _that = this;
switch (_that) {
case _ProjectEditorState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  List<ProjectWindow> windows,  int? projectId,  bool isLoaded)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProjectEditorState() when $default != null:
return $default(_that.name,_that.windows,_that.projectId,_that.isLoaded);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  List<ProjectWindow> windows,  int? projectId,  bool isLoaded)  $default,) {final _that = this;
switch (_that) {
case _ProjectEditorState():
return $default(_that.name,_that.windows,_that.projectId,_that.isLoaded);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  List<ProjectWindow> windows,  int? projectId,  bool isLoaded)?  $default,) {final _that = this;
switch (_that) {
case _ProjectEditorState() when $default != null:
return $default(_that.name,_that.windows,_that.projectId,_that.isLoaded);case _:
  return null;

}
}

}

/// @nodoc


class _ProjectEditorState extends ProjectEditorState {
  const _ProjectEditorState({this.name = '', final  List<ProjectWindow> windows = const [], this.projectId, this.isLoaded = false}): _windows = windows,super._();
  

@override@JsonKey() final  String name;
 final  List<ProjectWindow> _windows;
@override@JsonKey() List<ProjectWindow> get windows {
  if (_windows is EqualUnmodifiableListView) return _windows;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_windows);
}

/// Null while creating a new project.
@override final  int? projectId;
@override@JsonKey() final  bool isLoaded;

/// Create a copy of ProjectEditorState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProjectEditorStateCopyWith<_ProjectEditorState> get copyWith => __$ProjectEditorStateCopyWithImpl<_ProjectEditorState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProjectEditorState&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other._windows, _windows)&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.isLoaded, isLoaded) || other.isLoaded == isLoaded));
}


@override
int get hashCode => Object.hash(runtimeType,name,const DeepCollectionEquality().hash(_windows),projectId,isLoaded);

@override
String toString() {
  return 'ProjectEditorState(name: $name, windows: $windows, projectId: $projectId, isLoaded: $isLoaded)';
}


}

/// @nodoc
abstract mixin class _$ProjectEditorStateCopyWith<$Res> implements $ProjectEditorStateCopyWith<$Res> {
  factory _$ProjectEditorStateCopyWith(_ProjectEditorState value, $Res Function(_ProjectEditorState) _then) = __$ProjectEditorStateCopyWithImpl;
@override @useResult
$Res call({
 String name, List<ProjectWindow> windows, int? projectId, bool isLoaded
});




}
/// @nodoc
class __$ProjectEditorStateCopyWithImpl<$Res>
    implements _$ProjectEditorStateCopyWith<$Res> {
  __$ProjectEditorStateCopyWithImpl(this._self, this._then);

  final _ProjectEditorState _self;
  final $Res Function(_ProjectEditorState) _then;

/// Create a copy of ProjectEditorState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? windows = null,Object? projectId = freezed,Object? isLoaded = null,}) {
  return _then(_ProjectEditorState(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,windows: null == windows ? _self._windows : windows // ignore: cast_nullable_to_non_nullable
as List<ProjectWindow>,projectId: freezed == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as int?,isLoaded: null == isLoaded ? _self.isLoaded : isLoaded // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
