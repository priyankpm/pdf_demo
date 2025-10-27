// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_message_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ChatMessageModel {

 String get text; DateTime get timestamp; bool get isUser; ChatMessageType? get messageType;
/// Create a copy of ChatMessageModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatMessageModelCopyWith<ChatMessageModel> get copyWith => _$ChatMessageModelCopyWithImpl<ChatMessageModel>(this as ChatMessageModel, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatMessageModel&&(identical(other.text, text) || other.text == text)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.isUser, isUser) || other.isUser == isUser)&&(identical(other.messageType, messageType) || other.messageType == messageType));
}


@override
int get hashCode => Object.hash(runtimeType,text,timestamp,isUser,messageType);

@override
String toString() {
  return 'ChatMessageModel(text: $text, timestamp: $timestamp, isUser: $isUser, messageType: $messageType)';
}


}

/// @nodoc
abstract mixin class $ChatMessageModelCopyWith<$Res>  {
  factory $ChatMessageModelCopyWith(ChatMessageModel value, $Res Function(ChatMessageModel) _then) = _$ChatMessageModelCopyWithImpl;
@useResult
$Res call({
 String text, DateTime timestamp, bool isUser, ChatMessageType? messageType
});




}
/// @nodoc
class _$ChatMessageModelCopyWithImpl<$Res>
    implements $ChatMessageModelCopyWith<$Res> {
  _$ChatMessageModelCopyWithImpl(this._self, this._then);

  final ChatMessageModel _self;
  final $Res Function(ChatMessageModel) _then;

/// Create a copy of ChatMessageModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? text = null,Object? timestamp = null,Object? isUser = null,Object? messageType = freezed,}) {
  return _then(_self.copyWith(
text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,isUser: null == isUser ? _self.isUser : isUser // ignore: cast_nullable_to_non_nullable
as bool,messageType: freezed == messageType ? _self.messageType : messageType // ignore: cast_nullable_to_non_nullable
as ChatMessageType?,
  ));
}

}


/// Adds pattern-matching-related methods to [ChatMessageModel].
extension ChatMessageModelPatterns on ChatMessageModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatMessageModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatMessageModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatMessageModel value)  $default,){
final _that = this;
switch (_that) {
case _ChatMessageModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatMessageModel value)?  $default,){
final _that = this;
switch (_that) {
case _ChatMessageModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String text,  DateTime timestamp,  bool isUser,  ChatMessageType? messageType)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatMessageModel() when $default != null:
return $default(_that.text,_that.timestamp,_that.isUser,_that.messageType);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String text,  DateTime timestamp,  bool isUser,  ChatMessageType? messageType)  $default,) {final _that = this;
switch (_that) {
case _ChatMessageModel():
return $default(_that.text,_that.timestamp,_that.isUser,_that.messageType);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String text,  DateTime timestamp,  bool isUser,  ChatMessageType? messageType)?  $default,) {final _that = this;
switch (_that) {
case _ChatMessageModel() when $default != null:
return $default(_that.text,_that.timestamp,_that.isUser,_that.messageType);case _:
  return null;

}
}

}

/// @nodoc


class _ChatMessageModel extends ChatMessageModel {
   _ChatMessageModel({required this.text, required this.timestamp, required this.isUser, required this.messageType}): super._();
  

@override final  String text;
@override final  DateTime timestamp;
@override final  bool isUser;
@override final  ChatMessageType? messageType;

/// Create a copy of ChatMessageModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatMessageModelCopyWith<_ChatMessageModel> get copyWith => __$ChatMessageModelCopyWithImpl<_ChatMessageModel>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatMessageModel&&(identical(other.text, text) || other.text == text)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.isUser, isUser) || other.isUser == isUser)&&(identical(other.messageType, messageType) || other.messageType == messageType));
}


@override
int get hashCode => Object.hash(runtimeType,text,timestamp,isUser,messageType);

@override
String toString() {
  return 'ChatMessageModel(text: $text, timestamp: $timestamp, isUser: $isUser, messageType: $messageType)';
}


}

/// @nodoc
abstract mixin class _$ChatMessageModelCopyWith<$Res> implements $ChatMessageModelCopyWith<$Res> {
  factory _$ChatMessageModelCopyWith(_ChatMessageModel value, $Res Function(_ChatMessageModel) _then) = __$ChatMessageModelCopyWithImpl;
@override @useResult
$Res call({
 String text, DateTime timestamp, bool isUser, ChatMessageType? messageType
});




}
/// @nodoc
class __$ChatMessageModelCopyWithImpl<$Res>
    implements _$ChatMessageModelCopyWith<$Res> {
  __$ChatMessageModelCopyWithImpl(this._self, this._then);

  final _ChatMessageModel _self;
  final $Res Function(_ChatMessageModel) _then;

/// Create a copy of ChatMessageModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? text = null,Object? timestamp = null,Object? isUser = null,Object? messageType = freezed,}) {
  return _then(_ChatMessageModel(
text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,isUser: null == isUser ? _self.isUser : isUser // ignore: cast_nullable_to_non_nullable
as bool,messageType: freezed == messageType ? _self.messageType : messageType // ignore: cast_nullable_to_non_nullable
as ChatMessageType?,
  ));
}


}

// dart format on
