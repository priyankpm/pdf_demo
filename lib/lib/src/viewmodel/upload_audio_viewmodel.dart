
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:whiskers_flutter_app/src/repository/hive_repository.dart';
import 'package:whiskers_flutter_app/src/services/file_picker_service.dart';
import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_new/return_code.dart';
import 'package:path_provider/path_provider.dart';
import 'package:whiskers_flutter_app/src/view/video_trimmer_screen.dart';

class UploadAudioViewModel with ChangeNotifier {
  final HiveRepository _hiveRepository = HiveRepository();
  final FilePickerService _filePickerService = FilePickerService();

  String? _audioPath;
  String? get audioPath => _audioPath;

  Future<void> pickFile(BuildContext context) async {
    final file = await _filePickerService.pickFile();
    if (file != null) {
      if (file.path.endsWith('.mp4') || file.path.endsWith('.mov')) {
        final result = await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => VideoTrimmerScreen(file: file),
          ),
        );
        if (result != null) {
          final outputPath = await _extractAudio(result);
          if (outputPath != null) {
            _audioPath = outputPath;
            await _hiveRepository.saveAudioPath(outputPath);
            notifyListeners();
          }
        }
      } else {
        _audioPath = file.path;
        await _hiveRepository.saveAudioPath(file.path);
        notifyListeners();
      }
    }
  }

  Future<String?> _extractAudio(String videoPath) async {
    final Directory appDocumentsDir = await getApplicationDocumentsDirectory();
    final String rawDocumentPath = appDocumentsDir.path;
    final String audioPath = '$rawDocumentPath/output.mp3';
    final String command = '-i $videoPath -q:a 0 -map a $audioPath';

    final session = await FFmpegKit.execute(command);
    final returnCode = await session.getReturnCode();

    if (ReturnCode.isSuccess(returnCode)) {
      return audioPath;
    } else {
      return null;
    }
  }
}
