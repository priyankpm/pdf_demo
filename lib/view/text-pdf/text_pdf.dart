import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:pdf_demo/view/text-pdf/text_pdf_controller.dart';

class TextToPdf extends StatefulWidget {
  const TextToPdf({super.key});

  @override
  State<TextToPdf> createState() => _TextToPdfState();
}

class _TextToPdfState extends State<TextToPdf> with SingleTickerProviderStateMixin {
  final controller = Get.put(TextToPdfController());
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
          // Premium Header
          _buildPremiumHeader(),

          // Content
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  // Content Section
                  FadeTransition(
                    opacity: _animationController,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          // PDF Name Input Card
                          _buildPdfNameCard(),

                          const SizedBox(height: 20),

                          // Editor Card
                          _buildEditorCard(),

                          const SizedBox(height: 20),

                          // Generate Button
                          _buildGenerateButton(),

                          // Result Card
                          Obx(
                                () => controller.hasGeneratedFile
                                ? Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: _buildResultCard(),
                            )
                                : const SizedBox(),
                          ),

                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Premium Header with Gradient
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
              // App Bar
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

              // Title Section
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
                          Icons.text_fields_rounded,
                          color: Colors.white,
                          size: 36,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Text to PDF',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Create formatted PDFs',
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

  // PDF Name Card
  Widget _buildPdfNameCard() {
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
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.teal.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.drive_file_rename_outline_rounded,
                  color: Colors.teal.shade700,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'PDF Name',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Obx(
                () => Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                enabled: !controller.isProcessing.value,
                controller: controller.pdfNameController,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
                decoration: InputDecoration(
                  hintText: 'Enter PDF name (optional)',
                  hintStyle: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 15,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Editor Card
  Widget _buildEditorCard() {
    return Container(
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
          // Header
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.teal.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.edit_document,
                    color: Colors.teal.shade700,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Content Editor',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),

          // Divider
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Divider(height: 1, color: Colors.grey.shade200),
          ),

          // Toolbar
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: quill.QuillSimpleToolbar(
                controller: controller.quillController,
                config: quill.QuillSimpleToolbarConfig(
                  showAlignmentButtons: true,
                  showBackgroundColorButton: true,
                  showBoldButton: true,
                  showItalicButton: true,
                  showUnderLineButton: true,
                  showStrikeThrough: true,
                  showHeaderStyle: false,
                  showColorButton: false,
                  showFontSize: true,
                  showListBullets: true,
                  showListNumbers: true,
                  showListCheck: true,
                  showIndent: false,
                  showClearFormat: false,
                  showUndo: true,
                  showRedo: true,
                  showQuote: false,
                  showDividers: true,
                  showJustifyAlignment: true,
                  showLeftAlignment: true,
                  showCenterAlignment: true,
                  showRightAlignment: true,
                  showCodeBlock: false,
                  showDirection: false,
                  showFontFamily: false,
                  showInlineCode: false,
                  showLink: false,
                  showSearchButton: false,
                  showSmallButton: false,
                  showSubscript: false,
                  showSuperscript: false,
                  buttonOptions: quill.QuillSimpleToolbarButtonOptions(
                    base: quill.QuillToolbarBaseButtonOptions(
                      iconTheme: quill.QuillIconTheme(
                        iconButtonSelectedData: quill.IconButtonData(
                          color: Colors.teal.shade700,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Editor
          Container(
            height: 350,
            padding: const EdgeInsets.all(20),
            child: quill.QuillEditor.basic(
              controller: controller.quillController,
              config: const quill.QuillEditorConfig(
                placeholder: 'Start typing your content here...',
                autoFocus: false,
                expands: false,
                scrollable: true,
                padding: EdgeInsets.all(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Generate Button
  Widget _buildGenerateButton() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Obx(
            () => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (controller.isProcessing.value)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Column(
                  children: const [
                    Text(
                      'Generating PDF...',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Please wait while we create your PDF',
                      style: TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                  ],
                ),
              ),

            Material(
              color: controller.isProcessing.value
                  ? Colors.grey.shade300
                  : Colors.teal.shade600,
              borderRadius: BorderRadius.circular(16),
              elevation: controller.isProcessing.value ? 0 : 4,
              shadowColor: Colors.teal.withValues(alpha: 0.3),
              child: InkWell(
                onTap: controller.isProcessing.value
                    ? null
                    : controller.generatePdfFromText,
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (controller.isProcessing.value)
                        const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      else
                        const Icon(
                          Icons.picture_as_pdf_rounded,
                          color: Colors.white,
                          size: 26,
                        ),
                      const SizedBox(width: 12),
                      Text(
                        controller.isProcessing.value
                            ? 'Generating...'
                            : 'Generate PDF',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: controller.isProcessing.value
                              ? Colors.grey.shade600
                              : Colors.white,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Result Card
  Widget _buildResultCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.teal.shade50, Colors.teal.shade50],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.teal.shade200, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.teal.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Success Icon
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.teal.withValues(alpha: 0.2),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Icon(
              Icons.check_circle_rounded,
              color: Colors.teal.shade600,
              size: 48,
            ),
          ),

          const SizedBox(height: 16),

          const Text(
            'PDF Generated!',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),

          const SizedBox(height: 20),

          // Info Cards
          _buildResultInfoCard(
            Icons.description_rounded,
            'File Name',
            controller.generatedFileName,
          ),
          const SizedBox(height: 10),
          _buildResultInfoCard(
            Icons.folder_rounded,
            'Saved Location',
            controller.generatedFilePath,
          ),
        ],
      ),
    );
  }

  Widget _buildResultInfoCard(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
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
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}