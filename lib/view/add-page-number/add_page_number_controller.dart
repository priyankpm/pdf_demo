import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf_demo/view/view-pdf/view_pdf.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class AddPageNumberController extends GetxController {
  final Rx<File?> selectedFile = Rx<File?>(null);
  final Rx<File?> outputFile = Rx<File?>(null);
  final Rx<File?> previewFile = Rx<File?>(null);
  final RxInt fileSize = 0.obs;
  final RxBool isProcessing = false.obs;
  final RxBool isGeneratingPreview = false.obs;
  final RxString processingStatus = ''.obs;
  final RxString selectedPosition = 'Bottom Center'.obs;
  final RxString selectedStyle = 'Page X of Y'.obs;
  final RxInt fontSize = 12.obs;
  final Rx<Color> textColor = Colors.black.obs;
  final Rx<Color> backgroundColor = Colors.transparent.obs;
  final RxBool showBackground = false.obs;

  final List<String> positions = [
    'Top Left',
    'Top Center',
    'Top Right',
    'Bottom Left',
    'Bottom Center',
    'Bottom Right',
  ];

  final List<String> numberStyles = [
    'Page X of Y',
    'X / Y',
    'X',
    '- X -',
    '[X]',
  ];

  final List<Color> availableTextColors = [
    Colors.black,
    Colors.white,
    Colors.blue.shade700,
    Colors.red.shade700,
    Colors.green.shade700,
    Colors.orange.shade700,
    Colors.purple.shade700,
    Colors.grey.shade700,
  ];

  final List<Color> availableBackgroundColors = [
    Colors.blue.shade100,
    Colors.red.shade100,
    Colors.green.shade100,
    Colors.orange.shade100,
    Colors.purple.shade100,
    Colors.yellow.shade100,
    Colors.pink.shade100,
    Colors.grey.shade200,
  ];

  Timer? _statusUpdateTimer;
  String _pendingStatus = '';

  String get formattedFileSize => _formatSize(fileSize.value);
  String get selectedFileName =>
      selectedFile.value?.path.split(Platform.pathSeparator).last ?? '';
  String get outputFileName =>
      outputFile.value?.path.split(Platform.pathSeparator).last ?? '';
  String get outputFilePath => outputFile.value?.path ?? '';
  String get previewFilePath => previewFile.value?.path ?? '';

  bool get hasSelectedFile => selectedFile.value != null;
  bool get hasOutputFile => outputFile.value != null;
  bool get hasPreviewFile => previewFile.value != null;

  Future<void> pickPdfFile() async {
    try {
      _resetOutputFile();
      _resetPreviewFile();

      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        selectedFile.value = file;
        fileSize.value = file.lengthSync();
      }
    } catch (e) {
      _showToast('Error picking file', e);
    }
  }

  void updatePosition(String position) {
    selectedPosition.value = position;
    _resetPreviewFile();
  }

  void updateStyle(String style) {
    selectedStyle.value = style;
    _resetPreviewFile();
  }

  void updateFontSize(double size) {
    fontSize.value = size.toInt();
    _resetPreviewFile();
  }

  void updateTextColor(Color color) {
    textColor.value = color;
    _resetPreviewFile();
  }

  void updateBackgroundColor(Color color) {
    backgroundColor.value = color;
    _resetPreviewFile();
  }

  void toggleBackground(bool show) {
    showBackground.value = show;
    _resetPreviewFile();
  }

  Future<void> openPreviewPdf() async {
    if (previewFile.value == null) return;
    
    try {
      await OpenFile.open(previewFile.value!.path);
    } catch (e) {
      _showToast('Error opening preview', e);
    }
  }

  Future<void> viewPdfWithChanges() async {
    if (selectedFile.value == null) return;

    isGeneratingPreview.value = true;

    try {
      final bytes = await selectedFile.value!.readAsBytes();
      final PdfDocument document = PdfDocument(inputBytes: bytes);

      final totalPages = document.pages.count;

      // Process ALL pages with page numbers
      for (int i = 0; i < totalPages; i++) {
        final PdfPage page = document.pages[i];
        final Size pageSize = page.size;
        _applyPageNumberToPage(page, i + 1, totalPages, pageSize);
      }

      final List<int> previewBytes = await document.save();
      document.dispose();

      final preview = await _savePreviewPdf(previewBytes);
      previewFile.value = preview;

      // Navigate to ViewPdf screen with the preview file
      Get.to(() => const ViewPdf(), arguments: preview);
    } catch (e) {
      _showToast('Error viewing PDF', e);
    } finally {
      isGeneratingPreview.value = false;
    }
  }

  Future<void> showColorPicker(BuildContext context, bool isTextColor) async {
    Color pickedColor = isTextColor ? textColor.value : backgroundColor.value;
    
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(isTextColor ? 'Choose Text Color' : 'Choose Background Color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: pickedColor,
              onColorChanged: (Color color) {
                pickedColor = color;
              },
              labelTypes: const [],
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (isTextColor) {
                  updateTextColor(pickedColor);
                } else {
                  updateBackgroundColor(pickedColor);
                }
                Navigator.of(context).pop();
              },
              child: const Text('Select'),
            ),
          ],
        );
      },
    );
  }

  String _formatPageNumber(int currentPage, int totalPages) {
    switch (selectedStyle.value) {
      case 'Page X of Y':
        return 'Page $currentPage of $totalPages';
      case 'X / Y':
        return '$currentPage / $totalPages';
      case 'X':
        return '$currentPage';
      case '- X -':
        return '- $currentPage -';
      case '[X]':
        return '[$currentPage]';
      default:
        return 'Page $currentPage of $totalPages';
    }
  }

  void _updateStatus(String status) {
    _pendingStatus = status;

    if (_statusUpdateTimer?.isActive ?? false) return;

    _statusUpdateTimer = Timer(const Duration(milliseconds: 200), () {
      processingStatus.value = _pendingStatus;
    });
  }

  Future<void> addPageNumbers() async {
    if (selectedFile.value == null) {
      _showToast('No File Selected', 'Please select a PDF file first');
      return;
    }

    isProcessing.value = true;
    _resetOutputFile();
    processingStatus.value = 'Loading PDF...';

    try {
      final bytes = await selectedFile.value!.readAsBytes();

      _updateStatus('Adding page numbers...');

      // Load the existing PDF document
      final PdfDocument document = PdfDocument(inputBytes: bytes);

      final totalPages = document.pages.count;

      // Add page numbers to each page
      for (int i = 0; i < totalPages; i++) {
        _updateStatus('Processing page ${i + 1} of $totalPages...');

        final PdfPage page = document.pages[i];
        final Size pageSize = page.size;
        
        _applyPageNumberToPage(page, i + 1, totalPages, pageSize);
      }

      _updateStatus('Saving PDF...');

      // Save the document
      final List<int> outputBytes = await document.save();
      document.dispose();

      final output = await _saveOutputPdf(outputBytes);

      outputFile.value = output;

      _showToast('Success', 'Page numbers added successfully!');
    } catch (e) {
      _showToast('Error adding page numbers', e);
    } finally {
      isProcessing.value = false;
      processingStatus.value = '';
      _statusUpdateTimer?.cancel();
    }
  }

  void _applyPageNumberToPage(PdfPage page, int currentPage, int totalPages, Size pageSize) {
    // Create font
    final PdfFont font = PdfStandardFont(PdfFontFamily.helvetica, fontSize.value.toDouble());

    // Page number text
    final String pageNumberText = _formatPageNumber(currentPage, totalPages);

    // Calculate text size
    final Size textSize = font.measureString(pageNumberText);

    // Calculate position based on selection
    double x = 0;
    double y = 0;

    switch (selectedPosition.value) {
      case 'Top Left':
        x = 30;
        y = 30;
        break;
      case 'Top Center':
        x = (pageSize.width - textSize.width) / 2;
        y = 30;
        break;
      case 'Top Right':
        x = pageSize.width - textSize.width - 30;
        y = 30;
        break;
      case 'Bottom Left':
        x = 30;
        y = pageSize.height - 30;
        break;
      case 'Bottom Center':
        x = (pageSize.width - textSize.width) / 2;
        y = pageSize.height - 30;
        break;
      case 'Bottom Right':
        x = pageSize.width - textSize.width - 30;
        y = pageSize.height - 30;
        break;
    }

    // Draw background circle/rounded rectangle if enabled
    if (showBackground.value && backgroundColor.value != Colors.transparent) {
      final double padding = 8;
      final double bgWidth = textSize.width + (padding * 2);
      final double bgHeight = textSize.height + (padding * 2);
      
      page.graphics.drawRectangle(
        bounds: Rect.fromLTWH(x - padding, y - padding, bgWidth, bgHeight),
        brush: PdfSolidBrush(
          PdfColor(
            backgroundColor.value.red,
            backgroundColor.value.green,
            backgroundColor.value.blue,
            200,
          ),
        ),
        pen: PdfPen(PdfColor(backgroundColor.value.red, backgroundColor.value.green, backgroundColor.value.blue)),
      );
    }

    // Draw page number
    page.graphics.drawString(
      pageNumberText,
      font,
      bounds: Rect.fromLTWH(x, y, textSize.width, textSize.height),
      brush: PdfSolidBrush(
        PdfColor(
          textColor.value.red,
          textColor.value.green,
          textColor.value.blue,
        ),
      ),
    );
  }

  Future<File> _saveOutputPdf(List<int> pdfBytes) async {
    final output = await getTemporaryDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final fileName = selectedFile.value!.path
        .split(Platform.pathSeparator)
        .last
        .replaceAll('.pdf', '');
    final outputPath =
        '${output.path}${Platform.pathSeparator}${fileName}_numbered_$timestamp.pdf';

    final file = File(outputPath);
    await file.writeAsBytes(pdfBytes);

    return file;
  }

  Future<File> _savePreviewPdf(List<int> pdfBytes) async {
    final output = await getTemporaryDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final outputPath =
        '${output.path}${Platform.pathSeparator}preview_$timestamp.pdf';

    final file = File(outputPath);
    await file.writeAsBytes(pdfBytes);

    return file;
  }

  void _resetOutputFile() {
    outputFile.value = null;
  }

  void _resetPreviewFile() {
    previewFile.value = null;
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
