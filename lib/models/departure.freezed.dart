// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'departure.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Departure {

 String get id; DateTime get scheduledTime; String get platform; DepartureStatus get status; int get delayMinutes; int? get durationMinutes;
/// Create a copy of Departure
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DepartureCopyWith<Departure> get copyWith => _$DepartureCopyWithImpl<Departure>(this as Departure, _$identity);

  /// Serializes this Departure to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Departure;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Departure&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.scheduledTime, _this.scheduledTime) || other.scheduledTime == _this.scheduledTime)&&(identical(other.platform, _this.platform) || other.platform == _this.platform)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.delayMinutes, _this.delayMinutes) || other.delayMinutes == _this.delayMinutes)&&(identical(other.durationMinutes, _this.durationMinutes) || other.durationMinutes == _this.durationMinutes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Departure;
  return Object.hash(runtimeType,_this.id,_this.scheduledTime,_this.platform,_this.status,_this.delayMinutes,_this.durationMinutes);
}

@override
String toString() {
  final _this = this as Departure;
  return 'Departure(id: ${_this.id}, scheduledTime: ${_this.scheduledTime}, platform: ${_this.platform}, status: ${_this.status}, delayMinutes: ${_this.delayMinutes}, durationMinutes: ${_this.durationMinutes})';
}


}

/// @nodoc
abstract mixin class $DepartureCopyWith<$Res>  {
  factory $DepartureCopyWith(Departure value, $Res Function(Departure) _then) = _$DepartureCopyWithImpl;
@useResult
$Res call({
 String id, DateTime scheduledTime, String platform, DepartureStatus status, int delayMinutes, int? durationMinutes
});




}
/// @nodoc
class _$DepartureCopyWithImpl<$Res>
    implements $DepartureCopyWith<$Res> {
  _$DepartureCopyWithImpl(this._self, this._then);

  final Departure _self;
  final $Res Function(Departure) _then;

/// Create a copy of Departure
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? scheduledTime = null,Object? platform = null,Object? status = null,Object? delayMinutes = null,Object? durationMinutes = freezed,}) {
  return _then(Departure(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,scheduledTime: null == scheduledTime ? _self.scheduledTime : scheduledTime // ignore: cast_nullable_to_non_nullable
as DateTime,platform: null == platform ? _self.platform : platform // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as DepartureStatus,delayMinutes: null == delayMinutes ? _self.delayMinutes : delayMinutes // ignore: cast_nullable_to_non_nullable
as int,durationMinutes: freezed == durationMinutes ? _self.durationMinutes : durationMinutes // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [Departure].
extension DeparturePatterns on Departure {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Departure value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Departure() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Departure value)  $default,){
final _that = this;
switch (_that) {
case _Departure():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Departure value)?  $default,){
final _that = this;
switch (_that) {
case _Departure() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  DateTime scheduledTime,  String platform,  DepartureStatus status,  int delayMinutes,  int? durationMinutes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Departure() when $default != null:
return $default(_that.id,_that.scheduledTime,_that.platform,_that.status,_that.delayMinutes,_that.durationMinutes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  DateTime scheduledTime,  String platform,  DepartureStatus status,  int delayMinutes,  int? durationMinutes)  $default,) {final _that = this;
switch (_that) {
case _Departure():
return $default(_that.id,_that.scheduledTime,_that.platform,_that.status,_that.delayMinutes,_that.durationMinutes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  DateTime scheduledTime,  String platform,  DepartureStatus status,  int delayMinutes,  int? durationMinutes)?  $default,) {final _that = this;
switch (_that) {
case _Departure() when $default != null:
return $default(_that.id,_that.scheduledTime,_that.platform,_that.status,_that.delayMinutes,_that.durationMinutes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Departure extends Departure {
  const _Departure({required this.id, required this.scheduledTime, required this.platform, this.status = DepartureStatus.offline, this.delayMinutes = 0, this.durationMinutes}): super._();
  factory _Departure.fromJson(Map<String, dynamic> json) => _$DepartureFromJson(json);

@override final  String id;
@override final  DateTime scheduledTime;
@override final  String platform;
@override@JsonKey() final  DepartureStatus status;
@override@JsonKey() final  int delayMinutes;
@override final  int? durationMinutes;

/// Create a copy of Departure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DepartureCopyWith<_Departure> get copyWith => __$DepartureCopyWithImpl<_Departure>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DepartureToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Departure&&(identical(other.id, id) || other.id == id)&&(identical(other.scheduledTime, scheduledTime) || other.scheduledTime == scheduledTime)&&(identical(other.platform, platform) || other.platform == platform)&&(identical(other.status, status) || other.status == status)&&(identical(other.delayMinutes, delayMinutes) || other.delayMinutes == delayMinutes)&&(identical(other.durationMinutes, durationMinutes) || other.durationMinutes == durationMinutes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,scheduledTime,platform,status,delayMinutes,durationMinutes);
}

@override
String toString() {
    return 'Departure(id: $id, scheduledTime: $scheduledTime, platform: $platform, status: $status, delayMinutes: $delayMinutes, durationMinutes: $durationMinutes)';
}


}

/// @nodoc
abstract mixin class _$DepartureCopyWith<$Res> implements $DepartureCopyWith<$Res> {
  factory _$DepartureCopyWith(_Departure value, $Res Function(_Departure) _then) = __$DepartureCopyWithImpl;
@override @useResult
$Res call({
 String id, DateTime scheduledTime, String platform, DepartureStatus status, int delayMinutes, int? durationMinutes
});




}
/// @nodoc
class __$DepartureCopyWithImpl<$Res>
    implements _$DepartureCopyWith<$Res> {
  __$DepartureCopyWithImpl(this._self, this._then);

  final _Departure _self;
  final $Res Function(_Departure) _then;

/// Create a copy of Departure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? scheduledTime = null,Object? platform = null,Object? status = null,Object? delayMinutes = null,Object? durationMinutes = freezed,}) {
  return _then(_Departure(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,scheduledTime: null == scheduledTime ? _self.scheduledTime : scheduledTime // ignore: cast_nullable_to_non_nullable
as DateTime,platform: null == platform ? _self.platform : platform // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as DepartureStatus,delayMinutes: null == delayMinutes ? _self.delayMinutes : delayMinutes // ignore: cast_nullable_to_non_nullable
as int,durationMinutes: freezed == durationMinutes ? _self.durationMinutes : durationMinutes // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
