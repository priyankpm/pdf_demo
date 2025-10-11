import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

enum ScalingMode { fit, fill, center }

class PageSizeInfo {
  final String name;
  final double width;
  final double height;

  PageSizeInfo(this.name, this.width, this.height);
}

class ResizePdfController extends GetxController {
  final Rx<File?> selectedFile = Rx<File?>(null);
  final Rx<File?> resizedFile = Rx<File?>(null);
  final RxBool isProcessing = false.obs;
  final RxString processingStatus = ''.obs;
  final RxInt totalPages = 0.obs;
  final RxString targetPageSize = 'A4'.obs;
  final RxString currentPageSize = 'Unknown'.obs;
  final Rx<ScalingMode> scalingMode = ScalingMode.fit.obs;

  Timer? _statusUpdateTimer;
  String _pendingStatus = '';

  // Page sizes in points (1 inch = 72 points)
  static final Map<String, PageSizeInfo> pageSizes = {
    'A0': PageSizeInfo('A0', 2384, 3370),
    'A1': PageSizeInfo('A1', 1684, 2384),
    'A2': PageSizeInfo('A2', 1191, 1684),
    'A3': PageSizeInfo('A3', 842, 1191),
    'A4': PageSizeInfo('A4', 595, 842),
    'A5': PageSizeInfo('A5', 420, 595),
    'Legal': PageSizeInfo('Legal', 612, 1008), // 8.5 x 14 inches
    'Letter': PageSizeInfo('Letter', 612, 792), // 8.5 x 11 inches
  };

  String get fileName =>
      selectedFile.value?.path.split(Platform.pathSeparator).last ?? '';
  String get fileSize => _formatSize(selectedFile.value?.lengthSync() ?? 0);
  String get resizedFileName =>
      resizedFile.value?.path.split(Platform.pathSeparator).last ?? '';
  String get resizedFilePath => resizedFile.value?.path ?? '';
  String get resizedFileSize =>
      _formatSize(resizedFile.value?.lengthSync() ?? 0);

  bool get hasSelectedFile => selectedFile.value != null;
  bool get hasResizedFile => resizedFile.value != null;

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

          // Get PDF info
          await _loadPdfInfo(file);

          // Reset resized file when selecting new file
          _resetResizedFile();
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

      // Detect current page size
      if (document.pages.count > 0) {
        final firstPage = document.pages[0];
        currentPageSize.value = _detectPageSize(
          firstPage.size.width,
          firstPage.size.height,
        );
      }

      document.dispose();
    } catch (e) {
      _showToast('Error reading PDF', e);
      totalPages.value = 0;
      currentPageSize.value = 'Unknown';
    }
  }

  String _detectPageSize(double width, double height) {
    // Allow 5 points tolerance for size detection
    const tolerance = 5.0;

    for (var entry in pageSizes.entries) {
      final size = entry.value;
      // Check both portrait and landscape orientations
      if ((width - size.width).abs() < tolerance &&
          (height - size.height).abs() < tolerance ||
          (width - size.height).abs() < tolerance &&
              (height - size.width).abs() < tolerance) {
        return entry.key;
      }
    }

    return '${width.toStringAsFixed(0)} × ${height.toStringAsFixed(0)} pts';
  }

  void setTargetPageSize(String size) {
    targetPageSize.value = size;
    _resetResizedFile();
  }

  void setScalingMode(ScalingMode mode) {
    scalingMode.value = mode;
    _resetResizedFile();
  }

  void _updateStatus(String status) {
    _pendingStatus = status;

    if (_statusUpdateTimer?.isActive ?? false) return;

    _statusUpdateTimer = Timer(const Duration(milliseconds: 200), () {
      processingStatus.value = _pendingStatus;
    });
  }

  Future<void> resizePdf() async {
    if (selectedFile.value == null) {
      _showToast('No File', 'Please select a PDF file');
      return;
    }

    if (!pageSizes.containsKey(targetPageSize.value)) {
      _showToast('Invalid Size', 'Please select a valid page size');
      return;
    }

    isProcessing.value = true;
    _resetResizedFile();
    processingStatus.value = 'Initializing resize...';

    try {
      final bytes = await selectedFile.value!.readAsBytes();
      final PdfDocument sourceDocument = PdfDocument(inputBytes: bytes);

      final targetSize = pageSizes[targetPageSize.value]!;

      // Create target document
      final PdfDocument targetDocument = PdfDocument();

      for (int i = 0; i < sourceDocument.pages.count; i++) {
        _updateStatus(
            'Resizing page ${i + 1} of ${sourceDocument.pages.count}...');

        final sourcePage = sourceDocument.pages[i];

        // Create new page with target size
        final PdfSection section = targetDocument.sections!.add();
        section.pageSettings.size = Size(targetSize.width, targetSize.height);
        final PdfPage newPage = section.pages.add();

        // Get source page template
        final template = sourcePage.createTemplate();

        // Calculate scaling and positioning based on mode
        final sourceWidth = sourcePage.size.width;
        final sourceHeight = sourcePage.size.height;
        final targetWidth = targetSize.width;
        final targetHeight = targetSize.height;

        double drawWidth = sourceWidth;
        double drawHeight = sourceHeight;
        double offsetX = 0;
        double offsetY = 0;

        switch (scalingMode.value) {
          case ScalingMode.fit:
          // Scale to fit while maintaining aspect ratio
            final scaleXRatio = targetWidth / sourceWidth;
            final scaleYRatio = targetHeight / sourceHeight;
            final scale = scaleXRatio < scaleYRatio ? scaleXRatio : scaleYRatio;

            drawWidth = sourceWidth * scale;
            drawHeight = sourceHeight * scale;

            // Center the content
            offsetX = (targetWidth - drawWidth) / 2;
            offsetY = (targetHeight - drawHeight) / 2;
            break;

          case ScalingMode.fill:
          // Scale to fill entire page (may crop)
            final scaleXRatio = targetWidth / sourceWidth;
            final scaleYRatio = targetHeight / sourceHeight;
            final scale = scaleXRatio > scaleYRatio ? scaleXRatio : scaleYRatio;

            drawWidth = sourceWidth * scale;
            drawHeight = sourceHeight * scale;

            // Center the content
            offsetX = (targetWidth - drawWidth) / 2;
            offsetY = (targetHeight - drawHeight) / 2;
            break;

          case ScalingMode.center:
          // No scaling, just center
            drawWidth = sourceWidth;
            drawHeight = sourceHeight;
            offsetX = (targetWidth - sourceWidth) / 2;
            offsetY = (targetHeight - sourceHeight) / 2;
            break;
        }

        // Draw the template with calculated size and position
        newPage.graphics.drawPdfTemplate(
          template,
          Offset(offsetX, offsetY),
          Size(drawWidth, drawHeight),
        );

        await Future.delayed(const Duration(milliseconds: 20));
      }

      sourceDocument.dispose();

      _updateStatus('Saving resized PDF...');

      // Save the resized document
      final List<int> resizedBytes = await targetDocument.save();
      targetDocument.dispose();

      final outputFile = await _saveResizedPdf(resizedBytes);
      resizedFile.value = outputFile;

      _showToast('Success',
          'Successfully resized PDF to ${targetPageSize.value} (${totalPages.value} pages)');
    } catch (e) {
      _showToast('Error resizing PDF', e);
    } finally {
      isProcessing.value = false;
      processingStatus.value = '';
      _statusUpdateTimer?.cancel();
    }
  }

  Future<File> _saveResizedPdf(List<int> pdfBytes) async {
    final output = await getTemporaryDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final baseName = fileName.replaceAll('.pdf', '');
    final outputPath =
        '${output.path}${Platform.pathSeparator}${baseName}_resized_${targetPageSize.value}_$timestamp.pdf';

    final outputFile = File(outputPath);
    await outputFile.writeAsBytes(pdfBytes);

    return outputFile;
  }

  void _resetResizedFile() {
    resizedFile.value = null;
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