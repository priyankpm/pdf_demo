// viewmodels/pet_birthday_viewmodel.dart
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../common_utility/common_utility.dart';
import '../../models/pet_birthday_model.dart';
import '../../provider.dart';

class PetBirthdayViewModel extends StateNotifier<PetBirthdayModel> {
  PetBirthdayViewModel(this.ref) : super(PetBirthdayModel());
  final Ref ref;
  bool _isDisposed = false;

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  void updateMonth(String? month) {
    if (_isDisposed) return;
    state = state.copyWith(month: month);
  }

  void updateDay(String? day) {
    if (_isDisposed) return;
    state = state.copyWith(day: day);
  }

  void updateYear(String? year) {
    if (_isDisposed) return;
    state = state.copyWith(year: year);
  }

  void navigateToNextScreen() {
    if (_isDisposed) return;
    if (state.isComplete) {
      // Just navigate, no API call
      ref.read(navigationServiceProvider).pushNamed(RoutePaths.petGenderScreen);
    }
  }

  void navigateBack() {
    if (_isDisposed) return;
   // ref.read(navigationServiceProvider).pop();
  }
}