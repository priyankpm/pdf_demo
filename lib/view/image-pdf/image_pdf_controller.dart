import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:image/image.dart' as img;

class ImageToPdfController extends GetxController {
  final RxList<File> images = <File>[].obs;
  final RxBool isProcessing = false.obs;
  final RxString processingStatus = ''.obs;
  final Rx<File?> generatedPdfFile = Rx<File?>(null);
  final RxInt totalPagesConverted = 0.obs;

  int get imageCount => images.length;
  bool get hasImages => images.isNotEmpty;
  bool get hasGeneratedPdf => generatedPdfFile.value != null;

  String get pdfFileName =>
      generatedPdfFile.value?.path.split(Platform.pathSeparator).last ?? '';
  String get pdfFilePath => generatedPdfFile.value?.path ?? '';
  String get pdfFileSize =>
      _formatSize(generatedPdfFile.value?.lengthSync() ?? 0);

  Future<void> pickImages() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: true,
      );

      if (result != null && result.files.isNotEmpty) {
        final newImages = result.files
            .where((file) => file.path != null)
            .map((file) => File(file.path!))
            .toList();

        images.addAll(newImages);

        // Reset generated PDF when adding new images
        if (images.isNotEmpty) {
          _resetGeneratedPdf();
        }
      }
    } catch (e) {
      _showToast('Error', 'Failed to pick images: $e');
    }
  }

  void removeImage(int index) {
    if (index >= 0 && index < images.length) {
      images.removeAt(index);
      _resetGeneratedPdf();
    }
  }

  void clearAllImages() {
    Get.dialog(
      AlertDialog(
        title: const Text('Clear All Images'),
        content: const Text('Are you sure you want to remove all images?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              images.clear();
              _resetGeneratedPdf();
              Get.back();
              _showToast('Cleared', 'All images removed');
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }

  void reorderImages(int oldIndex, int newIndex) {
    final image = images.removeAt(oldIndex);
    images.insert(newIndex, image);
    _resetGeneratedPdf();
  }

  Future<void> convertToPdf() async {
    if (images.isEmpty) {
      _showToast('No Images', 'Please select images first');
      return;
    }

    isProcessing.value = true;
    processingStatus.value = 'Preparing...';
    _resetGeneratedPdf();

    try {
      final pdf = pw.Document(compress: true, version: PdfVersion.pdf_1_5);

      for (int i = 0; i < images.length; i++) {
        processingStatus.value =
        'Processing image ${i + 1} of ${images.length}...';

        final imageBytes = await images[i].readAsBytes();

        final processedImage = await compute(
          _processImageInIsolate,
          imageBytes,
        );

        final finalImageBytes = processedImage ?? imageBytes;

        final decodedImage = img.decodeImage(imageBytes);
        if (decodedImage == null) {
          _showToast(
              'Warning',
              "Image ${i + 1} couldn't be read properly. Please remove it and continue generating.",
          );
          isProcessing.value = false;
          processingStatus.value = '';
          return;
        }

        final pageFormat = PdfPageFormat(
          decodedImage.width.toDouble(),
          decodedImage.height.toDouble(),
          marginAll: 0,
        );

        pdf.addPage(
          pw.Page(
            pageFormat: pageFormat,
            build: (context) {
              return pw.Image(
                pw.MemoryImage(finalImageBytes),
                fit: pw.BoxFit.contain,
              );
            },
          ),
        );

        await Future.delayed(const Duration(milliseconds: 50));
      }

      processingStatus.value = 'Saving PDF...';

      final outputFile = await _savePdf(pdf);

      generatedPdfFile.value = outputFile;
      totalPagesConverted.value = images.length;

      isProcessing.value = false;
      processingStatus.value = '';

      _showToast('Success', 'PDF created successfully with ${images.length} pages');
    } catch (e) {
      _showToast('Error', 'Failed to convert images: $e');
      isProcessing.value = false;
      processingStatus.value = '';
    }
  }

  static Uint8List? _processImageInIsolate(Uint8List imageBytes) {
    try {
      final originalImage = img.decodeImage(imageBytes);
      if (originalImage == null) return null;

      img.Image processedImage = originalImage;

      if (originalImage.width > 2000 || originalImage.height > 2000) {
        final ratio = originalImage.width / originalImage.height;
        int newWidth, newHeight;

        if (ratio > 1) {
          newWidth = 2000;
          newHeight = (2000 / ratio).round();
        } else {
          newHeight = 2000;
          newWidth = (2000 * ratio).round();
        }

        processedImage = img.copyResize(
          originalImage,
          width: newWidth,
          height: newHeight,
          interpolation: img.Interpolation.linear,
        );
      }

      return Uint8List.fromList(img.encodeJpg(processedImage, quality: 90));
    } catch (e) {
      return null;
    }
  }

  Future<File> _savePdf(pw.Document pdf) async {
    final output = await getTemporaryDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final outputPath =
        '${output.path}${Platform.pathSeparator}images_to_pdf_$timestamp.pdf';

    final outputFile = File(outputPath);
    final pdfBytes = await pdf.save();
    await outputFile.writeAsBytes(pdfBytes);

    return outputFile;
  }

  void _resetGeneratedPdf() {
    generatedPdfFile.value = null;
    totalPagesConverted.value = 0;
  }

  String _formatSize(int bytes) {
    if (bytes == 0) return '0 KB';
    final kb = bytes / 1024;
    final mb = kb / 1024;
    if (mb >= 1) return "${mb.toStringAsFixed(2)} MB";
    return "${kb.toStringAsFixed(2)} KB";
  }

  void _showToast(String title, String message) => Get.snackbar(
    title,
    message,
    colorText: Colors.white,
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: Colors.grey.shade700,
    duration: const Duration(seconds: 3),
    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
  );
}