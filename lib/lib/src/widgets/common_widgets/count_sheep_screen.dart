import 'dart:async';
import 'dart:ui';

import 'package:confetti/confetti.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:whiskers_flutter_app/src/provider.dart' hide PetState;
import 'package:whiskers_flutter_app/src/styles/resources.dart';
import 'package:whiskers_flutter_app/src/widgets/common_widgets/random_animal_grid.dart';

import '../../common_utility/common_utility.dart';
import '../../models/count_sheep_model.dart';
import '../../viewmodel/video/gif_controller.dart';

class CountSheepScreen extends ConsumerStatefulWidget {
  const CountSheepScreen({super.key});

  @override
  ConsumerState<CountSheepScreen> createState() => _CountSheepScreenState();
}

class _CountSheepScreenState extends ConsumerState<CountSheepScreen> {
  late ConfettiController _confettiController;
  bool _allSheepCounted = false;
  int _selectedCount = 0;
  int _totalSheep = 0;
  bool _isInitialized = false;
  bool _previousShowCountSheepScreen = false;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 5),
    );

    // Initialize after build is complete
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeCount();
    });
  }

  void _initializeCount() {
    if (!_isInitialized) {
      setState(() {
        _selectedCount = ref.read(countSheepProvider).sheepCount ?? 0;
        _isInitialized = true;
      });
    }
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _handleSheepSelected(int selectedCount, int totalSheep) {
    // Use Future.microtask to avoid setState during build
    Future.microtask(() {
      setState(() {
        _selectedCount = selectedCount;
        _totalSheep = totalSheep;
      });

      _checkAllShipsSelected();
    });
  }

  void _checkAllShipsSelected() {
    if (_selectedCount >= _totalSheep && _totalSheep > 0 && !_allSheepCounted) {
      setState(() {
        _allSheepCounted = true;
      });

      _confettiController.play();

      // Update pet state to sleeping when all ships are counted
      ref.read(videoControllerProvider.notifier).handleAllShipsCounted();

      Future.delayed(const Duration(seconds: 3), () {
        _closeScreen();
      });
    }
  }

  void _showHardDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        title: const Text("Complete the Task"),
        content: Text(
          _selectedCount == 0
              ? "You haven't counted any sheep yet! You need to count all sheep before you can sleep."
              : "You have selected $_selectedCount out of $_totalSheep sheep. "
                    "You must select all $_totalSheep sheep before you can go to sleep.",
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Just close the dialog
            },
            child: const Text("Continue Counting"),
          ),
        ],
      ),
    );
  }

  void _cancelAndReturnToSleep() {
    // Close the count sheep screen only - don't change pet state
    ref
        .read(countSheepProvider.notifier)
        .notifyChanges(
          CountSheepModel(showCountSheepScreen: false, sheepCount: 0),
        );
  }

  void _closeScreen() {
    if (_allSheepCounted) {
      ref.read(sleepImageProvider.notifier).updateImage(sleepCatImg);
      ref
          .read(countSheepProvider.notifier)
          .notifyChanges(
            CountSheepModel(showCountSheepScreen: false, sheepCount: 0),
          );
    } else {
      _showHardDialog();
    }
  }

  // Reset all state when screen is opened
  void _resetState() {
    setState(() {
      _allSheepCounted = false;
      _selectedCount = 0;
      _totalSheep = 0;
      _isInitialized = true;
    });

    // Reset the sheep count in provider
    ref
        .read(countSheepProvider.notifier)
        .notifyChanges(
          CountSheepModel(showCountSheepScreen: true, sheepCount: 0),
        );
  }

  @override
  Widget build(BuildContext context) {
    final Resources res = ref.read(resourceProvider);
    final bool showCountSheepScreen =
        ref.watch(countSheepProvider).showCountSheepScreen ?? false;

    // Watch for changes in sheep count without causing rebuild loops
    final int providerSheepCount = ref.watch(
      countSheepProvider.select((value) => value.sheepCount ?? 0),
    );

    // Reset state when screen becomes visible (opened)
    if (showCountSheepScreen && !_previousShowCountSheepScreen) {
      Future.microtask(() {
        _resetState();
      });
    }

    // Update the previous state
    _previousShowCountSheepScreen = showCountSheepScreen;

    // Update selected count from provider without setState during build
    if (providerSheepCount != _selectedCount && _isInitialized) {
      Future.microtask(() {
        setState(() {
          _selectedCount = providerSheepCount;
        });
      });
    }

    return showCountSheepScreen
        ? Material(
            color: Colors.transparent,
            child: GestureDetector(
              onTap: () {
                // When tapping outside, close the count sheep screen
                _cancelAndReturnToSleep();
              },
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: <Color>[
                        Color.fromRGBO(0, 0, 0, 0.3),
                        Color.fromRGBO(0, 0, 0, 0.3),
                      ],
                    ),
                    border: Border.all(color: Colors.black, width: 1),
                  ),
                  child: Stack(
                    children: [
                      // Prevent taps on the background from closing when tapping inside the container
                      GestureDetector(
                        onTap: () {
                          // Do nothing - prevent background tap from closing
                        },
                        child: Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              top: 100,
                              bottom: 90,
                            ),
                            child: Container(
                              width: 390,
                              height: 631,
                              decoration: BoxDecoration(
                                color: res.themes.paleYellow,
                                border: Border.all(
                                  color: Colors.transparent,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                children: [
                                  Align(
                                    alignment: AlignmentGeometry.centerRight,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        right: 15,
                                        top: 15,
                                      ),
                                      child: GestureDetector(
                                        onTap: () => _cancelAndReturnToSleep(),
                                        child: Container(
                                          padding: EdgeInsets.all(2),
                                          decoration: BoxDecoration(
                                            color: Colors.black.withOpacity(
                                              0.05,
                                            ),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            Icons.close,
                                            size: 18,
                                            color: Color(0xFF666666),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const Align(
                                    alignment: Alignment.topCenter,
                                    child: Text(
                                      'Count Sheep',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),

                                  SizedBox(height: 15),
                                  Align(
                                    alignment: Alignment.topCenter,
                                    child: Text(
                                      _totalSheep > 0
                                          ? 'Selected: $_selectedCount/$_totalSheep\nTap on all sheep to count them'
                                          : 'Tap on all sheep to count them',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),

                                  RandomAnimalGrid(
                                    onAllSheepCounted: () {
                                      // This will be called when all sheep are counted via the old callback
                                      if (!_allSheepCounted) {
                                        _confettiController.play();
                                        ref
                                            .read(
                                              videoControllerProvider.notifier,
                                            )
                                            .handleAllShipsCounted();
                                        Future.delayed(
                                          const Duration(seconds: 3),
                                          () {
                                            _closeScreen();
                                          },
                                        );
                                      }
                                    },
                                    onSheepSelected: _handleSheepSelected,
                                  ),

                                  Text(
                                    _totalSheep > 0
                                        ? 'Progress: $_selectedCount/$_totalSheep'
                                        : 'Progress: $_selectedCount/?',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  if (!_allSheepCounted)
                                    ElevatedButton(
                                      onPressed: _showHardDialog,
                                      child: const Text("Check if I can sleep"),
                                    ),
                                  const SizedBox(height: 35),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 15, 15, 0),
                          child: GestureDetector(
                            onTap: _cancelAndReturnToSleep,
                            child: Container(
                              width: 24,
                              height: 24,
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: res.themes.grey100,
                                borderRadius: BorderRadius.circular(29),
                              ),
                              child: const Center(
                                child: Icon(Icons.close, size: 16),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topCenter,
                        child: ConfettiWidget(
                          confettiController: _confettiController,
                          blastDirectionality: BlastDirectionality.explosive,
                          shouldLoop: false,
                          colors: const [
                            Colors.green,
                            Colors.blue,
                            Colors.pink,
                            Colors.orange,
                            Colors.purple,
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        : Container();
  }
}
