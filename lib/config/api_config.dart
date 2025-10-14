import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  // Singleton instance
  static final ApiConfig _instance = ApiConfig._internal();
  factory ApiConfig() => _instance;
  ApiConfig._internal();

  // API Base Configuration
  String get baseUrl => dotenv.env['API_BASE_URL'] ?? 'https://api.example.com';
  String get apiVersion => dotenv.env['API_VERSION'] ?? 'v1';

  // Full API URL
  String get apiUrl => '$baseUrl/$apiVersion';

  // Endpoints
  String get authEndpoint => '$apiUrl/auth';
  String get usersEndpoint => '$apiUrl/users';
  String get counterRoomsEndpoint => '$apiUrl/counter-rooms';
  String get itemsEndpoint => '$apiUrl/items';
  String get notificationsEndpoint => '$apiUrl/notifications';

  // API Security
  String get jwtSecret => dotenv.env['JWT_SECRET'] ?? '';
  String get encryptionKey => dotenv.env['ENCRYPTION_KEY'] ?? '';

  // Request Configuration
  static const int connectionTimeout = 30000; // 30 seconds
  static const int receiveTimeout = 30000; // 30 seconds

  // API Headers
  Map<String, String> get defaultHeaders => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  Map<String, String> getAuthenticatedHeaders(String token) => {
        ...defaultHeaders,
        'Authorization': 'Bearer $token',
      };

  // API Response Codes
  static const int successCode = 200;
  static const int createdCode = 201;
  static const int badRequestCode = 400;
  static const int unauthorizedCode = 401;
  static const int forbiddenCode = 403;
  static const int notFoundCode = 404;
  static const int serverErrorCode = 500;
}