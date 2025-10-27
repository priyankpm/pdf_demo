// viewmodels/pet_gender_viewmodel.dart
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../common_utility/common_utility.dart';
import '../../models/pet_gender_model.dart';
import '../../provider.dart';
import '../../services/PetService.dart';

class PetGenderViewModel extends StateNotifier<PetGenderModel> {
  PetGenderViewModel(this.ref) : super(PetGenderModel());

  final Ref ref;
  bool _isDisposed = false;

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  void updateGender(String gender) {
    if (_isDisposed) return;
    state = state.copyWith(gender: gender, errorMessage: null);
  }

  void navigateBack() {
    if (_isDisposed) return;
    //ref.read(navigationServiceProvider).pop();
  }

  Future<void> savePetAndNavigate() async {
    if (_isDisposed) return;

    state = state.copyWith(loading: true, errorMessage: null);

    try {
      // Get ALL pet data from previous screens
      final petNameState = ref.read(petNameProvider);
      final petBirthdayState = ref.read(petBirthdayProvider);

      // Validate all data is present
      if (petNameState.petName == null || petBirthdayState.month == null ||
          petBirthdayState.day == null || petBirthdayState.year == null ||
          state.gender == null) {
        throw Exception('Please complete all pet information');
      }

      // Format birthday as YYYY-MM-DD
      final formattedBirthday = _formatBirthday(
          petBirthdayState.year!,
          petBirthdayState.month!,
          petBirthdayState.day!
      );

      ref.read(loggerProvider).i('🎯 FINAL PET API CALL:');
      ref.read(loggerProvider).i('Name: ${petNameState.petName}');
      ref.read(loggerProvider).i('Birthday: $formattedBirthday');
      ref.read(loggerProvider).i('Gender: ${state.gender}');

      // FINAL API CALL to create pet with all data
      final petService = ref.read(petServiceProvider);
      final response = await petService.createPet(
        name: petNameState.petName!,
        birthday: formattedBirthday,
        gender: state.gender!,
        profilePictureID: 'default-profile', // You can update this later
      );

      ref.read(loggerProvider).i('✅ PET CREATED SUCCESSFULLY: $response');

      // Save pet data locally
      await _savePetDataLocally(
        petNameState.petName!,
        formattedBirthday,
        state.gender!,
      );

      state = state.copyWith(loading: false);

      // Navigate to next screen after successful API call
      _navigateToNextScreen();

    } catch (e) {
      if (!_isDisposed) {
        _navigateToNextScreen();
        final errorMessage = 'Failed to save pet: ${e.toString().replaceFirst('Exception: ', '')}';
        state = state.copyWith(
          loading: false,
          errorMessage: errorMessage,
        );
        ref.read(loggerProvider).e('❌ Error in savePetAndNavigate: $errorMessage');
      }
    }
  }

  String _formatBirthday(String year, String month, String day) {
    final formattedMonth = month.length == 1 ? '0$month' : month;
    final formattedDay = day.length == 1 ? '0$day' : day;
    return '$year-$formattedMonth-$formattedDay';
  }

  Future<void> _savePetDataLocally(
      String name,
      String birthday,
      String gender
      ) async {
    try {
      final sharedPreferencesService = ref.read(sharedPreferencesServiceProvider);
      await sharedPreferencesService.setPetName(name);
      await sharedPreferencesService.setPetBirthday(birthday);
      await sharedPreferencesService.setPetGender(gender);
      ref.read(loggerProvider).i('💾 Pet data saved locally');
    } catch (e) {
      ref.read(loggerProvider).e('Error saving pet data locally: $e');
    }
  }

  void _navigateToNextScreen() {
    try {
      // Navigate to next screen after successful pet creation
      ref.read(navigationServiceProvider).pushNamed(RoutePaths.describeYourSelfScreen);
      ref.read(loggerProvider).i('➡️ Navigation to next screen triggered');
    } catch (e) {
      ref.read(loggerProvider).e('Navigation error: $e');
    }
  }

  void clearError() {
    if (_isDisposed) return;
    state = state.copyWith(errorMessage: null);
  }
}