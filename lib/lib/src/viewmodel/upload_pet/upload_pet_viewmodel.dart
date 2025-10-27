import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:whiskers_flutter_app/src/view/UploadHouseScreen.dart';

import '../../common_utility/common_utility.dart';
import '../../provider.dart';
import '../../widgets/common_widgets/New/SamplePetImagesPopup.dart';

class UploadPetViewModel {
  UploadPetViewModel(this.ref);

  final Ref ref;

  void navigateToNextScreen() {
    ref.read(navigationServiceProvider).pushNamed(RoutePaths.portraitConfirmScreen);
  }

  void showSampleImages(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (_) => SamplePetImagesPopup(
        title: "Please upload up to 3 images of your pet ensuring the following:",
        cautions: const [
          "• Your pet's head and shoulders are visible",
          "• Your pet is the only main subject",
          "• Minimal distraction in the background",
        ],
        correctSamples: const [
          "assets/samples/cat_good1.png",
          "assets/samples/dog_good.png",
          "assets/samples/cat_good2.png",
        ],
        incorrectSamples: const [
          "assets/samples/cat_body.png",
          "assets/samples/dog_with_cat.png",
          "assets/samples/multiple_pets.png",
        ],
        res: ref.read(resourceProvider),
      ),
    );
  }

  void navigateBack() {
    ref.read(navigationServiceProvider).pushNamed(RoutePaths.uploadHouseImagesScreen);
  }

  // Store pet images locally
  Future<void> storePetImagesLocally(List<File> images) async {
    final sharedPreferencesService = ref.read(sharedPreferencesServiceProvider);
    final logger = ref.read(loggerProvider);

    try {
      await sharedPreferencesService.storePetImages(images);
      logger.i('Pet images stored locally: ${images.length} images');
    } catch (e) {
      logger.e('Error storing pet images locally: $e');
    }
  }

  // Retrieve stored pet images
  Future<List<File>?> getStoredPetImages() async {
    final sharedPreferencesService = ref.read(sharedPreferencesServiceProvider);
    return await sharedPreferencesService.getPetImages();
  }

  // Clear stored pet images
  Future<void> clearStoredPetImages() async {
    final sharedPreferencesService = ref.read(sharedPreferencesServiceProvider);
    await sharedPreferencesService.clearPetImages();
  }
}