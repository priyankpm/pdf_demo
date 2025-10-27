// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_account_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CreateAccountModel {

 String get userId; String? get fullName; String? get email; String? get phoneNumber; String? get password;
/// Create a copy of CreateAccountModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateAccountModelCopyWith<CreateAccountModel> get copyWith => _$CreateAccountModelCopyWithImpl<CreateAccountModel>(this as CreateAccountModel, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateAccountModel&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.email, email) || other.email == email)&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&(identical(other.password, password) || other.password == password));
}


@override
int get hashCode => Object.hash(runtimeType,userId,fullName,email,phoneNumber,password);

@override
String toString() {
  return 'CreateAccountModel(userId: $userId, fullName: $fullName, email: $email, phoneNumber: $phoneNumber, password: $password)';
}


}

/// @nodoc
abstract mixin class $CreateAccountModelCopyWith<$Res>  {
  factory $CreateAccountModelCopyWith(CreateAccountModel value, $Res Function(CreateAccountModel) _then) = _$CreateAccountModelCopyWithImpl;
@useResult
$Res call({
 String userId, String? fullName, String? email, String? phoneNumber, String? password
});




}
/// @nodoc
class _$CreateAccountModelCopyWithImpl<$Res>
    implements $CreateAccountModelCopyWith<$Res> {
  _$CreateAccountModelCopyWithImpl(this._self, this._then);

  final CreateAccountModel _self;
  final $Res Function(CreateAccountModel) _then;

/// Create a copy of CreateAccountModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? fullName = freezed,Object? email = freezed,Object? phoneNumber = freezed,Object? password = freezed,}) {
  return _then(_self.copyWith(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,fullName: freezed == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,phoneNumber: freezed == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String?,password: freezed == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CreateAccountModel].
extension CreateAccountModelPatterns on CreateAccountModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateAccountModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateAccountModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateAccountModel value)  $default,){
final _that = this;
switch (_that) {
case _CreateAccountModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateAccountModel value)?  $default,){
final _that = this;
switch (_that) {
case _CreateAccountModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String userId,  String? fullName,  String? email,  String? phoneNumber,  String? password)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateAccountModel() when $default != null:
return $default(_that.userId,_that.fullName,_that.email,_that.phoneNumber,_that.password);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String userId,  String? fullName,  String? email,  String? phoneNumber,  String? password)  $default,) {final _that = this;
switch (_that) {
case _CreateAccountModel():
return $default(_that.userId,_that.fullName,_that.email,_that.phoneNumber,_that.password);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String userId,  String? fullName,  String? email,  String? phoneNumber,  String? password)?  $default,) {final _that = this;
switch (_that) {
case _CreateAccountModel() when $default != null:
return $default(_that.userId,_that.fullName,_that.email,_that.phoneNumber,_that.password);case _:
  return null;

}
}

}

/// @nodoc


class _CreateAccountModel extends CreateAccountModel {
   _CreateAccountModel({required this.userId, required this.fullName, required this.email, required this.phoneNumber, required this.password}): super._();
  

@override final  String userId;
@override final  String? fullName;
@override final  String? email;
@override final  String? phoneNumber;
@override final  String? password;

/// Create a copy of CreateAccountModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateAccountModelCopyWith<_CreateAccountModel> get copyWith => __$CreateAccountModelCopyWithImpl<_CreateAccountModel>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateAccountModel&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.email, email) || other.email == email)&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&(identical(other.password, password) || other.password == password));
}


@override
int get hashCode => Object.hash(runtimeType,userId,fullName,email,phoneNumber,password);

@override
String toString() {
  return 'CreateAccountModel(userId: $userId, fullName: $fullName, email: $email, phoneNumber: $phoneNumber, password: $password)';
}


}

/// @nodoc
abstract mixin class _$CreateAccountModelCopyWith<$Res> implements $CreateAccountModelCopyWith<$Res> {
  factory _$CreateAccountModelCopyWith(_CreateAccountModel value, $Res Function(_CreateAccountModel) _then) = __$CreateAccountModelCopyWithImpl;
@override @useResult
$Res call({
 String userId, String? fullName, String? email, String? phoneNumber, String? password
});




}
/// @nodoc
class __$CreateAccountModelCopyWithImpl<$Res>
    implements _$CreateAccountModelCopyWith<$Res> {
  __$CreateAccountModelCopyWithImpl(this._self, this._then);

  final _CreateAccountModel _self;
  final $Res Function(_CreateAccountModel) _then;

/// Create a copy of CreateAccountModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? fullName = freezed,Object? email = freezed,Object? phoneNumber = freezed,Object? password = freezed,}) {
  return _then(_CreateAccountModel(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,fullName: freezed == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,phoneNumber: freezed == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String?,password: freezed == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
