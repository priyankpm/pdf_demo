import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../common_utility/common_utility.dart';
import '../provider.dart';
import '../services/ValidationService.dart';
import '../widgets/common_widgets/New/ImageUploadGridBox.dart';
import '../widgets/common_widgets/New/background_paws.dart';
import '../widgets/common_widgets/New/continue_button.dart';
import '../widgets/common_widgets/back_button.dart';

class UploadHouseScreen extends ConsumerStatefulWidget {
  const UploadHouseScreen({super.key});

  @override
  ConsumerState<UploadHouseScreen> createState() => _UploadHouseScreenState();
}

class _UploadHouseScreenState extends ConsumerState<UploadHouseScreen> {
  final List<File?> _uploadedImages = [null, null, null];
  bool _isUploading = false;

  // Default images
  final Map<int, String> _defaultImages = {
    0: 'assets/samples/living.jpg',
    1: 'assets/samples/bedroom.jpg',
    2: 'assets/samples/kitchen.jpg',
  };

  void _onImageSelected(int index, File? file) {
    setState(() {
      _uploadedImages[index] = file;
    });
  }

  Future<void> _uploadImages() async {
    if (_isUploading) return;

    setState(() {
      _isUploading = true;
    });

    try {
      final logger = ref.read(loggerProvider);
      logger.i('=== STARTING IMAGE UPLOAD PROCESS ===');

      // Check if user uploaded any custom images
      final uploadedCustomImages = _uploadedImages.whereType<File>().toList();
      final hasCustomImages = uploadedCustomImages.isNotEmpty;

      String? petPortraitUrl;
      String? petPortraitKey;
      String? petImageId;

      // ALWAYS call the validation API, but with empty array if no custom images
      logger.i(hasCustomImages
          ? '🖼️ User uploaded ${uploadedCustomImages.length} custom images, calling validation API with images'
          : '📸 User is using default images, calling validation API with empty array');

      // Step 1: Always call validation API
      final validationService = ref.read(validationServiceProvider);
      final validationResult = await validationService.validateImages(
        hasCustomImages ? uploadedCustomImages : [], // Send empty array for default images
      );

      logger.i('✅ API validation successful: $validationResult');

      // Extract the pet portrait URL from the response (even for empty array)
      if (validationResult['data'] != null) {
        final data = validationResult['data'];
        petPortraitUrl = data['url'];
        petPortraitKey = data['key'];
        petImageId = data['imageId'];

        logger.i('📸 Extracted pet portrait URL: $petPortraitUrl');
        logger.i('🔑 Extracted pet portrait key: $petPortraitKey');
        logger.i('🆔 Extracted image ID: $petImageId');
      }

      // Step 2: Prepare images for storage (mix of custom and default)
      final List<File?> imagesToStore = [];
      final List<String> imageReferences = [];

      for (int i = 0; i < 3; i++) {
        if (_uploadedImages[i] != null) {
          // User uploaded custom image for this position
          imagesToStore.add(_uploadedImages[i]!);
          imageReferences.add(_uploadedImages[i]!.path);
        } else {
          // Use default image for this position
          imagesToStore.add(null);
          imageReferences.add(_defaultImages[i]!);
        }
      }

      // Step 3: Store in SharedPreferences
      final prefsService = ref.read(sharedPreferencesServiceProvider);
      await prefsService.storeBackgroundImages(imagesToStore);

      // Store pet portrait URL if available (even from empty array call)
      if (petPortraitUrl != null) {
        await prefsService.storePetPortraitUrl(petPortraitUrl);
        logger.i('💾 Stored pet portrait URL in preferences: $petPortraitUrl');
      }

      if (petPortraitKey != null) {
        await prefsService.storePetPortraitKey(petPortraitKey);
        logger.i('💾 Stored pet portrait key in preferences: $petPortraitKey');
      }

      if (petImageId != null) {
        await prefsService.storePetImageId(petImageId);
        logger.i('💾 Stored pet image ID in preferences: $petImageId');
      }

      // Verify storage
      final storedImages = await prefsService.getBackgroundImages();
      if (storedImages == null) {
        throw Exception('Failed to store images in SharedPreferences');
      }

      // Step 4: Update background image provider
      final backgroundNotifier = ref.read(backgroundImageProvider.notifier);
      backgroundNotifier.setBackgroundImages(imageReferences);

      logger.i('✅ All images processed successfully, navigating to next screen');
      logger.i('📁 Image references: $imageReferences');

      // Step 5: Navigate to next screen
      ref.read(navigationServiceProvider).pushNamed(RoutePaths.petImageUploadScreen);

    } catch (e) {
      final errorMessage = _getUserFriendlyError(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to upload images: $errorMessage"),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
        ),
      );

      ref.read(loggerProvider).e('💥 Upload error: $e');
    } finally {
      setState(() {
        _isUploading = false;
      });
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
    } else if (errorString.contains('Network error') || errorString.contains('Connection failed')) {
      return 'Network connection failed. Please check your internet and try again.';
    } else if (errorString.contains('Session expired')) {
      return 'Your session has expired. Please login again.';
    } else if (errorString.contains('Server error')) {
      return 'Server is temporarily unavailable. Please try again later.';
    } else if (errorString.contains('Images are too large')) {
      return 'Images are too large. Please use smaller images (under 5MB each).';
    } else if (errorString.contains('Unsupported image format')) {
      return 'Please use JPG or PNG images only.';
    } else if (errorString.contains('Too many requests')) {
      return 'Too many attempts. Please wait a moment and try again.';
    } else if (errorString.contains('timeout') || errorString.contains('timed out')) {
      return 'Request timed out. Please try again.';
    } else {
      return 'Failed to upload images: ${errorString.replaceFirst('Exception: ', '')}';
    }
  }

  // Check if we have any custom images uploaded
  bool get _hasCustomImages {
    return _uploadedImages.any((image) => image != null);
  }

  @override
  Widget build(BuildContext context) {
    final uploadHouseViewModel = ref.read(uploadHouseViewModelProvider);
    final res = ref.read(resourceProvider);
    final logger = ref.read(loggerProvider);

    logger.i('UploadHouseScreen: build called');

    return Scaffold(
      body: BackgroundPaws(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Custom AppBar style same as Pet Screen
                Row(
                  children: [
                    // IconButton(
                    //   icon: Icon(
                    //     Icons.arrow_back_ios,
                    //     color: res.themes.blackPure,
                    //   ),
                    //   onPressed: () => uploadHouseViewModel.navigateBack(),
                    // ),
                    commonBackButton(context, onPressed: () {
                      uploadHouseViewModel.navigateBack();
                    },),
                    const Spacer(),
                    Text(
                      "Upload Image",
                      style: TextStyle(
                        color: res.themes.blackPure,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    const SizedBox(width: 48),
                  ],
                ),

                const SizedBox(height: 50),

                // Content
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Keep text same, just restyled
                        Text(
                          "Please upload 3 images of your living room, bedroom and kitchen ensuring the following:",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: res.themes.blackPure,
                          ),
                        ),
                        const SizedBox(height: 22),
                        Text(
                          "• The lighting is optimal",
                          style: TextStyle(color: res.themes.blackPure),
                        ),
                        Text(
                          "• There is no subject visible",
                          style: TextStyle(color: res.themes.blackPure),
                        ),
                        const SizedBox(height: 40),

                        // Upload boxes
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: ImageUploadGridBox(
                                label: "Living Room",
                                onImageSelected: (file) => _onImageSelected(0, file),
                                selectedImage: _uploadedImages[0],
                                defaultImagePath: _defaultImages[0]!,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: ImageUploadGridBox(
                                label: "Bedroom",
                                onImageSelected: (file) => _onImageSelected(1, file),
                                selectedImage: _uploadedImages[1],
                                defaultImagePath: _defaultImages[1]!,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: ImageUploadGridBox(
                                label: "Kitchen",
                                onImageSelected: (file) => _onImageSelected(2, file),
                                selectedImage: _uploadedImages[2],
                                defaultImagePath: _defaultImages[2]!,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 32),

                        // Show upload progress and button
                        Column(
                          children: [
                            if (_isUploading) ...[
                              const CircularProgressIndicator(),
                              const SizedBox(height: 16),
                              Text(
                                _hasCustomImages
                                    ? "Validating and uploading images..."
                                    : "Processing images...",
                                style: TextStyle(
                                  color: res.themes.blackPure,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 16),
                            ],
                            // Button is ALWAYS enabled
                            ContinueButton(
                              label: _isUploading
                                  ? (_hasCustomImages ? "Validating..." : "Processing...")
                                  : "Continue",
                              onTap: _isUploading ? null : _uploadImages,
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        Center(
                          child: GestureDetector(
                            onTap: () {
                              // TODO: Implement sample images view
                              ref.read(loggerProvider).i('Sample images view requested');
                            },
                            child: Text(
                              "Click to view the sample images",
                              style: TextStyle(
                                color: res.themes.blue0a84ff,
                                decoration: TextDecoration.underline,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),

                        // Info text about default images
                        const SizedBox(height: 20),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            "You can continue with default sample images or upload your own. "
                                "If you upload custom images, they will be validated for optimal quality.",
                            style: TextStyle(
                              color: res.themes.blue0a84ff,
                              fontSize: 12,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),

                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}