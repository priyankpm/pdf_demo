import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdf_demo/view/rotate-pdf/rotate_pdf_controller.dart';

class RotatePdf extends StatefulWidget {
  const RotatePdf({super.key});

  @override
  State<RotatePdf> createState() => _RotatePdfState();
}

class _RotatePdfState extends State<RotatePdf> {
  final controller = Get.put(RotatePdfController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Rotate PDF'),
        backgroundColor: Colors.teal,
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
            const Icon(Icons.rotate_right, size: 48, color: Colors.teal),
            const SizedBox(height: 12),
            const Text(
              'Rotate PDF Pages',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Rotate pages clockwise or counterclockwise',
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectButton(RotatePdfController controller) {
    return Obx(
          () => ElevatedButton.icon(
        onPressed: controller.isProcessing.value
            ? null
            : controller.pickPdfFile,
        icon: const Icon(Icons.upload_file),
        label: Text(
          controller.hasSelectedFile ? 'Change PDF File' : 'Select PDF File',
        ),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
          textStyle: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildSelectedFileSection(RotatePdfController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildFileInfoCard(controller),
        const SizedBox(height: 20),
        _buildRotationOptionsCard(controller),
        const SizedBox(height: 20),
        _buildRotateButton(controller),
        Obx(
              () => controller.isProcessing.value
              ? _buildProcessingIndicator(controller)
              : const SizedBox.shrink(),
        ),
        Obx(
              () => controller.rotatedFile.value != null
              ? _buildResultCard(controller)
              : const SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _buildFileInfoCard(RotatePdfController controller) {
    return Obx(
          () => Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.picture_as_pdf, color: Colors.teal[700]),
                  const SizedBox(width: 8),
                  const Text(
                    "Selected File",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
              const Divider(height: 20),
              _buildInfoRow('File Name', controller.fileName),
              const SizedBox(height: 8),
              _buildInfoRow('File Size', controller.fileSize),
              const SizedBox(height: 8),
              _buildInfoRow('Total Pages', '${controller.totalPages} pages'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRotationOptionsCard(RotatePdfController controller) {
    return Obx(
          () => Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.settings, color: Colors.teal[700]),
                  const SizedBox(width: 8),
                  const Text(
                    "Rotation Options",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
              const Divider(height: 20),
              const Text(
                'Rotation Angle',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildAngleButton(controller, 90, Icons.rotate_90_degrees_ccw, '90° Right'),
                  _buildAngleButton(controller, 180, Icons.rotate_left, '180°'),
                  _buildAngleButton(controller, 270, Icons.rotate_90_degrees_cw, '270° Left'),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Apply To',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
              const SizedBox(height: 12),
              RadioListTile<RotateMode>(
                title: const Text('All Pages'),
                subtitle: const Text('Rotate all pages in the PDF'),
                value: RotateMode.all,
                groupValue: controller.rotateMode.value,
                onChanged: controller.isProcessing.value
                    ? null
                    : (value) => controller.setRotateMode(value!),
                activeColor: Colors.teal,
              ),
              RadioListTile<RotateMode>(
                title: const Text('Specific Pages'),
                subtitle: const Text('Enter page numbers (e.g., 1-3, 5, 7-9)'),
                value: RotateMode.specific,
                groupValue: controller.rotateMode.value,
                onChanged: controller.isProcessing.value
                    ? null
                    : (value) => controller.setRotateMode(value!),
                activeColor: Colors.teal,
              ),
              if (controller.rotateMode.value == RotateMode.specific)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    controller: controller.pageRangeController,
                    decoration: InputDecoration(
                      hintText: 'e.g., 1-3, 5, 7-9',
                      border: const OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.teal.shade200),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.teal.shade700),
                      ),
                    ),
                    enabled: !controller.isProcessing.value,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAngleButton(
      RotatePdfController controller, int angle, IconData icon, String label) {
    return Obx(
          () => GestureDetector(
        onTap: controller.isProcessing.value
            ? null
            : () => controller.setRotationAngle(angle),
        child: Container(
          width: 100,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: controller.rotationAngle.value == angle
                ? Colors.teal
                : Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: controller.rotationAngle.value == angle
                  ? Colors.teal
                  : Colors.grey[400]!,
              width: 2,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                size: 36,
                color: controller.rotationAngle.value == angle
                    ? Colors.white
                    : Colors.grey[700],
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: controller.rotationAngle.value == angle
                      ? Colors.white
                      : Colors.grey[700],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRotateButton(RotatePdfController controller) {
    return Obx(
          () => ElevatedButton.icon(
        onPressed: controller.isProcessing.value || !controller.hasSelectedFile
            ? null
            : controller.rotatePdf,
        icon: controller.isProcessing.value
            ? const SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Colors.white,
          ),
        )
            : const Icon(Icons.rotate_right, size: 24),
        label: Text(
          controller.isProcessing.value ? 'Rotating...' : 'Rotate PDF',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
        ),
      ),
    );
  }

  Widget _buildProcessingIndicator(RotatePdfController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Obx(
            () => Center(
          child: Column(
            children: [
              const CircularProgressIndicator(color: Colors.teal),
              const SizedBox(height: 16),
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
                'Rotating PDF pages...',
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultCard(RotatePdfController controller) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Obx(
            () => Card(
          elevation: 4,
          color: Colors.teal[50],
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.teal[700], size: 28),
                    const SizedBox(width: 12),
                    const Text(
                      "PDF Rotated Successfully!",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.teal,
                      ),
                    ),
                  ],
                ),
                const Divider(height: 24),
                _buildInfoRow('Pages Rotated',
                    '${controller.pagesRotated} page${controller.pagesRotated > 1 ? 's' : ''}'),
                const SizedBox(height: 8),
                _buildInfoRow('Rotation Angle',
                    '${controller.rotationAngle.value}°'),
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
                        controller.rotatedFile.value?.path ?? '',
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
          width: 130,
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