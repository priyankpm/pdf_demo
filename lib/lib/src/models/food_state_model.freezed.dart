// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'food_state_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FoodStateModel implements DiagnosticableTreeMixin {

 String? get id; String get imagePath; int get foodIndex; int get remainingPortions; DateTime get lastUpdated; bool get isHidden; ValueKey get key;
/// Create a copy of FoodStateModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FoodStateModelCopyWith<FoodStateModel> get copyWith => _$FoodStateModelCopyWithImpl<FoodStateModel>(this as FoodStateModel, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'FoodStateModel'))
    ..add(DiagnosticsProperty('id', id))..add(DiagnosticsProperty('imagePath', imagePath))..add(DiagnosticsProperty('foodIndex', foodIndex))..add(DiagnosticsProperty('remainingPortions', remainingPortions))..add(DiagnosticsProperty('lastUpdated', lastUpdated))..add(DiagnosticsProperty('isHidden', isHidden))..add(DiagnosticsProperty('key', key));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FoodStateModel&&(identical(other.id, id) || other.id == id)&&(identical(other.imagePath, imagePath) || other.imagePath == imagePath)&&(identical(other.foodIndex, foodIndex) || other.foodIndex == foodIndex)&&(identical(other.remainingPortions, remainingPortions) || other.remainingPortions == remainingPortions)&&(identical(other.lastUpdated, lastUpdated) || other.lastUpdated == lastUpdated)&&(identical(other.isHidden, isHidden) || other.isHidden == isHidden)&&(identical(other.key, key) || other.key == key));
}


@override
int get hashCode => Object.hash(runtimeType,id,imagePath,foodIndex,remainingPortions,lastUpdated,isHidden,key);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'FoodStateModel(id: $id, imagePath: $imagePath, foodIndex: $foodIndex, remainingPortions: $remainingPortions, lastUpdated: $lastUpdated, isHidden: $isHidden, key: $key)';
}


}

/// @nodoc
abstract mixin class $FoodStateModelCopyWith<$Res>  {
  factory $FoodStateModelCopyWith(FoodStateModel value, $Res Function(FoodStateModel) _then) = _$FoodStateModelCopyWithImpl;
@useResult
$Res call({
 String? id, String imagePath, int foodIndex, int remainingPortions, DateTime lastUpdated, bool isHidden, ValueKey key
});




}
/// @nodoc
class _$FoodStateModelCopyWithImpl<$Res>
    implements $FoodStateModelCopyWith<$Res> {
  _$FoodStateModelCopyWithImpl(this._self, this._then);

  final FoodStateModel _self;
  final $Res Function(FoodStateModel) _then;

/// Create a copy of FoodStateModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? imagePath = null,Object? foodIndex = null,Object? remainingPortions = null,Object? lastUpdated = null,Object? isHidden = null,Object? key = null,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,imagePath: null == imagePath ? _self.imagePath : imagePath // ignore: cast_nullable_to_non_nullable
as String,foodIndex: null == foodIndex ? _self.foodIndex : foodIndex // ignore: cast_nullable_to_non_nullable
as int,remainingPortions: null == remainingPortions ? _self.remainingPortions : remainingPortions // ignore: cast_nullable_to_non_nullable
as int,lastUpdated: null == lastUpdated ? _self.lastUpdated : lastUpdated // ignore: cast_nullable_to_non_nullable
as DateTime,isHidden: null == isHidden ? _self.isHidden : isHidden // ignore: cast_nullable_to_non_nullable
as bool,key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as ValueKey,
  ));
}

}


/// Adds pattern-matching-related methods to [FoodStateModel].
extension FoodStateModelPatterns on FoodStateModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FoodStateModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FoodStateModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FoodStateModel value)  $default,){
final _that = this;
switch (_that) {
case _FoodStateModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FoodStateModel value)?  $default,){
final _that = this;
switch (_that) {
case _FoodStateModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id,  String imagePath,  int foodIndex,  int remainingPortions,  DateTime lastUpdated,  bool isHidden,  ValueKey key)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FoodStateModel() when $default != null:
return $default(_that.id,_that.imagePath,_that.foodIndex,_that.remainingPortions,_that.lastUpdated,_that.isHidden,_that.key);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id,  String imagePath,  int foodIndex,  int remainingPortions,  DateTime lastUpdated,  bool isHidden,  ValueKey key)  $default,) {final _that = this;
switch (_that) {
case _FoodStateModel():
return $default(_that.id,_that.imagePath,_that.foodIndex,_that.remainingPortions,_that.lastUpdated,_that.isHidden,_that.key);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id,  String imagePath,  int foodIndex,  int remainingPortions,  DateTime lastUpdated,  bool isHidden,  ValueKey key)?  $default,) {final _that = this;
switch (_that) {
case _FoodStateModel() when $default != null:
return $default(_that.id,_that.imagePath,_that.foodIndex,_that.remainingPortions,_that.lastUpdated,_that.isHidden,_that.key);case _:
  return null;

}
}

}

/// @nodoc


class _FoodStateModel extends FoodStateModel with DiagnosticableTreeMixin {
  const _FoodStateModel({this.id, required this.imagePath, required this.foodIndex, required this.remainingPortions, required this.lastUpdated, this.isHidden = false, required this.key}): super._();
  

@override final  String? id;
@override final  String imagePath;
@override final  int foodIndex;
@override final  int remainingPortions;
@override final  DateTime lastUpdated;
@override@JsonKey() final  bool isHidden;
@override final  ValueKey key;

/// Create a copy of FoodStateModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FoodStateModelCopyWith<_FoodStateModel> get copyWith => __$FoodStateModelCopyWithImpl<_FoodStateModel>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'FoodStateModel'))
    ..add(DiagnosticsProperty('id', id))..add(DiagnosticsProperty('imagePath', imagePath))..add(DiagnosticsProperty('foodIndex', foodIndex))..add(DiagnosticsProperty('remainingPortions', remainingPortions))..add(DiagnosticsProperty('lastUpdated', lastUpdated))..add(DiagnosticsProperty('isHidden', isHidden))..add(DiagnosticsProperty('key', key));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FoodStateModel&&(identical(other.id, id) || other.id == id)&&(identical(other.imagePath, imagePath) || other.imagePath == imagePath)&&(identical(other.foodIndex, foodIndex) || other.foodIndex == foodIndex)&&(identical(other.remainingPortions, remainingPortions) || other.remainingPortions == remainingPortions)&&(identical(other.lastUpdated, lastUpdated) || other.lastUpdated == lastUpdated)&&(identical(other.isHidden, isHidden) || other.isHidden == isHidden)&&(identical(other.key, key) || other.key == key));
}


@override
int get hashCode => Object.hash(runtimeType,id,imagePath,foodIndex,remainingPortions,lastUpdated,isHidden,key);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'FoodStateModel(id: $id, imagePath: $imagePath, foodIndex: $foodIndex, remainingPortions: $remainingPortions, lastUpdated: $lastUpdated, isHidden: $isHidden, key: $key)';
}


}

/// @nodoc
abstract mixin class _$FoodStateModelCopyWith<$Res> implements $FoodStateModelCopyWith<$Res> {
  factory _$FoodStateModelCopyWith(_FoodStateModel value, $Res Function(_FoodStateModel) _then) = __$FoodStateModelCopyWithImpl;
@override @useResult
$Res call({
 String? id, String imagePath, int foodIndex, int remainingPortions, DateTime lastUpdated, bool isHidden, ValueKey key
});




}
/// @nodoc
class __$FoodStateModelCopyWithImpl<$Res>
    implements _$FoodStateModelCopyWith<$Res> {
  __$FoodStateModelCopyWithImpl(this._self, this._then);

  final _FoodStateModel _self;
  final $Res Function(_FoodStateModel) _then;

/// Create a copy of FoodStateModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? imagePath = null,Object? foodIndex = null,Object? remainingPortions = null,Object? lastUpdated = null,Object? isHidden = null,Object? key = null,}) {
  return _then(_FoodStateModel(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,imagePath: null == imagePath ? _self.imagePath : imagePath // ignore: cast_nullable_to_non_nullable
as String,foodIndex: null == foodIndex ? _self.foodIndex : foodIndex // ignore: cast_nullable_to_non_nullable
as int,remainingPortions: null == remainingPortions ? _self.remainingPortions : remainingPortions // ignore: cast_nullable_to_non_nullable
as int,lastUpdated: null == lastUpdated ? _self.lastUpdated : lastUpdated // ignore: cast_nullable_to_non_nullable
as DateTime,isHidden: null == isHidden ? _self.isHidden : isHidden // ignore: cast_nullable_to_non_nullable
as bool,key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as ValueKey,
  ));
}


}

// dart format on
