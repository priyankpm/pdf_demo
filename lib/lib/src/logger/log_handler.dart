import 'package:log_plus/log_plus.dart';

/// Wrapper class around log_plus
class Logger {
  static final Logger _instance = Logger._internal();

  final Logs _logger = Logs(
    storeLogLevel: LogLevel.warning, // only store warning and error logs
    printLogLevelWhenDebug: LogLevel.verbose, // print all logs in debug
    printLogLevelWhenRelease: LogLevel.error, // only print errors in release
    storeLimit: 500, // log history stored in memory
  );

  factory Logger() {
    return _instance;
  }

  Logger._internal();

  void i(String message, {String? tag}) {
    _logger.i(message);
  }

  void d(String message, {String? tag}) {
    _logger.d(message);
  }

  void w(String message, {String? tag}) {
    _logger.w(message);
  }

  void e(
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    _logger.e(message);
  }

  void verbose(String message, {String? tag}) {
    _logger.v(message);
  }
}
