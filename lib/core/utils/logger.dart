import 'package:logger/logger.dart';

/// Centralized logging utility
class AppLogger {
  AppLogger._();

  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 2,
      errorMethodCount: 8,
      lineLength: 120,
      colors: true,
      printEmojis: true,
      printTime: true,
    ),
  );

  /// Log debug message
  static void debug(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.d(message, error: error, stackTrace: stackTrace);
  }

  /// Log info message
  static void info(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.i(message, error: error, stackTrace: stackTrace);
  }

  /// Log warning message
  static void warning(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.w(message, error: error, stackTrace: stackTrace);
  }

  /// Log error message
  static void error(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }

  /// Log fatal/critical message
  static void fatal(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.f(message, error: error, stackTrace: stackTrace);
  }

  /// Log network request
  static void logRequest(
    String method,
    String url, [
    Map<String, dynamic>? data,
  ]) {
    info('🌐 $method $url${data != null ? '\nData: $data' : ''}');
  }

  /// Log network response
  static void logResponse(int statusCode, String url, [dynamic data]) {
    if (statusCode >= 200 && statusCode < 300) {
      info('✅ $statusCode $url${data != null ? '\nResponse: $data' : ''}');
    } else {
      error('❌ $statusCode $url${data != null ? '\nResponse: $data' : ''}');
    }
  }

  /// Log bloc event
  static void logBlocEvent(String blocName, String event) {
    debug('🎯 [$blocName] Event: $event');
  }

  /// Log bloc state
  static void logBlocState(String blocName, String state) {
    debug('📦 [$blocName] State: $state');
  }
}
