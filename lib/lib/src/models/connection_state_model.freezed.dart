// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'connection_state_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ConnectionStateModel {

 bool? get isConnected; String? get connectionStatus; bool? get isInitialised;
/// Create a copy of ConnectionStateModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConnectionStateModelCopyWith<ConnectionStateModel> get copyWith => _$ConnectionStateModelCopyWithImpl<ConnectionStateModel>(this as ConnectionStateModel, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConnectionStateModel&&(identical(other.isConnected, isConnected) || other.isConnected == isConnected)&&(identical(other.connectionStatus, connectionStatus) || other.connectionStatus == connectionStatus)&&(identical(other.isInitialised, isInitialised) || other.isInitialised == isInitialised));
}


@override
int get hashCode => Object.hash(runtimeType,isConnected,connectionStatus,isInitialised);

@override
String toString() {
  return 'ConnectionStateModel(isConnected: $isConnected, connectionStatus: $connectionStatus, isInitialised: $isInitialised)';
}


}

/// @nodoc
abstract mixin class $ConnectionStateModelCopyWith<$Res>  {
  factory $ConnectionStateModelCopyWith(ConnectionStateModel value, $Res Function(ConnectionStateModel) _then) = _$ConnectionStateModelCopyWithImpl;
@useResult
$Res call({
 bool? isConnected, String? connectionStatus, bool? isInitialised
});




}
/// @nodoc
class _$ConnectionStateModelCopyWithImpl<$Res>
    implements $ConnectionStateModelCopyWith<$Res> {
  _$ConnectionStateModelCopyWithImpl(this._self, this._then);

  final ConnectionStateModel _self;
  final $Res Function(ConnectionStateModel) _then;

/// Create a copy of ConnectionStateModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isConnected = freezed,Object? connectionStatus = freezed,Object? isInitialised = freezed,}) {
  return _then(_self.copyWith(
isConnected: freezed == isConnected ? _self.isConnected : isConnected // ignore: cast_nullable_to_non_nullable
as bool?,connectionStatus: freezed == connectionStatus ? _self.connectionStatus : connectionStatus // ignore: cast_nullable_to_non_nullable
as String?,isInitialised: freezed == isInitialised ? _self.isInitialised : isInitialised // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [ConnectionStateModel].
extension ConnectionStateModelPatterns on ConnectionStateModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ConnectionStateModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ConnectionStateModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ConnectionStateModel value)  $default,){
final _that = this;
switch (_that) {
case _ConnectionStateModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ConnectionStateModel value)?  $default,){
final _that = this;
switch (_that) {
case _ConnectionStateModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool? isConnected,  String? connectionStatus,  bool? isInitialised)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ConnectionStateModel() when $default != null:
return $default(_that.isConnected,_that.connectionStatus,_that.isInitialised);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool? isConnected,  String? connectionStatus,  bool? isInitialised)  $default,) {final _that = this;
switch (_that) {
case _ConnectionStateModel():
return $default(_that.isConnected,_that.connectionStatus,_that.isInitialised);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool? isConnected,  String? connectionStatus,  bool? isInitialised)?  $default,) {final _that = this;
switch (_that) {
case _ConnectionStateModel() when $default != null:
return $default(_that.isConnected,_that.connectionStatus,_that.isInitialised);case _:
  return null;

}
}

}

/// @nodoc


class _ConnectionStateModel extends ConnectionStateModel {
   _ConnectionStateModel({required this.isConnected, required this.connectionStatus, required this.isInitialised}): super._();
  

@override final  bool? isConnected;
@override final  String? connectionStatus;
@override final  bool? isInitialised;

/// Create a copy of ConnectionStateModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ConnectionStateModelCopyWith<_ConnectionStateModel> get copyWith => __$ConnectionStateModelCopyWithImpl<_ConnectionStateModel>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ConnectionStateModel&&(identical(other.isConnected, isConnected) || other.isConnected == isConnected)&&(identical(other.connectionStatus, connectionStatus) || other.connectionStatus == connectionStatus)&&(identical(other.isInitialised, isInitialised) || other.isInitialised == isInitialised));
}


@override
int get hashCode => Object.hash(runtimeType,isConnected,connectionStatus,isInitialised);

@override
String toString() {
  return 'ConnectionStateModel(isConnected: $isConnected, connectionStatus: $connectionStatus, isInitialised: $isInitialised)';
}


}

/// @nodoc
abstract mixin class _$ConnectionStateModelCopyWith<$Res> implements $ConnectionStateModelCopyWith<$Res> {
  factory _$ConnectionStateModelCopyWith(_ConnectionStateModel value, $Res Function(_ConnectionStateModel) _then) = __$ConnectionStateModelCopyWithImpl;
@override @useResult
$Res call({
 bool? isConnected, String? connectionStatus, bool? isInitialised
});




}
/// @nodoc
class __$ConnectionStateModelCopyWithImpl<$Res>
    implements _$ConnectionStateModelCopyWith<$Res> {
  __$ConnectionStateModelCopyWithImpl(this._self, this._then);

  final _ConnectionStateModel _self;
  final $Res Function(_ConnectionStateModel) _then;

/// Create a copy of ConnectionStateModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isConnected = freezed,Object? connectionStatus = freezed,Object? isInitialised = freezed,}) {
  return _then(_ConnectionStateModel(
isConnected: freezed == isConnected ? _self.isConnected : isConnected // ignore: cast_nullable_to_non_nullable
as bool?,connectionStatus: freezed == connectionStatus ? _self.connectionStatus : connectionStatus // ignore: cast_nullable_to_non_nullable
as String?,isInitialised: freezed == isInitialised ? _self.isInitialised : isInitialised // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}

// dart format on
