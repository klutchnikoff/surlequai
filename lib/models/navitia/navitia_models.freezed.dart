// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'navitia_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NavitiaResponse {

 List<NavitiaDeparture>? get departures; List<NavitiaJourney>? get journeys; List<NavitiaPlace>? get places;
/// Create a copy of NavitiaResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NavitiaResponseCopyWith<NavitiaResponse> get copyWith => _$NavitiaResponseCopyWithImpl<NavitiaResponse>(this as NavitiaResponse, _$identity);

  /// Serializes this NavitiaResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as NavitiaResponse;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NavitiaResponse&&const DeepCollectionEquality().equals(other.departures, _this.departures)&&const DeepCollectionEquality().equals(other.journeys, _this.journeys)&&const DeepCollectionEquality().equals(other.places, _this.places));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as NavitiaResponse;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.departures),const DeepCollectionEquality().hash(_this.journeys),const DeepCollectionEquality().hash(_this.places));
}

@override
String toString() {
  final _this = this as NavitiaResponse;
  return 'NavitiaResponse(departures: ${_this.departures}, journeys: ${_this.journeys}, places: ${_this.places})';
}


}

/// @nodoc
abstract mixin class $NavitiaResponseCopyWith<$Res>  {
  factory $NavitiaResponseCopyWith(NavitiaResponse value, $Res Function(NavitiaResponse) _then) = _$NavitiaResponseCopyWithImpl;
@useResult
$Res call({
 List<NavitiaDeparture>? departures, List<NavitiaJourney>? journeys, List<NavitiaPlace>? places
});




}
/// @nodoc
class _$NavitiaResponseCopyWithImpl<$Res>
    implements $NavitiaResponseCopyWith<$Res> {
  _$NavitiaResponseCopyWithImpl(this._self, this._then);

  final NavitiaResponse _self;
  final $Res Function(NavitiaResponse) _then;

/// Create a copy of NavitiaResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? departures = freezed,Object? journeys = freezed,Object? places = freezed,}) {
  return _then(NavitiaResponse(
departures: freezed == departures ? _self.departures : departures // ignore: cast_nullable_to_non_nullable
as List<NavitiaDeparture>?,journeys: freezed == journeys ? _self.journeys : journeys // ignore: cast_nullable_to_non_nullable
as List<NavitiaJourney>?,places: freezed == places ? _self.places : places // ignore: cast_nullable_to_non_nullable
as List<NavitiaPlace>?,
  ));
}

}


/// Adds pattern-matching-related methods to [NavitiaResponse].
extension NavitiaResponsePatterns on NavitiaResponse {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NavitiaResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NavitiaResponse() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NavitiaResponse value)  $default,){
final _that = this;
switch (_that) {
case _NavitiaResponse():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NavitiaResponse value)?  $default,){
final _that = this;
switch (_that) {
case _NavitiaResponse() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<NavitiaDeparture>? departures,  List<NavitiaJourney>? journeys,  List<NavitiaPlace>? places)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NavitiaResponse() when $default != null:
return $default(_that.departures,_that.journeys,_that.places);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<NavitiaDeparture>? departures,  List<NavitiaJourney>? journeys,  List<NavitiaPlace>? places)  $default,) {final _that = this;
switch (_that) {
case _NavitiaResponse():
return $default(_that.departures,_that.journeys,_that.places);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<NavitiaDeparture>? departures,  List<NavitiaJourney>? journeys,  List<NavitiaPlace>? places)?  $default,) {final _that = this;
switch (_that) {
case _NavitiaResponse() when $default != null:
return $default(_that.departures,_that.journeys,_that.places);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NavitiaResponse implements NavitiaResponse {
  const _NavitiaResponse({ List<NavitiaDeparture>? departures,  List<NavitiaJourney>? journeys,  List<NavitiaPlace>? places}): _departures = departures,_journeys = journeys,_places = places;
  factory _NavitiaResponse.fromJson(Map<String, dynamic> json) => _$NavitiaResponseFromJson(json);

 final  List<NavitiaDeparture>? _departures;
@override List<NavitiaDeparture>? get departures {
  final value = _departures;
  if (value == null) return null;
  if (_departures is EqualUnmodifiableListView) return _departures;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<NavitiaJourney>? _journeys;
@override List<NavitiaJourney>? get journeys {
  final value = _journeys;
  if (value == null) return null;
  if (_journeys is EqualUnmodifiableListView) return _journeys;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<NavitiaPlace>? _places;
@override List<NavitiaPlace>? get places {
  final value = _places;
  if (value == null) return null;
  if (_places is EqualUnmodifiableListView) return _places;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of NavitiaResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NavitiaResponseCopyWith<_NavitiaResponse> get copyWith => __$NavitiaResponseCopyWithImpl<_NavitiaResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NavitiaResponseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _NavitiaResponse&&const DeepCollectionEquality().equals(other.departures, _departures)&&const DeepCollectionEquality().equals(other.journeys, _journeys)&&const DeepCollectionEquality().equals(other.places, _places));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_departures),const DeepCollectionEquality().hash(_journeys),const DeepCollectionEquality().hash(_places));
}

@override
String toString() {
    return 'NavitiaResponse(departures: $departures, journeys: $journeys, places: $places)';
}


}

/// @nodoc
abstract mixin class _$NavitiaResponseCopyWith<$Res> implements $NavitiaResponseCopyWith<$Res> {
  factory _$NavitiaResponseCopyWith(_NavitiaResponse value, $Res Function(_NavitiaResponse) _then) = __$NavitiaResponseCopyWithImpl;
@override @useResult
$Res call({
 List<NavitiaDeparture>? departures, List<NavitiaJourney>? journeys, List<NavitiaPlace>? places
});




}
/// @nodoc
class __$NavitiaResponseCopyWithImpl<$Res>
    implements _$NavitiaResponseCopyWith<$Res> {
  __$NavitiaResponseCopyWithImpl(this._self, this._then);

  final _NavitiaResponse _self;
  final $Res Function(_NavitiaResponse) _then;

/// Create a copy of NavitiaResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? departures = freezed,Object? journeys = freezed,Object? places = freezed,}) {
  return _then(_NavitiaResponse(
departures: freezed == departures ? _self._departures : departures // ignore: cast_nullable_to_non_nullable
as List<NavitiaDeparture>?,journeys: freezed == journeys ? _self._journeys : journeys // ignore: cast_nullable_to_non_nullable
as List<NavitiaJourney>?,places: freezed == places ? _self._places : places // ignore: cast_nullable_to_non_nullable
as List<NavitiaPlace>?,
  ));
}


}


/// @nodoc
mixin _$NavitiaDeparture {

@JsonKey(name: 'stop_date_time') NavitiaStopDateTime get stopDateTime;@JsonKey(name: 'display_informations') NavitiaDisplayInfo? get displayInformation; NavitiaRoute? get route;
/// Create a copy of NavitiaDeparture
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NavitiaDepartureCopyWith<NavitiaDeparture> get copyWith => _$NavitiaDepartureCopyWithImpl<NavitiaDeparture>(this as NavitiaDeparture, _$identity);

  /// Serializes this NavitiaDeparture to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as NavitiaDeparture;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NavitiaDeparture&&(identical(other.stopDateTime, _this.stopDateTime) || other.stopDateTime == _this.stopDateTime)&&(identical(other.displayInformation, _this.displayInformation) || other.displayInformation == _this.displayInformation)&&(identical(other.route, _this.route) || other.route == _this.route));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as NavitiaDeparture;
  return Object.hash(runtimeType,_this.stopDateTime,_this.displayInformation,_this.route);
}

@override
String toString() {
  final _this = this as NavitiaDeparture;
  return 'NavitiaDeparture(stopDateTime: ${_this.stopDateTime}, displayInformation: ${_this.displayInformation}, route: ${_this.route})';
}


}

/// @nodoc
abstract mixin class $NavitiaDepartureCopyWith<$Res>  {
  factory $NavitiaDepartureCopyWith(NavitiaDeparture value, $Res Function(NavitiaDeparture) _then) = _$NavitiaDepartureCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'stop_date_time') NavitiaStopDateTime stopDateTime,@JsonKey(name: 'display_informations') NavitiaDisplayInfo? displayInformation, NavitiaRoute? route
});


$NavitiaStopDateTimeCopyWith<$Res> get stopDateTime;$NavitiaDisplayInfoCopyWith<$Res>? get displayInformation;$NavitiaRouteCopyWith<$Res>? get route;

}
/// @nodoc
class _$NavitiaDepartureCopyWithImpl<$Res>
    implements $NavitiaDepartureCopyWith<$Res> {
  _$NavitiaDepartureCopyWithImpl(this._self, this._then);

  final NavitiaDeparture _self;
  final $Res Function(NavitiaDeparture) _then;

/// Create a copy of NavitiaDeparture
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? stopDateTime = null,Object? displayInformation = freezed,Object? route = freezed,}) {
  return _then(NavitiaDeparture(
stopDateTime: null == stopDateTime ? _self.stopDateTime : stopDateTime // ignore: cast_nullable_to_non_nullable
as NavitiaStopDateTime,displayInformation: freezed == displayInformation ? _self.displayInformation : displayInformation // ignore: cast_nullable_to_non_nullable
as NavitiaDisplayInfo?,route: freezed == route ? _self.route : route // ignore: cast_nullable_to_non_nullable
as NavitiaRoute?,
  ));
}
/// Create a copy of NavitiaDeparture
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NavitiaStopDateTimeCopyWith<$Res> get stopDateTime {

  return $NavitiaStopDateTimeCopyWith<$Res>(_self.stopDateTime, (value) {
    return _then(_self.copyWith(stopDateTime: value));
  });
}/// Create a copy of NavitiaDeparture
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NavitiaDisplayInfoCopyWith<$Res>? get displayInformation {
    if (_self.displayInformation == null) {
    return null;
  }

  return $NavitiaDisplayInfoCopyWith<$Res>(_self.displayInformation!, (value) {
    return _then(_self.copyWith(displayInformation: value));
  });
}/// Create a copy of NavitiaDeparture
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NavitiaRouteCopyWith<$Res>? get route {
    if (_self.route == null) {
    return null;
  }

  return $NavitiaRouteCopyWith<$Res>(_self.route!, (value) {
    return _then(_self.copyWith(route: value));
  });
}
}


/// Adds pattern-matching-related methods to [NavitiaDeparture].
extension NavitiaDeparturePatterns on NavitiaDeparture {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NavitiaDeparture value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NavitiaDeparture() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NavitiaDeparture value)  $default,){
final _that = this;
switch (_that) {
case _NavitiaDeparture():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NavitiaDeparture value)?  $default,){
final _that = this;
switch (_that) {
case _NavitiaDeparture() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'stop_date_time')  NavitiaStopDateTime stopDateTime, @JsonKey(name: 'display_informations')  NavitiaDisplayInfo? displayInformation,  NavitiaRoute? route)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NavitiaDeparture() when $default != null:
return $default(_that.stopDateTime,_that.displayInformation,_that.route);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'stop_date_time')  NavitiaStopDateTime stopDateTime, @JsonKey(name: 'display_informations')  NavitiaDisplayInfo? displayInformation,  NavitiaRoute? route)  $default,) {final _that = this;
switch (_that) {
case _NavitiaDeparture():
return $default(_that.stopDateTime,_that.displayInformation,_that.route);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'stop_date_time')  NavitiaStopDateTime stopDateTime, @JsonKey(name: 'display_informations')  NavitiaDisplayInfo? displayInformation,  NavitiaRoute? route)?  $default,) {final _that = this;
switch (_that) {
case _NavitiaDeparture() when $default != null:
return $default(_that.stopDateTime,_that.displayInformation,_that.route);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NavitiaDeparture implements NavitiaDeparture {
  const _NavitiaDeparture({@JsonKey(name: 'stop_date_time') required this.stopDateTime, @JsonKey(name: 'display_informations') this.displayInformation, this.route});
  factory _NavitiaDeparture.fromJson(Map<String, dynamic> json) => _$NavitiaDepartureFromJson(json);

@override@JsonKey(name: 'stop_date_time') final  NavitiaStopDateTime stopDateTime;
@override@JsonKey(name: 'display_informations') final  NavitiaDisplayInfo? displayInformation;
@override final  NavitiaRoute? route;

/// Create a copy of NavitiaDeparture
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NavitiaDepartureCopyWith<_NavitiaDeparture> get copyWith => __$NavitiaDepartureCopyWithImpl<_NavitiaDeparture>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NavitiaDepartureToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _NavitiaDeparture&&(identical(other.stopDateTime, stopDateTime) || other.stopDateTime == stopDateTime)&&(identical(other.displayInformation, displayInformation) || other.displayInformation == displayInformation)&&(identical(other.route, route) || other.route == route));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,stopDateTime,displayInformation,route);
}

@override
String toString() {
    return 'NavitiaDeparture(stopDateTime: $stopDateTime, displayInformation: $displayInformation, route: $route)';
}


}

/// @nodoc
abstract mixin class _$NavitiaDepartureCopyWith<$Res> implements $NavitiaDepartureCopyWith<$Res> {
  factory _$NavitiaDepartureCopyWith(_NavitiaDeparture value, $Res Function(_NavitiaDeparture) _then) = __$NavitiaDepartureCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'stop_date_time') NavitiaStopDateTime stopDateTime,@JsonKey(name: 'display_informations') NavitiaDisplayInfo? displayInformation, NavitiaRoute? route
});


@override $NavitiaStopDateTimeCopyWith<$Res> get stopDateTime;@override $NavitiaDisplayInfoCopyWith<$Res>? get displayInformation;@override $NavitiaRouteCopyWith<$Res>? get route;

}
/// @nodoc
class __$NavitiaDepartureCopyWithImpl<$Res>
    implements _$NavitiaDepartureCopyWith<$Res> {
  __$NavitiaDepartureCopyWithImpl(this._self, this._then);

  final _NavitiaDeparture _self;
  final $Res Function(_NavitiaDeparture) _then;

/// Create a copy of NavitiaDeparture
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? stopDateTime = null,Object? displayInformation = freezed,Object? route = freezed,}) {
  return _then(_NavitiaDeparture(
stopDateTime: null == stopDateTime ? _self.stopDateTime : stopDateTime // ignore: cast_nullable_to_non_nullable
as NavitiaStopDateTime,displayInformation: freezed == displayInformation ? _self.displayInformation : displayInformation // ignore: cast_nullable_to_non_nullable
as NavitiaDisplayInfo?,route: freezed == route ? _self.route : route // ignore: cast_nullable_to_non_nullable
as NavitiaRoute?,
  ));
}

/// Create a copy of NavitiaDeparture
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NavitiaStopDateTimeCopyWith<$Res> get stopDateTime {

  return $NavitiaStopDateTimeCopyWith<$Res>(_self.stopDateTime, (value) {
    return _then(_self.copyWith(stopDateTime: value));
  });
}/// Create a copy of NavitiaDeparture
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NavitiaDisplayInfoCopyWith<$Res>? get displayInformation {
    if (_self.displayInformation == null) {
    return null;
  }

  return $NavitiaDisplayInfoCopyWith<$Res>(_self.displayInformation!, (value) {
    return _then(_self.copyWith(displayInformation: value));
  });
}/// Create a copy of NavitiaDeparture
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NavitiaRouteCopyWith<$Res>? get route {
    if (_self.route == null) {
    return null;
  }

  return $NavitiaRouteCopyWith<$Res>(_self.route!, (value) {
    return _then(_self.copyWith(route: value));
  });
}
}


/// @nodoc
mixin _$NavitiaStopDateTime {

@JsonKey(name: 'departure_date_time') String get departureDateTime;@JsonKey(name: 'base_departure_date_time') String get baseDepartureDateTime;@JsonKey(name: 'data_freshness') String get dataFreshness; String? get platform;
/// Create a copy of NavitiaStopDateTime
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NavitiaStopDateTimeCopyWith<NavitiaStopDateTime> get copyWith => _$NavitiaStopDateTimeCopyWithImpl<NavitiaStopDateTime>(this as NavitiaStopDateTime, _$identity);

  /// Serializes this NavitiaStopDateTime to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as NavitiaStopDateTime;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NavitiaStopDateTime&&(identical(other.departureDateTime, _this.departureDateTime) || other.departureDateTime == _this.departureDateTime)&&(identical(other.baseDepartureDateTime, _this.baseDepartureDateTime) || other.baseDepartureDateTime == _this.baseDepartureDateTime)&&(identical(other.dataFreshness, _this.dataFreshness) || other.dataFreshness == _this.dataFreshness)&&(identical(other.platform, _this.platform) || other.platform == _this.platform));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as NavitiaStopDateTime;
  return Object.hash(runtimeType,_this.departureDateTime,_this.baseDepartureDateTime,_this.dataFreshness,_this.platform);
}

@override
String toString() {
  final _this = this as NavitiaStopDateTime;
  return 'NavitiaStopDateTime(departureDateTime: ${_this.departureDateTime}, baseDepartureDateTime: ${_this.baseDepartureDateTime}, dataFreshness: ${_this.dataFreshness}, platform: ${_this.platform})';
}


}

/// @nodoc
abstract mixin class $NavitiaStopDateTimeCopyWith<$Res>  {
  factory $NavitiaStopDateTimeCopyWith(NavitiaStopDateTime value, $Res Function(NavitiaStopDateTime) _then) = _$NavitiaStopDateTimeCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'departure_date_time') String departureDateTime,@JsonKey(name: 'base_departure_date_time') String baseDepartureDateTime,@JsonKey(name: 'data_freshness') String dataFreshness, String? platform
});




}
/// @nodoc
class _$NavitiaStopDateTimeCopyWithImpl<$Res>
    implements $NavitiaStopDateTimeCopyWith<$Res> {
  _$NavitiaStopDateTimeCopyWithImpl(this._self, this._then);

  final NavitiaStopDateTime _self;
  final $Res Function(NavitiaStopDateTime) _then;

/// Create a copy of NavitiaStopDateTime
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? departureDateTime = null,Object? baseDepartureDateTime = null,Object? dataFreshness = null,Object? platform = freezed,}) {
  return _then(NavitiaStopDateTime(
departureDateTime: null == departureDateTime ? _self.departureDateTime : departureDateTime // ignore: cast_nullable_to_non_nullable
as String,baseDepartureDateTime: null == baseDepartureDateTime ? _self.baseDepartureDateTime : baseDepartureDateTime // ignore: cast_nullable_to_non_nullable
as String,dataFreshness: null == dataFreshness ? _self.dataFreshness : dataFreshness // ignore: cast_nullable_to_non_nullable
as String,platform: freezed == platform ? _self.platform : platform // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [NavitiaStopDateTime].
extension NavitiaStopDateTimePatterns on NavitiaStopDateTime {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NavitiaStopDateTime value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NavitiaStopDateTime() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NavitiaStopDateTime value)  $default,){
final _that = this;
switch (_that) {
case _NavitiaStopDateTime():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NavitiaStopDateTime value)?  $default,){
final _that = this;
switch (_that) {
case _NavitiaStopDateTime() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'departure_date_time')  String departureDateTime, @JsonKey(name: 'base_departure_date_time')  String baseDepartureDateTime, @JsonKey(name: 'data_freshness')  String dataFreshness,  String? platform)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NavitiaStopDateTime() when $default != null:
return $default(_that.departureDateTime,_that.baseDepartureDateTime,_that.dataFreshness,_that.platform);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'departure_date_time')  String departureDateTime, @JsonKey(name: 'base_departure_date_time')  String baseDepartureDateTime, @JsonKey(name: 'data_freshness')  String dataFreshness,  String? platform)  $default,) {final _that = this;
switch (_that) {
case _NavitiaStopDateTime():
return $default(_that.departureDateTime,_that.baseDepartureDateTime,_that.dataFreshness,_that.platform);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'departure_date_time')  String departureDateTime, @JsonKey(name: 'base_departure_date_time')  String baseDepartureDateTime, @JsonKey(name: 'data_freshness')  String dataFreshness,  String? platform)?  $default,) {final _that = this;
switch (_that) {
case _NavitiaStopDateTime() when $default != null:
return $default(_that.departureDateTime,_that.baseDepartureDateTime,_that.dataFreshness,_that.platform);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NavitiaStopDateTime implements NavitiaStopDateTime {
  const _NavitiaStopDateTime({@JsonKey(name: 'departure_date_time') required this.departureDateTime, @JsonKey(name: 'base_departure_date_time') required this.baseDepartureDateTime, @JsonKey(name: 'data_freshness') required this.dataFreshness, this.platform});
  factory _NavitiaStopDateTime.fromJson(Map<String, dynamic> json) => _$NavitiaStopDateTimeFromJson(json);

@override@JsonKey(name: 'departure_date_time') final  String departureDateTime;
@override@JsonKey(name: 'base_departure_date_time') final  String baseDepartureDateTime;
@override@JsonKey(name: 'data_freshness') final  String dataFreshness;
@override final  String? platform;

/// Create a copy of NavitiaStopDateTime
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NavitiaStopDateTimeCopyWith<_NavitiaStopDateTime> get copyWith => __$NavitiaStopDateTimeCopyWithImpl<_NavitiaStopDateTime>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NavitiaStopDateTimeToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _NavitiaStopDateTime&&(identical(other.departureDateTime, departureDateTime) || other.departureDateTime == departureDateTime)&&(identical(other.baseDepartureDateTime, baseDepartureDateTime) || other.baseDepartureDateTime == baseDepartureDateTime)&&(identical(other.dataFreshness, dataFreshness) || other.dataFreshness == dataFreshness)&&(identical(other.platform, platform) || other.platform == platform));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,departureDateTime,baseDepartureDateTime,dataFreshness,platform);
}

@override
String toString() {
    return 'NavitiaStopDateTime(departureDateTime: $departureDateTime, baseDepartureDateTime: $baseDepartureDateTime, dataFreshness: $dataFreshness, platform: $platform)';
}


}

/// @nodoc
abstract mixin class _$NavitiaStopDateTimeCopyWith<$Res> implements $NavitiaStopDateTimeCopyWith<$Res> {
  factory _$NavitiaStopDateTimeCopyWith(_NavitiaStopDateTime value, $Res Function(_NavitiaStopDateTime) _then) = __$NavitiaStopDateTimeCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'departure_date_time') String departureDateTime,@JsonKey(name: 'base_departure_date_time') String baseDepartureDateTime,@JsonKey(name: 'data_freshness') String dataFreshness, String? platform
});




}
/// @nodoc
class __$NavitiaStopDateTimeCopyWithImpl<$Res>
    implements _$NavitiaStopDateTimeCopyWith<$Res> {
  __$NavitiaStopDateTimeCopyWithImpl(this._self, this._then);

  final _NavitiaStopDateTime _self;
  final $Res Function(_NavitiaStopDateTime) _then;

/// Create a copy of NavitiaStopDateTime
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? departureDateTime = null,Object? baseDepartureDateTime = null,Object? dataFreshness = null,Object? platform = freezed,}) {
  return _then(_NavitiaStopDateTime(
departureDateTime: null == departureDateTime ? _self.departureDateTime : departureDateTime // ignore: cast_nullable_to_non_nullable
as String,baseDepartureDateTime: null == baseDepartureDateTime ? _self.baseDepartureDateTime : baseDepartureDateTime // ignore: cast_nullable_to_non_nullable
as String,dataFreshness: null == dataFreshness ? _self.dataFreshness : dataFreshness // ignore: cast_nullable_to_non_nullable
as String,platform: freezed == platform ? _self.platform : platform // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$NavitiaDisplayInfo {

 String? get network; String? get direction;@JsonKey(name: 'trip_short_name') String? get tripShortName;
/// Create a copy of NavitiaDisplayInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NavitiaDisplayInfoCopyWith<NavitiaDisplayInfo> get copyWith => _$NavitiaDisplayInfoCopyWithImpl<NavitiaDisplayInfo>(this as NavitiaDisplayInfo, _$identity);

  /// Serializes this NavitiaDisplayInfo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as NavitiaDisplayInfo;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NavitiaDisplayInfo&&(identical(other.network, _this.network) || other.network == _this.network)&&(identical(other.direction, _this.direction) || other.direction == _this.direction)&&(identical(other.tripShortName, _this.tripShortName) || other.tripShortName == _this.tripShortName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as NavitiaDisplayInfo;
  return Object.hash(runtimeType,_this.network,_this.direction,_this.tripShortName);
}

@override
String toString() {
  final _this = this as NavitiaDisplayInfo;
  return 'NavitiaDisplayInfo(network: ${_this.network}, direction: ${_this.direction}, tripShortName: ${_this.tripShortName})';
}


}

/// @nodoc
abstract mixin class $NavitiaDisplayInfoCopyWith<$Res>  {
  factory $NavitiaDisplayInfoCopyWith(NavitiaDisplayInfo value, $Res Function(NavitiaDisplayInfo) _then) = _$NavitiaDisplayInfoCopyWithImpl;
@useResult
$Res call({
 String? network, String? direction,@JsonKey(name: 'trip_short_name') String? tripShortName
});




}
/// @nodoc
class _$NavitiaDisplayInfoCopyWithImpl<$Res>
    implements $NavitiaDisplayInfoCopyWith<$Res> {
  _$NavitiaDisplayInfoCopyWithImpl(this._self, this._then);

  final NavitiaDisplayInfo _self;
  final $Res Function(NavitiaDisplayInfo) _then;

/// Create a copy of NavitiaDisplayInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? network = freezed,Object? direction = freezed,Object? tripShortName = freezed,}) {
  return _then(NavitiaDisplayInfo(
network: freezed == network ? _self.network : network // ignore: cast_nullable_to_non_nullable
as String?,direction: freezed == direction ? _self.direction : direction // ignore: cast_nullable_to_non_nullable
as String?,tripShortName: freezed == tripShortName ? _self.tripShortName : tripShortName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [NavitiaDisplayInfo].
extension NavitiaDisplayInfoPatterns on NavitiaDisplayInfo {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NavitiaDisplayInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NavitiaDisplayInfo() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NavitiaDisplayInfo value)  $default,){
final _that = this;
switch (_that) {
case _NavitiaDisplayInfo():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NavitiaDisplayInfo value)?  $default,){
final _that = this;
switch (_that) {
case _NavitiaDisplayInfo() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? network,  String? direction, @JsonKey(name: 'trip_short_name')  String? tripShortName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NavitiaDisplayInfo() when $default != null:
return $default(_that.network,_that.direction,_that.tripShortName);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? network,  String? direction, @JsonKey(name: 'trip_short_name')  String? tripShortName)  $default,) {final _that = this;
switch (_that) {
case _NavitiaDisplayInfo():
return $default(_that.network,_that.direction,_that.tripShortName);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? network,  String? direction, @JsonKey(name: 'trip_short_name')  String? tripShortName)?  $default,) {final _that = this;
switch (_that) {
case _NavitiaDisplayInfo() when $default != null:
return $default(_that.network,_that.direction,_that.tripShortName);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NavitiaDisplayInfo implements NavitiaDisplayInfo {
  const _NavitiaDisplayInfo({this.network, this.direction, @JsonKey(name: 'trip_short_name') this.tripShortName});
  factory _NavitiaDisplayInfo.fromJson(Map<String, dynamic> json) => _$NavitiaDisplayInfoFromJson(json);

@override final  String? network;
@override final  String? direction;
@override@JsonKey(name: 'trip_short_name') final  String? tripShortName;

/// Create a copy of NavitiaDisplayInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NavitiaDisplayInfoCopyWith<_NavitiaDisplayInfo> get copyWith => __$NavitiaDisplayInfoCopyWithImpl<_NavitiaDisplayInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NavitiaDisplayInfoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _NavitiaDisplayInfo&&(identical(other.network, network) || other.network == network)&&(identical(other.direction, direction) || other.direction == direction)&&(identical(other.tripShortName, tripShortName) || other.tripShortName == tripShortName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,network,direction,tripShortName);
}

@override
String toString() {
    return 'NavitiaDisplayInfo(network: $network, direction: $direction, tripShortName: $tripShortName)';
}


}

/// @nodoc
abstract mixin class _$NavitiaDisplayInfoCopyWith<$Res> implements $NavitiaDisplayInfoCopyWith<$Res> {
  factory _$NavitiaDisplayInfoCopyWith(_NavitiaDisplayInfo value, $Res Function(_NavitiaDisplayInfo) _then) = __$NavitiaDisplayInfoCopyWithImpl;
@override @useResult
$Res call({
 String? network, String? direction,@JsonKey(name: 'trip_short_name') String? tripShortName
});




}
/// @nodoc
class __$NavitiaDisplayInfoCopyWithImpl<$Res>
    implements _$NavitiaDisplayInfoCopyWith<$Res> {
  __$NavitiaDisplayInfoCopyWithImpl(this._self, this._then);

  final _NavitiaDisplayInfo _self;
  final $Res Function(_NavitiaDisplayInfo) _then;

/// Create a copy of NavitiaDisplayInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? network = freezed,Object? direction = freezed,Object? tripShortName = freezed,}) {
  return _then(_NavitiaDisplayInfo(
network: freezed == network ? _self.network : network // ignore: cast_nullable_to_non_nullable
as String?,direction: freezed == direction ? _self.direction : direction // ignore: cast_nullable_to_non_nullable
as String?,tripShortName: freezed == tripShortName ? _self.tripShortName : tripShortName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$NavitiaRoute {

 String? get id; String? get name;
/// Create a copy of NavitiaRoute
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NavitiaRouteCopyWith<NavitiaRoute> get copyWith => _$NavitiaRouteCopyWithImpl<NavitiaRoute>(this as NavitiaRoute, _$identity);

  /// Serializes this NavitiaRoute to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as NavitiaRoute;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NavitiaRoute&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as NavitiaRoute;
  return Object.hash(runtimeType,_this.id,_this.name);
}

@override
String toString() {
  final _this = this as NavitiaRoute;
  return 'NavitiaRoute(id: ${_this.id}, name: ${_this.name})';
}


}

/// @nodoc
abstract mixin class $NavitiaRouteCopyWith<$Res>  {
  factory $NavitiaRouteCopyWith(NavitiaRoute value, $Res Function(NavitiaRoute) _then) = _$NavitiaRouteCopyWithImpl;
@useResult
$Res call({
 String? id, String? name
});




}
/// @nodoc
class _$NavitiaRouteCopyWithImpl<$Res>
    implements $NavitiaRouteCopyWith<$Res> {
  _$NavitiaRouteCopyWithImpl(this._self, this._then);

  final NavitiaRoute _self;
  final $Res Function(NavitiaRoute) _then;

/// Create a copy of NavitiaRoute
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? name = freezed,}) {
  return _then(NavitiaRoute(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [NavitiaRoute].
extension NavitiaRoutePatterns on NavitiaRoute {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NavitiaRoute value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NavitiaRoute() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NavitiaRoute value)  $default,){
final _that = this;
switch (_that) {
case _NavitiaRoute():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NavitiaRoute value)?  $default,){
final _that = this;
switch (_that) {
case _NavitiaRoute() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id,  String? name)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NavitiaRoute() when $default != null:
return $default(_that.id,_that.name);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id,  String? name)  $default,) {final _that = this;
switch (_that) {
case _NavitiaRoute():
return $default(_that.id,_that.name);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id,  String? name)?  $default,) {final _that = this;
switch (_that) {
case _NavitiaRoute() when $default != null:
return $default(_that.id,_that.name);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NavitiaRoute implements NavitiaRoute {
  const _NavitiaRoute({this.id, this.name});
  factory _NavitiaRoute.fromJson(Map<String, dynamic> json) => _$NavitiaRouteFromJson(json);

@override final  String? id;
@override final  String? name;

/// Create a copy of NavitiaRoute
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NavitiaRouteCopyWith<_NavitiaRoute> get copyWith => __$NavitiaRouteCopyWithImpl<_NavitiaRoute>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NavitiaRouteToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _NavitiaRoute&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name);
}

@override
String toString() {
    return 'NavitiaRoute(id: $id, name: $name)';
}


}

/// @nodoc
abstract mixin class _$NavitiaRouteCopyWith<$Res> implements $NavitiaRouteCopyWith<$Res> {
  factory _$NavitiaRouteCopyWith(_NavitiaRoute value, $Res Function(_NavitiaRoute) _then) = __$NavitiaRouteCopyWithImpl;
@override @useResult
$Res call({
 String? id, String? name
});




}
/// @nodoc
class __$NavitiaRouteCopyWithImpl<$Res>
    implements _$NavitiaRouteCopyWith<$Res> {
  __$NavitiaRouteCopyWithImpl(this._self, this._then);

  final _NavitiaRoute _self;
  final $Res Function(_NavitiaRoute) _then;

/// Create a copy of NavitiaRoute
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? name = freezed,}) {
  return _then(_NavitiaRoute(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$NavitiaJourney {

@JsonKey(name: 'nb_transfers') int get nbTransfers; String? get status; List<NavitiaSection>? get sections;
/// Create a copy of NavitiaJourney
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NavitiaJourneyCopyWith<NavitiaJourney> get copyWith => _$NavitiaJourneyCopyWithImpl<NavitiaJourney>(this as NavitiaJourney, _$identity);

  /// Serializes this NavitiaJourney to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as NavitiaJourney;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NavitiaJourney&&(identical(other.nbTransfers, _this.nbTransfers) || other.nbTransfers == _this.nbTransfers)&&(identical(other.status, _this.status) || other.status == _this.status)&&const DeepCollectionEquality().equals(other.sections, _this.sections));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as NavitiaJourney;
  return Object.hash(runtimeType,_this.nbTransfers,_this.status,const DeepCollectionEquality().hash(_this.sections));
}

@override
String toString() {
  final _this = this as NavitiaJourney;
  return 'NavitiaJourney(nbTransfers: ${_this.nbTransfers}, status: ${_this.status}, sections: ${_this.sections})';
}


}

/// @nodoc
abstract mixin class $NavitiaJourneyCopyWith<$Res>  {
  factory $NavitiaJourneyCopyWith(NavitiaJourney value, $Res Function(NavitiaJourney) _then) = _$NavitiaJourneyCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'nb_transfers') int nbTransfers, String? status, List<NavitiaSection>? sections
});




}
/// @nodoc
class _$NavitiaJourneyCopyWithImpl<$Res>
    implements $NavitiaJourneyCopyWith<$Res> {
  _$NavitiaJourneyCopyWithImpl(this._self, this._then);

  final NavitiaJourney _self;
  final $Res Function(NavitiaJourney) _then;

/// Create a copy of NavitiaJourney
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? nbTransfers = null,Object? status = freezed,Object? sections = freezed,}) {
  return _then(NavitiaJourney(
nbTransfers: null == nbTransfers ? _self.nbTransfers : nbTransfers // ignore: cast_nullable_to_non_nullable
as int,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,sections: freezed == sections ? _self.sections : sections // ignore: cast_nullable_to_non_nullable
as List<NavitiaSection>?,
  ));
}

}


/// Adds pattern-matching-related methods to [NavitiaJourney].
extension NavitiaJourneyPatterns on NavitiaJourney {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NavitiaJourney value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NavitiaJourney() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NavitiaJourney value)  $default,){
final _that = this;
switch (_that) {
case _NavitiaJourney():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NavitiaJourney value)?  $default,){
final _that = this;
switch (_that) {
case _NavitiaJourney() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'nb_transfers')  int nbTransfers,  String? status,  List<NavitiaSection>? sections)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NavitiaJourney() when $default != null:
return $default(_that.nbTransfers,_that.status,_that.sections);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'nb_transfers')  int nbTransfers,  String? status,  List<NavitiaSection>? sections)  $default,) {final _that = this;
switch (_that) {
case _NavitiaJourney():
return $default(_that.nbTransfers,_that.status,_that.sections);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'nb_transfers')  int nbTransfers,  String? status,  List<NavitiaSection>? sections)?  $default,) {final _that = this;
switch (_that) {
case _NavitiaJourney() when $default != null:
return $default(_that.nbTransfers,_that.status,_that.sections);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NavitiaJourney implements NavitiaJourney {
  const _NavitiaJourney({@JsonKey(name: 'nb_transfers') required this.nbTransfers, this.status,  List<NavitiaSection>? sections}): _sections = sections;
  factory _NavitiaJourney.fromJson(Map<String, dynamic> json) => _$NavitiaJourneyFromJson(json);

@override@JsonKey(name: 'nb_transfers') final  int nbTransfers;
@override final  String? status;
 final  List<NavitiaSection>? _sections;
@override List<NavitiaSection>? get sections {
  final value = _sections;
  if (value == null) return null;
  if (_sections is EqualUnmodifiableListView) return _sections;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of NavitiaJourney
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NavitiaJourneyCopyWith<_NavitiaJourney> get copyWith => __$NavitiaJourneyCopyWithImpl<_NavitiaJourney>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NavitiaJourneyToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _NavitiaJourney&&(identical(other.nbTransfers, nbTransfers) || other.nbTransfers == nbTransfers)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.sections, _sections));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,nbTransfers,status,const DeepCollectionEquality().hash(_sections));
}

@override
String toString() {
    return 'NavitiaJourney(nbTransfers: $nbTransfers, status: $status, sections: $sections)';
}


}

/// @nodoc
abstract mixin class _$NavitiaJourneyCopyWith<$Res> implements $NavitiaJourneyCopyWith<$Res> {
  factory _$NavitiaJourneyCopyWith(_NavitiaJourney value, $Res Function(_NavitiaJourney) _then) = __$NavitiaJourneyCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'nb_transfers') int nbTransfers, String? status, List<NavitiaSection>? sections
});




}
/// @nodoc
class __$NavitiaJourneyCopyWithImpl<$Res>
    implements _$NavitiaJourneyCopyWith<$Res> {
  __$NavitiaJourneyCopyWithImpl(this._self, this._then);

  final _NavitiaJourney _self;
  final $Res Function(_NavitiaJourney) _then;

/// Create a copy of NavitiaJourney
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? nbTransfers = null,Object? status = freezed,Object? sections = freezed,}) {
  return _then(_NavitiaJourney(
nbTransfers: null == nbTransfers ? _self.nbTransfers : nbTransfers // ignore: cast_nullable_to_non_nullable
as int,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,sections: freezed == sections ? _self._sections : sections // ignore: cast_nullable_to_non_nullable
as List<NavitiaSection>?,
  ));
}


}


/// @nodoc
mixin _$NavitiaSection {

 String? get type; String? get id;@JsonKey(name: 'display_informations') NavitiaDisplayInfo? get displayInformation;@JsonKey(name: 'departure_date_time') String? get departureDateTime;@JsonKey(name: 'base_departure_date_time') String? get baseDepartureDateTime;@JsonKey(name: 'arrival_date_time') String? get arrivalDateTime;@JsonKey(name: 'data_freshness') String? get dataFreshness;@JsonKey(name: 'stop_date_times') List<NavitiaStopPoint>? get stopDateTimes;
/// Create a copy of NavitiaSection
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NavitiaSectionCopyWith<NavitiaSection> get copyWith => _$NavitiaSectionCopyWithImpl<NavitiaSection>(this as NavitiaSection, _$identity);

  /// Serializes this NavitiaSection to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as NavitiaSection;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NavitiaSection&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.displayInformation, _this.displayInformation) || other.displayInformation == _this.displayInformation)&&(identical(other.departureDateTime, _this.departureDateTime) || other.departureDateTime == _this.departureDateTime)&&(identical(other.baseDepartureDateTime, _this.baseDepartureDateTime) || other.baseDepartureDateTime == _this.baseDepartureDateTime)&&(identical(other.arrivalDateTime, _this.arrivalDateTime) || other.arrivalDateTime == _this.arrivalDateTime)&&(identical(other.dataFreshness, _this.dataFreshness) || other.dataFreshness == _this.dataFreshness)&&const DeepCollectionEquality().equals(other.stopDateTimes, _this.stopDateTimes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as NavitiaSection;
  return Object.hash(runtimeType,_this.type,_this.id,_this.displayInformation,_this.departureDateTime,_this.baseDepartureDateTime,_this.arrivalDateTime,_this.dataFreshness,const DeepCollectionEquality().hash(_this.stopDateTimes));
}

@override
String toString() {
  final _this = this as NavitiaSection;
  return 'NavitiaSection(type: ${_this.type}, id: ${_this.id}, displayInformation: ${_this.displayInformation}, departureDateTime: ${_this.departureDateTime}, baseDepartureDateTime: ${_this.baseDepartureDateTime}, arrivalDateTime: ${_this.arrivalDateTime}, dataFreshness: ${_this.dataFreshness}, stopDateTimes: ${_this.stopDateTimes})';
}


}

/// @nodoc
abstract mixin class $NavitiaSectionCopyWith<$Res>  {
  factory $NavitiaSectionCopyWith(NavitiaSection value, $Res Function(NavitiaSection) _then) = _$NavitiaSectionCopyWithImpl;
@useResult
$Res call({
 String? type, String? id,@JsonKey(name: 'display_informations') NavitiaDisplayInfo? displayInformation,@JsonKey(name: 'departure_date_time') String? departureDateTime,@JsonKey(name: 'base_departure_date_time') String? baseDepartureDateTime,@JsonKey(name: 'arrival_date_time') String? arrivalDateTime,@JsonKey(name: 'data_freshness') String? dataFreshness,@JsonKey(name: 'stop_date_times') List<NavitiaStopPoint>? stopDateTimes
});


$NavitiaDisplayInfoCopyWith<$Res>? get displayInformation;

}
/// @nodoc
class _$NavitiaSectionCopyWithImpl<$Res>
    implements $NavitiaSectionCopyWith<$Res> {
  _$NavitiaSectionCopyWithImpl(this._self, this._then);

  final NavitiaSection _self;
  final $Res Function(NavitiaSection) _then;

/// Create a copy of NavitiaSection
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = freezed,Object? id = freezed,Object? displayInformation = freezed,Object? departureDateTime = freezed,Object? baseDepartureDateTime = freezed,Object? arrivalDateTime = freezed,Object? dataFreshness = freezed,Object? stopDateTimes = freezed,}) {
  return _then(NavitiaSection(
type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,displayInformation: freezed == displayInformation ? _self.displayInformation : displayInformation // ignore: cast_nullable_to_non_nullable
as NavitiaDisplayInfo?,departureDateTime: freezed == departureDateTime ? _self.departureDateTime : departureDateTime // ignore: cast_nullable_to_non_nullable
as String?,baseDepartureDateTime: freezed == baseDepartureDateTime ? _self.baseDepartureDateTime : baseDepartureDateTime // ignore: cast_nullable_to_non_nullable
as String?,arrivalDateTime: freezed == arrivalDateTime ? _self.arrivalDateTime : arrivalDateTime // ignore: cast_nullable_to_non_nullable
as String?,dataFreshness: freezed == dataFreshness ? _self.dataFreshness : dataFreshness // ignore: cast_nullable_to_non_nullable
as String?,stopDateTimes: freezed == stopDateTimes ? _self.stopDateTimes : stopDateTimes // ignore: cast_nullable_to_non_nullable
as List<NavitiaStopPoint>?,
  ));
}
/// Create a copy of NavitiaSection
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NavitiaDisplayInfoCopyWith<$Res>? get displayInformation {
    if (_self.displayInformation == null) {
    return null;
  }

  return $NavitiaDisplayInfoCopyWith<$Res>(_self.displayInformation!, (value) {
    return _then(_self.copyWith(displayInformation: value));
  });
}
}


/// Adds pattern-matching-related methods to [NavitiaSection].
extension NavitiaSectionPatterns on NavitiaSection {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NavitiaSection value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NavitiaSection() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NavitiaSection value)  $default,){
final _that = this;
switch (_that) {
case _NavitiaSection():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NavitiaSection value)?  $default,){
final _that = this;
switch (_that) {
case _NavitiaSection() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? type,  String? id, @JsonKey(name: 'display_informations')  NavitiaDisplayInfo? displayInformation, @JsonKey(name: 'departure_date_time')  String? departureDateTime, @JsonKey(name: 'base_departure_date_time')  String? baseDepartureDateTime, @JsonKey(name: 'arrival_date_time')  String? arrivalDateTime, @JsonKey(name: 'data_freshness')  String? dataFreshness, @JsonKey(name: 'stop_date_times')  List<NavitiaStopPoint>? stopDateTimes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NavitiaSection() when $default != null:
return $default(_that.type,_that.id,_that.displayInformation,_that.departureDateTime,_that.baseDepartureDateTime,_that.arrivalDateTime,_that.dataFreshness,_that.stopDateTimes);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? type,  String? id, @JsonKey(name: 'display_informations')  NavitiaDisplayInfo? displayInformation, @JsonKey(name: 'departure_date_time')  String? departureDateTime, @JsonKey(name: 'base_departure_date_time')  String? baseDepartureDateTime, @JsonKey(name: 'arrival_date_time')  String? arrivalDateTime, @JsonKey(name: 'data_freshness')  String? dataFreshness, @JsonKey(name: 'stop_date_times')  List<NavitiaStopPoint>? stopDateTimes)  $default,) {final _that = this;
switch (_that) {
case _NavitiaSection():
return $default(_that.type,_that.id,_that.displayInformation,_that.departureDateTime,_that.baseDepartureDateTime,_that.arrivalDateTime,_that.dataFreshness,_that.stopDateTimes);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? type,  String? id, @JsonKey(name: 'display_informations')  NavitiaDisplayInfo? displayInformation, @JsonKey(name: 'departure_date_time')  String? departureDateTime, @JsonKey(name: 'base_departure_date_time')  String? baseDepartureDateTime, @JsonKey(name: 'arrival_date_time')  String? arrivalDateTime, @JsonKey(name: 'data_freshness')  String? dataFreshness, @JsonKey(name: 'stop_date_times')  List<NavitiaStopPoint>? stopDateTimes)?  $default,) {final _that = this;
switch (_that) {
case _NavitiaSection() when $default != null:
return $default(_that.type,_that.id,_that.displayInformation,_that.departureDateTime,_that.baseDepartureDateTime,_that.arrivalDateTime,_that.dataFreshness,_that.stopDateTimes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NavitiaSection implements NavitiaSection {
  const _NavitiaSection({this.type, this.id, @JsonKey(name: 'display_informations') this.displayInformation, @JsonKey(name: 'departure_date_time') this.departureDateTime, @JsonKey(name: 'base_departure_date_time') this.baseDepartureDateTime, @JsonKey(name: 'arrival_date_time') this.arrivalDateTime, @JsonKey(name: 'data_freshness') this.dataFreshness, @JsonKey(name: 'stop_date_times')  List<NavitiaStopPoint>? stopDateTimes}): _stopDateTimes = stopDateTimes;
  factory _NavitiaSection.fromJson(Map<String, dynamic> json) => _$NavitiaSectionFromJson(json);

@override final  String? type;
@override final  String? id;
@override@JsonKey(name: 'display_informations') final  NavitiaDisplayInfo? displayInformation;
@override@JsonKey(name: 'departure_date_time') final  String? departureDateTime;
@override@JsonKey(name: 'base_departure_date_time') final  String? baseDepartureDateTime;
@override@JsonKey(name: 'arrival_date_time') final  String? arrivalDateTime;
@override@JsonKey(name: 'data_freshness') final  String? dataFreshness;
 final  List<NavitiaStopPoint>? _stopDateTimes;
@override@JsonKey(name: 'stop_date_times') List<NavitiaStopPoint>? get stopDateTimes {
  final value = _stopDateTimes;
  if (value == null) return null;
  if (_stopDateTimes is EqualUnmodifiableListView) return _stopDateTimes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of NavitiaSection
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NavitiaSectionCopyWith<_NavitiaSection> get copyWith => __$NavitiaSectionCopyWithImpl<_NavitiaSection>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NavitiaSectionToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _NavitiaSection&&(identical(other.type, type) || other.type == type)&&(identical(other.id, id) || other.id == id)&&(identical(other.displayInformation, displayInformation) || other.displayInformation == displayInformation)&&(identical(other.departureDateTime, departureDateTime) || other.departureDateTime == departureDateTime)&&(identical(other.baseDepartureDateTime, baseDepartureDateTime) || other.baseDepartureDateTime == baseDepartureDateTime)&&(identical(other.arrivalDateTime, arrivalDateTime) || other.arrivalDateTime == arrivalDateTime)&&(identical(other.dataFreshness, dataFreshness) || other.dataFreshness == dataFreshness)&&const DeepCollectionEquality().equals(other.stopDateTimes, _stopDateTimes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,type,id,displayInformation,departureDateTime,baseDepartureDateTime,arrivalDateTime,dataFreshness,const DeepCollectionEquality().hash(_stopDateTimes));
}

@override
String toString() {
    return 'NavitiaSection(type: $type, id: $id, displayInformation: $displayInformation, departureDateTime: $departureDateTime, baseDepartureDateTime: $baseDepartureDateTime, arrivalDateTime: $arrivalDateTime, dataFreshness: $dataFreshness, stopDateTimes: $stopDateTimes)';
}


}

/// @nodoc
abstract mixin class _$NavitiaSectionCopyWith<$Res> implements $NavitiaSectionCopyWith<$Res> {
  factory _$NavitiaSectionCopyWith(_NavitiaSection value, $Res Function(_NavitiaSection) _then) = __$NavitiaSectionCopyWithImpl;
@override @useResult
$Res call({
 String? type, String? id,@JsonKey(name: 'display_informations') NavitiaDisplayInfo? displayInformation,@JsonKey(name: 'departure_date_time') String? departureDateTime,@JsonKey(name: 'base_departure_date_time') String? baseDepartureDateTime,@JsonKey(name: 'arrival_date_time') String? arrivalDateTime,@JsonKey(name: 'data_freshness') String? dataFreshness,@JsonKey(name: 'stop_date_times') List<NavitiaStopPoint>? stopDateTimes
});


@override $NavitiaDisplayInfoCopyWith<$Res>? get displayInformation;

}
/// @nodoc
class __$NavitiaSectionCopyWithImpl<$Res>
    implements _$NavitiaSectionCopyWith<$Res> {
  __$NavitiaSectionCopyWithImpl(this._self, this._then);

  final _NavitiaSection _self;
  final $Res Function(_NavitiaSection) _then;

/// Create a copy of NavitiaSection
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = freezed,Object? id = freezed,Object? displayInformation = freezed,Object? departureDateTime = freezed,Object? baseDepartureDateTime = freezed,Object? arrivalDateTime = freezed,Object? dataFreshness = freezed,Object? stopDateTimes = freezed,}) {
  return _then(_NavitiaSection(
type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,displayInformation: freezed == displayInformation ? _self.displayInformation : displayInformation // ignore: cast_nullable_to_non_nullable
as NavitiaDisplayInfo?,departureDateTime: freezed == departureDateTime ? _self.departureDateTime : departureDateTime // ignore: cast_nullable_to_non_nullable
as String?,baseDepartureDateTime: freezed == baseDepartureDateTime ? _self.baseDepartureDateTime : baseDepartureDateTime // ignore: cast_nullable_to_non_nullable
as String?,arrivalDateTime: freezed == arrivalDateTime ? _self.arrivalDateTime : arrivalDateTime // ignore: cast_nullable_to_non_nullable
as String?,dataFreshness: freezed == dataFreshness ? _self.dataFreshness : dataFreshness // ignore: cast_nullable_to_non_nullable
as String?,stopDateTimes: freezed == stopDateTimes ? _self._stopDateTimes : stopDateTimes // ignore: cast_nullable_to_non_nullable
as List<NavitiaStopPoint>?,
  ));
}

/// Create a copy of NavitiaSection
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NavitiaDisplayInfoCopyWith<$Res>? get displayInformation {
    if (_self.displayInformation == null) {
    return null;
  }

  return $NavitiaDisplayInfoCopyWith<$Res>(_self.displayInformation!, (value) {
    return _then(_self.copyWith(displayInformation: value));
  });
}
}


/// @nodoc
mixin _$NavitiaStopPoint {

@JsonKey(name: 'departure_stop_point') NavitiaStopPointDetails? get departureStopPoint;
/// Create a copy of NavitiaStopPoint
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NavitiaStopPointCopyWith<NavitiaStopPoint> get copyWith => _$NavitiaStopPointCopyWithImpl<NavitiaStopPoint>(this as NavitiaStopPoint, _$identity);

  /// Serializes this NavitiaStopPoint to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as NavitiaStopPoint;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NavitiaStopPoint&&(identical(other.departureStopPoint, _this.departureStopPoint) || other.departureStopPoint == _this.departureStopPoint));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as NavitiaStopPoint;
  return Object.hash(runtimeType,_this.departureStopPoint);
}

@override
String toString() {
  final _this = this as NavitiaStopPoint;
  return 'NavitiaStopPoint(departureStopPoint: ${_this.departureStopPoint})';
}


}

/// @nodoc
abstract mixin class $NavitiaStopPointCopyWith<$Res>  {
  factory $NavitiaStopPointCopyWith(NavitiaStopPoint value, $Res Function(NavitiaStopPoint) _then) = _$NavitiaStopPointCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'departure_stop_point') NavitiaStopPointDetails? departureStopPoint
});


$NavitiaStopPointDetailsCopyWith<$Res>? get departureStopPoint;

}
/// @nodoc
class _$NavitiaStopPointCopyWithImpl<$Res>
    implements $NavitiaStopPointCopyWith<$Res> {
  _$NavitiaStopPointCopyWithImpl(this._self, this._then);

  final NavitiaStopPoint _self;
  final $Res Function(NavitiaStopPoint) _then;

/// Create a copy of NavitiaStopPoint
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? departureStopPoint = freezed,}) {
  return _then(NavitiaStopPoint(
departureStopPoint: freezed == departureStopPoint ? _self.departureStopPoint : departureStopPoint // ignore: cast_nullable_to_non_nullable
as NavitiaStopPointDetails?,
  ));
}
/// Create a copy of NavitiaStopPoint
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NavitiaStopPointDetailsCopyWith<$Res>? get departureStopPoint {
    if (_self.departureStopPoint == null) {
    return null;
  }

  return $NavitiaStopPointDetailsCopyWith<$Res>(_self.departureStopPoint!, (value) {
    return _then(_self.copyWith(departureStopPoint: value));
  });
}
}


/// Adds pattern-matching-related methods to [NavitiaStopPoint].
extension NavitiaStopPointPatterns on NavitiaStopPoint {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NavitiaStopPoint value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NavitiaStopPoint() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NavitiaStopPoint value)  $default,){
final _that = this;
switch (_that) {
case _NavitiaStopPoint():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NavitiaStopPoint value)?  $default,){
final _that = this;
switch (_that) {
case _NavitiaStopPoint() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'departure_stop_point')  NavitiaStopPointDetails? departureStopPoint)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NavitiaStopPoint() when $default != null:
return $default(_that.departureStopPoint);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'departure_stop_point')  NavitiaStopPointDetails? departureStopPoint)  $default,) {final _that = this;
switch (_that) {
case _NavitiaStopPoint():
return $default(_that.departureStopPoint);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'departure_stop_point')  NavitiaStopPointDetails? departureStopPoint)?  $default,) {final _that = this;
switch (_that) {
case _NavitiaStopPoint() when $default != null:
return $default(_that.departureStopPoint);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NavitiaStopPoint implements NavitiaStopPoint {
  const _NavitiaStopPoint({@JsonKey(name: 'departure_stop_point') this.departureStopPoint});
  factory _NavitiaStopPoint.fromJson(Map<String, dynamic> json) => _$NavitiaStopPointFromJson(json);

@override@JsonKey(name: 'departure_stop_point') final  NavitiaStopPointDetails? departureStopPoint;

/// Create a copy of NavitiaStopPoint
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NavitiaStopPointCopyWith<_NavitiaStopPoint> get copyWith => __$NavitiaStopPointCopyWithImpl<_NavitiaStopPoint>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NavitiaStopPointToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _NavitiaStopPoint&&(identical(other.departureStopPoint, departureStopPoint) || other.departureStopPoint == departureStopPoint));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,departureStopPoint);
}

@override
String toString() {
    return 'NavitiaStopPoint(departureStopPoint: $departureStopPoint)';
}


}

/// @nodoc
abstract mixin class _$NavitiaStopPointCopyWith<$Res> implements $NavitiaStopPointCopyWith<$Res> {
  factory _$NavitiaStopPointCopyWith(_NavitiaStopPoint value, $Res Function(_NavitiaStopPoint) _then) = __$NavitiaStopPointCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'departure_stop_point') NavitiaStopPointDetails? departureStopPoint
});


@override $NavitiaStopPointDetailsCopyWith<$Res>? get departureStopPoint;

}
/// @nodoc
class __$NavitiaStopPointCopyWithImpl<$Res>
    implements _$NavitiaStopPointCopyWith<$Res> {
  __$NavitiaStopPointCopyWithImpl(this._self, this._then);

  final _NavitiaStopPoint _self;
  final $Res Function(_NavitiaStopPoint) _then;

/// Create a copy of NavitiaStopPoint
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? departureStopPoint = freezed,}) {
  return _then(_NavitiaStopPoint(
departureStopPoint: freezed == departureStopPoint ? _self.departureStopPoint : departureStopPoint // ignore: cast_nullable_to_non_nullable
as NavitiaStopPointDetails?,
  ));
}

/// Create a copy of NavitiaStopPoint
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NavitiaStopPointDetailsCopyWith<$Res>? get departureStopPoint {
    if (_self.departureStopPoint == null) {
    return null;
  }

  return $NavitiaStopPointDetailsCopyWith<$Res>(_self.departureStopPoint!, (value) {
    return _then(_self.copyWith(departureStopPoint: value));
  });
}
}


/// @nodoc
mixin _$NavitiaStopPointDetails {

 String? get platform;
/// Create a copy of NavitiaStopPointDetails
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NavitiaStopPointDetailsCopyWith<NavitiaStopPointDetails> get copyWith => _$NavitiaStopPointDetailsCopyWithImpl<NavitiaStopPointDetails>(this as NavitiaStopPointDetails, _$identity);

  /// Serializes this NavitiaStopPointDetails to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as NavitiaStopPointDetails;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NavitiaStopPointDetails&&(identical(other.platform, _this.platform) || other.platform == _this.platform));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as NavitiaStopPointDetails;
  return Object.hash(runtimeType,_this.platform);
}

@override
String toString() {
  final _this = this as NavitiaStopPointDetails;
  return 'NavitiaStopPointDetails(platform: ${_this.platform})';
}


}

/// @nodoc
abstract mixin class $NavitiaStopPointDetailsCopyWith<$Res>  {
  factory $NavitiaStopPointDetailsCopyWith(NavitiaStopPointDetails value, $Res Function(NavitiaStopPointDetails) _then) = _$NavitiaStopPointDetailsCopyWithImpl;
@useResult
$Res call({
 String? platform
});




}
/// @nodoc
class _$NavitiaStopPointDetailsCopyWithImpl<$Res>
    implements $NavitiaStopPointDetailsCopyWith<$Res> {
  _$NavitiaStopPointDetailsCopyWithImpl(this._self, this._then);

  final NavitiaStopPointDetails _self;
  final $Res Function(NavitiaStopPointDetails) _then;

/// Create a copy of NavitiaStopPointDetails
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? platform = freezed,}) {
  return _then(NavitiaStopPointDetails(
platform: freezed == platform ? _self.platform : platform // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [NavitiaStopPointDetails].
extension NavitiaStopPointDetailsPatterns on NavitiaStopPointDetails {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NavitiaStopPointDetails value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NavitiaStopPointDetails() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NavitiaStopPointDetails value)  $default,){
final _that = this;
switch (_that) {
case _NavitiaStopPointDetails():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NavitiaStopPointDetails value)?  $default,){
final _that = this;
switch (_that) {
case _NavitiaStopPointDetails() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? platform)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NavitiaStopPointDetails() when $default != null:
return $default(_that.platform);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? platform)  $default,) {final _that = this;
switch (_that) {
case _NavitiaStopPointDetails():
return $default(_that.platform);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? platform)?  $default,) {final _that = this;
switch (_that) {
case _NavitiaStopPointDetails() when $default != null:
return $default(_that.platform);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NavitiaStopPointDetails implements NavitiaStopPointDetails {
  const _NavitiaStopPointDetails({this.platform});
  factory _NavitiaStopPointDetails.fromJson(Map<String, dynamic> json) => _$NavitiaStopPointDetailsFromJson(json);

@override final  String? platform;

/// Create a copy of NavitiaStopPointDetails
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NavitiaStopPointDetailsCopyWith<_NavitiaStopPointDetails> get copyWith => __$NavitiaStopPointDetailsCopyWithImpl<_NavitiaStopPointDetails>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NavitiaStopPointDetailsToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _NavitiaStopPointDetails&&(identical(other.platform, platform) || other.platform == platform));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,platform);
}

@override
String toString() {
    return 'NavitiaStopPointDetails(platform: $platform)';
}


}

/// @nodoc
abstract mixin class _$NavitiaStopPointDetailsCopyWith<$Res> implements $NavitiaStopPointDetailsCopyWith<$Res> {
  factory _$NavitiaStopPointDetailsCopyWith(_NavitiaStopPointDetails value, $Res Function(_NavitiaStopPointDetails) _then) = __$NavitiaStopPointDetailsCopyWithImpl;
@override @useResult
$Res call({
 String? platform
});




}
/// @nodoc
class __$NavitiaStopPointDetailsCopyWithImpl<$Res>
    implements _$NavitiaStopPointDetailsCopyWith<$Res> {
  __$NavitiaStopPointDetailsCopyWithImpl(this._self, this._then);

  final _NavitiaStopPointDetails _self;
  final $Res Function(_NavitiaStopPointDetails) _then;

/// Create a copy of NavitiaStopPointDetails
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? platform = freezed,}) {
  return _then(_NavitiaStopPointDetails(
platform: freezed == platform ? _self.platform : platform // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$NavitiaPlace {

 String? get id; String? get name;@JsonKey(name: 'embedded_type') String? get embeddedType;@JsonKey(name: 'stop_area') NavitiaStopArea? get stopArea;
/// Create a copy of NavitiaPlace
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NavitiaPlaceCopyWith<NavitiaPlace> get copyWith => _$NavitiaPlaceCopyWithImpl<NavitiaPlace>(this as NavitiaPlace, _$identity);

  /// Serializes this NavitiaPlace to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as NavitiaPlace;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NavitiaPlace&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.embeddedType, _this.embeddedType) || other.embeddedType == _this.embeddedType)&&(identical(other.stopArea, _this.stopArea) || other.stopArea == _this.stopArea));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as NavitiaPlace;
  return Object.hash(runtimeType,_this.id,_this.name,_this.embeddedType,_this.stopArea);
}

@override
String toString() {
  final _this = this as NavitiaPlace;
  return 'NavitiaPlace(id: ${_this.id}, name: ${_this.name}, embeddedType: ${_this.embeddedType}, stopArea: ${_this.stopArea})';
}


}

/// @nodoc
abstract mixin class $NavitiaPlaceCopyWith<$Res>  {
  factory $NavitiaPlaceCopyWith(NavitiaPlace value, $Res Function(NavitiaPlace) _then) = _$NavitiaPlaceCopyWithImpl;
@useResult
$Res call({
 String? id, String? name,@JsonKey(name: 'embedded_type') String? embeddedType,@JsonKey(name: 'stop_area') NavitiaStopArea? stopArea
});


$NavitiaStopAreaCopyWith<$Res>? get stopArea;

}
/// @nodoc
class _$NavitiaPlaceCopyWithImpl<$Res>
    implements $NavitiaPlaceCopyWith<$Res> {
  _$NavitiaPlaceCopyWithImpl(this._self, this._then);

  final NavitiaPlace _self;
  final $Res Function(NavitiaPlace) _then;

/// Create a copy of NavitiaPlace
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? name = freezed,Object? embeddedType = freezed,Object? stopArea = freezed,}) {
  return _then(NavitiaPlace(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,embeddedType: freezed == embeddedType ? _self.embeddedType : embeddedType // ignore: cast_nullable_to_non_nullable
as String?,stopArea: freezed == stopArea ? _self.stopArea : stopArea // ignore: cast_nullable_to_non_nullable
as NavitiaStopArea?,
  ));
}
/// Create a copy of NavitiaPlace
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NavitiaStopAreaCopyWith<$Res>? get stopArea {
    if (_self.stopArea == null) {
    return null;
  }

  return $NavitiaStopAreaCopyWith<$Res>(_self.stopArea!, (value) {
    return _then(_self.copyWith(stopArea: value));
  });
}
}


/// Adds pattern-matching-related methods to [NavitiaPlace].
extension NavitiaPlacePatterns on NavitiaPlace {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NavitiaPlace value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NavitiaPlace() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NavitiaPlace value)  $default,){
final _that = this;
switch (_that) {
case _NavitiaPlace():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NavitiaPlace value)?  $default,){
final _that = this;
switch (_that) {
case _NavitiaPlace() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id,  String? name, @JsonKey(name: 'embedded_type')  String? embeddedType, @JsonKey(name: 'stop_area')  NavitiaStopArea? stopArea)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NavitiaPlace() when $default != null:
return $default(_that.id,_that.name,_that.embeddedType,_that.stopArea);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id,  String? name, @JsonKey(name: 'embedded_type')  String? embeddedType, @JsonKey(name: 'stop_area')  NavitiaStopArea? stopArea)  $default,) {final _that = this;
switch (_that) {
case _NavitiaPlace():
return $default(_that.id,_that.name,_that.embeddedType,_that.stopArea);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id,  String? name, @JsonKey(name: 'embedded_type')  String? embeddedType, @JsonKey(name: 'stop_area')  NavitiaStopArea? stopArea)?  $default,) {final _that = this;
switch (_that) {
case _NavitiaPlace() when $default != null:
return $default(_that.id,_that.name,_that.embeddedType,_that.stopArea);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NavitiaPlace implements NavitiaPlace {
  const _NavitiaPlace({this.id, this.name, @JsonKey(name: 'embedded_type') this.embeddedType, @JsonKey(name: 'stop_area') this.stopArea});
  factory _NavitiaPlace.fromJson(Map<String, dynamic> json) => _$NavitiaPlaceFromJson(json);

@override final  String? id;
@override final  String? name;
@override@JsonKey(name: 'embedded_type') final  String? embeddedType;
@override@JsonKey(name: 'stop_area') final  NavitiaStopArea? stopArea;

/// Create a copy of NavitiaPlace
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NavitiaPlaceCopyWith<_NavitiaPlace> get copyWith => __$NavitiaPlaceCopyWithImpl<_NavitiaPlace>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NavitiaPlaceToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _NavitiaPlace&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.embeddedType, embeddedType) || other.embeddedType == embeddedType)&&(identical(other.stopArea, stopArea) || other.stopArea == stopArea));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,embeddedType,stopArea);
}

@override
String toString() {
    return 'NavitiaPlace(id: $id, name: $name, embeddedType: $embeddedType, stopArea: $stopArea)';
}


}

/// @nodoc
abstract mixin class _$NavitiaPlaceCopyWith<$Res> implements $NavitiaPlaceCopyWith<$Res> {
  factory _$NavitiaPlaceCopyWith(_NavitiaPlace value, $Res Function(_NavitiaPlace) _then) = __$NavitiaPlaceCopyWithImpl;
@override @useResult
$Res call({
 String? id, String? name,@JsonKey(name: 'embedded_type') String? embeddedType,@JsonKey(name: 'stop_area') NavitiaStopArea? stopArea
});


@override $NavitiaStopAreaCopyWith<$Res>? get stopArea;

}
/// @nodoc
class __$NavitiaPlaceCopyWithImpl<$Res>
    implements _$NavitiaPlaceCopyWith<$Res> {
  __$NavitiaPlaceCopyWithImpl(this._self, this._then);

  final _NavitiaPlace _self;
  final $Res Function(_NavitiaPlace) _then;

/// Create a copy of NavitiaPlace
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? name = freezed,Object? embeddedType = freezed,Object? stopArea = freezed,}) {
  return _then(_NavitiaPlace(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,embeddedType: freezed == embeddedType ? _self.embeddedType : embeddedType // ignore: cast_nullable_to_non_nullable
as String?,stopArea: freezed == stopArea ? _self.stopArea : stopArea // ignore: cast_nullable_to_non_nullable
as NavitiaStopArea?,
  ));
}

/// Create a copy of NavitiaPlace
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NavitiaStopAreaCopyWith<$Res>? get stopArea {
    if (_self.stopArea == null) {
    return null;
  }

  return $NavitiaStopAreaCopyWith<$Res>(_self.stopArea!, (value) {
    return _then(_self.copyWith(stopArea: value));
  });
}
}


/// @nodoc
mixin _$NavitiaStopArea {

 String get id; String get name;
/// Create a copy of NavitiaStopArea
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NavitiaStopAreaCopyWith<NavitiaStopArea> get copyWith => _$NavitiaStopAreaCopyWithImpl<NavitiaStopArea>(this as NavitiaStopArea, _$identity);

  /// Serializes this NavitiaStopArea to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as NavitiaStopArea;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NavitiaStopArea&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as NavitiaStopArea;
  return Object.hash(runtimeType,_this.id,_this.name);
}

@override
String toString() {
  final _this = this as NavitiaStopArea;
  return 'NavitiaStopArea(id: ${_this.id}, name: ${_this.name})';
}


}

/// @nodoc
abstract mixin class $NavitiaStopAreaCopyWith<$Res>  {
  factory $NavitiaStopAreaCopyWith(NavitiaStopArea value, $Res Function(NavitiaStopArea) _then) = _$NavitiaStopAreaCopyWithImpl;
@useResult
$Res call({
 String id, String name
});




}
/// @nodoc
class _$NavitiaStopAreaCopyWithImpl<$Res>
    implements $NavitiaStopAreaCopyWith<$Res> {
  _$NavitiaStopAreaCopyWithImpl(this._self, this._then);

  final NavitiaStopArea _self;
  final $Res Function(NavitiaStopArea) _then;

/// Create a copy of NavitiaStopArea
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,}) {
  return _then(NavitiaStopArea(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [NavitiaStopArea].
extension NavitiaStopAreaPatterns on NavitiaStopArea {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NavitiaStopArea value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NavitiaStopArea() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NavitiaStopArea value)  $default,){
final _that = this;
switch (_that) {
case _NavitiaStopArea():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NavitiaStopArea value)?  $default,){
final _that = this;
switch (_that) {
case _NavitiaStopArea() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NavitiaStopArea() when $default != null:
return $default(_that.id,_that.name);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name)  $default,) {final _that = this;
switch (_that) {
case _NavitiaStopArea():
return $default(_that.id,_that.name);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name)?  $default,) {final _that = this;
switch (_that) {
case _NavitiaStopArea() when $default != null:
return $default(_that.id,_that.name);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NavitiaStopArea implements NavitiaStopArea {
  const _NavitiaStopArea({required this.id, required this.name});
  factory _NavitiaStopArea.fromJson(Map<String, dynamic> json) => _$NavitiaStopAreaFromJson(json);

@override final  String id;
@override final  String name;

/// Create a copy of NavitiaStopArea
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NavitiaStopAreaCopyWith<_NavitiaStopArea> get copyWith => __$NavitiaStopAreaCopyWithImpl<_NavitiaStopArea>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NavitiaStopAreaToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _NavitiaStopArea&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name);
}

@override
String toString() {
    return 'NavitiaStopArea(id: $id, name: $name)';
}


}

/// @nodoc
abstract mixin class _$NavitiaStopAreaCopyWith<$Res> implements $NavitiaStopAreaCopyWith<$Res> {
  factory _$NavitiaStopAreaCopyWith(_NavitiaStopArea value, $Res Function(_NavitiaStopArea) _then) = __$NavitiaStopAreaCopyWithImpl;
@override @useResult
$Res call({
 String id, String name
});




}
/// @nodoc
class __$NavitiaStopAreaCopyWithImpl<$Res>
    implements _$NavitiaStopAreaCopyWith<$Res> {
  __$NavitiaStopAreaCopyWithImpl(this._self, this._then);

  final _NavitiaStopArea _self;
  final $Res Function(_NavitiaStopArea) _then;

/// Create a copy of NavitiaStopArea
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,}) {
  return _then(_NavitiaStopArea(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
