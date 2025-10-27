import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_new/return_code.dart';
import 'package:path_provider/path_provider.dart';

class BackgroundRemover {
  /// Copies asset to temp folder and returns file path
  static Future<String> _copyAssetToFile(String assetPath, String fileName) async {
    final byteData = await rootBundle.load(assetPath);
    final file = File("${(await getTemporaryDirectory()).path}/$fileName");
    await file.writeAsBytes(byteData.buffer.asUint8List());
    return file.path;
  }

  /// Replaces green background with a given background image or video.
  static Future<File?> replaceGreenScreen({
    required String inputAsset,       // input is asset (mp4 in assets/)
    required String backgroundAsset,  // background can also be asset
    int? width,
    int? height,
  }) async {
    final dir = await getTemporaryDirectory();
    final outputPath =
        "${dir.path}/output_${DateTime.now().millisecondsSinceEpoch}.mp4";

    // Copy assets into usable temp files
    final inputVideo = await _copyAssetToFile(inputAsset, "input.mp4");
    final backgroundMedia =
    await _copyAssetToFile(backgroundAsset, "schedule_screen_bg.png"); // jpg/mp4 also fine

    // Defaults
    final w = width ?? 1280;
    final h = height ?? 720;

    final command =
        '-i "$backgroundMedia" -i "$inputVideo" -filter_complex "[0:v]scale=${w}:${h}[bg];[1:v]colorkey=0x00FF00:0.3:0.1[fg];[bg][fg]overlay[out]" -map "[out]" -c:v libx264 -crf 18 -preset ultrafast -shortest "$outputPath"';

    print("▶️ Running FFmpeg:\n$command");

    final session = await FFmpegKit.execute(command);
    final returnCode = await session.getReturnCode();

    if (ReturnCode.isSuccess(returnCode)) {
      print("✅ FFmpeg Success. Output: $outputPath");
      return File(outputPath);
    } else {
      final logs = await session.getAllLogsAsString();
      print("❌ FFmpeg failed. Logs:\n$logs");
      return null;
    }
  }
}
