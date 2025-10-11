import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdf_demo/view/merge-pdf/merge_pdf_controller.dart';

class MergePdf extends StatefulWidget {
  const MergePdf({super.key});

  @override
  State<MergePdf> createState() => _MergePdfState();
}

class _MergePdfState extends State<MergePdf> {
  final controller = Get.put(MergePdfController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('PDF Merger'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
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
                    () => controller.hasSelectedFiles
                    ? _buildSelectedFilesSection(controller)
                    : _buildEmptyState(),
              ),
            ],
          ),
        ),
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
            const Icon(Icons.merge_type, size: 48, color: Colors.teal),
            const SizedBox(height: 12),
            const Text(
              'PDF Merger',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Combine multiple PDF files into a single document',
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectButton(MergePdfController controller) {
    return Obx(
          () => ElevatedButton.icon(
        onPressed: controller.isProcessing.value
            ? null
            : controller.pickPdfFiles,
        icon: const Icon(Icons.add),
        label: Text(
          controller.hasSelectedFiles
              ? 'Add More PDF Files'
              : 'Select PDF Files',
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

  Widget _buildSelectedFilesSection(MergePdfController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildFilesListCard(controller),
        const SizedBox(height: 20),
        _buildMergeButton(controller),
        Obx(
              () => controller.isProcessing.value
              ? _buildProcessingIndicator(controller)
              : const SizedBox.shrink(),
        ),
        Obx(
              () => controller.hasMergedFile
              ? _buildResultCard(controller)
              : const SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _buildFilesListCard(MergePdfController controller) {
    return Obx(
          () => Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.list_alt, color: Colors.teal[700]),
                      const SizedBox(width: 8),
                      const Text(
                        "Selected Files",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ],
                  ),
                  Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.teal[100],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${controller.selectedFiles.length} files',
                      style: TextStyle(
                        color: Colors.teal[900],
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(height: 20),
              Text(
                'Drag to reorder • Swipe to remove',
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
              const SizedBox(height: 12),
              ReorderableListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.selectedFiles.length,
                onReorder: (oldIndex, newIndex) {
                  if (!controller.isProcessing.value) {
                    controller.reorderFiles(oldIndex, newIndex);
                  }
                },
                itemBuilder: (context, index) {
                  final file = controller.selectedFiles[index];
                  return Dismissible(
                    key: Key(file.path),
                    direction: controller.isProcessing.value
                        ? DismissDirection.none
                        : DismissDirection.endToStart,
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      color: Colors.red,
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    onDismissed: (direction) {
                      controller.removeFile(index);
                    },
                    child: Card(
                      key: Key(file.path),
                      margin: const EdgeInsets.only(bottom: 8),
                      color: Colors.teal[50],
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.teal[700],
                          foregroundColor: Colors.white,
                          child: Text('${index + 1}'),
                        ),
                        title: Text(
                          controller.getFileName(file),
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          controller.getFileSize(file),
                          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                        ),
                        trailing: Icon(Icons.drag_handle, color: Colors.grey[400]),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, size: 16, color: Colors.grey[700]),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Total Size: ${controller.totalSize}',
                        style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                      ),
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

  Widget _buildMergeButton(MergePdfController controller) {
    return Obx(
          () => ElevatedButton.icon(
        onPressed: controller.isProcessing.value ||
            controller.selectedFiles.length < 2
            ? null
            : controller.mergePdfs,
        icon: controller.isProcessing.value
            ? const SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Colors.white,
          ),
        )
            : const Icon(Icons.merge_type, size: 24),
        label: Text(
          controller.isProcessing.value
              ? 'Merging...'
              : controller.selectedFiles.length < 2
              ? 'Select at least 2 files'
              : 'Merge PDFs',
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

  Widget _buildProcessingIndicator(MergePdfController controller) {
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
                'Combining PDF files...',
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultCard(MergePdfController controller) {
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
                      "PDFs Merged Successfully!",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.teal,
                      ),
                    ),
                  ],
                ),
                const Divider(height: 24),
                _buildInfoRow('Merged File', controller.mergedFileName),
                const SizedBox(height: 8),
                _buildInfoRow('File Size', controller.mergedFileSize),
                const SizedBox(height: 8),
                _buildInfoRow(
                    'Total Pages', '${controller.totalPagesMerged} pages'),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.teal[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.merge_type, color: Colors.teal[900]),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "Combined ${controller.selectedFiles.length} files into one PDF",
                          style: TextStyle(
                            color: Colors.teal[900],
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
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
                        controller.mergedFilePath,
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
              'No PDFs selected',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Click "Select PDF Files" to begin',
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
          width: 110,
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