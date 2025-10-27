import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ImageUploadGridBox extends StatefulWidget {
  final String? label;
  final Function(File?)? onImageSelected;
  final File? selectedImage;
  final String? defaultImagePath; // Make it optional

  const ImageUploadGridBox({
    super.key,
    this.label,
    this.onImageSelected,
    this.selectedImage,
    this.defaultImagePath, // Now optional
  });

  @override
  State<ImageUploadGridBox> createState() => _ImageUploadGridBoxState();
}

class _ImageUploadGridBoxState extends State<ImageUploadGridBox> {
  File? _image;

  @override
  void initState() {
    super.initState();
    _image = widget.selectedImage;
  }

  @override
  void didUpdateWidget(ImageUploadGridBox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedImage != oldWidget.selectedImage) {
      setState(() {
        _image = widget.selectedImage;
      });
    }
  }

  void _showImageSourceBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: source,
      maxWidth: 1920,
      maxHeight: 1080,
    );

    if (pickedFile != null) {
      final file = File(pickedFile.path);
      setState(() {
        _image = file;
      });

      if (widget.onImageSelected != null) {
        widget.onImageSelected!(file);
      }
    } else {
      if (widget.onImageSelected != null) {
        widget.onImageSelected!(null);
      }
    }
  }

  void _removeImage() {
    setState(() {
      _image = null;
    });

    if (widget.onImageSelected != null) {
      widget.onImageSelected!(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
        ],

        GestureDetector(
          onTap: _showImageSourceBottomSheet,
          child: Container(
            height: 144, // 16:9 aspect ratio
            decoration: BoxDecoration(
              color: Colors.grey[200],
              border: Border.all(color: Colors.grey, width: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: _image == null
                ? _buildDefaultImage()
                : _buildSelectedImage(),
          ),
        ),
      ],
    );
  }

  Widget _buildDefaultImage() {
    // If no default image path provided, show basic placeholder
    if (widget.defaultImagePath == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.add_photo_alternate,
              size: 32,
              color: Colors.black54,
            ),
            const SizedBox(height: 8),
            Text(
              widget.label ?? 'Add Photo',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      );
    }

    // If default image path is provided, show it with overlay
    return Stack(
      children: [
        // Default background image
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(
            widget.defaultImagePath!,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.grey[300],
                child: const Icon(
                  Icons.pets,
                  size: 32,
                  color: Colors.black54,
                ),
              );
            },
          ),
        ),

        // Add photo overlay
        Container(
          decoration: BoxDecoration(
            color: Colors.black38,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.add_photo_alternate,
                    size: 24,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.label ?? 'Add Photo',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSelectedImage() {
    return Stack(
      children: [
        // Selected image
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.file(
            _image!,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
        ),

        // Remove button
        Positioned(
          top: 4,
          right: 4,
          child: GestureDetector(
            onTap: _removeImage,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.black54,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close,
                color: Colors.white,
                size: 16,
              ),
            ),
          ),
        ),

        // Change photo overlay
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 30,
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
            ),
            child: Center(
              child: Text(
                'Change Photo',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}