import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class ReorderPdfController extends GetxController {
  final Rx<File?> selectedFile = Rx<File?>(null);
  final Rx<File?> processedFile = Rx<File?>(null);
  final RxInt originalSize = 0.obs;
  final RxInt totalPages = 0.obs;
  final RxBool isLoadingPages = false.obs;
  final RxBool isProcessing = false.obs;
  final RxString processingStatus = ''.obs;
  final RxList<Uint8List?> pageImages = <Uint8List?>[].obs;
  final RxList<int> pageOrder = <int>[].obs; // Stores the order of pages
  final RxBool isReorderComplete = false.obs;
  final RxInt viewingPageIndex = (-1).obs;

  Timer? _statusUpdateTimer;
  String _pendingStatus = '';
  Uint8List? _originalPdfBytes;

  String get formattedOriginalSize => _formatSize(originalSize.value);
  String get selectedFileName =>
      selectedFile.value?.path.split(Platform.pathSeparator).last ?? '';
  String get processedFileName =>
      processedFile.value?.path.split(Platform.pathSeparator).last ?? '';
  String get processedFilePath => processedFile.value?.path ?? '';

  bool get hasSelectedFile => selectedFile.value != null;
  bool get hasProcessedFile => processedFile.value != null;
  bool get canReorderPages => !isReorderComplete.value;
  bool get hasReordered => !_isOriginalOrder();

  bool _isOriginalOrder() {
    if (pageOrder.isEmpty) return true;
    for (int i = 0; i < pageOrder.length; i++) {
      if (pageOrder[i] != i) return false;
    }
    return true;
  }

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

        await _loadPdfPages(file);
      }
    } catch (e) {
      _showToast('Error picking file', e);
    }
  }

  Future<void> _loadPdfPages(File file) async {
    try {
      isLoadingPages.value = true;
      processingStatus.value = 'Loading PDF pages...';

      _originalPdfBytes = await file.readAsBytes();

      int pageCount = 0;
      final pages = <Uint8List?>[];

      await for (final page in Printing.raster(_originalPdfBytes!, dpi: 72)) {
        pageCount++;
        _updateStatus('Loading page $pageCount...');

        final imageBytes = await page.toPng();
        pages.add(imageBytes);

        await Future.delayed(const Duration(milliseconds: 10));
      }

      totalPages.value = pageCount;
      pageImages.value = pages;

      // Initialize page order (0, 1, 2, 3, ...)
      pageOrder.value = List.generate(pageCount, (index) => index);

      log('Loaded $pageCount pages');
    } catch (e) {
      log('Error loading PDF pages: $e');
      _showToast('Error loading PDF', e);
      _resetAll();
    } finally {
      isLoadingPages.value = false;
      processingStatus.value = '';
      _statusUpdateTimer?.cancel();
    }
  }

  void viewSinglePage(int pageIndex) {
    viewingPageIndex.value = pageIndex;
  }

  void closeSinglePageView() {
    viewingPageIndex.value = -1;
  }

  void reorderPages(int oldIndex, int newIndex) {
    if (isReorderComplete.value) {
      _showToast(
        'Processing Complete',
        'Please press "Reset & Process Another PDF" to select a new file',
      );
      return;
    }

    if (oldIndex == newIndex) return;

    final item = pageOrder.removeAt(oldIndex);
    pageOrder.insert(newIndex, item);

    // Force update
    pageOrder.refresh();
  }

  void resetOrder() {
    if (isReorderComplete.value) {
      _showToast(
        'Processing Complete',
        'Please press "Reset & Process Another PDF" to select a new file',
      );
      return;
    }
    pageOrder.value = List.generate(totalPages.value, (index) => index);
  }

  void _updateStatus(String status) {
    _pendingStatus = status;

    if (_statusUpdateTimer?.isActive ?? false) return;

    _statusUpdateTimer = Timer(const Duration(milliseconds: 200), () {
      processingStatus.value = _pendingStatus;
    });
  }

  Future<void> savePdfWithNewOrder() async {
    if (selectedFile.value == null || _originalPdfBytes == null) {
      _showToast('No File Selected', 'Please select a PDF file first');
      return;
    }

    if (!hasReordered) {
      _showToast('No Changes Made', 'Please reorder pages before saving');
      return;
    }

    isProcessing.value = true;
    processingStatus.value = 'Preparing to reorder pages...';

    try {
      _updateStatus('Processing PDF pages...');

      final pageRasters = Printing.raster(_originalPdfBytes!, dpi: 150.0);
      final pdf = pw.Document(compress: true, version: PdfVersion.pdf_1_5);

      // Load all pages into memory first
      final allPages = <PdfRaster>[];
      await for (final page in pageRasters) {
        allPages.add(page);
      }

      // Add pages in the new order
      for (int i = 0; i < pageOrder.length; i++) {
        final originalPageIndex = pageOrder[i];
        _updateStatus('Adding page ${i + 1} of ${pageOrder.length}...');

        final page = allPages[originalPageIndex];
        final imageBytes = await page.toPng();

        pdf.addPage(
          pw.Page(
            pageFormat: PdfPageFormat(
              page.width.toDouble(),
              page.height.toDouble(),
              marginAll: 0,
            ),
            build: (context) {
              return pw.Image(
                pw.MemoryImage(imageBytes),
                fit: pw.BoxFit.fill,
              );
            },
          ),
        );

        await Future.delayed(const Duration(milliseconds: 50));
      }

      _updateStatus('Saving PDF...');

      final outputFile = await _saveProcessedPdf(pdf);

      processedFile.value = outputFile;
      isProcessing.value = false;
      isReorderComplete.value = true;

      _showToast(
        'Success',
        'PDF pages have been reordered successfully!',
      );
    } catch (e) {
      log('Error processing PDF: $e');
      _showToast('Error processing PDF', e);
      isProcessing.value = false;
      processedFile.value = null;
    } finally {
      processingStatus.value = '';
      _statusUpdateTimer?.cancel();
    }
  }

  Future<File> _saveProcessedPdf(pw.Document pdf) async {
    final output = await getTemporaryDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final fileName = selectedFile.value!.path
        .split(Platform.pathSeparator)
        .last
        .replaceAll('.pdf', '');
    final outputPath =
        '${output.path}${Platform.pathSeparator}${fileName}_reordered_$timestamp.pdf';

    final outputFile = File(outputPath);
    final pdfBytes = await pdf.save();
    await outputFile.writeAsBytes(pdfBytes);

    return outputFile;
  }

  void resetForNewFile() {
    _resetAll();
  }

  void _resetAll() {
    selectedFile.value = null;
    processedFile.value = null;
    originalSize.value = 0;
    totalPages.value = 0;
    pageImages.clear();
    pageOrder.clear();
    isLoadingPages.value = false;
    isProcessing.value = false;
    processingStatus.value = '';
    isReorderComplete.value = false;
    viewingPageIndex.value = -1;
    _originalPdfBytes = null;
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