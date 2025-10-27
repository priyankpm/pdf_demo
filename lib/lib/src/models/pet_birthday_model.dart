// models/pet_birthday_model.dart
class PetBirthdayModel {
  final String? month;
  final String? day;
  final String? year;
  final bool loading;
  final String? errorMessage;

  PetBirthdayModel({
    this.month,
    this.day,
    this.year,
    this.loading = false,
    this.errorMessage,
  });

  PetBirthdayModel copyWith({
    String? month,
    String? day,
    String? year,
    bool? loading,
    String? errorMessage,
  }) {
    return PetBirthdayModel(
      month: month ?? this.month,
      day: day ?? this.day,
      year: year ?? this.year,
      loading: loading ?? this.loading,
      errorMessage: errorMessage,
    );
  }

  bool get isComplete => month != null && day != null && year != null;
}