import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../common_utility/common_utility.dart';
import '../../models/select_pet_model.dart';
import '../../provider.dart';

class PetTypeViewModel extends StateNotifier<PetTypeModel> {
  PetTypeViewModel(this.ref) : super(PetTypeModel());

  final Ref ref;

  void selectPet(String petName) {
    state = state.copyWith(selectedPet: petName);
  }

  void navigateToUploadHouseScreen() {
    ref.read(navigationServiceProvider).pushNamed(RoutePaths.uploadHouseImagesScreen);
  }

  bool get isPetSelected => state.selectedPet != null;
}
