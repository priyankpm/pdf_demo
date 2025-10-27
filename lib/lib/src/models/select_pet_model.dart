class PetTypeModel {
  final String? selectedPet;

  PetTypeModel({this.selectedPet});

  PetTypeModel copyWith({String? selectedPet}) {
    return PetTypeModel(selectedPet: selectedPet ?? this.selectedPet);
  }
}