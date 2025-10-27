/// To get platform info.
abstract class AppPlatform {
  /// Will return true if platform is android.
  bool isAndroid();

  /// Will return true if platform is ios.
  bool isIOS();

  /// Will return name of platform.
  String getOperatingSystem();
}
