import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

enum RotateMode { all, specific }

class RotatePdfController extends GetxController {
  final Rx<File?> selectedFile = Rx<File?>(null);
  final Rx<File?> rotatedFile = Rx<File?>(null);
  final RxBool isProcessing = false.obs;
  final RxString processingStatus = ''.obs;
  final RxInt totalPages = 0.obs;
  final RxInt rotationAngle = 90.obs;
  final Rx<RotateMode> rotateMode = RotateMode.all.obs;

  final pageRangeController = TextEditingController(text: '1-3');

  int pagesRotated = 0;

  String get fileName =>
      selectedFile.value?.path.split(Platform.pathSeparator).last ?? '';
  String get fileSize => _formatSize(selectedFile.value?.lengthSync() ?? 0);

  bool get hasSelectedFile => selectedFile.value != null;

  Future<void> pickPdfFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        final fileResult = result.files.first;
        if (fileResult.path != null) {
          final file = File(fileResult.path!);
          selectedFile.value = file;
          await _loadPdfInfo(file);
          rotatedFile.value = null;
        }
      }
    } catch (e) {
      _showToast('Error picking file', e);
    }
  }

  Future<void> _loadPdfInfo(File file) async {
    try {
      final bytes = await file.readAsBytes();
      final PdfDocument document = PdfDocument(inputBytes: bytes);
      totalPages.value = document.pages.count;
      document.dispose();
    } catch (e) {
      _showToast('Error reading PDF', e);
      totalPages.value = 0;
    }
  }

  void setRotationAngle(int angle) {
    rotationAngle.value = angle;
  }

  void setRotateMode(RotateMode mode) {
    rotateMode.value = mode;
    rotatedFile.value = null;
  }

  Future<void> rotatePdf() async {
    if (selectedFile.value == null) {
      _showToast('No File', 'Please select a PDF file');
      return;
    }

    isProcessing.value = true;
    rotatedFile.value = null;
    processingStatus.value = 'Loading PDF...';
    pagesRotated = 0;

    try {
      final bytes = await selectedFile.value!.readAsBytes();
      final PdfDocument document = PdfDocument(inputBytes: bytes);

      List<int> pagesToRotate = [];

      if (rotateMode.value == RotateMode.all) {
        pagesToRotate = List.generate(document.pages.count, (i) => i);
      } else {
        final ranges = _parsePageRanges(pageRangeController.text);
        if (ranges.isEmpty) {
          throw Exception('Invalid page range format');
        }
        for (var page in ranges) {
          if (page > 0 && page <= document.pages.count) {
            pagesToRotate.add(page - 1);
          }
        }
      }

      // Process all pages
      for (int i = 0; i < document.pages.count; i++) {
        processingStatus.value =
        'Processing page ${i + 1} of ${document.pages.count}...';

        final sourcePage = document.pages[i];

        // Check if this page should be rotated
        final shouldRotate = pagesToRotate.contains(i);

        if (shouldRotate) {
          pagesRotated++;

          // Get rotation angle
          final angle = rotationAngle.value;

          // Apply rotation directly to the page
          switch (angle) {
            case 90:
              sourcePage.rotation = PdfPageRotateAngle.rotateAngle90;
              break;
            case 180:
              sourcePage.rotation = PdfPageRotateAngle.rotateAngle180;
              break;
            case 270:
              sourcePage.rotation = PdfPageRotateAngle.rotateAngle270;
              break;
          }
        }

        await Future.delayed(const Duration(milliseconds: 20));
      }

      processingStatus.value = 'Saving rotated PDF...';
      final outputFile = await _savePdf(document);
      rotatedFile.value = outputFile;

      document.dispose();

      _showToast('Success',
          'Successfully rotated $pagesRotated page${pagesRotated > 1 ? 's' : ''}');
    } catch (e) {
      _showToast('Error rotating PDF', e);
    } finally {
      isProcessing.value = false;
      processingStatus.value = '';
    }
  }

  List<int> _parsePageRanges(String input) {
    final List<int> pages = [];

    try {
      final parts = input.split(',');

      for (var part in parts) {
        part = part.trim();

        if (part.contains('-')) {
          final range = part.split('-');
          if (range.length == 2) {
            final start = int.parse(range[0].trim());
            final end = int.parse(range[1].trim());

            if (start <= end && start > 0) {
              pages.addAll(List.generate(end - start + 1, (i) => start + i));
            }
          }
        } else {
          final page = int.parse(part);
          if (page > 0) {
            pages.add(page);
          }
        }
      }
    } catch (e) {
      return [];
    }

    return pages.toSet().toList()..sort();
  }

  Future<File> _savePdf(PdfDocument document) async {
    final output = await getTemporaryDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final baseName = fileName.replaceAll('.pdf', '');
    final outputPath =
        '${output.path}${Platform.pathSeparator}${baseName}_rotated_$timestamp.pdf';

    final List<int> pdfBytes = await document.save();
    final outputFile = File(outputPath);
    await outputFile.writeAsBytes(pdfBytes);

    return outputFile;
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
    pageRangeController.dispose();
    super.onClose();
  }
}