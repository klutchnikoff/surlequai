// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'timetable_version.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TimetableVersion {

 String get version; String get region; DateTime get validFrom; DateTime get validUntil; DateTime get downloadedAt; int? get sizeBytes;
/// Create a copy of TimetableVersion
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TimetableVersionCopyWith<TimetableVersion> get copyWith => _$TimetableVersionCopyWithImpl<TimetableVersion>(this as TimetableVersion, _$identity);

  /// Serializes this TimetableVersion to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TimetableVersion;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TimetableVersion&&(identical(other.version, _this.version) || other.version == _this.version)&&(identical(other.region, _this.region) || other.region == _this.region)&&(identical(other.validFrom, _this.validFrom) || other.validFrom == _this.validFrom)&&(identical(other.validUntil, _this.validUntil) || other.validUntil == _this.validUntil)&&(identical(other.downloadedAt, _this.downloadedAt) || other.downloadedAt == _this.downloadedAt)&&(identical(other.sizeBytes, _this.sizeBytes) || other.sizeBytes == _this.sizeBytes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TimetableVersion;
  return Object.hash(runtimeType,_this.version,_this.region,_this.validFrom,_this.validUntil,_this.downloadedAt,_this.sizeBytes);
}

@override
String toString() {
  final _this = this as TimetableVersion;
  return 'TimetableVersion(version: ${_this.version}, region: ${_this.region}, validFrom: ${_this.validFrom}, validUntil: ${_this.validUntil}, downloadedAt: ${_this.downloadedAt}, sizeBytes: ${_this.sizeBytes})';
}


}

/// @nodoc
abstract mixin class $TimetableVersionCopyWith<$Res>  {
  factory $TimetableVersionCopyWith(TimetableVersion value, $Res Function(TimetableVersion) _then) = _$TimetableVersionCopyWithImpl;
@useResult
$Res call({
 String version, String region, DateTime validFrom, DateTime validUntil, DateTime downloadedAt, int? sizeBytes
});




}
/// @nodoc
class _$TimetableVersionCopyWithImpl<$Res>
    implements $TimetableVersionCopyWith<$Res> {
  _$TimetableVersionCopyWithImpl(this._self, this._then);

  final TimetableVersion _self;
  final $Res Function(TimetableVersion) _then;

/// Create a copy of TimetableVersion
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? version = null,Object? region = null,Object? validFrom = null,Object? validUntil = null,Object? downloadedAt = null,Object? sizeBytes = freezed,}) {
  return _then(TimetableVersion(
version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String,region: null == region ? _self.region : region // ignore: cast_nullable_to_non_nullable
as String,validFrom: null == validFrom ? _self.validFrom : validFrom // ignore: cast_nullable_to_non_nullable
as DateTime,validUntil: null == validUntil ? _self.validUntil : validUntil // ignore: cast_nullable_to_non_nullable
as DateTime,downloadedAt: null == downloadedAt ? _self.downloadedAt : downloadedAt // ignore: cast_nullable_to_non_nullable
as DateTime,sizeBytes: freezed == sizeBytes ? _self.sizeBytes : sizeBytes // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [TimetableVersion].
extension TimetableVersionPatterns on TimetableVersion {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TimetableVersion value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TimetableVersion() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TimetableVersion value)  $default,){
final _that = this;
switch (_that) {
case _TimetableVersion():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TimetableVersion value)?  $default,){
final _that = this;
switch (_that) {
case _TimetableVersion() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String version,  String region,  DateTime validFrom,  DateTime validUntil,  DateTime downloadedAt,  int? sizeBytes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TimetableVersion() when $default != null:
return $default(_that.version,_that.region,_that.validFrom,_that.validUntil,_that.downloadedAt,_that.sizeBytes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String version,  String region,  DateTime validFrom,  DateTime validUntil,  DateTime downloadedAt,  int? sizeBytes)  $default,) {final _that = this;
switch (_that) {
case _TimetableVersion():
return $default(_that.version,_that.region,_that.validFrom,_that.validUntil,_that.downloadedAt,_that.sizeBytes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String version,  String region,  DateTime validFrom,  DateTime validUntil,  DateTime downloadedAt,  int? sizeBytes)?  $default,) {final _that = this;
switch (_that) {
case _TimetableVersion() when $default != null:
return $default(_that.version,_that.region,_that.validFrom,_that.validUntil,_that.downloadedAt,_that.sizeBytes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TimetableVersion implements TimetableVersion {
  const _TimetableVersion({required this.version, required this.region, required this.validFrom, required this.validUntil, required this.downloadedAt, this.sizeBytes});
  factory _TimetableVersion.fromJson(Map<String, dynamic> json) => _$TimetableVersionFromJson(json);

@override final  String version;
@override final  String region;
@override final  DateTime validFrom;
@override final  DateTime validUntil;
@override final  DateTime downloadedAt;
@override final  int? sizeBytes;

/// Create a copy of TimetableVersion
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TimetableVersionCopyWith<_TimetableVersion> get copyWith => __$TimetableVersionCopyWithImpl<_TimetableVersion>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TimetableVersionToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TimetableVersion&&(identical(other.version, version) || other.version == version)&&(identical(other.region, region) || other.region == region)&&(identical(other.validFrom, validFrom) || other.validFrom == validFrom)&&(identical(other.validUntil, validUntil) || other.validUntil == validUntil)&&(identical(other.downloadedAt, downloadedAt) || other.downloadedAt == downloadedAt)&&(identical(other.sizeBytes, sizeBytes) || other.sizeBytes == sizeBytes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,version,region,validFrom,validUntil,downloadedAt,sizeBytes);
}

@override
String toString() {
    return 'TimetableVersion(version: $version, region: $region, validFrom: $validFrom, validUntil: $validUntil, downloadedAt: $downloadedAt, sizeBytes: $sizeBytes)';
}


}

/// @nodoc
abstract mixin class _$TimetableVersionCopyWith<$Res> implements $TimetableVersionCopyWith<$Res> {
  factory _$TimetableVersionCopyWith(_TimetableVersion value, $Res Function(_TimetableVersion) _then) = __$TimetableVersionCopyWithImpl;
@override @useResult
$Res call({
 String version, String region, DateTime validFrom, DateTime validUntil, DateTime downloadedAt, int? sizeBytes
});




}
/// @nodoc
class __$TimetableVersionCopyWithImpl<$Res>
    implements _$TimetableVersionCopyWith<$Res> {
  __$TimetableVersionCopyWithImpl(this._self, this._then);

  final _TimetableVersion _self;
  final $Res Function(_TimetableVersion) _then;

/// Create a copy of TimetableVersion
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? version = null,Object? region = null,Object? validFrom = null,Object? validUntil = null,Object? downloadedAt = null,Object? sizeBytes = freezed,}) {
  return _then(_TimetableVersion(
version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String,region: null == region ? _self.region : region // ignore: cast_nullable_to_non_nullable
as String,validFrom: null == validFrom ? _self.validFrom : validFrom // ignore: cast_nullable_to_non_nullable
as DateTime,validUntil: null == validUntil ? _self.validUntil : validUntil // ignore: cast_nullable_to_non_nullable
as DateTime,downloadedAt: null == downloadedAt ? _self.downloadedAt : downloadedAt // ignore: cast_nullable_to_non_nullable
as DateTime,sizeBytes: freezed == sizeBytes ? _self.sizeBytes : sizeBytes // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
