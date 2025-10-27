import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdf_demo/view/resize-pdf/resize_pdf_controller.dart';

class ResizePdf extends StatefulWidget {
  const ResizePdf({super.key});

  @override
  State<ResizePdf> createState() => _ResizePdfState();
}

class _ResizePdfState extends State<ResizePdf> with SingleTickerProviderStateMixin {
  final controller = Get.put(ResizePdfController());
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
                          Icons.photo_size_select_large,
                          color: Colors.white,
                          size: 36,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'PDF Resizer',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Convert pages to any size',
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
            onTap: controller.isProcessing.value ? null : controller.pickPdfFile,
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
                    controller.hasSelectedFile ? 'Change PDF File' : 'Select PDF File',
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

  // Content Section with FadeTransition
  Widget _buildContentSection() {
    return FadeTransition(
      opacity: _animationController,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            _buildFileInfoCard(),
            const SizedBox(height: 20),
            _buildPageSizeOptionsCard(),
            const SizedBox(height: 20),
            _buildScalingOptionsCard(),
            const SizedBox(height: 20),
            _buildResizeButton(),
            Obx(
                  () => controller.isProcessing.value
                  ? _buildProcessingIndicator()
                  : const SizedBox.shrink(),
            ),
            Obx(
                  () => controller.hasResizedFile
                  ? _buildResultCard()
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
            _buildInfoRow(Icons.description_rounded, 'File Name', controller.fileName),
            const SizedBox(height: 12),
            _buildInfoRow(Icons.storage_rounded, 'File Size', controller.fileSize),
            const SizedBox(height: 12),
            _buildInfoRow(
              Icons.article_rounded,
              'Total Pages',
              '${controller.totalPages} pages',
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
              Icons.aspect_ratio_rounded,
              'Current Size',
              controller.currentPageSize.value,
            ),
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

  // Page Size Options Card
  Widget _buildPageSizeOptionsCard() {
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
                  Icons.aspect_ratio_rounded,
                  color: Colors.teal.shade700,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Target Page Size',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Select the desired output paper size',
            style: TextStyle(color: Colors.grey[600], fontSize: 13),
          ),
          const SizedBox(height: 16),
          _buildPageSizeGrid(),
        ],
      ),
    );
  }

  Widget _buildPageSizeGrid() {
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
          return Material(
            color: isSelected ? Colors.teal.shade600 : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              onTap: controller.isProcessing.value
                  ? null
                  : () => controller.setTargetPageSize(size['name']!),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? Colors.teal.shade600
                        : Colors.grey.shade300,
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
            ),
          );
        }).toList(),
      ),
    );
  }

  // Scaling Options Card
  Widget _buildScalingOptionsCard() {
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
                    Icons.settings_rounded,
                    color: Colors.teal.shade700,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Scaling Options',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
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
    );
  }

  // Resize Button
  Widget _buildResizeButton() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Obx(
            () => Material(
          color: controller.isProcessing.value
              ? Colors.grey.shade300
              : Colors.teal.shade600,
          borderRadius: BorderRadius.circular(16),
          elevation: controller.isProcessing.value ? 0 : 4,
          shadowColor: Colors.teal.withValues(alpha: 0.3),
          child: InkWell(
            onTap: controller.isProcessing.value || !controller.hasSelectedFile
                ? null
                : controller.resizePdf,
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
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  else
                    const Icon(
                      Icons.photo_size_select_large,
                      color: Colors.white,
                      size: 26,
                    ),
                  const SizedBox(width: 12),
                  Text(
                    controller.isProcessing.value ? 'Resizing...' : 'Resize PDF',
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
                'Please wait...',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Result Card
  Widget _buildResultCard() {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Obx(
            () => Container(
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
                'PDF Resized Successfully!',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 20),
              _buildResultInfoCard(
                Icons.description_rounded,
                'Resized File',
                controller.resizedFileName,
              ),
              const SizedBox(height: 10),
              _buildResultInfoCard(
                Icons.storage_rounded,
                'File Size',
                controller.resizedFileSize,
              ),
              const SizedBox(height: 10),
              _buildResultInfoCard(
                Icons.article_rounded,
                'Total Pages',
                '${controller.totalPages} pages',
              ),
              const SizedBox(height: 10),
              _buildResultInfoCard(
                Icons.aspect_ratio_rounded,
                'New Page Size',
                controller.targetPageSize.value,
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.folder_rounded,
                          size: 18,
                          color: Colors.grey[700],
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Saved Location:',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      controller.resizedFilePath,
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
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
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
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
              'Select a PDF file to resize',
              style: TextStyle(fontSize: 15, color: Colors.grey[500]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}