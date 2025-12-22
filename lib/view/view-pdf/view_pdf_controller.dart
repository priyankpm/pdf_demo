import 'dart:async';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class ViewPdfController extends GetxController {
  final Rx<File?> selectedFile = Rx<File?>(null);
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxInt currentPage = 1.obs;
  final RxInt totalPages = 0.obs;
  final RxDouble zoomLevel = 1.0.obs;
  final RxBool showZoomLevel = false.obs;

  final pdfController = PdfViewerController();
  final pdfViewerKey = GlobalKey<SfPdfViewerState>();
  Timer? _zoomLevelTimer;

  @override
  void onInit() {
    super.onInit();
    // Check if a file was passed as argument
    if (Get.arguments != null && Get.arguments is File) {
      selectedFile.value = Get.arguments as File;
      currentPage.value = 1;
      totalPages.value = 0;
      zoomLevel.value = 1.0;
    }
  }

  /// Pick PDF from file manager and open in viewer
  Future<void> pickAndOpenPdf() async {
    try {
      errorMessage.value = '';

      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        selectedFile.value = File(result.files.single.path!);
        currentPage.value = 1;
        totalPages.value = 0;
        zoomLevel.value = 1.0;
      } else {
        _showToast('No file selected', 'Please select a PDF file.');
      }
    } catch (e) {
      errorMessage.value = 'Error picking PDF: ${e.toString()}';
      _showToast('Error', errorMessage.value);
    }
  }

  void closeViewer() {
    selectedFile.value = null;
    currentPage.value = 1;
    totalPages.value = 0;
  }

  void updatePageNumber(int pageNumber) {
    currentPage.value = pageNumber;
  }

  void updateTotalPages(int pages) {
    totalPages.value = pages;
  }

  void nextPage() {
    if (currentPage.value < totalPages.value) {
      pdfController.nextPage();
    }
  }

  void previousPage() {
    if (currentPage.value > 1) {
      pdfController.previousPage();
    }
  }

  void zoomIn() {
    final newZoom = (zoomLevel.value + 0.25).clamp(1.0, 3.0);
    pdfController.zoomLevel = newZoom;
    zoomLevel.value = newZoom;
    _showZoomIndicator();
  }

  void zoomOut() {
    final newZoom = (zoomLevel.value - 0.25).clamp(1.0, 3.0);
    pdfController.zoomLevel = newZoom;
    zoomLevel.value = newZoom;
    _showZoomIndicator();
  }


  void _showZoomIndicator() {
    showZoomLevel.value = true;
    _zoomLevelTimer?.cancel();
    _zoomLevelTimer = Timer(const Duration(seconds: 1), () {
      showZoomLevel.value = false;
    });
  }

  void _showToast(String title, String message) {
    Get.snackbar(
      title,
      message,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.grey.shade700,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(20),
    );
  }

  @override
  void onClose() {
    _zoomLevelTimer?.cancel();
    pdfController.dispose();
    super.onClose();
  }
}
