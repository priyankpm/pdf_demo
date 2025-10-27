// services/user_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../logger/log_handler.dart';
import '../provider.dart';

class UserService {
  UserService(this.ref);

  final Ref ref;

  static const String _baseUrl = 'http://whiskers-dev.onesol.in:8000/functions/v1';

  Future<Map<String, dynamic>> createUser({
    required String name,
    required String birthday,
  }) async {
    try {
      final logger = ref.read(loggerProvider);
      final sharedPreferencesService = ref.read(sharedPreferencesServiceProvider);

      // Get the access token from shared preferences
      final accessToken = await sharedPreferencesService.getAccessToken();

      logger.i('Access Token: $accessToken');

      if (accessToken == null || accessToken.isEmpty) {
        throw Exception('No access token found. Please login again.');
      }

      logger.i('Creating user with name: $name, birthday: $birthday');

      final response = await http.patch(
        Uri.parse('$_baseUrl/user'),
        headers: {
          'Content-Type': 'application/json',
            'Authorization': 'Bearer $accessToken',
        },
        body: json.encode({
          'Name': name,
          'Birthday': birthday,
        }),
      );

      logger.i('API Response Status: ${response.statusCode}');
      logger.i('API Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = json.decode(response.body);
        logger.i('User created successfully: $responseData');
        return responseData;
      } else {
        final errorBody = response.body.isNotEmpty ? json.decode(response.body) : {};
        final errorMessage = errorBody['message'] ?? errorBody['error'] ?? 'Failed to create user. Status: ${response.statusCode}';
        logger.e('API Error: ${response.statusCode} - $errorMessage');
        throw Exception(errorMessage);
      }
    } catch (e) {
      ref.read(loggerProvider).e('Error creating user: $e');
      rethrow;
    }
  }
}

// Provider for UserService
final userServiceProvider = Provider<UserService>((ref) {
  return UserService(ref);
});