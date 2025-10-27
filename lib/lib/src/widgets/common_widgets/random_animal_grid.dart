import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:whiskers_flutter_app/src/models/count_sheep_model.dart';

import '../../common_utility/common_utility.dart';
import '../../provider.dart';
import '../../util/app_haptic_feedback.dart';
import '../../viewmodel/video/gif_controller.dart';

class RandomAnimalGrid extends ConsumerStatefulWidget {
  const RandomAnimalGrid({
    super.key,
    this.onAllSheepCounted,
    this.onSheepSelected,
  });

  final VoidCallback? onAllSheepCounted;
  final Function(int selectedCount, int totalSheep)? onSheepSelected;

  @override
  ConsumerState<RandomAnimalGrid> createState() => RandomAnimalGridState();
}

class RandomAnimalGridState extends ConsumerState<RandomAnimalGrid> {
  late List<bool> animals;
  late List<int?> tappedOrder;
  int animalCount = 0;
  int totalSheep = 0;
  bool _allSheepCounted = false;
  bool _isInitialized = false;
  String? _petPortraitUrl;
  bool _isLoadingPetImage = true;

  @override
  void initState() {
    super.initState();

    // Initialize without setState
    animals = ref
        .read(countSheepProvider.notifier)
        .changeAnimalPositionToRandom();
    tappedOrder = List.filled(animals.length, null);
    totalSheep = animals.where((element) => element == true).length;
    animalCount = ref.read(countSheepProvider).sheepCount ?? 0;

    // Load pet portrait URL
    _loadPetPortraitUrl();

    // Mark as initialized after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _isInitialized = true;
      });
      widget.onSheepSelected?.call(animalCount, totalSheep);
    });
  }

  Future<void> _loadPetPortraitUrl() async {
    try {
      final prefsService = ref.read(sharedPreferencesServiceProvider);
      final url = await prefsService.getPetPortraitUrl();

      if (url != null && url.isNotEmpty) {
        setState(() {
          _petPortraitUrl = url;
        });
      }
    } catch (e) {
      // Handle error silently, will use default cat image
    } finally {
      setState(() {
        _isLoadingPetImage = false;
      });
    }
  }

  void _handleSheepTap(int index) {
    if (_allSheepCounted) return;

    final currentTapOrder = tappedOrder[index];
    if (currentTapOrder != null) return;

    if (animals[index]) {
      final newSheepCount = animalCount + 1;

      // Update provider state first
      ref
          .read(countSheepProvider.notifier)
          .notifyChanges(
            CountSheepModel(
              showCountSheepScreen: true,
              sheepCount: newSheepCount,
            ),
          );

      // Use Future.microtask to avoid setState during build
      Future.microtask(() {
        setState(() {
          tappedOrder[index] = newSheepCount;
          animalCount = newSheepCount;
        });

        widget.onSheepSelected?.call(newSheepCount, totalSheep);

        if (newSheepCount == totalSheep) {
          _allSheepCounted = true;
          widget.onAllSheepCounted?.call();
          widget.onSheepSelected?.call(newSheepCount, totalSheep);

          // Directly update video controller to ensure sleep state
          ref.read(videoControllerProvider.notifier).handleAllShipsCounted();
        }
      });
    } else {
      // Trigger haptic feedback when tapping on pet portrait
      HapticFeedback.hapticFeedback();

      // Immediately reset the grid without showing dialog
      _resetGrid();
    }
  }

  void _resetGrid() {
    // Update without setState during potential build
    Future.microtask(() {
      setState(() {
        animals = ref
            .read(countSheepProvider.notifier)
            .changeAnimalPositionToRandom();
        tappedOrder = List.filled(animals.length, null);
        animalCount = 0;
        _allSheepCounted = false;
        totalSheep = animals.where((element) => element == true).length;
      });

      ref
          .read(countSheepProvider.notifier)
          .notifyChanges(
            CountSheepModel(showCountSheepScreen: true, sheepCount: 0),
          );

      widget.onSheepSelected?.call(0, totalSheep);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Watch for provider changes without causing rebuild loops
    final int providerSheepCount = ref.watch(
      countSheepProvider.select((value) => value.sheepCount ?? 0),
    );

    // Sync with provider without setState during build
    if (providerSheepCount != animalCount && _isInitialized) {
      Future.microtask(() {
        setState(() {
          animalCount = providerSheepCount;
        });
      });
    }

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: List.generate(4, (rowIndex) {
            return getImageRow(
              rowAnimals: animals.sublist(rowIndex * 6, (rowIndex + 1) * 6),
              startIndex: rowIndex * 6,
              rowIndex: rowIndex,
            );
          }),
        ),
      ),
    );
  }

  Widget getImageRow({
    required List<bool> rowAnimals,
    required int startIndex,
    required int rowIndex,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: rowIndex == 3 ? 0:20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: List.generate(rowAnimals.length, (i) {
          final index = startIndex + i;
          return getImageAsset(rowAnimals[i], index);
        }),
      ),
    );
  }

  Widget getImageAsset(bool showSheep, int index) {
    final currentTapOrder = tappedOrder[index];

    return GestureDetector(
      onTap: () => _handleSheepTap(index),
      child: Container(
        width: 60,
        height: 65,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            if (showSheep)
              // Sheep image (unchanged)
              Image.asset(
                sheepAnimalPng,
                fit: BoxFit.contain,
                // color: currentTapOrder != null ? Colors.blue : null,
              )
            else
              // Pet portrait image (replaced cat with stored pet portrait)
              _buildPetPortraitImage(),

            if (showSheep && currentTapOrder != null)
              Image.asset(
                sheepAnimalBorderPng,
                fit: BoxFit.contain,
                // color: currentTapOrder != null ? Colors.blue : null,
              ),
            if (showSheep && currentTapOrder != null)
              Positioned(
                right: -2,
                top: -2,
                child: Container(
                  height: 14,
                  width: 14,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      currentTapOrder.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 8,
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

  Widget _buildPetPortraitImage() {
    if (_isLoadingPetImage) {
      return Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      );
    }

    if (_petPortraitUrl != null && _petPortraitUrl!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          _petPortraitUrl!,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                      : null,
                  strokeWidth: 2,
                ),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            // Fallback to default cat image if network image fails
            return Image.asset(
              catAnimalPng,
              width: 50,
              height: 50,
              fit: BoxFit.contain,
            );
          },
        ),
      );
    }

    // Fallback to default cat image if no pet portrait URL
    return Image.asset(
      catAnimalPng,
      width: 50,
      height: 50,
      fit: BoxFit.contain,
    );
  }
}
