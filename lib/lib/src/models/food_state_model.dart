import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'food_state_model.freezed.dart';

@freezed
abstract class FoodStateModel with _$FoodStateModel {
  const factory FoodStateModel({
    String? id,
    required String imagePath,
    required int foodIndex,
    required int remainingPortions,
    required DateTime lastUpdated,
    @Default(false) bool isHidden,
    required ValueKey key,
  }) = _FoodStateModel;

  const FoodStateModel._();

  factory FoodStateModel.fromJson(Map<String, dynamic> json) {
    print('==json===${json}');
    return FoodStateModel(
      id: json['FoodStateID'] as String?,
      imagePath: json['ImagePath'] as String,
      foodIndex: json['FoodIndex'] as int,
      remainingPortions: json['RemainingPortions'] as int,
      lastUpdated: DateTime.parse(json['LastUpdated'] as String),
      isHidden: json['IsHidden'] as bool? ?? false,
      key: ValueKey('foodBowl${json['FoodIndex']}'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'FoodStateID': id,
      'ImagePath': imagePath,
      'FoodIndex': foodIndex,
      'RemainingPortions': remainingPortions,
      'LastUpdated': lastUpdated.toIso8601String(),
      'IsHidden': isHidden,
    };
  }

  Map<String, dynamic> toApiJson() {
    return {
      'ImagePath': imagePath,
      'FoodIndex': foodIndex,
      'RemainingPortions': remainingPortions,
      'LastUpdated': lastUpdated.toIso8601String(),
      'IsHidden': isHidden,
    };
  }

  bool isFromToday() {
    final now = DateTime.now();
    return lastUpdated.year == now.year &&
        lastUpdated.month == now.month &&
        lastUpdated.day == now.day;
  }

  factory FoodStateModel.initial(int foodIndex, String imagePath) {
    return FoodStateModel(
      id: 'food_$foodIndex',
      imagePath: imagePath,
      foodIndex: foodIndex,
      remainingPortions: 3,
      lastUpdated: DateTime.now(),
      isHidden: false,
      key: ValueKey('foodBowl$foodIndex'),
    );
  }
}