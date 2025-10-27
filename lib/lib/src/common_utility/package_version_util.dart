import 'package:package_info_plus/package_info_plus.dart';

class PackageVersionUtil {
  static final PackageVersionUtil _instance = PackageVersionUtil._internal();
  factory PackageVersionUtil() => _instance;

  PackageVersionUtil._internal();

  late final PackageInfo _packageInfo;

  /// Call this once at app startup (e.g., inside main or init)
  Future<void> init() async {
    _packageInfo = await PackageInfo.fromPlatform();
  }

  String get appName => _packageInfo.appName;
  String get packageName => _packageInfo.packageName;
  String get version => _packageInfo.version;
  String get buildNumber => _packageInfo.buildNumber;

  /// Combined version string like: v1.2.3 (45)
  String get fullVersion => 'v$version ($buildNumber)';
}
