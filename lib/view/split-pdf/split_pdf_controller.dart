import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

enum SplitMode { specific, everyN, individual }

class SplitPdfController extends GetxController {
  final Rx<File?> selectedFile = Rx<File?>(null);
  final RxList<File> splitFiles = <File>[].obs;
  final RxBool isProcessing = false.obs;
  final RxString processingStatus = ''.obs;
  final RxInt totalPages = 0.obs;
  final RxInt totalPagesSplit = 0.obs;
  final Rx<SplitMode> splitMode = SplitMode.specific.obs;

  final pageRangeController = TextEditingController(text: '1-3');
  final splitEveryController = TextEditingController(text: '1');

  Timer? _statusUpdateTimer;
  String _pendingStatus = '';
  String outputDirectory = '';

  String get fileName =>
      selectedFile.value?.path.split(Platform.pathSeparator).last ?? '';
  String get fileSize => _formatSize(selectedFile.value?.lengthSync() ?? 0);

  bool get hasSelectedFile => selectedFile.value != null;
  bool get hasSplitFiles => splitFiles.isNotEmpty;

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

          // Get total pages
          await _loadPdfInfo(file);

          // Reset split files when selecting new file
          _resetSplitFiles();
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

  void setSplitMode(SplitMode mode) {
    splitMode.value = mode;
    _resetSplitFiles();
  }

  void _updateStatus(String status) {
    _pendingStatus = status;

    if (_statusUpdateTimer?.isActive ?? false) return;

    _statusUpdateTimer = Timer(const Duration(milliseconds: 200), () {
      processingStatus.value = _pendingStatus;
    });
  }

  Future<void> splitPdf() async {
    if (selectedFile.value == null) {
      _showToast('No File', 'Please select a PDF file');
      return;
    }

    isProcessing.value = true;
    _resetSplitFiles();
    processingStatus.value = 'Initializing split...';

    try {
      final bytes = await selectedFile.value!.readAsBytes();
      final PdfDocument document = PdfDocument(inputBytes: bytes);

      switch (splitMode.value) {
        case SplitMode.specific:
          await _splitSpecificPages(document);
          break;
        case SplitMode.everyN:
          await _splitEveryN(document);
          break;
        case SplitMode.individual:
          await _splitIndividual(document);
          break;
      }

      document.dispose();

      _showToast('Success',
          'Successfully split PDF into ${splitFiles.length} files');
    } catch (e) {
      _showToast('Error splitting PDF', e);
    } finally {
      isProcessing.value = false;
      processingStatus.value = '';
      _statusUpdateTimer?.cancel();
    }
  }

  Future<void> _splitSpecificPages(PdfDocument document) async {
    final ranges = _parsePageRanges(pageRangeController.text);

    if (ranges.isEmpty) {
      throw Exception('Invalid page range format');
    }

    int fileCount = 0;
    int pagesExtracted = 0;

    for (var range in ranges) {
      fileCount++;
      _updateStatus('Creating file $fileCount of ${ranges.length}...');

      final newDocument = PdfDocument();

      for (int pageNum in range) {
        if (pageNum > 0 && pageNum <= document.pages.count) {
          pagesExtracted++;
          _updateStatus(
              'Extracting page $pageNum (File $fileCount/${ranges.length})...');

          final page = document.pages[pageNum - 1];
          newDocument.pages.add().graphics.drawPdfTemplate(
            page.createTemplate(),
            Offset.zero,
            Size(page.size.width, page.size.height),
          );

          await Future.delayed(const Duration(milliseconds: 20));
        }
      }

      // Generate page range string for filename
      String pageRangeStr = range.length == 1
          ? 'page_${range.first}'
          : 'page_${range.first}-${range.last}';

      final outputFile = await _saveSplitPdf(newDocument, pageRangeStr);
      splitFiles.add(outputFile);

      newDocument.dispose();
    }

    totalPagesSplit.value = pagesExtracted;
  }

  Future<void> _splitEveryN(PdfDocument document) async {
    final splitEvery = int.tryParse(splitEveryController.text) ?? 1;

    if (splitEvery < 1) {
      throw Exception('Split value must be at least 1');
    }

    int fileCount = 0;
    int pagesProcessed = 0;

    for (int i = 0; i < document.pages.count; i += splitEvery) {
      fileCount++;
      final end = (i + splitEvery).clamp(0, document.pages.count);
      final pageCount = end - i;

      _updateStatus(
          'Creating file $fileCount (Pages ${i + 1}-$end)...');

      final newDocument = PdfDocument();

      for (int j = i; j < end; j++) {
        pagesProcessed++;
        _updateStatus(
            'Processing page ${j + 1} of ${document.pages.count}...');

        final page = document.pages[j];
        newDocument.pages.add().graphics.drawPdfTemplate(
          page.createTemplate(),
          Offset.zero,
          Size(page.size.width, page.size.height),
        );

        await Future.delayed(const Duration(milliseconds: 20));
      }

      // Generate page range string for filename
      String pageRangeStr = pageCount == 1
          ? 'page_${i + 1}'
          : 'page_${i + 1}-$end';

      final outputFile = await _saveSplitPdf(newDocument, pageRangeStr);
      splitFiles.add(outputFile);

      newDocument.dispose();
    }

    totalPagesSplit.value = pagesProcessed;
  }

  Future<void> _splitIndividual(PdfDocument document) async {
    int pagesProcessed = 0;

    for (int i = 0; i < document.pages.count; i++) {
      pagesProcessed++;
      _updateStatus(
          'Creating file for page ${i + 1} of ${document.pages.count}...');

      final newDocument = PdfDocument();
      final page = document.pages[i];

      newDocument.pages.add().graphics.drawPdfTemplate(
        page.createTemplate(),
        Offset.zero,
        Size(page.size.width, page.size.height),
      );

      final outputFile = await _saveSplitPdf(newDocument, 'page_${i + 1}');
      splitFiles.add(outputFile);

      newDocument.dispose();

      await Future.delayed(const Duration(milliseconds: 20));
    }

    totalPagesSplit.value = pagesProcessed;
  }

  List<List<int>> _parsePageRanges(String input) {
    final List<List<int>> ranges = [];

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
              ranges.add(List.generate(end - start + 1, (i) => start + i));
            }
          }
        } else {
          final page = int.parse(part);
          if (page > 0) {
            ranges.add([page]);
          }
        }
      }
    } catch (e) {
      return [];
    }

    return ranges;
  }

  Future<File> _saveSplitPdf(PdfDocument document, String pageInfo) async {
    final output = await getTemporaryDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final baseName = fileName.replaceAll('.pdf', '');
    final outputPath =
        '${output.path}${Platform.pathSeparator}${baseName}_${pageInfo}_$timestamp.pdf';

    outputDirectory = output.path;

    final List<int> pdfBytes = await document.save();
    final outputFile = File(outputPath);
    await outputFile.writeAsBytes(pdfBytes);

    return outputFile;
  }

  void _resetSplitFiles() {
    splitFiles.clear();
    totalPagesSplit.value = 0;
    outputDirectory = '';
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
    pageRangeController.dispose();
    splitEveryController.dispose();
    super.onClose();
  }
}