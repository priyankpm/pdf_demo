import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:whiskers_flutter_app/src/view/supabase_test_screen.dart';

import '../common_utility/common_utility.dart';
import '../logger/log_handler.dart';
import '../provider.dart';
import '../styles/resources.dart';
import '../viewmodel/login_screen/login_screen_viewmodel.dart';
import '../widgets/common_widgets/New/background_paws.dart';
import '../widgets/common_widgets/New/continue_button.dart';
import '../widgets/common_widgets/sign_up_socials.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends ConsumerState<LoginScreen> {
  late final Resources _res;
  late Logger _logger;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _responsePrinted = false;
  bool _obscurePassword = true;

  // Validation state variables
  bool _isEmailValid = false;
  bool _isPasswordValid = false;
  String _emailError = '';
  String _passwordError = '';
  bool _hasSubmitted = false;

  @override
  void initState() {
    super.initState();
    _logger = ref.read(loggerProvider);
    _logger.i('LoginScreenState: initState called');
    _res = ref.read(resourceProvider);

    // Add listeners for real-time validation
    _emailController.addListener(_validateEmail);
    _passwordController.addListener(_validatePassword);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(statusBarHandler).setStatusBarColor(_res.themes.lightOrange);
    });
  }

  @override
  void dispose() {
    _emailController.removeListener(_validateEmail);
    _passwordController.removeListener(_validatePassword);
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Real-time validation methods
  void _validateEmail() {
    final value = _emailController.text.trim();

    if (value.isEmpty) {
      setState(() {
        _isEmailValid = false;
        _emailError = 'Please enter your email';
      });
    } else {
      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      if (!emailRegex.hasMatch(value)) {
        setState(() {
          _isEmailValid = false;
          _emailError = 'Please enter a valid email address';
        });
      } else {
        setState(() {
          _isEmailValid = true;
          _emailError = '';
        });
      }
    }
  }

  void _validatePassword() {
    final value = _passwordController.text.trim();

    if (value.isEmpty) {
      setState(() {
        _isPasswordValid = false;
        _passwordError = 'Please enter your password';
      });
    } else if (value.length < 6) {
      setState(() {
        _isPasswordValid = false;
        _passwordError = 'Password must be at least 6 characters';
      });
    } else {
      setState(() {
        _isPasswordValid = true;
        _passwordError = '';
      });
    }
  }

  // Check if all fields are valid
  bool get _areAllFieldsValid {
    return _isEmailValid && _isPasswordValid;
  }

  @override
  Widget build(BuildContext context) {
    final loginViewModel = ref.read(loginProvider.notifier);
    final loginState = ref.watch(loginProvider);

    // Print response when available (only once)
    if (loginState.response != null && !_responsePrinted) {
      _responsePrinted = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _handleLoginResponse(loginState.response!);
      });
    }

    // Reset the flag when response is cleared (e.g., on new login attempt)
    if (loginState.response == null) {
      _responsePrinted = false;
    }

    return Scaffold(
      body: BackgroundPaws(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: ListView(
              children: [
                const SizedBox(height: 60),

                // Title
                Center(
                  child: Text(
                    "Welcome Back",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: _res.themes.blackPure,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    "Login to continue",
                    style: TextStyle(
                      fontSize: 16,
                      color: _res.themes.grey100,
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                // Email Field
                _buildEmailField(loginViewModel),
                if (_emailError.isNotEmpty && _hasSubmitted)
                  _buildErrorText(_emailError),
                const SizedBox(height: 16),

                // Password Field with eye icon
                _buildPasswordField(loginViewModel),
                if (_passwordError.isNotEmpty && _hasSubmitted)
                  _buildErrorText(_passwordError),
                const SizedBox(height: 8),

                // Forgot Password
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: _navigateToForgotPassword,
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(
                        color: _res.themes.darkGolden,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Error Message from API/ViewModel
                if (loginState.errorMessage != null)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _res.themes.red100.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: _res.themes.red100),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.error_outline, color: _res.themes.red100, size: 16),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            loginState.errorMessage!,
                            style: TextStyle(
                              color: _res.themes.red100,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                if (loginState.errorMessage != null) const SizedBox(height: 20),

                // Login Button
                ContinueButton(
                  label: loginState.loading ? "Logging in..." : "Login",
                  onTap: _areAllFieldsValid && !loginState.loading
                      ? () => _login(loginViewModel)
                      : null,
                ),
                const SizedBox(height: 30),

                // Social Login
                SignUpSocials(
                      () async {
                    _logger.d('google login callback');
                    // Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SupabaseTestScreen()));
                  },
                      () {
                    _logger.d('apple login callback');
                    // Implement Apple login
                  },
                      () {
                    _logger.d('facebook login callback');
                    // Implement Facebook login
                  },
                ),
                const SizedBox(height: 30),

                // Sign up redirect
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: TextStyle(
                        color: _res.themes.grey100,
                      ),
                    ),
                    GestureDetector(
                      onTap: _navigateToCreateAccount,
                      child: Text(
                        "Sign up",
                        style: TextStyle(
                          color: _res.themes.darkGolden,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmailField(LoginViewModel loginViewModel) {
    return TextField(
      controller: _emailController,
      decoration: InputDecoration(
        hintText: "Email Address",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: _emailError.isNotEmpty && _hasSubmitted
                ? Colors.red
                : _res.themes.grey100,
          ),
        ),
        filled: true,
        fillColor: _res.themes.fillsSmokeGrey,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: _emailError.isNotEmpty && _hasSubmitted
                ? Colors.red
                : _res.themes.darkGolden,
          ),
        ),
        hintStyle: TextStyle(color: _res.themes.grey100),
      ),
      style: TextStyle(color: _res.themes.black120),
      onChanged: (value) {
        loginViewModel.updateEmail(value);
        _validateEmail();
      },
      onTap: () {
        // Remove validation borders when user taps on field
        setState(() {
          _hasSubmitted = false;
        });
      },
      keyboardType: TextInputType.emailAddress,
    );
  }

  Widget _buildPasswordField(LoginViewModel loginViewModel) {
    return TextField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      decoration: InputDecoration(
        hintText: "Password",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: _passwordError.isNotEmpty && _hasSubmitted
                ? Colors.red
                : _res.themes.grey100,
          ),
        ),
        filled: true,
        fillColor: _res.themes.fillsSmokeGrey,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: _passwordError.isNotEmpty && _hasSubmitted
                ? Colors.red
                : _res.themes.darkGolden,
          ),
        ),
        hintStyle: TextStyle(color: _res.themes.grey100),
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility_off : Icons.visibility,
            color: _res.themes.grey100,
          ),
          onPressed: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
        ),
      ),
      style: TextStyle(color: _res.themes.black120),
      onChanged: (value) {
        loginViewModel.updatePassword(value);
        _validatePassword();
      },
      onTap: () {
        // Remove validation borders when user taps on field
        setState(() {
          _hasSubmitted = false;
        });
      },
    );
  }

  Widget _buildErrorText(String error) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, top: 4),
      child: Text(
        error,
        style: const TextStyle(
          color: Colors.red,
          fontSize: 12,
        ),
      ),
    );
  }

  void _login(LoginViewModel viewModel) {
    if (!mounted) return;

    // Set submitted to true to show all validation errors
    setState(() {
      _hasSubmitted = true;
    });

    // Force validation
    _validateEmail();
    _validatePassword();

    if (_areAllFieldsValid) {
      _logger.i('Login form validation passed');
      viewModel.login().then((response) {
        _logger.i('Login process completed');
      }).catchError((error) {
        _logger.e('Login error: $error');
        _responsePrinted = false; // Reset flag to allow retry
      });
    } else {
      _logger.w('Login form validation failed');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please fix the errors before submitting'),
          backgroundColor: _res.themes.red100,
        ),
      );
    }
  }

  void _navigateToCreateAccount() {
    ref.read(navigationServiceProvider).pushNamed(RoutePaths.createAccount);
  }

  void _navigateToForgotPassword() {
    _logger.d('Forgot password pressed');
    ref.read(navigationServiceProvider).pushNamed(RoutePaths.forgotPassword);
  }

  void _handleLoginResponse(dynamic response) {
    _logger.i('=== LOGIN RESPONSE ===');
    _logger.i('Response Type: ${response.runtimeType}');

    if (response != null && response is AuthResponse) {
      _logger.i('✅ AuthResponse detected');
      // Your existing response handling logic...
    }
    _logger.i('=== END LOGIN RESPONSE ===');
  }

  Future<void> _storeLoginData(
      String accessToken,
      String refreshToken,
      String userData,
      ) async {
    try {
      final sharedPreferencesService = ref.read(sharedPreferencesServiceProvider);
      await sharedPreferencesService.setAccessToken(accessToken);
      await sharedPreferencesService.setRefreshToken(refreshToken);
      await sharedPreferencesService.setUserData(userData);
      await sharedPreferencesService.setLoggedIn(true);
      _logger.i('Login data stored successfully in preferences');
      _navigateToHome();
    } catch (e) {
      _logger.e('Error storing login data: $e');
    }
  }

  void _navigateToHome() {
    if (!mounted) return;
    Navigator.of(context).pushNamedAndRemoveUntil(
      '/home',
          (route) => false,
    );
  }
}