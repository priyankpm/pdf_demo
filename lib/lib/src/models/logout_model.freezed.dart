// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'logout_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LogoutModel {

 bool? get showLogoutScreen;
/// Create a copy of LogoutModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LogoutModelCopyWith<LogoutModel> get copyWith => _$LogoutModelCopyWithImpl<LogoutModel>(this as LogoutModel, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LogoutModel&&(identical(other.showLogoutScreen, showLogoutScreen) || other.showLogoutScreen == showLogoutScreen));
}


@override
int get hashCode => Object.hash(runtimeType,showLogoutScreen);

@override
String toString() {
  return 'LogoutModel(showLogoutScreen: $showLogoutScreen)';
}


}

/// @nodoc
abstract mixin class $LogoutModelCopyWith<$Res>  {
  factory $LogoutModelCopyWith(LogoutModel value, $Res Function(LogoutModel) _then) = _$LogoutModelCopyWithImpl;
@useResult
$Res call({
 bool? showLogoutScreen
});




}
/// @nodoc
class _$LogoutModelCopyWithImpl<$Res>
    implements $LogoutModelCopyWith<$Res> {
  _$LogoutModelCopyWithImpl(this._self, this._then);

  final LogoutModel _self;
  final $Res Function(LogoutModel) _then;

/// Create a copy of LogoutModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? showLogoutScreen = freezed,}) {
  return _then(_self.copyWith(
showLogoutScreen: freezed == showLogoutScreen ? _self.showLogoutScreen : showLogoutScreen // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [LogoutModel].
extension LogoutModelPatterns on LogoutModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LogoutModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LogoutModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LogoutModel value)  $default,){
final _that = this;
switch (_that) {
case _LogoutModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LogoutModel value)?  $default,){
final _that = this;
switch (_that) {
case _LogoutModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool? showLogoutScreen)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LogoutModel() when $default != null:
return $default(_that.showLogoutScreen);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool? showLogoutScreen)  $default,) {final _that = this;
switch (_that) {
case _LogoutModel():
return $default(_that.showLogoutScreen);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool? showLogoutScreen)?  $default,) {final _that = this;
switch (_that) {
case _LogoutModel() when $default != null:
return $default(_that.showLogoutScreen);case _:
  return null;

}
}

}

/// @nodoc


class _LogoutModel extends LogoutModel {
   _LogoutModel({required this.showLogoutScreen}): super._();
  

@override final  bool? showLogoutScreen;

/// Create a copy of LogoutModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LogoutModelCopyWith<_LogoutModel> get copyWith => __$LogoutModelCopyWithImpl<_LogoutModel>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LogoutModel&&(identical(other.showLogoutScreen, showLogoutScreen) || other.showLogoutScreen == showLogoutScreen));
}


@override
int get hashCode => Object.hash(runtimeType,showLogoutScreen);

@override
String toString() {
  return 'LogoutModel(showLogoutScreen: $showLogoutScreen)';
}


}

/// @nodoc
abstract mixin class _$LogoutModelCopyWith<$Res> implements $LogoutModelCopyWith<$Res> {
  factory _$LogoutModelCopyWith(_LogoutModel value, $Res Function(_LogoutModel) _then) = __$LogoutModelCopyWithImpl;
@override @useResult
$Res call({
 bool? showLogoutScreen
});




}
/// @nodoc
class __$LogoutModelCopyWithImpl<$Res>
    implements _$LogoutModelCopyWith<$Res> {
  __$LogoutModelCopyWithImpl(this._self, this._then);

  final _LogoutModel _self;
  final $Res Function(_LogoutModel) _then;

/// Create a copy of LogoutModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? showLogoutScreen = freezed,}) {
  return _then(_LogoutModel(
showLogoutScreen: freezed == showLogoutScreen ? _self.showLogoutScreen : showLogoutScreen // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}

// dart format on
