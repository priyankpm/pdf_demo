import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdf_demo/view/split-pdf/split_pdf_controller.dart';

class SplitPdf extends StatefulWidget {
  const SplitPdf({super.key});

  @override
  State<SplitPdf> createState() => _SplitPdfState();
}

class _SplitPdfState extends State<SplitPdf> with SingleTickerProviderStateMixin {
  final controller = Get.put(SplitPdfController());
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
                  Obx(() => controller.hasSelectedFile
                      ? _buildContentSection()
                      : _buildEmptyState()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumHeader() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF4facfe), Color(0xFF00f2fe)],
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF4facfe).withValues(alpha: 0.3),
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
                  Obx(() => controller.hasSelectedFile
                      ? Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 1.5),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.auto_stories_rounded, color: Colors.white, size: 18),
                        const SizedBox(width: 6),
                        Text('${controller.totalPages} Pages',
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                      ],
                    ),
                  )
                      : const SizedBox.shrink()),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30, bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.25),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 2),
                      ),
                      child: const Icon(Icons.call_split_rounded, color: Colors.white, size: 36),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Split PDF',
                            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 0.5)),
                        const SizedBox(height: 4),
                        Text('Extract and separate pages',
                            style: TextStyle(fontSize: 15, color: Colors.white.withValues(alpha: 0.9), fontWeight: FontWeight.w500)),
                      ],
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

  Widget _buildSelectButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Obx(() => Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        elevation: 4,
        shadowColor: Colors.black.withValues(alpha: 0.1),
        child: InkWell(
          onTap: controller.isProcessing.value ? null : controller.pickPdfFile,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Color(0xFF4facfe).withValues(alpha: 0.3), width: 2),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [Color(0xFF4facfe), Color(0xFF00f2fe)]),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(controller.hasSelectedFile ? Icons.sync_rounded : Icons.upload_file_rounded,
                      color: Colors.white, size: 24),
                ),
                const SizedBox(width: 14),
                Text(controller.hasSelectedFile ? 'Change PDF File' : 'Select PDF File',
                    style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF4facfe), letterSpacing: 0.3)),
              ],
            ),
          ),
        ),
      )),
    );
  }

  Widget _buildContentSection() {
    return FadeTransition(
      opacity: _animationController,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            _buildCard(
              'Selected File',
              Icons.picture_as_pdf_rounded,
              Column(
                children: [
                  _buildInfoRow(Icons.description_rounded, 'File Name', controller.fileName),
                  const SizedBox(height: 12),
                  _buildInfoRow(Icons.storage_rounded, 'File Size', controller.fileSize),
                  const SizedBox(height: 12),
                  _buildInfoRow(Icons.auto_stories_rounded, 'Total Pages', '${controller.totalPages} pages'),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _buildSplitOptionsCard(),
            const SizedBox(height: 20),
            _buildSplitButton(),
            Obx(() => controller.hasSplitFiles ? _buildResultCard() : const SizedBox.shrink()),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(String title, IconData icon, Widget content) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: Color(0xFF4facfe).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
                child: Icon(icon, color: Color(0xFF4facfe), size: 20),
              ),
              const SizedBox(width: 12),
              Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)),
            ],
          ),
          const SizedBox(height: 16),
          content,
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[700]),
          const SizedBox(width: 12),
          Text('$label: ', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87)),
          Expanded(
            child: Text(value,
                style: TextStyle(fontSize: 14, color: Colors.grey[700], fontWeight: FontWeight.w500),
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }

  Widget _buildSplitOptionsCard() {
    return _buildCard(
      'Split Options',
      Icons.settings_rounded,
      Obx(() => Column(
        children: [
          _buildOption(SplitMode.specific, 'Extract Specific Pages', Icons.pageview_rounded),
          if (controller.splitMode.value == SplitMode.specific) ...[
            const SizedBox(height: 12),
            TextField(
              controller: controller.pageRangeController,
              decoration: InputDecoration(
                hintText: 'e.g., 1-3, 5, 7-9',
                filled: true,
                fillColor: Colors.grey.shade50,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200, width: 2)),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Color(0xFF4facfe), width: 2)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
              enabled: !controller.isProcessing.value,
            ),
          ],
          const SizedBox(height: 10),
          _buildOption(SplitMode.everyN, 'Split Every N Pages', Icons.splitscreen_rounded),
          if (controller.splitMode.value == SplitMode.everyN) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                const Text('Split every', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                const SizedBox(width: 12),
                SizedBox(
                  width: 80,
                  child: TextField(
                    controller: controller.splitEveryController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey.shade50,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200, width: 2)),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Color(0xFF4facfe), width: 2)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                    ),
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    enabled: !controller.isProcessing.value,
                  ),
                ),
                const SizedBox(width: 12),
                const Text('pages', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
              ],
            ),
          ],
          const SizedBox(height: 10),
          _buildOption(SplitMode.individual, 'Split into Individual Pages', Icons.layers_rounded),
        ],
      )),
    );
  }

  Widget _buildOption(SplitMode mode, String title, IconData icon) {
    final isSelected = controller.splitMode.value == mode;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: controller.isProcessing.value ? null : () => controller.setSplitMode(mode),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSelected ? Color(0xFF4facfe).withValues(alpha: 0.1) : Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isSelected ? Color(0xFF4facfe) : Colors.grey.shade200, width: 2),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: isSelected ? const LinearGradient(colors: [Color(0xFF4facfe), Color(0xFF00f2fe)]) : null,
                  color: isSelected ? null : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: isSelected ? Colors.white : Colors.grey.shade600, size: 24),
              ),
              const SizedBox(width: 14),
              Expanded(child: Text(title, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: isSelected ? Color(0xFF4facfe) : Colors.black87))),
              Icon(isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked, color: isSelected ? Color(0xFF4facfe) : Colors.grey.shade400),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSplitButton() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Obx(() => Column(
        children: [
          if (controller.isProcessing.value)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(controller.processingStatus.value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black87)),
            ),
          Material(
            color: const Color(0xFF4facfe),
            borderRadius: BorderRadius.circular(16),
            elevation: 4,
            shadowColor: Color(0xFF4facfe).withValues(alpha: 0.3),
            child: InkWell(
              onTap: controller.isProcessing.value || !controller.hasSelectedFile ? null : controller.splitPdf,
              borderRadius: BorderRadius.circular(16),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 18),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (controller.isProcessing.value)
                      const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Colors.white)))
                    else
                      const Icon(Icons.call_split_rounded, color: Colors.white, size: 26),
                    const SizedBox(width: 12),
                    Text(controller.isProcessing.value ? 'Splitting...' : 'Split PDF',
                        style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 0.3)),
                  ],
                ),
              ),
            ),
          ),
        ],
      )),
    );
  }

  Widget _buildResultCard() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20, top: 20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Colors.green.shade50, Colors.teal.shade50]),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.green.shade200, width: 2),
          boxShadow: [BoxShadow(color: Colors.green.withValues(alpha: 0.1), blurRadius: 20, offset: const Offset(0, 8))],
        ),
        child: Obx(() => Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: Colors.green.withValues(alpha: 0.2), blurRadius: 15, offset: const Offset(0, 5))],
              ),
              child: Icon(Icons.check_circle_rounded, color: Colors.green.shade600, size: 48),
            ),
            const SizedBox(height: 16),
            const Text('Split Successful!', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87)),
            const SizedBox(height: 20),
            _buildInfoRow(Icons.file_copy_rounded, 'Files Created', '${controller.splitFiles.length} PDF files'),
            const SizedBox(height: 10),
            _buildInfoRow(Icons.auto_stories_rounded, 'Total Pages', '${controller.totalPagesSplit} pages'),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.green.shade100, borderRadius: BorderRadius.circular(12)),
              child: Row(
                children: [
                  Icon(Icons.call_split, color: Colors.green.shade900),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text('Successfully split into ${controller.splitFiles.length} separate PDF files',
                        style: TextStyle(color: Colors.green.shade900, fontWeight: FontWeight.bold, fontSize: 14)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.folder_rounded, size: 18, color: Colors.grey[700]),
                      const SizedBox(width: 8),
                      const Text('Saved Location:', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black87)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(controller.outputDirectory, style: TextStyle(fontSize: 12, color: Colors.grey[600]), maxLines: 2, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
          ],
        )),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(color: Colors.grey.shade100, shape: BoxShape.circle),
            child: Icon(Icons.upload_file_rounded, size: 80, color: Colors.grey[400]),
          ),
          const SizedBox(height: 24),
          Text('No File Selected', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey[700])),
          const SizedBox(height: 8),
          Text('Select a PDF file to split', style: TextStyle(fontSize: 15, color: Colors.grey[500]), textAlign: TextAlign.center),
        ],
      ),
    );
  }
}