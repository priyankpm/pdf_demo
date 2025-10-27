import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../common_utility/common_utility.dart';
import '../../services/SharedPreferencesService.dart';
import '../../models/pet_name_model.dart';
import '../../provider.dart';

class PetNameViewModel extends StateNotifier<PetNameModel> {
  PetNameViewModel(this.ref) : super(PetNameModel());

  final Ref ref;

  // Reference to SharedPreferencesService
  final SharedPreferencesService _sharedPreferencesService = SharedPreferencesService();

  void updatePetName(String name) async {
    state = state.copyWith(petName: name, errorMessage: null);

    // Save pet name in SharedPreferences
    await _sharedPreferencesService.setPetName(name);
  }

  void navigateBack() {
    // ref.read(navigationServiceProvider).pop();
  }

  void navigateToNextScreen() {
    if (state.petName != null && state.petName!.isNotEmpty) {
      // Just navigate, no API call
      ref.read(navigationServiceProvider).pushNamed(RoutePaths.petBirthdayScreen);
    }
  }

  bool get isNameValid => state.petName != null && state.petName!.isNotEmpty;
}
