import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:whiskers_flutter_app/src/provider/providers.dart';
import 'package:whiskers_flutter_app/src/widgets/common_widgets/swapping_buttons.dart';
import '../../../common_utility/common_utility.dart' show RoutePaths;
import '../../../provider.dart' show navigationServiceProvider, sharedPreferencesServiceProvider;
import '../../../viewmodel/video/gif_controller.dart'; // Import the new GIF controller
import '../../common_widgets/dashed_border.dart';

// Thought bubble provider
final thoughtBubbleProvider = StateProvider<String?>((ref) => null);

// Show pet provider - controls whether pet is visible
final showPetProvider = StateProvider<bool>((ref) => false);

// Show homescreen provider - controls initial homescreen display
final showHomescreenProvider = StateProvider<bool>((ref) => true);

// NEW: Track if mic has been tapped to permanently hide sample background
final hasMicBeenTappedProvider = StateProvider<bool>((ref) => false);

class UploadImageScreen extends ConsumerStatefulWidget {
  const UploadImageScreen({super.key});

  @override
  ConsumerState<UploadImageScreen> createState() => _UploadImageScreenState();
}

class _UploadImageScreenState extends ConsumerState<UploadImageScreen> {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _lastRecognizedWords = '';

  // Default images for fallback
  final Map<int, String> _defaultImages = {
    0: 'assets/samples/living.jpg',
    1: 'assets/samples/bedroom.jpg',
    2: 'assets/samples/kitchen.jpg',
  };

  // Bounding box for petting area (relative to pet size)
  final Rect _pettingBounds = const Rect.fromLTWH(-0.3, -0.3, 1.6, 1.6);

  @override
  void initState() {
    super.initState();

    print("=== UPLOAD IMAGE SCREEN INITIALIZED ===");

    // Get background image information
    final backgroundState = ref.read(backgroundImageProvider);

    print("Background images list length: ${backgroundState.imagePaths.length}");
    print("Current background image: ${backgroundState.currentImage}");
    print("Current image index: ${backgroundState.currentIndex}");
    print("Is last image: ${backgroundState.isLast}");

    // Print all stored background image paths
    if (backgroundState.hasImages) {
      print("=== STORED BACKGROUND IMAGE PATHS ===");
      for (int i = 0; i < backgroundState.imagePaths.length; i++) {
        final path = backgroundState.imagePaths[i];
        final isAsset = path.startsWith('assets/');
        if (isAsset) {
          print("Image $i: $path (ASSET)");
        } else {
          final file = File(path);
          final exists = file.existsSync();
          print("Image $i: $path");
          print("  - File exists: $exists");
          if (exists) {
            print("  - File size: ${file.lengthSync()} bytes");
          }
        }
      }
      print("=====================================");
    } else {
      print("No background images stored");
    }

    // Check SharedPreferences storage as well
    _checkSharedPreferencesStorage();

    _speech = stt.SpeechToText();
    print("Speech to text initialized");
    print("=====================================");

    // Set current screen to 'home' and update pet state
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(videoControllerProvider.notifier).updateCurrentScreen('home');
      _debugBackgroundState();
    });
  }

  // Method to check SharedPreferences storage
  Future<void> _checkSharedPreferencesStorage() async {
    try {
      final prefsService = ref.read(sharedPreferencesServiceProvider);
      final storedImages = await prefsService.getBackgroundImages();

      print("=== SHAREDPREFERENCES STORAGE CHECK ===");
      if (storedImages == null || storedImages.isEmpty) {
        print("No images found in SharedPreferences");
        print("All images will use defaults:");
        _defaultImages.forEach((index, path) {
          print("  Image $index: $path (DEFAULT)");
        });
      } else {
        print("Found ${storedImages.length} images in SharedPreferences:");
        for (int i = 0; i < 3; i++) { // Check all 3 positions
          if (i < storedImages.length && storedImages[i] != null) {
            final image = storedImages[i]!;
            final exists = await image.exists();
            print("Image $i: ${image.path}");
            print("  - File exists: $exists");
            if (exists) {
              final stat = await image.stat();
              print("  - File size: ${stat.size} bytes");
              print("  - Modified: ${stat.modified}");
            } else {
              print("  - FILE MISSING! Will use default: ${_defaultImages[i]}");
            }
          } else {
            print("Image $i: NULL (will use default: ${_defaultImages[i]})");
          }
        }
      }
      print("======================================");
    } catch (e) {
      print("Error checking SharedPreferences: $e");
    }
  }

  void _startListening() async {
    bool available = await _speech.initialize();
    if (available) {
      setState(() => _isListening = true);

      // Use the new video controller for listening state
      ref.read(videoControllerProvider.notifier).handleListening();

      // Show the pet when mic is tapped and hide homescreen
      ref.read(showPetProvider.notifier).state = true;
      ref.read(showHomescreenProvider.notifier).state = false;

      // NEW: Mark that mic has been tapped to permanently hide sample background
      ref.read(hasMicBeenTappedProvider.notifier).state = true;

      // Show listening thought bubble
      ref.read(thoughtBubbleProvider.notifier).state = "Listening...";

      _speech.listen(
        onResult: (result) {
          if (result.recognizedWords.isNotEmpty && result.recognizedWords != _lastRecognizedWords) {
            _lastRecognizedWords = result.recognizedWords;

            // Use the new video controller for talking state
            ref.read(videoControllerProvider.notifier).handleTalking();

            // Show recognized speech in thought bubble
            ref.read(thoughtBubbleProvider.notifier).state = result.recognizedWords;

            // Auto-clear thought bubble after 3 seconds
            Future.delayed(const Duration(seconds: 3), () {
              if (ref.read(thoughtBubbleProvider) == result.recognizedWords) {
                ref.read(thoughtBubbleProvider.notifier).state = null;
              }
            });
          }
        },
      );
    }
  }

  void _stopListening() {
    _speech.stop();
    setState(() => _isListening = false);

    // Return to idle state using new controller
    ref.read(videoControllerProvider.notifier).updatePetState(PetState.idle);

    ref.read(thoughtBubbleProvider.notifier).state = null;
    // Keep pet visible even after stopping listening
  }

  // Check if touch is within petting bounds
  bool _isWithinPettingBounds(Offset localPosition, Size petSize) {
    final relativeX = localPosition.dx / petSize.width;
    final relativeY = localPosition.dy / petSize.height;

    return _pettingBounds.contains(Offset(relativeX, relativeY));
  }

  // Handle petting gestures
  void _handlePetting(Offset localPosition, Size petSize) {
    if (_isWithinPettingBounds(localPosition, petSize)) {
      // Use the new video controller for petting state
      ref.read(videoControllerProvider.notifier).handlePetting();

      // Show happy thought bubble
      ref.read(thoughtBubbleProvider.notifier).state = "Purr... 😊";
      Future.delayed(const Duration(seconds: 2), () {
        if (ref.read(thoughtBubbleProvider) == "Purr... 😊") {
          ref.read(thoughtBubbleProvider.notifier).state = null;
        }
      });
    }
  }

  // Handle upload functionality
  void _handleUpload() {
    // Show upload dialog or implement your upload logic
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Upload Image"),
        content: const Text("Choose an image to upload:"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              // Implement image picker and upload logic here
              Navigator.pop(context);
            },
            child: const Text("Upload"),
          ),
        ],
      ),
    );
  }

  // Handle delete background image
  void _deleteBackgroundImage() {
    final backgroundNotifier = ref.read(backgroundImageProvider.notifier);
    final backgroundState = ref.read(backgroundImageProvider);
    final currentIndex = backgroundState.currentIndex;

    if (currentIndex >= 0 && backgroundState.hasImages) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Delete Background"),
          content: const Text("Are you sure you want to remove this background image?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                backgroundNotifier.removeImage(currentIndex);
                Navigator.pop(context);
                setState(() {}); // Refresh UI
              },
              child: const Text(
                "Delete",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      );
    }
  }

  // Force reload from SharedPreferences with proper default image support
  Future<void> _forceReloadFromSharedPreferences() async {
    try {
      final prefsService = ref.read(sharedPreferencesServiceProvider);
      final storedImages = await prefsService.getBackgroundImages();

      if (storedImages != null && storedImages.isNotEmpty) {
        // Create final image list - use uploaded files or default images
        final List<String> finalImagePaths = [];

        for (int i = 0; i < 3; i++) {
          if (i < storedImages.length && storedImages[i] != null) {
            final image = storedImages[i]!;
            final exists = await image.exists();
            if (exists) {
              // Use uploaded image
              finalImagePaths.add(image.path);
              print("Image $i: USING UPLOADED - ${image.path}");
            } else {
              // File doesn't exist, use default
              finalImagePaths.add(_defaultImages[i]!);
              print("Image $i: USING DEFAULT (file missing) - ${_defaultImages[i]}");
            }
          } else {
            // No uploaded image for this index, use default
            finalImagePaths.add(_defaultImages[i]!);
            print("Image $i: USING DEFAULT (null) - ${_defaultImages[i]}");
          }
        }

        final backgroundNotifier = ref.read(backgroundImageProvider.notifier);
        await backgroundNotifier.setBackgroundImages(finalImagePaths);

        print('=== FORCE RELOAD COMPLETE ===');
        print('Reloaded ${finalImagePaths.length} images:');
        for (int i = 0; i < finalImagePaths.length; i++) {
          print("  Image $i: ${finalImagePaths[i]}");
        }
        setState(() {}); // Refresh UI
      } else {
        print('No images found in SharedPreferences to reload - using all defaults');
        // Set all default images
        final backgroundNotifier = ref.read(backgroundImageProvider.notifier);
        final defaultPaths = _defaultImages.values.toList();
        await backgroundNotifier.setBackgroundImages(defaultPaths);

        print('=== ALL DEFAULTS SET ===');
        for (int i = 0; i < defaultPaths.length; i++) {
          print("  Image $i: ${defaultPaths[i]} (DEFAULT)");
        }
        setState(() {});
      }

      // Debug the updated state
      _debugBackgroundState();
    } catch (e) {
      print('Error in force reload: $e');
    }
  }

  // SIMPLIFIED: Get the current background image with proper fallback logic
  String? _getCurrentBackgroundImage() {
    final backgroundState = ref.read(backgroundImageProvider);
    final currentImage = backgroundState.currentImage;
    final hasMicBeenTapped = ref.read(hasMicBeenTappedProvider);
    final showPet = ref.read(showPetProvider);

    // If we're on the upload slot (last image), show solid color
    if (backgroundState.isLast && showPet) {
      return null;
    }

    // If mic has been tapped OR pet is visible, show the current background image
    if (hasMicBeenTapped || showPet) {
      if (currentImage != null) {
        // Check if it's a file path (uploaded image)
        if (!currentImage.startsWith('assets/')) {
          final file = File(currentImage);
          if (file.existsSync()) {
            return currentImage;
          }
        } else {
          // It's an asset image, use it directly
          return currentImage;
        }
      }
      // If no valid image found, show solid color
      return null;
    }

    // Before mic tap - show homescreen
    return "assets/samples/homescreen.jpeg";
  }

  // Debug method to check current background state
  void _debugBackgroundState() {
    final backgroundState = ref.read(backgroundImageProvider);
    print("=== CURRENT BACKGROUND STATE ===");
    print("Total images: ${backgroundState.imagePaths.length}");
    print("Current index: ${backgroundState.currentIndex}");
    print("Current image: ${backgroundState.currentImage}");
    print("Has images: ${backgroundState.hasImages}");
    print("Is last: ${backgroundState.isLast}");

    print("All image paths:");
    for (int i = 0; i < backgroundState.imagePaths.length; i++) {
      final path = backgroundState.imagePaths[i];
      final isAsset = path.startsWith('assets/');
      final fileExists = !isAsset ? File(path).existsSync() : true;
      print("  [$i] $path");
      print("      Type: ${isAsset ? 'ASSET' : 'UPLOADED'}");
      print("      Exists: $fileExists");
    }
    print("=================================");
  }

  void _debugCurrentImageLogic() {
    final backgroundState = ref.read(backgroundImageProvider);
    final currentImage = backgroundState.currentImage;
    final currentIndex = backgroundState.currentIndex;
    final hasMicBeenTapped = ref.read(hasMicBeenTappedProvider);
    final showPet = ref.read(showPetProvider);
    final showHomescreen = ref.read(showHomescreenProvider);
    final showUploadBox = backgroundState.isLast && showPet;

    print("=== IMAGE LOGIC DEBUG ===");
    print("Current Index: $currentIndex");
    print("Current Image: $currentImage");
    print("Has Mic Been Tapped: $hasMicBeenTapped");
    print("Show Upload Box: $showUploadBox");
    print("Show Pet: $showPet");
    print("Show Homescreen: $showHomescreen");

    final result = _getCurrentBackgroundImage();
    print("Final Background Image: $result");
    print("==========================");
  }

  @override
  Widget build(BuildContext context) {
    _debugCurrentImageLogic(); // Add this line

    final backgroundNotifier = ref.watch(backgroundImageProvider.notifier);
    final backgroundState = ref.watch(backgroundImageProvider);
    final currentImage = _getCurrentBackgroundImage();
    final videoController = ref.watch(videoControllerProvider); // Use new video controller
    final thoughtBubble = ref.watch(thoughtBubbleProvider);
    final showPet = ref.watch(showPetProvider);
    final showHomescreen = ref.watch(showHomescreenProvider);
    final hasMicBeenTapped = ref.read(hasMicBeenTappedProvider);

    // Check if upload box is visible (last background)
    final showUploadBox = backgroundState.isLast && showPet;

    return Scaffold(
      body: Stack(
        children: [
          // Background logic simplified:
          // 1. If homescreen should be shown AND not upload box -> show homescreen
          // 2. If we have a valid background image AND not upload box -> show background
          // 3. Otherwise -> show solid color

          // Initial Homescreen - shown only when no mic interaction yet AND not showing upload box
          if (showHomescreen && !showUploadBox)
            Container(
              width: double.infinity,
              height: double.infinity,
              child: Image.asset(
                "assets/samples/homescreen.jpeg",
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: const Color(0xFFF5E1C0),
                    child: const Center(
                      child: Text(
                        "Welcome to Whiskers!",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

          // Background image - show when we have a valid image AND not showing homescreen AND not upload box
          if (!showHomescreen && !showUploadBox && currentImage != null)
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF5E1C0),
                image: DecorationImage(
                  image: currentImage.startsWith('assets/')
                      ? AssetImage(currentImage) as ImageProvider
                      : FileImage(File(currentImage)) as ImageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),

          // Solid color background when:
          // - Upload box is visible OR
          // - No valid background image available
          if ((showUploadBox || (currentImage == null && !showHomescreen)))
            Container(
              width: double.infinity,
              height: double.infinity,
              color: const Color(0xFFF5E1C0), // Same color as your sample backgrounds
            ),

          // Mic + Alert row - Always visible
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Mic button with active listening indicator
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _isListening ? Colors.red.withOpacity(0.3) : Colors.white,
                      border: _isListening
                          ? Border.all(color: Colors.red, width: 2)
                          : null,
                    ),
                    child: IconButton(
                      icon: Icon(
                        _isListening ? Icons.mic : Icons.mic_none,
                        size: 20,
                        color: _isListening ? Colors.red : Colors.black87,
                      ),
                      onPressed: () {
                        _isListening ? _stopListening() : _startListening();
                      },
                    ),
                  ),

                  // Alert button
                  Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.alarm, size: 20, color: Colors.red),
                      onPressed: () {
                        ref.read(navigationServiceProvider).pushNamed(RoutePaths.scheduleScreen);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Swapping buttons with delete option - only show if we have custom backgrounds AND pet is visible AND not showing homescreen
          // KEEP SWAPPING BUTTONS VISIBLE EVEN WHEN UPLOAD BOX IS VISIBLE
          if (backgroundState.hasImages && showPet && !showHomescreen)
            SwappingButtons(
              leftCallback: () {
                backgroundNotifier.previousImage();
                setState(() {}); // Refresh UI
              },
              rightCallback: () {
                backgroundNotifier.nextImage();
                setState(() {}); // Refresh UI
              },
              showDeleteButton: currentImage != null && !currentImage.startsWith('assets/') && !showUploadBox,
              deleteCallback: _deleteBackgroundImage,
            ),

          // Upload button -> visible only on last background AND when pet is visible AND not showing homescreen
          if (showUploadBox)
            Positioned(
              top: 54,
              left: 75,
              child: GestureDetector(
                onTap: _handleUpload,
                child: const UploadBox(),
              ),
            ),

          // Debug reload button (temporary) - only show when not on homescreen AND upload box is not visible
          if (showPet && !showHomescreen && !showUploadBox)
            Positioned(
              top: 120,
              right: 16,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.green,
                ),
                child: IconButton(
                  icon: Icon(Icons.refresh, size: 20, color: Colors.white),
                  onPressed: _forceReloadFromSharedPreferences,
                ),
              ),
            ),

          // Cancel button (small X icon in top right corner) - only show when not on homescreen AND upload box is not visible
          if (currentImage != null && !currentImage.startsWith('assets/') && showPet && !showHomescreen && !showUploadBox)
            Positioned(
              top: 70,
              right: 16,
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: IconButton(
                  icon: const Icon(Icons.close, size: 20, color: Colors.black87),
                  onPressed: _deleteBackgroundImage,
                ),
              ),
            ),

          // Pet object in center with 3D effect and thought bubble
          // Show pet only when:
          // - showPet is true
          // - upload box is not visible
          // - homescreen is not visible
          if (showPet && !showUploadBox && !showHomescreen)
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 0), // Small gap from bottom
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    // Thought Bubble above pet's head
                    if (thoughtBubble != null)
                      Positioned(
                        top: -120,
                        child: ThoughtBubble(text: thoughtBubble),
                      ),

                    // 🐾 Pet GIF using the new video controller
                    Container(
                      width: 300,
                      height: 500,
                      child: GestureDetector(
                        onPanUpdate: (details) {
                          final renderBox = context.findRenderObject() as RenderBox?;
                          if (renderBox != null) {
                            final localPosition =
                            renderBox.globalToLocal(details.globalPosition);
                            final petSize = renderBox.size;
                            _handlePetting(localPosition, petSize);
                          }
                        },
                        onTapDown: (details) {
                          final renderBox = context.findRenderObject() as RenderBox?;
                          if (renderBox != null) {
                            final localPosition = details.localPosition;
                            final petSize = renderBox.size;
                            _handlePetting(localPosition, petSize);
                          }
                        },
                        onDoubleTap: () {
                          // Use the new video controller for surprised state
                          ref.read(videoControllerProvider.notifier).updatePetState(PetState.surprised);

                          // Thought bubble for double tap
                          ref.read(thoughtBubbleProvider.notifier).state = "Wow! 😮";
                          Future.delayed(const Duration(seconds: 2), () {
                            if (ref.read(thoughtBubbleProvider) == "Wow! 😮") {
                              ref.read(thoughtBubbleProvider.notifier).state = null;
                            }
                          });
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20), // slight rounding, optional
                          child: Image.asset(
                            videoController.currentGifPath, // Use GIF path from video controller
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                'assets/pet/natural.gif', // Fallback to natural GIF
                                fit: BoxFit.cover,
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
        ],
      ),
    );
  }
}



// Enhanced Thought Bubble Widget
class ThoughtBubble extends StatelessWidget {
  final String text;

  const ThoughtBubble({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 15,
            spreadRadius: 2,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(
          color: Colors.blue.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(width: 8),
          // Speech bubble tail
          CustomPaint(
            size: const Size(15, 20),
            painter: _SpeechBubbleTailPainter(),
          ),
        ],
      ),
    );
  }
}

// Speech bubble tail painter
class _SpeechBubbleTailPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width / 2, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}