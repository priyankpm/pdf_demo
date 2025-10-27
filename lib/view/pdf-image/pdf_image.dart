import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdf_demo/view/pdf-image/pdf_image_controller.dart';

class PdfToImage extends StatefulWidget {
  const PdfToImage({super.key});

  @override
  State<PdfToImage> createState() => _PdfToImageState();
}

class _PdfToImageState extends State<PdfToImage>
    with SingleTickerProviderStateMixin {
  final controller = Get.put(PdfToImageController());
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
      body: Obx(() {
        // Show full-screen page view dialog if viewing a page
        if (controller.viewingPageIndex.value >= 0) {
          return _buildPageViewDialog();
        }

        return Column(
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

                    // Select Button
                    _buildSelectButton(),

                    const SizedBox(height: 20),

                    // Content Section
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
        );
      }),
    );
  }

  // Premium Header with Gradient (using home screen colors for PDF to Image)
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
                  Obx(
                    () => controller.hasSelectedFile
                        ? Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.3),
                                width: 1.5,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.auto_stories_rounded,
                                  color: Colors.white,
                                  size: 18,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  '${controller.totalPages.value} Pages',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
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
                          Icons.collections_rounded,
                          color: Colors.white,
                          size: 36,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'PDF to Image',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Convert pages to images',
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
            onTap:
                controller.isProcessing.value || controller.isLoadingPages.value
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // File Info Card
            _buildFileInfoCard(),

            const SizedBox(height: 20),

            // Export Options Card
            _buildExportOptionsCard(),

            const SizedBox(height: 20),

            // Loading or Pages Grid
            Obx(() {
              if (controller.isLoadingPages.value) {
                return _buildLoadingCard();
              } else if (controller.pageImages.isNotEmpty) {
                return _buildPagesSection();
              }
              return const SizedBox.shrink();
            }),

            // Export/Reset Button
            Obx(() {
              if (controller.isExportComplete.value) {
                return _buildResetButton();
              } else if (controller.hasSelectedFile &&
                  controller.pageImages.isNotEmpty) {
                return _buildExportButton();
              }
              return const SizedBox.shrink();
            }),

            // Result Card
            Obx(
              () => controller.exportedFiles.isNotEmpty
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
            _buildInfoRow(
              Icons.description_rounded,
              'File Name',
              controller.fileName,
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
              Icons.storage_rounded,
              'File Size',
              controller.fileSize,
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
              Icons.auto_stories_rounded,
              'Total Pages',
              '${controller.totalPages.value} pages',
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

  // Export Options Card
  Widget _buildExportOptionsCard() {
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
                    Icons.tune_rounded,
                    color: Colors.teal.shade700,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Export Settings',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Format Selection
            const Text(
              'Image Format',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildFormatOption(
                    ExportFormat.png,
                    'PNG',
                    'Lossless quality',
                    Icons.image_rounded,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildFormatOption(
                    ExportFormat.jpg,
                    'JPG',
                    'Smaller size',
                    Icons.photo_rounded,
                  ),
                ),
              ],
            ),

            // Quality Slider for JPG
            if (controller.exportFormat.value == ExportFormat.jpg) ...[
              const SizedBox(height: 20),
              const Text(
                'Image Quality',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Quality',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.teal.shade300,
                                Colors.teal.shade600,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${controller.imageQuality.value}%',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    SliderTheme(
                      data: SliderThemeData(
                        activeTrackColor: Colors.teal.shade600,
                        inactiveTrackColor: Colors.grey[300],
                        thumbColor: Colors.teal.shade700,
                        overlayColor: Colors.teal.withValues(alpha: 0.2),
                        trackHeight: 4,
                      ),
                      child: Slider(
                        value: controller.imageQuality.value.toDouble(),
                        min: 50,
                        max: 100,
                        divisions: 10,
                        onChanged: controller.isProcessing.value
                            ? null
                            : (value) =>
                                  controller.setImageQuality(value.toInt()),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 20),

            // Export All Pages Toggle
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap:
                    controller.isProcessing.value ||
                        controller.isLoadingPages.value
                    ? null
                    : () => controller.setExportAllPages(
                        !controller.exportAllPages.value,
                      ),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: controller.exportAllPages.value
                        ? Colors.teal.withValues(alpha: 0.1)
                        : Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: controller.exportAllPages.value
                          ? Colors.teal.shade600
                          : Colors.grey.shade300,
                      width: 2,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          gradient: controller.exportAllPages.value
                              ? LinearGradient(
                                  colors: [
                                    Colors.teal.shade300,
                                    Colors.teal.shade600,
                                  ],
                                )
                              : null,
                          color: controller.exportAllPages.value
                              ? null
                              : Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.select_all_rounded,
                          color: controller.exportAllPages.value
                              ? Colors.white
                              : Colors.grey.shade600,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Export All Pages',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: controller.exportAllPages.value
                                    ? Colors.teal.shade700
                                    : Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Convert all pages to images',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        controller.exportAllPages.value
                            ? Icons.check_circle_rounded
                            : Icons.radio_button_unchecked,
                        color: controller.exportAllPages.value
                            ? Colors.teal.shade600
                            : Colors.grey.shade400,
                        size: 24,
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

  Widget _buildFormatOption(
    ExportFormat format,
    String title,
    String desc,
    IconData icon,
  ) {
    return Obx(() {
      final isSelected = controller.exportFormat.value == format;
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: controller.isProcessing.value
              ? null
              : () => controller.setExportFormat(format),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isSelected
                  ? Colors.teal.withValues(alpha: 0.1)
                  : Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? Colors.teal.shade600 : Colors.grey.shade300,
                width: 2,
              ),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: isSelected
                        ? LinearGradient(
                            colors: [
                              Colors.teal.shade300,
                              Colors.teal.shade600,
                            ],
                          )
                        : null,
                    color: isSelected ? null : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    color: isSelected ? Colors.white : Colors.grey.shade600,
                    size: 28,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.teal.shade700 : Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  desc,
                  style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  // Loading Card
  Widget _buildLoadingCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(40),
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
        children: [
          CircularProgressIndicator(
            color: Colors.teal.shade600,
            strokeWidth: 3,
          ),
          const SizedBox(height: 20),
          Obx(
            () => Text(
              controller.processingStatus.value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Loading PDF pages...',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  // Pages Section
  Widget _buildPagesSection() {
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
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.teal.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.photo_library_rounded,
                      color: Colors.teal.shade700,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Select Pages',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              Obx(() {
                if (controller.isExportComplete.value) {
                  return const SizedBox.shrink();
                }
                if (controller.selectedPagesToExport.isEmpty &&
                    !controller.exportAllPages.value) {
                  return TextButton.icon(
                    onPressed: controller.selectAllPages,
                    icon: const Icon(Icons.select_all, size: 18),
                    label: const Text('Select All'),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.teal.shade700,
                    ),
                  );
                } else if (controller.selectedPagesToExport.isNotEmpty) {
                  return TextButton.icon(
                    onPressed: controller.clearSelection,
                    icon: const Icon(Icons.clear_all, size: 18),
                    label: const Text('Clear'),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.teal.shade700,
                    ),
                  );
                }
                return const SizedBox.shrink();
              }),
            ],
          ),

          const SizedBox(height: 16),

          // Info Banner
          Obx(() {
            if (controller.isExportComplete.value) {
              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.teal.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.teal.shade200, width: 1),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle_rounded,
                      color: Colors.teal.shade700,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Export complete! Reset to process another PDF',
                        style: TextStyle(
                          color: Colors.teal.shade900,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else if (controller.selectedPagesToExport.isNotEmpty) {
              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.teal.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.teal.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      color: Colors.teal.shade700,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        '${controller.selectedPagesToExport.length} page(s) selected • Tap to toggle',
                        style: TextStyle(
                          color: Colors.teal.shade900,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
            return Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.shade100, width: 1),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.touch_app_rounded,
                    color: Colors.blue.shade700,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Tap pages to select • Tap eye icon to preview',
                      style: TextStyle(
                        color: Colors.blue.shade900,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),

          const SizedBox(height: 16),

          // Pages Grid
          Obx(
            () => GridView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.only(top: 10),
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 0.65,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: controller.pageImages.length,
              itemBuilder: (context, index) {
                return _buildPageCard(index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPageCard(int index) {
    final pageNumber = index + 1;
    return Obx(() {
      final isSelected = controller.selectedPagesToExport.contains(pageNumber);
      final isExportComplete = controller.isExportComplete.value;

      return GestureDetector(
        onTap: () => controller.togglePageSelection(pageNumber),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? Colors.teal.shade600 : Colors.grey.shade300,
              width: isSelected ? 2.5 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: isSelected
                    ? Colors.teal.withValues(alpha: 0.3)
                    : Colors.black.withValues(alpha: 0.05),
                blurRadius: isSelected ? 8 : 2,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(11),
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        color: Colors.grey[100],
                        child: controller.pageImages[index] != null
                            ? Stack(
                                children: [
                                  Image.memory(
                                    controller.pageImages[index]!,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: double.infinity,
                                  ),
                                  if (isExportComplete)
                                    Container(
                                      color: Colors.black.withValues(
                                        alpha: 0.3,
                                      ),
                                    ),
                                ],
                              )
                            : Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.teal.shade600,
                                ),
                              ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 8,
                      ),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.teal.withValues(alpha: 0.1)
                            : Colors.white,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(11),
                          bottomRight: Radius.circular(11),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Page $pageNumber',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                              color: isSelected
                                  ? Colors.teal.shade700
                                  : Colors.black87,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => controller.viewSinglePage(index),
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? Colors.teal.shade600
                                    : Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Icon(
                                Icons.visibility_rounded,
                                size: 14,
                                color: isSelected
                                    ? Colors.white
                                    : Colors.grey.shade700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (isSelected)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.teal.shade300, Colors.teal.shade600],
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              if (isExportComplete)
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.grey[700],
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.lock_rounded,
                      color: Colors.white,
                      size: 14,
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
    });
  }

  // Export Button
  Widget _buildExportButton() {
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
                  children: [
                    Obx(
                      () => Text(
                        controller.processingStatus.value,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Converting PDF pages to images...',
                      style: TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                  ],
                ),
              ),

            Material(
              color: controller.selectedPagesToExport.isEmpty
                  ? Colors.grey.shade300
                  : Colors.teal.shade600,
              borderRadius: BorderRadius.circular(16),
              elevation: controller.selectedPagesToExport.isEmpty ? 0 : 4,
              shadowColor: Colors.teal.withValues(alpha: 0.3),
              child: InkWell(
                onTap:
                    controller.isProcessing.value ||
                        controller.selectedPagesToExport.isEmpty
                    ? null
                    : controller.exportToImages,
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
                          Icons.file_download_rounded,
                          color: Colors.white,
                          size: 26,
                        ),
                      const SizedBox(width: 12),
                      Text(
                        controller.isProcessing.value
                            ? 'Exporting...'
                            : controller.selectedPagesToExport.isEmpty
                            ? 'Select pages to export'
                            : 'Export ${controller.selectedPagesToExport.length} Page${controller.selectedPagesToExport.length > 1 ? 's' : ''}',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: controller.selectedPagesToExport.isEmpty
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.refresh_rounded, color: Colors.white, size: 26),
                SizedBox(width: 12),
                Text(
                  'Process Another PDF',
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

  // Result Card
  Widget _buildResultCard() {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Container(
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
        child: Obx(
          () => Column(
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
                'Export Successful!',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 20),

              // Info Cards
              _buildResultInfoCard(
                Icons.photo_library_rounded,
                'Images Exported',
                '${controller.exportedFiles.length} image${controller.exportedFiles.length > 1 ? 's' : ''}',
              ),
              const SizedBox(height: 10),
              _buildResultInfoCard(
                Icons.image_rounded,
                'Format',
                controller.exportFormat.value == ExportFormat.png
                    ? 'PNG (Lossless)'
                    : 'JPG (${controller.imageQuality.value}% quality)',
              ),

              const SizedBox(height: 16),

              // Location
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
                      controller.exportedFiles.isNotEmpty
                          ? controller.exportedFiles.first.parent.path
                          : '',
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
    return Padding(
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
            'No File Selected',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Select a PDF file to convert pages',
            style: TextStyle(fontSize: 15, color: Colors.grey[500]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // Page View Dialog (Full Screen)
  Widget _buildPageViewDialog() {
    return Container(
      color: Colors.black,
      child: Column(
        children: [
          // Header Bar
          Container(
            color: Colors.grey[900],
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Obx(
                      () => Text(
                        'Page ${controller.viewingPageIndex.value + 1} of ${controller.totalPages.value}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.close_rounded,
                          color: Colors.white,
                          size: 28,
                        ),
                        onPressed: controller.closeSinglePageView,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Image Viewer
          Expanded(
            child: Container(
              color: Colors.grey[900],
              child: Obx(() {
                final pageIndex = controller.viewingPageIndex.value;
                if (controller.pageImages.isNotEmpty &&
                    pageIndex < controller.pageImages.length &&
                    controller.pageImages[pageIndex] != null) {
                  return InteractiveViewer(
                    minScale: 0.5,
                    maxScale: 4.0,
                    child: Center(
                      child: Image.memory(
                        controller.pageImages[pageIndex]!,
                        fit: BoxFit.contain,
                      ),
                    ),
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
