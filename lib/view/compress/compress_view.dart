import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'compress_controller.dart';

class CompressorView extends StatelessWidget {
  const CompressorView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CompressorController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Superb PDF Compressor'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Obx(() {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: controller.processing.value
                    ? null
                    : controller.pickPDF,
                icon: const Icon(Icons.folder_open),
                label: const Text('Select PDF File'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
              const SizedBox(height: 20),
              if (controller.selectedFile != null) _buildFileInfo(controller),
              if (controller.processing.value)
                _buildProcessingStatus(controller),
              if (controller.compressedFile != null) _buildResult(controller),
              if (controller.selectedFile == null &&
                  !controller.processing.value)
                _buildEmptyState(),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildHeader() => Card(
    elevation: 2,
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Icon(Icons.compress, size: 48, color: Colors.blue),
          const SizedBox(height: 12),
          const Text(
            'PDF Compressor',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Reduce PDF file size with quality control',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    ),
  );

  Widget _buildFileInfo(CompressorController c) => Column(
    children: [
      Card(
        elevation: 2,
        color: Colors.blue[50],
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(Icons.picture_as_pdf, color: Colors.blue[700]),
                  const SizedBox(width: 8),
                  const Text(
                    'Selected File',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const Divider(),
              Text('File: ${c.selectedFile!.path.split('/').last}'),
              Text('Size: ${c.formatSize(c.originalSize!)}'),
            ],
          ),
        ),
      ),
      const SizedBox(height: 20),
      _buildQualitySelector(c),
      const SizedBox(height: 20),
      ElevatedButton.icon(
        onPressed: c.processing.value ? null : c.compressPdf,
        icon: c.processing.value
            ? const CircularProgressIndicator(color: Colors.white)
            : const Icon(Icons.compress),
        label: Text(c.processing.value ? 'Compressing...' : 'Compress PDF'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    ],
  );

  Widget _buildQualitySelector(CompressorController c) => Card(
    child: Column(
      children: [
        RadioListTile<String>(
          title: const Text('Normal Quality'),
          subtitle: const Text('150 DPI, 85% quality'),
          value: 'Normal',
          groupValue: c.selectedQuality.value,
          onChanged: (v) => c.selectedQuality.value = v!,
        ),
        RadioListTile<String>(
          title: const Text('Medium Quality'),
          subtitle: const Text('120 DPI, 70% quality'),
          value: 'Medium',
          groupValue: c.selectedQuality.value,
          onChanged: (v) => c.selectedQuality.value = v!,
        ),
        RadioListTile<String>(
          title: const Text('Maximum Compression'),
          subtitle: const Text('100 DPI, 50% quality'),
          value: 'Best',
          groupValue: c.selectedQuality.value,
          onChanged: (v) => c.selectedQuality.value = v!,
        ),
      ],
    ),
  );

  Widget _buildProcessingStatus(CompressorController c) => Column(
    children: [
      const SizedBox(height: 30),
      const CircularProgressIndicator(),
      const SizedBox(height: 12),
      Text(c.processingStatus.value),
      const SizedBox(height: 8),
      const Text(
        'Please wait, this may take a while...',
        style: TextStyle(color: Colors.grey),
      ),
    ],
  );

  Widget _buildResult(CompressorController c) => Card(
    color: Colors.green[50],
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green[700]),
              const SizedBox(width: 8),
              const Text(
                'Compression Complete!',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ),
          const Divider(),
          Text('Saved: ${c.savedPercent().toStringAsFixed(1)}%'),
          const SizedBox(height: 8),
          Text('File: ${c.compressedFile!.path.split('/').last}'),
          Text('Size: ${c.formatSize(c.compressedSize!)}'),
        ],
      ),
    ),
  );

  Widget _buildEmptyState() => Column(
    children: [
      Icon(Icons.upload_file, size: 80, color: Colors.grey[300]),
      const SizedBox(height: 12),
      Text('No PDF selected', style: TextStyle(color: Colors.grey[600])),
      const Text(
        'Click "Select PDF File" to begin',
        style: TextStyle(color: Colors.grey),
      ),
    ],
  );
}
