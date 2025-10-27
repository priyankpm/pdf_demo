import 'package:flutter/material.dart';

class ImageUploadBox extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final String? imagePath; // can hold uploaded image path

  const ImageUploadBox({
    super.key,
    required this.label,
    this.onTap,
    this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () {}, // can connect to image picker later
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(8),
          color: Colors.grey.shade100,
        ),
        child: imagePath != null
            ? ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(
            imagePath!,
            fit: BoxFit.cover,
          ),
        )
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.add_a_photo, color: Colors.grey),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(fontSize: 12, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}
