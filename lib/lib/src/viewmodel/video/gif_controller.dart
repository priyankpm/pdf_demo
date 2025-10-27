import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whiskers_flutter_app/src/viewmodel/data_sync/media_storage.dart';

// Enhanced Pet states
enum PetState {
  idle, // Natural state - Phase 1
  happy, // Happy state
  eating, // Eating state - NOW DYNAMIC!
  sleeping, // Sleeping state - Phase 2
  petting, // Petting state
  listening, // Listening to user
  talking, // Responding to user
  surprised, // Surprised state
  sad, // Sad state
}

// Video controller provider
final videoControllerProvider =
    StateNotifierProvider<VideoController, VideoControllerState>((ref) {
      return VideoController();
    });

// Video controller state
class VideoControllerState {
  final PetState currentState;
  final PetState previousState;
  final bool isPlaying;
  final String currentGifPath;
  final Map<PetState, DateTime> stateHistory;
  final Map<PetState, int> visitCount;
  final String currentScreen;
  final Map<String, String> dynamicMediaPaths; // NEW: Store dynamic media paths

  const VideoControllerState({
    required this.currentState,
    required this.previousState,
    required this.isPlaying,
    required this.currentGifPath,
    required this.stateHistory,
    required this.visitCount,
    required this.currentScreen,
    this.dynamicMediaPaths = const {},
  });

  VideoControllerState copyWith({
    PetState? currentState,
    PetState? previousState,
    bool? isPlaying,
    String? currentGifPath,
    Map<PetState, DateTime>? stateHistory,
    Map<PetState, int>? visitCount,
    String? currentScreen,
    Map<String, String>? dynamicMediaPaths,
  }) {
    return VideoControllerState(
      currentState: currentState ?? this.currentState,
      previousState: previousState ?? this.previousState,
      isPlaying: isPlaying ?? this.isPlaying,
      currentGifPath: currentGifPath ?? this.currentGifPath,
      stateHistory: stateHistory ?? this.stateHistory,
      visitCount: visitCount ?? this.visitCount,
      currentScreen: currentScreen ?? this.currentScreen,
      dynamicMediaPaths: dynamicMediaPaths ?? this.dynamicMediaPaths,
    );
  }
}

// Main video controller
class VideoController extends StateNotifier<VideoControllerState> {
  Timer? _stateTimer;

  VideoController()
    : super(
        VideoControllerState(
          currentState: PetState.idle,
          previousState: PetState.idle,
          isPlaying: false,
          currentGifPath: "assets/pet/natural.gif",
          stateHistory: {},
          visitCount: {},
          currentScreen: 'home',
          dynamicMediaPaths: {}, // ✅ Initialize as empty map, not const {}
        ),
      ) {
    _initializeHistory();
    _loadSleepState();
    _loadDynamicMedia();
  }

  // Initialize state history
  void _initializeHistory() {
    final now = DateTime.now();
    final initialHistory = <PetState, DateTime>{};
    final initialCount = <PetState, int>{};

    for (final petState in PetState.values) {
      initialHistory[petState] = now.subtract(const Duration(days: 1));
      initialCount[petState] = 0;
    }

    // ✅ IMPORTANT: Don't use copyWith here, directly assign
    state = VideoControllerState(
      currentState: state.currentState,
      previousState: state.previousState,
      isPlaying: state.isPlaying,
      currentGifPath: state.currentGifPath,
      stateHistory: initialHistory,
      visitCount: initialCount,
      currentScreen: state.currentScreen,
      dynamicMediaPaths: state.dynamicMediaPaths, // ✅ Preserve this!
    );
  }

  // Load sleep state from storage
  Future<void> _loadSleepState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final sleepCompleted = prefs.getBool('sleep_completed') ?? false;

      if (sleepCompleted) {
        final lastSleepTime = prefs.getInt('last_sleep_time') ?? 0;
        final lastSleep = DateTime.fromMillisecondsSinceEpoch(lastSleepTime);
        final now = DateTime.now();

        if (now.difference(lastSleep).inMinutes < 30) {
          // ✅ Use copyWith properly
          state = state.copyWith(
            currentState: PetState.sleeping,
            currentGifPath: _getGifPathForState(PetState.sleeping),
          );
        } else {
          await _clearSleepCompletion();
          state = state.copyWith(
            currentState: PetState.idle,
            currentGifPath: _getGifPathForState(PetState.idle),
          );
        }
      }
    } catch (e) {
      print('Error loading sleep state: $e');
    }
  }

  // NEW: Load all dynamic media from storage
  Future<void> _loadDynamicMedia() async {
    try {
      final mediaMap = await MediaStorage.getMediaByActions();
      final pathMap = <String, String>{};

      // Map action names to their file paths
      for (var entry in mediaMap.entries) {
        if (entry.value.isDownloaded &&
            entry.value.downloadedAssetPath.isNotEmpty) {
          pathMap[entry.key] = entry.value.downloadedAssetPath;
          print(
            'Loaded dynamic media for action "${entry.key}": ${entry.value.downloadedAssetPath}',
          );
        }
      }

      state = state.copyWith(dynamicMediaPaths: pathMap);
      print('Loaded ${pathMap.length} dynamic media files');
    } catch (e) {
      print('Error loading dynamic media: $e');
    }
  }

  // Map pet states to GIF assets (with dynamic media support)
  String _getGifPathForState(PetState petState) {
    switch (petState) {
      case PetState.idle:
        return "assets/pet/natural.gif";
      case PetState.happy:
        return "assets/pet/happy.gif";
      case PetState.eating:
        final dynamicPaths = state.dynamicMediaPaths;
        final chewingPath = dynamicPaths['chewing'];
        if (chewingPath != null && chewingPath.isNotEmpty) {
          print('Using dynamic chewing media: $chewingPath');
          return chewingPath;
        }
        print('Fallback to static eating gif');
        return "assets/pet/eating.gif";
      case PetState.sleeping:
        return "assets/pet/sleep.png";
      case PetState.petting:
        return "assets/pet/petting.gif";
      case PetState.listening:
        return "assets/pet/happy.gif";
      case PetState.talking:
        return "assets/pet/happy.gif";
      case PetState.surprised:
        return "assets/pet/happy.gif";
      case PetState.sad:
        return "assets/pet/happy.gif";
    }
  }

  // Rest of your methods remain the same...
  void handleFoodDrop() {
    if (state.currentScreen == 'eat') {
      updatePetState(PetState.eating);
    }
  }

  void updatePetState(PetState newState, {bool immediate = true}) {
    _stateTimer?.cancel();

    final updatedHistory = Map<PetState, DateTime>.from(state.stateHistory);
    final updatedCount = Map<PetState, int>.from(state.visitCount);

    updatedHistory[newState] = DateTime.now();
    updatedCount[newState] = (updatedCount[newState] ?? 0) + 1;

    state = state.copyWith(
      previousState: state.currentState,
      currentState: newState,
      currentGifPath: _getGifPathForState(newState),
      isPlaying: true,
      stateHistory: updatedHistory,
      visitCount: updatedCount,
    );

    if (newState != PetState.sleeping) {
      _stateTimer = Timer(const Duration(seconds: 5), () {
        _returnToIdle();
      });
    }
  }

  void _returnToIdle() {
    state = state.copyWith(
      currentState: PetState.idle,
      currentGifPath: _getGifPathForState(PetState.idle),
      isPlaying: false,
    );
  }

  void updateCurrentScreen(String screenName) {
    state = state.copyWith(currentScreen: screenName);
  }

  void handleAllShipsCounted() {
    _storeSleepCompletion();
    updatePetState(PetState.sleeping);
  }

  Future<void> _storeSleepCompletion() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('sleep_completed', true);
      await prefs.setInt(
        'last_sleep_time',
        DateTime.now().millisecondsSinceEpoch,
      );
    } catch (e) {
      print('Error storing sleep completion: $e');
    }
  }

  void wakeUpFromSleep() {
    _clearSleepCompletion();
    updatePetState(PetState.idle);
  }

  Future<void> _clearSleepCompletion() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('sleep_completed');
      await prefs.remove('last_sleep_time');
    } catch (e) {
      print('Error clearing sleep completion: $e');
    }
  }

  void handlePetting() {
    updatePetState(PetState.petting);
  }

  void handleListening() {
    updatePetState(PetState.listening);
  }

  void handleTalking() {
    updatePetState(PetState.talking);
  }

  // NEW: Refresh dynamic media (call this after sync)
  Future<void> refreshDynamicMedia() async {
    await _loadDynamicMedia();

    // If currently in a state that uses dynamic media, update the path
    if (state.currentState == PetState.eating) {
      state = state.copyWith(
        currentGifPath: _getGifPathForState(PetState.eating),
      );
    }
  }

  // Getters
  String get currentGifPath => state.currentGifPath;
  PetState get currentState => state.currentState;
  bool get isSleeping => state.currentState == PetState.sleeping;

  @override
  void dispose() {
    _stateTimer?.cancel();
    super.dispose();
  }
}
