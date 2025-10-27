// birthday_viewmodel.dart
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../common_utility/common_utility.dart';
import '../../provider.dart';
import '../../services/UserService.dart';

class BirthdayViewModel {
  BirthdayViewModel(this.ref);

  final Ref ref;

  // State variables
  bool _loading = false;
  String? _errorMessage;

  // Getters for state
  bool get loading => _loading;
  String? get errorMessage => _errorMessage;

  Future<void> saveBirthdayAndNavigate({
    required String month,
    required String day,
    required String year,
  }) async {
    _setLoading(true);
    _setError(null);

    try {
      // Format birthday as YYYY-MM-DD
      final formattedBirthday = _formatBirthday(year, month, day);

      // Get user name from shared preferences
        final sharedPreferencesService = ref.read(sharedPreferencesServiceProvider);
        final userEmail = await sharedPreferencesService.getUserEmail();
      final userName = _extractUserNameFromEmail(userEmail);

      ref.read(loggerProvider).i('Calling API with - Name: $userName, Birthday: $formattedBirthday');

      // Call API to create user
      final userService = ref.read(userServiceProvider);
      final response = await userService.createUser(
        name: userName,
        birthday: formattedBirthday,
      );

      ref.read(loggerProvider).i('API Response: $response');

      // Save birthday locally as well
      await _saveBirthdayLocally(formattedBirthday);

      _setLoading(false);

      // Navigate to next screen after successful API call
      _navigateToPetTypeScreen();

    } catch (e) {
      _setLoading(false);

      final errorMessage = e.toString().contains('No access token')
          ? 'Session expired. Please login again.'
          : 'Failed to save birthday: ${e.toString().replaceFirst('Exception: ', '')}';

      _setError(errorMessage);
      ref.read(loggerProvider).e('Error in saveBirthdayAndNavigate: $errorMessage');
    }
  }

  String _formatBirthday(String year, String month, String day) {
    final formattedMonth = month.length == 1 ? '0$month' : month;
    final formattedDay = day.length == 1 ? '0$day' : day;
    return '$year-$formattedMonth-$formattedDay';
  }

  String _extractUserNameFromEmail(String? email) {
    if (email == null || email.isEmpty) return 'User';
    try {
      final namePart = email.split('@').first;
      if (namePart.isEmpty) return 'User';
      return namePart[0].toUpperCase() + namePart.substring(1);
    } catch (e) {
      return 'User';
    }
  }

  Future<void> _saveBirthdayLocally(String birthday) async {
    try {
      final sharedPreferencesService = ref.read(sharedPreferencesServiceProvider);
      await sharedPreferencesService.setUserBirthday(birthday);
    } catch (e) {
      ref.read(loggerProvider).e('Error saving birthday locally: $e');
    }
  }

  void _navigateToPetTypeScreen() {
    try {
      ref.read(navigationServiceProvider).pushNamed(RoutePaths.selectPetScreen);
    } catch (e) {
      ref.read(loggerProvider).e('Navigation error: $e');
    }
  }

  bool validateBirthday(String? month, String? day, String? year) {
    if (month == null || day == null || year == null) return false;

    try {
      final formattedMonth = month.length == 1 ? '0$month' : month;
      final formattedDay = day.length == 1 ? '0$day' : day;
      final date = DateTime.parse('$year-$formattedMonth-$formattedDay');
      final now = DateTime.now();

      return !date.isAfter(now) && int.parse(year) >= 1900;
    } catch (e) {
      return false;
    }
  }

  void clearError() {
    _setError(null);
  }

  // Keep old method for compatibility
  void saveBirthday(String month, String day, String year) {
    final birthday = '$month/$day/$year';
    ref.read(loggerProvider).i('Birthday saved: $birthday');
  }

  void navigateToPetTypeScreen() {
    _navigateToPetTypeScreen();
  }

  // Private methods to update state
  void _setLoading(bool loading) {
    _loading = loading;
    // Notify listeners if needed (though with AutoDisposeProvider, we'll rely on widget rebuilds)
  }

  void _setError(String? error) {
    _errorMessage = error;
    // Notify listeners if needed
  }
}