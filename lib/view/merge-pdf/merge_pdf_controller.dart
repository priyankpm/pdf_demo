import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class MergePdfController extends GetxController {
  final RxList<File> selectedFiles = <File>[].obs;
  final Rx<File?> mergedFile = Rx<File?>(null);
  final RxBool isProcessing = false.obs;
  final RxString processingStatus = ''.obs;
  final RxInt totalPagesMerged = 0.obs;

  Timer? _statusUpdateTimer;
  String _pendingStatus = '';

  String get mergedFileName =>
      mergedFile.value?.path.split(Platform.pathSeparator).last ?? '';
  String get mergedFilePath => mergedFile.value?.path ?? '';
  String get mergedFileSize =>
      _formatSize(mergedFile.value?.lengthSync() ?? 0);

  bool get hasSelectedFiles => selectedFiles.isNotEmpty;
  bool get hasMergedFile => mergedFile.value != null;

  String get totalSize {
    int total = 0;
    for (var file in selectedFiles) {
      total += file.lengthSync();
    }
    return _formatSize(total);
  }

// Updated Controller - pickPdfFiles method
  Future<void> pickPdfFiles() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        allowMultiple: true,
      );

      if (result != null && result.files.isNotEmpty) {
        for (var fileResult in result.files) {
          if (fileResult.path != null) {
            final file = File(fileResult.path!);
            // Avoid duplicates
            if (!selectedFiles.any((f) => f.path == file.path)) {
              selectedFiles.add(file);
            }
          }
        }

        // Reset merged file when adding new files (this hides the success card)
        if (selectedFiles.isNotEmpty) {
          _resetMergedFile();
        }
      }
    } catch (e) {
      _showToast('Error picking files', e);
    }
  }

  void removeFile(int index) {
    if (index >= 0 && index < selectedFiles.length) {
      selectedFiles.removeAt(index);
      _resetMergedFile();

      if (selectedFiles.isEmpty) {
        _showToast('Info', 'All files removed');
      }
    }
  }

  void reorderFiles(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final file = selectedFiles.removeAt(oldIndex);
    selectedFiles.insert(newIndex, file);
    _resetMergedFile();
  }

  String getFileName(File file) {
    return file.path.split(Platform.pathSeparator).last;
  }

  String getFileSize(File file) {
    return _formatSize(file.lengthSync());
  }

  void _updateStatus(String status) {
    _pendingStatus = status;

    if (_statusUpdateTimer?.isActive ?? false) return;

    _statusUpdateTimer = Timer(const Duration(milliseconds: 200), () {
      processingStatus.value = _pendingStatus;
    });
  }

  Future<void> mergePdfs() async {
    if (selectedFiles.length < 2) {
      _showToast('Insufficient Files', 'Please select at least 2 PDF files');
      return;
    }

    isProcessing.value = true;
    _resetMergedFile();
    totalPagesMerged.value = 0;
    processingStatus.value = 'Initializing merge...';

    try {
      // Create a new PDF document for merged output
      final PdfDocument mergedDocument = PdfDocument();

      int fileCount = 0;
      int totalPages = 0;

      for (var file in selectedFiles) {
        fileCount++;
        _updateStatus('Processing file $fileCount of ${selectedFiles.length}...');

        final bytes = await file.readAsBytes();

        // Load the PDF document
        final PdfDocument document = PdfDocument(inputBytes: bytes);

        // Import all pages from this document
        for (int i = 0; i < document.pages.count; i++) {
          totalPages++;
          _updateStatus(
              'Merging page $totalPages from file $fileCount/${selectedFiles.length}...');

          // Import the page
          mergedDocument.pages.add().graphics.drawPdfTemplate(
            document.pages[i].createTemplate(),
            Offset.zero,
            Size(
              document.pages[i].size.width,
              document.pages[i].size.height,
            ),
          );

          await Future.delayed(const Duration(milliseconds: 20));
        }

        document.dispose();
      }

      totalPagesMerged.value = totalPages;

      _updateStatus('Saving merged PDF...');

      // Save the merged document
      final List<int> mergedBytes = await mergedDocument.save();
      mergedDocument.dispose();

      final outputFile = await _saveMergedPdf(mergedBytes);

      mergedFile.value = outputFile;

      _showToast('Success',
          'Successfully merged ${selectedFiles.length} PDFs into one ($totalPages pages)');
    } catch (e) {
      _showToast('Error merging PDFs', e);
    } finally {
      isProcessing.value = false;
      processingStatus.value = '';
      _statusUpdateTimer?.cancel();
    }
  }

  Future<File> _saveMergedPdf(List<int> pdfBytes) async {
    final output = await getTemporaryDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final outputPath =
        '${output.path}${Platform.pathSeparator}merged_pdf_$timestamp.pdf';

    final outputFile = File(outputPath);
    await outputFile.writeAsBytes(pdfBytes);

    return outputFile;
  }

  void _resetMergedFile() {
    mergedFile.value = null;
    totalPagesMerged.value = 0;
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