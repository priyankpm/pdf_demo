import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:crop_your_image/crop_your_image.dart';
import 'package:whiskers_flutter_app/src/provider/providers.dart';

class UploadBox extends ConsumerStatefulWidget {
  const UploadBox({super.key});

  @override
  ConsumerState<UploadBox> createState() => _UploadBoxState();
}

class _UploadBoxState extends ConsumerState<UploadBox> {
  Future<void> _showImageSourceBottomSheet() async {
    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(16),
                child: const Text(
                  "Choose Image Source",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              // Divider
              const Divider(height: 1),

              // Gallery Option
              ListTile(
                leading: const Icon(Icons.photo_library, color: Colors.blue),
                title: const Text("Gallery"),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),

              // Camera Option
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Colors.green),
                title: const Text("Camera"),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),

              // Cancel Button
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.cancel, color: Colors.red),
                title: const Text("Cancel"),
                onTap: () => Navigator.pop(context),
              ),

              // Extra space for bottom safe area
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: source);

    if (picked != null) {
      // Navigate to custom crop screen
      final croppedBytes = await Navigator.push<Uint8List?>(
        context,
        MaterialPageRoute(
          builder: (_) => CustomCropper(imageFile: File(picked.path)),
        ),
      );

      if (croppedBytes != null) {
        // Save cropped bytes into a temp file so we can use Image.file
        final tempDir = Directory.systemTemp;
        final croppedFile = File(
          '${tempDir.path}/cropped_${DateTime.now().millisecondsSinceEpoch}.png',
        );
        await croppedFile.writeAsBytes(croppedBytes);

        ref.read(backgroundImageProvider).addImage(croppedFile.path);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _showImageSourceBottomSheet,
      child: Container(
        width: 254,
        height: 115,
        decoration: ShapeDecoration(
          shape: _DashedBorder(radius: 4, dashWidth: 5, dashSpace: 5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.cloud_upload_outlined, size: 24),
            SizedBox(height: 12),
            Text(
              "Upload a New Background Image",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 10),
            Text(
              "Supported formats: JPEG, PNG",
              style: TextStyle(fontSize: 12, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}

/// Custom cropper screen with Cancel / Choose
class CustomCropper extends ConsumerStatefulWidget {
  final File imageFile;

  const CustomCropper({super.key, required this.imageFile});

  @override
  ConsumerState<CustomCropper> createState() => _CustomCropperState();
}

class _CustomCropperState extends ConsumerState<CustomCropper> {
  final _controller = CropController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: Crop(
              controller: _controller,
              image: widget.imageFile.readAsBytesSync(),
              aspectRatio: 254 / 115, // lock ratio
              onCropped: (result) {
                if (result is CropSuccess) {
                  Navigator.pop(context, result.croppedImage);
                } else {
                  Navigator.pop(context, null);
                }
              },
            ),
          ),
          Positioned(
            left: 16,
            bottom: 32,
            child: TextButton(
              onPressed: () => Navigator.pop(context), // Cancel
              child: const Text(
                "Cancel",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
          Positioned(
            right: 16,
            bottom: 32,
            child: TextButton(
              onPressed: () {
                _controller.crop(); // triggers onCropped
              },
              child: const Text(
                "Choose",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Dashed border painter (unchanged)
class _DashedBorder extends ShapeBorder {
  final double dashWidth;
  final double dashSpace;
  final double radius;

  _DashedBorder({
    this.dashWidth = 5.0,
    this.dashSpace = 5.0,
    this.radius = 4.0,
  });

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) =>
      getOuterPath(rect, textDirection: textDirection);

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) =>
      Path()..addRRect(RRect.fromRectAndRadius(rect, Radius.circular(radius)));

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(radius));
    final path = Path()..addRRect(rrect);

    final dashPath = Path();
    double distance = 0.0;

    for (final metric in path.computeMetrics()) {
      while (distance < metric.length) {
        dashPath.addPath(
          metric.extractPath(distance, distance + dashWidth),
          Offset.zero,
        );
        distance += dashWidth + dashSpace;
      }
      distance = 0;
    }

    canvas.drawPath(dashPath, paint);
  }

  @override
  ShapeBorder scale(double t) => this;
}