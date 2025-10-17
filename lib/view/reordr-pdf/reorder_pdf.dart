import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'reorder_pdf_controller.dart';

class ReorderPdf extends StatefulWidget {
  const ReorderPdf({super.key});

  @override
  State<ReorderPdf> createState() => _ReorderPdfState();
}

class _ReorderPdfState extends State<ReorderPdf> {
  final controller = Get.put(ReorderPdfController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Reorder PDF Pages'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Obx(() {
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

  Widget _buildPageViewDialog(
      BuildContext context,
      ReorderPdfController controller,
      ) {
    final pageIndex = controller.viewingPageIndex.value;
    final originalPageIndex = controller.pageOrder[pageIndex];
    final pageNumber = originalPageIndex + 1;

    return Column(
      children: [
        Container(
          color: Colors.grey[900],
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Page $pageNumber (Position ${pageIndex + 1})',
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
            child: controller.pageImages.isNotEmpty &&
                originalPageIndex < controller.pageImages.length &&
                controller.pageImages[originalPageIndex] != null
                ? Center(
              child: Image.memory(
                controller.pageImages[originalPageIndex]!,
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
            const Icon(Icons.swap_vert, size: 48, color: Colors.blue),
            const SizedBox(height: 12),
            const Text(
              'PDF Page Reorder',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Long press and drag to reorder pages in your PDF',
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectButton(ReorderPdfController controller) {
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
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          textStyle: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildSelectedFileSection(ReorderPdfController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildFileInfoCard(controller),
        const SizedBox(height: 20),
        Obx(() {
          if (controller.isLoadingPages.value) {
            return _buildLoadingIndicator(controller);
          }
          return _buildPagesReorderGrid(controller);
        }),
        const SizedBox(height: 20),
        Obx(() {
          if (controller.isReorderComplete.value) {
            return _buildResetButton(controller);
          } else if (!controller.isLoadingPages.value &&
              controller.pageImages.isNotEmpty) {
            return _buildSaveButton(controller);
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

  Widget _buildFileInfoCard(ReorderPdfController controller) {
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
              _buildInfoRow('Original Size', controller.formattedOriginalSize),
              if (controller.totalPages.value > 0) ...[
                const SizedBox(height: 8),
                _buildInfoRow('Total Pages', controller.totalPages.toString()),
              ],
              if (controller.hasReordered &&
                  !controller.isReorderComplete.value) ...[
                const SizedBox(height: 8),
                _buildInfoRow(
                  'Status',
                  'Pages have been reordered',
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator(ReorderPdfController controller) {
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
          ],
        ),
      ),
    );
  }

  Widget _buildPagesReorderGrid(ReorderPdfController controller) {
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
                  "Long Press & Drag to Reorder",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Obx(() {
                  if (controller.hasReordered &&
                      !controller.isReorderComplete.value) {
                    return TextButton.icon(
                      onPressed: controller.resetOrder,
                      icon: const Icon(Icons.restore, size: 18),
                      label: const Text('Reset Order'),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.blue,
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
                  () => controller.isReorderComplete.value
                  ? Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  'Processing complete. Press "Reset" to process another PDF',
                  style: TextStyle(
                    color: Colors.green[700],
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
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 0.65,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: controller.pageOrder.length,
                itemBuilder: (context, index) {
                  return _buildDraggablePageCard(index, controller);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDraggablePageCard(int index, ReorderPdfController controller) {
    final originalPageIndex = controller.pageOrder[index];
    final originalPageNumber = originalPageIndex + 1;
    final isDeletionComplete = controller.isReorderComplete.value;

    if (isDeletionComplete) {
      return _buildPageCard(
        index,
        originalPageIndex,
        originalPageNumber,
        isDeletionComplete,
        controller,
      );
    }

    return LongPressDraggable<int>(
      data: index,
      feedback: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(8),
        child: Opacity(
          opacity: 0.8,
          child: SizedBox(
            width: 100,
            height: 140,
            child: _buildPageCard(
              index,
              originalPageIndex,
              originalPageNumber,
              false,
              controller,
              isDragging: true,
            ),
          ),
        ),
      ),
      childWhenDragging: Opacity(
        opacity: 0.3,
        child: _buildPageCard(
          index,
          originalPageIndex,
          originalPageNumber,
          false,
          controller,
        ),
      ),
      child: DragTarget<int>(
        onWillAccept: (fromIndex) => fromIndex != null && fromIndex != index,
        onAccept: (fromIndex) {
          controller.reorderPages(fromIndex, index);
        },
        builder: (context, candidateData, rejectedData) {
          return _buildPageCard(
            index,
            originalPageIndex,
            originalPageNumber,
            false,
            controller,
            isHovering: candidateData.isNotEmpty,
          );
        },
      ),
    );
  }

  Widget _buildPageCard(
      int index,
      int originalPageIndex,
      int originalPageNumber,
      bool isDeletionComplete,
      ReorderPdfController controller, {
        bool isHovering = false,
        bool isDragging = false,
      }) {
    return GestureDetector(
      onTap: () => controller.viewSinglePage(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isHovering
                ? Colors.blue
                : Colors.blue.withOpacity(0.3),
            width: isHovering ? 2.5 : 1.5,
          ),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isHovering ? 0.2 : 0.1),
              blurRadius: isHovering ? 8 : 4,
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
                      child: controller.pageImages[originalPageIndex] != null
                          ? Stack(
                        children: [
                          Image.memory(
                            controller.pageImages[originalPageIndex]!,
                            fit: BoxFit.contain,
                            width: double.infinity,
                          ),
                          if (isDeletionComplete)
                            Container(
                              color: Colors.black.withOpacity(0.1),
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 6,
                    ),
                    width: double.infinity,
                    color: Colors.blue[50],
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Position: ${index + 1}',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 10,
                            color: Colors.blue[700],
                          ),
                        ),
                        Text(
                          'Page $originalPageNumber',
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 9,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (!isDeletionComplete && !isDragging)
              Positioned(
                top: 4,
                right: 4,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 3,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.drag_indicator,
                    color: Colors.white,
                    size: 14,
                  ),
                ),
              ),
            if (isDeletionComplete)
              Positioned(
                top: 4,
                right: 4,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.grey[700],
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
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
  }

  Widget _buildSaveButton(ReorderPdfController controller) {
    return Obx(
          () => ElevatedButton.icon(
        onPressed: controller.isProcessing.value || !controller.hasReordered
            ? null
            : controller.savePdfWithNewOrder,
        icon: controller.isProcessing.value
            ? const SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Colors.white,
          ),
        )
            : const Icon(Icons.save, size: 24),
        label: Text(
          controller.isProcessing.value
              ? 'Saving PDF...'
              : 'Save Reordered PDF',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
      ),
    );
  }

  Widget _buildResetButton(ReorderPdfController controller) {
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

  Widget _buildProcessingIndicator(ReorderPdfController controller) {
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

  Widget _buildResultCard(ReorderPdfController controller) {
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
                      "Pages Reordered Successfully!",
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
                _buildInfoRow('Total Pages', controller.totalPages.toString()),
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
}