import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdf_demo/view/extracttext-pdf/extract_text_controller.dart';

class ExtractText extends StatefulWidget {
  const ExtractText({super.key});

  @override
  State<ExtractText> createState() => _ExtractTextState();
}

class _ExtractTextState extends State<ExtractText>
    with SingleTickerProviderStateMixin {
  final controller = Get.put(ExtractTextPdfController());
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          _buildPremiumHeader(),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  _buildSelectButton(),
                  const SizedBox(height: 20),
                  Obx(
                        () => controller.hasSelectedFile
                        ? _buildContentSection()
                        : _buildEmptyState(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Premium Header
  Widget _buildPremiumHeader() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.teal.shade300, Colors.teal.shade600],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.teal.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Get.back(),
                    ),
                  ),
                  const Spacer(),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30, bottom: 20),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.25),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.3),
                            width: 2,
                          ),
                        ),
                        child: const Icon(
                          Icons.text_fields,
                          color: Colors.white,
                          size: 36,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Extract Text',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Get text from PDF',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.white.withValues(alpha: 0.9),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Select Button
  Widget _buildSelectButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Obx(
            () => Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          elevation: 4,
          shadowColor: Colors.black.withValues(alpha: 0.1),
          child: InkWell(
            onTap: controller.isProcessing.value
                ? null
                : controller.pickPdfFile,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.teal.withValues(alpha: 0.3),
                  width: 2,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.teal.shade300, Colors.teal.shade600],
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      controller.hasSelectedFile
                          ? Icons.sync_rounded
                          : Icons.upload_file_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Text(
                    controller.hasSelectedFile
                        ? 'Change PDF File'
                        : 'Select PDF File',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal.shade700,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Content Section
  Widget _buildContentSection() {
    return FadeTransition(
      opacity: _animationController,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            _buildFileInfoCard(),
            const SizedBox(height: 20),
            Obx(() {
              if (controller.isProcessing.value) {
                return _buildProcessingIndicator();
              } else if (controller.hasExtractedText) {
                return _buildExtractedTextSection();
              }
              return _buildExtractButton();
            }),
            const SizedBox(height: 20),
            Obx(
                  () => controller.isExtractionComplete.value
                  ? _buildResetButton()
                  : const SizedBox.shrink(),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // File Info Card
  Widget _buildFileInfoCard() {
    return Obx(
          () => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.teal.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.picture_as_pdf_rounded,
                    color: Colors.teal.shade700,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Selected File',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoRow(
              Icons.description_rounded,
              'File Name',
              controller.selectedFileName,
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
              Icons.storage_rounded,
              'File Size',
              controller.formattedOriginalSize,
            ),
            if (controller.totalPages.value > 0) ...[
              const SizedBox(height: 12),
              _buildInfoRow(
                Icons.article_rounded,
                'Total Pages',
                controller.totalPages.toString(),
              ),
            ],
            if (controller.hasExtractedText) ...[
              const SizedBox(height: 12),
              _buildInfoRow(
                Icons.text_snippet_rounded,
                'Characters',
                controller.totalCharacters.toString(),
              ),
              const SizedBox(height: 12),
              _buildInfoRow(
                Icons.format_quote_rounded,
                'Words',
                controller.totalWords.toString(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[700]),
          const SizedBox(width: 12),
          Text(
            '$label: ',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  // Extract Button
  Widget _buildExtractButton() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Material(
        color: Colors.teal.shade600,
        borderRadius: BorderRadius.circular(16),
        elevation: 4,
        shadowColor: Colors.teal.withValues(alpha: 0.3),
        child: InkWell(
          onTap: controller.extractText,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 18),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.text_snippet_rounded,
                  color: Colors.white,
                  size: 26,
                ),
                SizedBox(width: 12),
                Text(
                  'Extract Text',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Processing Indicator
  Widget _buildProcessingIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Container(width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Obx(
              () => Column(
            children: [
              const CircularProgressIndicator(color: Colors.teal),
              const SizedBox(height: 16),
              Text(
                controller.processingStatus.value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Please wait, extracting text...',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Extracted Text Section
  Widget _buildExtractedTextSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
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
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.teal.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IconButton(
                      onPressed: controller.copyToClipboard,
                      icon: const Icon(Icons.copy_rounded, size: 20),
                      tooltip: 'Copy to Clipboard',
                      color: Colors.teal.shade700,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.teal.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IconButton(
                      onPressed: controller.saveAsTextFile,
                      icon: const Icon(Icons.download_rounded, size: 20),
                      tooltip: 'Save as Text File',
                      color: Colors.teal.shade700,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            height: 400,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.teal.withValues(alpha: 0.2),
                width: 1.5,
              ),
            ),
            child: Obx(
                  () => SingleChildScrollView(
                child: SelectableText(
                  controller.extractedText.value,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.6,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Reset Button
  Widget _buildResetButton() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Material(
        color: Colors.teal.shade600,
        borderRadius: BorderRadius.circular(16),
        elevation: 4,
        shadowColor: Colors.teal.withValues(alpha: 0.3),
        child: InkWell(
          onTap: controller.resetForNewFile,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 18),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.refresh, color: Colors.white, size: 26),
                SizedBox(width: 12),
                Text(
                  'Extract from Another PDF',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Empty State
  Widget _buildEmptyState() {
    return FadeTransition(
      opacity: _animationController,
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.upload_file_rounded,
                size: 80,
                color: Colors.grey[400],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No PDF Selected',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Select a PDF file to extract text',
              style: TextStyle(fontSize: 15, color: Colors.grey[500]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}