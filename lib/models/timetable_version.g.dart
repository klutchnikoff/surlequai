// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timetable_version.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TimetableVersionImpl _$$TimetableVersionImplFromJson(
        Map<String, dynamic> json) =>
    _$TimetableVersionImpl(
      version: json['version'] as String,
      region: json['region'] as String,
      validFrom: DateTime.parse(json['validFrom'] as String),
      validUntil: DateTime.parse(json['validUntil'] as String),
      downloadedAt: DateTime.parse(json['downloadedAt'] as String),
      sizeBytes: (json['sizeBytes'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$TimetableVersionImplToJson(
        _$TimetableVersionImpl instance) =>
    <String, dynamic>{
      'version': instance.version,
      'region': instance.region,
      'validFrom': instance.validFrom.toIso8601String(),
      'validUntil': instance.validUntil.toIso8601String(),
      'downloadedAt': instance.downloadedAt.toIso8601String(),
      'sizeBytes': instance.sizeBytes,
    };
