import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdf_demo/view/view-pdf/view_pdf_controller.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class ViewPdf extends StatefulWidget {
  const ViewPdf({super.key});

  @override
  State<ViewPdf> createState() => _ViewPdfState();
}

class _ViewPdfState extends State<ViewPdf> {
  final controller = Get.put(ViewPdfController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Viewer'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        actions: [
          Obx(
            () => controller.selectedFile.value == null
                ? const SizedBox()
                : IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: controller.closeViewer,
                    tooltip: 'Close PDF',
                  ),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.selectedFile.value == null) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeaderCard(),
                const SizedBox(height: 20),
                _buildSelectButton(controller),
              ],
            ),
          );
        }

        return Stack(
          children: [
            SfPdfViewer.file(
              controller.selectedFile.value!,
              key: controller.pdfViewerKey,
              controller: controller.pdfController,
              onPageChanged: (details) =>
                  controller.updatePageNumber(details.newPageNumber),
              onDocumentLoaded: (details) =>
                  controller.updateTotalPages(details.document.pages.count),
            ),

            _buildZoomMenu(),

            _buildBottomBar(),

            Obx(() {
              if (controller.showZoomLevel.value) {
                return Positioned(
                  top: 20,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black87,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${(controller.zoomLevel.value * 100).toInt()}%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            }),
          ],
        );
      }),
    );
  }

  Widget _buildHeaderCard() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Icon(Icons.picture_as_pdf, size: 48, color: Colors.teal),
            const SizedBox(height: 12),
            const Text(
              'View PDF',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Preview and read your PDF files seamlessly',
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectButton(ViewPdfController controller) {
    return ElevatedButton.icon(
      onPressed: controller.pickAndOpenPdf,
      icon: const Icon(Icons.folder_open),
      label: const Text('Select PDF from File Manager'),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        textStyle: const TextStyle(fontSize: 16),
      ),
    );
  }

  Widget _buildBottomBar() {
    return Obx(() {
      final isSinglePage = controller.totalPages.value <= 1;
      final isFirstPage = controller.currentPage.value <= 1;
      final isLastPage =
          controller.currentPage.value >= controller.totalPages.value;

      const activeColor = Colors.teal;
      final disabledColor = Colors.grey.shade400;

      if (isSinglePage) return const SizedBox.shrink();

      return Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(color: Colors.teal),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: isFirstPage ? null : controller.previousPage,
                icon: Icon(
                  Icons.chevron_left,
                  size: 28,
                  color: isFirstPage
                      ? Colors.white.withValues(alpha: 0.4)
                      : Colors.white,
                ),
                color: isFirstPage ? disabledColor : activeColor,
                tooltip: 'Previous page',
              ),

              // 📄 Page Counter
              Expanded(
                child: Center(
                  child: Text(
                    'Page ${controller.currentPage.value} / ${controller.totalPages.value}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              IconButton(
                onPressed: isLastPage ? null : controller.nextPage,
                icon: Icon(
                  Icons.chevron_right,
                  size: 28,
                  color: isLastPage
                      ? Colors.white.withValues(alpha: 0.4)
                      : Colors.white,
                ),
                color: isLastPage ? disabledColor : activeColor,
                tooltip: 'Next page',
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildZoomMenu() {
    return Obx(() {
      final isMinZoom = controller.zoomLevel.value <= 1.0;
      final isMaxZoom = controller.zoomLevel.value >= 3.0;

      const activeColor = Colors.teal;
      final disabledColor = Colors.grey.shade400;

      return Positioned(
        right: 16,
        bottom: 100,
        child: Column(
          children: [
            FloatingActionButton(
              heroTag: 'zoom_in_btn',
              onPressed: isMaxZoom ? null : controller.zoomIn,
              backgroundColor: isMaxZoom ? disabledColor : activeColor,
              tooltip: 'Zoom in',
              child: const Icon(Icons.zoom_in, color: Colors.white),
            ),
            const SizedBox(height: 12),
            FloatingActionButton(
              heroTag: 'zoom_out_btn',
              onPressed: isMinZoom ? null : controller.zoomOut,
              backgroundColor: isMinZoom ? disabledColor : activeColor,
              tooltip: 'Zoom out',
              child: const Icon(Icons.zoom_out, color: Colors.white),
            ),
          ],
        ),
      );
    });
  }
}
