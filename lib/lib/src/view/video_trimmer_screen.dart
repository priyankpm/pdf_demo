
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_trimmer/video_trimmer.dart';

class VideoTrimmerScreen extends StatefulWidget {
  final File file;
  const VideoTrimmerScreen({Key? key, required this.file}) : super(key: key);

  @override
  _VideoTrimmerScreenState createState() => _VideoTrimmerScreenState();
}

class _VideoTrimmerScreenState extends State<VideoTrimmerScreen> {
  final Trimmer _trimmer = Trimmer();

  double _startValue = 0.0;
  double _endValue = 0.0;

  bool _isPlaying = false;
  bool _progressVisibility = false;

  @override
  void initState() {
    super.initState();
    _trimmer.loadVideo(videoFile: widget.file);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: const Text("Video Trimmer"),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _progressVisibility
                ? null
                : () async {
                    await _trimmer.saveTrimmedVideo(
                      startValue: _startValue,
                      endValue: _endValue,
                      onSave: (outputPath) {
                        Navigator.of(context).pop(outputPath);
                      },
                    );
                  },
          )
        ],
      ),
      body: Builder(
        builder: (context) => Center(
          child: Container(
            padding: const EdgeInsets.only(bottom: 30.0),
            color: Colors.black,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Visibility(
                  visible: _progressVisibility,
                  child: const LinearProgressIndicator(
                    backgroundColor: Colors.red,
                  ),
                ),
                Expanded(
                  child: VideoViewer(trimmer: _trimmer),
                ),
                Center(
                  child: TrimViewer(
                    trimmer: _trimmer,
                    viewerHeight: 50.0,
                    viewerWidth: MediaQuery.of(context).size.width,
                    maxVideoLength: const Duration(minutes: 10),
                    onChangeStart: (value) {
                      _startValue = value;
                    },
                    onChangeEnd: (value) {
                      _endValue = value;
                    },
                    onChangePlaybackState: (value) {
                      setState(() {
                        _isPlaying = value;
                      });
                    },
                  ),
                ),
                TextButton(
                  child: _isPlaying
                      ? const Icon(
                          Icons.pause,
                          size: 80.0,
                          color: Colors.white,
                        )
                      : const Icon(
                          Icons.play_arrow,
                          size: 80.0,
                          color: Colors.white,
                        ),
                  onPressed: () async {
                    bool playbackState = await _trimmer.videoPlaybackControl(
                      startValue: _startValue,
                      endValue: _endValue,
                    );
                    setState(() {
                      _isPlaying = playbackState;
                    });
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
