import 'dart:developer';
import 'dart:io';

import 'package:vibration/vibration.dart';

    class HapticFeedback {
  static Future hapticFeedback() async {
    if (await Vibration.hasVibrator()) {
      await Vibration.vibrate(duration: Platform.isIOS ? 40 : 80);
    } else {
      log("Device does not support vibration");
    }
  }
}
