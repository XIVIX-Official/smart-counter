import 'package:mockito/mockito.dart';
import 'package:dio/dio.dart';
import 'package:smart_counter/services/api_service.dart';
import 'package:smart_counter/services/storage_service.dart';
import 'package:smart_counter/utils/logger.dart';

// Mock classes for testing
class MockApiService extends Mock implements ApiService {
  @override
  Future<T> get<T>(
    String path, {
    CancelToken? cancelToken,
    Options? options,
    Map<String, dynamic>? queryParameters,
  }) async {
    return super.noSuchMethod(
      Invocation.method(#get, [path], {
        #cancelToken: cancelToken,
        #options: options,
        #queryParameters: queryParameters,
      }),
      returnValue: Future.value(null),
    );
  }
}

class MockStorageService extends Mock implements StorageService {
  @override
  T? getFromCache<T>(String key) {
    return super.noSuchMethod(
      Invocation.method(#getFromCache, [key]),
      returnValue: null,
    );
  }

  @override
  Future<void> saveToCache(
    String key,
    dynamic value, {
    Duration? duration,
  }) async {
    return super.noSuchMethod(
      Invocation.method(#saveToCache, [key, value], {#duration: duration}),
    );
  }
}

class MockAppLogger extends Mock implements AppLogger {
  @override
  void debug(String message, [dynamic error, StackTrace? stackTrace]) {
    super.noSuchMethod(
      Invocation.method(#debug, [message, error, stackTrace]),
    );
  }

  @override
  void error(String message, [dynamic error, StackTrace? stackTrace]) {
    super.noSuchMethod(
      Invocation.method(#error, [message, error, stackTrace]),
    );
  }
}