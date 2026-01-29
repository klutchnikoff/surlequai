// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'navitia_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NavitiaResponseImpl _$$NavitiaResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$NavitiaResponseImpl(
      departures: (json['departures'] as List<dynamic>?)
          ?.map((e) => NavitiaDeparture.fromJson(e as Map<String, dynamic>))
          .toList(),
      journeys: (json['journeys'] as List<dynamic>?)
          ?.map((e) => NavitiaJourney.fromJson(e as Map<String, dynamic>))
          .toList(),
      places: (json['places'] as List<dynamic>?)
          ?.map((e) => NavitiaPlace.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$NavitiaResponseImplToJson(
        _$NavitiaResponseImpl instance) =>
    <String, dynamic>{
      'departures': instance.departures,
      'journeys': instance.journeys,
      'places': instance.places,
    };

_$NavitiaDepartureImpl _$$NavitiaDepartureImplFromJson(
        Map<String, dynamic> json) =>
    _$NavitiaDepartureImpl(
      stopDateTime: NavitiaStopDateTime.fromJson(
          json['stop_date_time'] as Map<String, dynamic>),
      displayInformation: json['display_informations'] == null
          ? null
          : NavitiaDisplayInfo.fromJson(
              json['display_informations'] as Map<String, dynamic>),
      route: json['route'] == null
          ? null
          : NavitiaRoute.fromJson(json['route'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$NavitiaDepartureImplToJson(
        _$NavitiaDepartureImpl instance) =>
    <String, dynamic>{
      'stop_date_time': instance.stopDateTime,
      'display_informations': instance.displayInformation,
      'route': instance.route,
    };

_$NavitiaStopDateTimeImpl _$$NavitiaStopDateTimeImplFromJson(
        Map<String, dynamic> json) =>
    _$NavitiaStopDateTimeImpl(
      departureDateTime: json['departure_date_time'] as String,
      baseDepartureDateTime: json['base_departure_date_time'] as String,
      dataFreshness: json['data_freshness'] as String,
      platform: json['platform'] as String?,
    );

Map<String, dynamic> _$$NavitiaStopDateTimeImplToJson(
        _$NavitiaStopDateTimeImpl instance) =>
    <String, dynamic>{
      'departure_date_time': instance.departureDateTime,
      'base_departure_date_time': instance.baseDepartureDateTime,
      'data_freshness': instance.dataFreshness,
      'platform': instance.platform,
    };

_$NavitiaDisplayInfoImpl _$$NavitiaDisplayInfoImplFromJson(
        Map<String, dynamic> json) =>
    _$NavitiaDisplayInfoImpl(
      network: json['network'] as String?,
      direction: json['direction'] as String?,
      tripShortName: json['trip_short_name'] as String?,
    );

Map<String, dynamic> _$$NavitiaDisplayInfoImplToJson(
        _$NavitiaDisplayInfoImpl instance) =>
    <String, dynamic>{
      'network': instance.network,
      'direction': instance.direction,
      'trip_short_name': instance.tripShortName,
    };

_$NavitiaRouteImpl _$$NavitiaRouteImplFromJson(Map<String, dynamic> json) =>
    _$NavitiaRouteImpl(
      id: json['id'] as String?,
      name: json['name'] as String?,
    );

Map<String, dynamic> _$$NavitiaRouteImplToJson(_$NavitiaRouteImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };

_$NavitiaJourneyImpl _$$NavitiaJourneyImplFromJson(Map<String, dynamic> json) =>
    _$NavitiaJourneyImpl(
      nbTransfers: (json['nb_transfers'] as num).toInt(),
      sections: (json['sections'] as List<dynamic>?)
          ?.map((e) => NavitiaSection.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$NavitiaJourneyImplToJson(
        _$NavitiaJourneyImpl instance) =>
    <String, dynamic>{
      'nb_transfers': instance.nbTransfers,
      'sections': instance.sections,
    };

_$NavitiaSectionImpl _$$NavitiaSectionImplFromJson(Map<String, dynamic> json) =>
    _$NavitiaSectionImpl(
      type: json['type'] as String?,
      id: json['id'] as String?,
      displayInformation: json['display_informations'] == null
          ? null
          : NavitiaDisplayInfo.fromJson(
              json['display_informations'] as Map<String, dynamic>),
      departureDateTime: json['departure_date_time'] as String?,
      baseDepartureDateTime: json['base_departure_date_time'] as String?,
      arrivalDateTime: json['arrival_date_time'] as String?,
      dataFreshness: json['data_freshness'] as String?,
      stopDateTimes: (json['stop_date_times'] as List<dynamic>?)
          ?.map((e) => NavitiaStopPoint.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$NavitiaSectionImplToJson(
        _$NavitiaSectionImpl instance) =>
    <String, dynamic>{
      'type': instance.type,
      'id': instance.id,
      'display_informations': instance.displayInformation,
      'departure_date_time': instance.departureDateTime,
      'base_departure_date_time': instance.baseDepartureDateTime,
      'arrival_date_time': instance.arrivalDateTime,
      'data_freshness': instance.dataFreshness,
      'stop_date_times': instance.stopDateTimes,
    };

_$NavitiaStopPointImpl _$$NavitiaStopPointImplFromJson(
        Map<String, dynamic> json) =>
    _$NavitiaStopPointImpl(
      departureStopPoint: json['departure_stop_point'] == null
          ? null
          : NavitiaStopPointDetails.fromJson(
              json['departure_stop_point'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$NavitiaStopPointImplToJson(
        _$NavitiaStopPointImpl instance) =>
    <String, dynamic>{
      'departure_stop_point': instance.departureStopPoint,
    };

_$NavitiaStopPointDetailsImpl _$$NavitiaStopPointDetailsImplFromJson(
        Map<String, dynamic> json) =>
    _$NavitiaStopPointDetailsImpl(
      platform: json['platform'] as String?,
    );

Map<String, dynamic> _$$NavitiaStopPointDetailsImplToJson(
        _$NavitiaStopPointDetailsImpl instance) =>
    <String, dynamic>{
      'platform': instance.platform,
    };

_$NavitiaPlaceImpl _$$NavitiaPlaceImplFromJson(Map<String, dynamic> json) =>
    _$NavitiaPlaceImpl(
      id: json['id'] as String?,
      name: json['name'] as String?,
      embeddedType: json['embedded_type'] as String?,
      stopArea: json['stop_area'] == null
          ? null
          : NavitiaStopArea.fromJson(json['stop_area'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$NavitiaPlaceImplToJson(_$NavitiaPlaceImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'embedded_type': instance.embeddedType,
      'stop_area': instance.stopArea,
    };

_$NavitiaStopAreaImpl _$$NavitiaStopAreaImplFromJson(
        Map<String, dynamic> json) =>
    _$NavitiaStopAreaImpl(
      id: json['id'] as String,
      name: json['name'] as String,
    );

Map<String, dynamic> _$$NavitiaStopAreaImplToJson(
        _$NavitiaStopAreaImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };
