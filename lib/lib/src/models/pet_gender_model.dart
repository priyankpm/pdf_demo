// models/pet_gender_model.dart
class PetGenderModel {
  final String? gender;
  final bool loading;
  final String? errorMessage;

  PetGenderModel({
    this.gender,
    this.loading = false,
    this.errorMessage,
  });

  PetGenderModel copyWith({
    String? gender,
    bool? loading,
    String? errorMessage,
  }) {
    return PetGenderModel(
      gender: gender ?? this.gender,
      loading: loading ?? this.loading,
      errorMessage: errorMessage,
    );
  }

  bool get isComplete => gender != null && gender!.isNotEmpty;
}