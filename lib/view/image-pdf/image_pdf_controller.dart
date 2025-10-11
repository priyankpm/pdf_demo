import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:image/image.dart' as img;

class ImageToPdfController extends GetxController {
  final RxList<File> images = <File>[].obs;
  final RxBool isProcessing = false.obs;
  final RxString processingStatus = ''.obs;

  int get imageCount => images.length;
  bool get hasImages => images.isNotEmpty;

  Future<void> pickImages() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: true,
      );

      if (result != null && result.files.isNotEmpty) {
        final newImages = result.files
            .where((file) => file.path != null)
            .map((file) => File(file.path!))
            .toList();

        images.addAll(newImages);
      }
    } catch (e) {
      _showToast('Error', 'Failed to pick images: $e');
    }
  }

  void removeImage(int index) {
    if (index >= 0 && index < images.length) {
      images.removeAt(index);
    }
  }

  void clearAllImages() {
    Get.dialog(
      AlertDialog(
        title: const Text('Clear All Images'),
        content: const Text('Are you sure you want to remove all images?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              images.clear();
              Get.back();
              _showToast('Cleared', 'All images removed');
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }

  void reorderImages(int oldIndex, int newIndex) {
    final image = images.removeAt(oldIndex);
    images.insert(newIndex, image);
  }

  Future<void> convertToPdf() async {
    if (images.isEmpty) {
      _showToast('No Images', 'Please select images first');
      return;
    }

    isProcessing.value = true;
    processingStatus.value = 'Preparing...';

    try {
      final pdf = pw.Document(compress: true, version: PdfVersion.pdf_1_5);

      for (int i = 0; i < images.length; i++) {
        processingStatus.value =
            'Processing image ${i + 1} of ${images.length}...';

        final imageBytes = await images[i].readAsBytes();

        final processedImage = await compute(
          _processImageInIsolate,
          imageBytes,
        );

        final finalImageBytes = processedImage ?? imageBytes;

        final decodedImage = img.decodeImage(imageBytes);
        if (decodedImage == null) {
          _showToast(
            'Warning',
            'Image ${i + 1} couldn’t be read properly. Please remove it and continue generating.',
          );
          isProcessing.value = false;
          processingStatus.value = '';
          return;
        }

        final pageFormat = PdfPageFormat(
          decodedImage.width.toDouble(),
          decodedImage.height.toDouble(),
          marginAll: 0,
        );

        pdf.addPage(
          pw.Page(
            pageFormat: pageFormat,
            build: (context) {
              return pw.Image(
                pw.MemoryImage(finalImageBytes),
                fit: pw.BoxFit.contain,
              );
            },
          ),
        );

        await Future.delayed(const Duration(milliseconds: 50));
      }

      processingStatus.value = 'Saving PDF...';

      final outputFile = await _savePdf(pdf);
      final fileSize = outputFile.lengthSync();

      isProcessing.value = false;
      processingStatus.value = '';

      _showSuccessDialog(outputFile, fileSize);
    } catch (e) {
      _showToast('Error', 'Failed to convert images: $e');
      isProcessing.value = false;
      processingStatus.value = '';
    }
  }

  static Uint8List? _processImageInIsolate(Uint8List imageBytes) {
    try {
      final originalImage = img.decodeImage(imageBytes);
      if (originalImage == null) return null;

      img.Image processedImage = originalImage;

      if (originalImage.width > 2000 || originalImage.height > 2000) {
        final ratio = originalImage.width / originalImage.height;
        int newWidth, newHeight;

        if (ratio > 1) {
          newWidth = 2000;
          newHeight = (2000 / ratio).round();
        } else {
          newHeight = 2000;
          newWidth = (2000 * ratio).round();
        }

        processedImage = img.copyResize(
          originalImage,
          width: newWidth,
          height: newHeight,
          interpolation: img.Interpolation.linear,
        );
      }

      return Uint8List.fromList(img.encodeJpg(processedImage, quality: 90));
    } catch (e) {
      return null;
    }
  }

  Future<File> _savePdf(pw.Document pdf) async {
    final output = await getTemporaryDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final outputPath =
        '${output.path}${Platform.pathSeparator}images_to_pdf_$timestamp.pdf';

    final outputFile = File(outputPath);
    final pdfBytes = await pdf.save();
    await outputFile.writeAsBytes(pdfBytes);

    return outputFile;
  }

  void _showSuccessDialog(File file, int fileSize) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Success Icon
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.teal[50],
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_circle,
                  color: Colors.teal[700],
                  size: 48,
                ),
              ),
              const SizedBox(height: 16),

              const Text(
                'PDF Created Successfully!',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),

              Card(
                elevation: 0,
                color: Colors.teal[50],
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.picture_as_pdf,
                                color: Colors.teal[700],
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Pages:',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            '${images.length}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.file_present,
                                color: Colors.teal[700],
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'File Size:',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            _formatSize(fileSize),
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Saved Location:',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      file.path,
                      style: TextStyle(fontSize: 11, color: Colors.grey[700]),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Done Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Get.back();
                    images.clear();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Done',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
    duration: const Duration(seconds: 3),
    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
  );
}
