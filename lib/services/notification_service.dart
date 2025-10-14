import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../models/notification.dart' as app;
import '../utils/logger.dart';
import 'api_service.dart';
import 'storage_service.dart';

class NotificationService {
  // Singleton instance
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  // Dependencies
  final _messaging = FirebaseMessaging.instance;
  late final FlutterLocalNotificationsPlugin _localNotifications;
  final _apiService = ApiService();
  final _storageService = StorageService();
  final _logger = AppLogger();

  // Stream controllers
  final _notificationController =
      StreamController<app.AppNotification>.broadcast();

  // Message handlers
  Function(app.AppNotification)? _onMessageCallback;
  Function(app.AppNotification)? _onMessageOpenedAppCallback;

  // Getters
  Stream<app.AppNotification> get notificationStream =>
      _notificationController.stream;

  // Set message handlers
  void onMessage(Function(app.AppNotification) callback) {
    _onMessageCallback = callback;
  }

  void onMessageOpenedApp(Function(app.AppNotification) callback) {
    _onMessageOpenedAppCallback = callback;
  }

  Future<void> initialize() async => await init();

  Future<void> requestPermission() async => await _requestPermission();

  Future<void> updateFcmToken() async {
    try {
      final token = await _messaging.getToken();
      if (token != null) {
        await _apiService.updateFcmToken(token);
        _logger.debug('FCM token updated successfully');
      }
    } catch (e) {
      _logger.error('Failed to update FCM token', e);
      rethrow;
    }
  }

  void showLocalNotification(app.AppNotification notification) async {
    await _showLocalNotification(notification);
  }

  Future<void> deleteNotification(String notificationId) async {
    try {
      await _apiService.deleteNotification(notificationId);
      _logger.debug('Notification deleted successfully');
    } catch (e) {
      _logger.error('Failed to delete notification', e);
      rethrow;
    }
  }

  // Initialize the service
  Future<void> init() async {
    try {
      // Initialize local notifications
      _localNotifications = FlutterLocalNotificationsPlugin();

      // Configure local notifications
      const initializationSettings = InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(),
      );

      await _localNotifications.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: _handleLocalNotificationTap,
      );

      // Request permission for push notifications
      await _requestPermission();

      // Configure FCM
      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
      FirebaseMessaging.onMessageOpenedApp.listen(_handleBackgroundMessage);
      FirebaseMessaging.onBackgroundMessage(_handleBackgroundMessage);

      // Get FCM token
      final token = await _messaging.getToken();
      if (token != null) {
        await _updateFcmToken(token);
      }

      // Listen for token refresh
      _messaging.onTokenRefresh.listen(_updateFcmToken);

      _logger.info('Notification service initialized');
    } catch (e) {
      _logger.error('Failed to initialize notification service', e);
      rethrow;
    }
  }

  // Request push notification permission
  Future<void> _requestPermission() async {
    try {
      final settings = await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        announcement: false,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
      );

      _logger.info(
        'Notification permission status: ${settings.authorizationStatus}',
      );
    } catch (e) {
      _logger.error('Failed to request notification permission', e);
      rethrow;
    }
  }

  // Update FCM token
  Future<void> _updateFcmToken(String token) async {
    try {
      await _apiService.post<void>(
        '/users/fcm-token',
        data: {'token': token},
      );
      _logger.info('FCM token updated');
    } catch (e) {
      _logger.error('Failed to update FCM token', e);
    }
  }

  // Handle foreground message
  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    try {
      final notification = _parseNotification(message);
      if (notification != null) {
        _notificationController.add(notification);
        await _showLocalNotification(notification);
      }
    } catch (e) {
      _logger.error('Error handling foreground message', e);
    }
  }

  // Handle background message
  Future<void> _handleBackgroundMessage(RemoteMessage message) async {
    try {
      final notification = _parseNotification(message);
      if (notification != null) {
        _notificationController.add(notification);
      }
    } catch (e) {
      _logger.error('Error handling background message', e);
    }
  }

  // Handle local notification tap
  void _handleLocalNotificationTap(NotificationResponse response) {
    try {
      // Handle notification tap
      _logger.info('Local notification tapped: ${response.payload}');
    } catch (e) {
      _logger.error('Error handling local notification tap', e);
    }
  }

  // Parse FCM message to app notification
  app.AppNotification? _parseNotification(RemoteMessage message) {
    try {
      final data = message.data;
      return app.AppNotification(
        id: data['id'] ?? '',
        title: message.notification?.title ?? '',
        message: message.notification?.body ?? '',
        type: _parseNotificationType(data['type']),
        targetId: data['targetId'],
        targetType: data['targetType'],
        recipientId: data['recipientId'] ?? '',
        isRead: false,
        createdAt: DateTime.now(),
        metadata: data,
      );
    } catch (e) {
      _logger.error('Error parsing notification', e);
      return null;
    }
  }

  // Parse notification type
  app.NotificationType _parseNotificationType(String? type) {
    switch (type) {
      case 'info':
        return app.NotificationType.info;
      case 'success':
        return app.NotificationType.success;
      case 'warning':
        return app.NotificationType.warning;
      case 'error':
        return app.NotificationType.error;
      case 'item_update':
        return app.NotificationType.itemUpdate;
      case 'counter_update':
        return app.NotificationType.counterUpdate;
      case 'assignment':
        return app.NotificationType.assignment;
      default:
        return app.NotificationType.info;
    }
  }

  // Show local notification
  Future<void> _showLocalNotification(app.AppNotification notification) async {
    try {
      const androidDetails = AndroidNotificationDetails(
        'default_channel',
        'Default Channel',
        channelDescription: 'Default notification channel',
        importance: Importance.high,
        priority: Priority.high,
      );

      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const details = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.message,
        details,
        payload: notification.id,
      );
    } catch (e) {
      _logger.error('Error showing local notification', e);
    }
  }

  // Get all notifications
  Future<List<app.AppNotification>> getNotifications({
    bool unreadOnly = false,
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      final response = await _apiService.get<List<dynamic>>(
        '/notifications',
        queryParameters: {
          'unread_only': unreadOnly,
          'limit': limit,
          'offset': offset,
        },
      );

      return response
          .map((json) =>
              app.AppNotification.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      _logger.error('Failed to get notifications', e);
      rethrow;
    }
  }

  // Mark notification as read
  Future<void> markAsRead(String notificationId) async {
    try {
      await _apiService.put<void>(
        '/notifications/$notificationId/read',
      );
    } catch (e) {
      _logger.error('Failed to mark notification as read', e);
      rethrow;
    }
  }

  // Mark all notifications as read
  Future<void> markAllAsRead() async {
    try {
      await _apiService.put<void>(
        '/notifications/read-all',
      );
    } catch (e) {
      _logger.error('Failed to mark all notifications as read', e);
      rethrow;
    }
  }

  // Clear notification
  Future<void> clearNotification(String notificationId) async {
    try {
      await _apiService.delete<void>(
        '/notifications/$notificationId',
      );
    } catch (e) {
      _logger.error('Failed to clear notification', e);
      rethrow;
    }
  }

  // Clear all notifications
  Future<void> clearAllNotifications() async {
    try {
      await _apiService.delete<void>(
        '/notifications',
      );
    } catch (e) {
      _logger.error('Failed to clear all notifications', e);
      rethrow;
    }
  }

  // Clean up resources
  void dispose() {
    _notificationController.close();
  }
}