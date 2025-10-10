import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:pdf_demo/view/text-pdf/text_pdf_controller.dart';

class TextToPdf extends StatefulWidget {
  const TextToPdf({super.key});

  @override
  State<TextToPdf> createState() => _TextToPdfState();
}

class _TextToPdfState extends State<TextToPdf> {
  final controller = Get.put(TextToPdfController());

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Text to PDF'),
        centerTitle: true,
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeaderCard(),
              const SizedBox(height: 12),
              _buildPdfNameInput(),
              const SizedBox(height: 12),
              _buildQuillEditor(),
              const SizedBox(height: 16),
              _buildGenerateButton(),
              Obx(
                () => controller.hasGeneratedFile
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: _buildResultCard(),
                      )
                    : const SizedBox(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Icon(Icons.picture_as_pdf, size: 48, color: Colors.teal),
            const SizedBox(height: 12),
            const Text(
              'Text to PDF',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Create formatted PDFs easily',
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPdfNameInput() {
    return Obx(
      () => Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: TextField(
            enabled: !controller.isProcessing.value,
            controller: controller.pdfNameController,
            decoration: const InputDecoration(
              hintText: 'Enter PDF name (optional)',
              border: InputBorder.none,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuillEditor() {
    return Card(
      elevation: 2,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              color: Colors.teal.withValues(alpha: 0.15),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: quill.QuillSimpleToolbar(
                controller: controller.quillController,
                config: const quill.QuillSimpleToolbarConfig(
                  showAlignmentButtons: true,
                  showBackgroundColorButton: false,
                  showBoldButton: true,
                  showItalicButton: true,
                  showUnderLineButton: true,
                  showStrikeThrough: true,
                  showHeaderStyle: true,
                  showColorButton: false,
                  showFontSize: true,
                  showListBullets: true,
                  showListNumbers: true,
                  showListCheck: false,
                  showIndent: false,
                  showClearFormat: true,
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
                ),
              ),
            ),
          ),
          Container(
            height: 400,
            padding: const EdgeInsets.all(16),
            child: quill.QuillEditor.basic(
              controller: controller.quillController,
              config: const quill.QuillEditorConfig(
                placeholder: 'Start typing your content here...',
                autoFocus: false,
                expands: false,
                scrollable: true,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenerateButton() {
    return Obx(
      () => ElevatedButton.icon(
        onPressed: controller.isProcessing.value
            ? null
            : controller.generatePdfFromText,
        icon: controller.isProcessing.value
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : const Icon(Icons.picture_as_pdf),
        label: Text(
          controller.isProcessing.value ? 'Generating...' : 'Generate PDF',
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

  Widget _buildResultCard() {
    return Card(
      elevation: 3,
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
                  "PDF Generated!",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.teal,
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            _buildInfoRow('File Name', controller.generatedFileName),
            const SizedBox(height: 8),
            _buildInfoRow('File Path', controller.generatedFilePath),
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
          width: 120,
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
