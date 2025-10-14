import 'package:get/get.dart';
import '../models/notification.dart';
import '../services/notification_service.dart';
import '../utils/logger.dart';

class NotificationController extends GetxController {
  // Dependencies
  final _notificationService = NotificationService();
  final _logger = AppLogger();

  // Observable values
  final RxList<AppNotification> _notifications = <AppNotification>[].obs;
  final _unreadCount = 0.obs;
  final _isLoading = false.obs;
  final _error = Rx<String?>(null);

  // Getters
  List<AppNotification> get notifications => _notifications;
  int get unreadCount => _unreadCount.value;
  bool get isLoading => _isLoading.value;
  String? get error => _error.value;

  @override
  void onInit() {
    super.onInit();
    // Initialize Firebase message handling
    _initializeFirebaseMessaging();
  }

  // Initialize Firebase Cloud Messaging
  Future<void> _initializeFirebaseMessaging() async {
    try {
      await _notificationService.initialize();
      await _notificationService.requestPermission();
      
      // Set up message handlers
      _notificationService.onMessage((notification) {
        _handleNewNotification(notification);
      });

      _notificationService.onMessageOpenedApp((notification) {
        _handleNotificationTap(notification);
      });
    } catch (e) {
      _logger.error('Failed to initialize Firebase Messaging', e);
      _error.value = 'Failed to initialize notifications: ${e.toString()}';
    }
  }

  // Load notifications
  Future<void> loadNotifications() async {
    try {
      _isLoading.value = true;
      _error.value = null;

      final notifications = await _notificationService.getNotifications();
      _notifications.assignAll(notifications);
      _updateUnreadCount();
    } catch (e) {
      _logger.error('Failed to load notifications', e);
      _error.value = 'Failed to load notifications: ${e.toString()}';
      rethrow;
    } finally {
      _isLoading.value = false;
    }
  }

  // Handle new notification
  void _handleNewNotification(AppNotification notification) {
    _notifications.insert(0, notification);
    _updateUnreadCount();
    // Show local notification if app is in foreground
    _notificationService.showLocalNotification(notification);
  }

  // Handle notification tap
  void _handleNotificationTap(AppNotification notification) {
    // Mark as read
    markAsRead(notification.id);
    // Navigate to relevant screen based on notification type
    _navigateToNotificationContent(notification);
  }

  // Navigate to notification content
  void _navigateToNotificationContent(AppNotification notification) {
    switch (notification.type) {
      case NotificationType.counterRoom:
        Get.toNamed('/counter-room/${notification.metadata['roomId']}');
        break;
      case NotificationType.item:
        Get.toNamed('/item/${notification.metadata['itemId']}');
        break;
      case NotificationType.user:
        Get.toNamed('/profile/${notification.metadata['userId']}');
        break;
      default:
        Get.toNamed('/notifications');
    }
  }

  // Mark notification as read
  Future<void> markAsRead(String notificationId) async {
    try {
      await _notificationService.markAsRead(notificationId);
      
      final index = _notifications.indexWhere((n) => n.id == notificationId);
      if (index != -1) {
        final notification = _notifications[index];
        _notifications[index] = notification.copyWith(isRead: true);
        _updateUnreadCount();
      }
    } catch (e) {
      _logger.error('Failed to mark notification as read', e);
      _error.value = 'Failed to mark notification as read: ${e.toString()}';
      rethrow;
    }
  }

  // Mark all notifications as read
  Future<void> markAllAsRead() async {
    try {
      _isLoading.value = true;
      _error.value = null;

      await _notificationService.markAllAsRead();
      
      _notifications.assignAll(
        _notifications.map((n) => n.copyWith(isRead: true)).toList(),
      );
      _updateUnreadCount();
    } catch (e) {
      _logger.error('Failed to mark all notifications as read', e);
      _error.value = 'Failed to mark all notifications as read: ${e.toString()}';
      rethrow;
    } finally {
      _isLoading.value = false;
    }
  }

  // Delete notification
  Future<void> deleteNotification(String notificationId) async {
    try {
      await _notificationService.deleteNotification(notificationId);
      _notifications.removeWhere((n) => n.id == notificationId);
      _updateUnreadCount();
    } catch (e) {
      _logger.error('Failed to delete notification', e);
      _error.value = 'Failed to delete notification: ${e.toString()}';
      rethrow;
    }
  }

  // Update FCM token
  Future<void> updateFcmToken() async {
    try {
      await _notificationService.updateFcmToken();
    } catch (e) {
      _logger.error('Failed to update FCM token', e);
      _error.value = 'Failed to update notification token: ${e.toString()}';
      rethrow;
    }
  }

  // Update unread count
  void _updateUnreadCount() {
    _unreadCount.value = _notifications.where((n) => !n.isRead).length;
  }

  // Clear error
  void clearError() {
    _error.value = null;
  }

  // Refresh notifications
  Future<void> refresh() async {
    await loadNotifications();
  }

  @override
  void onClose() {
    _notificationService.dispose();
    super.onClose();
  }
}