// QR Code service tests
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('QR Service Tests', () {
    late QrService qrService;
    late MockLogger mockLogger;
    late MockApiService mockApiService;
    late MockStorageService mockStorageService;

    setUp(() {
      mockLogger = MockLogger();
      mockApiService = MockApiService();
      mockStorageService = MockStorageService();
      
      when(mockStorageService.saveToCache(any, any))
          .thenAnswer((_) async => true);
          
      qrService = QrService();
      qrService.logger = mockLogger;
      qrService.apiService = mockApiService;
      qrService.storageService = mockStorageService;
    });

    tearDown(() {
      reset(mockLogger);
      reset(mockApiService);
      reset(mockStorageService);
    });

    test('generateQrCode generates correct QR code image', () async {
      // Arrange
      final qrCode = QrCode(
        id: 'test-id',
        code: 'test-code',
        type: QrCodeType.item,
        targetId: 'item-123',
        createdAt: DateTime.now(),
        isActive: true,
        metadata: {},
      );

      // Act
      final qrImage = await qrService.generateQrCode(qrCode);

      // Assert
      expect(qrImage, isA<Uint8List>());
      expect(qrImage.lengthInBytes, greaterThan(0));
      verify(mockLogger.debug(any)).called(1);
    });

    test('createQrCode calls API and caches response', () async {
      // Arrange
      final response = {
        'id': 'test-id',
        'code': 'test-code',
        'type': 'item',
        'targetId': 'item-123',
        'createdAt': DateTime.now().toIso8601String(),
        'isActive': true,
        'metadata': {},
      };

      when(mockApiService.post<Map<String, dynamic>>(
        '/qr-codes',
        data: any,
      )).thenAnswer((_) async => response);

      // Act
      final qrCode = await qrService.createQrCode(
        QrCodeType.item,
        'item-123',
      );

      // Assert
      expect(qrCode.id, equals('test-id'));
      expect(qrCode.type, equals(QrCodeType.item));
      expect(qrCode.targetId, equals('item-123'));

      verify(mockApiService.post<Map<String, dynamic>>(
        '/qr-codes',
        data: any,
      )).called(1);

      verify(mockStorageService.saveToCache(
        'qr_code_test-id',
        response,
      )).called(1);

      verify(mockLogger.debug(any)).called(1);
    });

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

      when(mockStorageService.getFromCache<Map<String, dynamic>>(any))
          .thenReturn(cachedData);

      // Act
      final qrCode = await qrService.getQrCode('test-id');

      // Assert
      expect(qrCode.id, equals('test-id'));
      expect(qrCode.type, equals(QrCodeType.item));
      expect(qrCode.targetId, equals('item-123'));

      verify(mockStorageService.getFromCache<Map<String, dynamic>>(
        'qr_code_test-id',
      )).called(1);

      verifyNever(mockApiService.get<Map<String, dynamic>>(any));
      verify(mockLogger.debug(any)).called(1);
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

      when(mockStorageService.getFromCache<Map<String, dynamic>>(any))
          .thenReturn(null);

      when(mockApiService.get<Map<String, dynamic>>('/qr-codes/test-id'))
          .thenAnswer((_) async => apiResponse);

      // Act
      final qrCode = await qrService.getQrCode('test-id');

      // Assert
      expect(qrCode.id, equals('test-id'));
      expect(qrCode.type, equals(QrCodeType.item));
      expect(qrCode.targetId, equals('item-123'));

      verify(mockStorageService.getFromCache<Map<String, dynamic>>(
        'qr_code_test-id',
      )).called(1);

      verify(mockApiService.get<Map<String, dynamic>>('/qr-codes/test-id'))
          .called(1);

      verify(mockStorageService.saveToCache(
        'qr_code_test-id',
        apiResponse,
      )).called(1);

      verify(mockLogger.debug(any)).called(1);
    });

    test('validateQrCode returns true for valid QR code', () async {
      // Arrange
      final qrCode = QrCode(
        id: 'test-id',
        code: 'test-code',
        type: QrCodeType.item,
        targetId: 'item-123',
        createdAt: DateTime.now(),
        isActive: true,
        metadata: {},
      );

      when(mockApiService.get<Map<String, dynamic>>('/qr-codes/code/test-code'))
          .thenAnswer((_) async => qrCode.toJson());

      // Act
      final isValid = await qrService.validateQrCode('test-code');

      // Assert
      expect(isValid, isTrue);
      verify(mockLogger.debug(any)).called(1);
    });

    test('validateQrCode returns false for invalid QR code', () async {
      // Arrange
      when(mockApiService.get<Map<String, dynamic>>('/qr-codes/code/invalid-code'))
          .thenThrow(Exception('Invalid code'));

      // Act
      final isValid = await qrService.validateQrCode('invalid-code');

      // Assert
      expect(isValid, isFalse);
      verify(mockLogger.error(any, any)).called(1);
    });
  });
}