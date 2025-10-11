import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdf_demo/view/image-pdf/image_pdf_controller.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart';

class ImageToPdf extends StatefulWidget {
  const ImageToPdf({super.key});

  @override
  State<ImageToPdf> createState() => _ImageToPdfState();
}

class _ImageToPdfState extends State<ImageToPdf> {
  final controller = Get.put(ImageToPdfController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Image to PDF'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
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
                      () => controller.hasImages
                          ? _buildImagesSection(controller)
                          : _buildEmptyState(),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Obx(
            () => controller.hasImages
                ? _buildBottomBar(controller)
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Icon(Icons.image, size: 48, color: Colors.teal),
            const SizedBox(height: 12),
            const Text(
              'Image to PDF Converter',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Select multiple images and convert them into a single PDF',
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectButton(ImageToPdfController controller) {
    return Obx(
      () => ElevatedButton.icon(
        onPressed: controller.isProcessing.value ? null : controller.pickImages,
        icon: const Icon(Icons.add_photo_alternate),
        label: Text(controller.hasImages ? 'Add More Images' : 'Select Images'),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
          textStyle: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildImagesSection(ImageToPdfController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          elevation: 2,
          color: Colors.teal[50],
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(Icons.collections, color: Colors.teal[700]),
                const SizedBox(width: 8),
                Obx(
                  () => Text(
                    '${controller.imageCount} Image${controller.imageCount > 1 ? 's' : ''} Selected',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  'Long press & drag to reorder',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Obx(
          () => ReorderableGridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.75,
            onReorder: controller.reorderImages,
            children: List.generate(
              controller.imageCount,
              (index) => _buildImageCard(
                controller,
                index,
                key: ValueKey(controller.images[index].path),
              ),
            ),
          ),
        ),
        const SizedBox(height: 100),
      ],
    );
  }

  Widget _buildImageCard(
    ImageToPdfController controller,
    int index, {
    required Key key,
  }) {
    return Card(
      key: key,
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.file(controller.images[index], fit: BoxFit.cover),
          Positioned(
            top: 4,
            left: 4,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.teal,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${index + 1}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
          Positioned(
            top: 4,
            right: 4,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(15),
              ),
              child: IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 30, minHeight: 30),
                icon: const Icon(Icons.close, size: 18, color: Colors.white),
                onPressed: () => controller.removeImage(index),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(ImageToPdfController controller) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: SafeArea(
        child: Obx(
          () => ElevatedButton.icon(
            onPressed: controller.isProcessing.value
                ? null
                : controller.convertToPdf,
            icon: controller.isProcessing.value
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.picture_as_pdf, size: 24),
            label: Text(
              controller.isProcessing.value
                  ? controller.processingStatus.value
                  : 'Convert to PDF',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: Colors.teal,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 54),
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
            Icon(Icons.add_photo_alternate, size: 80, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(
              'No images selected',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Click "Select Images" to begin',
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            ),
          ],
        ),
      ),
    );
  }
}
