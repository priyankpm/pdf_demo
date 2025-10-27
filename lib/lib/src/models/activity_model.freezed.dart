// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'activity_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ActivityModel {

 PetActivityEnum? get petCurrentState; PetActivityEnum? get previousPetState;
/// Create a copy of ActivityModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ActivityModelCopyWith<ActivityModel> get copyWith => _$ActivityModelCopyWithImpl<ActivityModel>(this as ActivityModel, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ActivityModel&&(identical(other.petCurrentState, petCurrentState) || other.petCurrentState == petCurrentState)&&(identical(other.previousPetState, previousPetState) || other.previousPetState == previousPetState));
}


@override
int get hashCode => Object.hash(runtimeType,petCurrentState,previousPetState);

@override
String toString() {
  return 'ActivityModel(petCurrentState: $petCurrentState, previousPetState: $previousPetState)';
}


}

/// @nodoc
abstract mixin class $ActivityModelCopyWith<$Res>  {
  factory $ActivityModelCopyWith(ActivityModel value, $Res Function(ActivityModel) _then) = _$ActivityModelCopyWithImpl;
@useResult
$Res call({
 PetActivityEnum? petCurrentState, PetActivityEnum? previousPetState
});




}
/// @nodoc
class _$ActivityModelCopyWithImpl<$Res>
    implements $ActivityModelCopyWith<$Res> {
  _$ActivityModelCopyWithImpl(this._self, this._then);

  final ActivityModel _self;
  final $Res Function(ActivityModel) _then;

/// Create a copy of ActivityModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? petCurrentState = freezed,Object? previousPetState = freezed,}) {
  return _then(_self.copyWith(
petCurrentState: freezed == petCurrentState ? _self.petCurrentState : petCurrentState // ignore: cast_nullable_to_non_nullable
as PetActivityEnum?,previousPetState: freezed == previousPetState ? _self.previousPetState : previousPetState // ignore: cast_nullable_to_non_nullable
as PetActivityEnum?,
  ));
}

}


/// Adds pattern-matching-related methods to [ActivityModel].
extension ActivityModelPatterns on ActivityModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ActivityModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ActivityModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ActivityModel value)  $default,){
final _that = this;
switch (_that) {
case _ActivityModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ActivityModel value)?  $default,){
final _that = this;
switch (_that) {
case _ActivityModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( PetActivityEnum? petCurrentState,  PetActivityEnum? previousPetState)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ActivityModel() when $default != null:
return $default(_that.petCurrentState,_that.previousPetState);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( PetActivityEnum? petCurrentState,  PetActivityEnum? previousPetState)  $default,) {final _that = this;
switch (_that) {
case _ActivityModel():
return $default(_that.petCurrentState,_that.previousPetState);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( PetActivityEnum? petCurrentState,  PetActivityEnum? previousPetState)?  $default,) {final _that = this;
switch (_that) {
case _ActivityModel() when $default != null:
return $default(_that.petCurrentState,_that.previousPetState);case _:
  return null;

}
}

}

/// @nodoc


class _ActivityModel extends ActivityModel {
   _ActivityModel({required this.petCurrentState, required this.previousPetState}): super._();
  

@override final  PetActivityEnum? petCurrentState;
@override final  PetActivityEnum? previousPetState;

/// Create a copy of ActivityModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ActivityModelCopyWith<_ActivityModel> get copyWith => __$ActivityModelCopyWithImpl<_ActivityModel>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ActivityModel&&(identical(other.petCurrentState, petCurrentState) || other.petCurrentState == petCurrentState)&&(identical(other.previousPetState, previousPetState) || other.previousPetState == previousPetState));
}


@override
int get hashCode => Object.hash(runtimeType,petCurrentState,previousPetState);

@override
String toString() {
  return 'ActivityModel(petCurrentState: $petCurrentState, previousPetState: $previousPetState)';
}


}

/// @nodoc
abstract mixin class _$ActivityModelCopyWith<$Res> implements $ActivityModelCopyWith<$Res> {
  factory _$ActivityModelCopyWith(_ActivityModel value, $Res Function(_ActivityModel) _then) = __$ActivityModelCopyWithImpl;
@override @useResult
$Res call({
 PetActivityEnum? petCurrentState, PetActivityEnum? previousPetState
});




}
/// @nodoc
class __$ActivityModelCopyWithImpl<$Res>
    implements _$ActivityModelCopyWith<$Res> {
  __$ActivityModelCopyWithImpl(this._self, this._then);

  final _ActivityModel _self;
  final $Res Function(_ActivityModel) _then;

/// Create a copy of ActivityModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? petCurrentState = freezed,Object? previousPetState = freezed,}) {
  return _then(_ActivityModel(
petCurrentState: freezed == petCurrentState ? _self.petCurrentState : petCurrentState // ignore: cast_nullable_to_non_nullable
as PetActivityEnum?,previousPetState: freezed == previousPetState ? _self.previousPetState : previousPetState // ignore: cast_nullable_to_non_nullable
as PetActivityEnum?,
  ));
}


}

// dart format on
