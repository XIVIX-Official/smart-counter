import 'package:json_annotation/json_annotation.dart';

part 'item.g.dart';

@JsonSerializable()
class Item {
  final String id;
  final String name;
  final String description;
  final String qrCode;
  final String counterRoomId;
  final String? assignedUserId;
  final ItemStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Map<String, dynamic> metadata;
  final int quantity;
  final List<ItemHistory> history;

  const Item({
    required this.id,
    required this.name,
    required this.description,
    required this.qrCode,
    required this.counterRoomId,
    this.assignedUserId,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.metadata,
    required this.quantity,
    required this.history,
  });

  // From JSON
  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);

  // To JSON
  Map<String, dynamic> toJson() => _$ItemToJson(this);

  // Copy with
  Item copyWith({
    String? id,
    String? name,
    String? description,
    String? qrCode,
    String? counterRoomId,
    String? assignedUserId,
    ItemStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    Map<String, dynamic>? metadata,
    int? quantity,
    List<ItemHistory>? history,
  }) {
    return Item(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      qrCode: qrCode ?? this.qrCode,
      counterRoomId: counterRoomId ?? this.counterRoomId,
      assignedUserId: assignedUserId ?? this.assignedUserId,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      metadata: metadata ?? Map.from(this.metadata),
      quantity: quantity ?? this.quantity,
      history: history ?? List.from(this.history),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Item &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          description == other.description &&
          qrCode == other.qrCode &&
          counterRoomId == other.counterRoomId &&
          assignedUserId == other.assignedUserId &&
          status == other.status &&
          createdAt == other.createdAt &&
          updatedAt == other.updatedAt &&
          _mapEquals(metadata, other.metadata) &&
          quantity == other.quantity &&
          _listEquals(history, other.history);

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      description.hashCode ^
      qrCode.hashCode ^
      counterRoomId.hashCode ^
      assignedUserId.hashCode ^
      status.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode ^
      metadata.hashCode ^
      quantity.hashCode ^
      history.hashCode;

  @override
  String toString() {
    return 'Item(id: $id, name: $name, status: ${status.name})';
  }

  bool get isAssigned => assignedUserId != null;
  bool get isPending => status == ItemStatus.pending;
  bool get isProcessing => status == ItemStatus.processing;
  bool get isCompleted => status == ItemStatus.completed;
  bool get isCancelled => status == ItemStatus.cancelled;
}

bool _listEquals<T>(List<T> list1, List<T> list2) {
  if (list1.length != list2.length) return false;
  for (int i = 0; i < list1.length; i++) {
    if (list1[i] != list2[i]) return false;
  }
  return true;
}

bool _mapEquals<K, V>(Map<K, V> map1, Map<K, V> map2) {
  if (map1.length != map2.length) return false;
  for (final key in map1.keys) {
    if (!map2.containsKey(key) || map1[key] != map2[key]) return false;
  }
  return true;
}

enum ItemStatus {
  @JsonValue('active')
  active,
  @JsonValue('pending')
  pending,
  @JsonValue('processing')
  processing,
  @JsonValue('completed')
  completed,
  @JsonValue('cancelled')
  cancelled,
}

@JsonSerializable()
class ItemHistory {
  final String id;
  final String itemId;
  final String userId;
  final String action;
  final DateTime timestamp;
  final Map<String, dynamic> metadata;

  const ItemHistory({
    required this.id,
    required this.itemId,
    required this.userId,
    required this.action,
    required this.timestamp,
    required this.metadata,
  });

  // From JSON
  factory ItemHistory.fromJson(Map<String, dynamic> json) =>
      _$ItemHistoryFromJson(json);

  // To JSON
  Map<String, dynamic> toJson() => _$ItemHistoryToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ItemHistory &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          itemId == other.itemId &&
          userId == other.userId &&
          action == other.action &&
          timestamp == other.timestamp &&
          _mapEquals(metadata, other.metadata);

  @override
  int get hashCode =>
      id.hashCode ^
      itemId.hashCode ^
      userId.hashCode ^
      action.hashCode ^
      timestamp.hashCode ^
      metadata.hashCode;

  @override
  String toString() {
    return 'ItemHistory(id: $id, action: $action, timestamp: $timestamp)';
  }
}