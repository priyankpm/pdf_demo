import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdf_demo/compress_pdf.dart';
import 'package:pdf_demo/view/compress/compress_binding.dart';
import 'package:pdf_demo/view/compress/compress_view.dart';

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
        'name': 'Compress PDF',
        'onTap': () =>
            Get.to(() => CompressorView(), binding: CompressorBinding()),
      },
      {
        'name': 'Merge PDFs',
        'onTap': () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SuperbPdfCompressor()),
        ),
      },
      {
        'name': 'Split PDF',
        'onTap': () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SuperbPdfCompressor()),
        ),
      },
      {
        'name': 'Lock PDF',
        'onTap': () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SuperbPdfCompressor()),
        ),
      },
      {
        'name': 'Unlock PDF',
        'onTap': () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SuperbPdfCompressor()),
        ),
      },
      {
        'name': 'Image to PDF',
        'onTap': () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SuperbPdfCompressor()),
        ),
      },
      {
        'name': 'View PDF',
        'onTap': () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SuperbPdfCompressor()),
        ),
      },
      {
        'name': 'Text to PDF',
        'onTap': () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SuperbPdfCompressor()),
        ),
      },
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('PDF Utility App')),
      body: ListView.builder(
        itemCount: tools.length,
        itemBuilder: (context, index) {
          final tool = tools[index];
          return ListTile(
            title: Text(tool['name'].toString()),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: tool['onTap'] as void Function()?,
          );
        },
      ),
    );
  }
}
