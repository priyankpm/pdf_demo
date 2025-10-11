import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class LockPdfController extends GetxController {
  final Rx<File?> selectedFile = Rx<File?>(null);
  final Rx<File?> lockedFile = Rx<File?>(null);
  final RxInt fileSize = 0.obs;
  final RxBool isProcessing = false.obs;
  final RxString processingStatus = ''.obs;
  final RxBool showPassword = false.obs;

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  Timer? _statusUpdateTimer;
  String _pendingStatus = '';

  String get formattedFileSize => _formatSize(fileSize.value);
  String get selectedFileName =>
      selectedFile.value?.path.split(Platform.pathSeparator).last ?? '';
  String get lockedFileName =>
      lockedFile.value?.path.split(Platform.pathSeparator).last ?? '';
  String get lockedFilePath => lockedFile.value?.path ?? '';

  bool get hasSelectedFile => selectedFile.value != null;
  bool get hasLockedFile => lockedFile.value != null;

  Future<void> pickPdfFile() async {
    try {
      _resetLockedFile();
      _resetPasswordFields();

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

  Future<void> lockPdf() async {
    if (selectedFile.value == null) {
      _showToast('No File Selected', 'Please select a PDF file first');
      return;
    }

    if (passwordController.text.isEmpty) {
      _showToast('Password Required', 'Please enter a password');
      return;
    }

    if (passwordController.text.length < 4) {
      _showToast('Password Too Short', 'Password must be at least 4 characters');
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      _showToast('Password Mismatch', 'Passwords do not match');
      return;
    }

    isProcessing.value = true;
    _resetLockedFile();
    processingStatus.value = 'Loading PDF...';

    try {
      final bytes = await selectedFile.value!.readAsBytes();

      _updateStatus('Applying encryption...');

      // Load the existing PDF document
      final PdfDocument document = PdfDocument(inputBytes: bytes);

      // Create PDF security
      final PdfSecurity security = document.security;

      // Set user password (required to open the document)
      security.userPassword = passwordController.text;

      // Set owner password (for full permissions)
      security.ownerPassword = '${passwordController.text}_owner_${DateTime.now().millisecondsSinceEpoch}';

      // Set encryption algorithm
      security.algorithm = PdfEncryptionAlgorithm.aesx256Bit;

      // Set permissions - disable all modifications
      security.permissions.clear();

      _updateStatus('Saving secured PDF...');

      // Save the document
      final List<int> securedBytes = await document.save();
      document.dispose();

      final outputFile = await _saveLockedPdf(securedBytes);

      lockedFile.value = outputFile;

      _showToast('Success', 'PDF locked successfully with password protection!');
    } catch (e) {
      _showToast('Error locking PDF', e);
    } finally {
      isProcessing.value = false;
      processingStatus.value = '';
      _statusUpdateTimer?.cancel();
    }
  }

  Future<File> _saveLockedPdf(List<int> pdfBytes) async {
    final output = await getTemporaryDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final fileName = selectedFile.value!.path
        .split(Platform.pathSeparator)
        .last
        .replaceAll('.pdf', '');
    final outputPath =
        '${output.path}${Platform.pathSeparator}${fileName}_locked_$timestamp.pdf';

    final outputFile = File(outputPath);
    await outputFile.writeAsBytes(pdfBytes);

    return outputFile;
  }

  void _resetLockedFile() {
    lockedFile.value = null;
  }

  void _resetPasswordFields() {
    passwordController.clear();
    confirmPasswordController.clear();
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
    confirmPasswordController.dispose();
    super.onClose();
  }
}