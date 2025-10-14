import 'package:logger/logger.dart';
import '../config/app_config.dart';

class AppLogger {
  // Singleton instance
  static final AppLogger _instance = AppLogger._internal();
  factory AppLogger() => _instance;
  AppLogger._internal();

  late final Logger _logger;
  final _config = AppConfig();

  // Initialize logger
  void init() {
    _logger = Logger(
      printer: PrettyPrinter(
        methodCount: 0,
        errorMethodCount: 5,
        lineLength: 80,
        colors: true,
        printEmojis: true,
        printTime: true,
      ),
      level: _getLogLevel(),
    );
  }

  // Get log level from config
  Level _getLogLevel() {
    switch (_config.logLevel.toLowerCase()) {
      case 'verbose':
        return Level.verbose;
      case 'debug':
        return Level.debug;
      case 'info':
        return Level.info;
      case 'warning':
        return Level.warning;
      case 'error':
        return Level.error;
      case 'wtf':
        return Level.wtf;
      default:
        return Level.info;
    }
  }

  // Logging methods
  void verbose(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.v(message, error, stackTrace);
  }

  void debug(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.d(message, error, stackTrace);
  }

  void info(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.i(message, error, stackTrace);
  }

  void warning(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.w(message, error, stackTrace);
  }

  void error(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(message, error, stackTrace);
  }

  void wtf(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.wtf(message, error, stackTrace);
  }

  // Log with custom level
  void log(Level level, String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.log(level, message, error, stackTrace);
  }

  // Format message with context
  String _formatMessage(String message, {Map<String, dynamic>? context}) {
    if (context == null || context.isEmpty) {
      return message;
    }

    final contextString = context.entries
        .map((e) => '${e.key}=${e.value}')
        .join(', ');
    return '$message | Context: {$contextString}';
  }

  // Helper method for structured logging
  void logWithContext(
    Level level,
    String message, {
    Map<String, dynamic>? context,
    dynamic error,
    StackTrace? stackTrace,
  }) {
    final formattedMessage = _formatMessage(message, context: context);
    log(level, formattedMessage, error, stackTrace);
  }
}