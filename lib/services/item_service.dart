import '../models/item.dart';
import '../utils/logger.dart';
import 'api_service.dart';
import 'storage_service.dart';

class ItemService {
  // Singleton instance
  static final ItemService _instance = ItemService._internal();
  factory ItemService() => _instance;
  ItemService._internal();

  // Dependencies
  final _apiService = ApiService();
  final _storageService = StorageService();
  final _logger = AppLogger();

  // Constants
  static const String _cacheKeyPrefix = 'items_';
  static const Duration _cacheDuration = Duration(minutes: 5);

  // Get items by counter room
  Future<List<Item>> getItemsByCounterRoom(
    String counterRoomId, {
    bool forceRefresh = false,
  }) async {
    try {
      final cacheKey = '${_cacheKeyPrefix}$counterRoomId';

      // Check cache first if not forcing refresh
      if (!forceRefresh) {
        final cached = _storageService.getFromCache<List<dynamic>>(cacheKey);
        if (cached != null) {
          return cached
              .map((json) => Item.fromJson(json as Map<String, dynamic>))
              .toList();
        }
      }

      // Fetch from API
      final response = await _apiService.get<List<dynamic>>(
        '/counter-rooms/$counterRoomId/items',
      );

      // Convert response to list of Item objects
      final items = response
          .map((json) => Item.fromJson(json as Map<String, dynamic>))
          .toList();

      // Cache the result
      await _storageService.saveToCache(cacheKey, response, duration: _cacheDuration);

      return items;
    } catch (e) {
      _logger.error('Failed to get items for counter room: $counterRoomId', e);
      rethrow;
    }
  }

  // Get item by ID
  Future<Item> getItem(String id) async {
    try {
      final response = await _apiService.get<Map<String, dynamic>>(
        '/items/$id',
      );
      return Item.fromJson(response);
    } catch (e) {
      _logger.error('Failed to get item: $id', e);
      rethrow;
    }
  }

  // Create item
  Future<Item> createItem(
    String name,
    String description,
    String counterRoomId,
    String qrCode, {
    Map<String, dynamic>? metadata,
    int quantity = 1,
  }) async {
    try {
      final response = await _apiService.post<Map<String, dynamic>>(
        '/items',
        data: {
          'name': name,
          'description': description,
          'counterRoomId': counterRoomId,
          'qrCode': qrCode,
          'status': ItemStatus.pending.name,
          'metadata': metadata ?? {},
          'quantity': quantity,
        },
      );

      final item = Item.fromJson(response);

      // Clear cache for the counter room
      await _storageService.removeFromCache('${_cacheKeyPrefix}$counterRoomId');

      return item;
    } catch (e) {
      _logger.error('Failed to create item', e);
      rethrow;
    }
  }

  // Update item
  Future<Item> updateItem(
    String id,
    Map<String, dynamic> updates,
  ) async {
    try {
      final response = await _apiService.put<Map<String, dynamic>>(
        '/items/$id',
        data: updates,
      );

      final item = Item.fromJson(response);

      // Clear cache for the counter room
      await _storageService
          .removeFromCache('${_cacheKeyPrefix}${item.counterRoomId}');

      return item;
    } catch (e) {
      _logger.error('Failed to update item: $id', e);
      rethrow;
    }
  }

  // Delete item
  Future<void> deleteItem(String id, String counterRoomId) async {
    try {
      await _apiService.delete<void>(
        '/items/$id',
      );

      // Clear cache for the counter room
      await _storageService.removeFromCache('${_cacheKeyPrefix}$counterRoomId');
    } catch (e) {
      _logger.error('Failed to delete item: $id', e);
      rethrow;
    }
  }

  // Change item status
  Future<Item> changeItemStatus(
    String id,
    ItemStatus status, {
    Map<String, dynamic>? metadata,
  }) async {
    return updateItem(id, {
      'status': status.name,
      if (metadata != null) 'metadata': metadata,
    });
  }

  // Assign item to user
  Future<Item> assignItem(String id, String userId) async {
    return updateItem(id, {
      'assignedUserId': userId,
      'status': ItemStatus.processing.name,
    });
  }

  // Unassign item
  Future<Item> unassignItem(String id) async {
    return updateItem(id, {
      'assignedUserId': null,
      'status': ItemStatus.pending.name,
    });
  }

  // Complete item
  Future<Item> completeItem(
    String id, {
    Map<String, dynamic>? metadata,
  }) {
    return changeItemStatus(
      id,
      ItemStatus.completed,
      metadata: metadata,
    );
  }

  // Cancel item
  Future<Item> cancelItem(
    String id, {
    Map<String, dynamic>? metadata,
  }) {
    return changeItemStatus(
      id,
      ItemStatus.cancelled,
      metadata: metadata,
    );
  }

  // Get all items for a user
  Future<List<Item>> getUserItems(
    String userId, {
    bool? isCompleted,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        if (isCompleted != null) 'completed': isCompleted,
      };

      final response = await _apiService.get<List<dynamic>>(
        '/users/$userId/items',
        queryParameters: queryParams,
      );

      return response
          .map((json) => Item.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      _logger.error('Failed to get user items: $userId', e);
      rethrow;
    }
  }

  // Clear cache for a counter room
  Future<void> clearCache(String counterRoomId) async {
    await _storageService.removeFromCache('${_cacheKeyPrefix}$counterRoomId');
  }

  // Clear all caches
  Future<void> clearAllCaches() async {
    await _storageService.clearCache();
  }
}