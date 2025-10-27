// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'memory_frame_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MemoryFrameModel {

 String? get id; String get imagePath; String? get imageId; String get framePath; String? get description; String get title; String? get memoryFrameType; DateTime? get createdAt; int? get shares; String? get petId; String? get userId; bool? get IsFromApp;
/// Create a copy of MemoryFrameModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MemoryFrameModelCopyWith<MemoryFrameModel> get copyWith => _$MemoryFrameModelCopyWithImpl<MemoryFrameModel>(this as MemoryFrameModel, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MemoryFrameModel&&(identical(other.id, id) || other.id == id)&&(identical(other.imagePath, imagePath) || other.imagePath == imagePath)&&(identical(other.imageId, imageId) || other.imageId == imageId)&&(identical(other.framePath, framePath) || other.framePath == framePath)&&(identical(other.description, description) || other.description == description)&&(identical(other.title, title) || other.title == title)&&(identical(other.memoryFrameType, memoryFrameType) || other.memoryFrameType == memoryFrameType)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.shares, shares) || other.shares == shares)&&(identical(other.petId, petId) || other.petId == petId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.IsFromApp, IsFromApp) || other.IsFromApp == IsFromApp));
}


@override
int get hashCode => Object.hash(runtimeType,id,imagePath,imageId,framePath,description,title,memoryFrameType,createdAt,shares,petId,userId,IsFromApp);

@override
String toString() {
  return 'MemoryFrameModel(id: $id, imagePath: $imagePath, imageId: $imageId, framePath: $framePath, description: $description, title: $title, memoryFrameType: $memoryFrameType, createdAt: $createdAt, shares: $shares, petId: $petId, userId: $userId, IsFromApp: $IsFromApp)';
}


}

/// @nodoc
abstract mixin class $MemoryFrameModelCopyWith<$Res>  {
  factory $MemoryFrameModelCopyWith(MemoryFrameModel value, $Res Function(MemoryFrameModel) _then) = _$MemoryFrameModelCopyWithImpl;
@useResult
$Res call({
 String? id, String imagePath, String? imageId, String framePath, String? description, String title, String? memoryFrameType, DateTime? createdAt, int? shares, String? petId, String? userId, bool? IsFromApp
});




}
/// @nodoc
class _$MemoryFrameModelCopyWithImpl<$Res>
    implements $MemoryFrameModelCopyWith<$Res> {
  _$MemoryFrameModelCopyWithImpl(this._self, this._then);

  final MemoryFrameModel _self;
  final $Res Function(MemoryFrameModel) _then;

/// Create a copy of MemoryFrameModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? imagePath = null,Object? imageId = freezed,Object? framePath = null,Object? description = freezed,Object? title = null,Object? memoryFrameType = freezed,Object? createdAt = freezed,Object? shares = freezed,Object? petId = freezed,Object? userId = freezed,Object? IsFromApp = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,imagePath: null == imagePath ? _self.imagePath : imagePath // ignore: cast_nullable_to_non_nullable
as String,imageId: freezed == imageId ? _self.imageId : imageId // ignore: cast_nullable_to_non_nullable
as String?,framePath: null == framePath ? _self.framePath : framePath // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,memoryFrameType: freezed == memoryFrameType ? _self.memoryFrameType : memoryFrameType // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,shares: freezed == shares ? _self.shares : shares // ignore: cast_nullable_to_non_nullable
as int?,petId: freezed == petId ? _self.petId : petId // ignore: cast_nullable_to_non_nullable
as String?,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,IsFromApp: freezed == IsFromApp ? _self.IsFromApp : IsFromApp // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [MemoryFrameModel].
extension MemoryFrameModelPatterns on MemoryFrameModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MemoryFrameModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MemoryFrameModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MemoryFrameModel value)  $default,){
final _that = this;
switch (_that) {
case _MemoryFrameModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MemoryFrameModel value)?  $default,){
final _that = this;
switch (_that) {
case _MemoryFrameModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id,  String imagePath,  String? imageId,  String framePath,  String? description,  String title,  String? memoryFrameType,  DateTime? createdAt,  int? shares,  String? petId,  String? userId,  bool? IsFromApp)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MemoryFrameModel() when $default != null:
return $default(_that.id,_that.imagePath,_that.imageId,_that.framePath,_that.description,_that.title,_that.memoryFrameType,_that.createdAt,_that.shares,_that.petId,_that.userId,_that.IsFromApp);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id,  String imagePath,  String? imageId,  String framePath,  String? description,  String title,  String? memoryFrameType,  DateTime? createdAt,  int? shares,  String? petId,  String? userId,  bool? IsFromApp)  $default,) {final _that = this;
switch (_that) {
case _MemoryFrameModel():
return $default(_that.id,_that.imagePath,_that.imageId,_that.framePath,_that.description,_that.title,_that.memoryFrameType,_that.createdAt,_that.shares,_that.petId,_that.userId,_that.IsFromApp);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id,  String imagePath,  String? imageId,  String framePath,  String? description,  String title,  String? memoryFrameType,  DateTime? createdAt,  int? shares,  String? petId,  String? userId,  bool? IsFromApp)?  $default,) {final _that = this;
switch (_that) {
case _MemoryFrameModel() when $default != null:
return $default(_that.id,_that.imagePath,_that.imageId,_that.framePath,_that.description,_that.title,_that.memoryFrameType,_that.createdAt,_that.shares,_that.petId,_that.userId,_that.IsFromApp);case _:
  return null;

}
}

}

/// @nodoc


class _MemoryFrameModel extends MemoryFrameModel {
  const _MemoryFrameModel({this.id, required this.imagePath, this.imageId, required this.framePath, this.description, required this.title, this.memoryFrameType, this.createdAt, this.shares, this.petId, this.userId, this.IsFromApp}): super._();
  

@override final  String? id;
@override final  String imagePath;
@override final  String? imageId;
@override final  String framePath;
@override final  String? description;
@override final  String title;
@override final  String? memoryFrameType;
@override final  DateTime? createdAt;
@override final  int? shares;
@override final  String? petId;
@override final  String? userId;
@override final  bool? IsFromApp;

/// Create a copy of MemoryFrameModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MemoryFrameModelCopyWith<_MemoryFrameModel> get copyWith => __$MemoryFrameModelCopyWithImpl<_MemoryFrameModel>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MemoryFrameModel&&(identical(other.id, id) || other.id == id)&&(identical(other.imagePath, imagePath) || other.imagePath == imagePath)&&(identical(other.imageId, imageId) || other.imageId == imageId)&&(identical(other.framePath, framePath) || other.framePath == framePath)&&(identical(other.description, description) || other.description == description)&&(identical(other.title, title) || other.title == title)&&(identical(other.memoryFrameType, memoryFrameType) || other.memoryFrameType == memoryFrameType)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.shares, shares) || other.shares == shares)&&(identical(other.petId, petId) || other.petId == petId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.IsFromApp, IsFromApp) || other.IsFromApp == IsFromApp));
}


@override
int get hashCode => Object.hash(runtimeType,id,imagePath,imageId,framePath,description,title,memoryFrameType,createdAt,shares,petId,userId,IsFromApp);

@override
String toString() {
  return 'MemoryFrameModel(id: $id, imagePath: $imagePath, imageId: $imageId, framePath: $framePath, description: $description, title: $title, memoryFrameType: $memoryFrameType, createdAt: $createdAt, shares: $shares, petId: $petId, userId: $userId, IsFromApp: $IsFromApp)';
}


}

/// @nodoc
abstract mixin class _$MemoryFrameModelCopyWith<$Res> implements $MemoryFrameModelCopyWith<$Res> {
  factory _$MemoryFrameModelCopyWith(_MemoryFrameModel value, $Res Function(_MemoryFrameModel) _then) = __$MemoryFrameModelCopyWithImpl;
@override @useResult
$Res call({
 String? id, String imagePath, String? imageId, String framePath, String? description, String title, String? memoryFrameType, DateTime? createdAt, int? shares, String? petId, String? userId, bool? IsFromApp
});




}
/// @nodoc
class __$MemoryFrameModelCopyWithImpl<$Res>
    implements _$MemoryFrameModelCopyWith<$Res> {
  __$MemoryFrameModelCopyWithImpl(this._self, this._then);

  final _MemoryFrameModel _self;
  final $Res Function(_MemoryFrameModel) _then;

/// Create a copy of MemoryFrameModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? imagePath = null,Object? imageId = freezed,Object? framePath = null,Object? description = freezed,Object? title = null,Object? memoryFrameType = freezed,Object? createdAt = freezed,Object? shares = freezed,Object? petId = freezed,Object? userId = freezed,Object? IsFromApp = freezed,}) {
  return _then(_MemoryFrameModel(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,imagePath: null == imagePath ? _self.imagePath : imagePath // ignore: cast_nullable_to_non_nullable
as String,imageId: freezed == imageId ? _self.imageId : imageId // ignore: cast_nullable_to_non_nullable
as String?,framePath: null == framePath ? _self.framePath : framePath // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,memoryFrameType: freezed == memoryFrameType ? _self.memoryFrameType : memoryFrameType // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,shares: freezed == shares ? _self.shares : shares // ignore: cast_nullable_to_non_nullable
as int?,petId: freezed == petId ? _self.petId : petId // ignore: cast_nullable_to_non_nullable
as String?,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,IsFromApp: freezed == IsFromApp ? _self.IsFromApp : IsFromApp // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}

// dart format on
