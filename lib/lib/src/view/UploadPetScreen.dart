import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../provider.dart';
import '../widgets/common_widgets/New/ImageUploadGridBox.dart';
import '../widgets/common_widgets/New/background_paws.dart';
import '../widgets/common_widgets/New/continue_button.dart';
import '../widgets/common_widgets/back_button.dart';

class UploadPetScreen extends ConsumerStatefulWidget {
  const UploadPetScreen({super.key});

  @override
  ConsumerState<UploadPetScreen> createState() => _UploadPetScreenState();
}

class _UploadPetScreenState extends ConsumerState<UploadPetScreen> {
  final List<File?> _uploadedImages = [null, null, null];

  void _onImageSelected(int index, File? file) {
    setState(() {
      _uploadedImages[index] = file;
    });
  }

  void _uploadImages() {
    final uploadPetViewModel = ref.read(uploadPetViewModelProvider);
    final validImages = _uploadedImages.whereType<File>().toList();

    if (validImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please upload at least 1 image"),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Store images locally using ViewModel
    uploadPetViewModel.storePetImagesLocally(validImages);

    // Navigate to next screen
    uploadPetViewModel.navigateToNextScreen();
  }

  @override
  Widget build(BuildContext context) {
    final uploadPetViewModel = ref.read(uploadPetViewModelProvider);
    final res = ref.read(resourceProvider);
    final logger = ref.read(loggerProvider);

    logger.i('UploadPetScreen: build called');

    return Scaffold(
      body: BackgroundPaws(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // App Bar replacement
                Row(
                  children: [
                    // IconButton(
                    //   icon: Icon(
                    //     Icons.arrow_back_ios,
                    //     color: res.themes.blackPure,
                    //   ),
                    //   onPressed: () => uploadPetViewModel.navigateBack(),
                    // ),
                    commonBackButton(context, onPressed: () {
                      uploadPetViewModel.navigateBack();
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
                    const SizedBox(width: 48), // For balance
                  ],
                ),

                const SizedBox(height: 50),

                // Content
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Please upload up to 3 images of your pet ensuring the following:",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: res.themes.blackPure,
                          ),
                        ),
                        const SizedBox(height: 22),
                        Text(
                          "• Your pet's head and shoulders are visible",
                          style: TextStyle(color: res.themes.blackPure),
                        ),
                        Text(
                          "• Your pet is the only main subject",
                          style: TextStyle(color: res.themes.blackPure),
                        ),
                        Text(
                          "• Minimal distraction in the background",
                          style: TextStyle(color: res.themes.blackPure),
                        ),
                        const SizedBox(height: 40),

                        // Upload boxes row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: ImageUploadGridBox(
                                onImageSelected: (file) => _onImageSelected(0, file),
                                selectedImage: _uploadedImages[0],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: ImageUploadGridBox(
                                onImageSelected: (file) => _onImageSelected(1, file),
                                selectedImage: _uploadedImages[1],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: ImageUploadGridBox(
                                onImageSelected: (file) => _onImageSelected(2, file),
                                selectedImage: _uploadedImages[2],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 32),

                        // Upload button
                        ContinueButton(
                          label: "Upload Image",
                          onTap: _uploadImages,
                          enabled: _uploadedImages.whereType<File>().isNotEmpty,
                        ),

                        const SizedBox(height: 12),

                        // Sample link
                        Center(
                          child: GestureDetector(
                            onTap: () => uploadPetViewModel.showSampleImages(context, ref),
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