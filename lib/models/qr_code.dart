import 'package:json_annotation/json_annotation.dart';

part 'qr_code.g.dart';

@JsonSerializable()
class QrCode {
  final String id;
  final String code;
  final QrCodeType type;
  final String targetId;
  final DateTime createdAt;
  final DateTime? expiresAt;
  final bool isActive;
  final Map<String, dynamic> metadata;

  const QrCode({
    required this.id,
    required this.code,
    required this.type,
    required this.targetId,
    required this.createdAt,
    this.expiresAt,
    required this.isActive,
    required this.metadata,
  });

  // From JSON
  factory QrCode.fromJson(Map<String, dynamic> json) => _$QrCodeFromJson(json);

  // To JSON
  Map<String, dynamic> toJson() => _$QrCodeToJson(this);

  // Copy with
  QrCode copyWith({
    String? id,
    String? code,
    QrCodeType? type,
    String? targetId,
    DateTime? createdAt,
    DateTime? expiresAt,
    bool? isActive,
    Map<String, dynamic>? metadata,
  }) {
    return QrCode(
      id: id ?? this.id,
      code: code ?? this.code,
      type: type ?? this.type,
      targetId: targetId ?? this.targetId,
      createdAt: createdAt ?? this.createdAt,
      expiresAt: expiresAt ?? this.expiresAt,
      isActive: isActive ?? this.isActive,
      metadata: metadata ?? Map.from(this.metadata),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QrCode &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          code == other.code &&
          type == other.type &&
          targetId == other.targetId &&
          createdAt == other.createdAt &&
          expiresAt == other.expiresAt &&
          isActive == other.isActive &&
          _mapEquals(metadata, other.metadata);

  @override
  int get hashCode =>
      id.hashCode ^
      code.hashCode ^
      type.hashCode ^
      targetId.hashCode ^
      createdAt.hashCode ^
      expiresAt.hashCode ^
      isActive.hashCode ^
      metadata.hashCode;

  @override
  String toString() {
    return 'QrCode(id: $id, type: ${type.name}, targetId: $targetId)';
  }

  bool get hasExpiry => expiresAt != null;

  bool get isExpired {
    if (!hasExpiry) return false;
    return DateTime.now().isAfter(expiresAt!);
  }

  bool get isValid => isActive && !isExpired;
}

bool _mapEquals<K, V>(Map<K, V> map1, Map<K, V> map2) {
  if (map1.length != map2.length) return false;
  for (final key in map1.keys) {
    if (!map2.containsKey(key) || map1[key] != map2[key]) return false;
  }
  return true;
}

enum QrCodeType {
  @JsonValue('item')
  item,
  @JsonValue('counter_room')
  counterRoom,
  @JsonValue('temporary_access')
  temporaryAccess,
  @JsonValue('user')
  user,
}