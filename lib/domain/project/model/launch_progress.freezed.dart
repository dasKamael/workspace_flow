// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'launch_progress.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LaunchProgress {

 Map<int, LaunchStep> get steps; bool get isLaunching;/// True once every window has been dealt with — the button reads "Re-arrange".
 bool get hasLaunched;/// Set when the accessibility permission is missing.
 bool get needsAccessibilityPermission;
/// Create a copy of LaunchProgress
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LaunchProgressCopyWith<LaunchProgress> get copyWith => _$LaunchProgressCopyWithImpl<LaunchProgress>(this as LaunchProgress, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LaunchProgress&&const DeepCollectionEquality().equals(other.steps, steps)&&(identical(other.isLaunching, isLaunching) || other.isLaunching == isLaunching)&&(identical(other.hasLaunched, hasLaunched) || other.hasLaunched == hasLaunched)&&(identical(other.needsAccessibilityPermission, needsAccessibilityPermission) || other.needsAccessibilityPermission == needsAccessibilityPermission));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(steps),isLaunching,hasLaunched,needsAccessibilityPermission);

@override
String toString() {
  return 'LaunchProgress(steps: $steps, isLaunching: $isLaunching, hasLaunched: $hasLaunched, needsAccessibilityPermission: $needsAccessibilityPermission)';
}


}

/// @nodoc
abstract mixin class $LaunchProgressCopyWith<$Res>  {
  factory $LaunchProgressCopyWith(LaunchProgress value, $Res Function(LaunchProgress) _then) = _$LaunchProgressCopyWithImpl;
@useResult
$Res call({
 Map<int, LaunchStep> steps, bool isLaunching, bool hasLaunched, bool needsAccessibilityPermission
});




}
/// @nodoc
class _$LaunchProgressCopyWithImpl<$Res>
    implements $LaunchProgressCopyWith<$Res> {
  _$LaunchProgressCopyWithImpl(this._self, this._then);

  final LaunchProgress _self;
  final $Res Function(LaunchProgress) _then;

/// Create a copy of LaunchProgress
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? steps = null,Object? isLaunching = null,Object? hasLaunched = null,Object? needsAccessibilityPermission = null,}) {
  return _then(_self.copyWith(
steps: null == steps ? _self.steps : steps // ignore: cast_nullable_to_non_nullable
as Map<int, LaunchStep>,isLaunching: null == isLaunching ? _self.isLaunching : isLaunching // ignore: cast_nullable_to_non_nullable
as bool,hasLaunched: null == hasLaunched ? _self.hasLaunched : hasLaunched // ignore: cast_nullable_to_non_nullable
as bool,needsAccessibilityPermission: null == needsAccessibilityPermission ? _self.needsAccessibilityPermission : needsAccessibilityPermission // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [LaunchProgress].
extension LaunchProgressPatterns on LaunchProgress {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LaunchProgress value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LaunchProgress() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LaunchProgress value)  $default,){
final _that = this;
switch (_that) {
case _LaunchProgress():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LaunchProgress value)?  $default,){
final _that = this;
switch (_that) {
case _LaunchProgress() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Map<int, LaunchStep> steps,  bool isLaunching,  bool hasLaunched,  bool needsAccessibilityPermission)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LaunchProgress() when $default != null:
return $default(_that.steps,_that.isLaunching,_that.hasLaunched,_that.needsAccessibilityPermission);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Map<int, LaunchStep> steps,  bool isLaunching,  bool hasLaunched,  bool needsAccessibilityPermission)  $default,) {final _that = this;
switch (_that) {
case _LaunchProgress():
return $default(_that.steps,_that.isLaunching,_that.hasLaunched,_that.needsAccessibilityPermission);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Map<int, LaunchStep> steps,  bool isLaunching,  bool hasLaunched,  bool needsAccessibilityPermission)?  $default,) {final _that = this;
switch (_that) {
case _LaunchProgress() when $default != null:
return $default(_that.steps,_that.isLaunching,_that.hasLaunched,_that.needsAccessibilityPermission);case _:
  return null;

}
}

}

/// @nodoc


class _LaunchProgress extends LaunchProgress {
  const _LaunchProgress({final  Map<int, LaunchStep> steps = const {}, this.isLaunching = false, this.hasLaunched = false, this.needsAccessibilityPermission = false}): _steps = steps,super._();
  

 final  Map<int, LaunchStep> _steps;
@override@JsonKey() Map<int, LaunchStep> get steps {
  if (_steps is EqualUnmodifiableMapView) return _steps;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_steps);
}

@override@JsonKey() final  bool isLaunching;
/// True once every window has been dealt with — the button reads "Re-arrange".
@override@JsonKey() final  bool hasLaunched;
/// Set when the accessibility permission is missing.
@override@JsonKey() final  bool needsAccessibilityPermission;

/// Create a copy of LaunchProgress
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LaunchProgressCopyWith<_LaunchProgress> get copyWith => __$LaunchProgressCopyWithImpl<_LaunchProgress>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LaunchProgress&&const DeepCollectionEquality().equals(other._steps, _steps)&&(identical(other.isLaunching, isLaunching) || other.isLaunching == isLaunching)&&(identical(other.hasLaunched, hasLaunched) || other.hasLaunched == hasLaunched)&&(identical(other.needsAccessibilityPermission, needsAccessibilityPermission) || other.needsAccessibilityPermission == needsAccessibilityPermission));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_steps),isLaunching,hasLaunched,needsAccessibilityPermission);

@override
String toString() {
  return 'LaunchProgress(steps: $steps, isLaunching: $isLaunching, hasLaunched: $hasLaunched, needsAccessibilityPermission: $needsAccessibilityPermission)';
}


}

/// @nodoc
abstract mixin class _$LaunchProgressCopyWith<$Res> implements $LaunchProgressCopyWith<$Res> {
  factory _$LaunchProgressCopyWith(_LaunchProgress value, $Res Function(_LaunchProgress) _then) = __$LaunchProgressCopyWithImpl;
@override @useResult
$Res call({
 Map<int, LaunchStep> steps, bool isLaunching, bool hasLaunched, bool needsAccessibilityPermission
});




}
/// @nodoc
class __$LaunchProgressCopyWithImpl<$Res>
    implements _$LaunchProgressCopyWith<$Res> {
  __$LaunchProgressCopyWithImpl(this._self, this._then);

  final _LaunchProgress _self;
  final $Res Function(_LaunchProgress) _then;

/// Create a copy of LaunchProgress
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? steps = null,Object? isLaunching = null,Object? hasLaunched = null,Object? needsAccessibilityPermission = null,}) {
  return _then(_LaunchProgress(
steps: null == steps ? _self._steps : steps // ignore: cast_nullable_to_non_nullable
as Map<int, LaunchStep>,isLaunching: null == isLaunching ? _self.isLaunching : isLaunching // ignore: cast_nullable_to_non_nullable
as bool,hasLaunched: null == hasLaunched ? _self.hasLaunched : hasLaunched // ignore: cast_nullable_to_non_nullable
as bool,needsAccessibilityPermission: null == needsAccessibilityPermission ? _self.needsAccessibilityPermission : needsAccessibilityPermission // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
