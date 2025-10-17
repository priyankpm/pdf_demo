import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:printing/printing.dart';

enum RotateMode { all, specific }

class RotatePdfController extends GetxController {
  final Rx<File?> selectedFile = Rx<File?>(null);
  final Rx<File?> rotatedFile = Rx<File?>(null);
  final RxBool isProcessing = false.obs;
  final RxBool isLoadingPages = false.obs;
  final RxString processingStatus = ''.obs;
  final RxInt totalPages = 0.obs;
  final RxInt rotationAngle = 90.obs;
  final Rx<RotateMode> rotateMode = RotateMode.all.obs;
  final RxList<Uint8List?> pageImages = <Uint8List?>[].obs;
  final RxSet<int> selectedPagesToRotate = <int>{}.obs;
  final RxInt viewingPageIndex = (-1).obs;
  final RxBool isRotationComplete = false.obs;

  final pageRangeController = TextEditingController(text: '1-3');

  Timer? _statusUpdateTimer;
  String _pendingStatus = '';
  Uint8List? _originalPdfBytes;
  int pagesRotated = 0;

  String get fileName =>
      selectedFile.value?.path.split(Platform.pathSeparator).last ?? '';
  String get fileSize => _formatSize(selectedFile.value?.lengthSync() ?? 0);

  bool get hasSelectedFile => selectedFile.value != null;
  bool get canSelectPages => !isRotationComplete.value;

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

          // Load page previews if in specific mode
          if (rotateMode.value == RotateMode.specific) {
            await _loadPdfPages(file);
          }
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

  Future<void> _loadPdfPages(File file) async {
    try {
      isLoadingPages.value = true;
      processingStatus.value = 'Loading PDF pages...';
      pageImages.clear();

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

      pageImages.value = pages;
    } catch (e) {
      _showToast('Error loading PDF', e);
      pageImages.clear();
    } finally {
      isLoadingPages.value = false;
      processingStatus.value = '';
      _statusUpdateTimer?.cancel();
    }
  }

  void _updateStatus(String status) {
    _pendingStatus = status;

    if (_statusUpdateTimer?.isActive ?? false) return;

    _statusUpdateTimer = Timer(const Duration(milliseconds: 200), () {
      processingStatus.value = _pendingStatus;
    });
  }

  void setRotationAngle(int angle) {
    rotationAngle.value = angle;
  }

  Future<void> setRotateMode(RotateMode mode) async {
    rotateMode.value = mode;
    rotatedFile.value = null;
    selectedPagesToRotate.clear();
    isRotationComplete.value = false;

    // Load page previews when switching to specific mode
    if (mode == RotateMode.specific && selectedFile.value != null && pageImages.isEmpty) {
      await _loadPdfPages(selectedFile.value!);
    }
  }

  void togglePageSelection(int pageNumber) {
    if (isRotationComplete.value) {
      _showToast(
        'Processing Complete',
        'Please press "Reset" to process another PDF',
      );
      return;
    }

    if (selectedPagesToRotate.contains(pageNumber)) {
      selectedPagesToRotate.remove(pageNumber);
    } else {
      selectedPagesToRotate.add(pageNumber);
    }
  }

  void clearSelection() {
    if (isRotationComplete.value) {
      _showToast(
        'Processing Complete',
        'Please press "Reset" to process another PDF',
      );
      return;
    }
    selectedPagesToRotate.clear();
  }

  // View a single page
  void viewSinglePage(int pageIndex) {
    viewingPageIndex.value = pageIndex;
  }

  // Close single page view
  void closeSinglePageView() {
    viewingPageIndex.value = -1;
  }

  Future<void> rotatePdf() async {
    if (selectedFile.value == null) {
      _showToast('No File', 'Please select a PDF file');
      return;
    }

    if (rotateMode.value == RotateMode.specific && selectedPagesToRotate.isEmpty) {
      _showToast('No Pages Selected', 'Please select pages to rotate');
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
        // Use selected pages from visual selection
        for (var page in selectedPagesToRotate) {
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

      isRotationComplete.value = true;

      _showToast('Success',
          'Successfully rotated $pagesRotated page${pagesRotated > 1 ? 's' : ''}');
    } catch (e) {
      _showToast('Error rotating PDF', e);
    } finally {
      isProcessing.value = false;
      processingStatus.value = '';
    }
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

  void resetForNewFile() {
    _resetAll();
  }

  void _resetAll() {
    selectedFile.value = null;
    rotatedFile.value = null;
    totalPages.value = 0;
    pageImages.clear();
    selectedPagesToRotate.clear();
    isLoadingPages.value = false;
    isProcessing.value = false;
    processingStatus.value = '';
    isRotationComplete.value = false;
    viewingPageIndex.value = -1;
    rotationAngle.value = 90;
    rotateMode.value = RotateMode.all;
    pagesRotated = 0;
    _originalPdfBytes = null;
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
    _statusUpdateTimer?.cancel();
    super.onClose();
  }
}