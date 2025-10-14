import 'package:dio/dio.dart';
import '../config/api_config.dart';
import '../utils/logger.dart';
import '../exceptions/api_exception.dart';

class ApiService {
  // Singleton instance
  static ApiService? _instance;
  
  factory ApiService() {
    _instance ??= ApiService._internal();
    return _instance!;
  }
  
  ApiService._internal();

  // Dependencies
  final _config = ApiConfig();
  final _logger = AppLogger();
  late final Dio _dio;

  // Initialize the service
  Future<void> init() async {
    _dio = Dio(
      BaseOptions(
        baseUrl: _config.apiUrl,
        connectTimeout: Duration(milliseconds: ApiConfig.connectionTimeout),
        receiveTimeout: Duration(milliseconds: ApiConfig.receiveTimeout),
        headers: _config.defaultHeaders,
      ),
    );

    // Add interceptors
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: _onRequest,
        onResponse: _onResponse,
        onError: _onError,
      ),
    );
  }

  // Set auth token
  void setAuthToken(String token) {
    _dio.options.headers = _config.getAuthenticatedHeaders(token);
  }

  // Clear auth token
  void clearAuthToken() {
    _dio.options.headers = _config.defaultHeaders;
  }

  // GET request
  Future<T> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return _handleResponse<T>(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // POST request
  Future<T> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return _handleResponse<T>(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // PUT request
  Future<T> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return _handleResponse<T>(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Update FCM token
  Future<void> updateFcmToken(String token) async {
    await put<void>(
      '/notifications/fcm-token',
      data: {'token': token},
    );
  }

  // Delete notification
  Future<void> deleteNotification(String notificationId) async {
    await delete<void>('/notifications/$notificationId');
  }

  // DELETE request
  Future<T> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return _handleResponse<T>(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // PATCH request
  Future<T> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.patch(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return _handleResponse<T>(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Handle API response
  T _handleResponse<T>(Response response) {
    if (response.statusCode == ApiConfig.successCode ||
        response.statusCode == ApiConfig.createdCode) {
      if (response.data is T) {
        return response.data;
      }
      return response.data as T;
    }
    throw ApiException(
      message: 'Unexpected response format',
      statusCode: response.statusCode ?? 500,
    );
  }

  // Handle API error
  Exception _handleError(dynamic error) {
    _logger.error('API Error', error);

    if (error is DioException) {
      return ApiException(
        message: error.message ?? 'Unknown error occurred',
        statusCode: error.response?.statusCode ?? 500,
        data: error.response?.data,
      );
    }

    return ApiException(
      message: error.toString(),
      statusCode: 500,
    );
  }

  // Request interceptor
  void _onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    _logger.info('API Request: ${options.method} ${options.path}');
    handler.next(options);
  }

  // Response interceptor
  void _onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) {
    _logger.info(
      'API Response: ${response.statusCode} ${response.requestOptions.path}',
    );
    handler.next(response);
  }

  // Error interceptor
  void _onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) {
    _logger.error(
      'API Error: ${err.response?.statusCode} ${err.requestOptions.path}',
      err,
    );
    handler.next(err);
  }
}