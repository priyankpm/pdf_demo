import 'dart:developer';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:whiskers_flutter_app/src/models/media_state_model.dart';
import 'package:whiskers_flutter_app/src/viewmodel/data_sync/media_storage.dart';

class MediaViewModel extends StateNotifier<MediaViewState> {
  MediaViewModel(this.ref) : super(MediaViewState.initial());

  final Ref ref;

  Future<void> init() async {
    try {
      state = state.copyWith(isLoading: true);

      final mediaList = await MediaStorage.getAllMedia();
      final syncState = await MediaStorage.getSyncState();

      state = MediaViewState(
        mediaList: mediaList,
        syncState: syncState,
        isLoading: false,
        error: null,
      );

      log('Media view initialized: ${mediaList.length} items');
    } catch (e) {
      log('Error initializing media view: $e');
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> refresh() => init();
}

class MediaViewState {
  final List<MediaStateModel> mediaList;
  final SyncStateModel syncState;
  final bool isLoading;
  final String? error;

  const MediaViewState({
    required this.mediaList,
    required this.syncState,
    required this.isLoading,
    this.error,
  });

  factory MediaViewState.initial() {
    return MediaViewState(
      mediaList: const [],
      syncState: SyncStateModel.initial(),
      isLoading: false,
    );
  }

  MediaViewState copyWith({
    List<MediaStateModel>? mediaList,
    SyncStateModel? syncState,
    bool? isLoading,
    String? error,
  }) {
    return MediaViewState(
      mediaList: mediaList ?? this.mediaList,
      syncState: syncState ?? this.syncState,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}
