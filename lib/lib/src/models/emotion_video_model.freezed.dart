// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'emotion_video_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$EmotionVideoModel {

 EmotionType? get emotionType; String? get introVideo; String? get loopVideo; String? get outroVideo; String? get images;
/// Create a copy of EmotionVideoModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EmotionVideoModelCopyWith<EmotionVideoModel> get copyWith => _$EmotionVideoModelCopyWithImpl<EmotionVideoModel>(this as EmotionVideoModel, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EmotionVideoModel&&(identical(other.emotionType, emotionType) || other.emotionType == emotionType)&&(identical(other.introVideo, introVideo) || other.introVideo == introVideo)&&(identical(other.loopVideo, loopVideo) || other.loopVideo == loopVideo)&&(identical(other.outroVideo, outroVideo) || other.outroVideo == outroVideo)&&(identical(other.images, images) || other.images == images));
}


@override
int get hashCode => Object.hash(runtimeType,emotionType,introVideo,loopVideo,outroVideo,images);

@override
String toString() {
  return 'EmotionVideoModel(emotionType: $emotionType, introVideo: $introVideo, loopVideo: $loopVideo, outroVideo: $outroVideo, images: $images)';
}


}

/// @nodoc
abstract mixin class $EmotionVideoModelCopyWith<$Res>  {
  factory $EmotionVideoModelCopyWith(EmotionVideoModel value, $Res Function(EmotionVideoModel) _then) = _$EmotionVideoModelCopyWithImpl;
@useResult
$Res call({
 EmotionType? emotionType, String? introVideo, String? loopVideo, String? outroVideo, String? images
});




}
/// @nodoc
class _$EmotionVideoModelCopyWithImpl<$Res>
    implements $EmotionVideoModelCopyWith<$Res> {
  _$EmotionVideoModelCopyWithImpl(this._self, this._then);

  final EmotionVideoModel _self;
  final $Res Function(EmotionVideoModel) _then;

/// Create a copy of EmotionVideoModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? emotionType = freezed,Object? introVideo = freezed,Object? loopVideo = freezed,Object? outroVideo = freezed,Object? images = freezed,}) {
  return _then(_self.copyWith(
emotionType: freezed == emotionType ? _self.emotionType : emotionType // ignore: cast_nullable_to_non_nullable
as EmotionType?,introVideo: freezed == introVideo ? _self.introVideo : introVideo // ignore: cast_nullable_to_non_nullable
as String?,loopVideo: freezed == loopVideo ? _self.loopVideo : loopVideo // ignore: cast_nullable_to_non_nullable
as String?,outroVideo: freezed == outroVideo ? _self.outroVideo : outroVideo // ignore: cast_nullable_to_non_nullable
as String?,images: freezed == images ? _self.images : images // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [EmotionVideoModel].
extension EmotionVideoModelPatterns on EmotionVideoModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EmotionVideoModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EmotionVideoModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EmotionVideoModel value)  $default,){
final _that = this;
switch (_that) {
case _EmotionVideoModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EmotionVideoModel value)?  $default,){
final _that = this;
switch (_that) {
case _EmotionVideoModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( EmotionType? emotionType,  String? introVideo,  String? loopVideo,  String? outroVideo,  String? images)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EmotionVideoModel() when $default != null:
return $default(_that.emotionType,_that.introVideo,_that.loopVideo,_that.outroVideo,_that.images);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( EmotionType? emotionType,  String? introVideo,  String? loopVideo,  String? outroVideo,  String? images)  $default,) {final _that = this;
switch (_that) {
case _EmotionVideoModel():
return $default(_that.emotionType,_that.introVideo,_that.loopVideo,_that.outroVideo,_that.images);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( EmotionType? emotionType,  String? introVideo,  String? loopVideo,  String? outroVideo,  String? images)?  $default,) {final _that = this;
switch (_that) {
case _EmotionVideoModel() when $default != null:
return $default(_that.emotionType,_that.introVideo,_that.loopVideo,_that.outroVideo,_that.images);case _:
  return null;

}
}

}

/// @nodoc


class _EmotionVideoModel extends EmotionVideoModel {
   _EmotionVideoModel({required this.emotionType, required this.introVideo, required this.loopVideo, required this.outroVideo, required this.images}): super._();
  

@override final  EmotionType? emotionType;
@override final  String? introVideo;
@override final  String? loopVideo;
@override final  String? outroVideo;
@override final  String? images;

/// Create a copy of EmotionVideoModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EmotionVideoModelCopyWith<_EmotionVideoModel> get copyWith => __$EmotionVideoModelCopyWithImpl<_EmotionVideoModel>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EmotionVideoModel&&(identical(other.emotionType, emotionType) || other.emotionType == emotionType)&&(identical(other.introVideo, introVideo) || other.introVideo == introVideo)&&(identical(other.loopVideo, loopVideo) || other.loopVideo == loopVideo)&&(identical(other.outroVideo, outroVideo) || other.outroVideo == outroVideo)&&(identical(other.images, images) || other.images == images));
}


@override
int get hashCode => Object.hash(runtimeType,emotionType,introVideo,loopVideo,outroVideo,images);

@override
String toString() {
  return 'EmotionVideoModel(emotionType: $emotionType, introVideo: $introVideo, loopVideo: $loopVideo, outroVideo: $outroVideo, images: $images)';
}


}

/// @nodoc
abstract mixin class _$EmotionVideoModelCopyWith<$Res> implements $EmotionVideoModelCopyWith<$Res> {
  factory _$EmotionVideoModelCopyWith(_EmotionVideoModel value, $Res Function(_EmotionVideoModel) _then) = __$EmotionVideoModelCopyWithImpl;
@override @useResult
$Res call({
 EmotionType? emotionType, String? introVideo, String? loopVideo, String? outroVideo, String? images
});




}
/// @nodoc
class __$EmotionVideoModelCopyWithImpl<$Res>
    implements _$EmotionVideoModelCopyWith<$Res> {
  __$EmotionVideoModelCopyWithImpl(this._self, this._then);

  final _EmotionVideoModel _self;
  final $Res Function(_EmotionVideoModel) _then;

/// Create a copy of EmotionVideoModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? emotionType = freezed,Object? introVideo = freezed,Object? loopVideo = freezed,Object? outroVideo = freezed,Object? images = freezed,}) {
  return _then(_EmotionVideoModel(
emotionType: freezed == emotionType ? _self.emotionType : emotionType // ignore: cast_nullable_to_non_nullable
as EmotionType?,introVideo: freezed == introVideo ? _self.introVideo : introVideo // ignore: cast_nullable_to_non_nullable
as String?,loopVideo: freezed == loopVideo ? _self.loopVideo : loopVideo // ignore: cast_nullable_to_non_nullable
as String?,outroVideo: freezed == outroVideo ? _self.outroVideo : outroVideo // ignore: cast_nullable_to_non_nullable
as String?,images: freezed == images ? _self.images : images // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
