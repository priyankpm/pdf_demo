// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'question_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$QuestionModel {

 int get pageNumber; int get position; String get question; List<String>? get selectedOptions; List<String> get options; int? get minSelections; int? get maxSelections;
/// Create a copy of QuestionModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuestionModelCopyWith<QuestionModel> get copyWith => _$QuestionModelCopyWithImpl<QuestionModel>(this as QuestionModel, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuestionModel&&(identical(other.pageNumber, pageNumber) || other.pageNumber == pageNumber)&&(identical(other.position, position) || other.position == position)&&(identical(other.question, question) || other.question == question)&&const DeepCollectionEquality().equals(other.selectedOptions, selectedOptions)&&const DeepCollectionEquality().equals(other.options, options)&&(identical(other.minSelections, minSelections) || other.minSelections == minSelections)&&(identical(other.maxSelections, maxSelections) || other.maxSelections == maxSelections));
}


@override
int get hashCode => Object.hash(runtimeType,pageNumber,position,question,const DeepCollectionEquality().hash(selectedOptions),const DeepCollectionEquality().hash(options),minSelections,maxSelections);

@override
String toString() {
  return 'QuestionModel(pageNumber: $pageNumber, position: $position, question: $question, selectedOptions: $selectedOptions, options: $options, minSelections: $minSelections, maxSelections: $maxSelections)';
}


}

/// @nodoc
abstract mixin class $QuestionModelCopyWith<$Res>  {
  factory $QuestionModelCopyWith(QuestionModel value, $Res Function(QuestionModel) _then) = _$QuestionModelCopyWithImpl;
@useResult
$Res call({
 int pageNumber, int position, String question, List<String>? selectedOptions, List<String> options, int? minSelections, int? maxSelections
});




}
/// @nodoc
class _$QuestionModelCopyWithImpl<$Res>
    implements $QuestionModelCopyWith<$Res> {
  _$QuestionModelCopyWithImpl(this._self, this._then);

  final QuestionModel _self;
  final $Res Function(QuestionModel) _then;

/// Create a copy of QuestionModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? pageNumber = null,Object? position = null,Object? question = null,Object? selectedOptions = freezed,Object? options = null,Object? minSelections = freezed,Object? maxSelections = freezed,}) {
  return _then(_self.copyWith(
pageNumber: null == pageNumber ? _self.pageNumber : pageNumber // ignore: cast_nullable_to_non_nullable
as int,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,question: null == question ? _self.question : question // ignore: cast_nullable_to_non_nullable
as String,selectedOptions: freezed == selectedOptions ? _self.selectedOptions : selectedOptions // ignore: cast_nullable_to_non_nullable
as List<String>?,options: null == options ? _self.options : options // ignore: cast_nullable_to_non_nullable
as List<String>,minSelections: freezed == minSelections ? _self.minSelections : minSelections // ignore: cast_nullable_to_non_nullable
as int?,maxSelections: freezed == maxSelections ? _self.maxSelections : maxSelections // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [QuestionModel].
extension QuestionModelPatterns on QuestionModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QuestionModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QuestionModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QuestionModel value)  $default,){
final _that = this;
switch (_that) {
case _QuestionModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QuestionModel value)?  $default,){
final _that = this;
switch (_that) {
case _QuestionModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int pageNumber,  int position,  String question,  List<String>? selectedOptions,  List<String> options,  int? minSelections,  int? maxSelections)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QuestionModel() when $default != null:
return $default(_that.pageNumber,_that.position,_that.question,_that.selectedOptions,_that.options,_that.minSelections,_that.maxSelections);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int pageNumber,  int position,  String question,  List<String>? selectedOptions,  List<String> options,  int? minSelections,  int? maxSelections)  $default,) {final _that = this;
switch (_that) {
case _QuestionModel():
return $default(_that.pageNumber,_that.position,_that.question,_that.selectedOptions,_that.options,_that.minSelections,_that.maxSelections);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int pageNumber,  int position,  String question,  List<String>? selectedOptions,  List<String> options,  int? minSelections,  int? maxSelections)?  $default,) {final _that = this;
switch (_that) {
case _QuestionModel() when $default != null:
return $default(_that.pageNumber,_that.position,_that.question,_that.selectedOptions,_that.options,_that.minSelections,_that.maxSelections);case _:
  return null;

}
}

}

/// @nodoc


class _QuestionModel extends QuestionModel {
  const _QuestionModel({required this.pageNumber, required this.position, required this.question, final  List<String>? selectedOptions, required final  List<String> options, this.minSelections, this.maxSelections}): _selectedOptions = selectedOptions,_options = options,super._();
  

@override final  int pageNumber;
@override final  int position;
@override final  String question;
 final  List<String>? _selectedOptions;
@override List<String>? get selectedOptions {
  final value = _selectedOptions;
  if (value == null) return null;
  if (_selectedOptions is EqualUnmodifiableListView) return _selectedOptions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<String> _options;
@override List<String> get options {
  if (_options is EqualUnmodifiableListView) return _options;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_options);
}

@override final  int? minSelections;
@override final  int? maxSelections;

/// Create a copy of QuestionModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuestionModelCopyWith<_QuestionModel> get copyWith => __$QuestionModelCopyWithImpl<_QuestionModel>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuestionModel&&(identical(other.pageNumber, pageNumber) || other.pageNumber == pageNumber)&&(identical(other.position, position) || other.position == position)&&(identical(other.question, question) || other.question == question)&&const DeepCollectionEquality().equals(other._selectedOptions, _selectedOptions)&&const DeepCollectionEquality().equals(other._options, _options)&&(identical(other.minSelections, minSelections) || other.minSelections == minSelections)&&(identical(other.maxSelections, maxSelections) || other.maxSelections == maxSelections));
}


@override
int get hashCode => Object.hash(runtimeType,pageNumber,position,question,const DeepCollectionEquality().hash(_selectedOptions),const DeepCollectionEquality().hash(_options),minSelections,maxSelections);

@override
String toString() {
  return 'QuestionModel(pageNumber: $pageNumber, position: $position, question: $question, selectedOptions: $selectedOptions, options: $options, minSelections: $minSelections, maxSelections: $maxSelections)';
}


}

/// @nodoc
abstract mixin class _$QuestionModelCopyWith<$Res> implements $QuestionModelCopyWith<$Res> {
  factory _$QuestionModelCopyWith(_QuestionModel value, $Res Function(_QuestionModel) _then) = __$QuestionModelCopyWithImpl;
@override @useResult
$Res call({
 int pageNumber, int position, String question, List<String>? selectedOptions, List<String> options, int? minSelections, int? maxSelections
});




}
/// @nodoc
class __$QuestionModelCopyWithImpl<$Res>
    implements _$QuestionModelCopyWith<$Res> {
  __$QuestionModelCopyWithImpl(this._self, this._then);

  final _QuestionModel _self;
  final $Res Function(_QuestionModel) _then;

/// Create a copy of QuestionModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? pageNumber = null,Object? position = null,Object? question = null,Object? selectedOptions = freezed,Object? options = null,Object? minSelections = freezed,Object? maxSelections = freezed,}) {
  return _then(_QuestionModel(
pageNumber: null == pageNumber ? _self.pageNumber : pageNumber // ignore: cast_nullable_to_non_nullable
as int,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,question: null == question ? _self.question : question // ignore: cast_nullable_to_non_nullable
as String,selectedOptions: freezed == selectedOptions ? _self._selectedOptions : selectedOptions // ignore: cast_nullable_to_non_nullable
as List<String>?,options: null == options ? _self._options : options // ignore: cast_nullable_to_non_nullable
as List<String>,minSelections: freezed == minSelections ? _self.minSelections : minSelections // ignore: cast_nullable_to_non_nullable
as int?,maxSelections: freezed == maxSelections ? _self.maxSelections : maxSelections // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
