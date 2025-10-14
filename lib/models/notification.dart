import 'package:json_annotation/json_annotation.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

part 'notification.g.dart';

@JsonSerializable()
class AppNotification {
  final String id;
  final String title;
  final String message;
  final NotificationType type;
  final String? targetId;
  final String? targetType;
  final String recipientId;
  final bool isRead;
  final DateTime createdAt;
  final Map<String, dynamic> metadata;

  const AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    this.targetId,
    this.targetType,
    required this.recipientId,
    required this.isRead,
    required this.createdAt,
    required this.metadata,
  });

  // From JSON
  factory AppNotification.fromJson(Map<String, dynamic> json) =>
      _$AppNotificationFromJson(json);

  // To JSON
  Map<String, dynamic> toJson() => _$AppNotificationToJson(this);

  // From FCM Message
  factory AppNotification.fromMessage(RemoteMessage message) {
    final data = message.data;
    return AppNotification(
      id: data['id'] as String,
      title: message.notification?.title ?? '',
      message: message.notification?.body ?? '',
      type: NotificationType.values.firstWhere(
        (e) => e.toString().split('.').last == data['type'],
        orElse: () => NotificationType.info,
      ),
      targetId: data['targetId'] as String?,
      targetType: data['targetType'] as String?,
      recipientId: data['recipientId'] as String,
      isRead: false,
      createdAt: DateTime.now(),
      metadata: Map<String, dynamic>.from(data['metadata'] ?? {}),
    );
  }

  // Copy with
  AppNotification copyWith({
    String? id,
    String? title,
    String? message,
    NotificationType? type,
    String? targetId,
    String? targetType,
    String? recipientId,
    bool? isRead,
    DateTime? createdAt,
    Map<String, dynamic>? metadata,
  }) {
    return AppNotification(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      targetId: targetId ?? this.targetId,
      targetType: targetType ?? this.targetType,
      recipientId: recipientId ?? this.recipientId,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
      metadata: metadata ?? Map.from(this.metadata),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppNotification &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          message == other.message &&
          type == other.type &&
          targetId == other.targetId &&
          targetType == other.targetType &&
          recipientId == other.recipientId &&
          isRead == other.isRead &&
          createdAt == other.createdAt &&
          _mapEquals(metadata, other.metadata);

  @override
  int get hashCode =>
      id.hashCode ^
      title.hashCode ^
      message.hashCode ^
      type.hashCode ^
      targetId.hashCode ^
      targetType.hashCode ^
      recipientId.hashCode ^
      isRead.hashCode ^
      createdAt.hashCode ^
      metadata.hashCode;

  @override
  String toString() {
    return 'Notification(id: $id, type: ${type.name}, title: $title)';
  }

  bool get hasTarget => targetId != null && targetType != null;
  String get relativeTime {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${createdAt.day}/${createdAt.month}/${createdAt.year}';
    }
  }
}

bool _mapEquals<K, V>(Map<K, V> map1, Map<K, V> map2) {
  if (map1.length != map2.length) return false;
  for (final key in map1.keys) {
    if (!map2.containsKey(key) || map1[key] != map2[key]) return false;
  }
  return true;
}

enum NotificationType {
  @JsonValue('info')
  info,
  @JsonValue('success')
  success,
  @JsonValue('warning')
  warning,
  @JsonValue('error')
  error,
  @JsonValue('item_update')
  itemUpdate,
  @JsonValue('counter_update')
  counterUpdate,
  @JsonValue('assignment')
  assignment,
  @JsonValue('counter_room')
  counterRoom,
  @JsonValue('item')
  item,
  @JsonValue('user')
  user,
}