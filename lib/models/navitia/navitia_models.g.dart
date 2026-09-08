// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'navitia_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NavitiaResponse _$NavitiaResponseFromJson(Map<String, dynamic> json) =>
    _NavitiaResponse(
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

Map<String, dynamic> _$NavitiaResponseToJson(_NavitiaResponse instance) =>
    <String, dynamic>{
      'departures': instance.departures,
      'journeys': instance.journeys,
      'places': instance.places,
    };

_NavitiaDeparture _$NavitiaDepartureFromJson(Map<String, dynamic> json) =>
    _NavitiaDeparture(
      stopDateTime: NavitiaStopDateTime.fromJson(
        json['stop_date_time'] as Map<String, dynamic>,
      ),
      displayInformation: json['display_informations'] == null
          ? null
          : NavitiaDisplayInfo.fromJson(
              json['display_informations'] as Map<String, dynamic>,
            ),
      route: json['route'] == null
          ? null
          : NavitiaRoute.fromJson(json['route'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$NavitiaDepartureToJson(_NavitiaDeparture instance) =>
    <String, dynamic>{
      'stop_date_time': instance.stopDateTime,
      'display_informations': instance.displayInformation,
      'route': instance.route,
    };

_NavitiaStopDateTime _$NavitiaStopDateTimeFromJson(Map<String, dynamic> json) =>
    _NavitiaStopDateTime(
      departureDateTime: json['departure_date_time'] as String,
      baseDepartureDateTime: json['base_departure_date_time'] as String,
      dataFreshness: json['data_freshness'] as String,
      platform: json['platform'] as String?,
    );

Map<String, dynamic> _$NavitiaStopDateTimeToJson(
  _NavitiaStopDateTime instance,
) => <String, dynamic>{
  'departure_date_time': instance.departureDateTime,
  'base_departure_date_time': instance.baseDepartureDateTime,
  'data_freshness': instance.dataFreshness,
  'platform': instance.platform,
};

_NavitiaDisplayInfo _$NavitiaDisplayInfoFromJson(Map<String, dynamic> json) =>
    _NavitiaDisplayInfo(
      network: json['network'] as String?,
      direction: json['direction'] as String?,
      tripShortName: json['trip_short_name'] as String?,
    );

Map<String, dynamic> _$NavitiaDisplayInfoToJson(_NavitiaDisplayInfo instance) =>
    <String, dynamic>{
      'network': instance.network,
      'direction': instance.direction,
      'trip_short_name': instance.tripShortName,
    };

_NavitiaRoute _$NavitiaRouteFromJson(Map<String, dynamic> json) =>
    _NavitiaRoute(id: json['id'] as String?, name: json['name'] as String?);

Map<String, dynamic> _$NavitiaRouteToJson(_NavitiaRoute instance) =>
    <String, dynamic>{'id': instance.id, 'name': instance.name};

_NavitiaJourney _$NavitiaJourneyFromJson(Map<String, dynamic> json) =>
    _NavitiaJourney(
      nbTransfers: (json['nb_transfers'] as num).toInt(),
      status: json['status'] as String?,
      sections: (json['sections'] as List<dynamic>?)
          ?.map((e) => NavitiaSection.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$NavitiaJourneyToJson(_NavitiaJourney instance) =>
    <String, dynamic>{
      'nb_transfers': instance.nbTransfers,
      'status': instance.status,
      'sections': instance.sections,
    };

_NavitiaSection _$NavitiaSectionFromJson(Map<String, dynamic> json) =>
    _NavitiaSection(
      type: json['type'] as String?,
      id: json['id'] as String?,
      displayInformation: json['display_informations'] == null
          ? null
          : NavitiaDisplayInfo.fromJson(
              json['display_informations'] as Map<String, dynamic>,
            ),
      departureDateTime: json['departure_date_time'] as String?,
      baseDepartureDateTime: json['base_departure_date_time'] as String?,
      arrivalDateTime: json['arrival_date_time'] as String?,
      dataFreshness: json['data_freshness'] as String?,
      stopDateTimes: (json['stop_date_times'] as List<dynamic>?)
          ?.map((e) => NavitiaStopPoint.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$NavitiaSectionToJson(_NavitiaSection instance) =>
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

_NavitiaStopPoint _$NavitiaStopPointFromJson(Map<String, dynamic> json) =>
    _NavitiaStopPoint(
      departureStopPoint: json['departure_stop_point'] == null
          ? null
          : NavitiaStopPointDetails.fromJson(
              json['departure_stop_point'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$NavitiaStopPointToJson(_NavitiaStopPoint instance) =>
    <String, dynamic>{'departure_stop_point': instance.departureStopPoint};

_NavitiaStopPointDetails _$NavitiaStopPointDetailsFromJson(
  Map<String, dynamic> json,
) => _NavitiaStopPointDetails(platform: json['platform'] as String?);

Map<String, dynamic> _$NavitiaStopPointDetailsToJson(
  _NavitiaStopPointDetails instance,
) => <String, dynamic>{'platform': instance.platform};

_NavitiaPlace _$NavitiaPlaceFromJson(Map<String, dynamic> json) =>
    _NavitiaPlace(
      id: json['id'] as String?,
      name: json['name'] as String?,
      embeddedType: json['embedded_type'] as String?,
      stopArea: json['stop_area'] == null
          ? null
          : NavitiaStopArea.fromJson(json['stop_area'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$NavitiaPlaceToJson(_NavitiaPlace instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'embedded_type': instance.embeddedType,
      'stop_area': instance.stopArea,
    };

_NavitiaStopArea _$NavitiaStopAreaFromJson(Map<String, dynamic> json) =>
    _NavitiaStopArea(id: json['id'] as String, name: json['name'] as String);

Map<String, dynamic> _$NavitiaStopAreaToJson(_NavitiaStopArea instance) =>
    <String, dynamic>{'id': instance.id, 'name': instance.name};
