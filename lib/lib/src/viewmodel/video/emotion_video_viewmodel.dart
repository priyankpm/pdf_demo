import 'dart:async';
import 'dart:io';

import 'package:flick_video_player/flick_video_player.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:video_player/video_player.dart';
import 'package:whiskers_flutter_app/src/common_utility/common_utility.dart';
import 'package:whiskers_flutter_app/src/enum/emotion_type.dart';
import 'package:whiskers_flutter_app/src/viewmodel/base_viewmodel.dart';
import 'package:hive/hive.dart';

import '../../common_utility/background_remover.dart';
import '../../models/emotion_video_model.dart';
import '../../widgets/video_screen/animation_player/data_manager.dart';

class EmotionVideoViewmodel extends BaseViewModel<EmotionVideoModel> {
  EmotionVideoViewmodel(this.ref)
    : super(
        EmotionVideoModel(
          emotionType: EmotionType.none,
          introVideo: neutralToHappy,
          loopVideo: happyToHappy,
          outroVideo: neutralToNeutral,
          images: '',
        ),
      );

  final Ref ref;
  late Timer videoChangeTimer;
  int counter = 0;
  late FlickManager flickManager;
  late AnimationPlayerDataManager dataManager;
  late Box<String> processedBox;
  late final VideoPlayerController controller;

  EmotionType get currentEmotion => state.emotionType ?? EmotionType.none;

  Future<void> changeEmotion(EmotionVideoModel newEmotion) async {
    if (!mounted) {
      return;
    }
      // Outro
    if (state.outroVideo?.isNotEmpty ?? false) {
      final outroPath = await _getOrProcess(
        state.outroVideo ?? '',
        backgroundVideoImage,
      );
      await dataManager.playVideo(outroPath);
    }

    // Intro
    if (newEmotion.introVideo?.isNotEmpty ?? false) {
      final introPath = await _getOrProcess(
        newEmotion.introVideo ?? '',
        backgroundVideoImage,
      );
      await dataManager.playVideo(introPath);
    }

    // Loop
    if (newEmotion.loopVideo?.isNotEmpty ?? false) {
      final loopPath = await _getOrProcess(
        newEmotion.loopVideo ?? '',
        backgroundVideoImage,
      );
      dataManager.loopVideo(loopPath);
    }

    state = newEmotion;
  }

  Future<void> initModel({
    String docId = '',
    // required AnimationPlayerDataManager dataManager,
  }) async {
    // this.dataManager = dataManager;
    videoChangeTimer = Timer.periodic(Duration(seconds: 5), (_) {
      switch (counter % 3) {
        case 0:
          changeEmotion(
            getEmotionModel().copyWith(loopVideo: '', outroVideo: ''),
          );
          break;
        case 1:
          changeEmotion(
            getEmotionModel().copyWith(introVideo: '', outroVideo: ''),
          );
          break;
        case 2:
          counter = 0;
          changeEmotion(
            getEmotionModel().copyWith(introVideo: '', loopVideo: ''),
          );
          break;
      }
      counter++;
    });
  }

  EmotionVideoModel getEmotionModel() {
    return EmotionVideoModel(
      emotionType: EmotionType.none,
      introVideo: neutralToHappy,
      loopVideo: happyToHappy,
      outroVideo: neutralToNeutral,
      images: '',
    );
  }

  @override
  void notifyChanges(EmotionVideoModel model) {}

  @override
  Future<void> init({String docId = ''}) async {
    initHiveBox();
    controller = true
        ? docId.startsWith('/data/')
              ? VideoPlayerController.file(
                  File(docId),
                ) // ✅ Local file from FFmpeg
              : VideoPlayerController.asset(docId) // ✅ Asset
        : VideoPlayerController.networkUrl(Uri.parse(docId));
    flickManager = FlickManager(
      videoPlayerController: controller,
      // onVideoEnd: () =>
      //     dataManager.playNextVideo(useLocalPath, Duration(seconds: 5)),
    );

    dataManager = AnimationPlayerDataManager(flickManager, []);
  }

  Future<String> removeBackground(
    String inputAsset,
    String backgroundImage,
  ) async {
    final processed = await BackgroundRemover.replaceGreenScreen(
      inputAsset: inputAsset,
      backgroundAsset: backgroundImage,
    );

    return processed?.path ?? '';
  }

  Future<void> initHiveBox() async {
    processedBox = await Hive.openBox<String>('processedVideos');
  }

  Future<String?> _getProcessedPath(
    String inputVideo,
    String background,
  ) async {
    final key = "$inputVideo|$background";
    return processedBox.get(key);
  }

  Future<void> _saveProcessedPath(
    String inputVideo,
    String background,
    String outputPath,
  ) async {
    final key = "$inputVideo|$background";
    await processedBox.put(key, outputPath);
  }

  Future<String> _getOrProcess(String inputVideo, String background) async {
    // Check Hive first
    final cachedPath = await _getProcessedPath(inputVideo, background);
    if (cachedPath != null && File(cachedPath).existsSync()) {
      return cachedPath;
    }

    // Process with ffmpeg
    final processed = await removeBackground(inputVideo, background);
    if (processed.isNotEmpty) {
      await _saveProcessedPath(inputVideo, background, processed);
    }

    return processed;
  }

  int? targetWidth;
  int? targetHeight;

  void setTargetSize(int width, int height) {
    targetWidth = width;
    targetHeight = height;
  }
}
