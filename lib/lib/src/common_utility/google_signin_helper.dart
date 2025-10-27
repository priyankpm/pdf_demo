import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInHelper {
  static final GoogleSignInHelper _instance = GoogleSignInHelper._internal();

  factory GoogleSignInHelper() => _instance;

  GoogleSignInHelper._internal();

  GoogleSignInAccount? _currentUser;
  bool _isAuthorized = false;

  final List<String> _scopes = [
    'https://www.googleapis.com/auth/contacts.readonly',
  ];

  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  Future<void> init({String? clientId, String? serverClientId}) async {
    await _googleSignIn.initialize(
      clientId: clientId,
      serverClientId: serverClientId,
    );

    _googleSignIn.authenticationEvents.listen(_handleAuthEvent).onError(
      _handleError,
    );

    await _googleSignIn.attemptLightweightAuthentication();
  }

  GoogleSignInAccount? get currentUser => _currentUser;

  bool get isAuthorized => _isAuthorized;

  Future<void> signIn() async {
    if (_googleSignIn.supportsAuthenticate()) {
      await _googleSignIn.authenticate();
    } else {
      throw Exception('Platform does not support Google Sign-In');
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.disconnect();
  }

  Future<GoogleSignInClientAuthorization?> authorizeScopes() async {
    if (_currentUser == null) return null;
    final auth =
    await _currentUser!.authorizationClient.authorizeScopes(_scopes);
    _isAuthorized = auth != null;
    return auth;
  }

  Future<String?> getAccessToken() async {
    final headers =
    await _currentUser?.authorizationClient.authorizationHeaders(_scopes);
    return headers?['Authorization'];
  }

  void _handleAuthEvent(GoogleSignInAuthenticationEvent event) async {
    final user = switch (event) {
    GoogleSignInAuthenticationEventSignIn() => event.user,
    GoogleSignInAuthenticationEventSignOut() => null,
    };

    _currentUser = user;
    _isAuthorized =
    user != null && await user.authorizationClient.authorizationForScopes(_scopes) != null;
  }

  void _handleError(Object e) {
    _currentUser = null;
    _isAuthorized = false;
    debugPrint('GoogleSignIn error: $e');
  }
}
