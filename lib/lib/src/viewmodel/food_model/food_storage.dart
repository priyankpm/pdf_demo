import 'dart:convert';
import 'dart:developer';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:whiskers_flutter_app/src/models/food_state_model.dart';

import '../../styles/utils/common_constants.dart';

class FoodStorage {
  static const String _boxName = 'food_state_box';

  static Future<Box> _getBox() async {
    if (!Hive.isBoxOpen(_boxName)) {
      return await Hive.openBox(_boxName);
    }
    return Hive.box(_boxName);
  }

  static Future<void> saveFoodState(FoodStateModel state) async {
    try {
      final box = await _getBox();
      await box.put(state.id, jsonEncode(state.toJson()));
      log('Food state saved: ${state.id}');
    } catch (e) {
      log('Error saving food state: $e');
    }
  }

  static Future<List<FoodStateModel>> getFoodStates() async {
    try {
      final box = await _getBox();
      final List<FoodStateModel> states = [];

      for (var key in box.keys) {
        final value = box.get(key);
        if (value != null) {
          final state = FoodStateModel.fromJson(jsonDecode(value as String));
          states.add(state);
        }
      }

      log('Retrieved ${states.length} food states');
      return states;
    } catch (e) {
      log('Error getting food states: $e');
      return [];
    }
  }

  static Future<FoodStateModel?> getFoodStateById(String id) async {
    try {
      final box = await _getBox();
      final value = box.get(id);
      if (value != null) {
        return FoodStateModel.fromJson(jsonDecode(value as String));
      }
      return null;
    } catch (e) {
      log('Error getting food state by ID: $e');
      return null;
    }
  }

  static Future<void> updateFoodState(FoodStateModel state) async {
    try {
      final box = await _getBox();
      await box.put(state.id, jsonEncode(state.toJson()));
      log('Food state updated: ${state.id}');
    } catch (e) {
      log('Error updating food state: $e');
    }
  }

  static Future<void> deleteFoodState(String id) async {
    try {
      final box = await _getBox();
      await box.delete(id);
      log('Food state deleted: $id');
    } catch (e) {
      log('Error deleting food state: $e');
    }
  }

  static Future<void> clearAllFoodStates() async {
    try {
      final box = await _getBox();
      await box.clear();
      log('All food states cleared');
    } catch (e) {
      log('Error clearing food states: $e');
    }
  }

  static Future<bool> needsDailyReset() async {
    try {
      final states = await getFoodStates();
      if (states.isEmpty) return false;

      final _ = DateTime.now();
      for (var state in states) {
        if (!state.isFromToday()) {
          return true;
        }
      }
      return false;
    } catch (e) {
      log('Error checking daily reset: $e');
      return false;
    }
  }

  static Future<void> performDailyReset() async {
    try {
      await clearAllFoodStates();

      final freshStates = [
        FoodStateModel.initial(0, foodBowlJpgPhoto),
        FoodStateModel.initial(1, foodBowlJpgPhoto2),
        FoodStateModel.initial(2, foodBowlJpgPhoto3),
      ];

      for (var state in freshStates) {
        await saveFoodState(state);
      }

      log('Daily reset completed - all food states refreshed');
    } catch (e) {
      log('Error performing daily reset: $e');
    }
  }

  static Future<List<FoodStateModel>> getOrCreateFoodStates() async {
    try {
      if (await needsDailyReset()) {
        log('Performing daily reset...');
        await performDailyReset();
      }

      var states = await getFoodStates();

      if (states.isEmpty) {
        log('No food states found, creating initial states');
        final initialStates = [
          FoodStateModel.initial(0, foodBowlJpgPhoto),
          FoodStateModel.initial(1, foodBowlJpgPhoto2),
          FoodStateModel.initial(2, foodBowlJpgPhoto3),
        ];

        for (var state in initialStates) {
          await saveFoodState(state);
        }
        states = await getFoodStates();
      }

      return states;
    } catch (e) {
      log('Error in getOrCreateFoodStates: $e');
      return [
        FoodStateModel.initial(0, foodBowlJpgPhoto),
        FoodStateModel.initial(1, foodBowlJpgPhoto2),
        FoodStateModel.initial(2, foodBowlJpgPhoto3),
      ];
    }
  }
}