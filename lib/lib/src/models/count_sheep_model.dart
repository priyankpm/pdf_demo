import 'package:freezed_annotation/freezed_annotation.dart';

part 'count_sheep_model.freezed.dart';

@freezed
abstract class CountSheepModel with _$CountSheepModel {
  factory CountSheepModel({
    required bool? showCountSheepScreen,
    required int? sheepCount,
  }) = _CountSheepModel;
  const CountSheepModel._();
}