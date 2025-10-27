// services/validation_service.dart
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../logger/log_handler.dart';
import '../provider.dart';

class ValidationService {
  ValidationService(this.ref);

  final Ref ref;

  static const String _baseUrl = 'http://whiskers-dev.onesol.in:8000/functions/v1';

// services/validation_service.dart
  Future<Map<String, dynamic>> validateImages(List<File> images) async {
    try {
      final logger = ref.read(loggerProvider);
      final sharedPreferencesService = ref.read(sharedPreferencesServiceProvider);

      // Get the access token from shared preferences
      final accessToken = await sharedPreferencesService.getAccessToken();

      if (accessToken == null || accessToken.isEmpty) {
        throw Exception('No access token found. Please login again.');
      }

      logger.i('🖼️ Validating ${images.length} images');

      // Convert images to base64 (skip if empty array)
      final List<String> base64Images = [];
      for (int i = 0; i < images.length; i++) {
        final file = images[i];
        if (await file.exists()) {
          final bytes = await file.readAsBytes();
          final base64Image = base64Encode(bytes);
          base64Images.add(base64Image);
          logger.i('   Image $i: ${file.path} (${bytes.length} bytes)');
        } else {
          throw Exception('Image file not found: ${file.path}');
        }
      }

      // Note: We don't throw exception for empty array anymore
      // This allows the API to be called with [] for default images
      logger.i('📤 Sending validation request with ${base64Images.length} images');

      final response = await http.post(
        Uri.parse('$_baseUrl/validation'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: json.encode({
          'image': base64Images, // This will be [] for default images
        }),
      ).timeout(const Duration(seconds: 30));

      logger.i('📡 Validation API Response Status: ${response.statusCode}');
      logger.i('📦 Validation API Response Body: ${response.body}');

      // Handle different status codes
      return _handleResponse(response);

    } catch (e) {
      ref.read(loggerProvider).e('💥 Error validating images: $e');

      // Handle specific error types
      if (e is http.ClientException) {
        throw Exception('Network error: Please check your internet connection');
      } else if (e is SocketException) {
        throw Exception('Connection failed: Unable to reach the server');
      } else if (e is FormatException) {
        throw Exception('Invalid response format from server');
      } else {
        rethrow;
      }
    }
  }
  Map<String, dynamic> _handleResponse(http.Response response) {
    final logger = ref.read(loggerProvider);

    switch (response.statusCode) {
      case 200:
      // Success case
        final responseData = json.decode(response.body);

        // Check if there's an error in the response data
        if (responseData['error'] != null) {
          final errorMessage = responseData['error'] ?? 'Validation failed';
          logger.e('❌ Validation failed with error: $errorMessage');
          throw Exception(errorMessage);
        }

        // Check if we have the expected success data structure
        if (responseData['data'] != null) {
          logger.i('✅ Image validation successful with data: ${responseData['data']}');
          return responseData;
        } else {
          logger.i('✅ Image validation successful: $responseData');
          return responseData;
        }

      case 201:
      // Created successfully
        final responseData = json.decode(response.body);
        logger.i('✅ Image validation completed successfully: $responseData');
        return responseData;

      case 400:
      // Bad Request
        final errorBody = response.body.isNotEmpty ? json.decode(response.body) : {};
        final errorMessage = errorBody['msg'] ?? errorBody['message'] ?? errorBody['error'] ?? 'Invalid request. Please check your images.';
        logger.e('❌ Bad Request (400): $errorMessage');
        throw Exception(errorMessage);

      case 401:
      // Unauthorized
        throw Exception('Session expired. Please login again.');

      case 403:
      // Forbidden
        throw Exception('Access denied. Please check your permissions.');

      case 404:
      // Not Found
        throw Exception('Validation service not found.');

      case 408:
      // Request Timeout
        throw Exception('Request timeout. Please try again.');

      case 413:
      // Payload Too Large
        throw Exception('Images are too large. Please use smaller images.');

      case 415:
      // Unsupported Media Type
        throw Exception('Unsupported image format. Please use JPG or PNG images.');

      case 429:
      // Too Many Requests
        throw Exception('Too many requests. Please wait and try again.');

      case 500:
      // Internal Server Error
        final errorBody = response.body.isNotEmpty ? json.decode(response.body) : {};
        final errorMessage = errorBody['msg'] ?? errorBody['message'] ?? errorBody['error'] ?? 'Server error. Please try again later.';
        logger.e('❌ Server Error (500): $errorMessage');

        // Check for specific server errors
        if (errorMessage.contains('operation canceled') || errorMessage.contains('Interrupted')) {
          throw Exception('Server processing was interrupted. Please try again with smaller images.');
        } else if (errorMessage.contains('timeout') || errorMessage.contains('timed out')) {
          throw Exception('Server timeout. Please try again.');
        } else {
          throw Exception('Server error: $errorMessage');
        }

      case 502:
      // Bad Gateway
        throw Exception('Server is temporarily unavailable. Please try again later.');

      case 503:
      // Service Unavailable
        throw Exception('Service is temporarily unavailable. Please try again later.');

      default:
      // Other status codes
        final errorBody = response.body.isNotEmpty ? json.decode(response.body) : {};
        final errorMessage = errorBody['msg'] ?? errorBody['message'] ?? errorBody['error'] ?? 'Unexpected error occurred. Status: ${response.statusCode}';
        logger.e('❌ Unexpected Error (${response.statusCode}): $errorMessage');
        throw Exception(errorMessage);
    }
  }
}

// Provider for ValidationService
final validationServiceProvider = Provider<ValidationService>((ref) {
  return ValidationService(ref);
});