
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class FilePickerService {
  final ImagePicker _picker = ImagePicker();

  Future<File?> pickFile() async {
    final XFile? file = await _picker.pickMedia();
    if (file != null) {
      return File(file.path);
    }
    return null;
  }
}
