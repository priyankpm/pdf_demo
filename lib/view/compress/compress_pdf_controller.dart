import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:image/image.dart' as img;

enum CompressionQuality { normal, medium, best }

class CompressPdfController extends GetxController {
  final Rx<File?> selectedFile = Rx<File?>(null);
  final Rx<File?> compressedFile = Rx<File?>(null);
  final RxInt originalSize = 0.obs;
  final RxInt compressedSize = 0.obs;
  final RxBool isProcessing = false.obs;
  final RxString processingStatus = ''.obs;
  final Rx<CompressionQuality> selectedQuality = CompressionQuality.medium.obs;

  Timer? _statusUpdateTimer;
  String _pendingStatus = '';

  String get formattedOriginalSize => _formatSize(originalSize.value);
  String get formattedCompressedSize => _formatSize(compressedSize.value);
  String get selectedFileName =>
      selectedFile.value?.path.split(Platform.pathSeparator).last ?? '';
  String get compressedFileName =>
      compressedFile.value?.path.split(Platform.pathSeparator).last ?? '';
  String get compressedFilePath => compressedFile.value?.path ?? '';

  double get savedPercentage {
    if (originalSize.value == 0 || compressedSize.value == 0) return 0;
    return (1 - (compressedSize.value / originalSize.value)) * 100;
  }

  bool get hasSelectedFile => selectedFile.value != null;
  bool get hasCompressedFile => compressedFile.value != null;

  int get imageQuality {
    switch (selectedQuality.value) {
      case CompressionQuality.normal:
        return 85;
      case CompressionQuality.best:
        return 50;
      case CompressionQuality.medium:
        return 70;
    }
  }

  double get dpi {
    switch (selectedQuality.value) {
      case CompressionQuality.normal:
        return 150.0;
      case CompressionQuality.best:
        return 100.0;
      case CompressionQuality.medium:
        return 120.0;
    }
  }

  Future<void> pickPdfFile() async {
    try {
      _resetCompressedFile();

      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        selectedFile.value = file;
        originalSize.value = file.lengthSync();
      }
    } catch (e) {
      _showToast('Error picking file', e);
    }
  }

  void _updateStatus(String status) {
    _pendingStatus = status;

    if (_statusUpdateTimer?.isActive ?? false) return;

    _statusUpdateTimer = Timer(const Duration(milliseconds: 200), () {
      processingStatus.value = _pendingStatus;
    });
  }

  Future<void> compressPdf() async {
    if (selectedFile.value == null) {
      _showToast('No File Selected', 'Please select a PDF file first');
      return;
    }

    isProcessing.value = true;
    _resetCompressedFile();
    processingStatus.value = 'Loading PDF...';

    try {
      final bytes = await selectedFile.value!.readAsBytes();
      final currentDpi = dpi;
      final quality = imageQuality;

      _updateStatus('Rendering pages at ${currentDpi.toInt()} DPI...');

      final pageImages = Printing.raster(bytes, dpi: currentDpi);
      final pdf = pw.Document(compress: true, version: PdfVersion.pdf_1_5);

      int pageCount = 0;

      await for (final page in pageImages) {
        pageCount++;
        _updateStatus('Compressing page $pageCount...');

        final imageBytes = await page.toPng();

        final compressedImageBytes = await compute(
          _compressImageInIsolate,
          _ImageCompressionParams(imageBytes, quality),
        );

        if (compressedImageBytes == null) {
          log('Failed to compress page $pageCount');
          continue;
        }

        pdf.addPage(
          pw.Page(
            pageFormat: PdfPageFormat(
              page.width.toDouble(),
              page.height.toDouble(),
              marginAll: 0,
            ),
            build: (context) {
              return pw.Image(
                pw.MemoryImage(compressedImageBytes),
                fit: pw.BoxFit.fill,
              );
            },
          ),
        );

        await Future.delayed(const Duration(milliseconds: 50));
      }

      _updateStatus('Saving compressed PDF...');

      final outputFile = await _saveCompressedPdf(pdf);
      final finalSize = outputFile.lengthSync();

      compressedFile.value = outputFile;
      compressedSize.value = finalSize;

      _showSuccessMessage(finalSize);
    } catch (e) {
      _showToast('Error compressing PDF', e);
    } finally {
      isProcessing.value = false;
      processingStatus.value = '';
      _statusUpdateTimer?.cancel();
    }
  }

  static Uint8List? _compressImageInIsolate(_ImageCompressionParams params) {
    try {
      final originalImage = img.decodeImage(params.imageBytes);
      if (originalImage == null) return null;

      return Uint8List.fromList(
        img.encodeJpg(originalImage, quality: params.quality),
      );
    } catch (e) {
      log('Error in isolate: $e');
      return null;
    }
  }

  Future<File> _saveCompressedPdf(pw.Document pdf) async {
    final output = await getTemporaryDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final fileName = selectedFile.value!.path
        .split(Platform.pathSeparator)
        .last
        .replaceAll('.pdf', '');
    final outputPath =
        '${output.path}${Platform.pathSeparator}${fileName}_compressed_$timestamp.pdf';

    final outputFile = File(outputPath);
    final pdfBytes = await pdf.save();
    await outputFile.writeAsBytes(pdfBytes);

    return outputFile;
  }

  void changeQuality(CompressionQuality quality) {
    if (!isProcessing.value) {
      selectedQuality.value = quality;
    }
  }

  void _resetCompressedFile() {
    compressedFile.value = null;
    compressedSize.value = 0;
  }

  void _showSuccessMessage(int finalSize) {
    if (finalSize < originalSize.value) {
      final saved = ((1 - (finalSize / originalSize.value)) * 100)
          .toStringAsFixed(1);
      _showToast('Success', 'PDF compressed successfully! Saved $saved%');
    } else {
      _showToast('Completed', 'PDF processed (file may already be optimized)');
    }
  }

  void _showToast(String title, dynamic error) => Get.snackbar(
    title,
    error.toString(),
    colorText: Colors.white,
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: Colors.grey.shade700,
    duration: const Duration(seconds: 4),
    margin: const EdgeInsets.symmetric(horizontal: 20),
  );

  String _formatSize(int bytes) {
    if (bytes == 0) return '0 KB';
    final kb = bytes / 1024;
    final mb = kb / 1024;
    if (mb >= 1) return "${mb.toStringAsFixed(2)} MB";
    return "${kb.toStringAsFixed(2)} KB";
  }

  @override
  void onClose() {
    _statusUpdateTimer?.cancel();
    super.onClose();
  }
}

class _ImageCompressionParams {
  final Uint8List imageBytes;
  final int quality;

  _ImageCompressionParams(this.imageBytes, this.quality);
}