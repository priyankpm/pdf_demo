import 'dart:io';

import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:whiskers_flutter_app/src/provider.dart' hide PetState;
import 'package:whiskers_flutter_app/src/widgets/common_widgets/thought_bubble.dart';

import '../../../models/count_sheep_model.dart';
import '../../../models/memory_frame_model.dart';
import '../../../viewmodel/video/gif_controller.dart';
import '../animation_player/data_manager.dart';

// Default images for fallback
final Map<int, String> _defaultImages = {
  0: 'assets/samples/living.jpg',
  1: 'assets/samples/bedroom.jpg',
  2: 'assets/samples/kitchen.jpg',
};

// Global variable for sleep state
bool _isProcessingTap = false;

class SleepScreen extends ConsumerStatefulWidget {
  const SleepScreen({
    required this.flickManager,
    required this.dataManager,
    required this.pauseOnTap,
    super.key,
  });

  final FlickManager flickManager;
  final AnimationPlayerDataManager dataManager;
  final bool pauseOnTap;

  @override
  ConsumerState<SleepScreen> createState() => _SleepScreenState();
}

class _SleepScreenState extends ConsumerState<SleepScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(videoControllerProvider.notifier).updateCurrentScreen('sleep');
    });
  }

  // Simple tap handler using only provider state
  void _handlePetTap() {
    // Prevent multiple taps
    if (_isProcessingTap) return;

    _isProcessingTap = true;

    final videoNotifier = ref.read(videoControllerProvider.notifier);
    final videoController = ref.read(videoControllerProvider);
    final currentPetState = videoController.currentState;

    print("🐾 Pet tapped. Current state: $currentPetState");

    if (currentPetState == PetState.sleeping) {
      print("🐾 Waking up pet...");

      // CLOSE COUNT SHEEP DIALOG IF IT'S OPEN
      final isCountSheepOpen = ref.read(countSheepProvider).showCountSheepScreen == true;
      if (isCountSheepOpen) {
        print("🔴 Closing count sheep dialog...");
        ref.read(countSheepProvider.notifier).notifyChanges(
          CountSheepModel(showCountSheepScreen: false, sheepCount: 0),
        );
      }

      videoNotifier.wakeUpFromSleep();

    } else if (currentPetState == PetState.idle) {
      print("🐏 Starting count sheep...");

      // Check if count sheep is already open
      final isCountSheepOpen = ref.read(countSheepProvider).showCountSheepScreen == true;
      if (!isCountSheepOpen) {
        ref.read(countSheepProvider.notifier).notifyChanges(
          CountSheepModel(showCountSheepScreen: true, sheepCount: 0),
        );
      } else {
        print("⚠️ Count sheep already showing");
      }
    }

    // Reset processing flag after delay
    Future.delayed(const Duration(milliseconds: 1000), () {
      _isProcessingTap = false;
    });
  }

  String? _getBackgroundImage(PetState currentState) {
    final backgroundState = ref.read(backgroundImageProvider);

    // Always use bedroom background for both idle and sleeping states
    if (currentState == PetState.idle || currentState == PetState.sleeping) {
      if (backgroundState.isNotEmpty &&
          backgroundState.length > 1 &&
          backgroundState[1] != null) {
        final bedroomImage = backgroundState[1]!;
        final path = bedroomImage.path;
        if (!path.startsWith('assets/')) {
          final file = File(path);
          if (file.existsSync()) return path;
        } else {
          return path;
        }
      }
      return _defaultImages[1]!; // Fallback to default bedroom
    }
    return null;
  }

  List<String> _getMemoryPhotos(WidgetRef ref) {
    final memoryFrameModel = ref.watch(memoryFrameProvider);
    if (memoryFrameModel == null || memoryFrameModel.isEmpty) return [];
    return memoryFrameModel
        .map((e) => e.imagePath)
        .where((p) => p.isNotEmpty)
        .toList();
  }

  Widget _buildSafeImage(String? imagePath,
      {double? width, double? height, BoxFit fit = BoxFit.cover}) {
    if (imagePath == null || imagePath.isEmpty) {
      return Container(color: const Color(0xFFF5E1C0), width: width, height: height);
    }
    return imagePath.startsWith('assets/')
        ? Image.asset(imagePath, width: width, height: height, fit: fit)
        : Image.file(File(imagePath), width: width, height: height, fit: fit);
  }

  @override
  Widget build(BuildContext context) {
    final sleepImage = ref.watch(sleepImageProvider);
    final videoController = ref.watch(videoControllerProvider);
    final currentPetState = videoController.currentState;

    final backgroundImagePath = _getBackgroundImage(currentPetState);
    final memoryPhotos = _getMemoryPhotos(ref);
    final hasMemoryPhotos = memoryPhotos.isNotEmpty;

    final isPetSleeping = currentPetState == PetState.sleeping;
    final isPetIdle = currentPetState == PetState.idle;

    return VisibilityDetector(
      key: ObjectKey(widget.flickManager),
      onVisibilityChanged: (visibility) {
        final control = widget.flickManager.flickControlManager!;
        if (visibility.visibleFraction == 0) {
          control.autoPause();
        } else if (visibility.visibleFraction == 1) {
          control.autoResume();
        }
      },
      child: Container(
        color: const Color(0xFFF5E1C0),
        child: Stack(
          children: [
            // Background - SAME FOR BOTH IDLE AND SLEEPING
            if (backgroundImagePath != null)
              Positioned.fill(child: _buildSafeImage(backgroundImagePath)),

            // Sleep overlay - ONLY show sleep image overlay when sleeping
            if (isPetSleeping && sleepImage.isNotEmpty)
              Positioned.fill(child: _buildSafeImage(sleepImage)),

            // Idle mode text cloud - ONLY show when idle
            if (isPetIdle)
              const Positioned(
                top: 60,
                left: 0,
                right: 0,
                child: CloudWithText(text: 'i am sleepy put me to sleep'),
              ),

            // Memory wall cloud - ONLY show when sleeping and has photos
            if (isPetSleeping && hasMemoryPhotos)
              Positioned(
                top: 40,
                left: 0,
                right: 0,
                child: CloudWithText(imagePaths: memoryPhotos),
              ),

            // Pet image / GIF - ONLY THIS IS TAPPABLE
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: GestureDetector(
                onTap: _handlePetTap,
                child: MouseRegion(
                  cursor: (isPetSleeping || isPetIdle)
                      ? SystemMouseCursors.click
                      : SystemMouseCursors.basic,
                  child: Container(
                    color: Colors.transparent,
                    height: MediaQuery.of(context).size.height * 0.5,
                    width: double.infinity,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.5,
                        width: double.infinity,
                        child: _buildSafeImage(
                          videoController.currentGifPath,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}