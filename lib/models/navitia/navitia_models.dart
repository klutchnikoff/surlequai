import 'package:freezed_annotation/freezed_annotation.dart';

part 'navitia_models.freezed.dart';
part 'navitia_models.g.dart';

@freezed
class NavitiaResponse with _$NavitiaResponse {
  const factory NavitiaResponse({
    List<NavitiaDeparture>? departures,
    List<NavitiaJourney>? journeys,
    List<NavitiaPlace>? places,
  }) = _NavitiaResponse;

  factory NavitiaResponse.fromJson(Map<String, dynamic> json) =>
      _$NavitiaResponseFromJson(json);
}

@freezed
class NavitiaDeparture with _$NavitiaDeparture {
  const factory NavitiaDeparture({
    @JsonKey(name: 'stop_date_time') required NavitiaStopDateTime stopDateTime,
    @JsonKey(name: 'display_informations') NavitiaDisplayInfo? displayInformation,
    NavitiaRoute? route,
  }) = _NavitiaDeparture;

  factory NavitiaDeparture.fromJson(Map<String, dynamic> json) =>
      _$NavitiaDepartureFromJson(json);
}

@freezed
class NavitiaStopDateTime with _$NavitiaStopDateTime {
  const factory NavitiaStopDateTime({
    @JsonKey(name: 'departure_date_time') required String departureDateTime,
    @JsonKey(name: 'base_departure_date_time') required String baseDepartureDateTime,
    @JsonKey(name: 'data_freshness') required String dataFreshness,
    String? platform, // Parfois absent
  }) = _NavitiaStopDateTime;

  factory NavitiaStopDateTime.fromJson(Map<String, dynamic> json) =>
      _$NavitiaStopDateTimeFromJson(json);
}

@freezed
class NavitiaDisplayInfo with _$NavitiaDisplayInfo {
  const factory NavitiaDisplayInfo({
    String? network,
    String? direction,
    @JsonKey(name: 'trip_short_name') String? tripShortName,
  }) = _NavitiaDisplayInfo;

  factory NavitiaDisplayInfo.fromJson(Map<String, dynamic> json) =>
      _$NavitiaDisplayInfoFromJson(json);
}

@freezed
class NavitiaRoute with _$NavitiaRoute {
  const factory NavitiaRoute({
    String? id,
    String? name,
  }) = _NavitiaRoute;

  factory NavitiaRoute.fromJson(Map<String, dynamic> json) =>
      _$NavitiaRouteFromJson(json);
}

// Pour /journeys
@freezed
class NavitiaJourney with _$NavitiaJourney {
  const factory NavitiaJourney({
    @JsonKey(name: 'nb_transfers') required int nbTransfers,
    List<NavitiaSection>? sections,
  }) = _NavitiaJourney;

  factory NavitiaJourney.fromJson(Map<String, dynamic> json) =>
      _$NavitiaJourneyFromJson(json);
}

@freezed
class NavitiaSection with _$NavitiaSection {
  const factory NavitiaSection({
    String? type,
    String? id, // ID du train
    @JsonKey(name: 'display_informations') NavitiaDisplayInfo? displayInformation,
    @JsonKey(name: 'departure_date_time') String? departureDateTime,
    @JsonKey(name: 'base_departure_date_time') String? baseDepartureDateTime,
    @JsonKey(name: 'arrival_date_time') String? arrivalDateTime,
    @JsonKey(name: 'data_freshness') String? dataFreshness,
    @JsonKey(name: 'stop_date_times') List<NavitiaStopPoint>? stopDateTimes,
  }) = _NavitiaSection;

  factory NavitiaSection.fromJson(Map<String, dynamic> json) =>
      _$NavitiaSectionFromJson(json);
}

@freezed
class NavitiaStopPoint with _$NavitiaStopPoint {
  const factory NavitiaStopPoint({
    @JsonKey(name: 'departure_stop_point') NavitiaStopPointDetails? departureStopPoint,
  }) = _NavitiaStopPoint;

  factory NavitiaStopPoint.fromJson(Map<String, dynamic> json) =>
      _$NavitiaStopPointFromJson(json);
}

@freezed
class NavitiaStopPointDetails with _$NavitiaStopPointDetails {
  const factory NavitiaStopPointDetails({
    String? platform,
  }) = _NavitiaStopPointDetails;

  factory NavitiaStopPointDetails.fromJson(Map<String, dynamic> json) =>
      _$NavitiaStopPointDetailsFromJson(json);
}

// Pour /places (autocomplete)
@freezed
class NavitiaPlace with _$NavitiaPlace {
  const factory NavitiaPlace({
    String? id,
    String? name,
    @JsonKey(name: 'embedded_type') String? embeddedType,
    @JsonKey(name: 'stop_area') NavitiaStopArea? stopArea,
  }) = _NavitiaPlace;

  factory NavitiaPlace.fromJson(Map<String, dynamic> json) =>
      _$NavitiaPlaceFromJson(json);
}

@freezed
class NavitiaStopArea with _$NavitiaStopArea {
  const factory NavitiaStopArea({
    required String id,
    required String name,
  }) = _NavitiaStopArea;

  factory NavitiaStopArea.fromJson(Map<String, dynamic> json) =>
      _$NavitiaStopAreaFromJson(json);
}
