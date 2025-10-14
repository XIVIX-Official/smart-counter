// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Item _$ItemFromJson(Map<String, dynamic> json) => Item(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      qrCode: json['qrCode'] as String,
      counterRoomId: json['counterRoomId'] as String,
      assignedUserId: json['assignedUserId'] as String?,
      status: $enumDecode(_$ItemStatusEnumMap, json['status']),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      metadata: json['metadata'] as Map<String, dynamic>,
      quantity: (json['quantity'] as num).toInt(),
      history: (json['history'] as List<dynamic>)
          .map((e) => ItemHistory.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ItemToJson(Item instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'qrCode': instance.qrCode,
      'counterRoomId': instance.counterRoomId,
      'assignedUserId': instance.assignedUserId,
      'status': _$ItemStatusEnumMap[instance.status]!,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'metadata': instance.metadata,
      'quantity': instance.quantity,
      'history': instance.history,
    };

const _$ItemStatusEnumMap = {
  ItemStatus.active: 'active',
  ItemStatus.pending: 'pending',
  ItemStatus.processing: 'processing',
  ItemStatus.completed: 'completed',
  ItemStatus.cancelled: 'cancelled',
};

ItemHistory _$ItemHistoryFromJson(Map<String, dynamic> json) => ItemHistory(
      id: json['id'] as String,
      itemId: json['itemId'] as String,
      userId: json['userId'] as String,
      action: json['action'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      metadata: json['metadata'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$ItemHistoryToJson(ItemHistory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'itemId': instance.itemId,
      'userId': instance.userId,
      'action': instance.action,
      'timestamp': instance.timestamp.toIso8601String(),
      'metadata': instance.metadata,
    };
