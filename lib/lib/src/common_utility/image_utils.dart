import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;

import '../enum/memory_frame_type.dart';

class ImageUtils {
  static Future<File?> pickAndCropImage(
    BuildContext context, {
    required String frameType,
  }) async {
    final picker = ImagePicker();

    // Pick image
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery, // you can still allow camera/gallery switch
      imageQuality: 100,
    );

    if (pickedFile == null) return null;
    final imageFile = File(pickedFile.path);

    // Read image
    final bytes = await imageFile.readAsBytes();
    final decoded = img.decodeImage(bytes);
    if (decoded == null) return imageFile;

    img.Image croppedImage = decoded;

    // --- Auto crop based on MemoryFrameType ---
    if (frameType == MemoryFrameType.square.name) {
      // Center crop to square
      int size = decoded.width < decoded.height
          ? decoded.width
          : decoded.height;
      int x = (decoded.width - size) ~/ 2;
      int y = (decoded.height - size) ~/ 2;
      croppedImage = img.copyCrop(
        decoded,
        x: x,
        y: y,
        width: size,
        height: size,
      );
    } else if (frameType == MemoryFrameType.rectangle.name) {
      // Center crop to 4:3
      double targetRatio = 4 / 3;
      int targetWidth = decoded.width;
      int targetHeight = (decoded.width / targetRatio).round();

      if (targetHeight > decoded.height) {
        targetHeight = decoded.height;
        targetWidth = (decoded.height * targetRatio).round();
      }

      int x = (decoded.width - targetWidth) ~/ 2;
      int y = (decoded.height - targetHeight) ~/ 2;

      croppedImage = img.copyCrop(
        decoded,
        x: x,
        y: y,
        width: targetWidth,
        height: targetHeight,
      );
    }
    // if type == none → keep original

    // --- Resize to fixed width (153px) while keeping ratio ---
    final resizedImage = img.copyResize(croppedImage, width: 153);
    final resizedBytes = Uint8List.fromList(
      img.encodeJpg(resizedImage, quality: 100),
    );

    // Save back to file
    final resizedFile = File(imageFile.path)..writeAsBytesSync(resizedBytes);
    return resizedFile;
  }

  static Future<File?> picImage(
    BuildContext context, {
    required String frameType,
  }) async {
    final picker = ImagePicker();

    // Pick image
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery, // you can still allow camera/gallery switch
      imageQuality: 100,
    );

    if (pickedFile == null) return null;
    final imageFile = File(pickedFile.path);

    return imageFile;
  }
}
