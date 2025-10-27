import 'dart:convert';
import 'dart:developer';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:whiskers_flutter_app/src/models/media_state_model.dart';

class MediaStorage {
  static const String _mediaBoxName = 'media_state_box';
  static const String _syncBoxName = 'sync_state_box';
  static const String _syncStateKey = 'sync_state';

  static Future<Box> _getMediaBox() async {
    if (!Hive.isBoxOpen(_mediaBoxName)) {
      return await Hive.openBox(_mediaBoxName);
    }
    return Hive.box(_mediaBoxName);
  }

  static Future<void> saveMedia(MediaStateModel media) async {
    try {
      final box = await _getMediaBox();
      await box.put(media.key, jsonEncode(media.toJson()));
      log('Media saved: ${media.key}');
    } catch (e) {
      log('Error saving media: $e');
    }
  }

  static Future<List<MediaStateModel>> getAllMedia() async {
    try {
      final box = await _getMediaBox();
      final List<MediaStateModel> mediaList = [];

      for (var key in box.keys) {
        final value = box.get(key);
        if (value != null) {
          final media = MediaStateModel.fromJson(jsonDecode(value as String));
          mediaList.add(media);
        }
      }

      log('Retrieved ${mediaList.length} media items');
      return mediaList;
    } catch (e) {
      log('Error getting media: $e');
      return [];
    }
  }

  static Future<MediaStateModel?> getMediaByKey(String key) async {
    try {
      final box = await _getMediaBox();
      final value = box.get(key);
      if (value != null) {
        return MediaStateModel.fromJson(jsonDecode(value as String));
      }
      return null;
    } catch (e) {
      log('Error getting media by key: $e');
      return null;
    }
  }

  static Future<MediaStateModel?> getMediaByAction(String action) async {
    try {
      final box = await _getMediaBox();

      for (var key in box.keys) {
        final value = box.get(key);
        if (value != null) {
          final media = MediaStateModel.fromJson(jsonDecode(value as String));
          if (media.action == action) {
            log('Found existing media for action "$action": ${media.key}');
            return media;
          }
        }
      }

      log('No existing media found for action "$action"');
      return null;
    } catch (e) {
      log('Error getting media by action: $e');
      return null;
    }
  }



  static Future<void> updateMedia(MediaStateModel media) async {
    try {
      final box = await _getMediaBox();
      await box.put(media.key, jsonEncode(media.toJson()));
      log('Media updated: ${media.key}');
    } catch (e) {
      log('Error updating media: $e');
    }
  }

  static Future<Map<String, MediaStateModel>> getMediaByActions() async {
    try {
      final box = await _getMediaBox();
      final Map<String, MediaStateModel> mediaMap = {};

      for (var key in box.keys) {
        final value = box.get(key);
        if (value != null) {
          final media = MediaStateModel.fromJson(jsonDecode(value as String));
          // Map by action name (e.g., "chewing", "sleeping", etc.)
          mediaMap[media.action] = media;
        }
      }

      log('Retrieved ${mediaMap.length} media items by action');
      return mediaMap;
    } catch (e) {
      log('Error getting media by actions: $e');
      return {};
    }
  }

  static Future<void> deleteMedia(String key) async {
    try {
      final box = await _getMediaBox();
      await box.delete(key);
      log('Media deleted: $key');
    } catch (e) {
      log('Error deleting media: $e');
    }
  }

  static Future<Box> _getSyncBox() async {
    if (!Hive.isBoxOpen(_syncBoxName)) {
      return await Hive.openBox(_syncBoxName);
    }
    return Hive.box(_syncBoxName);
  }

  static Future<void> saveSyncState(SyncStateModel syncState) async {
    try {
      final box = await _getSyncBox();
      await box.put(_syncStateKey, jsonEncode(syncState.toJson()));
      log('Sync state saved');
    } catch (e) {
      log('Error saving sync state: $e');
    }
  }

  static Future<SyncStateModel> getSyncState() async {
    try {
      final box = await _getSyncBox();
      final value = box.get(_syncStateKey);

      if (value != null) {
        final syncState = SyncStateModel.fromJson(jsonDecode(value as String));
        log('Retrieved sync state: LastMedia=${syncState.lastMedia}');
        return syncState;
      } else {
        log('No sync state found, returning initial state');
        return SyncStateModel.initial();
      }
    } catch (e) {
      log('Error getting sync state: $e');
      return SyncStateModel.initial();
    }
  }

  static Future<void> updateSyncState({
    DateTime? lastMemory,
    DateTime? lastReminder,
    DateTime? lastMedia,
    List<String>? lastDownloaded,
  }) async {
    try {
      final currentState = await getSyncState();

      final updatedState = SyncStateModel(
        lastMemory: lastMemory ?? currentState.lastMemory,
        lastReminder: lastReminder ?? currentState.lastReminder,
        lastMedia: lastMedia ?? currentState.lastMedia,
        lastDownloaded: lastDownloaded ?? currentState.lastDownloaded,
      );

      await saveSyncState(updatedState);
      log('Sync state updated');
    } catch (e) {
      log('Error updating sync state: $e');
    }
  }
}
