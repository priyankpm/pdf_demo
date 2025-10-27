import 'package:freezed_annotation/freezed_annotation.dart';

part 'question_model.freezed.dart';

@freezed
abstract class QuestionModel with _$QuestionModel {
  const factory QuestionModel({
    required int pageNumber,
    required int position,
    required String question,
    List<String>? selectedOptions,
    required List<String> options,
    int? minSelections,
    int? maxSelections,
  }) = _QuestionModel;

  const QuestionModel._();
}