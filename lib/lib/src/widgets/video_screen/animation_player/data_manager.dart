import 'dart:async';
import 'dart:io';

import 'package:flick_video_player/flick_video_player.dart';
import 'package:video_player/video_player.dart';

import '../../../common_utility/common_utility.dart';

class AnimationPlayerDataManager {
  bool inAnimation = false;
  final FlickManager flickManager;
  final List items;
  int currentIndex = 0;
  late Timer videoChangeTimer;
  String currentEmotion = 'neutral'; // Track current emotion state

  // Emotion video mappings - update these paths with your actual video assets
  final Map<String, String> emotionVideos = {
    'neutral': neutralToHappy, // Default neutral/happy state
    'happy': neutralToHappy, // Happy emotion
    'sleepy': 'assets/videos/sleepy.mp4', // Sleepy state
    'eating': 'assets/videos/eating.mp4', // Eating animation
    'playing': 'assets/videos/playing.mp4', // Playing state
    'curious': 'assets/videos/curious.mp4', // Curious/interactive
    'affectionate': 'assets/videos/affectionate.mp4', // When being petted
  };

  AnimationPlayerDataManager(this.flickManager, this.items);

  void playEmotionVideo(String emotion) {
    if (emotionVideos.containsKey(emotion)) {
      currentEmotion = emotion;
      final videoPath = emotionVideos[emotion]!;

      _playVideoWithEmotion(videoPath, emotion);
    } else {
      print('Unknown emotion: $emotion, falling back to neutral');
      playEmotionVideo('neutral');
    }
  }

  Future<void> _playVideoWithEmotion(String videoPath, String emotion) async {
    try {
      // Stop any current video playback
      flickManager.flickControlManager?.pause();

      // Determine if it's a local file or asset
      final bool isLocalFile = videoPath.startsWith('/data/');
      final bool isAsset = videoPath.contains('assets/');

      VideoPlayerController controller;

      if (isLocalFile) {
        controller = VideoPlayerController.file(File(videoPath));
      } else if (isAsset) {
        controller = VideoPlayerController.asset(videoPath);
      } else {
        controller = VideoPlayerController.networkUrl(Uri.parse(videoPath));
      }

      // Initialize the controller
      await controller.initialize();

      // Set looping based on emotion (some emotions should loop, others not)
      controller.setLooping(_shouldLoopEmotion(emotion));

      // Handle the video change with proper error handling
      await flickManager.handleChangeVideo(controller);

      // Set up completion handler for non-looping emotions
      if (!_shouldLoopEmotion(emotion)) {
        controller.addListener(() {
          if (controller.value.position >= controller.value.duration &&
              !controller.value.isLooping) {
            // Return to neutral after emotion video completes
            _returnToNeutralAfterEmotion();
          }
        });
      }

      print('Playing emotion video: $emotion from path: $videoPath');

    } catch (e) {
      print('Error playing emotion video $emotion: $e');
      // Fallback to neutral emotion on error
      _playFallbackVideo();
    }
  }

  bool _shouldLoopEmotion(String emotion) {
    // Emotions that should loop continuously
    final loopingEmotions = {'neutral', 'sleepy', 'eating', 'curious'};
    return loopingEmotions.contains(emotion);
  }

  void _returnToNeutralAfterEmotion() {
    // Short delay before returning to neutral
    Timer(Duration(seconds: 2), () {
      if (currentEmotion != 'neutral') {
        playEmotionVideo('neutral');
      }
    });
  }

  Future<void> _playFallbackVideo() async {
    try {
      final fallbackController = VideoPlayerController.asset(neutralToHappy);
      await fallbackController.initialize();
      await flickManager.handleChangeVideo(fallbackController);
      currentEmotion = 'neutral';
    } catch (e) {
      print('Error playing fallback video: $e');
    }
  }

  // Enhanced method to play emotion with duration (for temporary emotions like happy when petted)
  void playTemporaryEmotion(String emotion, {Duration duration = const Duration(seconds: 5)}) {
    if (currentEmotion == emotion) return; // Already in this emotion

    final previousEmotion = currentEmotion;
    playEmotionVideo(emotion);

    // Schedule return to previous emotion after duration
    if (!_shouldLoopEmotion(emotion)) {
      Timer(duration, () {
        if (currentEmotion == emotion) {
          playEmotionVideo(previousEmotion);
        }
      });
    }
  }

  // Method to change background (integrate with your background system)
  void changeBackground(String backgroundId) {
    // This would integrate with your background removal/overlay system
    print('Changing background to: $backgroundId');

    // You might want to trigger different pet reactions based on background
    switch (backgroundId) {
      case 'beach':
        playTemporaryEmotion('curious', duration: Duration(seconds: 3));
        break;
      case 'forest':
        playTemporaryEmotion('curious', duration: Duration(seconds: 3));
        break;
      case 'space':
        playTemporaryEmotion('curious', duration: Duration(seconds: 4));
        break;
      default:
      // No special reaction for default backgrounds
        break;
    }
  }

  // Get current emotion state
  String getCurrentEmotion() {
    return currentEmotion;
  }

  // Check if pet is in a specific emotional state
  bool isInEmotion(String emotion) {
    return currentEmotion == emotion;
  }

  // Original methods with minor improvements
  void playNextVideo(bool useLocalPath, [Duration? duration]) {
    if (currentIndex >= items.length - 1) {
      currentIndex = -1;
    }

    String nextVideoUrl = items[currentIndex + 1]['trailer_url'];

    if (currentIndex != items.length - 1) {
      if (duration != null) {
        videoChangeTimer = Timer(duration, () {
          currentIndex++;
        });
      } else {
        currentIndex++;
      }

      flickManager.handleChangeVideo(
        useLocalPath
            ? VideoPlayerController.asset(nextVideoUrl)
            : VideoPlayerController.networkUrl(Uri.parse(nextVideoUrl)),
        videoChangeDuration: duration,
        timerCancelCallback: (bool playNext) {
          videoChangeTimer.cancel();
          if (playNext) {
            currentIndex++;
          }
        },
      );
    }
  }

  String getCurrentVideoTitle() {
    return 'Emotion: ${currentEmotion.capitalize()}';
  }

  String getNextVideoTitle() {
    return 'Next Emotion';
  }

  String getCurrentPoster() {
    return backgroundVideoImage;
  }

  Future<void> playVideo(String url, {bool useLocalPath = true}) async {
    await flickManager.handleChangeVideo(
      url.startsWith('/data/')
          ? url.contains('assets/')
          ? VideoPlayerController.asset(url)
          : VideoPlayerController.file(File(url))
          : url.contains('assets/')
          ? VideoPlayerController.asset(url)
          : VideoPlayerController.networkUrl(Uri.parse(url)),
    );
    // Update emotion based on the video being played
    _updateEmotionFromVideoUrl(url);
  }

  Future<void> loopVideo(String url, {bool useLocalPath = true}) async {
    final controller = url.startsWith('/data/')
        ? url.contains('assets/')
        ? VideoPlayerController.asset(url)
        : VideoPlayerController.file(File(url))
        : url.contains('assets/')
        ? VideoPlayerController.asset(url)
        : VideoPlayerController.networkUrl(Uri.parse(url));
    await controller.initialize();
    controller.setLooping(true);
    await flickManager.handleChangeVideo(controller);
    _updateEmotionFromVideoUrl(url);
  }

  void _updateEmotionFromVideoUrl(String url) {
    // Extract emotion from URL or filename if possible
    if (url.contains('happy') || url.contains('play')) {
      currentEmotion = 'happy';
    } else if (url.contains('sleep')) {
      currentEmotion = 'sleepy';
    } else if (url.contains('eat')) {
      currentEmotion = 'eating';
    } else {
      currentEmotion = 'neutral';
    }
  }

  // Dispose method to clean up resources
  void dispose() {
    videoChangeTimer.cancel();
  }
}

// Extension for string capitalization
extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}