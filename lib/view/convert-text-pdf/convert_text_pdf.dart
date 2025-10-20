import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdf_demo/view/convert-text-pdf/convert_text_pdf_controller.dart';

class ConvertTextPdf extends StatefulWidget {
  const ConvertTextPdf({super.key});

  @override
  State<ConvertTextPdf> createState() => _ConvertTextPdfState();
}

class _ConvertTextPdfState extends State<ConvertTextPdf> {
  final controller = Get.put(ConvertTextPdfController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('.txt Converter'),
        backgroundColor: Colors.purple,
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
              _buildConversionModeCard(),
              const SizedBox(height: 20),
              Obx(
                    () => controller.conversionMode.value == ConversionMode.textToPdf
                    ? _buildToPdfSection()
                    : _buildFromPdfSection(),
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
            const Icon(Icons.sync_alt, size: 48, color: Colors.purple),
            const SizedBox(height: 12),
            const Text(
              'Smart Converter',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Convert TXT ↔ PDF seamlessly',
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConversionModeCard() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.compare_arrows, color: Colors.purple[700]),
                const SizedBox(width: 8),
                const Text(
                  "Conversion Mode",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
            const Divider(height: 20),
            Obx(
                  () => Row(
                children: [
                  Expanded(
                    child: _buildModeButton(
                      'TXT → PDF',
                      Icons.description,
                      ConversionMode.textToPdf,
                      controller.conversionMode.value == ConversionMode.textToPdf,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildModeButton(
                      'PDF → TXT',
                      Icons.picture_as_pdf,
                      ConversionMode.pdfToText,
                      controller.conversionMode.value == ConversionMode.pdfToText,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModeButton(
      String label,
      IconData icon,
      ConversionMode mode,
      bool isSelected,
      ) {
    return ElevatedButton.icon(
      onPressed: controller.isProcessing.value
          ? null
          : () => controller.setConversionMode(mode),
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 14),
        backgroundColor: isSelected ? Colors.purple : Colors.grey[300],
        foregroundColor: isSelected ? Colors.white : Colors.black87,
      ),
    );
  }

  Widget _buildToPdfSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildSelectFileButton(),
        const SizedBox(height: 20),
        Obx(
              () => controller.hasSelectedFile
              ? _buildSelectedFileCard()
              : _buildEmptyState('Select a file to convert to PDF'),
        ),
      ],
    );
  }

  Widget _buildFromPdfSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildSelectFileButton(),
        const SizedBox(height: 20),
        Obx(
              () => controller.hasSelectedFile
              ? _buildSelectedFileCard()
              : _buildEmptyState('Select a PDF file to convert'),
        ),
      ],
    );
  }

  Widget _buildSelectFileButton() {
    return Obx(
          () => ElevatedButton.icon(
        onPressed: controller.isProcessing.value ? null : controller.pickFile,
        icon: const Icon(Icons.upload_file),
        label: Text(
          controller.hasSelectedFile ? 'Change File' : 'Select File',
        ),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          backgroundColor: Colors.purple,
          foregroundColor: Colors.white,
          textStyle: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildSelectedFileCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildFileInfoCard(),
        const SizedBox(height: 20),
        _buildConvertButton(),
        Obx(
              () => controller.isProcessing.value
              ? _buildProcessingIndicator()
              : const SizedBox.shrink(),
        ),
        Obx(
              () => controller.hasConvertedFile
              ? _buildResultCard()
              : const SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _buildFileInfoCard() {
    return Obx(
          () => Card(
        elevation: 2,
        color: Colors.purple[50],
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    controller.fileExtension.toLowerCase() == '.pdf'
                        ? Icons.picture_as_pdf
                        : Icons.description,
                    color: Colors.purple[700],
                    size: 24,
                  ),
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
              _buildInfoRow(
                'Current Format',
                controller.fileExtension.toUpperCase().replaceAll('.', ''),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.purple[100],
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: [
                    Icon(Icons.arrow_forward,
                        color: Colors.purple[700], size: 18),
                    const SizedBox(width: 8),
                    Text(
                      'Convert To: ',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        color: Colors.purple[900],
                      ),
                    ),
                    Text(
                      controller.conversionMode.value == ConversionMode.textToPdf
                          ? 'PDF'
                          : 'TXT',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.purple[900],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConvertButton() {
    return Obx(
          () => ElevatedButton.icon(
        onPressed: controller.isProcessing.value || !controller.hasSelectedFile
            ? null
            : controller.convertFile,
        icon: controller.isProcessing.value
            ? const SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Colors.white,
          ),
        )
            : const Icon(Icons.sync_alt, size: 24),
        label: Text(
          controller.isProcessing.value
              ? 'Converting...'
              : controller.conversionMode.value == ConversionMode.textToPdf
              ? 'Convert to PDF'
              : 'Convert to TXT',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          backgroundColor: Colors.purple,
          foregroundColor: Colors.white,
        ),
      ),
    );
  }

  Widget _buildProcessingIndicator() {
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
                'Please wait...',
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultCard() {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Obx(
            () => Card(
          elevation: 4,
          color: Colors.green[50],
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green[700], size: 28),
                    const SizedBox(width: 12),
                    const Text(
                      "Conversion Successful!",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
                const Divider(height: 24),
                _buildInfoRow('Output File', controller.convertedFileName),
                const SizedBox(height: 8),
                _buildInfoRow('File Size', controller.convertedFileSize),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.purple[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle_outline,
                          color: Colors.purple[900]),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "Converted from ${controller.fileExtension} to ${controller.conversionMode.value == ConversionMode.textToPdf ? 'PDF' : 'TXT'}",
                          style: TextStyle(
                            color: Colors.purple[900],
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
                        controller.convertedFilePath,
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

  Widget _buildEmptyState(String message) {
    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.file_upload_outlined, size: 80, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(
              'No file selected',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
              textAlign: TextAlign.center,
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
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 14),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}