import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'dart:io';

import '../logger/log_handler.dart';
import '../provider.dart';
import '../styles/resources.dart';
import '../widgets/common_widgets/New/background_paws.dart';
import '../widgets/common_widgets/New/continue_button.dart';
import '../widgets/common_widgets/back_button.dart';

class PetNameScreen extends ConsumerStatefulWidget {
  const PetNameScreen({super.key});

  @override
  PetNameScreenState createState() => PetNameScreenState();
}

class PetNameScreenState extends ConsumerState<PetNameScreen> {
  late final Resources _res;
  late Logger _logger;
  final TextEditingController _nameController = TextEditingController();
  String? _petPortraitUrl;
  bool _isLoading = true;

  // Default images for fallback
  final Map<int, String> _defaultImages = {
    0: 'assets/samples/living.jpg',
    1: 'assets/samples/bedroom.jpg',
    2: 'assets/samples/kitchen.jpg',
  };

  @override
  void initState() {
    super.initState();
    _logger = ref.read(loggerProvider);
    _res = ref.read(resourceProvider);
    _logger.i('PetNameScreenState: initState called');
    _loadPetPortraitUrl();
  }

  // Get living room background image - index 0
  String _getLivingRoomImage() {
    final backgroundState = ref.read(backgroundImageProvider);

    if (backgroundState.isNotEmpty && backgroundState.length > 0 && backgroundState[0] != null) {
      final livingRoomImage = backgroundState[0]!;
      final livingRoomImagePath = livingRoomImage.path;

      if (!livingRoomImagePath.startsWith('assets/')) {
        final file = File(livingRoomImagePath);
        if (file.existsSync()) {
          return livingRoomImagePath;
        }
      } else {
        return livingRoomImagePath;
      }
    }

    return _defaultImages[0]!; // Fallback to default living room
  }

  Future<void> _loadPetPortraitUrl() async {
    try {
      _logger.i('🖼️ Loading pet portrait URL from SharedPreferences');

      final prefsService = ref.read(sharedPreferencesServiceProvider);
      final url = await prefsService.getPetPortraitUrl();

      if (url != null && url.isNotEmpty) {
        _logger.i('✅ Loaded pet portrait URL: $url');
        setState(() {
          _petPortraitUrl = url;
        });
      } else {
        _logger.w('⚠️ No pet portrait URL found in SharedPreferences, using default image');
      }
    } catch (e) {
      _logger.e('💥 Error loading pet portrait URL: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final petNameViewModel = ref.read(petNameProvider.notifier);
    final petNameState = ref.watch(petNameProvider);

    return Scaffold(
      body: BackgroundPaws(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Row: Back Arrow + Centered Title
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: commonBackButton(context, onPressed: () {
                        petNameViewModel.navigateBack();
                      },),
                    ),
                    Center(
                      child: Text(
                        "Name your pet",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: _res.themes.black120,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                // Pet Image with Background Frame - 300px width and 300px height
                _buildPetImageWithBackgroundFrame(),

                const SizedBox(height: 30),

                // TextField
                Center(
                  child: SizedBox(
                    width: 280,
                    child: TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        hintText: "Type something",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: _res.themes.grey100),
                        ),
                        filled: true,
                        fillColor: _res.themes.paleGrey, // ✅ Light grey background
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: _res.themes.darkGolden),
                        ),
                        hintStyle: TextStyle(color: _res.themes.grey100),
                      ),
                      onChanged: (value) => petNameViewModel.updatePetName(value),
                      style: TextStyle(color: _res.themes.black120),
                      textAlign: TextAlign.center, // ✅ Center-aligned text
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                // Continue Button
                if (petNameState.petName != null &&
                    petNameState.petName!.isNotEmpty)
                  Center(
                    child: ContinueButton(
                      label: "Continue",
                      onTap: () {
                        petNameViewModel.navigateToNextScreen();
                      },
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPetImageWithBackgroundFrame() {
    final livingRoomImagePath = _getLivingRoomImage();

    return Center(
      child: Container(
        width: 300, // Fixed width for frame
        height: 300, // Increased by 100px (from 250 to 350)
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [

          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10), // Slightly smaller than frame
          child: Stack(
            children: [
              // Background Image ONLY inside the frame
              Positioned.fill(
                child: Image.asset(
                  livingRoomImagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: const Color(0xFFF5E1C0),
                    );
                  },
                ),
              ),

              // Pet Image on top of the background
              Center(
                child: _buildPetImageContent(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPetImageContent() {
    if (_isLoading) {
      return Container(
        width: 250, // Smaller than frame
        height: 300, // Adjusted for new frame height
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // If we have a stored URL, show the network image
    if (_petPortraitUrl != null && _petPortraitUrl!.isNotEmpty) {
      return Container(
        width: 250, // Smaller than frame
        height: 300, // Adjusted for new frame height
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),

        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            _petPortraitUrl!,
            width: 250,
            height: 300,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                width: 250,
                height: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white.withOpacity(0.8),
                ),
                child: Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              _logger.e('💥 Error loading network image: $error');
              // Fallback to default image if network image fails to load
              return _buildDefaultImageContent();
            },
          ),
        ),
      );
    }

    // Fallback to default image if no URL is available
    return _buildDefaultImageContent();
  }

  Widget _buildDefaultImageContent() {
    return Container(
      width: 250, // Smaller than frame
      height: 300, // Adjusted for new frame height
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white.withOpacity(0.9),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            spreadRadius: 1,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.asset(
          "assets/samples/cool_cate.png", // Default image
          width: 250,
          height: 300,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}