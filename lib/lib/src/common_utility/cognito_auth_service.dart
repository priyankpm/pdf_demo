import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CognitoService {
  // The private constructor now initializes _userPool.
  CognitoService._privateConstructor()
      : _userPool = CognitoUserPool(_userPoolId, _clientId);

  static final CognitoService _instance = CognitoService._privateConstructor();

  factory CognitoService() => _instance;

  final FlutterAppAuth _appAuth = FlutterAppAuth();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  // Made these static const as they are fixed values for the service.
  static const String _clientId = '6dvu2e8uh6je8m16cf62lts0ff';
  static const String _userPoolId = 'us-east-1_Fj6lOPatV';

  // Other configuration values
  final String _redirectUrl = 'iconCloudfrontCognitoSign-in://';
  final String _issuer =
      'https://cognito-idp.us-east-1.amazonaws.com/$_userPoolId';
  final List<String> _scopes = ['openid', 'email', 'profile'];

  // This is now correctly initialized by the constructor.
  final CognitoUserPool _userPool;

  /// Signs up a new user with email, name, and password.
  Future<bool> signUp(String email, String password, String name) async {
    try {
      final userAttributes = [
        AttributeArg(name: 'name', value: name),
        AttributeArg(name: 'email', value: email),
      ];
      CognitoUserPoolData pool = await _userPool.signUp(email, password, userAttributes: userAttributes);
      print(pool.user.username);
      // You might want to return the CognitoUser object or handle confirmation here
      return true;
    } on CognitoClientException catch (e) {
      // Handle specific Cognito errors, e.g., UserExistsException
      print('Cognito sign-up failed: ${e.message}');
      return false;
    } catch (e) {
      print('Sign-up failed: $e');
      return false;
    }
  }

  Future<AuthorizationTokenResponse?> signInWithSocial() async {
    try {
      return await _appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          _clientId,
          _redirectUrl,
          issuer: _issuer,
          scopes: ['openid', 'profile', 'email'],
          promptValues: ['login'],
        ),
      );
    } catch (e) {
      print('Sign-in failed: $e');
      return null;
    }
  }

  Future<TokenResponse?> refreshSession() async {
    try {
      final String? refreshToken =
      await _secureStorage.read(key: 'refresh_token');

      if (refreshToken == null) {
        print('No refresh token found');
        return null;
      }

      final TokenResponse? result = await _appAuth.token(
        TokenRequest(
          _clientId,
          _redirectUrl,
          issuer: _issuer,
          refreshToken: refreshToken,
          scopes: _scopes,
        ),
      );

      if (result != null) {
        await _secureStorage.write(
            key: 'access_token', value: result.accessToken);
        await _secureStorage.write(key: 'id_token', value: result.idToken);
        if (result.refreshToken != null) {
          await _secureStorage.write(
              key: 'refresh_token', value: result.refreshToken);
        }
      }

      return result;
    } catch (e) {
      print('Refresh session failed: $e');
      return null;
    }
  }

  Future<void> signOut() async {
    await _secureStorage.deleteAll();
  }

  Future<String?> createInitialRecord(String email, String password) async {
    print('Authenticating User...');
    final userPool = CognitoUserPool(_userPoolId, _clientId);
    final cognitoUser = CognitoUser(email, userPool);
    final authDetails = AuthenticationDetails(
      username: email,
      password: password,
    );

    try {
      final session = await cognitoUser.authenticateUser(authDetails);
      print('Login Success...');
      return session?.idToken.jwtToken;
    } on CognitoUserConfirmationNecessaryException catch (_) {
      print('User not confirmed. Please verify your email.');
    } on CognitoUserNewPasswordRequiredException catch (_) {
      print('New password required.');
    } on CognitoUserMfaRequiredException catch (_) {
      print('MFA required.');
    } on CognitoClientException catch (e) {
      print('CognitoClientException: ${e.message}');
    } catch (e) {
      print('Unexpected error: $e');
    }

    return null;
  }
}