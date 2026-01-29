// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'departure.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DepartureImpl _$$DepartureImplFromJson(Map<String, dynamic> json) =>
    _$DepartureImpl(
      id: json['id'] as String,
      scheduledTime: DateTime.parse(json['scheduledTime'] as String),
      platform: json['platform'] as String,
      status: $enumDecodeNullable(_$DepartureStatusEnumMap, json['status']) ??
          DepartureStatus.offline,
      delayMinutes: (json['delayMinutes'] as num?)?.toInt() ?? 0,
      durationMinutes: (json['durationMinutes'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$DepartureImplToJson(_$DepartureImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'scheduledTime': instance.scheduledTime.toIso8601String(),
      'platform': instance.platform,
      'status': _$DepartureStatusEnumMap[instance.status]!,
      'delayMinutes': instance.delayMinutes,
      'durationMinutes': instance.durationMinutes,
    };

const _$DepartureStatusEnumMap = {
  DepartureStatus.onTime: 'onTime',
  DepartureStatus.delayed: 'delayed',
  DepartureStatus.cancelled: 'cancelled',
  DepartureStatus.offline: 'offline',
};
