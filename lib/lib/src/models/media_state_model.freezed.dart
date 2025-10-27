// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'media_state_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MediaStateModel implements DiagnosticableTreeMixin {

 String get key; String get type; String get action; String get downloadedAssetPath; DateTime get downloadedAt; bool get isDownloaded;
/// Create a copy of MediaStateModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MediaStateModelCopyWith<MediaStateModel> get copyWith => _$MediaStateModelCopyWithImpl<MediaStateModel>(this as MediaStateModel, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'MediaStateModel'))
    ..add(DiagnosticsProperty('key', key))..add(DiagnosticsProperty('type', type))..add(DiagnosticsProperty('action', action))..add(DiagnosticsProperty('downloadedAssetPath', downloadedAssetPath))..add(DiagnosticsProperty('downloadedAt', downloadedAt))..add(DiagnosticsProperty('isDownloaded', isDownloaded));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MediaStateModel&&(identical(other.key, key) || other.key == key)&&(identical(other.type, type) || other.type == type)&&(identical(other.action, action) || other.action == action)&&(identical(other.downloadedAssetPath, downloadedAssetPath) || other.downloadedAssetPath == downloadedAssetPath)&&(identical(other.downloadedAt, downloadedAt) || other.downloadedAt == downloadedAt)&&(identical(other.isDownloaded, isDownloaded) || other.isDownloaded == isDownloaded));
}


@override
int get hashCode => Object.hash(runtimeType,key,type,action,downloadedAssetPath,downloadedAt,isDownloaded);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'MediaStateModel(key: $key, type: $type, action: $action, downloadedAssetPath: $downloadedAssetPath, downloadedAt: $downloadedAt, isDownloaded: $isDownloaded)';
}


}

/// @nodoc
abstract mixin class $MediaStateModelCopyWith<$Res>  {
  factory $MediaStateModelCopyWith(MediaStateModel value, $Res Function(MediaStateModel) _then) = _$MediaStateModelCopyWithImpl;
@useResult
$Res call({
 String key, String type, String action, String downloadedAssetPath, DateTime downloadedAt, bool isDownloaded
});




}
/// @nodoc
class _$MediaStateModelCopyWithImpl<$Res>
    implements $MediaStateModelCopyWith<$Res> {
  _$MediaStateModelCopyWithImpl(this._self, this._then);

  final MediaStateModel _self;
  final $Res Function(MediaStateModel) _then;

/// Create a copy of MediaStateModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? key = null,Object? type = null,Object? action = null,Object? downloadedAssetPath = null,Object? downloadedAt = null,Object? isDownloaded = null,}) {
  return _then(_self.copyWith(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,action: null == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as String,downloadedAssetPath: null == downloadedAssetPath ? _self.downloadedAssetPath : downloadedAssetPath // ignore: cast_nullable_to_non_nullable
as String,downloadedAt: null == downloadedAt ? _self.downloadedAt : downloadedAt // ignore: cast_nullable_to_non_nullable
as DateTime,isDownloaded: null == isDownloaded ? _self.isDownloaded : isDownloaded // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [MediaStateModel].
extension MediaStateModelPatterns on MediaStateModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MediaStateModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MediaStateModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MediaStateModel value)  $default,){
final _that = this;
switch (_that) {
case _MediaStateModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MediaStateModel value)?  $default,){
final _that = this;
switch (_that) {
case _MediaStateModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String key,  String type,  String action,  String downloadedAssetPath,  DateTime downloadedAt,  bool isDownloaded)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MediaStateModel() when $default != null:
return $default(_that.key,_that.type,_that.action,_that.downloadedAssetPath,_that.downloadedAt,_that.isDownloaded);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String key,  String type,  String action,  String downloadedAssetPath,  DateTime downloadedAt,  bool isDownloaded)  $default,) {final _that = this;
switch (_that) {
case _MediaStateModel():
return $default(_that.key,_that.type,_that.action,_that.downloadedAssetPath,_that.downloadedAt,_that.isDownloaded);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String key,  String type,  String action,  String downloadedAssetPath,  DateTime downloadedAt,  bool isDownloaded)?  $default,) {final _that = this;
switch (_that) {
case _MediaStateModel() when $default != null:
return $default(_that.key,_that.type,_that.action,_that.downloadedAssetPath,_that.downloadedAt,_that.isDownloaded);case _:
  return null;

}
}

}

/// @nodoc


class _MediaStateModel extends MediaStateModel with DiagnosticableTreeMixin {
  const _MediaStateModel({required this.key, required this.type, required this.action, required this.downloadedAssetPath, required this.downloadedAt, this.isDownloaded = false}): super._();
  

@override final  String key;
@override final  String type;
@override final  String action;
@override final  String downloadedAssetPath;
@override final  DateTime downloadedAt;
@override@JsonKey() final  bool isDownloaded;

/// Create a copy of MediaStateModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MediaStateModelCopyWith<_MediaStateModel> get copyWith => __$MediaStateModelCopyWithImpl<_MediaStateModel>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'MediaStateModel'))
    ..add(DiagnosticsProperty('key', key))..add(DiagnosticsProperty('type', type))..add(DiagnosticsProperty('action', action))..add(DiagnosticsProperty('downloadedAssetPath', downloadedAssetPath))..add(DiagnosticsProperty('downloadedAt', downloadedAt))..add(DiagnosticsProperty('isDownloaded', isDownloaded));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MediaStateModel&&(identical(other.key, key) || other.key == key)&&(identical(other.type, type) || other.type == type)&&(identical(other.action, action) || other.action == action)&&(identical(other.downloadedAssetPath, downloadedAssetPath) || other.downloadedAssetPath == downloadedAssetPath)&&(identical(other.downloadedAt, downloadedAt) || other.downloadedAt == downloadedAt)&&(identical(other.isDownloaded, isDownloaded) || other.isDownloaded == isDownloaded));
}


@override
int get hashCode => Object.hash(runtimeType,key,type,action,downloadedAssetPath,downloadedAt,isDownloaded);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'MediaStateModel(key: $key, type: $type, action: $action, downloadedAssetPath: $downloadedAssetPath, downloadedAt: $downloadedAt, isDownloaded: $isDownloaded)';
}


}

/// @nodoc
abstract mixin class _$MediaStateModelCopyWith<$Res> implements $MediaStateModelCopyWith<$Res> {
  factory _$MediaStateModelCopyWith(_MediaStateModel value, $Res Function(_MediaStateModel) _then) = __$MediaStateModelCopyWithImpl;
@override @useResult
$Res call({
 String key, String type, String action, String downloadedAssetPath, DateTime downloadedAt, bool isDownloaded
});




}
/// @nodoc
class __$MediaStateModelCopyWithImpl<$Res>
    implements _$MediaStateModelCopyWith<$Res> {
  __$MediaStateModelCopyWithImpl(this._self, this._then);

  final _MediaStateModel _self;
  final $Res Function(_MediaStateModel) _then;

/// Create a copy of MediaStateModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? key = null,Object? type = null,Object? action = null,Object? downloadedAssetPath = null,Object? downloadedAt = null,Object? isDownloaded = null,}) {
  return _then(_MediaStateModel(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,action: null == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as String,downloadedAssetPath: null == downloadedAssetPath ? _self.downloadedAssetPath : downloadedAssetPath // ignore: cast_nullable_to_non_nullable
as String,downloadedAt: null == downloadedAt ? _self.downloadedAt : downloadedAt // ignore: cast_nullable_to_non_nullable
as DateTime,isDownloaded: null == isDownloaded ? _self.isDownloaded : isDownloaded // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
mixin _$SyncStateModel implements DiagnosticableTreeMixin {

 DateTime get lastMemory; DateTime get lastReminder; DateTime get lastMedia; List<String> get lastDownloaded;
/// Create a copy of SyncStateModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SyncStateModelCopyWith<SyncStateModel> get copyWith => _$SyncStateModelCopyWithImpl<SyncStateModel>(this as SyncStateModel, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'SyncStateModel'))
    ..add(DiagnosticsProperty('lastMemory', lastMemory))..add(DiagnosticsProperty('lastReminder', lastReminder))..add(DiagnosticsProperty('lastMedia', lastMedia))..add(DiagnosticsProperty('lastDownloaded', lastDownloaded));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SyncStateModel&&(identical(other.lastMemory, lastMemory) || other.lastMemory == lastMemory)&&(identical(other.lastReminder, lastReminder) || other.lastReminder == lastReminder)&&(identical(other.lastMedia, lastMedia) || other.lastMedia == lastMedia)&&const DeepCollectionEquality().equals(other.lastDownloaded, lastDownloaded));
}


@override
int get hashCode => Object.hash(runtimeType,lastMemory,lastReminder,lastMedia,const DeepCollectionEquality().hash(lastDownloaded));

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'SyncStateModel(lastMemory: $lastMemory, lastReminder: $lastReminder, lastMedia: $lastMedia, lastDownloaded: $lastDownloaded)';
}


}

/// @nodoc
abstract mixin class $SyncStateModelCopyWith<$Res>  {
  factory $SyncStateModelCopyWith(SyncStateModel value, $Res Function(SyncStateModel) _then) = _$SyncStateModelCopyWithImpl;
@useResult
$Res call({
 DateTime lastMemory, DateTime lastReminder, DateTime lastMedia, List<String> lastDownloaded
});




}
/// @nodoc
class _$SyncStateModelCopyWithImpl<$Res>
    implements $SyncStateModelCopyWith<$Res> {
  _$SyncStateModelCopyWithImpl(this._self, this._then);

  final SyncStateModel _self;
  final $Res Function(SyncStateModel) _then;

/// Create a copy of SyncStateModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? lastMemory = null,Object? lastReminder = null,Object? lastMedia = null,Object? lastDownloaded = null,}) {
  return _then(_self.copyWith(
lastMemory: null == lastMemory ? _self.lastMemory : lastMemory // ignore: cast_nullable_to_non_nullable
as DateTime,lastReminder: null == lastReminder ? _self.lastReminder : lastReminder // ignore: cast_nullable_to_non_nullable
as DateTime,lastMedia: null == lastMedia ? _self.lastMedia : lastMedia // ignore: cast_nullable_to_non_nullable
as DateTime,lastDownloaded: null == lastDownloaded ? _self.lastDownloaded : lastDownloaded // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [SyncStateModel].
extension SyncStateModelPatterns on SyncStateModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SyncStateModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SyncStateModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SyncStateModel value)  $default,){
final _that = this;
switch (_that) {
case _SyncStateModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SyncStateModel value)?  $default,){
final _that = this;
switch (_that) {
case _SyncStateModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime lastMemory,  DateTime lastReminder,  DateTime lastMedia,  List<String> lastDownloaded)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SyncStateModel() when $default != null:
return $default(_that.lastMemory,_that.lastReminder,_that.lastMedia,_that.lastDownloaded);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime lastMemory,  DateTime lastReminder,  DateTime lastMedia,  List<String> lastDownloaded)  $default,) {final _that = this;
switch (_that) {
case _SyncStateModel():
return $default(_that.lastMemory,_that.lastReminder,_that.lastMedia,_that.lastDownloaded);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime lastMemory,  DateTime lastReminder,  DateTime lastMedia,  List<String> lastDownloaded)?  $default,) {final _that = this;
switch (_that) {
case _SyncStateModel() when $default != null:
return $default(_that.lastMemory,_that.lastReminder,_that.lastMedia,_that.lastDownloaded);case _:
  return null;

}
}

}

/// @nodoc


class _SyncStateModel extends SyncStateModel with DiagnosticableTreeMixin {
  const _SyncStateModel({required this.lastMemory, required this.lastReminder, required this.lastMedia, final  List<String> lastDownloaded = const []}): _lastDownloaded = lastDownloaded,super._();
  

@override final  DateTime lastMemory;
@override final  DateTime lastReminder;
@override final  DateTime lastMedia;
 final  List<String> _lastDownloaded;
@override@JsonKey() List<String> get lastDownloaded {
  if (_lastDownloaded is EqualUnmodifiableListView) return _lastDownloaded;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_lastDownloaded);
}


/// Create a copy of SyncStateModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SyncStateModelCopyWith<_SyncStateModel> get copyWith => __$SyncStateModelCopyWithImpl<_SyncStateModel>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'SyncStateModel'))
    ..add(DiagnosticsProperty('lastMemory', lastMemory))..add(DiagnosticsProperty('lastReminder', lastReminder))..add(DiagnosticsProperty('lastMedia', lastMedia))..add(DiagnosticsProperty('lastDownloaded', lastDownloaded));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SyncStateModel&&(identical(other.lastMemory, lastMemory) || other.lastMemory == lastMemory)&&(identical(other.lastReminder, lastReminder) || other.lastReminder == lastReminder)&&(identical(other.lastMedia, lastMedia) || other.lastMedia == lastMedia)&&const DeepCollectionEquality().equals(other._lastDownloaded, _lastDownloaded));
}


@override
int get hashCode => Object.hash(runtimeType,lastMemory,lastReminder,lastMedia,const DeepCollectionEquality().hash(_lastDownloaded));

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'SyncStateModel(lastMemory: $lastMemory, lastReminder: $lastReminder, lastMedia: $lastMedia, lastDownloaded: $lastDownloaded)';
}


}

/// @nodoc
abstract mixin class _$SyncStateModelCopyWith<$Res> implements $SyncStateModelCopyWith<$Res> {
  factory _$SyncStateModelCopyWith(_SyncStateModel value, $Res Function(_SyncStateModel) _then) = __$SyncStateModelCopyWithImpl;
@override @useResult
$Res call({
 DateTime lastMemory, DateTime lastReminder, DateTime lastMedia, List<String> lastDownloaded
});




}
/// @nodoc
class __$SyncStateModelCopyWithImpl<$Res>
    implements _$SyncStateModelCopyWith<$Res> {
  __$SyncStateModelCopyWithImpl(this._self, this._then);

  final _SyncStateModel _self;
  final $Res Function(_SyncStateModel) _then;

/// Create a copy of SyncStateModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? lastMemory = null,Object? lastReminder = null,Object? lastMedia = null,Object? lastDownloaded = null,}) {
  return _then(_SyncStateModel(
lastMemory: null == lastMemory ? _self.lastMemory : lastMemory // ignore: cast_nullable_to_non_nullable
as DateTime,lastReminder: null == lastReminder ? _self.lastReminder : lastReminder // ignore: cast_nullable_to_non_nullable
as DateTime,lastMedia: null == lastMedia ? _self.lastMedia : lastMedia // ignore: cast_nullable_to_non_nullable
as DateTime,lastDownloaded: null == lastDownloaded ? _self._lastDownloaded : lastDownloaded // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
