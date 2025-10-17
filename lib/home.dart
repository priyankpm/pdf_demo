import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdf_demo/view/compress-pdf/compress_pdf.dart';
import 'package:pdf_demo/view/delete-pdf/delete_pdf.dart';
import 'package:pdf_demo/view/image-pdf/image_pdf.dart';
import 'package:pdf_demo/view/reordr-pdf/reorder_pdf.dart';
import 'package:pdf_demo/view/split-pdf/split_pdf.dart';
import 'package:pdf_demo/view/text-pdf/text_pdf.dart';
import 'package:pdf_demo/view/view-pdf/view_pdf.dart';
import 'view/extractimage-pdf/extract_image_pdf.dart';
import 'view/lock-pdf/lock_pdf.dart';
import 'view/merge-pdf/merge_pdf.dart';
import 'view/resize-pdf/resize_pdf.dart';
import 'view/rotate-pdf/rotate_pdf.dart';
import 'view/unlock-pdf/unlock_pdf.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    final tools = [
      {
        'icon': Icons.compress,
        'name': 'Compress PDF',
        'desc': 'Reduce file size with quality control',
        'onTap': () => Get.to(() => const CompressPdf()),
      },
      {
        'icon': Icons.merge_type,
        'name': 'Merge PDFs',
        'desc': 'Combine multiple PDFs into one',
        'onTap': () => Get.to(() => const MergePdf()),
      },
      {
        'icon': Icons.call_split,
        'name': 'Split PDF',
        'desc': 'Separate pages from a PDF',
        'onTap': () => Get.to(() => const SplitPdf()),
      },
      {
        'icon': Icons.lock,
        'name': 'Lock PDF',
        'desc': 'Protect your PDF with a password',
        'onTap': () => Get.to(() => const LockPdf()),
      },
      {
        'icon': Icons.lock_open,
        'name': 'Unlock PDF',
        'desc': 'Remove password protection',
        'onTap': () => Get.to(() => const UnlockPdf()),
      },
      {
        'icon': Icons.image,
        'name': 'Image to PDF',
        'desc': 'Convert images into a single PDF',
        'onTap': () => Get.to(() => const ImageToPdf()),
      },
      {
        'icon': Icons.picture_as_pdf,
        'name': 'View PDF',
        'desc': 'Preview or open your PDF files',
        'onTap': () => Get.to(() => const ViewPdf()),
      },
      {
        'icon': Icons.text_fields,
        'name': 'Text to PDF',
        'desc': 'Generate PDFs from text documents',
        'onTap': () => Get.to(() => const TextToPdf()),
      },
      {
        'icon': Icons.photo_size_select_small_sharp,
        'name': 'Resize PDF',
        'desc': 'Convert PDF to different paper sizes',
        'onTap': () => Get.to(() => const ResizePdf()),
      },
      {
        'icon': Icons.rotate_right,
        'name': 'Rotate PDF',
        'desc': 'Rotate pages clockwise or counterclockwise',
        'onTap': () => Get.to(() => const RotatePdf()),
      },
      {
        'icon': Icons.reorder,
        'name': 'Reorder Pages',
        'desc': 'Rearrange PDF pages in custom order',
        'onTap': () => Get.to(() => const ReorderPdf()),
      },
      {
        'icon': Icons.delete_outline,
        'name': 'Delete Pages',
        'desc': 'Remove specific pages from PDF',
        'onTap': () => Get.to(() => const DeletePdf()),
      },
      // {
      //   'icon': Icons.image_search,
      //   'name': 'Extract Images',
      //   'desc': 'Export all images from PDF',
      //   'onTap': () => Get.to(() => const ExtractImages()),
      // },
      // {
      //   'icon': Icons.text_snippet,
      //   'name': 'Extract Text',
      //   'desc': 'Copy all text content from PDF',
      //   'onTap': () => Get.to(() => const ExtractText()),
      // },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 2,
      ),
      body: Container(
        width: double.infinity,
        color: Colors.grey[100],
        padding: const EdgeInsets.all(14),
        child: ListView.builder(
          itemCount: tools.length,
          itemBuilder: (context, index) {
            final tool = tools[index];
            return _buildToolCard(
              icon: tool['icon'] as IconData,
              title: tool['name'] as String,
              desc: tool['desc'] as String,
              onTap: tool['onTap'] as VoidCallback,
            );
          },
        ),
      ),
    );
  }

  Widget _buildToolCard({
    required IconData icon,
    required String title,
    required String desc,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.teal[100],
                radius: 24,
                child: Icon(icon, color: Colors.teal[700], size: 26),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      desc,
                      style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
