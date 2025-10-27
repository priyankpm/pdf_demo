import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../logger/log_handler.dart';
import '../provider.dart';
import '../styles/resources.dart';
import '../viewmodel/potrait_confirm_screen/potrait_confirm_viewmodel.dart';
import '../widgets/common_widgets/New/background_paws.dart';

class PortraitConfirmScreen extends ConsumerStatefulWidget {
  const PortraitConfirmScreen({super.key});

  @override
  PortraitConfirmScreenState createState() => PortraitConfirmScreenState();
}

class PortraitConfirmScreenState extends ConsumerState<PortraitConfirmScreen> {
  late final Resources _res;
  late Logger _logger;
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
    _logger.i('PortraitConfirmScreenState: initState called');
    _loadPetPortraitUrl();
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

  @override
  Widget build(BuildContext context) {
    // Use watch instead of read to avoid using disposed notifier
    final portraitConfirmState = ref.watch(portraitConfirmProvider);
    final portraitConfirmViewModel = ref.read(portraitConfirmProvider.notifier);

    return Scaffold(
      body: BackgroundPaws(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Title
            const SizedBox(height: 30),
            Text(
              "Does this look like your pet?",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: _res.themes.black120,
              ),
            ),
            const SizedBox(height: 50),

            // Pet Image with Background Frame - 300px width and 300px height
            _buildPetImageWithBackgroundFrame(),

            const SizedBox(height: 50),

            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _customButton(
                  "No",
                  _res.themes.pureWhite,
                  _res.themes.black120,
                  onPressed: () => _confirmPortrait(false, portraitConfirmViewModel),
                ),
                const SizedBox(width: 10),
                _customButtonWithGradient(
                  "Yes",
                  _res.themes.black120,
                  onPressed: () => _confirmPortrait(true, portraitConfirmViewModel),
                ),
              ],
            ),
          ],
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

  void _confirmPortrait(bool isConfirmed, PortraitConfirmViewModel viewModel) {
    if (mounted) {
      _logger.i('👤 User confirmed portrait: $isConfirmed');
      viewModel.confirmPortrait(isConfirmed);
    }
  }

  Widget _customButton(String text, Color bgColor, Color txtColor, {VoidCallback? onPressed}) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 45,
        width: 120,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: _res.themes.grey100),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: txtColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _customButtonWithGradient(String text, Color txtColor, {VoidCallback? onPressed}) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 45,
        width: 120,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color.fromRGBO(255, 210, 136, 0.5), // rgba(255, 210, 136, 0.5)
              Color.fromRGBO(177, 86, 0, 0.5),     // rgba(177, 86, 0, 0.5)
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: _res.themes.grey100),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: txtColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}