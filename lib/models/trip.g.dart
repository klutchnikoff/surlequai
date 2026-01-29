// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TripImpl _$$TripImplFromJson(Map<String, dynamic> json) => _$TripImpl(
      id: json['id'] as String,
      stationA: Station.fromJson(json['stationA'] as Map<String, dynamic>),
      stationB: Station.fromJson(json['stationB'] as Map<String, dynamic>),
      morningDirection:
          $enumDecode(_$MorningDirectionEnumMap, json['morningDirection']),
    );

Map<String, dynamic> _$$TripImplToJson(_$TripImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'stationA': instance.stationA,
      'stationB': instance.stationB,
      'morningDirection': _$MorningDirectionEnumMap[instance.morningDirection]!,
    };

const _$MorningDirectionEnumMap = {
  MorningDirection.aToB: 'aToB',
  MorningDirection.bToA: 'bToA',
};
