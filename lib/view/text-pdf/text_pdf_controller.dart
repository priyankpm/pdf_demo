import 'package:flutter/material.dart';
import 'package:flutter_quill/quill_delta.dart' as quill;
import 'package:get/get.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class TextToPdfController extends GetxController {
  final TextEditingController pdfNameController = TextEditingController();
  final RxBool isProcessing = false.obs;
  final Rx<File?> generatedFile = Rx<File?>(null);

  late quill.QuillController quillController;

  bool get hasGeneratedFile => generatedFile.value != null;
  String get generatedFileName =>
      generatedFile.value?.path.split(Platform.pathSeparator).last ?? '';
  String get generatedFilePath => generatedFile.value?.path ?? '';

  @override
  void onInit() {
    super.onInit();
    quillController = quill.QuillController.basic();
  }

  Future<void> generatePdfFromText() async {
    if (quillController.document.toPlainText().trim().isEmpty) {
      _showToast('Error', 'Please enter some text to generate PDF');
      return;
    }

    isProcessing.value = true;

    try {
      final pdf = pw.Document();
      final delta = quillController.document.toDelta();

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(32),
          build: (_) => _buildPdfContent(delta),
        ),
      );

      final dir = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final nameInput = pdfNameController.text.trim();
      final fileName = nameInput.isEmpty
          ? 'document-$timestamp'
          : '${nameInput.replaceAll(' ', '_')}-$timestamp';
      final filePath = '${dir.path}${Platform.pathSeparator}$fileName.pdf';

      final file = File(filePath);
      await file.writeAsBytes(await pdf.save());
      generatedFile.value = file;

      _showToast('Success', 'PDF generated successfully!');
    } catch (e) {
      _showToast('Error', 'Failed to generate PDF: $e');
    } finally {
      isProcessing.value = false;
    }
  }

  List<pw.Widget> _buildPdfContent(quill.Delta delta) {
    final widgets = <pw.Widget>[];

    for (var op in delta.toList()) {
      if (op.data is String) {
        final text = op.data as String;
        final attributes = op.attributes ?? {};

        final isBold = attributes['bold'] == true;
        final isItalic = attributes['italic'] == true;
        final isUnderline = attributes['underline'] == true;

        double fontSize = 12;
        if (attributes['size'] != null) {
          fontSize = _parseFontSize(attributes['size']);
        }

        PdfColor textColor = PdfColors.black;
        if (attributes['color'] != null) {
          textColor = _parseColor(attributes['color']);
        }

        pw.TextAlign alignment = pw.TextAlign.left;
        if (attributes['align'] != null) {
          alignment = _parseAlignment(attributes['align']);
        }

        final style = pw.TextStyle(
          fontSize: fontSize,
          color: textColor,
          fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
          fontStyle: isItalic ? pw.FontStyle.italic : pw.FontStyle.normal,
          decoration:
          isUnderline ? pw.TextDecoration.underline : pw.TextDecoration.none,
        );

        widgets.add(
          pw.Padding(
            padding: const pw.EdgeInsets.only(bottom: 6),
            child: pw.Text(text, style: style, textAlign: alignment),
          ),
        );
      }
    }

    return widgets;
  }

  double _parseFontSize(dynamic size) {
    if (size is String) {
      switch (size) {
        case 'small':
          return 10;
        case 'large':
          return 18;
        case 'huge':
          return 28;
        default:
          return double.tryParse(size) ?? 12;
      }
    }
    return 12;
  }

  PdfColor _parseColor(dynamic color) {
    if (color is String) {
      String colorStr = color.replaceAll('#', '');
      if (colorStr.length == 6) {
        final r = int.parse(colorStr.substring(0, 2), radix: 16);
        final g = int.parse(colorStr.substring(2, 4), radix: 16);
        final b = int.parse(colorStr.substring(4, 6), radix: 16);
        return PdfColor(r / 255, g / 255, b / 255);
      }
    }
    return PdfColors.black;
  }

  pw.TextAlign _parseAlignment(dynamic align) {
    switch (align) {
      case 'center':
        return pw.TextAlign.center;
      case 'right':
        return pw.TextAlign.right;
      case 'justify':
        return pw.TextAlign.justify;
      default:
        return pw.TextAlign.left;
    }
  }

  void _showToast(String title, String message) {
    Get.snackbar(
      title,
      message,
      backgroundColor: Colors.black87,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    );
  }

  @override
  void onClose() {
    pdfNameController.dispose();
    quillController.dispose();
    super.onClose();
  }
}
