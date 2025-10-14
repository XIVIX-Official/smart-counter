import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dio/dio.dart';
import 'package:smart_counter/models/qr_code.dart';
import 'package:smart_counter/services/qr_service.dart';
import 'package:smart_counter/exceptions/api_exception.dart';
import 'package:smart_counter/services/api_service.dart';
import 'package:smart_counter/services/storage_service.dart';
import 'package:smart_counter/utils/logger.dart';

class MockApiService extends Mock implements ApiService {
  @override
  Future<T> get<T>(
    String path, {
    CancelToken? cancelToken,
    Options? options,
    Map<String, dynamic>? queryParameters,
  }) =>
      Future.value() as Future<T>;
}

class MockStorageService extends Mock implements StorageService {
  @override
  T? getFromCache<T>(String key) => null;

  @override
  Future<void> saveToCache(
    String key,
    dynamic value, {
    Duration? duration,
  }) async {}
}

class MockAppLogger extends Mock implements AppLogger {
  @override 
  void error(String message, [dynamic error, StackTrace? stackTrace]) {}

  @override
  void debug(String message, [dynamic error, StackTrace? stackTrace]) {}
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late QrService qrService;
  late MockApiService mockApiService;
  late MockStorageService mockStorageService;
  late MockAppLogger mockLogger;

  setUp(() {
    mockApiService = MockApiService();
    mockStorageService = MockStorageService();
    mockLogger = MockAppLogger();

    qrService = QrService(
      apiService: mockApiService,
      storageService: mockStorageService,
      logger: mockLogger,
    );
  });

  group('QR Service Tests', () {
    test('getQrCode fetches from cache first if available', () async {
      // Arrange
      final cachedData = {
        'id': 'test-id',
        'code': 'test-code',
        'type': 'item',
        'targetId': 'item-123',
        'createdAt': DateTime.now().toIso8601String(),
        'isActive': true,
        'metadata': {},
      };

      when(mockStorageService.getFromCache(
        'qr_code_test-id',
      )).thenReturn(cachedData);

      // Act
      final qrCode = await qrService.getQrCode('test-id');

      // Assert
      expect(qrCode?.id, equals('test-id'));
      expect(qrCode?.type, equals(QrCodeType.item));
      expect(qrCode?.targetId, equals('item-123'));

      verify(mockStorageService.getFromCache(
        'qr_code_test-id',
      )).called(1);

      verifyNever(mockApiService.get('/qr-codes/test-id'));
    });

    test('getQrCode fetches from API if not in cache', () async {
      // Arrange
      final apiResponse = {
        'id': 'test-id',
        'code': 'test-code',
        'type': 'item',
        'targetId': 'item-123',
        'createdAt': DateTime.now().toIso8601String(),
        'isActive': true,
        'metadata': {},
      };

      when(mockStorageService.getFromCache(
        'qr_code_test-id',
      )).thenReturn(null);

      when(mockApiService.get('/qr-codes/test-id'))
          .thenAnswer((_) async => apiResponse);

      // Act
      final qrCode = await qrService.getQrCode('test-id');

      // Assert
      expect(qrCode?.id, equals('test-id'));
      expect(qrCode?.type, equals(QrCodeType.item));
      expect(qrCode?.targetId, equals('item-123'));

      verify(mockStorageService.getFromCache('qr_code_test-id')).called(1);
      verify(mockApiService.get('/qr-codes/test-id')).called(1);
      verify(mockStorageService.saveToCache('qr_code_test-id', apiResponse))
          .called(1);
    });

    test('getQrCode returns null when API throws ApiException', () async {
      // Arrange
      when(mockStorageService.getFromCache('qr_code_test-id'))
          .thenReturn(null);

      when(mockApiService.get('/qr-codes/test-id'))
          .thenThrow(ApiException(
            message: 'Not found',
            statusCode: 404,
          ));

      // Act
      final qrCode = await qrService.getQrCode('test-id');

      // Assert
      expect(qrCode, isNull);
      verify(mockLogger.error(
        'Failed to get QR code: test-id',
        any,
      )).called(1);
    });

    test('getQrCodeByCode fetches from cache first if available', () async {
      // Arrange
      final cachedData = {
        'id': 'test-id',
        'code': 'test-code',
        'type': 'item',
        'targetId': 'item-123',
        'createdAt': DateTime.now().toIso8601String(),
        'isActive': true,
        'metadata': {},
      };

      when(mockStorageService.getFromCache('qr_code_code_test-code'))
          .thenReturn(cachedData);

      // Act
      final qrCode = await qrService.getQrCodeByCode('test-code');

      // Assert
      expect(qrCode?.id, equals('test-id'));
      expect(qrCode?.type, equals(QrCodeType.item));
      expect(qrCode?.targetId, equals('item-123'));

      verify(mockStorageService.getFromCache('qr_code_code_test-code')).called(1);
      verifyNever(mockApiService.get('/qr-codes/code/test-code'));
    });

    test('getQrCodeByCode returns null when API throws ApiException', () async {
      // Arrange
      when(mockStorageService.getFromCache('qr_code_code_test-code'))
          .thenReturn(null);

      when(mockApiService.get('/qr-codes/code/test-code'))
          .thenThrow(ApiException(
            message: 'Not found',
            statusCode: 404,
          ));

      // Act
      final qrCode = await qrService.getQrCodeByCode('test-code');

      // Assert
      expect(qrCode, isNull);
      verify(mockLogger.error(
        'Failed to get QR code by code: test-code',
        any,
      )).called(1);
    });
  });
}