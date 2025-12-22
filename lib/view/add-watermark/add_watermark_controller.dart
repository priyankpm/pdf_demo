import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf_demo/view/view-pdf/view_pdf.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class AddWatermarkController extends GetxController {
  final Rx<File?> selectedFile = Rx<File?>(null);
  final Rx<File?> outputFile = Rx<File?>(null);
  final Rx<File?> previewFile = Rx<File?>(null);
  final RxInt fileSize = 0.obs;
  final RxBool isProcessing = false.obs;
  final RxBool isGeneratingPreview = false.obs;
  final RxString processingStatus = ''.obs;
  
  // Watermark text settings
  final RxString watermarkText = 'CONFIDENTIAL'.obs;
  final RxInt fontSize = 30.obs;
  final textColor = Color(0xFF808080).obs; // Plain Color, not MaterialColor - Grey default
  final baseColor = Color(0xFF808080).obs; // Store color without opacity - Grey default
  final RxDouble rotation = 45.0.obs;
  final RxDouble opacity = 0.5.obs;
  
  // Watermark style
  final RxString watermarkStyle = 'Diagonal'.obs;
  final RxString fontStyle = 'Normal'.obs; // Normal, Bold, or Italic
  
  final List<String> fontStyles = [
    'Normal',
    'Bold',
    'Italic',
  ];
  
  // Position settings
  final RxString position = 'Center'.obs;
  final RxBool repeatWatermark = true.obs;
  final RxDouble spacing = 250.0.obs;

  final List<String> watermarkStyles = [
    'Diagonal',
    'Horizontal',
    'Vertical',
  ];

  final List<String> positions = [
    'Center',
    'Top Left',
    'Top Center',
    'Top Right',
    'Bottom Left',
    'Bottom Center',
    'Bottom Right',
  ];

  final List<Color> availableColors = [
    Color(0xFF808080), // Gray - Draft
    Color(0xFF000000), // Black - Professional
    Color(0xFFFF0000), // Red - Confidential
    Color(0xFF0000FF), // Blue - Approved
    Color(0xFFFF6B35), // Orange - Urgent
  ];

  Timer? _statusUpdateTimer;
  String _pendingStatus = '';

  String get formattedFileSize => _formatSize(fileSize.value);
  String get selectedFileName =>
      selectedFile.value?.path.split(Platform.pathSeparator).last ?? '';
  String get outputFileName =>
      outputFile.value?.path.split(Platform.pathSeparator).last ?? '';
  String get outputFilePath => outputFile.value?.path ?? '';

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

  void updateWatermarkText(String text) {
    watermarkText.value = text;
    _resetPreviewFile();
  }

  void updateFontSize(double size) {
    fontSize.value = size.toInt();
    _resetPreviewFile();
  }

  void updateTextColor(Color color) {
    // Convert MaterialColor to plain Color to avoid type issues
    final plainColor = Color(color.value);
    baseColor.value = plainColor;
    textColor.value = plainColor.withValues(alpha: opacity.value);
    _resetPreviewFile();
  }

  void updateRotation(double angle) {
    rotation.value = angle;
    _resetPreviewFile();
  }

  void updateOpacity(double value) {
    opacity.value = value;
    textColor.value = baseColor.value.withValues(alpha: value);
    _resetPreviewFile();
  }

  Future<void> showColorPicker(BuildContext context) async {
    Color pickedColor = baseColor.value;
    
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Choose Watermark Color'),
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
                updateTextColor(pickedColor);
                Navigator.of(context).pop();
              },
              child: const Text('Select'),
            ),
          ],
        );
      },
    );
  }

  void updateStyle(String style) {
    watermarkStyle.value = style;
    // Auto-adjust rotation based on style
    if (style == 'Diagonal') {
      rotation.value = 45.0;
    } else if (style == 'Horizontal') {
      rotation.value = 0.0;
    } else if (style == 'Vertical') {
      rotation.value = 90.0;
    }
    _resetPreviewFile();
  }

  void updatePosition(String pos) {
    position.value = pos;
    _resetPreviewFile();
  }

  void updateFontStyle(String style) {
    fontStyle.value = style;
    _resetPreviewFile();
  }

  void toggleRepeat(bool value) {
    repeatWatermark.value = value;
    _resetPreviewFile();
  }

  void updateSpacing(double value) {
    spacing.value = value;
    _resetPreviewFile();
  }

  Future<void> viewPdfWithChanges() async {
    if (selectedFile.value == null) return;

    isGeneratingPreview.value = true;

    try {
      final bytes = await selectedFile.value!.readAsBytes();
      final PdfDocument document = PdfDocument(inputBytes: bytes);

      final totalPages = document.pages.count;

      // Apply watermark to all pages
      for (int i = 0; i < totalPages; i++) {
        final PdfPage page = document.pages[i];
        _applyWatermarkToPage(page);
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

  Future<void> addWatermark() async {
    if (selectedFile.value == null) {
      _showToast('No File Selected', 'Please select a PDF file first');
      return;
    }

    if (watermarkText.value.trim().isEmpty) {
      _showToast('No Watermark Text', 'Please enter watermark text');
      return;
    }

    isProcessing.value = true;
    _resetOutputFile();
    processingStatus.value = 'Loading PDF...';

    try {
      final bytes = await selectedFile.value!.readAsBytes();

      _updateStatus('Adding watermark...');

      final PdfDocument document = PdfDocument(inputBytes: bytes);
      final totalPages = document.pages.count;

      // Add watermark to each page
      for (int i = 0; i < totalPages; i++) {
        _updateStatus('Processing page ${i + 1} of $totalPages...');
        final PdfPage page = document.pages[i];
        _applyWatermarkToPage(page);
      }

      _updateStatus('Saving PDF...');

      final List<int> outputBytes = await document.save();
      document.dispose();

      final output = await _saveOutputPdf(outputBytes);
      outputFile.value = output;

      _showToast('Success', 'Watermark added successfully!');
    } catch (e) {
      _showToast('Error adding watermark', e);
    } finally {
      isProcessing.value = false;
      processingStatus.value = '';
      _statusUpdateTimer?.cancel();
    }
  }

  void _applyWatermarkToPage(PdfPage page) {
    final Size pageSize = page.size;
    final PdfGraphics graphics = page.graphics;

    // Create font with style
    PdfFont font;
    if (fontStyle.value == 'Bold') {
      font = PdfStandardFont(PdfFontFamily.helvetica, fontSize.value.toDouble(),
          style: PdfFontStyle.bold);
    } else if (fontStyle.value == 'Italic') {
      font = PdfStandardFont(PdfFontFamily.helvetica, fontSize.value.toDouble(),
          style: PdfFontStyle.italic);
    } else {
      font = PdfStandardFont(PdfFontFamily.helvetica, fontSize.value.toDouble());
    }

    // Measure text
    final Size textSize = font.measureString(watermarkText.value);
    
    // Create brush without opacity in color
    final PdfBrush brush = PdfSolidBrush(
      PdfColor(
        baseColor.value.red,
        baseColor.value.green,
        baseColor.value.blue,
      ),
    );

    // Save graphics state and set transparency
    final PdfGraphicsState state = graphics.save();
    graphics.setTransparency(opacity.value);

    if (repeatWatermark.value) {
      // Draw repeated watermark pattern
      final double spacingValue = spacing.value;
      final int horizontalCount = (pageSize.width / spacingValue).ceil() + 1;
      final int verticalCount = (pageSize.height / spacingValue).ceil() + 1;

      for (int i = 0; i < horizontalCount; i++) {
        for (int j = 0; j < verticalCount; j++) {
          final double x = i * spacingValue;
          final double y = j * spacingValue;

          graphics.save();
          graphics.translateTransform(x, y);
          graphics.rotateTransform(-rotation.value);
          graphics.drawString(
            watermarkText.value,
            font,
            brush: brush,
            bounds: Rect.fromLTWH(-textSize.width / 2, -textSize.height / 2,
                textSize.width, textSize.height),
          );
          graphics.restore();
        }
      }
    } else {
      // Draw single watermark at specified position
      double x = 0;
      double y = 0;

      switch (position.value) {
        case 'Center':
          x = pageSize.width / 2;
          y = pageSize.height / 2;
          break;
        case 'Top Left':
          x = textSize.width / 2 + 50;
          y = textSize.height / 2 + 50;
          break;
        case 'Top Center':
          x = pageSize.width / 2;
          y = textSize.height / 2 + 50;
          break;
        case 'Top Right':
          x = pageSize.width - textSize.width / 2 - 50;
          y = textSize.height / 2 + 50;
          break;
        case 'Bottom Left':
          x = textSize.width / 2 + 50;
          y = pageSize.height - textSize.height / 2 - 50;
          break;
        case 'Bottom Center':
          x = pageSize.width / 2;
          y = pageSize.height - textSize.height / 2 - 50;
          break;
        case 'Bottom Right':
          x = pageSize.width - textSize.width / 2 - 50;
          y = pageSize.height - textSize.height / 2 - 50;
          break;
      }

      graphics.translateTransform(x, y);
      graphics.rotateTransform(-rotation.value);
      graphics.drawString(
        watermarkText.value,
        font,
        brush: brush,
        bounds: Rect.fromLTWH(-textSize.width / 2, -textSize.height / 2,
            textSize.width, textSize.height),
      );
    }

    // Restore graphics state
    graphics.restore(state);
  }

  void _updateStatus(String status) {
    _pendingStatus = status;

    if (_statusUpdateTimer?.isActive ?? false) return;

    _statusUpdateTimer = Timer(const Duration(milliseconds: 200), () {
      processingStatus.value = _pendingStatus;
    });
  }

  Future<File> _saveOutputPdf(List<int> pdfBytes) async {
    final output = await getTemporaryDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final fileName = selectedFile.value!.path
        .split(Platform.pathSeparator)
        .last
        .replaceAll('.pdf', '');
    final outputPath =
        '${output.path}${Platform.pathSeparator}${fileName}_watermarked_$timestamp.pdf';

    final file = File(outputPath);
    await file.writeAsBytes(pdfBytes);

    return file;
  }

  Future<File> _savePreviewPdf(List<int> pdfBytes) async {
    final output = await getTemporaryDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final outputPath =
        '${output.path}${Platform.pathSeparator}preview_watermark_$timestamp.pdf';

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
