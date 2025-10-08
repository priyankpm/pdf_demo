import 'package:get/get.dart';

import 'compress_controller.dart';

class CompressorBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CompressorController>(() => CompressorController());
  }
}
