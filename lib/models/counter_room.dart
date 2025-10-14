import 'package:json_annotation/json_annotation.dart';

part 'counter_room.g.dart';

@JsonSerializable()
class CounterRoom {
  final String id;
  final String name;
  final String description;
  final String? qrCode;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<String> assignedUserIds;
  final int itemCount;
  final CounterRoomStatus status;

  /// Total number of items in the counter room
  int get totalItems => itemCount;

  /// Number of active items in the counter room
  int get activeItems => itemCount > 0 ? itemCount : 0;

  /// Number of members (assigned users) in the counter room
  int get memberCount => assignedUserIds.length;

  const CounterRoom({
    required this.id,
    required this.name,
    required this.description,
    this.qrCode,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    required this.assignedUserIds,
    required this.itemCount,
    required this.status,
  });

  // From JSON
  factory CounterRoom.fromJson(Map<String, dynamic> json) =>
      _$CounterRoomFromJson(json);

  // To JSON
  Map<String, dynamic> toJson() => _$CounterRoomToJson(this);

  // Copy with
  CounterRoom copyWith({
    String? id,
    String? name,
    String? description,
    String? qrCode,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<String>? assignedUserIds,
    int? itemCount,
    CounterRoomStatus? status,
  }) {
    return CounterRoom(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      qrCode: qrCode ?? this.qrCode,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      assignedUserIds: assignedUserIds ?? List.from(this.assignedUserIds),
      itemCount: itemCount ?? this.itemCount,
      status: status ?? this.status,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CounterRoom &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          description == other.description &&
          qrCode == other.qrCode &&
          isActive == other.isActive &&
          createdAt == other.createdAt &&
          updatedAt == other.updatedAt &&
          _listEquals(assignedUserIds, other.assignedUserIds) &&
          itemCount == other.itemCount &&
          status == other.status;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      description.hashCode ^
      qrCode.hashCode ^
      isActive.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode ^
      assignedUserIds.hashCode ^
      itemCount.hashCode ^
      status.hashCode;

  @override
  String toString() {
    return 'CounterRoom(id: $id, name: $name, status: ${status.name})';
  }

  bool isUserAssigned(String userId) => assignedUserIds.contains(userId);

  bool get isOpen => status == CounterRoomStatus.open;
  bool get isClosed => status == CounterRoomStatus.closed;
  bool get isPaused => status == CounterRoomStatus.paused;
}

bool _listEquals<T>(List<T> list1, List<T> list2) {
  if (list1.length != list2.length) return false;
  for (int i = 0; i < list1.length; i++) {
    if (list1[i] != list2[i]) return false;
  }
  return true;
}

enum CounterRoomStatus {
  @JsonValue('open')
  open,
  @JsonValue('closed')
  closed,
  @JsonValue('paused')
  paused,
}