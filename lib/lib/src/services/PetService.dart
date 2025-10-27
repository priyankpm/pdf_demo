// services/pet_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../logger/log_handler.dart';
import '../provider.dart';

class PetService {
  PetService(this.ref);

  final Ref ref;

  static const String _baseUrl = 'http://whiskers-dev.onesol.in:8000/functions/v1';

  Future<Map<String, dynamic>> createPet({
    required String name,
    required String birthday,
    required String gender,
    required String profilePictureID,
  }) async {
    try {
      final logger = ref.read(loggerProvider);
      final sharedPreferencesService = ref.read(sharedPreferencesServiceProvider);

      // Get the access token and user ID from shared preferences
      final accessToken = await sharedPreferencesService.getAccessToken();
      final userId = await sharedPreferencesService.getUserId();

      if (accessToken == null || accessToken.isEmpty) {
        throw Exception('No access token found. Please login again.');
      }

      if (userId == null || userId.isEmpty) {
        throw Exception('User ID not found. Please login again.');
      }

      logger.i('🐾 Creating/Updating pet for User ID: $userId');
      logger.i('   Name: $name');
      logger.i('   Birthday: $birthday');
      logger.i('   Gender: $gender');
      logger.i('   ProfilePictureID: $profilePictureID');

      // Match exactly with your curl command - PATCH with user ID in URL
      final response = await http.patch(
        Uri.parse('$_baseUrl/pet/$userId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: json.encode({
          'Name': name,
          'Birthday': birthday,
          'ProfilePictureID': profilePictureID,
          'Gender': gender,
        }),
      );

      logger.i('📡 Pet API Response Status: ${response.statusCode}');
      logger.i('📦 Pet API Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = json.decode(response.body);
        logger.i('✅ Pet created/updated successfully: $responseData');
        return responseData;
      } else {
        // Handle specific error cases
        if (response.statusCode == 500) {
          // Server error - might be temporary
          logger.e('❌ Server error (500). This might be a temporary issue.');
          throw Exception('Server is experiencing issues. Please try again in a few moments.');
        } else {
          final errorBody = response.body.isNotEmpty ? json.decode(response.body) : {};
          final errorMessage = errorBody['message'] ?? errorBody['error'] ?? 'Failed to create pet. Status: ${response.statusCode}';
          logger.e('❌ Pet API Error: ${response.statusCode} - $errorMessage');
          throw Exception(errorMessage);
        }
      }
    } catch (e) {
      ref.read(loggerProvider).e('💥 Error creating/updating pet: $e');
      rethrow;
    }
  }
}

// Provider for PetService
final petServiceProvider = Provider<PetService>((ref) {
  return PetService(ref);
});