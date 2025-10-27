// models/pet_name_model.dart
class PetNameModel {
  final String? petName;
  final bool loading;
  final String? errorMessage;

  PetNameModel({
    this.petName,
    this.loading = false,
    this.errorMessage,
  });

  PetNameModel copyWith({
    String? petName,
    bool? loading,
    String? errorMessage,
  }) {
    return PetNameModel(
      petName: petName ?? this.petName,
      loading: loading ?? this.loading,
      errorMessage: errorMessage,
    );
  }

  bool get isComplete => petName != null && petName!.isNotEmpty;
}