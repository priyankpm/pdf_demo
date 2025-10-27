// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'count_sheep_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CountSheepModel {

 bool? get showCountSheepScreen; int? get sheepCount;
/// Create a copy of CountSheepModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CountSheepModelCopyWith<CountSheepModel> get copyWith => _$CountSheepModelCopyWithImpl<CountSheepModel>(this as CountSheepModel, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CountSheepModel&&(identical(other.showCountSheepScreen, showCountSheepScreen) || other.showCountSheepScreen == showCountSheepScreen)&&(identical(other.sheepCount, sheepCount) || other.sheepCount == sheepCount));
}


@override
int get hashCode => Object.hash(runtimeType,showCountSheepScreen,sheepCount);

@override
String toString() {
  return 'CountSheepModel(showCountSheepScreen: $showCountSheepScreen, sheepCount: $sheepCount)';
}


}

/// @nodoc
abstract mixin class $CountSheepModelCopyWith<$Res>  {
  factory $CountSheepModelCopyWith(CountSheepModel value, $Res Function(CountSheepModel) _then) = _$CountSheepModelCopyWithImpl;
@useResult
$Res call({
 bool? showCountSheepScreen, int? sheepCount
});




}
/// @nodoc
class _$CountSheepModelCopyWithImpl<$Res>
    implements $CountSheepModelCopyWith<$Res> {
  _$CountSheepModelCopyWithImpl(this._self, this._then);

  final CountSheepModel _self;
  final $Res Function(CountSheepModel) _then;

/// Create a copy of CountSheepModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? showCountSheepScreen = freezed,Object? sheepCount = freezed,}) {
  return _then(_self.copyWith(
showCountSheepScreen: freezed == showCountSheepScreen ? _self.showCountSheepScreen : showCountSheepScreen // ignore: cast_nullable_to_non_nullable
as bool?,sheepCount: freezed == sheepCount ? _self.sheepCount : sheepCount // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [CountSheepModel].
extension CountSheepModelPatterns on CountSheepModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CountSheepModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CountSheepModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CountSheepModel value)  $default,){
final _that = this;
switch (_that) {
case _CountSheepModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CountSheepModel value)?  $default,){
final _that = this;
switch (_that) {
case _CountSheepModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool? showCountSheepScreen,  int? sheepCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CountSheepModel() when $default != null:
return $default(_that.showCountSheepScreen,_that.sheepCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool? showCountSheepScreen,  int? sheepCount)  $default,) {final _that = this;
switch (_that) {
case _CountSheepModel():
return $default(_that.showCountSheepScreen,_that.sheepCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool? showCountSheepScreen,  int? sheepCount)?  $default,) {final _that = this;
switch (_that) {
case _CountSheepModel() when $default != null:
return $default(_that.showCountSheepScreen,_that.sheepCount);case _:
  return null;

}
}

}

/// @nodoc


class _CountSheepModel extends CountSheepModel {
   _CountSheepModel({required this.showCountSheepScreen, required this.sheepCount}): super._();
  

@override final  bool? showCountSheepScreen;
@override final  int? sheepCount;

/// Create a copy of CountSheepModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CountSheepModelCopyWith<_CountSheepModel> get copyWith => __$CountSheepModelCopyWithImpl<_CountSheepModel>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CountSheepModel&&(identical(other.showCountSheepScreen, showCountSheepScreen) || other.showCountSheepScreen == showCountSheepScreen)&&(identical(other.sheepCount, sheepCount) || other.sheepCount == sheepCount));
}


@override
int get hashCode => Object.hash(runtimeType,showCountSheepScreen,sheepCount);

@override
String toString() {
  return 'CountSheepModel(showCountSheepScreen: $showCountSheepScreen, sheepCount: $sheepCount)';
}


}

/// @nodoc
abstract mixin class _$CountSheepModelCopyWith<$Res> implements $CountSheepModelCopyWith<$Res> {
  factory _$CountSheepModelCopyWith(_CountSheepModel value, $Res Function(_CountSheepModel) _then) = __$CountSheepModelCopyWithImpl;
@override @useResult
$Res call({
 bool? showCountSheepScreen, int? sheepCount
});




}
/// @nodoc
class __$CountSheepModelCopyWithImpl<$Res>
    implements _$CountSheepModelCopyWith<$Res> {
  __$CountSheepModelCopyWithImpl(this._self, this._then);

  final _CountSheepModel _self;
  final $Res Function(_CountSheepModel) _then;

/// Create a copy of CountSheepModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? showCountSheepScreen = freezed,Object? sheepCount = freezed,}) {
  return _then(_CountSheepModel(
showCountSheepScreen: freezed == showCountSheepScreen ? _self.showCountSheepScreen : showCountSheepScreen // ignore: cast_nullable_to_non_nullable
as bool?,sheepCount: freezed == sheepCount ? _self.sheepCount : sheepCount // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
