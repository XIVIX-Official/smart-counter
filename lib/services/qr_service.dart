import 'dart:convert';
import 'dart:typed_data';
import 'package:qr_flutter/qr_flutter.dart' as qr_flutter;
import '../models/qr_code.dart';
import '../utils/logger.dart';
import 'api_service.dart';
import '../exceptions/api_exception.dart';
import 'storage_service.dart';

/// Service for managing QR code operations including generation, scanning, and storage.
/// 
/// This service follows the singleton pattern to ensure only one instance exists
/// throughout the app lifecycle. It handles:
/// - QR code generation for items and counter rooms
/// - QR code scanning and validation
/// - Caching of QR codes
/// - API communication for QR code operations
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

  /// Starts scanning for QR codes.
  /// 
  /// [onScanned] is called when a valid QR code is scanned.
  Future<void> startScanning({required void Function(String) onScanned}) async {
    try {
      _logger.debug('Starting QR code scanner');
      throw UnimplementedError('Platform-specific implementation required');
    } catch (e) {
      _logger.error('Failed to start QR code scanner', e);
      rethrow;
    }
  }

  /// Stops the QR code scanner.
  /// 
  /// This method cleans up resources and stops the scanning process.
  Future<void> stopScanning() async {
    try {
      _logger.debug('QR code scanner stopped');
    } catch (e) {
      _logger.error('Failed to stop QR code scanner', e);
      rethrow;
    }
  }

  /// Create a new QR code in the system.
  /// 
  /// [type] is the type of entity this QR code is for.
  /// [targetId] is the ID of the entity.
  /// [expiresAt] optionally sets when this QR code should expire.
  /// [metadata] optional additional data to store with the QR code.
  /// Returns the created QR code.
  Future<QrCode> createQrCode(
    QrCodeType type,
    String targetId, {
    DateTime? expiresAt,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      _logger.debug('Creating QR code');
      
      final response = await _apiService.post<Map<String, dynamic>>(
        '/qr-codes',
        data: {
          'type': type.toString().split('.').last,
          'targetId': targetId,
          if (expiresAt != null) 'expiresAt': expiresAt.toIso8601String(),
          if (metadata != null) 'metadata': metadata,
        },
      );

      final qrCode = QrCode.fromJson(response);

      // Cache the result
      await _storageService.saveToCache(
        '${_cacheKeyPrefix}${qrCode.id}',
        response,
      );

      _logger.debug('Created QR code with ID: ${qrCode.id}');
      return qrCode;
    } catch (e) {
      _logger.error('Failed to create QR code', e);
      rethrow;
    }
  }

  /// Process a scanned QR code and validate it against the system.
  /// 
  /// Returns true if the QR code is valid and exists in the system.
  Future<bool> processQrCode(QrCode qrCode) async {
    try {
      _logger.debug('Processing QR code: ${qrCode.code}');
      final existingCode = await getQrCodeByCode(qrCode.code);
      return existingCode?.isValid ?? false;
    } catch (e) {
      _logger.error('Failed to process QR code', e);
      return false;
    }
  }

  /// Verify a QR code by its code string.
  /// 
  /// This is a convenience method that checks if a QR code exists and is valid.
  /// Returns true if the code is valid and active.
  Future<bool> verifyQrCode(String code) async {
    try {
      final qrCode = await getQrCodeByCode(code);
      return qrCode?.isValid ?? false;
    } catch (e) {
      _logger.error('Failed to verify QR code', e);
      return false;
    }
  }

  /// Generate a QR code image as a byte array.
  /// 
  /// [data] is the string data to encode in the QR code.
  /// [size] is the size of the generated QR code image in pixels.
  /// Returns the QR code image as a [Uint8List].
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

  /// Get a QR code by its ID.
  /// 
  /// [id] is the unique identifier of the QR code.
  /// [forceRefresh] when true, bypasses the cache and fetches from API.
  /// Returns the QR code if found, null otherwise.
  Future<QrCode?> getQrCode(
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
      try {
        final response = await _apiService.get<Map<String, dynamic>>(
          '/qr-codes/$id',
        );

        final qrCode = QrCode.fromJson(response);

        // Cache the result
        await _storageService.saveToCache(cacheKey, response);

        return qrCode;
      } on ApiException {
        return null;
      }
    } catch (e) {
      _logger.error('Failed to get QR code: $id', e);
      return null;
    }
  }

  /// Get a QR code by its encoded string value.
  /// 
  /// [code] is the actual QR code string value.
  /// [forceRefresh] when true, bypasses the cache and fetches from API.
  /// Returns the QR code if found, null otherwise.
  Future<QrCode?> getQrCodeByCode(
    String code, {
    bool forceRefresh = false,
  }) async {
    try {
      final cacheKey = '${_cacheKeyPrefix}code_$code';

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
      try {
        final response = await _apiService.get<Map<String, dynamic>>(
          '/qr-codes/code/$code',
        );

        final qrCode = QrCode.fromJson(response);

        // Cache the result
        await _storageService.saveToCache(cacheKey, response);

        return qrCode;
      } on ApiException {
        return null;
      }
    } catch (e) {
      _logger.error('Failed to get QR code by code: $code', e);
      return null;
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
      if (qrCode == null) return false;
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