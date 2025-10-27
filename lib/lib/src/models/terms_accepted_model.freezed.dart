// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'terms_accepted_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TermsAcceptedModel {

 bool? get isTermsAccepted;
/// Create a copy of TermsAcceptedModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TermsAcceptedModelCopyWith<TermsAcceptedModel> get copyWith => _$TermsAcceptedModelCopyWithImpl<TermsAcceptedModel>(this as TermsAcceptedModel, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TermsAcceptedModel&&(identical(other.isTermsAccepted, isTermsAccepted) || other.isTermsAccepted == isTermsAccepted));
}


@override
int get hashCode => Object.hash(runtimeType,isTermsAccepted);

@override
String toString() {
  return 'TermsAcceptedModel(isTermsAccepted: $isTermsAccepted)';
}


}

/// @nodoc
abstract mixin class $TermsAcceptedModelCopyWith<$Res>  {
  factory $TermsAcceptedModelCopyWith(TermsAcceptedModel value, $Res Function(TermsAcceptedModel) _then) = _$TermsAcceptedModelCopyWithImpl;
@useResult
$Res call({
 bool? isTermsAccepted
});




}
/// @nodoc
class _$TermsAcceptedModelCopyWithImpl<$Res>
    implements $TermsAcceptedModelCopyWith<$Res> {
  _$TermsAcceptedModelCopyWithImpl(this._self, this._then);

  final TermsAcceptedModel _self;
  final $Res Function(TermsAcceptedModel) _then;

/// Create a copy of TermsAcceptedModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isTermsAccepted = freezed,}) {
  return _then(_self.copyWith(
isTermsAccepted: freezed == isTermsAccepted ? _self.isTermsAccepted : isTermsAccepted // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [TermsAcceptedModel].
extension TermsAcceptedModelPatterns on TermsAcceptedModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TermsAcceptedModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TermsAcceptedModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TermsAcceptedModel value)  $default,){
final _that = this;
switch (_that) {
case _TermsAcceptedModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TermsAcceptedModel value)?  $default,){
final _that = this;
switch (_that) {
case _TermsAcceptedModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool? isTermsAccepted)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TermsAcceptedModel() when $default != null:
return $default(_that.isTermsAccepted);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool? isTermsAccepted)  $default,) {final _that = this;
switch (_that) {
case _TermsAcceptedModel():
return $default(_that.isTermsAccepted);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool? isTermsAccepted)?  $default,) {final _that = this;
switch (_that) {
case _TermsAcceptedModel() when $default != null:
return $default(_that.isTermsAccepted);case _:
  return null;

}
}

}

/// @nodoc


class _TermsAcceptedModel extends TermsAcceptedModel {
   _TermsAcceptedModel({required this.isTermsAccepted}): super._();
  

@override final  bool? isTermsAccepted;

/// Create a copy of TermsAcceptedModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TermsAcceptedModelCopyWith<_TermsAcceptedModel> get copyWith => __$TermsAcceptedModelCopyWithImpl<_TermsAcceptedModel>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TermsAcceptedModel&&(identical(other.isTermsAccepted, isTermsAccepted) || other.isTermsAccepted == isTermsAccepted));
}


@override
int get hashCode => Object.hash(runtimeType,isTermsAccepted);

@override
String toString() {
  return 'TermsAcceptedModel(isTermsAccepted: $isTermsAccepted)';
}


}

/// @nodoc
abstract mixin class _$TermsAcceptedModelCopyWith<$Res> implements $TermsAcceptedModelCopyWith<$Res> {
  factory _$TermsAcceptedModelCopyWith(_TermsAcceptedModel value, $Res Function(_TermsAcceptedModel) _then) = __$TermsAcceptedModelCopyWithImpl;
@override @useResult
$Res call({
 bool? isTermsAccepted
});




}
/// @nodoc
class __$TermsAcceptedModelCopyWithImpl<$Res>
    implements _$TermsAcceptedModelCopyWith<$Res> {
  __$TermsAcceptedModelCopyWithImpl(this._self, this._then);

  final _TermsAcceptedModel _self;
  final $Res Function(_TermsAcceptedModel) _then;

/// Create a copy of TermsAcceptedModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isTermsAccepted = freezed,}) {
  return _then(_TermsAcceptedModel(
isTermsAccepted: freezed == isTermsAccepted ? _self.isTermsAccepted : isTermsAccepted // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}

// dart format on
