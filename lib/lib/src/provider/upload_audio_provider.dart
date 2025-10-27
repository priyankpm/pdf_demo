
import 'package:flutter/material.dart';
import 'package:whiskers_flutter_app/src/viewmodel/upload_audio_viewmodel.dart';

class UploadAudioProvider extends ChangeNotifier {
  final UploadAudioViewModel _uploadAudioViewModel = UploadAudioViewModel();

  UploadAudioViewModel get uploadAudioViewModel => _uploadAudioViewModel;
}
