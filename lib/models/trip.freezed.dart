// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'trip.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Trip {

 String get id; Station get stationA; Station get stationB; MorningDirection get morningDirection;
/// Create a copy of Trip
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TripCopyWith<Trip> get copyWith => _$TripCopyWithImpl<Trip>(this as Trip, _$identity);

  /// Serializes this Trip to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Trip;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Trip&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.stationA, _this.stationA) || other.stationA == _this.stationA)&&(identical(other.stationB, _this.stationB) || other.stationB == _this.stationB)&&(identical(other.morningDirection, _this.morningDirection) || other.morningDirection == _this.morningDirection));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Trip;
  return Object.hash(runtimeType,_this.id,_this.stationA,_this.stationB,_this.morningDirection);
}

@override
String toString() {
  final _this = this as Trip;
  return 'Trip(id: ${_this.id}, stationA: ${_this.stationA}, stationB: ${_this.stationB}, morningDirection: ${_this.morningDirection})';
}


}

/// @nodoc
abstract mixin class $TripCopyWith<$Res>  {
  factory $TripCopyWith(Trip value, $Res Function(Trip) _then) = _$TripCopyWithImpl;
@useResult
$Res call({
 String id, Station stationA, Station stationB, MorningDirection morningDirection
});


$StationCopyWith<$Res> get stationA;$StationCopyWith<$Res> get stationB;

}
/// @nodoc
class _$TripCopyWithImpl<$Res>
    implements $TripCopyWith<$Res> {
  _$TripCopyWithImpl(this._self, this._then);

  final Trip _self;
  final $Res Function(Trip) _then;

/// Create a copy of Trip
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? stationA = null,Object? stationB = null,Object? morningDirection = null,}) {
  return _then(Trip(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,stationA: null == stationA ? _self.stationA : stationA // ignore: cast_nullable_to_non_nullable
as Station,stationB: null == stationB ? _self.stationB : stationB // ignore: cast_nullable_to_non_nullable
as Station,morningDirection: null == morningDirection ? _self.morningDirection : morningDirection // ignore: cast_nullable_to_non_nullable
as MorningDirection,
  ));
}
/// Create a copy of Trip
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StationCopyWith<$Res> get stationA {

  return $StationCopyWith<$Res>(_self.stationA, (value) {
    return _then(_self.copyWith(stationA: value));
  });
}/// Create a copy of Trip
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StationCopyWith<$Res> get stationB {

  return $StationCopyWith<$Res>(_self.stationB, (value) {
    return _then(_self.copyWith(stationB: value));
  });
}
}


/// Adds pattern-matching-related methods to [Trip].
extension TripPatterns on Trip {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Trip value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Trip() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Trip value)  $default,){
final _that = this;
switch (_that) {
case _Trip():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Trip value)?  $default,){
final _that = this;
switch (_that) {
case _Trip() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  Station stationA,  Station stationB,  MorningDirection morningDirection)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Trip() when $default != null:
return $default(_that.id,_that.stationA,_that.stationB,_that.morningDirection);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  Station stationA,  Station stationB,  MorningDirection morningDirection)  $default,) {final _that = this;
switch (_that) {
case _Trip():
return $default(_that.id,_that.stationA,_that.stationB,_that.morningDirection);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  Station stationA,  Station stationB,  MorningDirection morningDirection)?  $default,) {final _that = this;
switch (_that) {
case _Trip() when $default != null:
return $default(_that.id,_that.stationA,_that.stationB,_that.morningDirection);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Trip implements Trip {
  const _Trip({required this.id, required this.stationA, required this.stationB, required this.morningDirection});
  factory _Trip.fromJson(Map<String, dynamic> json) => _$TripFromJson(json);

@override final  String id;
@override final  Station stationA;
@override final  Station stationB;
@override final  MorningDirection morningDirection;

/// Create a copy of Trip
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TripCopyWith<_Trip> get copyWith => __$TripCopyWithImpl<_Trip>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TripToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Trip&&(identical(other.id, id) || other.id == id)&&(identical(other.stationA, stationA) || other.stationA == stationA)&&(identical(other.stationB, stationB) || other.stationB == stationB)&&(identical(other.morningDirection, morningDirection) || other.morningDirection == morningDirection));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,stationA,stationB,morningDirection);
}

@override
String toString() {
    return 'Trip(id: $id, stationA: $stationA, stationB: $stationB, morningDirection: $morningDirection)';
}


}

/// @nodoc
abstract mixin class _$TripCopyWith<$Res> implements $TripCopyWith<$Res> {
  factory _$TripCopyWith(_Trip value, $Res Function(_Trip) _then) = __$TripCopyWithImpl;
@override @useResult
$Res call({
 String id, Station stationA, Station stationB, MorningDirection morningDirection
});


@override $StationCopyWith<$Res> get stationA;@override $StationCopyWith<$Res> get stationB;

}
/// @nodoc
class __$TripCopyWithImpl<$Res>
    implements _$TripCopyWith<$Res> {
  __$TripCopyWithImpl(this._self, this._then);

  final _Trip _self;
  final $Res Function(_Trip) _then;

/// Create a copy of Trip
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? stationA = null,Object? stationB = null,Object? morningDirection = null,}) {
  return _then(_Trip(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,stationA: null == stationA ? _self.stationA : stationA // ignore: cast_nullable_to_non_nullable
as Station,stationB: null == stationB ? _self.stationB : stationB // ignore: cast_nullable_to_non_nullable
as Station,morningDirection: null == morningDirection ? _self.morningDirection : morningDirection // ignore: cast_nullable_to_non_nullable
as MorningDirection,
  ));
}

/// Create a copy of Trip
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StationCopyWith<$Res> get stationA {

  return $StationCopyWith<$Res>(_self.stationA, (value) {
    return _then(_self.copyWith(stationA: value));
  });
}/// Create a copy of Trip
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StationCopyWith<$Res> get stationB {

  return $StationCopyWith<$Res>(_self.stationB, (value) {
    return _then(_self.copyWith(stationB: value));
  });
}
}

// dart format on
