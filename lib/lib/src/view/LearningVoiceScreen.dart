import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../common_utility/common_utility.dart';
import '../provider.dart';
import '../services/SharedPreferencesService.dart';
import '../widgets/common_widgets/New/background_paws.dart';
import 'dart:io';
import 'dart:async';
import 'dart:developer';

class LearningVoiceScreen extends ConsumerStatefulWidget {
  const LearningVoiceScreen({super.key});

  @override
  ConsumerState<LearningVoiceScreen> createState() =>
      _LearningVoiceScreenState();
}

class _LearningVoiceScreenState extends ConsumerState<LearningVoiceScreen>
    with SingleTickerProviderStateMixin {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  bool _isCorrect = false;
  bool _showRetry = false;
  String _recognizedText = "";
  String? _petName;
  late AnimationController _animationController;
  String? _petPortraitUrl;
  bool _isLoading = true;
  bool _isSyncing = false;

  // Default images for fallback
  final Map<int, String> _defaultImages = {
    0: 'assets/samples/living.jpg',
    1: 'assets/samples/bedroom.jpg',
    2: 'assets/samples/kitchen.jpg',
  };

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _loadPetName();
    _animationController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _loadPetPortraitUrl();

  }
  Future<void> _loadPetPortraitUrl() async {
    try {

      final prefsService = ref.read(sharedPreferencesServiceProvider);
      final url = await prefsService.getPetPortraitUrl();

      if (url != null && url.isNotEmpty) {
        setState(() {
          _petPortraitUrl = url;
        });
      } else {
      }
    } catch (e) {
      log("$e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _speech.stop();
    _animationController.dispose();
    super.dispose();
  }

  void _navigateToNextScreen() {
    // Stop speech recognition if active
    if (_isListening) {
      _speech.stop();
    }

    // Navigate to next screen
    ref.read(navigationServiceProvider).pushNamed(RoutePaths.videoScreen);
  }

  Future<void> _onSkipPressed() async {
    if (_isSyncing) return;

    setState(() {
      _isSyncing = true;
    });

    try {
      if (mounted) {
        SyncLoadingDialog.show(
          context,
          title: 'Syncing Data',
          message: 'Preparing your pet...',
        );
      }

      await ref.read(mediaViewModelProvider.notifier).init();

      final syncService = ref.read(dataSyncServiceProvider);
      final result = await syncService.syncData(context);

      if (mounted) {
        SyncLoadingDialog.hide(context);
      }

      if (result != null && result.media.isNotEmpty) {
        log('Sync successful: ${result.media.length} media items received');

        await ref.read(mediaViewModelProvider.notifier).refresh();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('✓ Synced ${result.media.length} media items'),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 1),
            ),
          );
        }
      } else {
        log('No new media to sync');
      }
    } catch (e) {
      log('Error during sync: $e');

      if (mounted) {
        SyncLoadingDialog.hide(context);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Sync completed with some errors'),
            backgroundColor: Colors.orange,
            duration: Duration(seconds: 1),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSyncing = false;
        });
      }
      _navigateToNextScreen();
    }
  }

  Future<void> _loadPetName() async {
    final service = SharedPreferencesService();
    final name = await service.getPetName();
    setState(() {
      _petName = name ?? "Cat";
    });
  }

  void _startListening() async {
    if (_petName == null) return;

    bool available = await _speech.initialize(
      onStatus: (status) {
        if (status == "done") {
          _checkText();
          setState(() => _showRetry = true);
        }
      },
      onError: (error) {
        print("Speech recognition error: $error");
        setState(() => _showRetry = true);
      },
    );

    if (available) {
      setState(() {
        _isListening = true;
        _showRetry = false;
        _recognizedText = "";
      });
      _speech.listen(
        onResult: (result) {
          setState(() {
            _recognizedText = result.recognizedWords;
          });
          _checkText();
        },
      );
    } else {
      setState(() => _isListening = false);
    }
  }

  void _stopListening() {
    _speech.stop();
    setState(() {
      _isListening = false;
      _showRetry = true;
    });
    _checkText();
  }

  void _resetListening() {
    _speech.stop();
    setState(() {
      _isListening = false;
      _recognizedText = "";
      _isCorrect = false;
      _showRetry = false;
    });
  }

  void _checkText() {
    if (_petName == null) return;

    String expected = "Hi $_petName";
    if (_recognizedText.trim().toLowerCase() == expected.toLowerCase() && !_isCorrect) {
      setState(() {
        _isCorrect = true;
        _animationController.forward();
      });

      // wait 2 seconds and navigate to Home Screen
      Timer(const Duration(seconds: 2), () async {
        await _onSkipPressed();
      });
    }
  }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundPaws(
        child: SafeArea(
          child: _petName == null
              ? const Center(child: CircularProgressIndicator())
              : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Row: Back Arrow + Centered Title + Skip Button
                Stack(
                  alignment: Alignment.center,
                  children: [
                    // Back Button
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back,
                            color: Colors.black87),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    // Centered Title
                    const Center(
                      child: Text(
                        "Learning Your Voice",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    // Skip Button
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: _isSyncing ? null : _onSkipPressed,
                        child: _isSyncing
                            ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                            : const Text(
                          'Skip',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.blue,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                // Pet Image with Background Frame (same as PetNameScreen)
                _buildPetImageWithBackgroundFrame(),
                const SizedBox(height: 20),

                // Instruction Text
                Center(
                  child: Column(
                    children: [
                      Text(
                        'Please repeat the words, "Hi $_petName."',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'This helps your pet recognize your voice',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          fontStyle: FontStyle.italic,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),

                // Mic + Retry Icon
                Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      GestureDetector(
                        onTap: _isListening ? _stopListening : _startListening,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 500),
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: _isCorrect
                                ? Colors.green
                                : _isListening
                                ? Colors.red
                                : Colors.grey[300],
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: _isCorrect
                              ? const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 40,
                          )
                              : Icon(
                            _isListening ? Icons.mic : Icons.mic_none,
                            color: _isListening ? Colors.white : Colors.black87,
                            size: 40,
                          ),
                        ),
                      ),
                      if (_showRetry && !_isCorrect)
                        Positioned(
                          right: -10,
                          bottom: -10,
                          child: GestureDetector(
                            onTap: _resetListening,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.all(8),
                              child: const Icon(
                                Icons.refresh,
                                size: 20,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Recognized Text
                if (_recognizedText.isNotEmpty)
                  Column(
                    children: [
                      const Text(
                        "You said:",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.grey.withOpacity(0.3),
                          ),
                        ),
                        child: Text(
                          _recognizedText,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SyncLoadingDialog extends StatelessWidget {
  final String title;
  final String message;
  final double? progress;
  final int? currentItem;
  final int? totalItems;

  const SyncLoadingDialog({
    super.key,
    this.title = 'Syncing Data',
    this.message = 'Please wait...',
    this.progress,
    this.currentItem,
    this.totalItems,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 20),
            if (progress == null)
              const CircularProgressIndicator()
            else
              SizedBox(
                width: 60,
                height: 60,
                child: CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 6,
                  backgroundColor: Colors.grey[200],
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
              ),
            const SizedBox(height: 20),
            Text(
              message,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            if (currentItem != null && totalItems != null) ...[
              const SizedBox(height: 12),
              Text(
                'Processing $currentItem of $totalItems',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black54,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
            if (progress != null) ...[
              const SizedBox(height: 8),
              Text(
                '${(progress! * 100).toStringAsFixed(0)}%',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  static void show(
    BuildContext context, {
    String title = 'Syncing Data',
    String message = 'Please wait...',
    double? progress,
    int? currentItem,
    int? totalItems,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => SyncLoadingDialog(
        title: title,
        message: message,
        progress: progress,
        currentItem: currentItem,
        totalItems: totalItems,
      ),
    );
  }

  static void hide(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }

  static void update(
    BuildContext context, {
    String? title,
    String? message,
    double? progress,
    int? currentItem,
    int? totalItems,
  }) {
    Navigator.of(context, rootNavigator: true).pop();
    show(
      context,
      title: title ?? 'Syncing Data',
      message: message ?? 'Please wait...',
      progress: progress,
      currentItem: currentItem,
      totalItems: totalItems,
    );
  }
}
