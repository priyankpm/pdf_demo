import 'dart:io';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:video_player/video_player.dart';

import 'data_manager.dart';
import 'landscape_controls.dart';
import 'portrait_video_controls.dart';

class FlickVideoPlayerScreen extends ConsumerStatefulWidget {
  const FlickVideoPlayerScreen({
    required this.dataManager,
    required this.flickManager,
    required this.pauseOnTap,
    this.customVideoPath,
    super.key,
  });

  final AnimationPlayerDataManager dataManager;
  final FlickManager flickManager;
  final bool pauseOnTap;
  final String? customVideoPath;

  @override
  ConsumerState<FlickVideoPlayerScreen> createState() =>
      _FlickVideoPlayerScreenState();
}

class _FlickVideoPlayerScreenState
    extends ConsumerState<FlickVideoPlayerScreen> {
  FlickManager? _activeFlickManager;
  double _aspectRatio = 16 / 9;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    try {
      if (widget.customVideoPath != null && widget.customVideoPath!.isNotEmpty) {
        VideoPlayerController controller;

        if (widget.customVideoPath!.startsWith("http")) {
          controller = VideoPlayerController.network(widget.customVideoPath!);
        } else {
          final file = File(widget.customVideoPath!);
          if (!file.existsSync()) {
            throw Exception("Local video file not found: ${widget.customVideoPath}");
          }
          controller = VideoPlayerController.file(file);
        }

        await controller.initialize(); // MUST initialize first

        _activeFlickManager = FlickManager(videoPlayerController: controller);
        _aspectRatio = controller.value.aspectRatio.isFinite
            ? controller.value.aspectRatio
            : 16 / 9;
      } else {
        _activeFlickManager = widget.flickManager;
      }

      setState(() {
        _isInitialized = true;
      });
    } catch (e) {
      debugPrint("Error initializing video: $e");
      _activeFlickManager = widget.flickManager;
      _aspectRatio = 16 / 9; // fallback
      setState(() {
        _isInitialized = true;
      });
    }
  }

  @override
  void dispose() {
    if (widget.customVideoPath != null && widget.customVideoPath!.isNotEmpty) {
      _activeFlickManager?.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const Center(child: CupertinoActivityIndicator());
    }

    return AspectRatio(
      aspectRatio: _aspectRatio.isFinite ? _aspectRatio : 16 / 9,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: FlickVideoPlayer(
          flickManager: _activeFlickManager!,
          flickVideoWithControls: AnimationPlayerPortraitVideoControls(
            dataManager: widget.dataManager,
            pauseOnTap: widget.pauseOnTap,
          ),
          flickVideoWithControlsFullscreen: FlickVideoWithControls(
            controls: AnimationPlayerLandscapeControls(
              animationPlayerDataManager: widget.dataManager,
            ),
          ),
        ),
      ),
    );
  }
}
