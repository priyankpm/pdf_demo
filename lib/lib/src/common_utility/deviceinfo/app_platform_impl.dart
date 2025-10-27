import 'dart:io';

import 'app_platform.dart';

/// Implementation of [AppPlatform].
class AppPlatformImpl implements AppPlatform {
  @override
  bool isAndroid() => Platform.isAndroid;

  @override
  bool isIOS() => Platform.isIOS;

  @override
  String getOperatingSystem() => Platform.operatingSystem;
}
