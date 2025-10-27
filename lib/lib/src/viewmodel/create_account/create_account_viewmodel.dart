import 'dart:convert';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:whiskers_flutter_app/src/provider.dart';
import 'package:whiskers_flutter_app/src/viewmodel/base_viewmodel.dart';

import '../../common_utility/common_utility.dart';
import '../../common_utility/google_signin_helper.dart';
import '../../logger/log_handler.dart';
import '../../models/create_account_model.dart';

class CreateAccountViewModel extends BaseViewModel<CreateAccountModel> {
  CreateAccountViewModel(this.ref)
    : logger = ref.read(loggerProvider),
      super(
        CreateAccountModel(
          email: '',
          fullName: '',
          password: '',
          phoneNumber: '',
          userId: '',
        ),
      );

  final Ref ref;
  final GoogleSignInHelper googleSignInHelper = GoogleSignInHelper();
  final Logger logger;

  @override
  Future<void> init({String docId = ''}) {
    // TODO: implement init
    throw UnimplementedError();
  }

  @override
  void notifyChanges(CreateAccountModel model) {
    if (mounted) {
      state = model;
    }
  }

  Future<void> loggedInUsingGoogle() async {
    try {
      final result = await ref
          .read(cognitoAuthServiceProvider)
          .signInWithSocial();

      if (result != null) {
        final idToken = result.idToken;
        final accessToken = result.accessToken;
        final refreshToken = result.refreshToken;

        final claims = parseJwt(idToken!);

        final model = CreateAccountModel(
          email: claims['email'] ?? '',
          fullName: claims['name'] ?? '',
          password: '',
          phoneNumber: '',
          userId: claims['sub'] ?? '',
        );
        notifyChanges(model);
        await saveDetailsInSharePref();

        final prefs = await ref.read(sharedPreferencesProvider.future);
        await prefs.addString('access_token', accessToken ?? '');
        await prefs.addString('id_token', idToken);
        if (refreshToken != null) {
          await prefs.addString('refresh_token', refreshToken);
        }
      }
    } catch (e, st) {
      logger.e("Cognito sign-in error", error: e, stackTrace: st);
    }
  }

  Future<void> refreshSessionIfNeeded() async {
    final prefs = await ref.read(sharedPreferencesProvider.future);
    final idToken = prefs.getStringValue('id_token');
    final accessToken = prefs.getStringValue('access_token');
    final refreshToken = prefs.getStringValue('refresh_token');

    if (accessToken != null && !isJwtExpired(accessToken)) {
      logger.d("Access token still valid");
      return;
    }

    logger.d("Access token expired. Attempting refresh...");

    try {
      final newSession = await ref
          .read(cognitoAuthServiceProvider)
          .refreshSession();

      if (newSession != null) {
        final newIdToken = newSession.idToken;
        final newAccessToken = newSession.accessToken;
        await prefs.addString('access_token', newAccessToken ?? '');
        await prefs.addString('id_token', newIdToken ?? '');
        logger.d("Token refresh successful");
      }
    } catch (e, st) {
      logger.e("Token refresh failed", error: e, stackTrace: st);
    }
  }

  String sanitizedUsername(String fullName) {
    return fullName
        .trim()
        .replaceAll(RegExp(r'\s+'), '_')   // Replace spaces with underscore
        .replaceAll(RegExp(r'[^a-zA-Z0-9_@.-]'), ''); // Remove invalid characters
  }


  Future<bool> enteredManualDetails(
    String fullName,
    String password,
    String emailOrPhone,
    bool isPhoneNumber,
  ) async {
    if (isPhoneNumber) {
      logger.e("Phone number sign-up is not implemented in this example.");
      return false;
    }
    fullName = sanitizedUsername(fullName);

    // Create the model for local state
    CreateAccountModel model = CreateAccountModel(
      email: emailOrPhone,
      fullName: fullName,
      password: password,
      phoneNumber: '',
      userId: '', // This will be set by Cognito upon successful sign-up
    );
    notifyChanges(model);

    // Call the sign-up service
    try {
      final cognitoService = ref.read(cognitoAuthServiceProvider);
      final success = await cognitoService.signUp(
        fullName,
        emailOrPhone,
        password,
      );

      if (success) {
        logger.d("Sign-up successful. User needs to confirm their account.");
        await saveDetailsInSharePref();
        ref
            .read(navigationServiceProvider)
            .pushReplacementNamed(RoutePaths.profileScreen);
        return true;
      } else {
        logger.e("Sign-up failed in the view model.");
        return false;
      }
    } catch (e, st) {
      logger.e("Error during manual sign-up", error: e, stackTrace: st);
      return false;
    }
  }

  Future<void> saveDetailsInSharePref() async {
    final AppSharedPref pref = await ref.read(sharedPreferencesProvider.future);
    pref.clear();
    await Future.wait([
      pref.addString(userFullName, state.fullName ?? ''),
      pref.addString(email, state.email ?? ''),
    ]);
  }

  Map<String, dynamic> parseJwt(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      throw Exception('Invalid JWT token');
    }

    final payload = _decodeBase64(parts[1]);
    final payloadMap = json.decode(payload);

    if (payloadMap is! Map<String, dynamic>) {
      throw Exception('Invalid JWT payload');
    }

    return payloadMap;
  }

  String _decodeBase64(String str) {
    String output = str.replaceAll('-', '+').replaceAll('_', '/');
    while (output.length % 4 != 0) {
      output += '=';
    }
    return utf8.decode(base64Url.decode(output));
  }

  bool isJwtExpired(String token) {
    final claims = parseJwt(token);
    final expiry = claims['exp'];

    if (expiry == null) return true;

    final expiryDate = DateTime.fromMillisecondsSinceEpoch(expiry * 1000);
    return DateTime.now().isAfter(expiryDate);
  }
}
