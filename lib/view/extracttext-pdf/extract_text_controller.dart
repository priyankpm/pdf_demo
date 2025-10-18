import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:syncfusion_flutter_pdf/pdf.dart' as syncfusion;

class ExtractTextPdfController extends GetxController {
  final Rx<File?> selectedFile = Rx<File?>(null);
  final RxInt originalSize = 0.obs;
  final RxInt totalPages = 0.obs;
  final RxBool isProcessing = false.obs;
  final RxString processingStatus = ''.obs;
  final RxString extractedText = ''.obs;
  final RxBool isExtractionComplete = false.obs;

  Timer? _statusUpdateTimer;
  String _pendingStatus = '';

  String get formattedOriginalSize => _formatSize(originalSize.value);
  String get selectedFileName =>
      selectedFile.value?.path.split(Platform.pathSeparator).last ?? '';

  bool get hasSelectedFile => selectedFile.value != null;
  bool get hasExtractedText => extractedText.value.isNotEmpty;

  int get totalCharacters => extractedText.value.length;
  int get totalWords => extractedText.value.trim().isEmpty
      ? 0
      : extractedText.value.trim().split(RegExp(r'\s+')).length;

  Future<void> pickPdfFile() async {
    try {
      _resetAll();

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

  Future<void> extractText() async {
    if (selectedFile.value == null) {
      _showToast('No File Selected', 'Please select a PDF file first');
      return;
    }

    isProcessing.value = true;
    processingStatus.value = 'Loading PDF...';

    try {
      final pdfBytes = await selectedFile.value!.readAsBytes();

      _updateStatus('Extracting text from PDF...');

      // Load the PDF document using Syncfusion
      final syncfusion.PdfDocument document =
      syncfusion.PdfDocument(inputBytes: pdfBytes);

      totalPages.value = document.pages.count;

      final StringBuffer textBuffer = StringBuffer();

      for (int i = 0; i < document.pages.count; i++) {
        _updateStatus('Extracting text from page ${i + 1} of ${document.pages.count}...');

        final syncfusion.PdfPage page = document.pages[i];
        final String pageText =
        syncfusion.PdfTextExtractor(document).extractText(startPageIndex: i, endPageIndex: i);

        if (pageText.isNotEmpty) {
          textBuffer.writeln('--- Page ${i + 1} ---');
          textBuffer.writeln(pageText.trim());
          textBuffer.writeln();
        }

        await Future.delayed(const Duration(milliseconds: 10));
      }

      document.dispose();

      extractedText.value = textBuffer.toString();

      if (extractedText.value.trim().isEmpty) {
        _showToast(
          'No Text Found',
          'The PDF might be scanned or contain only images',
        );
      } else {
        isExtractionComplete.value = true;
        _showToast(
          'Success',
          'Text extracted successfully! ${totalWords} words found.',
        );
      }

      log('Extracted ${totalCharacters} characters from ${totalPages.value} pages');
    } catch (e) {
      log('Error extracting text: $e');
      _showToast('Error extracting text', e);
      extractedText.value = '';
    } finally {
      isProcessing.value = false;
      processingStatus.value = '';
      _statusUpdateTimer?.cancel();
    }
  }

  Future<void> copyToClipboard() async {
    if (extractedText.value.isEmpty) {
      _showToast('No Text', 'There is no text to copy');
      return;
    }

    try {
      await Clipboard.setData(ClipboardData(text: extractedText.value));
      _showToast('Copied', 'Text copied to clipboard successfully');
    } catch (e) {
      _showToast('Error', 'Failed to copy text to clipboard');
    }
  }

  Future<void> saveAsTextFile() async {
    if (extractedText.value.isEmpty) {
      _showToast('No Text', 'There is no text to save');
      return;
    }

    try {
      isProcessing.value = true;
      processingStatus.value = 'Saving text file...';

      final output = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = selectedFile.value!.path
          .split(Platform.pathSeparator)
          .last
          .replaceAll('.pdf', '');
      final outputPath =
          '${output.path}${Platform.pathSeparator}${fileName}_extracted_$timestamp.txt';

      final outputFile = File(outputPath);
      await outputFile.writeAsString(extractedText.value);

      _showToast(
        'Success',
        'Text saved to: $outputPath',
      );

      log('Text file saved to: $outputPath');
    } catch (e) {
      log('Error saving text file: $e');
      _showToast('Error', 'Failed to save text file');
    } finally {
      isProcessing.value = false;
      processingStatus.value = '';
    }
  }

  void _updateStatus(String status) {
    _pendingStatus = status;

    if (_statusUpdateTimer?.isActive ?? false) return;

    _statusUpdateTimer = Timer(const Duration(milliseconds: 200), () {
      processingStatus.value = _pendingStatus;
    });
  }

  void resetForNewFile() {
    _resetAll();
  }

  void _resetAll() {
    selectedFile.value = null;
    originalSize.value = 0;
    totalPages.value = 0;
    extractedText.value = '';
    isProcessing.value = false;
    processingStatus.value = '';
    isExtractionComplete.value = false;
  }

  void _showToast(String title, dynamic error) => Get.snackbar(
    title,
    error.toString(),
    colorText: Colors.white,
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: Colors.grey.shade700,
    duration: const Duration(seconds: 4),
    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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