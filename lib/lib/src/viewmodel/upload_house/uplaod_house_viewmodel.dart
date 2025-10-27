// viewmodels/upload_house_viewmodel.dart


import 'dart:io';
import 'dart:math' as logger show e;

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../common_utility/common_utility.dart';
import '../../provider.dart';
import '../../services/ValidationService.dart';

class UploadHouseViewModel extends StateNotifier<UploadHouseState> {
  UploadHouseViewModel(this.ref) : super(UploadHouseState());

  final Ref ref;
  bool _isDisposed = false;

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  Future<void> validateAndUploadImages(List<String> imagePaths, BuildContext context) async {
    if (_isDisposed) return;

    state = state.copyWith(loading: true, errorMessage: null);

    try {
      final logger = ref.read(loggerProvider);

      // Convert paths to File objects
      final imageFiles = imagePaths.map((path) => File(path)).toList();

      // Validate that all files exist
      for (int i = 0; i < imageFiles.length; i++) {
        if (!await imageFiles[i].exists()) {
          throw Exception('Image file not found: ${imageFiles[i].path}');
        }
      }

      logger.i('🖼️ Starting image validation for ${imageFiles.length} images');

      // Call validation API
      final validationService = ref.read(validationServiceProvider);
      final validationResponse = await validationService.validateImages(imageFiles);

      logger.i('✅ Image validation successful, proceeding with upload');

      // Store images in SharedPreferences
      final prefsService = ref.read(sharedPreferencesServiceProvider);
      await prefsService.storeBackgroundImages(imageFiles);

      // Store in background provider - IMPORTANT: Pass all images
      final backgroundNotifier = ref.read(backgroundImageProvider.notifier);
      backgroundNotifier.setBackgroundImages(imagePaths);

      state = state.copyWith(loading: false);

      // Navigate to next screen after successful validation and upload
      _navigateToPetUploadScreen();

    } catch (e) {
      if (!_isDisposed) {
        final errorMessage = _getUserFriendlyError(e);
        state = state.copyWith(
          loading: false,
          errorMessage: errorMessage,
        );

        // Show error to user
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }
  String _getUserFriendlyError(dynamic e) {
    final errorString = e.toString();

    if (errorString.contains('No access token')) {
      return 'Session expired. Please login again.';
    } else if (errorString.contains('Image file not found')) {
      return 'One or more images could not be found. Please upload them again.';
    } else if (errorString.contains('Expected 3 images')) {
      return 'Please upload exactly 3 images.';
    } else if (errorString.contains('500')) {
      return 'Server error. Please try again later.';
    } else if (errorString.contains('Failed to validate')) {
      return 'Image validation failed. Please check your images and try again.';
    } else {
      return 'Failed to upload images: ${errorString.replaceFirst('Exception: ', '')}';
    }
  }

  void _navigateToPetUploadScreen() {
    try {
      ref.read(navigationServiceProvider).pushNamed(RoutePaths.petImageUploadScreen);
      ref.read(loggerProvider).i('➡️ Navigation to pet upload screen triggered');
    } catch (e) {
      ref.read(loggerProvider).e('Navigation error: $e');
    }
  }

  void navigateBack() {
    if (_isDisposed) return;
    //ref.read(navigationServiceProvider).pop();
  }

  void clearError() {
    if (_isDisposed) return;
    state = state.copyWith(errorMessage: null);
  }
}

// Upload House State
class UploadHouseState {
  final bool loading;
  final String? errorMessage;

  UploadHouseState({
    this.loading = false,
    this.errorMessage,
  });

  UploadHouseState copyWith({
    bool? loading,
    String? errorMessage,
  }) {
    return UploadHouseState(
      loading: loading ?? this.loading,
      errorMessage: errorMessage,
    );
  }

  void navigateBack() {}
}

// Provider
final uploadHouseViewModelProvider = StateNotifierProvider<UploadHouseViewModel, UploadHouseState>((ref) {
  return UploadHouseViewModel(ref);
});