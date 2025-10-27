import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:whiskers_flutter_app/src/models/terms_accepted_model.dart';
import 'package:whiskers_flutter_app/src/provider.dart';
import 'package:whiskers_flutter_app/src/styles/resources.dart';
import 'package:whiskers_flutter_app/src/viewmodel/create_account/create_account_viewmodel.dart';
import 'package:whiskers_flutter_app/src/viewmodel/terms_and_condition_viewmodel.dart';
import 'package:whiskers_flutter_app/src/widgets/common_widgets/New/background_paws.dart';
import 'package:whiskers_flutter_app/src/widgets/common_widgets/New/continue_button.dart';

import '../../common_utility/common_utility.dart';
import '../../logger/log_handler.dart';
import '../common_widgets/sign_up_socials.dart';
import '../common_widgets/sign_up_widget.dart';
import '../common_widgets/terms_and_condition_widget.dart';

class CreateAccount extends ConsumerStatefulWidget {
  const CreateAccount({super.key});

  @override
  CreateAccountState createState() => CreateAccountState();
}

class CreateAccountState extends ConsumerState<CreateAccount> {
  late Resources res;
  late Logger logger;
  late TermsAndConditionViewModel termsAndConditionViewModel;
  late CreateAccountViewModel createAccountViewModel;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailPhoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); // Single form key for all fields

  final ScrollController scrollController = ScrollController();

  bool isPhoneNumberEntered = false;
  bool isLoading = false;
  bool obscurePassword = true;

  // Validation state variables
  bool isNameValid = false;
  bool isEmailPhoneValid = false;
  bool isPasswordValid = false;
  String nameError = '';
  String emailPhoneError = '';
  String passwordError = '';

  @override
  void initState() {
    super.initState();
    res = ref.read(resourceProvider);
    logger = ref.read(loggerProvider);
    createAccountViewModel = ref.read(createAccountProvider.notifier);
    termsAndConditionViewModel = ref.read(termsAndConditionProvider.notifier);

    // Add listeners for real-time validation
    nameController.addListener(_validateName);
    emailPhoneController.addListener(_validateEmailPhone);
    passwordController.addListener(_validatePassword);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(statusBarHandler).setStatusBarColor(res.themes.lightOrange);
    });
  }

  @override
  void dispose() {
    nameController.removeListener(_validateName);
    emailPhoneController.removeListener(_validateEmailPhone);
    passwordController.removeListener(_validatePassword);
    nameController.dispose();
    emailPhoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // Real-time validation methods
  void _validateName() {
    final value = nameController.text.trim();

    if (value.isEmpty) {
      setState(() {
        isNameValid = false;
        nameError = 'Please enter your full name';
      });
    } else if (value.length < 2) {
      setState(() {
        isNameValid = false;
        nameError = 'Name must be at least 2 characters';
      });
    } else {
      setState(() {
        isNameValid = true;
        nameError = '';
      });
    }
  }

  void _validateEmailPhone() {
    final value = emailPhoneController.text.trim();

    if (value.isEmpty) {
      setState(() {
        isEmailPhoneValid = false;
        emailPhoneError = 'Please enter email or phone number';
      });
    } else {
      // Email validation
      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      // Basic phone validation
      final phoneRegex = RegExp(r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$');

      if (!emailRegex.hasMatch(value) && !phoneRegex.hasMatch(value)) {
        setState(() {
          isEmailPhoneValid = false;
          emailPhoneError = 'Please enter a valid email or phone number';
        });
      } else {
        setState(() {
          isEmailPhoneValid = true;
          emailPhoneError = '';
        });
      }
    }
  }

  void _validatePassword() {
    final value = passwordController.text.trim();

    if (value.isEmpty) {
      setState(() {
        isPasswordValid = false;
        passwordError = 'Please enter password';
      });
    } else if (value.length < 6) {
      setState(() {
        isPasswordValid = false;
        passwordError = 'Password must be at least 6 characters';
      });
    } else if (!RegExp(r'[A-Za-z]').hasMatch(value) || !RegExp(r'[0-9]').hasMatch(value)) {
      setState(() {
        isPasswordValid = false;
        passwordError = 'Password should contain letters and numbers';
      });
    } else {
      setState(() {
        isPasswordValid = true;
        passwordError = '';
      });
    }
  }

  // Check if all fields are valid
  bool get _areAllFieldsValid {
    return isNameValid && isEmailPhoneValid && isPasswordValid && termsAndConditionViewModel.isTermsAccepted();
  }

  Future<void> _signUpWithSupabase() async {
    if (!_areAllFieldsValid) {
      // Force validation to show all errors
      _validateName();
      _validateEmailPhone();
      _validatePassword();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fix all errors before continuing"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final emailOrPhone = emailPhoneController.text.trim();
    final password = passwordController.text.trim();
    final fullName = nameController.text.trim();

    setState(() => isLoading = true);

    try {
      AuthResponse response;
      if (emailOrPhone.contains('@')) {
        response = await Supabase.instance.client.auth.signUp(
          email: emailOrPhone,
          password: password,
          data: {'full_name': fullName},
        );
      } else {
        response = await Supabase.instance.client.auth.signUp(
          phone: emailOrPhone,
          password: password,
          data: {'full_name': fullName},
        );
      }

      if (response.user != null) {
        final userId = response.user!.id;
        logger.d('User created: $userId');

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                response.session == null
                    ? "Account created! Please confirm your email."
                    : "Account created successfully!",
              ),
              backgroundColor: Colors.green,
            ),
          );
        }

        if (response.session != null) {
          ref.read(navigationServiceProvider).pushNamed(RoutePaths.describeYourSelfScreen);
        }
      }
    } on AuthException catch (e) {
      logger.e('Signup error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      logger.e('Unexpected error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An unexpected error occurred'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundPaws(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                const SizedBox(height: 40),
                Center(
                  child: Text(
                    "Create Account",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: res.themes.blackPure,
                    ),
                  ),
                ),
                const SizedBox(height: 25),

                // Name Field
                _buildNameField(),
                if (nameError.isNotEmpty) _buildErrorText(nameError),
                const SizedBox(height: 16),

                // Email/Phone Field
                _buildEmailPhoneField(),
                if (emailPhoneError.isNotEmpty) _buildErrorText(emailPhoneError),
                const SizedBox(height: 16),

                // Password Field with eye icon
                _buildPasswordField(),
                if (passwordError.isNotEmpty) _buildErrorText(passwordError),
                const SizedBox(height: 16),

                TermsAndConditionWidget((bool value) {
                  termsAndConditionViewModel.notifyChanges(
                    TermsAcceptedModel(
                      isTermsAccepted: !termsAndConditionViewModel.isTermsAccepted(),
                    ),
                  );
                  setState(() {}); // Rebuild to update button state
                }),

                SignUpWidget(
                  onSignUpPressed: () async {
                    await _signUpWithSupabase();
                  },
                  onJoinNowPressed: () {
                    ref.read(navigationServiceProvider).pushNamed(RoutePaths.loginScreen);
                  },
                  isLoading: isLoading,
                ),

                SignUpSocials(
                      () async {
                    logger.d('google callback');
                    ref.read(navigationServiceProvider).pushReplacementNamed(RoutePaths.uploadAudioScreen);
                  },
                      () {
                    logger.d('apple callback');
                    ref.read(navigationServiceProvider).pushReplacementNamed(RoutePaths.homeScreen);
                  },
                      () {
                    ref.read(navigationServiceProvider).pushNamed(RoutePaths.videoScreen);
                    logger.d('facebook callback');
                  },
                ),
                const SizedBox(height: 180),
                const SizedBox(height: 20),

                ContinueButton(
                  label: isLoading ? "Creating Account..." : "Continue",
                  onTap: _areAllFieldsValid && !isLoading ? _signUpWithSupabase : null,
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      controller: nameController,
      keyboardType: TextInputType.name,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        hintText: "Full Name",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: nameError.isNotEmpty ? Colors.red : res.themes.grey100,
          ),
        ),
        filled: true,
        fillColor: res.themes.fillsSmokeGrey,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: nameError.isNotEmpty ? Colors.red : res.themes.darkGolden,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red),
        ),
        hintStyle: TextStyle(color: res.themes.grey100),
      ),
      style: TextStyle(color: res.themes.black120),
    );
  }

  Widget _buildEmailPhoneField() {
    return TextFormField(
      controller: emailPhoneController,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        hintText: "Email or Phone Number",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: emailPhoneError.isNotEmpty ? Colors.red : Colors.transparent,
          ),
        ),
        filled: true,
        fillColor: res.themes.fillsSmokeGrey,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: emailPhoneError.isNotEmpty ? Colors.red : res.themes.darkGolden,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red),
        ),
        hintStyle: TextStyle(color: res.themes.grey100),
      ),
      style: TextStyle(color: res.themes.black120),
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: passwordController,
      obscureText: obscurePassword,
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        hintText: "Password",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: passwordError.isNotEmpty ? Colors.red : res.themes.grey100,
          ),
        ),
        filled: true,
        fillColor: res.themes.fillsSmokeGrey,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: passwordError.isNotEmpty ? Colors.red : res.themes.darkGolden,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red),
        ),
        hintStyle: TextStyle(color: res.themes.grey100),
        suffixIcon: IconButton(
          icon: Icon(
            obscurePassword ? Icons.visibility_off : Icons.visibility,
            color: res.themes.grey100,
          ),
          onPressed: () {
            setState(() {
              obscurePassword = !obscurePassword;
            });
          },
        ),
      ),
      style: TextStyle(color: res.themes.black120),
    );
  }

  Widget _buildErrorText(String error) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, top: 4),
      child: Text(
        error,
        style: TextStyle(
          color: Colors.red,
          fontSize: 12,
        ),
      ),
    );
  }
}