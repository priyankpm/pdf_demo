import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdf_demo/view/resize-pdf/resize_pdf_controller.dart';

class ResizePdf extends StatefulWidget {
  const ResizePdf({super.key});

  @override
  State<ResizePdf> createState() => _ResizePdfState();
}

class _ResizePdfState extends State<ResizePdf> {
  final controller = Get.put(ResizePdfController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('PDF Resizer'),
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
            const Icon(Icons.photo_size_select_large, size: 48, color: Colors.teal),
            const SizedBox(height: 12),
            const Text(
              'PDF Resizer',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Convert PDF pages to different paper sizes',
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectButton(ResizePdfController controller) {
    return Obx(
          () => ElevatedButton.icon(
        onPressed: controller.isProcessing.value
            ? null
            : controller.pickPdfFile,
        icon: const Icon(Icons.upload_file),
        label: Text(
          controller.hasSelectedFile
              ? 'Change PDF File'
              : 'Select PDF File',
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

  Widget _buildSelectedFileSection(ResizePdfController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildFileInfoCard(controller),
        const SizedBox(height: 20),
        _buildPageSizeOptionsCard(controller),
        const SizedBox(height: 20),
        _buildScalingOptionsCard(controller),
        const SizedBox(height: 20),
        _buildResizeButton(controller),
        Obx(
              () => controller.isProcessing.value
              ? _buildProcessingIndicator(controller)
              : const SizedBox.shrink(),
        ),
        Obx(
              () => controller.hasResizedFile
              ? _buildResultCard(controller)
              : const SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _buildFileInfoCard(ResizePdfController controller) {
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
              const SizedBox(height: 8),
              _buildInfoRow('Current Size', controller.currentPageSize.value),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPageSizeOptionsCard(ResizePdfController controller) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.aspect_ratio, color: Colors.teal[700]),
                const SizedBox(width: 8),
                const Text(
                  "Target Page Size",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
            const Divider(height: 20),
            Text(
              'Select the desired output paper size',
              style: TextStyle(color: Colors.grey[600], fontSize: 13),
            ),
            const SizedBox(height: 16),
            _buildPageSizeGrid(controller),
          ],
        ),
      ),
    );
  }

  Widget _buildPageSizeGrid(ResizePdfController controller) {
    final sizes = [
      {'name': 'A0', 'desc': '841 × 1189 mm'},
      {'name': 'A1', 'desc': '594 × 841 mm'},
      {'name': 'A2', 'desc': '420 × 594 mm'},
      {'name': 'A3', 'desc': '297 × 420 mm'},
      {'name': 'A4', 'desc': '210 × 297 mm'},
      {'name': 'A5', 'desc': '148 × 210 mm'},
      {'name': 'Legal', 'desc': '8.5 × 14 in'},
      {'name': 'Letter', 'desc': '8.5 × 11 in'},
    ];

    return Obx(
          () => Wrap(
        spacing: 8,
        runSpacing: 8,
        children: sizes.map((size) {
          final isSelected = controller.targetPageSize.value == size['name'];
          return InkWell(
            onTap: controller.isProcessing.value
                ? null
                : () => controller.setTargetPageSize(size['name']!),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? Colors.teal : Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isSelected ? Colors.teal : Colors.grey.shade300,
                  width: 2,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    size['name']!,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: isSelected ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    size['desc']!,
                    style: TextStyle(
                      fontSize: 10,
                      color: isSelected ? Colors.white70 : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildScalingOptionsCard(ResizePdfController controller) {
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
                    "Scaling Options",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
              const Divider(height: 20),
              RadioListTile<ScalingMode>(
                title: const Text('Fit to Page'),
                subtitle: const Text('Scale content to fit new size'),
                value: ScalingMode.fit,
                groupValue: controller.scalingMode.value,
                onChanged: controller.isProcessing.value
                    ? null
                    : (value) => controller.setScalingMode(value!),
                activeColor: Colors.teal,
                dense: true,
                contentPadding: EdgeInsets.zero,
              ),
              RadioListTile<ScalingMode>(
                title: const Text('Fill Page'),
                subtitle: const Text('Scale to fill entire page (may crop)'),
                value: ScalingMode.fill,
                groupValue: controller.scalingMode.value,
                onChanged: controller.isProcessing.value
                    ? null
                    : (value) => controller.setScalingMode(value!),
                activeColor: Colors.teal,
                dense: true,
                contentPadding: EdgeInsets.zero,
              ),
              RadioListTile<ScalingMode>(
                title: const Text('Center without Scaling'),
                subtitle: const Text('Keep original size, center on new page'),
                value: ScalingMode.center,
                groupValue: controller.scalingMode.value,
                onChanged: controller.isProcessing.value
                    ? null
                    : (value) => controller.setScalingMode(value!),
                activeColor: Colors.teal,
                dense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResizeButton(ResizePdfController controller) {
    return Obx(
          () => ElevatedButton.icon(
        onPressed: controller.isProcessing.value || !controller.hasSelectedFile
            ? null
            : controller.resizePdf,
        icon: controller.isProcessing.value
            ? const SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Colors.white,
          ),
        )
            : const Icon(Icons.photo_size_select_large, size: 24),
        label: Text(
          controller.isProcessing.value
              ? 'Resizing...'
              : 'Resize PDF',
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

  Widget _buildProcessingIndicator(ResizePdfController controller) {
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
                'Resizing PDF pages...',
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultCard(ResizePdfController controller) {
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
                      "PDF Resized Successfully!",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.teal,
                      ),
                    ),
                  ],
                ),
                const Divider(height: 24),
                _buildInfoRow('Resized File', controller.resizedFileName),
                const SizedBox(height: 8),
                _buildInfoRow('File Size', controller.resizedFileSize),
                const SizedBox(height: 8),
                _buildInfoRow('Total Pages', '${controller.totalPages} pages'),
                const SizedBox(height: 8),
                _buildInfoRow('New Page Size', controller.targetPageSize.value),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.teal[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.photo_size_select_large, color: Colors.teal[900]),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "Converted from ${controller.currentPageSize} to ${controller.targetPageSize.value}",
                          style: TextStyle(
                            color: Colors.teal[900],
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
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
                        controller.resizedFilePath,
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
          width: 110,
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