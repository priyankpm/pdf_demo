import 'package:freezed_annotation/freezed_annotation.dart';

import '../enum/pet_activity_enum.dart';

part 'activity_model.freezed.dart';

@freezed
abstract class ActivityModel with _$ActivityModel {
  factory ActivityModel({
    required PetActivityEnum? petCurrentState,
    required PetActivityEnum? previousPetState,
  }) = _ActivityModel;
  const ActivityModel._();
}