import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  // Singleton instance
  static final AppConfig _instance = AppConfig._internal();
  factory AppConfig() => _instance;
  AppConfig._internal();

  // App information
  String get appName => dotenv.env['APP_NAME'] ?? 'Smart Counter';
  String get appVersion => dotenv.env['APP_VERSION'] ?? '1.0.0';
  String get appEnvironment => dotenv.env['APP_ENV'] ?? 'development';

  // Feature flags
  bool get enablePushNotifications =>
      dotenv.env['ENABLE_PUSH_NOTIFICATIONS']?.toLowerCase() == 'true';
  bool get enableOfflineMode =>
      dotenv.env['ENABLE_OFFLINE_MODE']?.toLowerCase() == 'true';
  bool get enableAnalytics =>
      dotenv.env['ENABLE_ANALYTICS']?.toLowerCase() == 'true';

  // Cache configuration
  int get cacheDuration =>
      int.tryParse(dotenv.env['CACHE_DURATION'] ?? '') ?? 3600;
  int get maxCacheSize =>
      int.tryParse(dotenv.env['MAX_CACHE_SIZE'] ?? '') ?? 100;

  // Logging configuration
  String get logLevel => dotenv.env['LOG_LEVEL'] ?? 'info';
  bool get enableCrashReporting =>
      dotenv.env['ENABLE_CRASH_REPORTING']?.toLowerCase() == 'true';

  // Firebase configuration
  Map<String, String> get firebaseConfig => {
        'apiKey': dotenv.env['FIREBASE_API_KEY'] ?? '',
        'projectId': dotenv.env['FIREBASE_PROJECT_ID'] ?? '',
        'messagingSenderId': dotenv.env['FIREBASE_MESSAGING_SENDER_ID'] ?? '',
        'appId': dotenv.env['FIREBASE_APP_ID'] ?? '',
        'measurementId': dotenv.env['FIREBASE_MEASUREMENT_ID'] ?? '',
      };

  bool get isProduction => appEnvironment == 'production';
  bool get isStaging => appEnvironment == 'staging';
  bool get isDevelopment => appEnvironment == 'development';
}