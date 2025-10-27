import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

class MediaDownloadService {
  final Dio _dio = Dio();

  Future<String?> downloadMedia({
    required String url,
    required String key,
    required String type,
    Function(int, int)? onProgress,
  }) async {
    try {
      log('Starting download for: $url');
      final appDir = await getApplicationDocumentsDirectory();
      final mediaDir = Directory('${appDir.path}/media');

      if (!await mediaDir.exists()) {
        await mediaDir.create(recursive: true);
      }

      final fileName = _sanitizeFileName(key);
      final filePath = '${mediaDir.path}/$fileName';

      await _dio.download(
        url,
        filePath,
        onReceiveProgress: (received, total) {
          if (total != -1 && onProgress != null) {
            onProgress(received, total);
            log(
              'Download progress: ${(received / total * 100).toStringAsFixed(0)}%',
            );
          }
        },
      );

      log('Download completed: $filePath');
      return filePath;
    } catch (e) {
      log('Error downloading media: $e');
      return null;
    }
  }

  String _sanitizeFileName(String fileName) {
    return fileName.replaceAll(RegExp(r'[<>:"/\\|?*]'), '_');
  }
}
