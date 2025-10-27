// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'speaker_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SpeakerModel {

 bool? get showMuteIcon;
/// Create a copy of SpeakerModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SpeakerModelCopyWith<SpeakerModel> get copyWith => _$SpeakerModelCopyWithImpl<SpeakerModel>(this as SpeakerModel, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SpeakerModel&&(identical(other.showMuteIcon, showMuteIcon) || other.showMuteIcon == showMuteIcon));
}


@override
int get hashCode => Object.hash(runtimeType,showMuteIcon);

@override
String toString() {
  return 'SpeakerModel(showMuteIcon: $showMuteIcon)';
}


}

/// @nodoc
abstract mixin class $SpeakerModelCopyWith<$Res>  {
  factory $SpeakerModelCopyWith(SpeakerModel value, $Res Function(SpeakerModel) _then) = _$SpeakerModelCopyWithImpl;
@useResult
$Res call({
 bool? showMuteIcon
});




}
/// @nodoc
class _$SpeakerModelCopyWithImpl<$Res>
    implements $SpeakerModelCopyWith<$Res> {
  _$SpeakerModelCopyWithImpl(this._self, this._then);

  final SpeakerModel _self;
  final $Res Function(SpeakerModel) _then;

/// Create a copy of SpeakerModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? showMuteIcon = freezed,}) {
  return _then(_self.copyWith(
showMuteIcon: freezed == showMuteIcon ? _self.showMuteIcon : showMuteIcon // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [SpeakerModel].
extension SpeakerModelPatterns on SpeakerModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SpeakerModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SpeakerModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SpeakerModel value)  $default,){
final _that = this;
switch (_that) {
case _SpeakerModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SpeakerModel value)?  $default,){
final _that = this;
switch (_that) {
case _SpeakerModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool? showMuteIcon)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SpeakerModel() when $default != null:
return $default(_that.showMuteIcon);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool? showMuteIcon)  $default,) {final _that = this;
switch (_that) {
case _SpeakerModel():
return $default(_that.showMuteIcon);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool? showMuteIcon)?  $default,) {final _that = this;
switch (_that) {
case _SpeakerModel() when $default != null:
return $default(_that.showMuteIcon);case _:
  return null;

}
}

}

/// @nodoc


class _SpeakerModel extends SpeakerModel {
   _SpeakerModel({required this.showMuteIcon}): super._();
  

@override final  bool? showMuteIcon;

/// Create a copy of SpeakerModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SpeakerModelCopyWith<_SpeakerModel> get copyWith => __$SpeakerModelCopyWithImpl<_SpeakerModel>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SpeakerModel&&(identical(other.showMuteIcon, showMuteIcon) || other.showMuteIcon == showMuteIcon));
}


@override
int get hashCode => Object.hash(runtimeType,showMuteIcon);

@override
String toString() {
  return 'SpeakerModel(showMuteIcon: $showMuteIcon)';
}


}

/// @nodoc
abstract mixin class _$SpeakerModelCopyWith<$Res> implements $SpeakerModelCopyWith<$Res> {
  factory _$SpeakerModelCopyWith(_SpeakerModel value, $Res Function(_SpeakerModel) _then) = __$SpeakerModelCopyWithImpl;
@override @useResult
$Res call({
 bool? showMuteIcon
});




}
/// @nodoc
class __$SpeakerModelCopyWithImpl<$Res>
    implements _$SpeakerModelCopyWith<$Res> {
  __$SpeakerModelCopyWithImpl(this._self, this._then);

  final _SpeakerModel _self;
  final $Res Function(_SpeakerModel) _then;

/// Create a copy of SpeakerModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? showMuteIcon = freezed,}) {
  return _then(_SpeakerModel(
showMuteIcon: freezed == showMuteIcon ? _self.showMuteIcon : showMuteIcon // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}

// dart format on
