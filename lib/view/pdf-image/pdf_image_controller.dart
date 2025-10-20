import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
import 'package:image/image.dart' as img;

enum ExportFormat { png, jpg }

class PdfToImageController extends GetxController {
  final Rx<File?> selectedFile = Rx<File?>(null);
  final RxBool isProcessing = false.obs;
  final RxBool isLoadingPages = false.obs;
  final RxString processingStatus = ''.obs;
  final RxInt totalPages = 0.obs;
  final RxList<Uint8List?> pageImages = <Uint8List?>[].obs;
  final RxSet<int> selectedPagesToExport = <int>{}.obs;
  final RxInt viewingPageIndex = (-1).obs;
  final Rx<ExportFormat> exportFormat = ExportFormat.png.obs;
  final RxInt imageQuality = 90.obs;
  final RxBool exportAllPages = true.obs;
  final RxList<File> exportedFiles = <File>[].obs;
  final RxBool isExportComplete = false.obs;

  String get fileName =>
      selectedFile.value?.path.split(Platform.pathSeparator).last ?? '';
  String get fileSize => _formatSize(selectedFile.value?.lengthSync() ?? 0);
  bool get hasSelectedFile => selectedFile.value != null;
  bool get canSelectPages => !isExportComplete.value;

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
          exportedFiles.clear();
          isExportComplete.value = false;
          selectedPagesToExport.clear();

          await _loadPdfPages(file);
        }
      }
    } catch (e) {
      _showToast('Error', 'Failed to pick file: $e');
    }
  }

  Future<void> _loadPdfPages(File file) async {
    try {
      isLoadingPages.value = true;
      processingStatus.value = 'Loading PDF pages...';
      pageImages.clear();
      totalPages.value = 0;

      final pdfBytes = await file.readAsBytes();

      int pageCount = 0;
      final pages = <Uint8List?>[];

      await for (final page in Printing.raster(pdfBytes, dpi: 72)) {
        pageCount++;
        processingStatus.value = 'Loading page $pageCount...';

        final imageBytes = await page.toPng();
        pages.add(imageBytes);

        await Future.delayed(const Duration(milliseconds: 10));
      }

      pageImages.value = pages;
      totalPages.value = pageCount;

      // Select all pages by default
      if (exportAllPages.value) {
        selectedPagesToExport.value = Set.from(
            List.generate(pageCount, (i) => i + 1)
        );
      }
    } catch (e) {
      _showToast('Error', 'Failed to load PDF: $e');
      pageImages.clear();
      totalPages.value = 0;
    } finally {
      isLoadingPages.value = false;
      processingStatus.value = '';
    }
  }

  void setExportFormat(ExportFormat format) {
    exportFormat.value = format;
  }

  void setImageQuality(int quality) {
    imageQuality.value = quality;
  }

  void setExportAllPages(bool value) {
    exportAllPages.value = value;

    if (value) {
      // Select all pages
      selectedPagesToExport.value = Set.from(
          List.generate(totalPages.value, (i) => i + 1)
      );
    } else {
      // Clear selection
      selectedPagesToExport.clear();
    }
  }

  void togglePageSelection(int pageNumber) {
    if (isExportComplete.value) {
      _showToast(
        'Export Complete',
        'Please press "Reset" to process another PDF',
      );
      return;
    }

    if (selectedPagesToExport.contains(pageNumber)) {
      selectedPagesToExport.remove(pageNumber);
    } else {
      selectedPagesToExport.add(pageNumber);
    }

    // Update exportAllPages flag
    exportAllPages.value =
        selectedPagesToExport.length == totalPages.value;
  }

  void clearSelection() {
    if (isExportComplete.value) {
      _showToast(
        'Export Complete',
        'Please press "Reset" to process another PDF',
      );
      return;
    }
    selectedPagesToExport.clear();
    exportAllPages.value = false;
  }

  void selectAllPages() {
    if (isExportComplete.value) {
      _showToast(
        'Export Complete',
        'Please press "Reset" to process another PDF',
      );
      return;
    }
    selectedPagesToExport.value = Set.from(
        List.generate(totalPages.value, (i) => i + 1)
    );
    exportAllPages.value = true;
  }

  void viewSinglePage(int pageIndex) {
    viewingPageIndex.value = pageIndex;
  }

  void closeSinglePageView() {
    viewingPageIndex.value = -1;
  }

  Future<void> exportToImages() async {
    if (selectedFile.value == null) {
      _showToast('No File', 'Please select a PDF file');
      return;
    }

    if (selectedPagesToExport.isEmpty) {
      _showToast('No Pages Selected', 'Please select pages to export');
      return;
    }

    isProcessing.value = true;
    exportedFiles.clear();
    processingStatus.value = 'Preparing to export...';

    try {
      final pdfBytes = await selectedFile.value!.readAsBytes();
      final output = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final baseName = fileName.replaceAll('.pdf', '');

      final sortedPages = selectedPagesToExport.toList()..sort();
      int exportCount = 0;

      for (final pageNum in sortedPages) {
        exportCount++;
        processingStatus.value =
        'Exporting page $exportCount of ${sortedPages.length}...';

        final pageIndex = pageNum - 1;
        if (pageIndex < 0 || pageIndex >= pageImages.length) continue;

        final imageBytes = pageImages[pageIndex];
        if (imageBytes == null) continue;

        // Decode and process image
        final decodedImage = img.decodeImage(imageBytes);
        if (decodedImage == null) continue;

        // Encode based on format
        List<int> finalBytes;
        String extension;

        if (exportFormat.value == ExportFormat.jpg) {
          finalBytes = img.encodeJpg(
            decodedImage,
            quality: imageQuality.value,
          );
          extension = 'jpg';
        } else {
          finalBytes = img.encodePng(decodedImage);
          extension = 'png';
        }

        // Save file
        final outputPath =
            '${output.path}${Platform.pathSeparator}${baseName}_page_${pageNum}_$timestamp.$extension';
        final outputFile = File(outputPath);
        await outputFile.writeAsBytes(finalBytes);
        exportedFiles.add(outputFile);

        await Future.delayed(const Duration(milliseconds: 50));
      }

      isExportComplete.value = true;
      processingStatus.value = '';

      _showToast(
        'Success',
        'Successfully exported ${exportedFiles.length} image${exportedFiles.length > 1 ? 's' : ''}',
      );
    } catch (e) {
      _showToast('Error', 'Failed to export images: $e');
    } finally {
      isProcessing.value = false;
      processingStatus.value = '';
    }
  }

  void resetForNewFile() {
    selectedFile.value = null;
    totalPages.value = 0;
    pageImages.clear();
    selectedPagesToExport.clear();
    exportedFiles.clear();
    isLoadingPages.value = false;
    isProcessing.value = false;
    processingStatus.value = '';
    isExportComplete.value = false;
    viewingPageIndex.value = -1;
    exportFormat.value = ExportFormat.png;
    imageQuality.value = 90;
    exportAllPages.value = true;
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
    duration: const Duration(seconds: 4),
    margin: const EdgeInsets.symmetric(horizontal: 20),
  );

  @override
  void onClose() {
    super.onClose();
  }
}