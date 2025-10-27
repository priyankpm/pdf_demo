import 'dart:io';

import 'package:oauth2/oauth2.dart' as oauth2;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

/// Wrapper for handling OAuth2 flows.
class OAuth2Client {
  final Uri tokenEndpoint;
  final String clientId;
  final String? clientSecret;

  static const _storage = FlutterSecureStorage();
  static const _credKey = 'oauth2_credentials';

  oauth2.Client? _client;

  OAuth2Client({
    required this.tokenEndpoint,
    required this.clientId,
    this.clientSecret,
  });

  /// Get current client (throws if not authenticated)
  oauth2.Client get client {
    if (_client == null) {
      throw StateError('OAuth2 client not initialized');
    }
    return _client!;
  }

  /// Perform password grant authentication
  Future<void> authenticateWithPassword(String username, String password) async {
    _client = await oauth2.resourceOwnerPasswordGrant(
      tokenEndpoint,
      username,
      password,
      identifier: clientId,
      secret: clientSecret,
      httpClient: _JsonHttpClient(), // Fixes Flutter web CORS issues
    );

    await _saveCredentials(_client?.credentials);
  }

  /// Load credentials from secure storage
  Future<bool> tryLoadCredentials() async {
    final json = await _storage.read(key: _credKey);
    if (json == null) return false;

    final credentials = oauth2.Credentials.fromJson(json);

    if (credentials.isExpired) return false;

    _client = oauth2.Client(credentials, identifier: clientId, secret: clientSecret);
    return true;
  }

  /// Refresh and persist credentials
  Future<void> refreshTokenIfNeeded() async {
    if (_client == null) return;

    if (_client!.credentials.isExpired) {
      if (_client!.credentials.canRefresh) {
        _client = await _client!.refreshCredentials();
        await _saveCredentials(_client!.credentials);
      } else {
        await logout();
        throw Exception('Token expired and cannot be refreshed');
      }
    }
  }

  Future<void> logout() async {
    _client = null;
    await _storage.delete(key: _credKey);
  }

  Future<void> _saveCredentials(oauth2.Credentials? credentials) async {
    await _storage.write(key: _credKey, value: credentials?.toJson());
  }
}

class _JsonHttpClient extends http.BaseClient {
  final _inner = http.Client();

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers[HttpHeaders.contentTypeHeader] = 'application/x-www-form-urlencoded';
    return _inner.send(request);
  }
}
