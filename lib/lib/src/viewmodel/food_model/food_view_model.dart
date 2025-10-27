import 'dart:developer';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:whiskers_flutter_app/src/models/food_state_model.dart';
import '../../styles/utils/common_constants.dart';
import 'food_storage.dart';

class FoodViewModel extends StateNotifier<List<FoodStateModel>> {
  FoodViewModel(this.ref) : super([]);

  final Ref ref;

  static const Map<int, String> _foodImagePaths = {
    0: foodBowlJpgPhoto,
    1: foodBowlJpgPhoto2,
    2: foodBowlJpgPhoto3,
  };

  Future<void> init() async {
    try {
      final states = await FoodStorage.getOrCreateFoodStates();
      state = states;
      log('Food states initialized: ${states.length} items');
    } catch (e) {
      log('Error initializing food states: $e');
      state = _generateInitialStates();
    }
  }

  List<FoodStateModel> _generateInitialStates() {
    return List.generate(
      3,
          (i) => FoodStateModel.initial(i, _foodImagePaths[i]!),
    );
  }

  Future<void> consumePortion(int foodIndex) async {
    try {
      final currentStates = [...state];
      final stateIndex = currentStates.indexWhere((s) => s.foodIndex == foodIndex);

      if (stateIndex != -1) {
        final currentState = currentStates[stateIndex];

        if (currentState.remainingPortions > 0) {
          final newPortions = currentState.remainingPortions - 1;
          final updatedState = currentState.copyWith(
            remainingPortions: newPortions,
            isHidden: newPortions <= 0,
            lastUpdated: DateTime.now(),
          );

          await FoodStorage.updateFoodState(updatedState);

          currentStates[stateIndex] = updatedState;
          state = currentStates;

          log('Food $foodIndex consumed: $newPortions portions remaining');
        } else {
          log('Food $foodIndex already fully consumed');
        }
      }
    } catch (e) {
      log('Error consuming portion: $e');
    }
  }

  bool isFoodAvailable(int foodIndex) {
    try {
      final foodState = state.firstWhere(
            (s) => s.foodIndex == foodIndex,
        orElse: () => FoodStateModel.initial(
          foodIndex,
          _foodImagePaths[foodIndex] ?? foodBowlJpgPhoto,
        ),
      );
      return foodState.remainingPortions > 0 && !foodState.isHidden;
    } catch (e) {
      log('Error checking food availability: $e');
      return false;
    }
  }

  int getRemainingPortions(int foodIndex) {
    try {
      final foodState = state.firstWhere(
            (s) => s.foodIndex == foodIndex,
        orElse: () => FoodStateModel.initial(
          foodIndex,
          _foodImagePaths[foodIndex] ?? foodBowlJpgPhoto,
        ),
      );
      return foodState.remainingPortions;
    } catch (e) {
      log('Error getting remaining portions: $e');
      return 0;
    }
  }

  Future<void> resetAllFood() async {
    try {
      await FoodStorage.performDailyReset();
      await init();
      log('Manual food reset completed');
    } catch (e) {
      log('Error resetting food: $e');
    }
  }

  List<FoodStateModel> getVisibleFoodStates() {
    return state.where((s) => !s.isHidden && s.remainingPortions > 0).toList();
  }

  FoodStateModel? getFoodStateByIndex(int foodIndex) {
    try {
      return state.firstWhere(
            (s) => s.foodIndex == foodIndex,
        orElse: () => FoodStateModel.initial(
          foodIndex,
          _foodImagePaths[foodIndex] ?? foodBowlJpgPhoto,
        ),
      );
    } catch (e) {
      log('Error getting food state by index: $e');
      return null;
    }
  }

  bool get hasAnyFoodAvailable {
    return state.any((s) => !s.isHidden && s.remainingPortions > 0);
  }

  int get totalRemainingPortions {
    return state.fold(0, (sum, s) => sum + s.remainingPortions);
  }
}