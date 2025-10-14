/// Base class for all app-specific exceptions
class AppException implements Exception {
  final String message;
  final String code;
  final dynamic data;

  AppException(
    this.message, {
    this.code = 'unknown_error',
    this.data,
  });

  @override
  String toString() => 'AppException: $message (code: $code)';
}

/// Authentication related exceptions
class AuthException extends AppException {
  AuthException(
    String message, {
    String code = 'auth_error',
    dynamic data,
  }) : super(message, code: code, data: data);
}

/// Network related exceptions
class NetworkException extends AppException {
  NetworkException(
    String message, {
    String code = 'network_error',
    dynamic data,
  }) : super(message, code: code, data: data);
}

/// Server related exceptions
class ServerException extends AppException {
  ServerException(
    String message, {
    String code = 'server_error',
    dynamic data,
  }) : super(message, code: code, data: data);
}

/// Cache related exceptions
class CacheException extends AppException {
  CacheException(
    String message, {
    String code = 'cache_error',
    dynamic data,
  }) : super(message, code: code, data: data);
}

/// Storage related exceptions
class StorageException extends AppException {
  StorageException(
    String message, {
    String code = 'storage_error',
    dynamic data,
  }) : super(message, code: code, data: data);
}

/// API related exceptions
class ApiException extends AppException {
  final int? statusCode;
  final String? endpoint;

  ApiException(
    String message, {
    String code = 'api_error',
    this.statusCode,
    this.endpoint,
    dynamic data,
  }) : super(message, code: code, data: data);

  @override
  String toString() =>
      'ApiException: $message (code: $code, status: $statusCode, endpoint: $endpoint)';
}

/// Permission related exceptions
class PermissionException extends AppException {
  PermissionException(
    String message, {
    String code = 'permission_error',
    dynamic data,
  }) : super(message, code: code, data: data);
}

/// Validation related exceptions
class ValidationException extends AppException {
  final Map<String, String>? errors;

  ValidationException(
    String message, {
    String code = 'validation_error',
    this.errors,
    dynamic data,
  }) : super(message, code: code, data: data);

  @override
  String toString() =>
      'ValidationException: $message (code: $code, errors: $errors)';
}

/// QR code related exceptions
class QrException extends AppException {
  QrException(
    String message, {
    String code = 'qr_error',
    dynamic data,
  }) : super(message, code: code, data: data);
}

/// Counter room related exceptions
class CounterRoomException extends AppException {
  CounterRoomException(
    String message, {
    String code = 'counter_room_error',
    dynamic data,
  }) : super(message, code: code, data: data);
}

/// Item related exceptions
class ItemException extends AppException {
  ItemException(
    String message, {
    String code = 'item_error',
    dynamic data,
  }) : super(message, code: code, data: data);
}

/// User related exceptions
class UserException extends AppException {
  UserException(
    String message, {
    String code = 'user_error',
    dynamic data,
  }) : super(message, code: code, data: data);
}

/// File related exceptions
class FileException extends AppException {
  final String? filePath;

  FileException(
    String message, {
    String code = 'file_error',
    this.filePath,
    dynamic data,
  }) : super(message, code: code, data: data);

  @override
  String toString() =>
      'FileException: $message (code: $code, filePath: $filePath)';
}