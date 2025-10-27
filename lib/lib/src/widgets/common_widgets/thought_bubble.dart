import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_drawing/path_drawing.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../../common_utility/common_utility.dart';

class CloudWithText extends StatelessWidget {
  final String? text;
  final List<String>? imagePaths;
  final double padding;
  final double minWidth;

  const CloudWithText({
    super.key,
    this.text,
    this.imagePaths,
    this.padding = 24,
    this.minWidth = 150,
  }) : assert(text != null || imagePaths != null, 'Either text or imagePaths must be provided');

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        Widget contentWidget;
        double contentWidth;
        double contentHeight;

        if (imagePaths != null && imagePaths!.isNotEmpty) {
          // Image content - handle both asset and file images
          contentWidth = constraints.maxWidth * 0.7;
          contentHeight = contentWidth * (9 / 30);
          contentWidget = CarouselSlider(
            options: CarouselOptions(
              autoPlay: true,
              aspectRatio: 4 / 3,
              enlargeCenterPage: true,
              viewportFraction: 0.8,
              autoPlayInterval: const Duration(seconds: 3),
              autoPlayAnimationDuration: const Duration(milliseconds: 2000),
              autoPlayCurve: Curves.linear,
              scrollDirection: Axis.horizontal,
              enableInfiniteScroll: true,
            ),
            items: imagePaths!.map((item) {
              // Check if it's an asset path or file path
              if (item.startsWith('assets/')) {
                return Image.asset(item, fit: BoxFit.cover);
              } else {
                // It's a file path from memory
                return Image.file(
                  File(item),
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    print("Error loading file image: $item");
                    return Container(
                      color: Colors.grey[200],
                      child: const Icon(Icons.photo, size: 40, color: Colors.grey),
                    );
                  },
                );
              }
            }).toList(),
          );
        } else {
          // Text content
          final textStyle = const TextStyle(fontSize: 16, color: Colors.black);
          final textSpan = TextSpan(text: text, style: textStyle);
          final textPainter = TextPainter(
            text: textSpan,
            maxLines: null,
            textDirection: TextDirection.ltr,
          );

          final maxTextWidth = constraints.maxWidth - (padding * 2);
          textPainter.layout(maxWidth: maxTextWidth);

          final textSize = textPainter.size;

          contentWidth = textSize.width;
          contentHeight = textSize.height;
          contentWidget = Text(
            text!,
            style: textStyle,
            textAlign: TextAlign.center,
          );
        }

        final cloudContentWidth = contentWidth + (padding * 2);
        final cloudContentHeight = contentHeight + (padding * 2);

        final cloudWidth = cloudContentWidth < minWidth ? minWidth : cloudContentWidth;
        final cloudHeight = cloudContentHeight < 56 ? 56.0 : cloudContentHeight + 30;

        return Center(
          child: SizedBox(
            width: cloudWidth,
            height: cloudHeight,
            child: CustomPaint(
              painter: CloudPainter(color: const Color(0xFFFFE3B4)),
              child: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: padding,
                    vertical: padding,
                  ),
                  child: contentWidget,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class CloudPainter extends CustomPainter {
  final Color color;

  CloudPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;

    // Original SVG path
    final svgPath = cloudSvgPath;

    final path = parseSvgPathData(svgPath);

    final bounds = path.getBounds();

    // Calculate scale factors to fit the cloud within the given size
    final scaleX = size.width / bounds.width;
    final scaleY = size.height / bounds.height;

    final matrix = Matrix4.identity()
      ..scale(scaleX, scaleY)
      ..translate(-bounds.left.toDouble(), -bounds.top.toDouble());

    // Create scaled path
    final scaledPath = path.transform(matrix.storage);

    // Get new bounds after scaling
    final scaledBounds = scaledPath.getBounds();

    // Calculate offset to center cloud inside canvas
    final dx = (size.width - scaledBounds.width) / 2 - scaledBounds.left;
    final dy = (size.height - scaledBounds.height) / 2 - scaledBounds.top;

    // Apply centering translation
    canvas.translate(dx, dy);

    // Draw final centered path
    canvas.drawPath(scaledPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}