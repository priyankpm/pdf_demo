import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdf_demo/view/extracttext-pdf/extract_text_controller.dart';


class ExtractText extends StatefulWidget {
  const ExtractText({super.key});

  @override
  State<ExtractText> createState() => _ExtractTextState();
}

class _ExtractTextState extends State<ExtractText> {
  final controller = Get.put(ExtractTextPdfController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Extract Text from PDF'),
        backgroundColor: Colors.blue,
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
            const Icon(Icons.text_fields, size: 48, color: Colors.blue),
            const SizedBox(height: 12),
            const Text(
              'PDF Text Extraction',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Extract all text content from your PDF file',
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectButton(ExtractTextPdfController controller) {
    return Obx(
          () => ElevatedButton.icon(
        onPressed: controller.isProcessing.value
            ? null
            : controller.pickPdfFile,
        icon: const Icon(Icons.folder_open),
        label: const Text('Select PDF File'),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          textStyle: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildSelectedFileSection(ExtractTextPdfController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildFileInfoCard(controller),
        const SizedBox(height: 20),
        Obx(() {
          if (controller.isProcessing.value) {
            return _buildProcessingIndicator(controller);
          } else if (controller.hasExtractedText) {
            return _buildExtractedTextSection(controller);
          }
          return _buildExtractButton(controller);
        }),
        const SizedBox(height: 20),
        Obx(
              () => controller.isExtractionComplete.value
              ? _buildResetButton(controller)
              : const SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _buildFileInfoCard(ExtractTextPdfController controller) {
    return Obx(
          () => Card(
        elevation: 2,
        color: Colors.blue[50],
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.picture_as_pdf, color: Colors.blue[700]),
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
              _buildInfoRow('File Size', controller.formattedOriginalSize),
              if (controller.totalPages.value > 0) ...[
                const SizedBox(height: 8),
                _buildInfoRow('Total Pages', controller.totalPages.toString()),
              ],
              if (controller.hasExtractedText) ...[
                const SizedBox(height: 8),
                _buildInfoRow('Total Characters', controller.totalCharacters.toString()),
                const SizedBox(height: 8),
                _buildInfoRow('Total Words', controller.totalWords.toString()),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExtractButton(ExtractTextPdfController controller) {
    return ElevatedButton.icon(
      onPressed: controller.extractText,
      icon: const Icon(Icons.text_snippet, size: 24),
      label: const Text(
        'Extract Text',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget _buildProcessingIndicator(ExtractTextPdfController controller) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          children: [
            const CircularProgressIndicator(color: Colors.blue),
            const SizedBox(height: 20),
            Obx(
                  () => Text(
                controller.processingStatus.value,
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Please wait...',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExtractedTextSection(ExtractTextPdfController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Extracted Text',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: controller.copyToClipboard,
                          icon: const Icon(Icons.copy, size: 20),
                          tooltip: 'Copy to Clipboard',
                          color: Colors.blue,
                        ),
                        IconButton(
                          onPressed: controller.saveAsTextFile,
                          icon: const Icon(Icons.download, size: 20),
                          tooltip: 'Save as Text File',
                          color: Colors.blue,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  height: 400,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Obx(
                        () => SingleChildScrollView(
                      child: SelectableText(
                        controller.extractedText.value,
                        style: const TextStyle(
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildResetButton(ExtractTextPdfController controller) {
    return ElevatedButton.icon(
      onPressed: controller.resetForNewFile,
      icon: const Icon(Icons.refresh, size: 24),
      label: const Text(
        'Extract from Another PDF',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
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
          width: 140,
          child: Text(
            '$label:',
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
        ),
        Expanded(
          child: Text(value, style: const TextStyle(fontSize: 14)),
        ),
      ],
    );
  }
}