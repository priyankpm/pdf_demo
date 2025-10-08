import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:image/image.dart' as img;

class SuperbPdfCompressor extends StatefulWidget {
  const SuperbPdfCompressor({super.key});

  @override
  State<SuperbPdfCompressor> createState() => _SuperbPdfCompressorState();
}

class _SuperbPdfCompressorState extends State<SuperbPdfCompressor> {
  File? selectedFile;
  File? compressedFile;
  int? originalSize;
  int? compressedSize;
  bool processing = false;
  String processingStatus = '';
  String selectedQuality = 'Medium';

  Future<void> _pickPDF() async {
    setState(() {
      compressedFile = null;
      compressedSize = null;
    });

    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null && result.files.single.path != null) {
        final f = File(result.files.single.path!);
        setState(() {
          selectedFile = f;
          originalSize = f.lengthSync();
        });
      }
    } catch (e) {
      _showSnack("Error picking file: $e");
    }
  }

  String _formatSize(int bytes) {
    double kb = bytes / 1024;
    double mb = kb / 1024;
    if (mb >= 1) return "${mb.toStringAsFixed(2)} MB";
    return "${kb.toStringAsFixed(2)} KB";
  }

  int _getImageQuality() {
    switch (selectedQuality) {
      case 'Normal':
        return 85;
      case 'Best':
        return 50;
      default:
        return 70;
    }
  }

  double _getDPI() {
    switch (selectedQuality) {
      case 'Normal':
        return 150.0;
      case 'Best':
        return 100.0;
      default:
        return 120.0;
    }
  }

  void _showSnack(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  double _savedPercent() {
    if (originalSize == null || compressedSize == null) return 0;
    return (1 - (compressedSize! / originalSize!)) * 100;
  }

  Future<void> _superCompressPdf() async {
    if (selectedFile == null) return;

    setState(() {
      processing = true;
      compressedFile = null;
      compressedSize = null;
      processingStatus = 'Loading PDF...';
    });

    try {
      final bytes = await selectedFile!.readAsBytes();
      final dpi = _getDPI();
      final quality = _getImageQuality();

      setState(() {
        processingStatus = 'Rendering pages at ${dpi.toInt()} DPI...';
      });

      final pageImages = Printing.raster(bytes, dpi: dpi);

      final pdf = pw.Document(compress: true, version: PdfVersion.pdf_1_5);

      int pageCount = 0;
      await for (final page in pageImages) {
        pageCount++;
        setState(() {
          processingStatus = 'Compressing page $pageCount...';
        });

        // Convert page to PNG
        final imageBytes = await page.toPng();

        // Decode and compress the image
        final originalImage = img.decodeImage(imageBytes);
        if (originalImage == null) {
          debugPrint('Failed to decode page $pageCount');
          continue;
        }

        // Compress image with quality setting
        final compressedImageBytes = img.encodeJpg(
          originalImage,
          quality: quality,
        );

        // Add compressed page to PDF
        pdf.addPage(
          pw.Page(
            pageFormat: PdfPageFormat(
              double.parse("${page.width}"),
              double.parse("${page.height}"),
              marginAll: 0,
            ),
            build: (context) {
              return pw.Image(
                pw.MemoryImage(Uint8List.fromList(compressedImageBytes)),
                fit: pw.BoxFit.fill,
              );
            },
          ),
        );

        // Small delay for UI updates
        await Future.delayed(const Duration(milliseconds: 10));
      }

      setState(() {
        processingStatus = 'Saving compressed PDF...';
      });

      // Save the compressed PDF
      final output = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = selectedFile!.path
          .split(Platform.pathSeparator)
          .last
          .replaceAll('.pdf', '');
      final outputPath =
          '${output.path}${Platform.pathSeparator}${fileName}_compressed_$timestamp.pdf';

      final outputFile = File(outputPath);
      final pdfBytes = await pdf.save();
      await outputFile.writeAsBytes(pdfBytes);

      final finalSize = outputFile.lengthSync();

      setState(() {
        compressedFile = outputFile;
        compressedSize = finalSize;
        processing = false;
        processingStatus = '';
      });

      if (finalSize < originalSize!) {
        final saved = ((1 - (finalSize / originalSize!)) * 100).toStringAsFixed(
          1,
        );
        _showSnack("PDF compressed successfully! Saved $saved%");
      } else {
        _showSnack("PDF processed (file may already be optimized)");
      }
    } catch (e) {
      setState(() {
        processing = false;
        processingStatus = '';
      });
      _showSnack("Error compressing PDF: $e");
      debugPrint("Compression error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Superb PDF Compressor'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Icon(Icons.compress, size: 48, color: Colors.blue),
                      const SizedBox(height: 12),
                      const Text(
                        'PDF Compressor',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Reduce PDF file size with quality control',
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: processing ? null : _pickPDF,
                icon: const Icon(Icons.folder_open),
                label: const Text('Select PDF File'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  textStyle: const TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(height: 20),
              if (selectedFile != null) ...[
                Card(
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
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 20),
                        _buildInfoRow(
                          'Filename',
                          selectedFile!.path.split(Platform.pathSeparator).last,
                        ),
                        const SizedBox(height: 8),
                        _buildInfoRow(
                          'Original Size',
                          originalSize != null
                              ? _formatSize(originalSize!)
                              : '--',
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Compression Quality",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        RadioGroup<String>(
                          groupValue: selectedQuality,
                          onChanged: processing
                              ? (_) {}
                              : (v) => setState(() => selectedQuality = v!),
                          child: Column(
                            children: [
                              RadioListTile<String>(
                                value: 'Normal',
                                title: const Text('Normal Quality'),
                                subtitle: const Text(
                                  '150 DPI, 85% quality - Better appearance',
                                ),
                                dense: true,
                                contentPadding: EdgeInsets.zero,
                              ),
                              RadioListTile<String>(
                                value: 'Medium',
                                title: const Text('Medium Quality'),
                                subtitle: const Text(
                                  '120 DPI, 70% quality - Balanced',
                                ),
                                dense: true,
                                contentPadding: EdgeInsets.zero,
                              ),
                              RadioListTile<String>(
                                value: 'Best',
                                title: const Text('Maximum Compression'),
                                subtitle: const Text(
                                  '100 DPI, 50% quality - Smallest file',
                                ),
                                dense: true,
                                contentPadding: EdgeInsets.zero,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 56,
                  child: ElevatedButton.icon(
                    onPressed: processing ? null : _superCompressPdf,
                    icon: processing
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.compress, size: 24),
                    label: Text(
                      processing ? 'Compressing...' : 'Compress PDF',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
              if (processing) ...[
                const SizedBox(height: 30),
                Center(
                  child: Column(
                    children: [
                      const CircularProgressIndicator(strokeWidth: 3),
                      const SizedBox(height: 16),
                      Text(
                        processingStatus,
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
              ],
              if (compressedFile != null) ...[
                const SizedBox(height: 20),
                Card(
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
                              "Compression Complete!",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 24),
                        _buildInfoRow(
                          'Compressed File',
                          compressedFile!.path
                              .split(Platform.pathSeparator)
                              .last,
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: _buildStatCard(
                                'Original',
                                _formatSize(originalSize!),
                                Colors.blue,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildStatCard(
                                'Compressed',
                                _formatSize(compressedSize!),
                                Colors.green,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.green[100],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.trending_down,
                                color: Colors.green[900],
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "Saved: ${_savedPercent().toStringAsFixed(1)}%",
                                style: TextStyle(
                                  color: Colors.green[900],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
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
                                compressedFile!.path,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              if (selectedFile == null && !processing) ...[
                const SizedBox(height: 40),
                Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.upload_file,
                        size: 80,
                        color: Colors.grey[300],
                      ),
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
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
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
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color.withValues(alpha: 0.7),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              color: color.withValues(alpha: 0.9),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}