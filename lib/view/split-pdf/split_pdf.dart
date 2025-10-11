import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdf_demo/view/split-pdf/split_pdf_controller.dart';

class SplitPdf extends StatefulWidget {
  const SplitPdf({super.key});

  @override
  State<SplitPdf> createState() => _SplitPdfState();
}

class _SplitPdfState extends State<SplitPdf> {
  final controller = Get.put(SplitPdfController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('PDF Splitter'),
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
            const Icon(Icons.call_split, size: 48, color: Colors.teal),
            const SizedBox(height: 12),
            const Text(
              'PDF Splitter',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Extract specific pages or split PDF into separate files',
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectButton(SplitPdfController controller) {
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

  Widget _buildSelectedFileSection(SplitPdfController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildFileInfoCard(controller),
        const SizedBox(height: 20),
        _buildSplitOptionsCard(controller),
        const SizedBox(height: 20),
        _buildSplitButton(controller),
        Obx(
              () => controller.isProcessing.value
              ? _buildProcessingIndicator(controller)
              : const SizedBox.shrink(),
        ),
        Obx(
              () => controller.hasSplitFiles
              ? _buildResultCard(controller)
              : const SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _buildFileInfoCard(SplitPdfController controller) {
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

  Widget _buildSplitOptionsCard(SplitPdfController controller) {
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
                    "Split Options",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
              const Divider(height: 20),
              RadioListTile<SplitMode>(
                title: const Text('Extract Specific Pages'),
                subtitle: const Text('Enter page ranges (e.g., 1-3, 5, 7-9)'),
                value: SplitMode.specific,
                groupValue: controller.splitMode.value,
                onChanged: controller.isProcessing.value
                    ? null
                    : (value) => controller.setSplitMode(value!),
                activeColor: Colors.teal,
              ),
              if (controller.splitMode.value == SplitMode.specific)
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
              RadioListTile<SplitMode>(
                title: const Text('Split Every N Pages'),
                subtitle: const Text('Divide into equal-sized chunks'),
                value: SplitMode.everyN,
                groupValue: controller.splitMode.value,
                onChanged: controller.isProcessing.value
                    ? null
                    : (value) => controller.setSplitMode(value!),
                activeColor: Colors.teal,
              ),
              if (controller.splitMode.value == SplitMode.everyN)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      const Text('Split every'),
                      const SizedBox(width: 12),
                      SizedBox(
                        width: 80,
                        child: TextField(
                          controller: controller.splitEveryController,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                              BorderSide(color: Colors.teal.shade200),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                              BorderSide(color: Colors.teal.shade700),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          enabled: !controller.isProcessing.value,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text('pages'),
                    ],
                  ),
                ),
              RadioListTile<SplitMode>(
                title: const Text('Split into Individual Pages'),
                subtitle: const Text('Each page becomes a separate PDF'),
                value: SplitMode.individual,
                groupValue: controller.splitMode.value,
                onChanged: controller.isProcessing.value
                    ? null
                    : (value) => controller.setSplitMode(value!),
                activeColor: Colors.teal,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSplitButton(SplitPdfController controller) {
    return Obx(
          () => ElevatedButton.icon(
        onPressed: controller.isProcessing.value || !controller.hasSelectedFile
            ? null
            : controller.splitPdf,
        icon: controller.isProcessing.value
            ? const SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Colors.white,
          ),
        )
            : const Icon(Icons.call_split, size: 24),
        label: Text(
          controller.isProcessing.value
              ? 'Splitting...'
              : 'Split PDF',
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

  Widget _buildProcessingIndicator(SplitPdfController controller) {
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
                'Splitting PDF file...',
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultCard(SplitPdfController controller) {
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
                      "PDF Split Successfully!",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.teal,
                      ),
                    ),
                  ],
                ),
                const Divider(height: 24),
                _buildInfoRow('Files Created',
                    '${controller.splitFiles.length} PDF files'),
                const SizedBox(height: 8),
                _buildInfoRow('Total Pages Split',
                    '${controller.totalPagesSplit} pages'),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.teal[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.call_split, color: Colors.teal[900]),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "Split into ${controller.splitFiles.length} separate PDF files",
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
                        controller.outputDirectory,
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