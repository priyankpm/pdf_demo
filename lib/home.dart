import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdf_demo/view/compress/compress_pdf.dart';
import 'package:pdf_demo/view/text-pdf/text_pdf.dart';
import 'package:pdf_demo/view/view/view_pdf.dart';

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
        'onTap': () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const CompressPdf()),
        ),
      },
      {
        'icon': Icons.call_split,
        'name': 'Split PDF',
        'desc': 'Separate pages from a PDF',
        'onTap': () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const CompressPdf()),
        ),
      },
      {
        'icon': Icons.lock,
        'name': 'Lock PDF',
        'desc': 'Protect your PDF with a password',
        'onTap': () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const CompressPdf()),
        ),
      },
      {
        'icon': Icons.lock_open,
        'name': 'Unlock PDF',
        'desc': 'Remove password protection',
        'onTap': () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const CompressPdf()),
        ),
      },
      {
        'icon': Icons.image,
        'name': 'Image to PDF',
        'desc': 'Convert images into a single PDF',
        'onTap': () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const CompressPdf()),
        ),
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
