// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'navitia_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

NavitiaResponse _$NavitiaResponseFromJson(Map<String, dynamic> json) {
  return _NavitiaResponse.fromJson(json);
}

/// @nodoc
mixin _$NavitiaResponse {
  List<NavitiaDeparture>? get departures => throw _privateConstructorUsedError;
  List<NavitiaJourney>? get journeys => throw _privateConstructorUsedError;
  List<NavitiaPlace>? get places => throw _privateConstructorUsedError;

  /// Serializes this NavitiaResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NavitiaResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NavitiaResponseCopyWith<NavitiaResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NavitiaResponseCopyWith<$Res> {
  factory $NavitiaResponseCopyWith(
          NavitiaResponse value, $Res Function(NavitiaResponse) then) =
      _$NavitiaResponseCopyWithImpl<$Res, NavitiaResponse>;
  @useResult
  $Res call(
      {List<NavitiaDeparture>? departures,
      List<NavitiaJourney>? journeys,
      List<NavitiaPlace>? places});
}

/// @nodoc
class _$NavitiaResponseCopyWithImpl<$Res, $Val extends NavitiaResponse>
    implements $NavitiaResponseCopyWith<$Res> {
  _$NavitiaResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NavitiaResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? departures = freezed,
    Object? journeys = freezed,
    Object? places = freezed,
  }) {
    return _then(_value.copyWith(
      departures: freezed == departures
          ? _value.departures
          : departures // ignore: cast_nullable_to_non_nullable
              as List<NavitiaDeparture>?,
      journeys: freezed == journeys
          ? _value.journeys
          : journeys // ignore: cast_nullable_to_non_nullable
              as List<NavitiaJourney>?,
      places: freezed == places
          ? _value.places
          : places // ignore: cast_nullable_to_non_nullable
              as List<NavitiaPlace>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NavitiaResponseImplCopyWith<$Res>
    implements $NavitiaResponseCopyWith<$Res> {
  factory _$$NavitiaResponseImplCopyWith(_$NavitiaResponseImpl value,
          $Res Function(_$NavitiaResponseImpl) then) =
      __$$NavitiaResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<NavitiaDeparture>? departures,
      List<NavitiaJourney>? journeys,
      List<NavitiaPlace>? places});
}

/// @nodoc
class __$$NavitiaResponseImplCopyWithImpl<$Res>
    extends _$NavitiaResponseCopyWithImpl<$Res, _$NavitiaResponseImpl>
    implements _$$NavitiaResponseImplCopyWith<$Res> {
  __$$NavitiaResponseImplCopyWithImpl(
      _$NavitiaResponseImpl _value, $Res Function(_$NavitiaResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of NavitiaResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? departures = freezed,
    Object? journeys = freezed,
    Object? places = freezed,
  }) {
    return _then(_$NavitiaResponseImpl(
      departures: freezed == departures
          ? _value._departures
          : departures // ignore: cast_nullable_to_non_nullable
              as List<NavitiaDeparture>?,
      journeys: freezed == journeys
          ? _value._journeys
          : journeys // ignore: cast_nullable_to_non_nullable
              as List<NavitiaJourney>?,
      places: freezed == places
          ? _value._places
          : places // ignore: cast_nullable_to_non_nullable
              as List<NavitiaPlace>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NavitiaResponseImpl implements _NavitiaResponse {
  const _$NavitiaResponseImpl(
      {final List<NavitiaDeparture>? departures,
      final List<NavitiaJourney>? journeys,
      final List<NavitiaPlace>? places})
      : _departures = departures,
        _journeys = journeys,
        _places = places;

  factory _$NavitiaResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$NavitiaResponseImplFromJson(json);

  final List<NavitiaDeparture>? _departures;
  @override
  List<NavitiaDeparture>? get departures {
    final value = _departures;
    if (value == null) return null;
    if (_departures is EqualUnmodifiableListView) return _departures;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<NavitiaJourney>? _journeys;
  @override
  List<NavitiaJourney>? get journeys {
    final value = _journeys;
    if (value == null) return null;
    if (_journeys is EqualUnmodifiableListView) return _journeys;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<NavitiaPlace>? _places;
  @override
  List<NavitiaPlace>? get places {
    final value = _places;
    if (value == null) return null;
    if (_places is EqualUnmodifiableListView) return _places;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'NavitiaResponse(departures: $departures, journeys: $journeys, places: $places)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NavitiaResponseImpl &&
            const DeepCollectionEquality()
                .equals(other._departures, _departures) &&
            const DeepCollectionEquality().equals(other._journeys, _journeys) &&
            const DeepCollectionEquality().equals(other._places, _places));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_departures),
      const DeepCollectionEquality().hash(_journeys),
      const DeepCollectionEquality().hash(_places));

  /// Create a copy of NavitiaResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NavitiaResponseImplCopyWith<_$NavitiaResponseImpl> get copyWith =>
      __$$NavitiaResponseImplCopyWithImpl<_$NavitiaResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NavitiaResponseImplToJson(
      this,
    );
  }
}

abstract class _NavitiaResponse implements NavitiaResponse {
  const factory _NavitiaResponse(
      {final List<NavitiaDeparture>? departures,
      final List<NavitiaJourney>? journeys,
      final List<NavitiaPlace>? places}) = _$NavitiaResponseImpl;

  factory _NavitiaResponse.fromJson(Map<String, dynamic> json) =
      _$NavitiaResponseImpl.fromJson;

  @override
  List<NavitiaDeparture>? get departures;
  @override
  List<NavitiaJourney>? get journeys;
  @override
  List<NavitiaPlace>? get places;

  /// Create a copy of NavitiaResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NavitiaResponseImplCopyWith<_$NavitiaResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

NavitiaDeparture _$NavitiaDepartureFromJson(Map<String, dynamic> json) {
  return _NavitiaDeparture.fromJson(json);
}

/// @nodoc
mixin _$NavitiaDeparture {
  @JsonKey(name: 'stop_date_time')
  NavitiaStopDateTime get stopDateTime => throw _privateConstructorUsedError;
  @JsonKey(name: 'display_informations')
  NavitiaDisplayInfo? get displayInformation =>
      throw _privateConstructorUsedError;
  NavitiaRoute? get route => throw _privateConstructorUsedError;

  /// Serializes this NavitiaDeparture to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NavitiaDeparture
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NavitiaDepartureCopyWith<NavitiaDeparture> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NavitiaDepartureCopyWith<$Res> {
  factory $NavitiaDepartureCopyWith(
          NavitiaDeparture value, $Res Function(NavitiaDeparture) then) =
      _$NavitiaDepartureCopyWithImpl<$Res, NavitiaDeparture>;
  @useResult
  $Res call(
      {@JsonKey(name: 'stop_date_time') NavitiaStopDateTime stopDateTime,
      @JsonKey(name: 'display_informations')
      NavitiaDisplayInfo? displayInformation,
      NavitiaRoute? route});

  $NavitiaStopDateTimeCopyWith<$Res> get stopDateTime;
  $NavitiaDisplayInfoCopyWith<$Res>? get displayInformation;
  $NavitiaRouteCopyWith<$Res>? get route;
}

/// @nodoc
class _$NavitiaDepartureCopyWithImpl<$Res, $Val extends NavitiaDeparture>
    implements $NavitiaDepartureCopyWith<$Res> {
  _$NavitiaDepartureCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NavitiaDeparture
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? stopDateTime = null,
    Object? displayInformation = freezed,
    Object? route = freezed,
  }) {
    return _then(_value.copyWith(
      stopDateTime: null == stopDateTime
          ? _value.stopDateTime
          : stopDateTime // ignore: cast_nullable_to_non_nullable
              as NavitiaStopDateTime,
      displayInformation: freezed == displayInformation
          ? _value.displayInformation
          : displayInformation // ignore: cast_nullable_to_non_nullable
              as NavitiaDisplayInfo?,
      route: freezed == route
          ? _value.route
          : route // ignore: cast_nullable_to_non_nullable
              as NavitiaRoute?,
    ) as $Val);
  }

  /// Create a copy of NavitiaDeparture
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $NavitiaStopDateTimeCopyWith<$Res> get stopDateTime {
    return $NavitiaStopDateTimeCopyWith<$Res>(_value.stopDateTime, (value) {
      return _then(_value.copyWith(stopDateTime: value) as $Val);
    });
  }

  /// Create a copy of NavitiaDeparture
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $NavitiaDisplayInfoCopyWith<$Res>? get displayInformation {
    if (_value.displayInformation == null) {
      return null;
    }

    return $NavitiaDisplayInfoCopyWith<$Res>(_value.displayInformation!,
        (value) {
      return _then(_value.copyWith(displayInformation: value) as $Val);
    });
  }

  /// Create a copy of NavitiaDeparture
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $NavitiaRouteCopyWith<$Res>? get route {
    if (_value.route == null) {
      return null;
    }

    return $NavitiaRouteCopyWith<$Res>(_value.route!, (value) {
      return _then(_value.copyWith(route: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$NavitiaDepartureImplCopyWith<$Res>
    implements $NavitiaDepartureCopyWith<$Res> {
  factory _$$NavitiaDepartureImplCopyWith(_$NavitiaDepartureImpl value,
          $Res Function(_$NavitiaDepartureImpl) then) =
      __$$NavitiaDepartureImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'stop_date_time') NavitiaStopDateTime stopDateTime,
      @JsonKey(name: 'display_informations')
      NavitiaDisplayInfo? displayInformation,
      NavitiaRoute? route});

  @override
  $NavitiaStopDateTimeCopyWith<$Res> get stopDateTime;
  @override
  $NavitiaDisplayInfoCopyWith<$Res>? get displayInformation;
  @override
  $NavitiaRouteCopyWith<$Res>? get route;
}

/// @nodoc
class __$$NavitiaDepartureImplCopyWithImpl<$Res>
    extends _$NavitiaDepartureCopyWithImpl<$Res, _$NavitiaDepartureImpl>
    implements _$$NavitiaDepartureImplCopyWith<$Res> {
  __$$NavitiaDepartureImplCopyWithImpl(_$NavitiaDepartureImpl _value,
      $Res Function(_$NavitiaDepartureImpl) _then)
      : super(_value, _then);

  /// Create a copy of NavitiaDeparture
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? stopDateTime = null,
    Object? displayInformation = freezed,
    Object? route = freezed,
  }) {
    return _then(_$NavitiaDepartureImpl(
      stopDateTime: null == stopDateTime
          ? _value.stopDateTime
          : stopDateTime // ignore: cast_nullable_to_non_nullable
              as NavitiaStopDateTime,
      displayInformation: freezed == displayInformation
          ? _value.displayInformation
          : displayInformation // ignore: cast_nullable_to_non_nullable
              as NavitiaDisplayInfo?,
      route: freezed == route
          ? _value.route
          : route // ignore: cast_nullable_to_non_nullable
              as NavitiaRoute?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NavitiaDepartureImpl implements _NavitiaDeparture {
  const _$NavitiaDepartureImpl(
      {@JsonKey(name: 'stop_date_time') required this.stopDateTime,
      @JsonKey(name: 'display_informations') this.displayInformation,
      this.route});

  factory _$NavitiaDepartureImpl.fromJson(Map<String, dynamic> json) =>
      _$$NavitiaDepartureImplFromJson(json);

  @override
  @JsonKey(name: 'stop_date_time')
  final NavitiaStopDateTime stopDateTime;
  @override
  @JsonKey(name: 'display_informations')
  final NavitiaDisplayInfo? displayInformation;
  @override
  final NavitiaRoute? route;

  @override
  String toString() {
    return 'NavitiaDeparture(stopDateTime: $stopDateTime, displayInformation: $displayInformation, route: $route)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NavitiaDepartureImpl &&
            (identical(other.stopDateTime, stopDateTime) ||
                other.stopDateTime == stopDateTime) &&
            (identical(other.displayInformation, displayInformation) ||
                other.displayInformation == displayInformation) &&
            (identical(other.route, route) || other.route == route));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, stopDateTime, displayInformation, route);

  /// Create a copy of NavitiaDeparture
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NavitiaDepartureImplCopyWith<_$NavitiaDepartureImpl> get copyWith =>
      __$$NavitiaDepartureImplCopyWithImpl<_$NavitiaDepartureImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NavitiaDepartureImplToJson(
      this,
    );
  }
}

abstract class _NavitiaDeparture implements NavitiaDeparture {
  const factory _NavitiaDeparture(
      {@JsonKey(name: 'stop_date_time')
      required final NavitiaStopDateTime stopDateTime,
      @JsonKey(name: 'display_informations')
      final NavitiaDisplayInfo? displayInformation,
      final NavitiaRoute? route}) = _$NavitiaDepartureImpl;

  factory _NavitiaDeparture.fromJson(Map<String, dynamic> json) =
      _$NavitiaDepartureImpl.fromJson;

  @override
  @JsonKey(name: 'stop_date_time')
  NavitiaStopDateTime get stopDateTime;
  @override
  @JsonKey(name: 'display_informations')
  NavitiaDisplayInfo? get displayInformation;
  @override
  NavitiaRoute? get route;

  /// Create a copy of NavitiaDeparture
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NavitiaDepartureImplCopyWith<_$NavitiaDepartureImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

NavitiaStopDateTime _$NavitiaStopDateTimeFromJson(Map<String, dynamic> json) {
  return _NavitiaStopDateTime.fromJson(json);
}

/// @nodoc
mixin _$NavitiaStopDateTime {
  @JsonKey(name: 'departure_date_time')
  String get departureDateTime => throw _privateConstructorUsedError;
  @JsonKey(name: 'base_departure_date_time')
  String get baseDepartureDateTime => throw _privateConstructorUsedError;
  @JsonKey(name: 'data_freshness')
  String get dataFreshness => throw _privateConstructorUsedError;
  String? get platform => throw _privateConstructorUsedError;

  /// Serializes this NavitiaStopDateTime to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NavitiaStopDateTime
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NavitiaStopDateTimeCopyWith<NavitiaStopDateTime> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NavitiaStopDateTimeCopyWith<$Res> {
  factory $NavitiaStopDateTimeCopyWith(
          NavitiaStopDateTime value, $Res Function(NavitiaStopDateTime) then) =
      _$NavitiaStopDateTimeCopyWithImpl<$Res, NavitiaStopDateTime>;
  @useResult
  $Res call(
      {@JsonKey(name: 'departure_date_time') String departureDateTime,
      @JsonKey(name: 'base_departure_date_time') String baseDepartureDateTime,
      @JsonKey(name: 'data_freshness') String dataFreshness,
      String? platform});
}

/// @nodoc
class _$NavitiaStopDateTimeCopyWithImpl<$Res, $Val extends NavitiaStopDateTime>
    implements $NavitiaStopDateTimeCopyWith<$Res> {
  _$NavitiaStopDateTimeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NavitiaStopDateTime
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? departureDateTime = null,
    Object? baseDepartureDateTime = null,
    Object? dataFreshness = null,
    Object? platform = freezed,
  }) {
    return _then(_value.copyWith(
      departureDateTime: null == departureDateTime
          ? _value.departureDateTime
          : departureDateTime // ignore: cast_nullable_to_non_nullable
              as String,
      baseDepartureDateTime: null == baseDepartureDateTime
          ? _value.baseDepartureDateTime
          : baseDepartureDateTime // ignore: cast_nullable_to_non_nullable
              as String,
      dataFreshness: null == dataFreshness
          ? _value.dataFreshness
          : dataFreshness // ignore: cast_nullable_to_non_nullable
              as String,
      platform: freezed == platform
          ? _value.platform
          : platform // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NavitiaStopDateTimeImplCopyWith<$Res>
    implements $NavitiaStopDateTimeCopyWith<$Res> {
  factory _$$NavitiaStopDateTimeImplCopyWith(_$NavitiaStopDateTimeImpl value,
          $Res Function(_$NavitiaStopDateTimeImpl) then) =
      __$$NavitiaStopDateTimeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'departure_date_time') String departureDateTime,
      @JsonKey(name: 'base_departure_date_time') String baseDepartureDateTime,
      @JsonKey(name: 'data_freshness') String dataFreshness,
      String? platform});
}

/// @nodoc
class __$$NavitiaStopDateTimeImplCopyWithImpl<$Res>
    extends _$NavitiaStopDateTimeCopyWithImpl<$Res, _$NavitiaStopDateTimeImpl>
    implements _$$NavitiaStopDateTimeImplCopyWith<$Res> {
  __$$NavitiaStopDateTimeImplCopyWithImpl(_$NavitiaStopDateTimeImpl _value,
      $Res Function(_$NavitiaStopDateTimeImpl) _then)
      : super(_value, _then);

  /// Create a copy of NavitiaStopDateTime
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? departureDateTime = null,
    Object? baseDepartureDateTime = null,
    Object? dataFreshness = null,
    Object? platform = freezed,
  }) {
    return _then(_$NavitiaStopDateTimeImpl(
      departureDateTime: null == departureDateTime
          ? _value.departureDateTime
          : departureDateTime // ignore: cast_nullable_to_non_nullable
              as String,
      baseDepartureDateTime: null == baseDepartureDateTime
          ? _value.baseDepartureDateTime
          : baseDepartureDateTime // ignore: cast_nullable_to_non_nullable
              as String,
      dataFreshness: null == dataFreshness
          ? _value.dataFreshness
          : dataFreshness // ignore: cast_nullable_to_non_nullable
              as String,
      platform: freezed == platform
          ? _value.platform
          : platform // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NavitiaStopDateTimeImpl implements _NavitiaStopDateTime {
  const _$NavitiaStopDateTimeImpl(
      {@JsonKey(name: 'departure_date_time') required this.departureDateTime,
      @JsonKey(name: 'base_departure_date_time')
      required this.baseDepartureDateTime,
      @JsonKey(name: 'data_freshness') required this.dataFreshness,
      this.platform});

  factory _$NavitiaStopDateTimeImpl.fromJson(Map<String, dynamic> json) =>
      _$$NavitiaStopDateTimeImplFromJson(json);

  @override
  @JsonKey(name: 'departure_date_time')
  final String departureDateTime;
  @override
  @JsonKey(name: 'base_departure_date_time')
  final String baseDepartureDateTime;
  @override
  @JsonKey(name: 'data_freshness')
  final String dataFreshness;
  @override
  final String? platform;

  @override
  String toString() {
    return 'NavitiaStopDateTime(departureDateTime: $departureDateTime, baseDepartureDateTime: $baseDepartureDateTime, dataFreshness: $dataFreshness, platform: $platform)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NavitiaStopDateTimeImpl &&
            (identical(other.departureDateTime, departureDateTime) ||
                other.departureDateTime == departureDateTime) &&
            (identical(other.baseDepartureDateTime, baseDepartureDateTime) ||
                other.baseDepartureDateTime == baseDepartureDateTime) &&
            (identical(other.dataFreshness, dataFreshness) ||
                other.dataFreshness == dataFreshness) &&
            (identical(other.platform, platform) ||
                other.platform == platform));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, departureDateTime,
      baseDepartureDateTime, dataFreshness, platform);

  /// Create a copy of NavitiaStopDateTime
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NavitiaStopDateTimeImplCopyWith<_$NavitiaStopDateTimeImpl> get copyWith =>
      __$$NavitiaStopDateTimeImplCopyWithImpl<_$NavitiaStopDateTimeImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NavitiaStopDateTimeImplToJson(
      this,
    );
  }
}

abstract class _NavitiaStopDateTime implements NavitiaStopDateTime {
  const factory _NavitiaStopDateTime(
      {@JsonKey(name: 'departure_date_time')
      required final String departureDateTime,
      @JsonKey(name: 'base_departure_date_time')
      required final String baseDepartureDateTime,
      @JsonKey(name: 'data_freshness') required final String dataFreshness,
      final String? platform}) = _$NavitiaStopDateTimeImpl;

  factory _NavitiaStopDateTime.fromJson(Map<String, dynamic> json) =
      _$NavitiaStopDateTimeImpl.fromJson;

  @override
  @JsonKey(name: 'departure_date_time')
  String get departureDateTime;
  @override
  @JsonKey(name: 'base_departure_date_time')
  String get baseDepartureDateTime;
  @override
  @JsonKey(name: 'data_freshness')
  String get dataFreshness;
  @override
  String? get platform;

  /// Create a copy of NavitiaStopDateTime
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NavitiaStopDateTimeImplCopyWith<_$NavitiaStopDateTimeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

NavitiaDisplayInfo _$NavitiaDisplayInfoFromJson(Map<String, dynamic> json) {
  return _NavitiaDisplayInfo.fromJson(json);
}

/// @nodoc
mixin _$NavitiaDisplayInfo {
  String? get network => throw _privateConstructorUsedError;
  String? get direction => throw _privateConstructorUsedError;
  @JsonKey(name: 'trip_short_name')
  String? get tripShortName => throw _privateConstructorUsedError;

  /// Serializes this NavitiaDisplayInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NavitiaDisplayInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NavitiaDisplayInfoCopyWith<NavitiaDisplayInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NavitiaDisplayInfoCopyWith<$Res> {
  factory $NavitiaDisplayInfoCopyWith(
          NavitiaDisplayInfo value, $Res Function(NavitiaDisplayInfo) then) =
      _$NavitiaDisplayInfoCopyWithImpl<$Res, NavitiaDisplayInfo>;
  @useResult
  $Res call(
      {String? network,
      String? direction,
      @JsonKey(name: 'trip_short_name') String? tripShortName});
}

/// @nodoc
class _$NavitiaDisplayInfoCopyWithImpl<$Res, $Val extends NavitiaDisplayInfo>
    implements $NavitiaDisplayInfoCopyWith<$Res> {
  _$NavitiaDisplayInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NavitiaDisplayInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? network = freezed,
    Object? direction = freezed,
    Object? tripShortName = freezed,
  }) {
    return _then(_value.copyWith(
      network: freezed == network
          ? _value.network
          : network // ignore: cast_nullable_to_non_nullable
              as String?,
      direction: freezed == direction
          ? _value.direction
          : direction // ignore: cast_nullable_to_non_nullable
              as String?,
      tripShortName: freezed == tripShortName
          ? _value.tripShortName
          : tripShortName // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NavitiaDisplayInfoImplCopyWith<$Res>
    implements $NavitiaDisplayInfoCopyWith<$Res> {
  factory _$$NavitiaDisplayInfoImplCopyWith(_$NavitiaDisplayInfoImpl value,
          $Res Function(_$NavitiaDisplayInfoImpl) then) =
      __$$NavitiaDisplayInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? network,
      String? direction,
      @JsonKey(name: 'trip_short_name') String? tripShortName});
}

/// @nodoc
class __$$NavitiaDisplayInfoImplCopyWithImpl<$Res>
    extends _$NavitiaDisplayInfoCopyWithImpl<$Res, _$NavitiaDisplayInfoImpl>
    implements _$$NavitiaDisplayInfoImplCopyWith<$Res> {
  __$$NavitiaDisplayInfoImplCopyWithImpl(_$NavitiaDisplayInfoImpl _value,
      $Res Function(_$NavitiaDisplayInfoImpl) _then)
      : super(_value, _then);

  /// Create a copy of NavitiaDisplayInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? network = freezed,
    Object? direction = freezed,
    Object? tripShortName = freezed,
  }) {
    return _then(_$NavitiaDisplayInfoImpl(
      network: freezed == network
          ? _value.network
          : network // ignore: cast_nullable_to_non_nullable
              as String?,
      direction: freezed == direction
          ? _value.direction
          : direction // ignore: cast_nullable_to_non_nullable
              as String?,
      tripShortName: freezed == tripShortName
          ? _value.tripShortName
          : tripShortName // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NavitiaDisplayInfoImpl implements _NavitiaDisplayInfo {
  const _$NavitiaDisplayInfoImpl(
      {this.network,
      this.direction,
      @JsonKey(name: 'trip_short_name') this.tripShortName});

  factory _$NavitiaDisplayInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$NavitiaDisplayInfoImplFromJson(json);

  @override
  final String? network;
  @override
  final String? direction;
  @override
  @JsonKey(name: 'trip_short_name')
  final String? tripShortName;

  @override
  String toString() {
    return 'NavitiaDisplayInfo(network: $network, direction: $direction, tripShortName: $tripShortName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NavitiaDisplayInfoImpl &&
            (identical(other.network, network) || other.network == network) &&
            (identical(other.direction, direction) ||
                other.direction == direction) &&
            (identical(other.tripShortName, tripShortName) ||
                other.tripShortName == tripShortName));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, network, direction, tripShortName);

  /// Create a copy of NavitiaDisplayInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NavitiaDisplayInfoImplCopyWith<_$NavitiaDisplayInfoImpl> get copyWith =>
      __$$NavitiaDisplayInfoImplCopyWithImpl<_$NavitiaDisplayInfoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NavitiaDisplayInfoImplToJson(
      this,
    );
  }
}

abstract class _NavitiaDisplayInfo implements NavitiaDisplayInfo {
  const factory _NavitiaDisplayInfo(
          {final String? network,
          final String? direction,
          @JsonKey(name: 'trip_short_name') final String? tripShortName}) =
      _$NavitiaDisplayInfoImpl;

  factory _NavitiaDisplayInfo.fromJson(Map<String, dynamic> json) =
      _$NavitiaDisplayInfoImpl.fromJson;

  @override
  String? get network;
  @override
  String? get direction;
  @override
  @JsonKey(name: 'trip_short_name')
  String? get tripShortName;

  /// Create a copy of NavitiaDisplayInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NavitiaDisplayInfoImplCopyWith<_$NavitiaDisplayInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

NavitiaRoute _$NavitiaRouteFromJson(Map<String, dynamic> json) {
  return _NavitiaRoute.fromJson(json);
}

/// @nodoc
mixin _$NavitiaRoute {
  String? get id => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;

  /// Serializes this NavitiaRoute to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NavitiaRoute
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NavitiaRouteCopyWith<NavitiaRoute> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NavitiaRouteCopyWith<$Res> {
  factory $NavitiaRouteCopyWith(
          NavitiaRoute value, $Res Function(NavitiaRoute) then) =
      _$NavitiaRouteCopyWithImpl<$Res, NavitiaRoute>;
  @useResult
  $Res call({String? id, String? name});
}

/// @nodoc
class _$NavitiaRouteCopyWithImpl<$Res, $Val extends NavitiaRoute>
    implements $NavitiaRouteCopyWith<$Res> {
  _$NavitiaRouteCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NavitiaRoute
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NavitiaRouteImplCopyWith<$Res>
    implements $NavitiaRouteCopyWith<$Res> {
  factory _$$NavitiaRouteImplCopyWith(
          _$NavitiaRouteImpl value, $Res Function(_$NavitiaRouteImpl) then) =
      __$$NavitiaRouteImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? id, String? name});
}

/// @nodoc
class __$$NavitiaRouteImplCopyWithImpl<$Res>
    extends _$NavitiaRouteCopyWithImpl<$Res, _$NavitiaRouteImpl>
    implements _$$NavitiaRouteImplCopyWith<$Res> {
  __$$NavitiaRouteImplCopyWithImpl(
      _$NavitiaRouteImpl _value, $Res Function(_$NavitiaRouteImpl) _then)
      : super(_value, _then);

  /// Create a copy of NavitiaRoute
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
  }) {
    return _then(_$NavitiaRouteImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NavitiaRouteImpl implements _NavitiaRoute {
  const _$NavitiaRouteImpl({this.id, this.name});

  factory _$NavitiaRouteImpl.fromJson(Map<String, dynamic> json) =>
      _$$NavitiaRouteImplFromJson(json);

  @override
  final String? id;
  @override
  final String? name;

  @override
  String toString() {
    return 'NavitiaRoute(id: $id, name: $name)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NavitiaRouteImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name);

  /// Create a copy of NavitiaRoute
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NavitiaRouteImplCopyWith<_$NavitiaRouteImpl> get copyWith =>
      __$$NavitiaRouteImplCopyWithImpl<_$NavitiaRouteImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NavitiaRouteImplToJson(
      this,
    );
  }
}

abstract class _NavitiaRoute implements NavitiaRoute {
  const factory _NavitiaRoute({final String? id, final String? name}) =
      _$NavitiaRouteImpl;

  factory _NavitiaRoute.fromJson(Map<String, dynamic> json) =
      _$NavitiaRouteImpl.fromJson;

  @override
  String? get id;
  @override
  String? get name;

  /// Create a copy of NavitiaRoute
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NavitiaRouteImplCopyWith<_$NavitiaRouteImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

NavitiaJourney _$NavitiaJourneyFromJson(Map<String, dynamic> json) {
  return _NavitiaJourney.fromJson(json);
}

/// @nodoc
mixin _$NavitiaJourney {
  @JsonKey(name: 'nb_transfers')
  int get nbTransfers => throw _privateConstructorUsedError;
  List<NavitiaSection>? get sections => throw _privateConstructorUsedError;

  /// Serializes this NavitiaJourney to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NavitiaJourney
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NavitiaJourneyCopyWith<NavitiaJourney> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NavitiaJourneyCopyWith<$Res> {
  factory $NavitiaJourneyCopyWith(
          NavitiaJourney value, $Res Function(NavitiaJourney) then) =
      _$NavitiaJourneyCopyWithImpl<$Res, NavitiaJourney>;
  @useResult
  $Res call(
      {@JsonKey(name: 'nb_transfers') int nbTransfers,
      List<NavitiaSection>? sections});
}

/// @nodoc
class _$NavitiaJourneyCopyWithImpl<$Res, $Val extends NavitiaJourney>
    implements $NavitiaJourneyCopyWith<$Res> {
  _$NavitiaJourneyCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NavitiaJourney
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? nbTransfers = null,
    Object? sections = freezed,
  }) {
    return _then(_value.copyWith(
      nbTransfers: null == nbTransfers
          ? _value.nbTransfers
          : nbTransfers // ignore: cast_nullable_to_non_nullable
              as int,
      sections: freezed == sections
          ? _value.sections
          : sections // ignore: cast_nullable_to_non_nullable
              as List<NavitiaSection>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NavitiaJourneyImplCopyWith<$Res>
    implements $NavitiaJourneyCopyWith<$Res> {
  factory _$$NavitiaJourneyImplCopyWith(_$NavitiaJourneyImpl value,
          $Res Function(_$NavitiaJourneyImpl) then) =
      __$$NavitiaJourneyImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'nb_transfers') int nbTransfers,
      List<NavitiaSection>? sections});
}

/// @nodoc
class __$$NavitiaJourneyImplCopyWithImpl<$Res>
    extends _$NavitiaJourneyCopyWithImpl<$Res, _$NavitiaJourneyImpl>
    implements _$$NavitiaJourneyImplCopyWith<$Res> {
  __$$NavitiaJourneyImplCopyWithImpl(
      _$NavitiaJourneyImpl _value, $Res Function(_$NavitiaJourneyImpl) _then)
      : super(_value, _then);

  /// Create a copy of NavitiaJourney
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? nbTransfers = null,
    Object? sections = freezed,
  }) {
    return _then(_$NavitiaJourneyImpl(
      nbTransfers: null == nbTransfers
          ? _value.nbTransfers
          : nbTransfers // ignore: cast_nullable_to_non_nullable
              as int,
      sections: freezed == sections
          ? _value._sections
          : sections // ignore: cast_nullable_to_non_nullable
              as List<NavitiaSection>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NavitiaJourneyImpl implements _NavitiaJourney {
  const _$NavitiaJourneyImpl(
      {@JsonKey(name: 'nb_transfers') required this.nbTransfers,
      final List<NavitiaSection>? sections})
      : _sections = sections;

  factory _$NavitiaJourneyImpl.fromJson(Map<String, dynamic> json) =>
      _$$NavitiaJourneyImplFromJson(json);

  @override
  @JsonKey(name: 'nb_transfers')
  final int nbTransfers;
  final List<NavitiaSection>? _sections;
  @override
  List<NavitiaSection>? get sections {
    final value = _sections;
    if (value == null) return null;
    if (_sections is EqualUnmodifiableListView) return _sections;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'NavitiaJourney(nbTransfers: $nbTransfers, sections: $sections)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NavitiaJourneyImpl &&
            (identical(other.nbTransfers, nbTransfers) ||
                other.nbTransfers == nbTransfers) &&
            const DeepCollectionEquality().equals(other._sections, _sections));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, nbTransfers, const DeepCollectionEquality().hash(_sections));

  /// Create a copy of NavitiaJourney
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NavitiaJourneyImplCopyWith<_$NavitiaJourneyImpl> get copyWith =>
      __$$NavitiaJourneyImplCopyWithImpl<_$NavitiaJourneyImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NavitiaJourneyImplToJson(
      this,
    );
  }
}

abstract class _NavitiaJourney implements NavitiaJourney {
  const factory _NavitiaJourney(
      {@JsonKey(name: 'nb_transfers') required final int nbTransfers,
      final List<NavitiaSection>? sections}) = _$NavitiaJourneyImpl;

  factory _NavitiaJourney.fromJson(Map<String, dynamic> json) =
      _$NavitiaJourneyImpl.fromJson;

  @override
  @JsonKey(name: 'nb_transfers')
  int get nbTransfers;
  @override
  List<NavitiaSection>? get sections;

  /// Create a copy of NavitiaJourney
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NavitiaJourneyImplCopyWith<_$NavitiaJourneyImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

NavitiaSection _$NavitiaSectionFromJson(Map<String, dynamic> json) {
  return _NavitiaSection.fromJson(json);
}

/// @nodoc
mixin _$NavitiaSection {
  String? get type => throw _privateConstructorUsedError;
  String? get id => throw _privateConstructorUsedError; // ID du train
  @JsonKey(name: 'display_informations')
  NavitiaDisplayInfo? get displayInformation =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'departure_date_time')
  String? get departureDateTime => throw _privateConstructorUsedError;
  @JsonKey(name: 'base_departure_date_time')
  String? get baseDepartureDateTime => throw _privateConstructorUsedError;
  @JsonKey(name: 'arrival_date_time')
  String? get arrivalDateTime => throw _privateConstructorUsedError;
  @JsonKey(name: 'data_freshness')
  String? get dataFreshness => throw _privateConstructorUsedError;
  @JsonKey(name: 'stop_date_times')
  List<NavitiaStopPoint>? get stopDateTimes =>
      throw _privateConstructorUsedError;

  /// Serializes this NavitiaSection to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NavitiaSection
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NavitiaSectionCopyWith<NavitiaSection> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NavitiaSectionCopyWith<$Res> {
  factory $NavitiaSectionCopyWith(
          NavitiaSection value, $Res Function(NavitiaSection) then) =
      _$NavitiaSectionCopyWithImpl<$Res, NavitiaSection>;
  @useResult
  $Res call(
      {String? type,
      String? id,
      @JsonKey(name: 'display_informations')
      NavitiaDisplayInfo? displayInformation,
      @JsonKey(name: 'departure_date_time') String? departureDateTime,
      @JsonKey(name: 'base_departure_date_time') String? baseDepartureDateTime,
      @JsonKey(name: 'arrival_date_time') String? arrivalDateTime,
      @JsonKey(name: 'data_freshness') String? dataFreshness,
      @JsonKey(name: 'stop_date_times') List<NavitiaStopPoint>? stopDateTimes});

  $NavitiaDisplayInfoCopyWith<$Res>? get displayInformation;
}

/// @nodoc
class _$NavitiaSectionCopyWithImpl<$Res, $Val extends NavitiaSection>
    implements $NavitiaSectionCopyWith<$Res> {
  _$NavitiaSectionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NavitiaSection
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = freezed,
    Object? id = freezed,
    Object? displayInformation = freezed,
    Object? departureDateTime = freezed,
    Object? baseDepartureDateTime = freezed,
    Object? arrivalDateTime = freezed,
    Object? dataFreshness = freezed,
    Object? stopDateTimes = freezed,
  }) {
    return _then(_value.copyWith(
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      displayInformation: freezed == displayInformation
          ? _value.displayInformation
          : displayInformation // ignore: cast_nullable_to_non_nullable
              as NavitiaDisplayInfo?,
      departureDateTime: freezed == departureDateTime
          ? _value.departureDateTime
          : departureDateTime // ignore: cast_nullable_to_non_nullable
              as String?,
      baseDepartureDateTime: freezed == baseDepartureDateTime
          ? _value.baseDepartureDateTime
          : baseDepartureDateTime // ignore: cast_nullable_to_non_nullable
              as String?,
      arrivalDateTime: freezed == arrivalDateTime
          ? _value.arrivalDateTime
          : arrivalDateTime // ignore: cast_nullable_to_non_nullable
              as String?,
      dataFreshness: freezed == dataFreshness
          ? _value.dataFreshness
          : dataFreshness // ignore: cast_nullable_to_non_nullable
              as String?,
      stopDateTimes: freezed == stopDateTimes
          ? _value.stopDateTimes
          : stopDateTimes // ignore: cast_nullable_to_non_nullable
              as List<NavitiaStopPoint>?,
    ) as $Val);
  }

  /// Create a copy of NavitiaSection
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $NavitiaDisplayInfoCopyWith<$Res>? get displayInformation {
    if (_value.displayInformation == null) {
      return null;
    }

    return $NavitiaDisplayInfoCopyWith<$Res>(_value.displayInformation!,
        (value) {
      return _then(_value.copyWith(displayInformation: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$NavitiaSectionImplCopyWith<$Res>
    implements $NavitiaSectionCopyWith<$Res> {
  factory _$$NavitiaSectionImplCopyWith(_$NavitiaSectionImpl value,
          $Res Function(_$NavitiaSectionImpl) then) =
      __$$NavitiaSectionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? type,
      String? id,
      @JsonKey(name: 'display_informations')
      NavitiaDisplayInfo? displayInformation,
      @JsonKey(name: 'departure_date_time') String? departureDateTime,
      @JsonKey(name: 'base_departure_date_time') String? baseDepartureDateTime,
      @JsonKey(name: 'arrival_date_time') String? arrivalDateTime,
      @JsonKey(name: 'data_freshness') String? dataFreshness,
      @JsonKey(name: 'stop_date_times') List<NavitiaStopPoint>? stopDateTimes});

  @override
  $NavitiaDisplayInfoCopyWith<$Res>? get displayInformation;
}

/// @nodoc
class __$$NavitiaSectionImplCopyWithImpl<$Res>
    extends _$NavitiaSectionCopyWithImpl<$Res, _$NavitiaSectionImpl>
    implements _$$NavitiaSectionImplCopyWith<$Res> {
  __$$NavitiaSectionImplCopyWithImpl(
      _$NavitiaSectionImpl _value, $Res Function(_$NavitiaSectionImpl) _then)
      : super(_value, _then);

  /// Create a copy of NavitiaSection
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = freezed,
    Object? id = freezed,
    Object? displayInformation = freezed,
    Object? departureDateTime = freezed,
    Object? baseDepartureDateTime = freezed,
    Object? arrivalDateTime = freezed,
    Object? dataFreshness = freezed,
    Object? stopDateTimes = freezed,
  }) {
    return _then(_$NavitiaSectionImpl(
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      displayInformation: freezed == displayInformation
          ? _value.displayInformation
          : displayInformation // ignore: cast_nullable_to_non_nullable
              as NavitiaDisplayInfo?,
      departureDateTime: freezed == departureDateTime
          ? _value.departureDateTime
          : departureDateTime // ignore: cast_nullable_to_non_nullable
              as String?,
      baseDepartureDateTime: freezed == baseDepartureDateTime
          ? _value.baseDepartureDateTime
          : baseDepartureDateTime // ignore: cast_nullable_to_non_nullable
              as String?,
      arrivalDateTime: freezed == arrivalDateTime
          ? _value.arrivalDateTime
          : arrivalDateTime // ignore: cast_nullable_to_non_nullable
              as String?,
      dataFreshness: freezed == dataFreshness
          ? _value.dataFreshness
          : dataFreshness // ignore: cast_nullable_to_non_nullable
              as String?,
      stopDateTimes: freezed == stopDateTimes
          ? _value._stopDateTimes
          : stopDateTimes // ignore: cast_nullable_to_non_nullable
              as List<NavitiaStopPoint>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NavitiaSectionImpl implements _NavitiaSection {
  const _$NavitiaSectionImpl(
      {this.type,
      this.id,
      @JsonKey(name: 'display_informations') this.displayInformation,
      @JsonKey(name: 'departure_date_time') this.departureDateTime,
      @JsonKey(name: 'base_departure_date_time') this.baseDepartureDateTime,
      @JsonKey(name: 'arrival_date_time') this.arrivalDateTime,
      @JsonKey(name: 'data_freshness') this.dataFreshness,
      @JsonKey(name: 'stop_date_times')
      final List<NavitiaStopPoint>? stopDateTimes})
      : _stopDateTimes = stopDateTimes;

  factory _$NavitiaSectionImpl.fromJson(Map<String, dynamic> json) =>
      _$$NavitiaSectionImplFromJson(json);

  @override
  final String? type;
  @override
  final String? id;
// ID du train
  @override
  @JsonKey(name: 'display_informations')
  final NavitiaDisplayInfo? displayInformation;
  @override
  @JsonKey(name: 'departure_date_time')
  final String? departureDateTime;
  @override
  @JsonKey(name: 'base_departure_date_time')
  final String? baseDepartureDateTime;
  @override
  @JsonKey(name: 'arrival_date_time')
  final String? arrivalDateTime;
  @override
  @JsonKey(name: 'data_freshness')
  final String? dataFreshness;
  final List<NavitiaStopPoint>? _stopDateTimes;
  @override
  @JsonKey(name: 'stop_date_times')
  List<NavitiaStopPoint>? get stopDateTimes {
    final value = _stopDateTimes;
    if (value == null) return null;
    if (_stopDateTimes is EqualUnmodifiableListView) return _stopDateTimes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'NavitiaSection(type: $type, id: $id, displayInformation: $displayInformation, departureDateTime: $departureDateTime, baseDepartureDateTime: $baseDepartureDateTime, arrivalDateTime: $arrivalDateTime, dataFreshness: $dataFreshness, stopDateTimes: $stopDateTimes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NavitiaSectionImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.displayInformation, displayInformation) ||
                other.displayInformation == displayInformation) &&
            (identical(other.departureDateTime, departureDateTime) ||
                other.departureDateTime == departureDateTime) &&
            (identical(other.baseDepartureDateTime, baseDepartureDateTime) ||
                other.baseDepartureDateTime == baseDepartureDateTime) &&
            (identical(other.arrivalDateTime, arrivalDateTime) ||
                other.arrivalDateTime == arrivalDateTime) &&
            (identical(other.dataFreshness, dataFreshness) ||
                other.dataFreshness == dataFreshness) &&
            const DeepCollectionEquality()
                .equals(other._stopDateTimes, _stopDateTimes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      type,
      id,
      displayInformation,
      departureDateTime,
      baseDepartureDateTime,
      arrivalDateTime,
      dataFreshness,
      const DeepCollectionEquality().hash(_stopDateTimes));

  /// Create a copy of NavitiaSection
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NavitiaSectionImplCopyWith<_$NavitiaSectionImpl> get copyWith =>
      __$$NavitiaSectionImplCopyWithImpl<_$NavitiaSectionImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NavitiaSectionImplToJson(
      this,
    );
  }
}

abstract class _NavitiaSection implements NavitiaSection {
  const factory _NavitiaSection(
      {final String? type,
      final String? id,
      @JsonKey(name: 'display_informations')
      final NavitiaDisplayInfo? displayInformation,
      @JsonKey(name: 'departure_date_time') final String? departureDateTime,
      @JsonKey(name: 'base_departure_date_time')
      final String? baseDepartureDateTime,
      @JsonKey(name: 'arrival_date_time') final String? arrivalDateTime,
      @JsonKey(name: 'data_freshness') final String? dataFreshness,
      @JsonKey(name: 'stop_date_times')
      final List<NavitiaStopPoint>? stopDateTimes}) = _$NavitiaSectionImpl;

  factory _NavitiaSection.fromJson(Map<String, dynamic> json) =
      _$NavitiaSectionImpl.fromJson;

  @override
  String? get type;
  @override
  String? get id; // ID du train
  @override
  @JsonKey(name: 'display_informations')
  NavitiaDisplayInfo? get displayInformation;
  @override
  @JsonKey(name: 'departure_date_time')
  String? get departureDateTime;
  @override
  @JsonKey(name: 'base_departure_date_time')
  String? get baseDepartureDateTime;
  @override
  @JsonKey(name: 'arrival_date_time')
  String? get arrivalDateTime;
  @override
  @JsonKey(name: 'data_freshness')
  String? get dataFreshness;
  @override
  @JsonKey(name: 'stop_date_times')
  List<NavitiaStopPoint>? get stopDateTimes;

  /// Create a copy of NavitiaSection
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NavitiaSectionImplCopyWith<_$NavitiaSectionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

NavitiaStopPoint _$NavitiaStopPointFromJson(Map<String, dynamic> json) {
  return _NavitiaStopPoint.fromJson(json);
}

/// @nodoc
mixin _$NavitiaStopPoint {
  @JsonKey(name: 'departure_stop_point')
  NavitiaStopPointDetails? get departureStopPoint =>
      throw _privateConstructorUsedError;

  /// Serializes this NavitiaStopPoint to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NavitiaStopPoint
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NavitiaStopPointCopyWith<NavitiaStopPoint> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NavitiaStopPointCopyWith<$Res> {
  factory $NavitiaStopPointCopyWith(
          NavitiaStopPoint value, $Res Function(NavitiaStopPoint) then) =
      _$NavitiaStopPointCopyWithImpl<$Res, NavitiaStopPoint>;
  @useResult
  $Res call(
      {@JsonKey(name: 'departure_stop_point')
      NavitiaStopPointDetails? departureStopPoint});

  $NavitiaStopPointDetailsCopyWith<$Res>? get departureStopPoint;
}

/// @nodoc
class _$NavitiaStopPointCopyWithImpl<$Res, $Val extends NavitiaStopPoint>
    implements $NavitiaStopPointCopyWith<$Res> {
  _$NavitiaStopPointCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NavitiaStopPoint
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? departureStopPoint = freezed,
  }) {
    return _then(_value.copyWith(
      departureStopPoint: freezed == departureStopPoint
          ? _value.departureStopPoint
          : departureStopPoint // ignore: cast_nullable_to_non_nullable
              as NavitiaStopPointDetails?,
    ) as $Val);
  }

  /// Create a copy of NavitiaStopPoint
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $NavitiaStopPointDetailsCopyWith<$Res>? get departureStopPoint {
    if (_value.departureStopPoint == null) {
      return null;
    }

    return $NavitiaStopPointDetailsCopyWith<$Res>(_value.departureStopPoint!,
        (value) {
      return _then(_value.copyWith(departureStopPoint: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$NavitiaStopPointImplCopyWith<$Res>
    implements $NavitiaStopPointCopyWith<$Res> {
  factory _$$NavitiaStopPointImplCopyWith(_$NavitiaStopPointImpl value,
          $Res Function(_$NavitiaStopPointImpl) then) =
      __$$NavitiaStopPointImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'departure_stop_point')
      NavitiaStopPointDetails? departureStopPoint});

  @override
  $NavitiaStopPointDetailsCopyWith<$Res>? get departureStopPoint;
}

/// @nodoc
class __$$NavitiaStopPointImplCopyWithImpl<$Res>
    extends _$NavitiaStopPointCopyWithImpl<$Res, _$NavitiaStopPointImpl>
    implements _$$NavitiaStopPointImplCopyWith<$Res> {
  __$$NavitiaStopPointImplCopyWithImpl(_$NavitiaStopPointImpl _value,
      $Res Function(_$NavitiaStopPointImpl) _then)
      : super(_value, _then);

  /// Create a copy of NavitiaStopPoint
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? departureStopPoint = freezed,
  }) {
    return _then(_$NavitiaStopPointImpl(
      departureStopPoint: freezed == departureStopPoint
          ? _value.departureStopPoint
          : departureStopPoint // ignore: cast_nullable_to_non_nullable
              as NavitiaStopPointDetails?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NavitiaStopPointImpl implements _NavitiaStopPoint {
  const _$NavitiaStopPointImpl(
      {@JsonKey(name: 'departure_stop_point') this.departureStopPoint});

  factory _$NavitiaStopPointImpl.fromJson(Map<String, dynamic> json) =>
      _$$NavitiaStopPointImplFromJson(json);

  @override
  @JsonKey(name: 'departure_stop_point')
  final NavitiaStopPointDetails? departureStopPoint;

  @override
  String toString() {
    return 'NavitiaStopPoint(departureStopPoint: $departureStopPoint)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NavitiaStopPointImpl &&
            (identical(other.departureStopPoint, departureStopPoint) ||
                other.departureStopPoint == departureStopPoint));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, departureStopPoint);

  /// Create a copy of NavitiaStopPoint
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NavitiaStopPointImplCopyWith<_$NavitiaStopPointImpl> get copyWith =>
      __$$NavitiaStopPointImplCopyWithImpl<_$NavitiaStopPointImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NavitiaStopPointImplToJson(
      this,
    );
  }
}

abstract class _NavitiaStopPoint implements NavitiaStopPoint {
  const factory _NavitiaStopPoint(
          {@JsonKey(name: 'departure_stop_point')
          final NavitiaStopPointDetails? departureStopPoint}) =
      _$NavitiaStopPointImpl;

  factory _NavitiaStopPoint.fromJson(Map<String, dynamic> json) =
      _$NavitiaStopPointImpl.fromJson;

  @override
  @JsonKey(name: 'departure_stop_point')
  NavitiaStopPointDetails? get departureStopPoint;

  /// Create a copy of NavitiaStopPoint
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NavitiaStopPointImplCopyWith<_$NavitiaStopPointImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

NavitiaStopPointDetails _$NavitiaStopPointDetailsFromJson(
    Map<String, dynamic> json) {
  return _NavitiaStopPointDetails.fromJson(json);
}

/// @nodoc
mixin _$NavitiaStopPointDetails {
  String? get platform => throw _privateConstructorUsedError;

  /// Serializes this NavitiaStopPointDetails to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NavitiaStopPointDetails
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NavitiaStopPointDetailsCopyWith<NavitiaStopPointDetails> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NavitiaStopPointDetailsCopyWith<$Res> {
  factory $NavitiaStopPointDetailsCopyWith(NavitiaStopPointDetails value,
          $Res Function(NavitiaStopPointDetails) then) =
      _$NavitiaStopPointDetailsCopyWithImpl<$Res, NavitiaStopPointDetails>;
  @useResult
  $Res call({String? platform});
}

/// @nodoc
class _$NavitiaStopPointDetailsCopyWithImpl<$Res,
        $Val extends NavitiaStopPointDetails>
    implements $NavitiaStopPointDetailsCopyWith<$Res> {
  _$NavitiaStopPointDetailsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NavitiaStopPointDetails
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? platform = freezed,
  }) {
    return _then(_value.copyWith(
      platform: freezed == platform
          ? _value.platform
          : platform // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NavitiaStopPointDetailsImplCopyWith<$Res>
    implements $NavitiaStopPointDetailsCopyWith<$Res> {
  factory _$$NavitiaStopPointDetailsImplCopyWith(
          _$NavitiaStopPointDetailsImpl value,
          $Res Function(_$NavitiaStopPointDetailsImpl) then) =
      __$$NavitiaStopPointDetailsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? platform});
}

/// @nodoc
class __$$NavitiaStopPointDetailsImplCopyWithImpl<$Res>
    extends _$NavitiaStopPointDetailsCopyWithImpl<$Res,
        _$NavitiaStopPointDetailsImpl>
    implements _$$NavitiaStopPointDetailsImplCopyWith<$Res> {
  __$$NavitiaStopPointDetailsImplCopyWithImpl(
      _$NavitiaStopPointDetailsImpl _value,
      $Res Function(_$NavitiaStopPointDetailsImpl) _then)
      : super(_value, _then);

  /// Create a copy of NavitiaStopPointDetails
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? platform = freezed,
  }) {
    return _then(_$NavitiaStopPointDetailsImpl(
      platform: freezed == platform
          ? _value.platform
          : platform // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NavitiaStopPointDetailsImpl implements _NavitiaStopPointDetails {
  const _$NavitiaStopPointDetailsImpl({this.platform});

  factory _$NavitiaStopPointDetailsImpl.fromJson(Map<String, dynamic> json) =>
      _$$NavitiaStopPointDetailsImplFromJson(json);

  @override
  final String? platform;

  @override
  String toString() {
    return 'NavitiaStopPointDetails(platform: $platform)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NavitiaStopPointDetailsImpl &&
            (identical(other.platform, platform) ||
                other.platform == platform));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, platform);

  /// Create a copy of NavitiaStopPointDetails
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NavitiaStopPointDetailsImplCopyWith<_$NavitiaStopPointDetailsImpl>
      get copyWith => __$$NavitiaStopPointDetailsImplCopyWithImpl<
          _$NavitiaStopPointDetailsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NavitiaStopPointDetailsImplToJson(
      this,
    );
  }
}

abstract class _NavitiaStopPointDetails implements NavitiaStopPointDetails {
  const factory _NavitiaStopPointDetails({final String? platform}) =
      _$NavitiaStopPointDetailsImpl;

  factory _NavitiaStopPointDetails.fromJson(Map<String, dynamic> json) =
      _$NavitiaStopPointDetailsImpl.fromJson;

  @override
  String? get platform;

  /// Create a copy of NavitiaStopPointDetails
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NavitiaStopPointDetailsImplCopyWith<_$NavitiaStopPointDetailsImpl>
      get copyWith => throw _privateConstructorUsedError;
}

NavitiaPlace _$NavitiaPlaceFromJson(Map<String, dynamic> json) {
  return _NavitiaPlace.fromJson(json);
}

/// @nodoc
mixin _$NavitiaPlace {
  String? get id => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'embedded_type')
  String? get embeddedType => throw _privateConstructorUsedError;
  @JsonKey(name: 'stop_area')
  NavitiaStopArea? get stopArea => throw _privateConstructorUsedError;

  /// Serializes this NavitiaPlace to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NavitiaPlace
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NavitiaPlaceCopyWith<NavitiaPlace> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NavitiaPlaceCopyWith<$Res> {
  factory $NavitiaPlaceCopyWith(
          NavitiaPlace value, $Res Function(NavitiaPlace) then) =
      _$NavitiaPlaceCopyWithImpl<$Res, NavitiaPlace>;
  @useResult
  $Res call(
      {String? id,
      String? name,
      @JsonKey(name: 'embedded_type') String? embeddedType,
      @JsonKey(name: 'stop_area') NavitiaStopArea? stopArea});

  $NavitiaStopAreaCopyWith<$Res>? get stopArea;
}

/// @nodoc
class _$NavitiaPlaceCopyWithImpl<$Res, $Val extends NavitiaPlace>
    implements $NavitiaPlaceCopyWith<$Res> {
  _$NavitiaPlaceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NavitiaPlace
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? embeddedType = freezed,
    Object? stopArea = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      embeddedType: freezed == embeddedType
          ? _value.embeddedType
          : embeddedType // ignore: cast_nullable_to_non_nullable
              as String?,
      stopArea: freezed == stopArea
          ? _value.stopArea
          : stopArea // ignore: cast_nullable_to_non_nullable
              as NavitiaStopArea?,
    ) as $Val);
  }

  /// Create a copy of NavitiaPlace
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $NavitiaStopAreaCopyWith<$Res>? get stopArea {
    if (_value.stopArea == null) {
      return null;
    }

    return $NavitiaStopAreaCopyWith<$Res>(_value.stopArea!, (value) {
      return _then(_value.copyWith(stopArea: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$NavitiaPlaceImplCopyWith<$Res>
    implements $NavitiaPlaceCopyWith<$Res> {
  factory _$$NavitiaPlaceImplCopyWith(
          _$NavitiaPlaceImpl value, $Res Function(_$NavitiaPlaceImpl) then) =
      __$$NavitiaPlaceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? id,
      String? name,
      @JsonKey(name: 'embedded_type') String? embeddedType,
      @JsonKey(name: 'stop_area') NavitiaStopArea? stopArea});

  @override
  $NavitiaStopAreaCopyWith<$Res>? get stopArea;
}

/// @nodoc
class __$$NavitiaPlaceImplCopyWithImpl<$Res>
    extends _$NavitiaPlaceCopyWithImpl<$Res, _$NavitiaPlaceImpl>
    implements _$$NavitiaPlaceImplCopyWith<$Res> {
  __$$NavitiaPlaceImplCopyWithImpl(
      _$NavitiaPlaceImpl _value, $Res Function(_$NavitiaPlaceImpl) _then)
      : super(_value, _then);

  /// Create a copy of NavitiaPlace
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? embeddedType = freezed,
    Object? stopArea = freezed,
  }) {
    return _then(_$NavitiaPlaceImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      embeddedType: freezed == embeddedType
          ? _value.embeddedType
          : embeddedType // ignore: cast_nullable_to_non_nullable
              as String?,
      stopArea: freezed == stopArea
          ? _value.stopArea
          : stopArea // ignore: cast_nullable_to_non_nullable
              as NavitiaStopArea?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NavitiaPlaceImpl implements _NavitiaPlace {
  const _$NavitiaPlaceImpl(
      {this.id,
      this.name,
      @JsonKey(name: 'embedded_type') this.embeddedType,
      @JsonKey(name: 'stop_area') this.stopArea});

  factory _$NavitiaPlaceImpl.fromJson(Map<String, dynamic> json) =>
      _$$NavitiaPlaceImplFromJson(json);

  @override
  final String? id;
  @override
  final String? name;
  @override
  @JsonKey(name: 'embedded_type')
  final String? embeddedType;
  @override
  @JsonKey(name: 'stop_area')
  final NavitiaStopArea? stopArea;

  @override
  String toString() {
    return 'NavitiaPlace(id: $id, name: $name, embeddedType: $embeddedType, stopArea: $stopArea)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NavitiaPlaceImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.embeddedType, embeddedType) ||
                other.embeddedType == embeddedType) &&
            (identical(other.stopArea, stopArea) ||
                other.stopArea == stopArea));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, name, embeddedType, stopArea);

  /// Create a copy of NavitiaPlace
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NavitiaPlaceImplCopyWith<_$NavitiaPlaceImpl> get copyWith =>
      __$$NavitiaPlaceImplCopyWithImpl<_$NavitiaPlaceImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NavitiaPlaceImplToJson(
      this,
    );
  }
}

abstract class _NavitiaPlace implements NavitiaPlace {
  const factory _NavitiaPlace(
          {final String? id,
          final String? name,
          @JsonKey(name: 'embedded_type') final String? embeddedType,
          @JsonKey(name: 'stop_area') final NavitiaStopArea? stopArea}) =
      _$NavitiaPlaceImpl;

  factory _NavitiaPlace.fromJson(Map<String, dynamic> json) =
      _$NavitiaPlaceImpl.fromJson;

  @override
  String? get id;
  @override
  String? get name;
  @override
  @JsonKey(name: 'embedded_type')
  String? get embeddedType;
  @override
  @JsonKey(name: 'stop_area')
  NavitiaStopArea? get stopArea;

  /// Create a copy of NavitiaPlace
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NavitiaPlaceImplCopyWith<_$NavitiaPlaceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

NavitiaStopArea _$NavitiaStopAreaFromJson(Map<String, dynamic> json) {
  return _NavitiaStopArea.fromJson(json);
}

/// @nodoc
mixin _$NavitiaStopArea {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;

  /// Serializes this NavitiaStopArea to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NavitiaStopArea
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NavitiaStopAreaCopyWith<NavitiaStopArea> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NavitiaStopAreaCopyWith<$Res> {
  factory $NavitiaStopAreaCopyWith(
          NavitiaStopArea value, $Res Function(NavitiaStopArea) then) =
      _$NavitiaStopAreaCopyWithImpl<$Res, NavitiaStopArea>;
  @useResult
  $Res call({String id, String name});
}

/// @nodoc
class _$NavitiaStopAreaCopyWithImpl<$Res, $Val extends NavitiaStopArea>
    implements $NavitiaStopAreaCopyWith<$Res> {
  _$NavitiaStopAreaCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NavitiaStopArea
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NavitiaStopAreaImplCopyWith<$Res>
    implements $NavitiaStopAreaCopyWith<$Res> {
  factory _$$NavitiaStopAreaImplCopyWith(_$NavitiaStopAreaImpl value,
          $Res Function(_$NavitiaStopAreaImpl) then) =
      __$$NavitiaStopAreaImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String name});
}

/// @nodoc
class __$$NavitiaStopAreaImplCopyWithImpl<$Res>
    extends _$NavitiaStopAreaCopyWithImpl<$Res, _$NavitiaStopAreaImpl>
    implements _$$NavitiaStopAreaImplCopyWith<$Res> {
  __$$NavitiaStopAreaImplCopyWithImpl(
      _$NavitiaStopAreaImpl _value, $Res Function(_$NavitiaStopAreaImpl) _then)
      : super(_value, _then);

  /// Create a copy of NavitiaStopArea
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
  }) {
    return _then(_$NavitiaStopAreaImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NavitiaStopAreaImpl implements _NavitiaStopArea {
  const _$NavitiaStopAreaImpl({required this.id, required this.name});

  factory _$NavitiaStopAreaImpl.fromJson(Map<String, dynamic> json) =>
      _$$NavitiaStopAreaImplFromJson(json);

  @override
  final String id;
  @override
  final String name;

  @override
  String toString() {
    return 'NavitiaStopArea(id: $id, name: $name)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NavitiaStopAreaImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name);

  /// Create a copy of NavitiaStopArea
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NavitiaStopAreaImplCopyWith<_$NavitiaStopAreaImpl> get copyWith =>
      __$$NavitiaStopAreaImplCopyWithImpl<_$NavitiaStopAreaImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NavitiaStopAreaImplToJson(
      this,
    );
  }
}

abstract class _NavitiaStopArea implements NavitiaStopArea {
  const factory _NavitiaStopArea(
      {required final String id,
      required final String name}) = _$NavitiaStopAreaImpl;

  factory _NavitiaStopArea.fromJson(Map<String, dynamic> json) =
      _$NavitiaStopAreaImpl.fromJson;

  @override
  String get id;
  @override
  String get name;

  /// Create a copy of NavitiaStopArea
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NavitiaStopAreaImplCopyWith<_$NavitiaStopAreaImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
