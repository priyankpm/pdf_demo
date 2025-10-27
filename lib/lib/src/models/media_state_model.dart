import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
part 'media_state_model.freezed.dart';

@freezed
abstract class MediaStateModel with _$MediaStateModel {
  const factory MediaStateModel({
    required String key,
    required String type,
    required String action,
    required String downloadedAssetPath,
    required DateTime downloadedAt,
    @Default(false) bool isDownloaded,
  }) = _MediaStateModel;

  const MediaStateModel._();

  factory MediaStateModel.fromJson(Map<String, dynamic> json) {
    return MediaStateModel(
      key: json['key'] as String,
      type: json['type'] as String,
      action: json['action'] as String,
      downloadedAssetPath: json['downloaded_asset'] as String? ?? '',
      downloadedAt: json['downloaded_at'] != null
          ? DateTime.parse(json['downloaded_at'] as String)
          : DateTime.now(),
      isDownloaded: json['is_downloaded'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'type': type,
      'action': action,
      'downloaded_asset': downloadedAssetPath,
      'downloaded_at': downloadedAt.toIso8601String(),
      'is_downloaded': isDownloaded,
    };
  }

  factory MediaStateModel.fromApiResponse(Map<String, dynamic> json) {
    return MediaStateModel(
      key: json['key'] as String,
      type: json['type'] as String,
      action: json['action'] as String,
      downloadedAssetPath: '',
      downloadedAt: DateTime.now(),
      isDownloaded: false,
    );
  }
}

@freezed
abstract class SyncStateModel with _$SyncStateModel {
  const factory SyncStateModel({
    required DateTime lastMemory,
    required DateTime lastReminder,
    required DateTime lastMedia,
    @Default([]) List<String> lastDownloaded,
  }) = _SyncStateModel;

  const SyncStateModel._();

  factory SyncStateModel.fromJson(Map<String, dynamic> json) {
    return SyncStateModel(
      lastMemory: DateTime.parse(json['LastMemory'] as String),
      lastReminder: DateTime.parse(json['LastReminder'] as String),
      lastMedia: DateTime.parse(json['LastMedia'] as String),
      lastDownloaded: (json['LastDownloaded'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'LastMemory': lastMemory.toIso8601String(),
      'LastReminder': lastReminder.toIso8601String(),
      'LastMedia': lastMedia.toIso8601String(),
      'LastDownloaded': lastDownloaded,
    };
  }

  factory SyncStateModel.initial() {
    final defaultDate = DateTime.parse('1970-01-01 00:00:00.000000+00:00');
    return SyncStateModel(
      lastMemory: defaultDate,
      lastReminder: defaultDate,
      lastMedia: defaultDate,
      lastDownloaded: [],
    );
  }
}