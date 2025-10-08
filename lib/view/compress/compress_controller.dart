import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:image/image.dart' as img;

class CompressorController extends GetxController {
  File? selectedFile;
  File? compressedFile;
  int? originalSize;
  int? compressedSize;

  var processing = false.obs;
  var processingStatus = ''.obs;
  var selectedQuality = 'Medium'.obs;

  Future<void> pickPDF() async {
    compressedFile = null;
    compressedSize = null;

    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );
      if (result != null && result.files.single.path != null) {
        selectedFile = File(result.files.single.path!);
        originalSize = selectedFile!.lengthSync();
        update();
      }
    } catch (e) {
      Get.snackbar("Error", "Error picking file: $e");
    }
  }

  String formatSize(int bytes) {
    double kb = bytes / 1024;
    double mb = kb / 1024;
    if (mb >= 1) return "${mb.toStringAsFixed(2)} MB";
    return "${kb.toStringAsFixed(2)} KB";
  }

  int getImageQuality() {
    switch (selectedQuality.value) {
      case 'Normal':
        return 85;
      case 'Best':
        return 50;
      default:
        return 70;
    }
  }

  double getDPI() {
    switch (selectedQuality.value) {
      case 'Normal':
        return 150.0;
      case 'Best':
        return 100.0;
      default:
        return 120.0;
    }
  }

  double savedPercent() {
    if (originalSize == null || compressedSize == null) return 0;
    return (1 - (compressedSize! / originalSize!)) * 100;
  }

  Future<void> compressPdf() async {
    if (selectedFile == null) return;

    processing.value = true;
    compressedFile = null;
    compressedSize = null;
    processingStatus.value = 'Loading PDF...';

    try {
      final bytes = await selectedFile!.readAsBytes();
      final dpi = getDPI();
      final quality = getImageQuality();

      processingStatus.value = 'Rendering pages at ${dpi.toInt()} DPI...';

      final pageImages = Printing.raster(bytes, dpi: dpi);
      final pdf = pw.Document(compress: true, version: PdfVersion.pdf_1_5);

      int pageCount = 0;
      await for (final page in pageImages) {
        pageCount++;
        processingStatus.value = 'Compressing page $pageCount...';

        final imageBytes = await page.toPng();
        final originalImage = img.decodeImage(imageBytes);
        if (originalImage == null) continue;

        final compressedImageBytes = img.encodeJpg(originalImage, quality: quality);

        pdf.addPage(
          pw.Page(
            pageFormat: PdfPageFormat(
              double.parse("${page.width}"),
              double.parse("${page.height}"),
              marginAll: 0,
            ),
            build: (context) {
              return pw.Image(
                pw.MemoryImage(Uint8List.fromList(compressedImageBytes)),
                fit: pw.BoxFit.fill,
              );
            },
          ),
        );
        await Future.delayed(const Duration(milliseconds: 10));
      }

      processingStatus.value = 'Saving compressed PDF...';
      final output = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = selectedFile!.path.split(Platform.pathSeparator).last.replaceAll('.pdf', '');
      final outputPath = '${output.path}${Platform.pathSeparator}${fileName}_compressed_$timestamp.pdf';
      final outputFile = File(outputPath);
      final pdfBytes = await pdf.save();
      await outputFile.writeAsBytes(pdfBytes);

      compressedFile = outputFile;
      compressedSize = outputFile.lengthSync();

      processing.value = false;
      processingStatus.value = '';

      if (compressedSize! < originalSize!) {
        final saved = savedPercent().toStringAsFixed(1);
        Get.snackbar("Success", "PDF compressed successfully! Saved $saved%");
      } else {
        Get.snackbar("Info", "PDF processed (file may already be optimized)");
      }

      update();
    } catch (e) {
      processing.value = false;
      processingStatus.value = '';
      Get.snackbar("Error", "Error compressing PDF: $e");
    }
  }
}
