import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:meta/meta.dart';
import '../models/qr_code.dart';
import '../services/qr_service.dart';
import '../utils/logger.dart';

class QrController extends GetxController {
  // Internal testing methods
  @visibleForTesting
  set scannedCode(QrCode? code) => _scannedCode.value = code;
  QrController({QrService? qrService, AppLogger? logger})
      : _qrService = qrService ?? QrService(),
        _logger = logger ?? AppLogger();

  // Dependencies  
  final QrService _qrService;
  final AppLogger _logger;

  final _isScanning = false.obs;
  final _isLoading = false.obs;
  final _scannedCode = Rx<QrCode?>(null);
  final _error = Rx<String?>(null);

  bool get isScanning => _isScanning.value;
  bool get isLoading => _isLoading.value;
  QrCode? get scannedCode => _scannedCode.value;
  String? get error => _error.value;

  @override
  void onInit() {
    super.onInit();
    _logger.init();
  }

  // Handle QR code scanning result
  @visibleForTesting
  Future<void> handleQrCodeScanned(String code) async {
    try {
      _logger.debug('QR code scanned: $code');
      final qrCode = QrCode(
        id: '',
        code: code,
        type: QrCodeType.temporaryAccess,
        targetId: '',
        createdAt: DateTime.now(),
        isActive: true,
        metadata: {}
      );
      _scannedCode.value = qrCode;

      // Process the QR code
      final success = await _qrService.processQrCode(qrCode);
      if (!success) {
        _error.value = 'Failed to process QR code';
      }
    } catch (e) {
      _error.value = 'Invalid QR code format';
      _logger.error('Failed to handle QR code scan', e);
    }
  }

  @override
  void onClose() {
    stopScanning();
    super.onClose();
  }

  Future<QrCode> createQrCode(
    QrCodeType type,
    String targetId, {
    DateTime? expiresAt,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      _isLoading.value = true;
      _error.value = null;

      final qrCode = await _qrService.createQrCode(
        type,
        targetId,
        expiresAt: expiresAt,
        metadata: metadata,
      );

      _logger.debug('Created QR code: ${qrCode.id}');
      return qrCode;
    } catch (e) {
      _logger.error('Failed to create QR code', e);
      _error.value = 'Failed to create QR code: ${e.toString()}';
      rethrow;
    } finally {
      _isLoading.value = false;
    }
  }

  Future<Uint8List> generateQrCode(String code) async {
    try {
      _isLoading.value = true;
      _error.value = null;

      final qrImage = await _qrService.generateQrCode(code);
      _logger.debug('Generated QR code image for code');
      return qrImage;
    } catch (e) {
      _logger.error('Failed to generate QR code image', e);
      _error.value = 'Failed to generate QR code image: ${e.toString()}';
      rethrow;
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> startScanning() async {
    try {
      if (_isScanning.value) {
        _logger.warning('QR scanner is already running');
        return;
      }

      _isScanning.value = true;
      _error.value = null;
      _scannedCode.value = null;

      await _qrService.startScanning(
        onScanned: _handleQrCodeScanned,
      );

      _logger.debug('QR scanner started');
    } catch (e) {
      _logger.error('Failed to start QR scanner', e);
      _error.value = 'Failed to start QR scanner: ${e.toString()}';
      _isScanning.value = false;
      rethrow;
    }
  }

  Future<void> stopScanning() async {
    try {
      if (!_isScanning.value) {
        return;
      }

      await _qrService.stopScanning();
      _isScanning.value = false;
      _logger.debug('QR scanner stopped');
    } catch (e) {
      _logger.error('Failed to stop QR scanner', e);
      _error.value = 'Failed to stop QR scanner: ${e.toString()}';
      rethrow;
    }
  }

  void _handleQrCodeScanned(String rawCode) async {
    try {
      _isLoading.value = true;
      _error.value = null;

      final qrCode = await _qrService.getQrCodeByCode(rawCode);
      
      if (qrCode == null || !qrCode.isValid) {
        throw Exception('Invalid QR code');
      }

      _scannedCode.value = qrCode;
      await stopScanning();
      await _processQrCode(qrCode);

      _logger.debug('Processed QR code: ${qrCode.id}');
    } catch (e) {
      _logger.error('Failed to process QR code', e);
      _error.value = 'Failed to process QR code: ${e.toString()}';
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> _processQrCode(QrCode code) async {
    try {
      switch (code.type) {
        case QrCodeType.counterRoom:
          await _processCounterRoomQr(code);
          break;
        case QrCodeType.item:
          await _processItemQr(code);
          break;
        case QrCodeType.user:
          await _processUserQr(code);
          break;
        case QrCodeType.temporaryAccess:
          _logger.debug('Temporary access QR code not yet implemented');
          break;
      }
    } catch (e) {
      _logger.error('Failed to process QR code type', e);
      _error.value = 'Failed to process QR code type: ${e.toString()}';
      rethrow;
    }
  }

  Future<void> _processCounterRoomQr(QrCode code) async {
    try {
      final roomId = code.targetId;
      Get.toNamed('/counter-room/$roomId');
      _logger.debug('Navigating to counter room: $roomId');
    } catch (e) {
      _logger.error('Failed to process counter room QR', e);
      _error.value = 'Failed to process counter room QR: ${e.toString()}';
      rethrow;
    }
  }

  Future<void> _processItemQr(QrCode code) async {
    try {
      final itemId = code.targetId;
      Get.toNamed('/item/$itemId');
      _logger.debug('Navigating to item: $itemId');
    } catch (e) {
      _logger.error('Failed to process item QR', e);
      _error.value = 'Failed to process item QR: ${e.toString()}';
      rethrow;
    }
  }

  Future<void> _processUserQr(QrCode code) async {
    try {
      final userId = code.targetId;
      Get.toNamed('/profile/$userId');
      _logger.debug('Navigating to user profile: $userId');
    } catch (e) {
      _logger.error('Failed to process user QR', e);
      _error.value = 'Failed to process user QR: ${e.toString()}';
      rethrow;
    }
  }

  void clearError() {
    _error.value = null;
  }

  void clearScannedCode() {
    _scannedCode.value = null;
  }

  // Extension methods for testing
  @visibleForTesting
  void setScannedCode(QrCode? code) {
    _scannedCode.value = code;
  }

  @visibleForTesting
  void setError(String? error) {
    _error.value = error;
  }

  @visibleForTesting
  void setIsScanning(bool value) {
    _isScanning.value = value;
  }
}