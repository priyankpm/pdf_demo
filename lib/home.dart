import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdf_demo/view/compress-pdf/compress_pdf.dart';
import 'package:pdf_demo/view/convert-text-pdf/convert_text_pdf.dart';
import 'package:pdf_demo/view/delete-pdf/delete_pdf.dart';
import 'package:pdf_demo/view/image-pdf/image_pdf.dart';
import 'package:pdf_demo/view/pdf-image/pdf_image.dart';
import 'package:pdf_demo/view/reordr-pdf/reorder_pdf.dart';
import 'package:pdf_demo/view/split-pdf/split_pdf.dart';
import 'package:pdf_demo/view/text-pdf/text_pdf.dart';
import 'package:pdf_demo/view/view-pdf/view_pdf.dart';
import 'view/extracttext-pdf/extract_text_pdf.dart';
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

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
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
    final popularTools = [
      {
        'icon': Icons.merge_type_rounded,
        'name': 'Merge',
        'desc': 'Combine PDFs',
        'gradient': [Color(0xFF667eea), Color(0xFF764ba2)],
        'onTap': () => Get.to(() => const MergePdf()),
      },
      {
        'icon': Icons.compress_rounded,
        'name': 'Compress',
        'desc': 'Reduce size',
        'gradient': [Color(0xFFf093fb), Color(0xFFF5576C)],
        'onTap': () => Get.to(() => const CompressPdf()),
      },
      {
        'icon': Icons.call_split_rounded,
        'name': 'Split',
        'desc': 'Separate pages',
        'gradient': [Color(0xFF4facfe), Color(0xFF00f2fe)],
        'onTap': () => Get.to(() => const SplitPdf()),
      },
      {
        'icon': Icons.image_rounded,
        'name': 'Images',
        'desc': 'To PDF',
        'gradient': [Color(0xFF5F6368), Color(0xFF202124)],
        'onTap': () => Get.to(() => const ImageToPdf()),
      },
    ];

    final allTools = [
      {
        'icon': Icons.collections_rounded,
        'name': 'PDF to Image',
        'desc': 'Extract as images',
        'onTap': () => Get.to(() => const PdfToImage()),
      },
      {
        'icon': Icons.text_fields_rounded,
        'name': 'Text to PDF',
        'desc': 'Create from text',
        'onTap': () => Get.to(() => const TextToPdf()),
      },
      {
        'icon': Icons.lock_rounded,
        'name': 'Lock PDF',
        'desc': 'Add password',
        'onTap': () => Get.to(() => const LockPdf()),
      },
      {
        'icon': Icons.lock_open_rounded,
        'name': 'Unlock PDF',
        'desc': 'Remove password',
        'onTap': () => Get.to(() => const UnlockPdf()),
      },
      {
        'icon': Icons.visibility_rounded,
        'name': 'View PDF',
        'desc': 'Preview files',
        'onTap': () => Get.to(() => const ViewPdf()),
      },
      {
        'icon': Icons.sync_alt_rounded,
        'name': 'Convert .txt',
        'desc': 'Text conversion',
        'onTap': () => Get.to(() => const ConvertTextPdf()),
      },
      {
        'icon': Icons.photo_size_select_large_rounded,
        'name': 'Resize PDF',
        'desc': 'Change size',
        'onTap': () => Get.to(() => const ResizePdf()),
      },
      {
        'icon': Icons.rotate_right_rounded,
        'name': 'Rotate PDF',
        'desc': 'Rotate pages',
        'onTap': () => Get.to(() => const RotatePdf()),
      },
      {
        'icon': Icons.reorder_rounded,
        'name': 'Reorder',
        'desc': 'Rearrange pages',
        'onTap': () => Get.to(() => const ReorderPdf()),
      },
      {
        'icon': Icons.delete_sweep_rounded,
        'name': 'Delete Pages',
        'desc': 'Remove pages',
        'onTap': () => Get.to(() => const DeletePdf()),
      },
      {
        'icon': Icons.text_snippet_rounded,
        'name': 'Extract Text',
        'desc': 'Copy text',
        'onTap': () => Get.to(() => const ExtractText()),
      },
    ];

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          // Amazing App Bar
          _buildAmazingAppBar(),

          // Content
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),

                  // Quick Access Section
                  _buildSectionHeader(
                    icon: Icons.bolt_rounded,
                    title: 'Quick Access',
                    gradientColors: [
                      Colors.amber.shade400,
                      Colors.orange.shade500,
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Popular Tools Grid (2x2)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 1.15,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                      padding: EdgeInsets.zero,
                      itemCount: popularTools.length,
                      itemBuilder: (context, index) {
                        final tool = popularTools[index];
                        return _buildAnimatedCard(
                          delay: index * 100,
                          child: _buildGradientCard(
                            icon: tool['icon'] as IconData,
                            name: tool['name'] as String,
                            desc: tool['desc'] as String,
                            gradient: tool['gradient'] as List<Color>,
                            onTap: tool['onTap'] as VoidCallback,
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 20),

                  _buildSectionHeader(
                    icon: Icons.apps_rounded,
                    title: 'All Tools',
                    gradientColors: [
                      Colors.red.shade400,
                      Colors.red.shade700,
                    ],
                  ),
                  SizedBox(height: 16),
                  // All Tools Grid (2 columns)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: GridView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 1.5,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                      itemCount: allTools.length,
                      itemBuilder: (context, index) {
                        final tool = allTools[index];
                        return _buildAnimatedCard(
                          delay: index * 50,
                          child: _buildCompactToolCard(
                            icon: tool['icon'] as IconData,
                            name: tool['name'] as String,
                            desc: tool['desc'] as String,
                            onTap: tool['onTap'] as VoidCallback,
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Amazing App Bar
  Widget _buildAmazingAppBar() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.teal.shade400,
            Colors.teal.shade600,
            Colors.cyan.shade700,
          ],
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
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.25),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.3),
                            width: 2,
                          ),
                        ),
                        child: const Icon(
                          Icons.picture_as_pdf_rounded,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'PDF Master',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                          Text(
                            'All-in-one PDF toolkit',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.white.withValues(alpha: 0.9),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.3),
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.folder_special_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '15 Tools',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Section Header
  Widget _buildSectionHeader({
    required IconData icon,
    required String title,
    required List<Color> gradientColors,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: gradientColors),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: gradientColors[0].withValues(alpha: 0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }

  // Animated Card Wrapper
  Widget _buildAnimatedCard({required int delay, required Widget child}) {
    return TweenAnimationBuilder(
      duration: Duration(milliseconds: 500 + delay),
      tween: Tween<double>(begin: 0, end: 1),
      curve: Curves.easeOutCubic,
      builder: (context, double value, _) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 30 * (1 - value)),
            child: child,
          ),
        );
      },
    );
  }

  // Gradient Card for Popular Tools
  Widget _buildGradientCard({
    required IconData icon,
    required String name,
    required String desc,
    required List<Color> gradient,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: gradient,
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: gradient[0].withValues(alpha: 0.4),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Background Circle
              Positioned(
                right: -25,
                top: -25,
                child: Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.15),
                  ),
                ),
              ),
              // Content
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.25),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(icon, color: Colors.white, size: 32),
                    ),
                    const Spacer(),
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      desc,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white.withValues(alpha: 0.9),
                        fontWeight: FontWeight.w500,
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

  // Compact Tool Card
  Widget _buildCompactToolCard({
    required IconData icon,
    required String name,
    required String desc,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      elevation: 2,
      shadowColor: Colors.black.withValues(alpha: 0.08),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.teal.shade300, Colors.teal.shade600],
                  ),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.teal.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(icon, color: Colors.white, size: 24),
              ),
              const Spacer(),
              Text(
                name,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  letterSpacing: 0.2,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 3),
              Text(
                desc,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
