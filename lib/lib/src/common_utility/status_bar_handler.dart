import 'package:flutter/services.dart';

class StatusBarHandler {
  void setStatusBarColor(Color color) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
        statusBarColor: color,
      ),
    );
  }
}
