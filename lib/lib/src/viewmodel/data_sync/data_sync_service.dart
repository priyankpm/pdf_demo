import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:whiskers_flutter_app/src/models/media_state_model.dart';
import 'package:whiskers_flutter_app/src/models/memory_frame_model.dart';
import 'package:whiskers_flutter_app/src/models/schedule_reminder_model.dart';
import 'package:whiskers_flutter_app/src/services/supabase_service.dart';
import 'package:whiskers_flutter_app/src/viewmodel/data_sync/media_download_service.dart';
import 'package:whiskers_flutter_app/src/viewmodel/data_sync/media_storage.dart';
import 'package:whiskers_flutter_app/src/viewmodel/schedule_screen/schedule_storage.dart';
import 'package:whiskers_flutter_app/src/viewmodel/video/memory_frame_storage.dart';

class DataSyncService {
  final SupabaseService _supabaseService = SupabaseService();
  final MediaDownloadService _downloadService = MediaDownloadService();

  Future<DataSyncResult?> syncData(BuildContext context) async {
    try {
      final syncState = await MediaStorage.getSyncState();
      log('Current sync state: $syncState');
      final requestBody = syncState.toJson();

      final response = await _supabaseService.post(
        context,
        functionName: 'data-sync',
        body: /*{
          "LastMemory": "1970-01-01 00:00:00.000000+00:00",
          "LastReminder": "1970-01-01 00:00:00.000000+00:00",
          "LastMedia": "1970-01-01 00:00:00.000000+00",
          "LastDownloaded": [],
        }*/ requestBody,
      );

      if (response == null) {
        log('Sync API returned null response');
        return null;
      }

      log('Sync API response: $response');

      final syncResult = DataSyncResult.fromJson(response);
      log('Parsed sync result - Media count: ${syncResult.media.length}');

      if (syncResult.media.isNotEmpty) {
        await _processMediaItems(syncResult.media);
      }

      if (syncResult.reminders.isNotEmpty) {
        await _processReminders(syncResult.reminders);
      }

      if (syncResult.memories.isNotEmpty) {
        await _processMemories(syncResult.memories);
      }
      await _updateSyncState(syncResult);

      log('Data sync completed successfully');
      return syncResult;
    } catch (e) {
      log('Error during data sync: $e');
      return null;
    }
  }

  /// Process and download media items
  Future<void> _processMediaItems(List<MediaStateModel> mediaItems) async {
    try {
      log('Processing ${mediaItems.length} media items');

      for (var media in mediaItems) {
        final existingMedia = await MediaStorage.getMediaByAction(media.action);

        if (existingMedia != null) {
          log('Found existing media for action "${media.action}": ${existingMedia.key}');
          await MediaStorage.deleteMedia(existingMedia.key);
          log('Deleted old media for action "${media.action}"');
        }

        final url = media.downloadedAssetPath;

        final downloadUrl = url;

        log('Downloading from URL: $downloadUrl');

        final localPath = await _downloadService.downloadMedia(
          url: downloadUrl,
          key: media.key,
          type: media.type,
        );

        if (localPath != null) {
          final downloadedMedia = media.copyWith(
            downloadedAssetPath: localPath,
            isDownloaded: true,
            downloadedAt: DateTime.now(),
          );

          await MediaStorage.saveMedia(downloadedMedia);
          log('Media downloaded and saved: ${media.key}');
        } else {
          final failedMedia = media.copyWith(
            downloadedAssetPath: '',
            isDownloaded: false,
          );
          await MediaStorage.saveMedia(failedMedia);
          log('Media info saved (download failed): ${media.key}');
        }
      }

      log('Finished processing media items');
    } catch (e) {
      log('Error processing media items: $e');
    }
  }

  Future<void> _processReminders(List<ReminderModel> reminders) async {
    try {
      log('Processing ${reminders.length} reminders from API');

      final existingReminders = await ReminderStorage.getReminders();
      final existingIds = existingReminders.map((r) => r.id).toSet();

      for (var reminder in reminders) {
        if (existingIds.contains(reminder.id)) {
          log(
            'Skipping duplicate reminder: ${reminder.id} - ${reminder.title}',
          );
          continue;
        }

        await ReminderStorage.saveReminder(reminder);
        log('Saved new reminder from API: ${reminder.id} - ${reminder.title}');
      }

      log('Finished processing reminders');
    } catch (e) {
      log('Error processing reminders: $e');
    }
  }


  Future<void> _processMemories(List<MemoryFrameModel> memories) async {
    try {
      log('Processing ${memories.length} memories from API');

      final existingMemories = await MemoryFrameStorage.getFrames();
      final existingIds = existingMemories.map((m) => m.id).toSet();

      for (var memory in memories) {
        if (existingIds.contains(memory.id)) {
          log('Skipping duplicate memory: ${memory.id} - ${memory.title}');
          continue;
        }
        await MemoryFrameStorage.saveFrame(memory);
        log('Saved new memory from API: ${memory.id} - ${memory.title}');
      }

      log('Finished processing memories');
    } catch (e) {
      log('Error processing memories: $e');
    }
  }


  Future<void> _updateSyncState(DataSyncResult syncResult) async {
    try {
      final currentState = await MediaStorage.getSyncState();
      log('Updating sync state from: $currentState');

      DateTime newLastMemory = currentState.lastMemory;
      DateTime newLastReminder = currentState.lastReminder;
      DateTime newLastMedia = currentState.lastMedia;

      if (syncResult.lastMemoryTimestamp != null) {
        if (syncResult.lastMemoryTimestamp!.isAfter(currentState.lastMemory)) {
          newLastMemory = syncResult.lastMemoryTimestamp!;
          log('Updated lastMemory to: $newLastMemory');
        }
      }

      if (syncResult.lastReminderTimestamp != null) {
        if (syncResult.lastReminderTimestamp!.isAfter(
          currentState.lastReminder,
        )) {
          newLastReminder = syncResult.lastReminderTimestamp!;
          log('Updated lastReminder to: $newLastReminder');
        }
      }

      if (syncResult.media.isNotEmpty) {
        final latestMediaTime = syncResult.media
            .map((m) => m.downloadedAt)
            .reduce((a, b) => a.isAfter(b) ? a : b);

        if (latestMediaTime.isAfter(currentState.lastMedia)) {
          newLastMedia = latestMediaTime;
          log('Updated lastMedia to latest media time: $newLastMedia');
        }
      } else if (syncResult.lastMediaTimestamp != null) {
        if (syncResult.lastMediaTimestamp!.isAfter(currentState.lastMedia)) {
          newLastMedia = syncResult.lastMediaTimestamp!;
          log('No media but using API LastMedia timestamp: $newLastMedia');
        }
      } else {
        final initialDate = DateTime.parse('1970-01-01 00:00:00.000000+00:00');
        if (currentState.lastMedia.isAtSameMomentAs(initialDate)) {
          newLastMedia = DateTime.now();
          log('Initial sync with no media - using current time: $newLastMedia');
        } else {
          log('No media and no API timestamp - keeping existing lastMedia');
        }
      }

      final downloadedKeys = syncResult.media
          .where((m) => m.isDownloaded)
          .map((m) => m.key)
          .toList();

      await MediaStorage.updateSyncState(
        lastMemory: newLastMemory,
        lastReminder: newLastReminder,
        lastMedia: newLastMedia,
        lastDownloaded: downloadedKeys,
      );

      log('Sync state updated successfully');
      log('  - LastMemory: $newLastMemory');
      log('  - LastReminder: $newLastReminder');
      log('  - LastMedia: $newLastMedia');
      log('  - Downloaded keys: ${downloadedKeys.length}');
    } catch (e) {
      log('Error updating sync state: $e');
    }
  }
}

class DataSyncResult {
  final List<MediaStateModel> media;
  final List<MemoryFrameModel> memories;

  final List<ReminderModel> reminders;
  final DateTime? lastMemoryTimestamp;
  final DateTime? lastReminderTimestamp;

  final DateTime? lastMediaTimestamp;

  DataSyncResult({
    required this.media,   required this.memories,
    required this.reminders,
    this.lastMemoryTimestamp,
    this.lastReminderTimestamp,
    this.lastMediaTimestamp,
  });

  factory DataSyncResult.fromJson(Map<String, dynamic> json) {
    log('Parsing DataSyncResult from JSON');
    log('JSON keys: ${json.keys.toList()}');

    Map<String, dynamic> dataJson = json;

    if (json.containsKey('data') && json['data'] != null) {
      log('Found "data" wrapper in response');
      dataJson = json['data'] as Map<String, dynamic>;
      log('Actual data keys: ${dataJson.keys.toList()}');
    }

    final mediaList = <MediaStateModel>[];

    if (dataJson['Media'] != null && dataJson['Media'] is List) {
      final mediaJsonList = dataJson['Media'] as List;
      log('Media list found with ${mediaJsonList.length} items');

      for (var i = 0; i < mediaJsonList.length; i++) {
        try {
          final item = mediaJsonList[i] as Map<String, dynamic>;
          log(
            'Parsing media item $i: url=${item['url']}, key=${item['key']}, type=${item['type']}, action=${item['action']}',
          );
          final mediaItem = MediaStateModel(
            key: item['key'] as String,
            type: item['type'] as String,
            action: item['action'] as String,
            downloadedAssetPath: item['url'] as String,
            downloadedAt: DateTime.now(),
            isDownloaded: false,
          );

          mediaList.add(mediaItem);
          log('Successfully parsed media item $i');
        } catch (e) {
          log('Error parsing media item $i: $e');
        }
      }
    } else {
      log('No Media list in response or Media is not a List');
    }

    final reminderList = <ReminderModel>[];
    if (dataJson['Reminders'] != null && dataJson['Reminders'] is List) {
      final reminderJsonList = dataJson['Reminders'] as List;
      log('Reminders list found with ${reminderJsonList.length} items');

      for (var i = 0; i < reminderJsonList.length; i++) {
        try {
          final item = reminderJsonList[i] as Map<String, dynamic>;
          log(
            'Parsing reminder item $i: ${item['ReminderID']} - ${item['Title']}',
          );

          final reminder = ReminderModel.fromJson(item);
          reminderList.add(reminder);
          log('Successfully parsed reminder item $i');
        } catch (e) {
          log('Error parsing reminder item $i: $e');
        }
      }
    } else {
      log(
        'No Reminders list in response or Reminders is not a List. Reminders value: ${dataJson['Reminders']}',
      );
    }

    final memoryList = <MemoryFrameModel>[];
    if (dataJson['Memories'] != null && dataJson['Memories'] is List) {
      final memoryJsonList = dataJson['Memories'] as List;
      log('Memories list found with ${memoryJsonList.length} items');

      for (var i = 0; i < memoryJsonList.length; i++) {
        try {
          final item = memoryJsonList[i] as Map<String, dynamic>;
          log('Parsing memory item $i: ${item['MemoryID']} - ${item['Caption']}');
          final memory = MemoryFrameModel.fromJson(item);
          memoryList.add(memory);
          log('Successfully parsed memory item $i');
        } catch (e) {
          log('Error parsing memory item $i: $e');
        }
      }
    } else {
      log('No Memories list in response or Memories is not a List. Memories value: ${dataJson['Memories']}');
    }


    final lastMemory = dataJson['LastMemory'] != null
        ? DateTime.tryParse(dataJson['LastMemory'] as String)
        : null;
    final lastReminder = dataJson['LastReminder'] != null
        ? DateTime.tryParse(dataJson['LastReminder'] as String)
        : null;
    final lastMedia = dataJson['LastMedia'] != null
        ? DateTime.tryParse(dataJson['LastMedia'] as String)
        : null;

    log('Parsed DataSyncResult:');
    log('  - Media count: ${mediaList.length}');
    log('  - Reminders count: ${reminderList.length}');
    log('  - Memories count: ${memoryList.length}');
    log('  - LastMemory: $lastMemory');
    log('  - LastReminder: $lastReminder');
    log('  - LastMedia: $lastMedia');

    return DataSyncResult(
      media: mediaList,
      memories: memoryList,
      reminders: reminderList,
      lastMemoryTimestamp: lastMemory,
      lastReminderTimestamp: lastReminder,
      lastMediaTimestamp: lastMedia,
    );
  }
}
