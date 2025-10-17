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

class DeletePdfController extends GetxController {
  final Rx<File?> selectedFile = Rx<File?>(null);
  final Rx<File?> processedFile = Rx<File?>(null);
  final RxInt originalSize = 0.obs;
  final RxInt totalPages = 0.obs;
  final RxBool isLoadingPages = false.obs;
  final RxBool isProcessing = false.obs;
  final RxString processingStatus = ''.obs;
  final RxList<Uint8List?> pageImages = <Uint8List?>[].obs;
  final RxSet<int> selectedPagesToDelete = <int>{}.obs;
  final RxBool isDeletionComplete = false.obs;
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

  int get remainingPages => totalPages.value - selectedPagesToDelete.length;
  int get deletedPagesCount => selectedPagesToDelete.length;

  bool get hasSelectedFile => selectedFile.value != null;
  bool get hasProcessedFile => processedFile.value != null;
  bool get canSelectPages => !isDeletionComplete.value;

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

  // View a single page
  void viewSinglePage(int pageIndex) {
    viewingPageIndex.value = pageIndex;
  }

  // Close single page view
  void closeSinglePageView() {
    viewingPageIndex.value = -1;
  }

  void togglePageSelection(int pageNumber) {
    if (isDeletionComplete.value) {
      _showToast(
        'Processing Complete',
        'Please press "Reset & Process Another PDF" to select a new file',
      );
      return;
    }

    if (selectedPagesToDelete.contains(pageNumber)) {
      selectedPagesToDelete.remove(pageNumber);
    } else {
      if (selectedPagesToDelete.length >= totalPages.value - 1) {
        _showToast(
          'Cannot Delete All Pages',
          'At least one page must remain in the PDF',
        );
        return;
      }
      selectedPagesToDelete.add(pageNumber);
    }
  }

  void clearSelection() {
    if (isDeletionComplete.value) {
      _showToast(
        'Processing Complete',
        'Please press "Reset & Process Another PDF" to select a new file',
      );
      return;
    }
    selectedPagesToDelete.clear();
  }

  void _updateStatus(String status) {
    _pendingStatus = status;

    if (_statusUpdateTimer?.isActive ?? false) return;

    _statusUpdateTimer = Timer(const Duration(milliseconds: 200), () {
      processingStatus.value = _pendingStatus;
    });
  }

  Future<void> deletePdfPages() async {
    if (selectedFile.value == null || _originalPdfBytes == null) {
      _showToast('No File Selected', 'Please select a PDF file first');
      return;
    }

    if (selectedPagesToDelete.isEmpty) {
      _showToast('No Pages Selected', 'Please select pages to delete');
      return;
    }

    isProcessing.value = true;
    processingStatus.value = 'Preparing to delete pages...';

    try {
      _updateStatus('Processing PDF pages...');

      final pageRasters = Printing.raster(_originalPdfBytes!, dpi: 150.0);
      final pdf = pw.Document(compress: true, version: PdfVersion.pdf_1_5);

      int currentPage = 0;
      final pagesToDeleteSet = selectedPagesToDelete.toSet();
      int processedPages = 0;

      await for (final page in pageRasters) {
        currentPage++;

        if (pagesToDeleteSet.contains(currentPage)) {
          _updateStatus('Skipping page $currentPage of ${totalPages.value}...');
          await Future.delayed(const Duration(milliseconds: 10));
          continue;
        }

        processedPages++;
        _updateStatus('Adding page $currentPage of ${totalPages.value}...');

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

      if (processedPages == 0) {
        throw Exception('No pages remaining after deletion');
      }

      _updateStatus('Saving PDF...');

      final outputFile = await _saveProcessedPdf(pdf);

      processedFile.value = outputFile;
      isProcessing.value = false;
      isDeletionComplete.value = true;

      _showToast(
        'Success',
        'Deleted ${selectedPagesToDelete.length} page(s). ${remainingPages} page(s) remaining.',
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
        '${output.path}${Platform.pathSeparator}${fileName}_deleted_pages_$timestamp.pdf';

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
    selectedPagesToDelete.clear();
    isLoadingPages.value = false;
    isProcessing.value = false;
    processingStatus.value = '';
    isDeletionComplete.value = false;
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