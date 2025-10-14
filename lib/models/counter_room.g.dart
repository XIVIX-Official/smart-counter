// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'counter_room.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CounterRoom _$CounterRoomFromJson(Map<String, dynamic> json) => CounterRoom(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      qrCode: json['qrCode'] as String?,
      isActive: json['isActive'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      assignedUserIds: (json['assignedUserIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      itemCount: (json['itemCount'] as num).toInt(),
      status: $enumDecode(_$CounterRoomStatusEnumMap, json['status']),
    );

Map<String, dynamic> _$CounterRoomToJson(CounterRoom instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'qrCode': instance.qrCode,
      'isActive': instance.isActive,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'assignedUserIds': instance.assignedUserIds,
      'itemCount': instance.itemCount,
      'status': _$CounterRoomStatusEnumMap[instance.status]!,
    };

const _$CounterRoomStatusEnumMap = {
  CounterRoomStatus.open: 'open',
  CounterRoomStatus.closed: 'closed',
  CounterRoomStatus.paused: 'paused',
};
