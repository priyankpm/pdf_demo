// Updated Memory Wall Storage Class

import 'dart:developer';

import 'package:hive_flutter/hive_flutter.dart';
import '../../models/memory_frame_model.dart';

class MemoryFrameStorage {
  static const _boxName = 'memory_frames';

  static Future<void> saveFrame(MemoryFrameModel frame) async {
    final box = await Hive.openBox(_boxName);
    final frames = (box.get('frames', defaultValue: []) as List).cast<Map>();

    // Check if frame with same id exists
    final index = frames.indexWhere((f) {
      return f['MemoryID'] == frame.id;
    });

    if (index >= 0) {
      frames[index] = frame.toJson();
      print("Updated frame with id: ${frame.id}");
    } else {
      if (frame.imagePath.isEmpty) {
        final hasEmptyFrame = frames.any((f) =>
        (f['ImagePath'] == null || f['ImagePath'] == ''));
        if (hasEmptyFrame) {
          return;
        }
      }

      // Add new frame
      frames.add(frame.toJson());
      print("➕ Added new frame with id: ${frame.id}");
    }

    await box.put('frames', frames);
  }

  // Add this new method to update frame ID after Supabase sync
  static Future<void> updateFrameIdInHive(
      String oldId,
      MemoryFrameModel updatedFrame
      ) async {
    final box = await Hive.openBox(_boxName);
    final frames = (box.get('frames', defaultValue: []) as List).cast<Map>();

    final index = frames.indexWhere((f) {
      return f['MemoryID'] == oldId;
    });

    if (index >= 0) {
      frames[index] = updatedFrame.toJson();
      log("Updated frame ID from $oldId to ${updatedFrame.id}");
    }

    await box.put('frames', frames);
  }

  static Future<List<MemoryFrameModel>> getFrames() async {
    final box = await Hive.openBox(_boxName);
    final frames = box.get('frames', defaultValue: []) as List;

    return frames.map((e) {
      return MemoryFrameModel.fromJson(Map<String, dynamic>.from(e));
    }).toList();
  }

  static Future<void> deleteFrame(String frameId) async {
    final box = await Hive.openBox(_boxName);
    final frames = (box.get('frames', defaultValue: []) as List).cast<Map>();

    frames.removeWhere((f) => f['MemoryID'] == frameId);
    await box.put('frames', frames);
    print("Deleted frame with id: $frameId");
  }

  static Future<void> clearFrames() async {
    final box = await Hive.openBox(_boxName);
    await box.put('frames', []);
  }

  static Future<void> overwriteFrames(List<MemoryFrameModel> frames) async {
    final box = await Hive.openBox(_boxName);
    await box.put('frames', frames.map((f) => f.toJson()).toList());
  }
}