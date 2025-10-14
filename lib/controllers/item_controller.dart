import 'package:get/get.dart';
import '../models/item.dart';
import '../services/item_service.dart';
import '../utils/logger.dart';
import 'counter_controller.dart';

class ItemController extends GetxController {
  // Dependencies
  final _counterController = Get.find<CounterController>();
  // Dependencies
  final _itemService = ItemService();
  final _logger = AppLogger();

  // Observable values
  final RxList<Item> _items = <Item>[].obs;
  final _selectedItem = Rx<Item?>(null);
  final _isLoading = false.obs;
  final _error = Rx<String?>(null);

  // Getters
  List<Item> get items => _items;
  Item? get selectedItem => _selectedItem.value;
  bool get isLoading => _isLoading.value;
  String? get error => _error.value;

  // Load items by counter room
  Future<void> loadItems(
    String counterRoomId, {
    bool forceRefresh = false,
  }) async {
    try {
      _isLoading.value = true;
      _error.value = null;

      final items = await _itemService.getItemsByCounterRoom(
        counterRoomId,
        forceRefresh: forceRefresh,
      );
      _items.assignAll(items);
    } catch (e) {
      _logger.error('Failed to load items', e);
      _error.value = 'Failed to load items: ${e.toString()}';
      rethrow;
    } finally {
      _isLoading.value = false;
    }
  }

  // Select item
  Future<void> selectItem(String itemId) async {
    try {
      _isLoading.value = true;
      _error.value = null;

      final item = await _itemService.getItem(itemId);
      _selectedItem.value = item;
    } catch (e) {
      _logger.error('Failed to select item', e);
      _error.value = 'Failed to select item: ${e.toString()}';
      rethrow;
    } finally {
      _isLoading.value = false;
    }
  }

  // Create item
  Future<void> createItem(
    String name,
    String description,
    String counterRoomId,
    String qrCode, {
    Map<String, dynamic>? metadata,
    int quantity = 1,
  }) async {
    try {
      _isLoading.value = true;
      _error.value = null;

      final item = await _itemService.createItem(
        name,
        description,
        counterRoomId,
        qrCode,
        metadata: metadata,
        quantity: quantity,
      );
      _items.add(item);
    } catch (e) {
      _logger.error('Failed to create item', e);
      _error.value = 'Failed to create item: ${e.toString()}';
      rethrow;
    } finally {
      _isLoading.value = false;
    }
  }

  // Update item
  Future<void> updateItem(
    String itemId,
    Map<String, dynamic> updates,
  ) async {
    try {
      _isLoading.value = true;
      _error.value = null;

      final updatedItem = await _itemService.updateItem(
        itemId,
        updates,
      );

      final index = _items.indexWhere((item) => item.id == itemId);
      if (index != -1) {
        _items[index] = updatedItem;
      }

      if (_selectedItem.value?.id == itemId) {
        _selectedItem.value = updatedItem;
      }
    } catch (e) {
      _logger.error('Failed to update item', e);
      _error.value = 'Failed to update item: ${e.toString()}';
      rethrow;
    } finally {
      _isLoading.value = false;
    }
  }

  // Delete item
  Future<void> deleteItem(String itemId, String counterRoomId) async {
    try {
      _isLoading.value = true;
      _error.value = null;

      await _itemService.deleteItem(itemId, counterRoomId);

      _items.removeWhere((item) => item.id == itemId);

      if (_selectedItem.value?.id == itemId) {
        _selectedItem.value = null;
      }
    } catch (e) {
      _logger.error('Failed to delete item', e);
      _error.value = 'Failed to delete item: ${e.toString()}';
      rethrow;
    } finally {
      _isLoading.value = false;
    }
  }

  // Change item status
  Future<void> changeItemStatus(
    String itemId,
    ItemStatus status, {
    Map<String, dynamic>? metadata,
  }) async {
    try {
      _isLoading.value = true;
      _error.value = null;

      final updatedItem = await _itemService.changeItemStatus(
        itemId,
        status,
        metadata: metadata,
      );

      final index = _items.indexWhere((item) => item.id == itemId);
      if (index != -1) {
        _items[index] = updatedItem;
      }

      if (_selectedItem.value?.id == itemId) {
        _selectedItem.value = updatedItem;
      }
    } catch (e) {
      _logger.error('Failed to change item status', e);
      _error.value = 'Failed to change item status: ${e.toString()}';
      rethrow;
    } finally {
      _isLoading.value = false;
    }
  }

  // Assign item
  Future<void> assignItem(String itemId, String userId) async {
    try {
      _isLoading.value = true;
      _error.value = null;

      final updatedItem = await _itemService.assignItem(itemId, userId);

      final index = _items.indexWhere((item) => item.id == itemId);
      if (index != -1) {
        _items[index] = updatedItem;
      }

      if (_selectedItem.value?.id == itemId) {
        _selectedItem.value = updatedItem;
      }
    } catch (e) {
      _logger.error('Failed to assign item', e);
      _error.value = 'Failed to assign item: ${e.toString()}';
      rethrow;
    } finally {
      _isLoading.value = false;
    }
  }

  // Unassign item
  Future<void> unassignItem(String itemId) async {
    try {
      _isLoading.value = true;
      _error.value = null;

      final updatedItem = await _itemService.unassignItem(itemId);

      final index = _items.indexWhere((item) => item.id == itemId);
      if (index != -1) {
        _items[index] = updatedItem;
      }

      if (_selectedItem.value?.id == itemId) {
        _selectedItem.value = updatedItem;
      }
    } catch (e) {
      _logger.error('Failed to unassign item', e);
      _error.value = 'Failed to unassign item: ${e.toString()}';
      rethrow;
    } finally {
      _isLoading.value = false;
    }
  }

  // Complete item
  Future<void> completeItem(
    String itemId, {
    Map<String, dynamic>? metadata,
  }) async {
    try {
      _isLoading.value = true;
      _error.value = null;

      final updatedItem = await _itemService.completeItem(
        itemId,
        metadata: metadata,
      );

      final index = _items.indexWhere((item) => item.id == itemId);
      if (index != -1) {
        _items[index] = updatedItem;
      }

      if (_selectedItem.value?.id == itemId) {
        _selectedItem.value = updatedItem;
      }
    } catch (e) {
      _logger.error('Failed to complete item', e);
      _error.value = 'Failed to complete item: ${e.toString()}';
      rethrow;
    } finally {
      _isLoading.value = false;
    }
  }

  // Cancel item
  Future<void> cancelItem(
    String itemId, {
    Map<String, dynamic>? metadata,
  }) async {
    try {
      _isLoading.value = true;
      _error.value = null;

      final updatedItem = await _itemService.cancelItem(
        itemId,
        metadata: metadata,
      );

      final index = _items.indexWhere((item) => item.id == itemId);
      if (index != -1) {
        _items[index] = updatedItem;
      }

      if (_selectedItem.value?.id == itemId) {
        _selectedItem.value = updatedItem;
      }
    } catch (e) {
      _logger.error('Failed to cancel item', e);
      _error.value = 'Failed to cancel item: ${e.toString()}';
      rethrow;
    } finally {
      _isLoading.value = false;
    }
  }

  // Get user items
  Future<List<Item>> getUserItems(
    String userId, {
    bool? isCompleted,
  }) async {
    try {
      _isLoading.value = true;
      _error.value = null;

      return await _itemService.getUserItems(userId, isCompleted: isCompleted);
    } catch (e) {
      _logger.error('Failed to get user items', e);
      _error.value = 'Failed to get user items: ${e.toString()}';
      rethrow;
    } finally {
      _isLoading.value = false;
    }
  }

  // Clear error
  void clearError() {
    _error.value = null;
  }

  // Clear selected item
  void clearSelectedItem() {
    _selectedItem.value = null;
  }

  // Override refresh from ListNotifierMixin
  @override
  void refresh() {
    if (_counterController.selectedRoom == null) return;
    loadItems(_counterController.selectedRoom!.id, forceRefresh: true);
  }
}