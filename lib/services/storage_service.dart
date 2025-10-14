import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../utils/logger.dart';

class StorageService {
  // Singleton instance
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  // Constants
  static const String _authTokenKey = 'auth_token';
  static const String _userBox = 'user_box';
  static const String _settingsBox = 'settings_box';
  static const String _cacheBox = 'cache_box';

  // Dependencies
  late final SharedPreferences _prefs;
  late final Box _userBoxInstance;
  late final Box _settingsBoxInstance;
  late final Box _cacheBoxInstance;
  final _logger = AppLogger();

  // Auth methods
  Future<void> clearAuthData() async {
    try {
      await _prefs.remove(_authTokenKey);
      await _userBoxInstance.clear();
      _logger.debug('Auth data cleared successfully');
    } catch (e, st) {
      _logger.error('Failed to clear auth data', e, st);
      rethrow;
    }
  }

  // Initialize the service
  Future<void> init() async {
    try {
      // Initialize SharedPreferences
      _prefs = await SharedPreferences.getInstance();

      // Initialize Hive
      await Hive.initFlutter();

      // Open Hive boxes
      _userBoxInstance = await Hive.openBox(_userBox);
      _settingsBoxInstance = await Hive.openBox(_settingsBox);
      _cacheBoxInstance = await Hive.openBox(_cacheBox);

      _logger.info('Storage service initialized');
    } catch (e) {
      _logger.error('Failed to initialize storage service', e);
      rethrow;
    }
  }

  // Auth Token Management
  Future<void> saveAuthToken(String token) async {
    await _prefs.setString(_authTokenKey, token);
  }

  String? getAuthToken() {
    return _prefs.getString(_authTokenKey);
  }

  Future<void> clearAuthToken() async {
    await _prefs.remove(_authTokenKey);
  }

  // User Data Management
  Future<void> saveUserData(String key, dynamic value) async {
    await _userBoxInstance.put(key, value);
  }

  T? getUserData<T>(String key) {
    return _userBoxInstance.get(key) as T?;
  }

  Future<void> deleteUserData(String key) async {
    await _userBoxInstance.delete(key);
  }

  Future<void> clearUserData() async {
    await _userBoxInstance.clear();
  }

  // Settings Management
  Future<void> saveSetting(String key, dynamic value) async {
    await _settingsBoxInstance.put(key, value);
  }

  T? getSetting<T>(String key) {
    return _settingsBoxInstance.get(key) as T?;
  }

  Future<void> deleteSetting(String key) async {
    await _settingsBoxInstance.delete(key);
  }

  Future<void> clearSettings() async {
    await _settingsBoxInstance.clear();
  }

  // Cache Management
  Future<void> saveToCache(
    String key,
    dynamic value, {
    Duration? duration = const Duration(minutes: 5),
  }) async {
    try {
      final expiryTime = duration != null
          ? DateTime.now().add(duration)
          : null;

      await _cacheBoxInstance.put(key, {
        'data': value,
        'expiry': expiryTime,
      });
      _logger.debug('Saved to cache: $key');
    } catch (e, st) {
      _logger.error('Failed to save to cache', e, st);
      rethrow;
    }
  }

  T? getFromCache<T>(String key) {
    try {
      final cacheEntry = _cacheBoxInstance.get(key);
      if (cacheEntry == null) {
        return null;
      }

      final expiryTime = cacheEntry['expiry'] as DateTime?;
      if (expiryTime != null && expiryTime.isBefore(DateTime.now())) {
        _cacheBoxInstance.delete(key);
        return null;
      }

      return cacheEntry['data'] as T;
    } catch (e, st) {
      _logger.error('Failed to retrieve from cache', e, st);
      return null;
    }
  }

  Future<void> removeFromCache(String key) async {
    try {
      await _cacheBoxInstance.delete(key);
      _logger.debug('Removed from cache: $key');
    } catch (e, st) {
      _logger.error('Failed to remove from cache', e, st);
      rethrow;
    }
  }

  Future<void> clearCache() async {
    try {
      await _cacheBoxInstance.clear();
      _logger.debug('Cache cleared');
    } catch (e, st) {
      _logger.error('Failed to clear cache', e, st);
      rethrow;
    }
  }

  // Generic Storage Methods
  Future<void> saveData(String box, String key, dynamic value) async {
    final boxInstance = await Hive.openBox(box);
    await boxInstance.put(key, value);
    await boxInstance.close();
  }

  Future<T?> getData<T>(String box, String key) async {
    final boxInstance = await Hive.openBox(box);
    final value = boxInstance.get(key) as T?;
    await boxInstance.close();
    return value;
  }

  Future<void> deleteData(String box, String key) async {
    final boxInstance = await Hive.openBox(box);
    await boxInstance.delete(key);
    await boxInstance.close();
  }

  Future<void> clearBox(String box) async {
    final boxInstance = await Hive.openBox(box);
    await boxInstance.clear();
    await boxInstance.close();
  }

  // Clean up resources
  Future<void> dispose() async {
    await Hive.close();
  }
}