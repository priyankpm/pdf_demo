import 'package:hooks_riverpod/hooks_riverpod.dart';

class SleepImageViewModel extends StateNotifier<String> {
  SleepImageViewModel() : super('');

  void updateImage(String imagePath) {
    state = imagePath;
  }
}