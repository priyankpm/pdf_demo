import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdf_demo/view/delete-pdf/delete_pdf_controller.dart';

class DeletePdf extends StatefulWidget {
  const DeletePdf({super.key});

  @override
  State<DeletePdf> createState() => _DeletePdfState();
}

class _DeletePdfState extends State<DeletePdf> with SingleTickerProviderStateMixin {
  final controller = Get.put(DeletePdfController());
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
        if (controller.viewingPageIndex.value >= 0) {
          return _buildPageViewDialog(context, controller);
        }

        return Column(
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
        );
      }),
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
                          Icons.delete_sweep,
                          color: Colors.white,
                          size: 36,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Delete PDF',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Remove unwanted pages',
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
            onTap: controller.isProcessing.value || controller.isLoadingPages.value
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
              if (controller.isLoadingPages.value) {
                return _buildLoadingIndicator();
              }
              return _buildPagesGrid();
            }),
            const SizedBox(height: 20),
            Obx(() {
              if (controller.isDeletionComplete.value) {
                return _buildResetButton();
              } else if (!controller.isLoadingPages.value &&
                  controller.pageImages.isNotEmpty) {
                return _buildDeleteButton();
              }
              return const SizedBox.shrink();
            }),
            Obx(
                  () => controller.isProcessing.value
                  ? _buildProcessingIndicator()
                  : const SizedBox.shrink(),
            ),
            Obx(
                  () => controller.hasProcessedFile
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
            if (controller.selectedPagesToDelete.isNotEmpty &&
                !controller.isDeletionComplete.value) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.teal.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.teal.withValues(alpha: 0.3),
                    width: 1.5,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.delete_rounded,
                      color: Colors.teal.shade700,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${controller.selectedPagesToDelete.length} page(s) selected for deletion',
                        style: TextStyle(
                          color: Colors.teal.shade700,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
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

  // Loading Indicator
  Widget _buildLoadingIndicator() {
    return Container(
      width: double.infinity,
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
        children: [
          const CircularProgressIndicator(color: Colors.teal),
          const SizedBox(height: 20),
          Obx(
                () => Text(
              controller.processingStatus.value,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  // Pages Grid
  Widget _buildPagesGrid() {
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
                'Select Pages to Delete',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Obx(() {
                if (controller.selectedPagesToDelete.isNotEmpty &&
                    !controller.isDeletionComplete.value) {
                  return TextButton.icon(
                    onPressed: controller.clearSelection,
                    icon: const Icon(Icons.clear_all, size: 18),
                    label: const Text('Clear'),
                    style: TextButton.styleFrom(foregroundColor: Colors.teal),
                  );
                }
                return const SizedBox.shrink();
              }),
            ],
          ),
          const SizedBox(height: 12),
          Obx(
                () => controller.isDeletionComplete.value
                ? Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(
                'Processing complete. Press "Reset" to process another PDF',
                style: TextStyle(
                  color: Colors.teal[700],
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
                : const SizedBox(),
          ),
          Obx(
                () => GridView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
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
      final isSelected = controller.selectedPagesToDelete.contains(pageNumber);
      final isDeletionComplete = controller.isDeletionComplete.value;

      return GestureDetector(
        onTap: () => controller.togglePageSelection(pageNumber),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? Colors.teal.shade600
                  : Colors.teal.withValues(alpha: 0.3),
              width: isSelected ? 2.5 : 1.5,
            ),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: isSelected
                    ? Colors.teal.withValues(alpha: 0.2)
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
                              fit: BoxFit.contain,
                              width: double.infinity,
                            ),
                            if (isDeletionComplete)
                              Container(
                                color: Colors.black.withValues(alpha: 0.1),
                              ),
                          ],
                        )
                            : const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 5,
                      ),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.teal.shade50 : Colors.teal.shade50,
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
                              fontWeight: FontWeight.w600,
                              fontSize: 11,
                              color: isSelected
                                  ? Colors.teal[700]
                                  : Colors.teal[700],
                            ),
                          ),
                          GestureDetector(
                            onTap: () => controller.viewSinglePage(index),
                            child: Icon(
                              Icons.remove_red_eye,
                              size: 18,
                              color: isSelected
                                  ? Colors.teal[700]
                                  : Colors.teal[700],
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
                  top: 4,
                  right: 4,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.teal.shade600,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          blurRadius: 3,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                      size: 14,
                    ),
                  ),
                ),
              if (isDeletionComplete)
                Positioned(
                  top: 4,
                  left: 4,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.grey[700],
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          blurRadius: 3,
                        ),
                      ],
                    ),
                    child: const Icon(Icons.lock, color: Colors.white, size: 14),
                  ),
                ),
            ],
          ),
        ),
      );
    });
  }

  // Delete Button
  Widget _buildDeleteButton() {
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
            onTap: controller.isProcessing.value ||
                controller.selectedPagesToDelete.isEmpty
                ? null
                : controller.deletePdfPages,
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
                      Icons.delete_rounded,
                      color: Colors.white,
                      size: 26,
                    ),
                  const SizedBox(width: 12),
                  Text(
                    controller.isProcessing.value
                        ? 'Deleting Pages...'
                        : 'Delete Selected (${controller.selectedPagesToDelete.length})',
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
              children: [
                const Icon(Icons.refresh, color: Colors.white, size: 26),
                const SizedBox(width: 12),
                const Text(
                  'Reset & Process Another',
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
      child: Container(
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
                'Please wait, this may take a while...',
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
                'Pages Deleted Successfully!',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      'Original',
                      controller.totalPages.toString(),
                      Colors.grey,
                      Icons.article_rounded,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      'Deleted',
                      controller.deletedPagesCount.toString(),
                      Colors.teal,
                      Icons.delete_rounded,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      'Remaining',
                      controller.remainingPages.toString(),
                      Colors.teal,
                      Icons.check_circle_rounded,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildResultInfoCard(
                Icons.description_rounded,
                'Output File',
                controller.processedFileName,
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
                      controller.processedFilePath,
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

  Widget _buildStatCard(String label, String value, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, size: 24, color: color),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[700],
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
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
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  // Page View Dialog
  Widget _buildPageViewDialog(
      BuildContext context,
      DeletePdfController controller,
      ) {
    final pageIndex = controller.viewingPageIndex.value;
    final pageNumber = pageIndex + 1;

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.teal.shade400, Colors.teal.shade600],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.teal.withValues(alpha: 0.2),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Page $pageNumber / ${controller.totalPages.value}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 24,
                      ),
                      onPressed: controller.closeSinglePageView,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            color: Colors.grey[200],
            child:
            controller.pageImages.isNotEmpty &&
                pageIndex < controller.pageImages.length &&
                controller.pageImages[pageIndex] != null
                ? Center(
              child: Image.memory(
                controller.pageImages[pageIndex]!,
                fit: BoxFit.contain,
              ),
            )
                : const Center(child: CircularProgressIndicator()),
          ),
        ),
      ],
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
              'Select a PDF file to delete pages',
              style: TextStyle(fontSize: 15, color: Colors.grey[500]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}