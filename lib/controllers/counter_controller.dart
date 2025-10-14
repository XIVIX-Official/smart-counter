import 'package:get/get.dart';
import '../models/counter_room.dart';
import '../services/counter_service.dart';
import '../utils/logger.dart';

class CounterController extends GetxController {
  // Dependencies
  final _counterService = CounterService();
  final _logger = AppLogger();

  // Observable values
  final RxList<CounterRoom> _rooms = <CounterRoom>[].obs;
  final _selectedRoom = Rx<CounterRoom?>(null);
  final _isLoading = false.obs;
  final _error = Rx<String?>(null);

  // Getters
  List<CounterRoom> get rooms => _rooms;
  CounterRoom? get selectedRoom => _selectedRoom.value;
  bool get isLoading => _isLoading.value;
  String? get error => _error.value;

  // Load counter rooms
  Future<void> loadCounterRooms({bool forceRefresh = false}) async {
    try {
      _isLoading.value = true;
      _error.value = null;

      final rooms = await _counterService.getAllCounterRooms(
        forceRefresh: forceRefresh,
      );
      _rooms.assignAll(rooms);
    } catch (e) {
      _logger.error('Failed to load counter rooms', e);
      _error.value = 'Failed to load counter rooms: ${e.toString()}';
      rethrow;
    } finally {
      _isLoading.value = false;
    }
  }

  // Select counter room
  Future<void> selectRoom(String roomId) async {
    try {
      _isLoading.value = true;
      _error.value = null;

      final room = await _counterService.getCounterRoom(roomId);
      _selectedRoom.value = room;
    } catch (e) {
      _logger.error('Failed to select counter room', e);
      _error.value = 'Failed to select counter room: ${e.toString()}';
      rethrow;
    } finally {
      _isLoading.value = false;
    }
  }

  // Create counter room
  Future<void> createRoom(
    String name,
    String description,
    List<String> assignedUserIds,
  ) async {
    try {
      _isLoading.value = true;
      _error.value = null;

      final room = await _counterService.createCounterRoom(
        name,
        description,
        assignedUserIds,
      );
      _rooms.add(room);
    } catch (e) {
      _logger.error('Failed to create counter room', e);
      _error.value = 'Failed to create counter room: ${e.toString()}';
      rethrow;
    } finally {
      _isLoading.value = false;
    }
  }

  // Update counter room
  Future<void> updateRoom(
    String roomId,
    Map<String, dynamic> updates,
  ) async {
    try {
      _isLoading.value = true;
      _error.value = null;

      final updatedRoom = await _counterService.updateCounterRoom(
        roomId,
        updates,
      );

      final index = _rooms.indexWhere((room) => room.id == roomId);
      if (index != -1) {
        _rooms[index] = updatedRoom;
      }

      if (_selectedRoom.value?.id == roomId) {
        _selectedRoom.value = updatedRoom;
      }
    } catch (e) {
      _logger.error('Failed to update counter room', e);
      _error.value = 'Failed to update counter room: ${e.toString()}';
      rethrow;
    } finally {
      _isLoading.value = false;
    }
  }

  // Delete counter room
  Future<void> deleteRoom(String roomId) async {
    try {
      _isLoading.value = true;
      _error.value = null;

      await _counterService.deleteCounterRoom(roomId);

      _rooms.removeWhere((room) => room.id == roomId);

      if (_selectedRoom.value?.id == roomId) {
        _selectedRoom.value = null;
      }
    } catch (e) {
      _logger.error('Failed to delete counter room', e);
      _error.value = 'Failed to delete counter room: ${e.toString()}';
      rethrow;
    } finally {
      _isLoading.value = false;
    }
  }

  // Open counter room
  Future<void> openRoom(String roomId) async {
    try {
      _isLoading.value = true;
      _error.value = null;

      final updatedRoom = await _counterService.openCounterRoom(roomId);

      final index = _rooms.indexWhere((room) => room.id == roomId);
      if (index != -1) {
        _rooms[index] = updatedRoom;
      }

      if (_selectedRoom.value?.id == roomId) {
        _selectedRoom.value = updatedRoom;
      }
    } catch (e) {
      _logger.error('Failed to open counter room', e);
      _error.value = 'Failed to open counter room: ${e.toString()}';
      rethrow;
    } finally {
      _isLoading.value = false;
    }
  }

  // Close counter room
  Future<void> closeRoom(String roomId) async {
    try {
      _isLoading.value = true;
      _error.value = null;

      final updatedRoom = await _counterService.closeCounterRoom(roomId);

      final index = _rooms.indexWhere((room) => room.id == roomId);
      if (index != -1) {
        _rooms[index] = updatedRoom;
      }

      if (_selectedRoom.value?.id == roomId) {
        _selectedRoom.value = updatedRoom;
      }
    } catch (e) {
      _logger.error('Failed to close counter room', e);
      _error.value = 'Failed to close counter room: ${e.toString()}';
      rethrow;
    } finally {
      _isLoading.value = false;
    }
  }

  // Pause counter room
  Future<void> pauseRoom(String roomId) async {
    try {
      _isLoading.value = true;
      _error.value = null;

      final updatedRoom = await _counterService.pauseCounterRoom(roomId);

      final index = _rooms.indexWhere((room) => room.id == roomId);
      if (index != -1) {
        _rooms[index] = updatedRoom;
      }

      if (_selectedRoom.value?.id == roomId) {
        _selectedRoom.value = updatedRoom;
      }
    } catch (e) {
      _logger.error('Failed to pause counter room', e);
      _error.value = 'Failed to pause counter room: ${e.toString()}';
      rethrow;
    } finally {
      _isLoading.value = false;
    }
  }

  // Assign users to counter room
  Future<void> assignUsers(String roomId, List<String> userIds) async {
    try {
      _isLoading.value = true;
      _error.value = null;

      final updatedRoom = await _counterService.assignUsers(roomId, userIds);

      final index = _rooms.indexWhere((room) => room.id == roomId);
      if (index != -1) {
        _rooms[index] = updatedRoom;
      }

      if (_selectedRoom.value?.id == roomId) {
        _selectedRoom.value = updatedRoom;
      }
    } catch (e) {
      _logger.error('Failed to assign users to counter room', e);
      _error.value = 'Failed to assign users to counter room: ${e.toString()}';
      rethrow;
    } finally {
      _isLoading.value = false;
    }
  }

  // Remove users from counter room
  Future<void> removeUsers(String roomId, List<String> userIds) async {
    try {
      _isLoading.value = true;
      _error.value = null;

      final updatedRoom = await _counterService.removeUsers(roomId, userIds);

      final index = _rooms.indexWhere((room) => room.id == roomId);
      if (index != -1) {
        _rooms[index] = updatedRoom;
      }

      if (_selectedRoom.value?.id == roomId) {
        _selectedRoom.value = updatedRoom;
      }
    } catch (e) {
      _logger.error('Failed to remove users from counter room', e);
      _error.value = 'Failed to remove users from counter room: ${e.toString()}';
      rethrow;
    } finally {
      _isLoading.value = false;
    }
  }

  // Get user's counter rooms
  Future<List<CounterRoom>> getUserRooms(String userId) async {
    try {
      _isLoading.value = true;
      _error.value = null;

      return await _counterService.getUserCounterRooms(userId);
    } catch (e) {
      _logger.error('Failed to get user counter rooms', e);
      _error.value = 'Failed to get user counter rooms: ${e.toString()}';
      rethrow;
    } finally {
      _isLoading.value = false;
    }
  }

  // Clear error
  void clearError() {
    _error.value = null;
  }

  // Clear selected room
  void clearSelectedRoom() {
    _selectedRoom.value = null;
  }

  // Refresh data
  Future<void> refresh() async {
    await loadCounterRooms(forceRefresh: true);
  }
}