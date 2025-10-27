import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:whiskers_flutter_app/src/view/LearningVoiceScreen.dart';
import '../../../common_utility/common_utility.dart';
import '../../../models/food_state_model.dart';
import '../../../provider.dart'
    show backgroundImageProvider, foodViewModelProvider, sharedPreferencesServiceProvider, mediaViewModelProvider, dataSyncServiceProvider, navigationServiceProvider;
import '../../../util/app_haptic_feedback.dart';
import '../../../viewmodel/video/gif_controller.dart';
import '../../common_widgets/custom_carousel.dart';
import '../animation_player/data_manager.dart';

final Map<int, String> _defaultImages = {
  0: 'assets/samples/living.jpg',
  1: 'assets/samples/bedroom.jpg',
  2: 'assets/samples/kitchen.jpg',
};

class EatScreen extends ConsumerStatefulWidget {
  const EatScreen({
    required this.flickManager,
    required this.dataManager,
    required this.pauseOnTap,
    super.key,
  });

  final FlickManager flickManager;
  final AnimationPlayerDataManager dataManager;
  final bool pauseOnTap;

  @override
  ConsumerState<EatScreen> createState() => _EatScreenState();
}

class _EatScreenState extends ConsumerState<EatScreen> {
  final ValueNotifier<DateTime?> lastFoodDropTimeNotifier =
      ValueNotifier<DateTime?>(null);
  final ValueNotifier<int?> selectedFoodIndexNotifier = ValueNotifier<int?>(
    null,
  );

  Timer? _eatingTimer;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeScreen();
    });
  }

  Future<void> _initializeScreen() async {
    if (!_isInitialized) {
      ref.read(videoControllerProvider.notifier).updateCurrentScreen('eat');
      await ref.read(foodViewModelProvider.notifier).init();
      _isInitialized = true;
    }
  }

  String _getKitchenImage() {
    final backgroundState = ref.read(backgroundImageProvider);

    if (backgroundState.isNotEmpty && backgroundState.length > 2) {
      final kitchenImage = backgroundState[2];
      final kitchenImagePath = kitchenImage.path;
      if (!kitchenImagePath.startsWith('assets/')) {
        final file = File(kitchenImagePath);
        if (file.existsSync()) {
          return kitchenImagePath;
        }
      } else {
        return kitchenImagePath;
      }
    }

    return _defaultImages[2]!;
  }

  Future<void> _handleFoodDrop(FoodStateModel droppedModel) async {
    if (droppedModel.isHidden || droppedModel.remainingPortions <= 0) return;

    HapticFeedback.hapticFeedback();

    // Use the ViewModel to consume the portion
    await ref
        .read(foodViewModelProvider.notifier)
        .consumePortion(droppedModel.foodIndex);

    // Check if food is now fully consumed
    final updatedState = ref
        .read(foodViewModelProvider.notifier)
        .getFoodStateByIndex(droppedModel.foodIndex);
    if (updatedState != null && updatedState.remainingPortions <= 0) {
      selectedFoodIndexNotifier.value = null;
    }

    final now = DateTime.now();
    lastFoodDropTimeNotifier.value = now;

    ref.read(videoControllerProvider.notifier).handleFoodDrop();

    _eatingTimer?.cancel();
    _eatingTimer = Timer(const Duration(seconds: 5), () {
      if (lastFoodDropTimeNotifier.value != null &&
          DateTime.now().difference(lastFoodDropTimeNotifier.value!) >=
              const Duration(seconds: 5)) {
        ref
            .read(videoControllerProvider.notifier)
            .updatePetState(PetState.idle);
      }
    });
  }

  bool _isSyncing = false;

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

  void _navigateToNextScreen() {
    ref.read(navigationServiceProvider).pushNamed(RoutePaths.videoScreen);
  }

  @override
  Widget build(BuildContext context) {
    final videoController = ref.watch(videoControllerProvider);
    final foodStates = ref.watch(foodViewModelProvider);
    final kitchenImagePath = _getKitchenImage();

    return VisibilityDetector(
      key: ObjectKey(widget.flickManager),
      onVisibilityChanged: (visibility) {
        if (visibility.visibleFraction == 0) {
          widget.flickManager.flickControlManager!.autoPause();
        } else if (visibility.visibleFraction == 1) {
          widget.flickManager.flickControlManager!.autoResume();
        }
      },
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: kitchenImagePath.startsWith('assets/')
                ? AssetImage(kitchenImagePath) as ImageProvider
                : FileImage(File(kitchenImagePath)) as ImageProvider,
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: <Widget>[
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  DragTarget<FoodStateModel>(
                    onWillAcceptWithDetails: (details) =>
                        !details.data.isHidden &&
                        details.data.remainingPortions > 0,
                    onLeave: (foodState) {},
                    onAcceptWithDetails: (details) {
                      _handleFoodDrop(details.data);
                    },
                    builder: (context, candidateData, rejectedData) {
                      return SizedBox(
                        height: 360,
                        child: _buildPetImage(videoController.currentGifPath),
                      );
                    },
                  ),
                  SizedBox(
                    height: 250,
                    child: Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.center,
                      children: [
                        Positioned.fill(
                          child: Image.asset(
                            tableJpgPhoto,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(color: Colors.brown[300]);
                            },
                          ),
                        ),
                        Positioned(
                          bottom: 10,
                          left: 0,
                          right: 0,
                          child: _buildFoodCarousel(foodStates),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 160,
              left: 0,
              right: 0,
              child: ValueListenableBuilder<int?>(
                valueListenable: selectedFoodIndexNotifier,
                builder: (context, selectedIndex, _) {
                  if (selectedIndex == null ||
                      selectedIndex >= foodStates.length) {
                    return const SizedBox.shrink();
                  }

                  final selectedFood = foodStates[selectedIndex];

                  if (selectedFood.isHidden ||
                      selectedFood.remainingPortions <= 0) {
                    return const SizedBox.shrink();
                  }

                  return Center(child: _buildFoodItemBig(selectedFood));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPetImage(String imagePath) {
    if (imagePath.startsWith('assets/')) {
      return Image.asset(
        imagePath,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          print('Error loading asset: $imagePath - $error');
          return Image.asset(
            'assets/pet/natural.gif',
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.grey[200],
                child: const Icon(Icons.pets, size: 150),
              );
            },
          );
        },
      );
    } else {
      final file = File(imagePath);
      if (file.existsSync()) {
        return Image.file(
          file,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return Image.asset('assets/pet/natural.gif', fit: BoxFit.contain);
          },
        );
      } else {
        return Image.asset('assets/pet/natural.gif', fit: BoxFit.contain);
      }
    }
  }

  Widget _buildFoodCarousel(List<FoodStateModel> foodStates) {
    final visibleFoodStates = foodStates
        .where((state) => !state.isHidden && state.remainingPortions > 0)
        .toList();

    if (visibleFoodStates.isEmpty) {
      return Center(
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Text(
            'All food consumed! Come back tomorrow',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }

    return CustomCarousel<FoodStateModel>(
      items: visibleFoodStates,
      height: 90,
      isHorizontal: true,
      itemBuilder: (context, foodState, index) {
        final originalIndex = foodStates.indexOf(foodState);

        return GestureDetector(
          onTap: () {
            if (!foodState.isHidden && foodState.remainingPortions > 0) {
              selectedFoodIndexNotifier.value = originalIndex;
            }
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              Image.asset(
                foodState.imagePath,
                fit: BoxFit.fill,
                width: 90,
                height: 90,
              ),
              if (foodState.remainingPortions < 3)
                Positioned(
                  top: 5,
                  right: 5,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${foodState.remainingPortions}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFoodItemBig(FoodStateModel foodState) {
    return Draggable<FoodStateModel>(
      data: foodState,
      feedback: Material(
        color: Colors.transparent,
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 198,
              height: 198,
              child: Image.asset(
                foodState.imagePath,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[300],
                    child: const Icon(Icons.food_bank),
                  );
                },
              ),
            ),
            if (foodState.remainingPortions > 0)
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${foodState.remainingPortions} ${foodState.remainingPortions == 1 ? 'bite' : 'bites'} left',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
      childWhenDragging: Opacity(
        opacity: 0.3,
        child: Container(
          width: 190,
          height: 190,
          color: Colors.transparent,
          child: Image.asset(
            foodState.imagePath,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.grey[300],
                child: const Icon(Icons.food_bank, size: 80),
              );
            },
          ),
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 190,
            height: 190,
            color: Colors.transparent,
            child: Image.asset(
              foodState.imagePath,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[300],
                  child: const Icon(Icons.food_bank, size: 80),
                );
              },
            ),
          ),
          if (foodState.remainingPortions < 3)
            Positioned(
              bottom: 10,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.restaurant, color: Colors.white, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      '${foodState.remainingPortions} ${foodState.remainingPortions == 1 ? 'bite' : 'bites'} left',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _eatingTimer?.cancel();
    lastFoodDropTimeNotifier.dispose();
    selectedFoodIndexNotifier.dispose();
    super.dispose();
  }
}
