import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../common_utility/common_utility.dart';
import '../../models/login_model.dart';
import '../../provider.dart';

class LoginViewModel extends StateNotifier<LoginModel> {
  LoginViewModel(this.ref) : super(LoginModel());

  final Ref ref;
  bool _isDisposed = false;

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  void updateEmail(String email) {
    if (_isDisposed) return;
    state = state.copyWith(email: email, errorMessage: null);
  }

  void updatePassword(String password) {
    if (_isDisposed) return;
    state = state.copyWith(password: password, errorMessage: null);
  }

  Future<void> login() async {
    if (_isDisposed) return;

    state = state.copyWith(loading: true, errorMessage: null);

    try {
      final AuthResponse res = await Supabase.instance.client.auth.signInWithPassword(
        email: state.email!.trim(),
        password: state.password!.trim(),
      );

      if (res.user != null) {
        // Store login data first
        await _storeLoginData(res);

        // Update state with success
        state = state.copyWith(
          loading: false,
          response: res,
        );

        // Add a small delay to ensure state is updated before navigation
        await Future.delayed(const Duration(milliseconds: 100));

        // Navigate to next screen
        _navigateToNextScreen();

      }
    } on AuthException catch (e) {
      if (!_isDisposed) {
        state = state.copyWith(loading: false, errorMessage: e.message);
      }
    } catch (e) {
      if (!_isDisposed) {
        state = state.copyWith(loading: false, errorMessage: 'Unexpected error: $e');
      }
    }
  }

// In LoginViewModel - update _storeLoginData method
  Future<void> _storeLoginData(AuthResponse res) async {
    print(res);
    try {
      final sharedPreferencesService = ref.read(sharedPreferencesServiceProvider);

      // Store tokens
      if (res.session?.accessToken != null) {
        await sharedPreferencesService.setAccessToken(res.session!.accessToken);
      }
      if (res.session?.refreshToken != null) {
        await sharedPreferencesService.setRefreshToken(res.session!.refreshToken!);
      }

      // Store user data
      if (res.user != null) {
        await sharedPreferencesService.setUserEmail(res.user!.email ?? '');
        await sharedPreferencesService.setUserId(res.user!.id);
        await sharedPreferencesService.setLoggedIn(true);

        // Extract and store user name from email
        final userEmail = res.user!.email ?? '';
        final userName = _extractUserNameFromEmail(userEmail);
        await sharedPreferencesService.setUserName(userName);

        ref.read(loggerProvider).i('Stored user name: $userName from email: $userEmail');
      }

      ref.read(loggerProvider).i('Login data stored successfully');

    } catch (e) {
      ref.read(loggerProvider).e('Error storing login data: $e');
    }
  }

// Add this helper method to LoginViewModel
  String _extractUserNameFromEmail(String email) {
    if (email.isEmpty) return 'User';

    try {
      // Extract the part before @ symbol
      final namePart = email.split('@').first;
      if (namePart.isEmpty) return 'User';

      // Capitalize first letter
      return namePart[0].toUpperCase() + namePart.substring(1);
    } catch (e) {
      return 'User';
    }
  }
// Add this helper method to LoginViewModel
  void _navigateToNextScreen() {
    try {
      ref.read(navigationServiceProvider).pushNamedAndRemoveUntil(
        RoutePaths.birthdayScreen, // Remove all previous routes
      );
      ref.read(loggerProvider).i('Navigation to birthday screen triggered');
    } catch (e) {
      ref.read(loggerProvider).e('Navigation error: $e');
      // Fallback navigation
      _fallbackNavigation();
    }
  }

  void _fallbackNavigation() {
    // Try alternative navigation method
    try {
      final navigatorKey = ref.read(navigationServiceProvider).navigatorKey;
      navigatorKey.currentState?.pushNamedAndRemoveUntil(
        RoutePaths.birthdayScreen,
            (route) => false,
      );
    } catch (e) {
      ref.read(loggerProvider).e('Fallback navigation also failed: $e');
    }
  }

  void clearError() {
    if (_isDisposed) return;
    state = state.copyWith(errorMessage: null);
  }
}