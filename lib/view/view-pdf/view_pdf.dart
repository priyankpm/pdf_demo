import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdf_demo/view/view-pdf/view_pdf_controller.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class ViewPdf extends StatefulWidget {
  const ViewPdf({super.key});

  @override
  State<ViewPdf> createState() => _ViewPdfState();
}

class _ViewPdfState extends State<ViewPdf> with SingleTickerProviderStateMixin {
  final controller = Get.put(ViewPdfController());
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
        if (controller.selectedFile.value == null) {
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
                      _buildEmptyState(),
                    ],
                  ),
                ),
              ),
            ],
          );
        }

        return Column(
          children: [
            _buildViewerHeader(),
            Expanded(
              child: Stack(
                children: [
                  // PDF Viewer with subtle padding
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 20,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: SfPdfViewer.file(
                          controller.selectedFile.value!,
                          key: controller.pdfViewerKey,
                          controller: controller.pdfController,
                          onPageChanged: (details) =>
                              controller.updatePageNumber(details.newPageNumber),
                          onDocumentLoaded: (details) =>
                              controller.updateTotalPages(details.document.pages.count),
                        ),
                      ),
                    ),
                  ),

                  // Floating Control Panel
                  _buildFloatingControlPanel(),

                  // Zoom Menu
                  _buildZoomMenu(),

                  // Bottom Navigation Bar
                  _buildBottomBar(),

                  // Zoom Level Indicator
                  _buildZoomLevelIndicator(),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  // Premium Header for Empty State
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
                          Icons.picture_as_pdf_rounded,
                          color: Colors.white,
                          size: 36,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'View PDF',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Read and preview documents',
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

  // Compact Header for Viewer Mode
  Widget _buildViewerHeader() {
    return Container(
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
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white, size: 22),
                  onPressed: () => Get.back(),
                  tooltip: 'Back',
                ),
              ),
              const SizedBox(width: 12),
              const Icon(Icons.picture_as_pdf, color: Colors.white, size: 22),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'PDF Viewer',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white, size: 22),
                  onPressed: controller.closeViewer,
                  tooltip: 'Close PDF',
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
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        elevation: 4,
        shadowColor: Colors.black.withValues(alpha: 0.1),
        child: InkWell(
          onTap: controller.pickAndOpenPdf,
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
                  child: const Icon(
                    Icons.folder_open_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 14),
                Text(
                  'Select PDF File',
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
                Icons.insert_drive_file_rounded,
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
              'Select a PDF file to preview and read',
              style: TextStyle(fontSize: 15, color: Colors.grey[500]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
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
                  _buildFeatureItem(
                    Icons.zoom_in_rounded,
                    'Zoom Controls',
                    'Pinch to zoom or use zoom buttons',
                  ),
                  const SizedBox(height: 16),
                  _buildFeatureItem(
                    Icons.navigate_next_rounded,
                    'Page Navigation',
                    'Swipe or use buttons to navigate',
                  ),
                  const SizedBox(height: 16),
                  _buildFeatureItem(
                    Icons.fullscreen_rounded,
                    'Full Screen View',
                    'Immersive reading experience',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String title, String description) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.teal.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: Colors.teal.shade700, size: 24),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: TextStyle(fontSize: 13, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Bottom Navigation Bar - Enhanced
  Widget _buildBottomBar() {
    return Obx(() {
      final isSinglePage = controller.totalPages.value <= 1;
      final isFirstPage = controller.currentPage.value <= 1;
      final isLastPage =
          controller.currentPage.value >= controller.totalPages.value;

      if (isSinglePage) return const SizedBox.shrink();

      return Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white.withValues(alpha: 0.95),
                Colors.white.withValues(alpha: 0.9),
              ],
            ),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Previous Button
              _buildNavButton(
                icon: Icons.skip_previous_rounded,
                label: 'Prev',
                isDisabled: isFirstPage,
                onTap: controller.previousPage,
              ),

              // Page Indicator
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.teal.shade400, Colors.teal.shade600],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.teal.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.article_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${controller.currentPage.value}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        ' / ${controller.totalPages.value}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Next Button
              _buildNavButton(
                icon: Icons.skip_next_rounded,
                label: 'Next',
                isDisabled: isLastPage,
                onTap: controller.nextPage,
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildNavButton({
    required IconData icon,
    required String label,
    required bool isDisabled,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isDisabled ? null : onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isDisabled
                ? Colors.grey.shade200
                : Colors.teal.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDisabled
                  ? Colors.grey.shade300
                  : Colors.teal.withValues(alpha: 0.3),
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: isDisabled ? Colors.grey.shade400 : Colors.teal.shade700,
                size: 22,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: isDisabled ? Colors.grey.shade400 : Colors.teal.shade700,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Floating Control Panel
  Widget _buildFloatingControlPanel() {
    return Positioned(
      top: 16,
      left: 16,
      child: Obx(() {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white.withValues(alpha: 0.95),
                Colors.white.withValues(alpha: 0.9),
              ],
            ),
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 20,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.picture_as_pdf_rounded,
                color: Colors.teal.shade600,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Page ${controller.currentPage.value}',
                style: TextStyle(
                  color: Colors.teal.shade700,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                '/ ${controller.totalPages.value}',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 13,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  // Zoom Menu - Enhanced
  Widget _buildZoomMenu() {
    return Obx(() {
      final isMinZoom = controller.zoomLevel.value <= 1.0;
      final isMaxZoom = controller.zoomLevel.value >= 3.0;

      return Positioned(
        right: 16,
        top: 16,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withValues(alpha: 0.95),
                Colors.white.withValues(alpha: 0.9),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 20,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: isMaxZoom ? null : controller.zoomIn,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      gradient: isMaxZoom
                          ? null
                          : LinearGradient(
                        colors: [
                          Colors.teal.shade400,
                          Colors.teal.shade600,
                        ],
                      ),
                      color: isMaxZoom ? Colors.grey.shade300 : null,
                    ),
                    child: Icon(
                      Icons.add_rounded,
                      color: isMaxZoom ? Colors.grey.shade500 : Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ),
              Container(
                width: 50,
                height: 1,
                color: Colors.grey.shade300,
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  '${(controller.zoomLevel.value * 100).toInt()}%',
                  style: TextStyle(
                    color: Colors.teal.shade700,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              Container(
                width: 50,
                height: 1,
                color: Colors.grey.shade300,
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: isMinZoom ? null : controller.zoomOut,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                      gradient: isMinZoom
                          ? null
                          : LinearGradient(
                        colors: [
                          Colors.teal.shade400,
                          Colors.teal.shade600,
                        ],
                      ),
                      color: isMinZoom ? Colors.grey.shade300 : null,
                    ),
                    child: Icon(
                      Icons.remove_rounded,
                      color: isMinZoom ? Colors.grey.shade500 : Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  // Zoom Level Indicator - Enhanced
  Widget _buildZoomLevelIndicator() {
    return Obx(() {
      if (!controller.showZoomLevel.value) return const SizedBox.shrink();

      return Positioned(
        bottom: 100,
        left: 0,
        right: 0,
        child: Center(
          child: TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 300),
            tween: Tween(begin: 0.0, end: 1.0),
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: Opacity(
                  opacity: value,
                  child: child,
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withValues(alpha: 0.95),
                    Colors.white.withValues(alpha: 0.9),
                  ],
                ),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: Colors.teal.withValues(alpha: 0.3),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.teal.shade400, Colors.teal.shade600],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.zoom_in_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '${(controller.zoomLevel.value * 100).toInt()}%',
                    style: TextStyle(
                      color: Colors.teal.shade700,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}