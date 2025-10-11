import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class UnlockPdfController extends GetxController {
  final Rx<File?> selectedFile = Rx<File?>(null);
  final Rx<File?> unlockedFile = Rx<File?>(null);
  final RxInt fileSize = 0.obs;
  final RxBool isProcessing = false.obs;
  final RxString processingStatus = ''.obs;
  final RxBool showPassword = false.obs;
  final RxBool isPasswordProtected = false.obs;

  final TextEditingController passwordController = TextEditingController();

  Timer? _statusUpdateTimer;
  String _pendingStatus = '';

  String get formattedFileSize => _formatSize(fileSize.value);
  String get selectedFileName =>
      selectedFile.value?.path.split(Platform.pathSeparator).last ?? '';
  String get unlockedFileName =>
      unlockedFile.value?.path.split(Platform.pathSeparator).last ?? '';
  String get unlockedFilePath => unlockedFile.value?.path ?? '';

  bool get hasSelectedFile => selectedFile.value != null;
  bool get hasUnlockedFile => unlockedFile.value != null;

  Future<void> pickPdfFile() async {
    try {
      _resetUnlockedFile();
      _resetPasswordFields();
      isPasswordProtected.value = false;

      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        selectedFile.value = file;
        fileSize.value = file.lengthSync();

        // Check if PDF is password protected
        await _checkPasswordProtection(file);
      }
    } catch (e) {
      _showToast('Error picking file', e);
    }
  }

  Future<void> _checkPasswordProtection(File file) async {
    try {
      final bytes = await file.readAsBytes();
      final PdfDocument document = PdfDocument(inputBytes: bytes);

      // If we can open it without error, it's not password protected
      // or has no user password
      isPasswordProtected.value = document.security.userPassword.isNotEmpty;

      document.dispose();
    } catch (e) {
      // If error occurs, likely password protected
      isPasswordProtected.value = true;
    }
  }

  void togglePasswordVisibility() {
    showPassword.value = !showPassword.value;
  }

  void _updateStatus(String status) {
    _pendingStatus = status;

    if (_statusUpdateTimer?.isActive ?? false) return;

    _statusUpdateTimer = Timer(const Duration(milliseconds: 200), () {
      processingStatus.value = _pendingStatus;
    });
  }

  Future<void> unlockPdf() async {
    if (selectedFile.value == null) {
      _showToast('No File Selected', 'Please select a PDF file first');
      return;
    }

    if (!isPasswordProtected.value) {
      _showToast('Not Protected', 'This PDF is not password protected');
      return;
    }

    if (passwordController.text.isEmpty) {
      _showToast('Password Required', 'Please enter the PDF password');
      return;
    }

    isProcessing.value = true;
    _resetUnlockedFile();
    processingStatus.value = 'Loading PDF...';

    try {
      final bytes = await selectedFile.value!.readAsBytes();

      _updateStatus('Verifying password...');

      // Try to load the PDF with the provided password
      PdfDocument? document;
      try {
        document = PdfDocument(
          inputBytes: bytes,
          password: passwordController.text,
        );
      } catch (e) {
        _showToast('Wrong Password', 'The password you entered is incorrect');
        isProcessing.value = false;
        processingStatus.value = '';
        return;
      }

      _updateStatus('Removing password protection...');

      // Clear the security settings
      document.security.userPassword = '';
      document.security.ownerPassword = '';
      document.security.permissions.clear();

      _updateStatus('Saving unlocked PDF...');

      // Save the document without password
      final List<int> unlockedBytes = await document.save();
      document.dispose();

      final outputFile = await _saveUnlockedPdf(unlockedBytes);

      unlockedFile.value = outputFile;

      _showToast('Success', 'PDF unlocked successfully! Password removed.');
    } catch (e) {
      _showToast('Error unlocking PDF', e);
    } finally {
      isProcessing.value = false;
      processingStatus.value = '';
      _statusUpdateTimer?.cancel();
    }
  }

  Future<File> _saveUnlockedPdf(List<int> pdfBytes) async {
    final output = await getTemporaryDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final fileName = selectedFile.value!.path
        .split(Platform.pathSeparator)
        .last
        .replaceAll('.pdf', '')
        .replaceAll('_locked', '');
    final outputPath =
        '${output.path}${Platform.pathSeparator}${fileName}_unlocked_$timestamp.pdf';

    final outputFile = File(outputPath);
    await outputFile.writeAsBytes(pdfBytes);

    return outputFile;
  }

  void _resetUnlockedFile() {
    unlockedFile.value = null;
  }

  void _resetPasswordFields() {
    passwordController.clear();
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
    passwordController.dispose();
    super.onClose();
  }
}