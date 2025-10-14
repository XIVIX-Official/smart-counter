import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import '../../lib/controllers/qr_controller.dart';
import '../../lib/models/qr_code.dart';
import '../../lib/services/qr_service.dart';
import '../../lib/utils/logger.dart';

// Helper functions
QrCode createTestQrCode(String code) => QrCode(
      id: '',
      code: code,
      type: QrCodeType.temporaryAccess,
      targetId: '',
      createdAt: DateTime.now(),
      isActive: true,
      metadata: {},
    );

// Mock classes
void Function(String) onScanFunction = (String code) {};
@GenerateMocks([QrService, AppLogger])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  
  group('QrController Tests', () {
    late QrService mockQrService;
    late AppLogger mockLogger;
    late QrController qrController;

    setUp(() {
      mockQrService = MockQrService();
      mockLogger = MockAppLogger();

      qrController = QrController(
        qrService: mockQrService,
        logger: mockLogger,
      );
    });

    tearDown(() {
      qrController.dispose();
      reset(mockQrService);
      reset(mockLogger);
    });

    test('createQrCode updates loading state and returns QR code', () async {
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

      when(mockQrService.createQrCode(
        QrCodeType.item,
        'item-123',
        expiresAt: null,
        metadata: null,
      )).thenAnswer((_) async => qrCode);

      // Act
      final result = await qrController.createQrCode(
        QrCodeType.item,
        'item-123',
      );

      // Assert
      expect(result.id, equals('test-id'));
      expect(result.type, equals(QrCodeType.item));
      expect(result.targetId, equals('item-123'));
      expect(qrController.isLoading, isFalse);
      verify(mockQrService.createQrCode(
        QrCodeType.item,
        'item-123',
        expiresAt: null,
        metadata: null,
      )).called(1);
      verify(mockLogger.debug(any)).called(1);
    });

    test('generateQrCode generates QR code image', () async {
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

      final fakeImage = Uint8List.fromList([1, 2, 3, 4]);
      when(mockQrService.generateQrCode(qrCode))
          .thenAnswer((_) async => fakeImage);

      // Act
      final result = await qrController.generateQrCode(qrCode);

      // Assert
      expect(result, equals(fakeImage));
      expect(qrController.isLoading, isFalse);
      verify(mockQrService.generateQrCode(qrCode)).called(1);
      verify(mockLogger.debug(any)).called(1);
    });

    test('startScanning prevents duplicate scans', () async {
      // Arrange
      qrController.setIsScanning(true);

      // Act
      await qrController.startScanning();

      // Assert
      verifyNever(mockQrService.startScanning(onScanned: anyNamed('onScanned')));
      verify(mockLogger.warning(any)).called(1);
    });

    test('stopScanning only stops if currently scanning', () async {
      // Arrange
      qrController.setIsScanning(false);

      // Act
      await qrController.stopScanning();

      // Assert
      verifyNever(mockQrService.stopScanning());
    });

    test('handleQrCodeScanned processes valid QR codes', () async {
      // Arrange
      final testCode = createTestQrCode('test-code');
      when(mockQrService.processQrCode(testCode))
          .thenAnswer((_) async => true);

      // Act
      await qrController.handleQrCodeScanned('test-code');

      // Assert
      verify(mockQrService.processQrCode(testCode))
          .called(1);
      verify(mockLogger.debug('QR code scanned: test-code')).called(1);
      expect(qrController.scannedCode?.code, equals('test-code'));
      expect(qrController.error, isNull);
    });

    test('handleQrCodeScanned handles processing failure', () async {
      // Arrange
      final testCode = createTestQrCode('test-code');
      when(mockQrService.processQrCode(testCode))
          .thenAnswer((_) async => false);

      // Act
      await qrController.handleQrCodeScanned('test-code');

      // Assert
      verify(mockQrService.processQrCode(testCode))
          .called(1);
      verify(mockLogger.debug('QR code scanned: test-code')).called(1);
      expect(qrController.scannedCode?.code, equals('test-code'));
      expect(qrController.error, equals('Failed to process QR code'));
    });

    test('clearError resets error state', () {
      // Arrange
      qrController.setError('Test error');

      // Act
      qrController.clearError();

      // Assert
      expect(qrController.error, isNull);
    });

    test('clearScannedCode resets scanned code', () {
      // Arrange
      qrController.scannedCode = QrCode(
        id: 'test-id',
        code: 'test-code',
        type: QrCodeType.item,
        targetId: 'item-123',
        createdAt: DateTime.now(),
        isActive: true,
        metadata: {},
      );

      // Act
      qrController.clearScannedCode();

      // Assert
      expect(qrController.scannedCode, isNull);
    });
  });
}