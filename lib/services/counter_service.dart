import '../models/counter_room.dart';
import '../utils/logger.dart';
import 'api_service.dart';
import 'storage_service.dart';

class CounterService {
  // Singleton instance
  static final CounterService _instance = CounterService._internal();
  factory CounterService() => _instance;
  CounterService._internal();

  // Dependencies
  final _apiService = ApiService();
  final _storageService = StorageService();
  final _logger = AppLogger();

  // Constants
  static const String _cacheKey = 'counter_rooms';
  static const Duration _cacheDuration = Duration(minutes: 5);

  // Get all counter rooms
  Future<List<CounterRoom>> getAllCounterRooms({
    bool forceRefresh = false,
  }) async {
    try {
      // Check cache first if not forcing refresh
      if (!forceRefresh) {
        final cached = _storageService.getFromCache<List<dynamic>>(_cacheKey);
        if (cached != null) {
          return cached
              .map((json) => CounterRoom.fromJson(json as Map<String, dynamic>))
              .toList();
        }
      }

      // Fetch from API
      final response = await _apiService.get<List<dynamic>>(
        '/counter-rooms',
      );

      // Convert response to list of CounterRoom objects
      final rooms = response
          .map((json) => CounterRoom.fromJson(json as Map<String, dynamic>))
          .toList();

      // Cache the result
      await _storageService.saveToCache(_cacheKey, response, duration: _cacheDuration);

      return rooms;
    } catch (e) {
      _logger.error('Failed to get counter rooms', e);
      rethrow;
    }
  }

  // Get counter room by ID
  Future<CounterRoom> getCounterRoom(String id) async {
    try {
      final response = await _apiService.get<Map<String, dynamic>>(
        '/counter-rooms/$id',
      );
      return CounterRoom.fromJson(response);
    } catch (e) {
      _logger.error('Failed to get counter room: $id', e);
      rethrow;
    }
  }

  // Create counter room
  Future<CounterRoom> createCounterRoom(
    String name,
    String description,
    List<String> assignedUserIds,
  ) async {
    try {
      final response = await _apiService.post<Map<String, dynamic>>(
        '/counter-rooms',
        data: {
          'name': name,
          'description': description,
          'assignedUserIds': assignedUserIds,
          'status': CounterRoomStatus.closed.name,
        },
      );

      final room = CounterRoom.fromJson(response);

      // Clear cache to force refresh
      await _storageService.removeFromCache(_cacheKey);

      return room;
    } catch (e) {
      _logger.error('Failed to create counter room', e);
      rethrow;
    }
  }

  // Update counter room
  Future<CounterRoom> updateCounterRoom(
    String id,
    Map<String, dynamic> updates,
  ) async {
    try {
      final response = await _apiService.put<Map<String, dynamic>>(
        '/counter-rooms/$id',
        data: updates,
      );

      final room = CounterRoom.fromJson(response);

      // Clear cache to force refresh
      await _storageService.removeFromCache(_cacheKey);

      return room;
    } catch (e) {
      _logger.error('Failed to update counter room: $id', e);
      rethrow;
    }
  }

  // Delete counter room
  Future<void> deleteCounterRoom(String id) async {
    try {
      await _apiService.delete<void>(
        '/counter-rooms/$id',
      );

      // Clear cache to force refresh
      await _storageService.removeFromCache(_cacheKey);
    } catch (e) {
      _logger.error('Failed to delete counter room: $id', e);
      rethrow;
    }
  }

  // Open counter room
  Future<CounterRoom> openCounterRoom(String id) async {
    return updateCounterRoom(id, {
      'status': CounterRoomStatus.open.name,
    });
  }

  // Close counter room
  Future<CounterRoom> closeCounterRoom(String id) async {
    return updateCounterRoom(id, {
      'status': CounterRoomStatus.closed.name,
    });
  }

  // Pause counter room
  Future<CounterRoom> pauseCounterRoom(String id) async {
    return updateCounterRoom(id, {
      'status': CounterRoomStatus.paused.name,
    });
  }

  // Assign users to counter room
  Future<CounterRoom> assignUsers(String id, List<String> userIds) async {
    return updateCounterRoom(id, {
      'assignedUserIds': userIds,
    });
  }

  // Remove users from counter room
  Future<CounterRoom> removeUsers(String id, List<String> userIds) async {
    final room = await getCounterRoom(id);
    final updatedUserIds =
        room.assignedUserIds.where((uid) => !userIds.contains(uid)).toList();

    return updateCounterRoom(id, {
      'assignedUserIds': updatedUserIds,
    });
  }

  // Get all rooms for a user
  Future<List<CounterRoom>> getUserCounterRooms(String userId) async {
    try {
      final response = await _apiService.get<List<dynamic>>(
        '/users/$userId/counter-rooms',
      );

      return response
          .map((json) => CounterRoom.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      _logger.error('Failed to get user counter rooms: $userId', e);
      rethrow;
    }
  }

  // Clear cache
  Future<void> clearCache() async {
    await _storageService.removeFromCache(_cacheKey);
  }
}