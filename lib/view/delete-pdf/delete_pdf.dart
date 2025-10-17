import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdf_demo/view/delete-pdf/delete_pdf_controller.dart';

class DeletePdf extends StatefulWidget {
  const DeletePdf({super.key});

  @override
  State<DeletePdf> createState() => _DeletePdfState();
}

class _DeletePdfState extends State<DeletePdf> {
  final controller = Get.put(DeletePdfController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Delete PDF Pages'),
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
      ),
      body: Obx(() {
        // Show page view dialog if viewing a page
        if (controller.viewingPageIndex.value >= 0) {
          return _buildPageViewDialog(context, controller);
        }

        return SingleChildScrollView(
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
        );
      }),
    );
  }

  // Build full-screen page view
  Widget _buildPageViewDialog(
    BuildContext context,
    DeletePdfController controller,
  ) {
    final pageIndex = controller.viewingPageIndex.value;
    final pageNumber = pageIndex + 1;

    return Column(
      children: [
        Container(
          color: Colors.grey[900],
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Page $pageNumber of ${controller.totalPages.value}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 28),
                onPressed: controller.closeSinglePageView,
              ),
            ],
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

  Widget _buildHeaderCard() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Icon(Icons.delete_sweep, size: 48, color: Colors.deepOrange),
            const SizedBox(height: 12),
            const Text(
              'PDF Page Remover',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Select and remove unwanted pages from your PDF',
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectButton(DeletePdfController controller) {
    return Obx(
      () => ElevatedButton.icon(
        onPressed:
            controller.isProcessing.value || controller.isLoadingPages.value
            ? null
            : controller.pickPdfFile,
        icon: const Icon(Icons.folder_open),
        label: const Text('Select PDF File'),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          backgroundColor: Colors.deepOrange,
          foregroundColor: Colors.white,
          textStyle: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildSelectedFileSection(DeletePdfController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildFileInfoCard(controller),
        const SizedBox(height: 20),
        Obx(() {
          if (controller.isLoadingPages.value) {
            return _buildLoadingIndicator(controller);
          }
          return _buildPagesGrid(controller);
        }),
        const SizedBox(height: 20),
        Obx(() {
          if (controller.isDeletionComplete.value) {
            return _buildResetButton(controller);
          } else if (!controller.isLoadingPages.value &&
              controller.pageImages.isNotEmpty) {
            return _buildDeleteButton(controller);
          }
          return const SizedBox.shrink();
        }),
        Obx(
          () => controller.isProcessing.value
              ? _buildProcessingIndicator(controller)
              : const SizedBox.shrink(),
        ),
        Obx(
          () => controller.hasProcessedFile
              ? _buildResultCard(controller)
              : const SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _buildFileInfoCard(DeletePdfController controller) {
    return Obx(
      () => Card(
        elevation: 2,
        color: Colors.deepOrange[50],
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.picture_as_pdf, color: Colors.deepOrange[700]),
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
              _buildInfoRow('Original Size', controller.formattedOriginalSize),
              if (controller.totalPages.value > 0) ...[
                const SizedBox(height: 8),
                _buildInfoRow('Total Pages', controller.totalPages.toString()),
              ],
              if (controller.selectedPagesToDelete.isNotEmpty) ...[
                const SizedBox(height: 8),
                _buildInfoRow(
                  'Selected for Deletion',
                  '${controller.selectedPagesToDelete.length} page(s)',
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator(DeletePdfController controller) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          children: [
            const CircularProgressIndicator(color: Colors.deepOrange),
            const SizedBox(height: 20),
            Obx(
              () => Text(
                controller.processingStatus.value,
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPagesGrid(DeletePdfController controller) {
    return Card(
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
                  "Select Pages to Delete",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Obx(() {
                  if (controller.selectedPagesToDelete.isNotEmpty &&
                      !controller.isDeletionComplete.value) {
                    return TextButton.icon(
                      onPressed: controller.clearSelection,
                      icon: const Icon(Icons.clear_all, size: 18),
                      label: const Text('Clear'),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.deepOrange,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                }),
              ],
            ),
            const SizedBox(height: 12),
            Obx(
              () => controller.isDeletionComplete.value
                  ? Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Text(
                        'Processing complete. Press "Reset" to process another PDF',
                        style: TextStyle(
                          color: controller.isDeletionComplete.value
                              ? Colors.green[700]
                              : Colors.grey[600],
                          fontSize: 12,
                          fontWeight: controller.isDeletionComplete.value
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                      ),
                    )
                  : SizedBox(),
            ),
            Obx(
              () => GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 0.65,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: controller.pageImages.length,
                itemBuilder: (context, index) {
                  return _buildPageCard(index, controller);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPageCard(int index, DeletePdfController controller) {
    final pageNumber = index + 1;
    return Obx(() {
      final isSelected = controller.selectedPagesToDelete.contains(pageNumber);
      final isDeletionComplete = controller.isDeletionComplete.value;

      return GestureDetector(
        onTap: () => controller.togglePageSelection(pageNumber),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? Colors.red : Colors.grey[300]!,
              width: isSelected ? 2.5 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: isSelected
                    ? Colors.red.withValues(alpha: 0.3)
                    : Colors.black.withValues(alpha: 0.05),
                blurRadius: isSelected ? 6 : 2,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(7),
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
                                      color: Colors.black.withValues(
                                        alpha: 0.1,
                                      ),
                                    ),
                                ],
                              )
                            : const Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12,vertical: 5),
                      width: double.infinity,
                      color: isSelected ? Colors.red[50] : Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Page $pageNumber',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 11,
                              color: isSelected
                                  ? Colors.red[700]
                                  : Colors.black87,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          GestureDetector(
                            onTap: () => controller.viewSinglePage(index),
                            child: Icon(Icons.remove_red_eye, size: 18),
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
                      color: Colors.red,
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
                    child: const Icon(
                      Icons.lock,
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

  Widget _buildDeleteButton(DeletePdfController controller) {
    return Obx(
      () => ElevatedButton.icon(
        onPressed:
            controller.isProcessing.value ||
                controller.selectedPagesToDelete.isEmpty
            ? null
            : controller.deletePdfPages,
        icon: controller.isProcessing.value
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : const Icon(Icons.delete, size: 24),
        label: Text(
          controller.isProcessing.value
              ? 'Deleting Pages...'
              : 'Delete Selected Pages (${controller.selectedPagesToDelete.length})',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          backgroundColor: Colors.deepOrange,
          foregroundColor: Colors.white,
        ),
      ),
    );
  }

  Widget _buildResetButton(DeletePdfController controller) {
    return ElevatedButton.icon(
      onPressed: controller.resetForNewFile,
      icon: const Icon(Icons.refresh, size: 24),
      label: const Text(
        'Reset & Process Another PDF',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget _buildProcessingIndicator(DeletePdfController controller) {
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
                'Please wait, this may take a while...',
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultCard(DeletePdfController controller) {
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
                    Icon(
                      Icons.check_circle,
                      color: Colors.green[700],
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      "Pages Deleted Successfully!",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
                const Divider(height: 24),
                _buildInfoRow('Output File', controller.processedFileName),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        'Original Pages',
                        controller.totalPages.toString(),
                        Colors.grey,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        'Deleted',
                        controller.deletedPagesCount.toString(),
                        Colors.red,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        'Remaining',
                        controller.remainingPages.toString(),
                        Colors.green,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
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
                        controller.processedFilePath,
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
          width: 140,
          child: Text(
            '$label:',
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
        ),
        Expanded(child: Text(value, style: const TextStyle(fontSize: 14))),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: color,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
