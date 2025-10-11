import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdf_demo/view/lock-pdf/lock_pdf_controller.dart';

class LockPdf extends StatefulWidget {
  const LockPdf({super.key});

  @override
  State<LockPdf> createState() => _LockPdfState();
}

class _LockPdfState extends State<LockPdf> {
  final controller = Get.put(LockPdfController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('PDF Lock'),
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeaderCard(),
              const SizedBox(height: 20),
              _buildSelectButton(controller),
              const SizedBox(height: 20),
              Obx(
                    () => controller.hasSelectedFile
                    ? _buildSelectedFileSection(controller)
                    : _buildEmptyState(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Icon(Icons.lock, size: 48, color: Colors.deepOrange),
            const SizedBox(height: 12),
            const Text(
              'PDF Lock',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Secure your PDF files with password protection',
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectButton(LockPdfController controller) {
    return Obx(
          () => ElevatedButton.icon(
        onPressed: controller.isProcessing.value
            ? null
            : controller.pickPdfFile,
        icon: const Icon(Icons.folder_open),
        label: const Text('Select PDF File'),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          backgroundColor: Colors.deepOrange,
          foregroundColor: Colors.white,
          textStyle: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildSelectedFileSection(LockPdfController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildFileInfoCard(controller),
        const SizedBox(height: 20),
        _buildPasswordCard(controller),

        const SizedBox(height: 20),
        _buildLockButton(controller),
        Obx(
              () => controller.isProcessing.value
              ? _buildProcessingIndicator(controller)
              : const SizedBox.shrink(),
        ),
        Obx(
              () => controller.hasLockedFile
              ? _buildResultCard(controller)
              : const SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _buildFileInfoCard(LockPdfController controller) {
    return Obx(
          () => Card(
        elevation: 2,
        color: Colors.deepOrange[50],
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.picture_as_pdf, color: Colors.deepOrange[700]),
                  const SizedBox(width: 8),
                  const Text(
                    "Selected File",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
              const Divider(height: 20),
              _buildInfoRow('Filename', controller.selectedFileName),
              const SizedBox(height: 8),
              _buildInfoRow('File Size', controller.formattedFileSize),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordCard(LockPdfController controller) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.vpn_key, color: Colors.deepOrange[700], size: 20),
                const SizedBox(width: 8),
                const Text(
                  "Password Protection",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Obx(
                  () => TextField(
                controller: controller.passwordController,
                enabled: !controller.isProcessing.value,
                obscureText: !controller.showPassword.value,
                decoration: InputDecoration(
                  labelText: 'Enter Password',
                  hintText: 'Minimum 4 characters',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                      controller.showPassword.value
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: controller.togglePasswordVisibility,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Obx(
                  () => TextField(
                controller: controller.confirmPasswordController,
                enabled: !controller.isProcessing.value,
                obscureText: !controller.showPassword.value,
                decoration: const InputDecoration(
                  labelText: 'Confirm Password',
                  hintText: 'Re-enter password',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }



  Widget _buildLockButton(LockPdfController controller) {
    return Obx(
          () => ElevatedButton.icon(
        onPressed: controller.isProcessing.value
            ? null
            : controller.lockPdf,
        icon: controller.isProcessing.value
            ? const SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Colors.white,
          ),
        )
            : const Icon(Icons.lock, size: 24),
        label: Text(
          controller.isProcessing.value ? 'Locking...' : 'Lock PDF',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          backgroundColor: Colors.deepOrange,
          foregroundColor: Colors.white,
        ),
      ),
    );
  }

  Widget _buildProcessingIndicator(LockPdfController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Obx(
            () => Center(
          child: Column(
            children: [
              Text(
                controller.processingStatus.value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'Securing your PDF...',
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultCard(LockPdfController controller) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Obx(
            () => Card(
          elevation: 4,
          color: Colors.deepOrange[50],
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.check_circle,
                        color: Colors.deepOrange[700], size: 28),
                    const SizedBox(width: 12),
                    const Text(
                      "PDF Locked Successfully!",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.deepOrange,
                      ),
                    ),
                  ],
                ),
                const Divider(height: 24),
                _buildInfoRow('Locked File', controller.lockedFileName),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.deepOrange[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.security, color: Colors.deepOrange[900]),
                      const SizedBox(width: 8),
                      Text(
                        "Password Protected",
                        style: TextStyle(
                          color: Colors.deepOrange[900],
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(6),
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
                        controller.lockedFilePath,
                        style: TextStyle(fontSize: 11, color: Colors.grey[700]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.upload_file, size: 80, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(
              'No PDF selected',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Click "Select PDF File" to begin',
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            '$label:',
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
        ),
        Expanded(child: Text(value, style: const TextStyle(fontSize: 14))),
      ],
    );
  }
}