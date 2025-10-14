import 'dart:convert';
import 'dart:typed_data';
import 'package:qr_flutter/qr_flutter.dart' as qr_flutter;
import '../models/qr_code.dart';
import '../utils/logger.dart';
import 'api_service.dart';
import 'storage_service.dart';

class QrService {
  // Dependencies
  final ApiService _apiService;
  final StorageService _storageService;
  final AppLogger _logger;

  // Constants
  static const String _cacheKeyPrefix = 'qr_code_';

  // Singleton instance
  static QrService? _instance;
  
  factory QrService({
    ApiService? apiService,
    StorageService? storageService,
    AppLogger? logger,
  }) {
    _instance ??= QrService._(
      apiService: apiService,
      storageService: storageService,
      logger: logger,
    );
    return _instance!;
  }

  QrService._({
    ApiService? apiService,
    StorageService? storageService,
    AppLogger? logger,
  })  : _apiService = apiService ?? ApiService(),
        _storageService = storageService ?? StorageService(),
        _logger = logger ?? AppLogger();

  // Start QR Code scanning
  Future<void> startScanning({
    required Function(String) onScanned,
  }) async {
    try {
      if (_isScanning) {
        throw Exception('QR code scanner is already running');
      }

      _isScanning = true;
      _onQrCodeScanned = onScanned;
      _logger.debug('QR code scanner started');
    } catch (e) {
      _logger.error('Failed to start QR code scanner', e);
      rethrow;
    }
  }

  // Stop QR Code scanning
  Future<void> stopScanning() async {
    try {
      _isScanning = false;
      _onQrCodeScanned = null;
      _logger.debug('QR code scanner stopped');
    } catch (e) {
      _logger.error('Failed to stop QR code scanner', e);
      rethrow;
    }
  }

  // Process a scanned QR code
  Future<bool> processQrCode(QrCode qrCode) async {
    try {
      _logger.debug('Processing QR code: ${qrCode.code}');
      // For now, just verify if the QR code exists and is valid
      final existingCode = await getQrCodeByCode(qrCode.code);
      if (existingCode == null) {
        return false;
      }
      return existingCode.isValid;
    } catch (e) {
      _logger.error('Failed to process QR code', e);
      return false;
    }
  }





  // Verify QR Code
  Future<bool> verifyQrCode(String code) async {
    try {
      final qrCode = await getQrCodeByCode(code);
      return qrCode?.isValid ?? false;
    } catch (e) {
      _logger.error('Failed to verify QR code', e);
      return false;
    }
  }

  // Generate QR Code
  Future<Uint8List> generateQrCode(
    String data, {
    double size = 200.0,
  }) async {
    try {
      _logger.debug('Generating QR code for: $data');

      final qrImage = await qr_flutter.QrPainter(
        data: data,
        version: qr_flutter.QrVersions.auto,
        errorCorrectionLevel: qr_flutter.QrErrorCorrectLevel.H,
      ).toImageData(size);

      if (qrImage == null) {
        throw Exception('Failed to generate QR code image');
      }

      return qrImage.buffer.asUint8List();
    } catch (e) {
      _logger.error('Failed to generate QR code', e);
      rethrow;
    }
  }

  // Get QR Code by ID
  Future<QrCode> getQrCode(
    String id, {
    bool forceRefresh = false,
  }) async {
    try {
      final cacheKey = '${_cacheKeyPrefix}$id';

      // Check cache first if not forcing refresh
      if (!forceRefresh) {
        final cached = _storageService.getFromCache<Map<String, dynamic>>(
          cacheKey,
        );
        if (cached != null) {
          return QrCode.fromJson(cached);
        }
      }

      // Fetch from API
      final response = await _apiService.get<Map<String, dynamic>>(
        '/qr-codes/$id',
      );

      // Cache the result
      await _storageService.saveToCache(cacheKey, response);

      return QrCode.fromJson(response);
    } catch (e) {
      _logger.error('Failed to get QR code: $id', e);
      rethrow;
    }
  }

  // Get QR Code by code
  Future<QrCode> getQrCodeByCode(
    String code, {
    bool forceRefresh = false,
  }) async {
    try {
      final response = await _apiService.get<Map<String, dynamic>>(
        '/qr-codes/code/$code',
      );

      final qrCode = QrCode.fromJson(response);

      // Cache the result
      await _storageService.saveToCache(
        '${_cacheKeyPrefix}${qrCode.id}',
        response,
      );

      return qrCode;
    } catch (e) {
      _logger.error('Failed to get QR code by code: $code', e);
      rethrow;
    }
  }

  // Update QR Code
  Future<QrCode> updateQrCode(
    String id,
    Map<String, dynamic> updates,
  ) async {
    try {
      final response = await _apiService.put<Map<String, dynamic>>(
        '/qr-codes/$id',
        data: updates,
      );

      final qrCode = QrCode.fromJson(response);

      // Update cache
      await _storageService.saveToCache(
        '${_cacheKeyPrefix}${qrCode.id}',
        response,
      );

      return qrCode;
    } catch (e) {
      _logger.error('Failed to update QR code: $id', e);
      rethrow;
    }
  }

  // Delete QR Code
  Future<void> deleteQrCode(String id) async {
    try {
      await _apiService.delete<void>(
        '/qr-codes/$id',
      );

      // Remove from cache
      await _storageService.removeFromCache('${_cacheKeyPrefix}$id');
    } catch (e) {
      _logger.error('Failed to delete QR code: $id', e);
      rethrow;
    }
  }

  // Validate QR Code
  Future<bool> validateQrCode(String code) async {
    try {
      final qrCode = await getQrCodeByCode(code);
      return qrCode.isValid;
    } catch (e) {
      _logger.error('Failed to validate QR code: $code', e);
      return false;
    }
  }

  // Parse QR Code data
  Map<String, dynamic>? parseQrCodeData(String data) {
    try {
      return json.decode(data) as Map<String, dynamic>;
    } catch (e) {
      _logger.error('Failed to parse QR code data', e);
      return null;
    }
  }

  // Clear cache for a QR code
  Future<void> clearCache(String id) async {
    await _storageService.removeFromCache('${_cacheKeyPrefix}$id');
  }

  // Clear all caches
  Future<void> clearAllCaches() async {
    await _storageService.clearCache();
  }
}