import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:syncfusion_flutter_pdf/pdf.dart' as sf;

enum ConversionMode { textToPdf, pdfToText }

class ConvertTextPdfController extends GetxController {
  final Rx<File?> selectedFile = Rx<File?>(null);
  final Rx<File?> convertedFile = Rx<File?>(null);
  final Rx<ConversionMode> conversionMode = ConversionMode.textToPdf.obs;
  final RxBool isProcessing = false.obs;
  final RxString processingStatus = ''.obs;

  Timer? _statusUpdateTimer;
  String _pendingStatus = '';

  String get fileName =>
      selectedFile.value?.path.split(Platform.pathSeparator).last ?? '';
  String get fileExtension =>
      selectedFile.value != null ? _getFileExtension(fileName) : '';
  String get fileSize =>
      selectedFile.value != null ? _formatSize(selectedFile.value!.lengthSync()) : '';
  String get convertedFileName =>
      convertedFile.value?.path.split(Platform.pathSeparator).last ?? '';
  String get convertedFileSize =>
      convertedFile.value != null ? _formatSize(convertedFile.value!.lengthSync()) : '';
  String get convertedFilePath => convertedFile.value?.path ?? '';

  bool get hasSelectedFile => selectedFile.value != null;
  bool get hasConvertedFile => convertedFile.value != null;

  void setConversionMode(ConversionMode mode) {
    if (isProcessing.value) return;
    conversionMode.value = mode;
    _resetAll();
  }

  Future<void> pickFile() async {
    try {
      _resetConverted();

      FileType fileType;
      List<String>? allowedExtensions;

      if (conversionMode.value == ConversionMode.textToPdf) {
        fileType = FileType.custom;
        allowedExtensions = ['txt'];
      } else {
        fileType = FileType.custom;
        allowedExtensions = ['pdf'];
      }

      final result = await FilePicker.platform.pickFiles(
        type: fileType,
        allowedExtensions: allowedExtensions,
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        final pickedExt = _getFileExtension(file.path).toLowerCase();

        if (conversionMode.value == ConversionMode.textToPdf) {
          if (pickedExt != '.txt') {
            _showToast('Invalid File', 'Please select a .txt file');
            return;
          }
        } else {
          if (pickedExt != '.pdf') {
            _showToast('Invalid File', 'Please select a .pdf file');
            return;
          }
        }

        selectedFile.value = file;
      }
    } catch (e) {
      _showToast('Error', 'Failed to pick file: $e');
    }
  }

  void _updateStatus(String status) {
    _pendingStatus = status;
    if (_statusUpdateTimer?.isActive ?? false) return;
    _statusUpdateTimer = Timer(const Duration(milliseconds: 200), () {
      processingStatus.value = _pendingStatus;
    });
  }

  Future<void> convertFile() async {
    if (selectedFile.value == null) {
      _showToast('No File', 'Please select a file first');
      return;
    }

    isProcessing.value = true;
    _resetConverted();

    try {
      if (conversionMode.value == ConversionMode.textToPdf) {
        await _textToPdf();
      } else {
        await _pdfToText();
      }

      _showToast('Success', 'File converted successfully!');
    } catch (e) {
      _showToast('Error', 'Conversion failed: $e');
      convertedFile.value = null;
    } finally {
      isProcessing.value = false;
      processingStatus.value = '';
      _statusUpdateTimer?.cancel();
    }
  }

  // ==================== TXT TO PDF ====================

  Future<void> _textToPdf() async {
    _updateStatus('Reading text file...');

    String textContent;
    try {
      final bytes = await selectedFile.value!.readAsBytes();

      try {
        textContent = const Utf8Decoder(allowMalformed: true).convert(bytes);
      } catch (e) {
        textContent = latin1.decode(bytes);
        _showToast('Info', 'File decoded using Latin-1 encoding');
      }
    } catch (e) {
      throw Exception('Failed to read text file: $e');
    }

    if (textContent.trim().isEmpty) {
      textContent = 'The text file appears to be empty.';
      _showToast('Warning', 'The selected file is empty');
    }

    _updateStatus('Creating PDF...');
    final pdf = pw.Document();

    // Split text into lines preserving line breaks
    final lines = textContent.split('\n');

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (context) {
          List<pw.Widget> widgets = [];

          for (var line in lines) {
            if (line.trim().isEmpty) {
              // Preserve empty lines for spacing
              widgets.add(pw.SizedBox(height: 6));
            } else {
              widgets.add(
                pw.Text(
                  line,
                  style: const pw.TextStyle(
                    fontSize: 11,
                    lineSpacing: 1.5,
                  ),
                ),
              );
            }
          }

          return widgets.isEmpty
              ? [pw.Text('No content found')]
              : widgets;
        },
      ),
    );

    _updateStatus('Saving PDF...');
    convertedFile.value = await _savePdf(pdf, 'text_to_pdf');
  }

  // ==================== PDF TO TXT ====================

  Future<void> _pdfToText() async {
    _updateStatus('Loading PDF...');
    final bytes = await selectedFile.value!.readAsBytes();

    _updateStatus('Extracting text...');
    final sf.PdfDocument document = sf.PdfDocument(inputBytes: bytes);

    final StringBuffer textBuffer = StringBuffer();

    for (int i = 0; i < document.pages.count; i++) {
      _updateStatus('Extracting text from page ${i + 1} of ${document.pages.count}...');
      final sf.PdfTextExtractor extractor = sf.PdfTextExtractor(document);
      final String pageText = extractor.extractText(startPageIndex: i, endPageIndex: i);

      // Add page separator for multi-page PDFs
      if (i > 0) {
        textBuffer.writeln('');
        textBuffer.writeln('=' * 60);
        textBuffer.writeln('Page ${i + 1}');
        textBuffer.writeln('=' * 60);
      } else {
        if (document.pages.count > 1) {
          textBuffer.writeln('Page 1');
          textBuffer.writeln('=' * 60);
        }
      }

      textBuffer.writeln(pageText);
    }

    document.dispose();

    _updateStatus('Saving text file...');
    convertedFile.value = await _saveText(textBuffer.toString(), 'pdf_to_text');
  }

  // ==================== HELPER METHODS ====================

  Future<File> _savePdf(pw.Document pdf, String prefix) async {
    final output = await getTemporaryDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final outputPath = '${output.path}${Platform.pathSeparator}${prefix}_$timestamp.pdf';

    final outputFile = File(outputPath);
    final bytes = await pdf.save();
    await outputFile.writeAsBytes(bytes);

    return outputFile;
  }

  Future<File> _saveText(String content, String prefix) async {
    final output = await getTemporaryDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final outputPath = '${output.path}${Platform.pathSeparator}${prefix}_$timestamp.txt';

    final outputFile = File(outputPath);
    await outputFile.writeAsString(content, encoding: utf8);

    return outputFile;
  }

  String _getFileExtension(String filename) {
    final parts = filename.split('.');
    return parts.length > 1 ? '.${parts.last.toLowerCase()}' : '';
  }

  String _formatSize(int bytes) {
    if (bytes == 0) return '0 KB';
    final kb = bytes / 1024;
    final mb = kb / 1024;
    if (mb >= 1) return "${mb.toStringAsFixed(2)} MB";
    return "${kb.toStringAsFixed(2)} KB";
  }

  void _resetConverted() {
    convertedFile.value = null;
  }

  void _resetAll() {
    selectedFile.value = null;
    convertedFile.value = null;
  }

  void _showToast(String title, String message) => Get.snackbar(
    title,
    message,
    colorText: Colors.white,
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: Colors.grey.shade700,
    duration: const Duration(seconds: 3),
    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
  );

  @override
  void onClose() {
    _statusUpdateTimer?.cancel();
    super.onClose();
  }
}