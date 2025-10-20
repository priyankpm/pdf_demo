import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdf_demo/view/pdf-image/pdf_image_controller.dart';

class PdfToImage extends StatefulWidget {
  const PdfToImage({super.key});

  @override
  State<PdfToImage> createState() => _PdfToImageState();
}

class _PdfToImageState extends State<PdfToImage> {
  final controller = Get.put(PdfToImageController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('PDF to Image'),
        backgroundColor: Colors.teal,
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

  Widget _buildPageViewDialog(
      BuildContext context,
      PdfToImageController controller,
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
            child: controller.pageImages.isNotEmpty &&
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
            const Icon(Icons.photo_library, size: 48, color: Colors.teal),
            const SizedBox(height: 12),
            const Text(
              'PDF to Image Converter',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Convert PDF pages into individual images',
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectButton(PdfToImageController controller) {
    return Obx(
          () => ElevatedButton.icon(
        onPressed: controller.isProcessing.value ||
            controller.isLoadingPages.value
            ? null
            : controller.pickPdfFile,
        icon: const Icon(Icons.upload_file),
        label: Text(
          controller.hasSelectedFile ? 'Change PDF File' : 'Select PDF File',
        ),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
          textStyle: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildSelectedFileSection(PdfToImageController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildFileInfoCard(controller),
        const SizedBox(height: 20),
        _buildExportOptionsCard(controller),
        const SizedBox(height: 20),

        // Show page grid
        Obx(() {
          if (controller.isLoadingPages.value) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: _buildLoadingIndicator(controller),
            );
          } else if (controller.pageImages.isNotEmpty) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: _buildPagesGrid(controller),
            );
          }
          return const SizedBox.shrink();
        }),

        // Show Reset button if export is complete, otherwise show Export button
        Obx(() {
          if (controller.isExportComplete.value) {
            return _buildResetButton(controller);
          } else {
            return _buildExportButton(controller);
          }
        }),

        Obx(
              () => controller.isProcessing.value
              ? _buildProcessingIndicator(controller)
              : const SizedBox.shrink(),
        ),

        Obx(
              () => controller.exportedFiles.isNotEmpty
              ? _buildResultCard(controller)
              : const SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _buildFileInfoCard(PdfToImageController controller) {
    return Obx(
          () => Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.picture_as_pdf, color: Colors.teal[700]),
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
              _buildInfoRow('Total Pages', '${controller.totalPages} pages'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExportOptionsCard(PdfToImageController controller) {
    return Obx(
          () => Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.settings, color: Colors.teal[700]),
                  const SizedBox(width: 8),
                  const Text(
                    "Export Options",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
              const Divider(height: 20),

              // Format Selection
              const Text(
                'Image Format',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildFormatButton(
                      controller,
                      ExportFormat.png,
                      Icons.image,
                      'PNG',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildFormatButton(
                      controller,
                      ExportFormat.jpg,
                      Icons.photo,
                      'JPG',
                    ),
                  ),
                ],
              ),

              // Quality Slider (only for JPG)
              if (controller.exportFormat.value == ExportFormat.jpg) ...[
                const SizedBox(height: 20),
                const Text(
                  'Image Quality',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Slider(
                        value: controller.imageQuality.value.toDouble(),
                        min: 50,
                        max: 100,
                        divisions: 10,
                        label: '${controller.imageQuality.value}%',
                        activeColor: Colors.teal,
                        onChanged: controller.isProcessing.value
                            ? null
                            : (value) => controller.setImageQuality(value.toInt()),
                      ),
                    ),
                    SizedBox(
                      width: 50,
                      child: Text(
                        '${controller.imageQuality.value}%',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ],

              const SizedBox(height: 20),
              const Text(
                'Pages to Export',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
              const SizedBox(height: 12),
              CheckboxListTile(
                title: const Text('Export All Pages'),
                subtitle: const Text('Export all pages in the PDF'),
                value: controller.exportAllPages.value,
                onChanged: controller.isProcessing.value ||
                    controller.isLoadingPages.value
                    ? null
                    : (value) => controller.setExportAllPages(value ?? true),
                activeColor: Colors.teal,
                controlAffinity: ListTileControlAffinity.leading,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormatButton(
      PdfToImageController controller,
      ExportFormat format,
      IconData icon,
      String label,
      ) {
    return Obx(
          () => GestureDetector(
        onTap: controller.isProcessing.value
            ? null
            : () => controller.setExportFormat(format),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: controller.exportFormat.value == format
                ? Colors.teal
                : Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: controller.exportFormat.value == format
                  ? Colors.teal
                  : Colors.grey[400]!,
              width: 2,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                size: 32,
                color: controller.exportFormat.value == format
                    ? Colors.white
                    : Colors.grey[700],
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: controller.exportFormat.value == format
                      ? Colors.white
                      : Colors.grey[700],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator(PdfToImageController controller) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          children: [
            const CircularProgressIndicator(color: Colors.teal),
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

  Widget _buildPagesGrid(PdfToImageController controller) {
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
                  "Select Pages to Export",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Row(
                  children: [
                    Obx(() {
                      if (!controller.exportAllPages.value &&
                          controller.selectedPagesToExport.isEmpty) {
                        return TextButton.icon(
                          onPressed: controller.selectAllPages,
                          icon: const Icon(Icons.select_all, size: 18),
                          label: const Text('Select All'),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.teal,
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                          ),
                        );
                      } else if (controller.selectedPagesToExport.isNotEmpty) {
                        return TextButton.icon(
                          onPressed: controller.clearSelection,
                          icon: const Icon(Icons.clear_all, size: 18),
                          label: const Text('Clear'),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.teal,
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    }),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Obx(
                  () => controller.isExportComplete.value
                  ? Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  'Export complete. Press "Reset" to process another PDF',
                  style: TextStyle(
                    color: Colors.green[700],
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
                  : controller.selectedPagesToExport.isNotEmpty
                  ? Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  '${controller.selectedPagesToExport.length} page(s) selected for export',
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

  Widget _buildPageCard(int index, PdfToImageController controller) {
    final pageNumber = index + 1;
    return Obx(() {
      final isSelected =
      controller.selectedPagesToExport.contains(pageNumber);
      final isExportComplete = controller.isExportComplete.value;

      return GestureDetector(
        onTap: () => controller.togglePageSelection(pageNumber),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? Colors.teal : Colors.grey[300]!,
              width: isSelected ? 2.5 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: isSelected
                    ? Colors.teal.withValues(alpha: 0.3)
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
                            if (isExportComplete)
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
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 5,
                      ),
                      width: double.infinity,
                      color: isSelected ? Colors.teal[50] : Colors.white,
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
                                  : Colors.black87,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          GestureDetector(
                            onTap: () => controller.viewSinglePage(index),
                            child: Icon(
                              Icons.remove_red_eye,
                              size: 18,
                              color: isSelected
                                  ? Colors.teal[700]
                                  : Colors.grey[700],
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
                      color: Colors.teal,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          blurRadius: 3,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 14,
                    ),
                  ),
                ),
              if (isExportComplete)
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

  Widget _buildExportButton(PdfToImageController controller) {
    return Obx(
          () => ElevatedButton.icon(
        onPressed: controller.isProcessing.value ||
            !controller.hasSelectedFile ||
            controller.selectedPagesToExport.isEmpty
            ? null
            : controller.exportToImages,
        icon: controller.isProcessing.value
            ? const SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Colors.white,
          ),
        )
            : const Icon(Icons.download, size: 24),
        label: Text(
          controller.isProcessing.value
              ? 'Exporting...'
              : controller.selectedPagesToExport.isNotEmpty
              ? 'Export ${controller.selectedPagesToExport.length} Page${controller.selectedPagesToExport.length > 1 ? 's' : ''}'
              : 'Export to Images',
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

  Widget _buildResetButton(PdfToImageController controller) {
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

  Widget _buildProcessingIndicator(PdfToImageController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Obx(
            () => Center(
          child: Column(
            children: [
              const CircularProgressIndicator(color: Colors.teal),
              const SizedBox(height: 16),
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
                'Exporting PDF pages to images...',
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultCard(PdfToImageController controller) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Obx(
            () => Card(
          elevation: 4,
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
                      "Export Successful!",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.teal,
                      ),
                    ),
                  ],
                ),
                const Divider(height: 24),
                _buildInfoRow(
                  'Images Exported',
                  '${controller.exportedFiles.length} image${controller.exportedFiles.length > 1 ? 's' : ''}',
                ),
                const SizedBox(height: 8),
                _buildInfoRow(
                  'Format',
                  controller.exportFormat.value == ExportFormat.png
                      ? 'PNG'
                      : 'JPG (${controller.imageQuality.value}% quality)',
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
                        controller.exportedFiles.isNotEmpty
                            ? controller.exportedFiles.first.parent.path
                            : '',
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
          width: 130,
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