// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'timetable_version.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TimetableVersion _$TimetableVersionFromJson(Map<String, dynamic> json) {
  return _TimetableVersion.fromJson(json);
}

/// @nodoc
mixin _$TimetableVersion {
  String get version => throw _privateConstructorUsedError;
  String get region => throw _privateConstructorUsedError;
  DateTime get validFrom => throw _privateConstructorUsedError;
  DateTime get validUntil => throw _privateConstructorUsedError;
  DateTime get downloadedAt => throw _privateConstructorUsedError;
  int? get sizeBytes => throw _privateConstructorUsedError;

  /// Serializes this TimetableVersion to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TimetableVersion
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TimetableVersionCopyWith<TimetableVersion> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TimetableVersionCopyWith<$Res> {
  factory $TimetableVersionCopyWith(
          TimetableVersion value, $Res Function(TimetableVersion) then) =
      _$TimetableVersionCopyWithImpl<$Res, TimetableVersion>;
  @useResult
  $Res call(
      {String version,
      String region,
      DateTime validFrom,
      DateTime validUntil,
      DateTime downloadedAt,
      int? sizeBytes});
}

/// @nodoc
class _$TimetableVersionCopyWithImpl<$Res, $Val extends TimetableVersion>
    implements $TimetableVersionCopyWith<$Res> {
  _$TimetableVersionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TimetableVersion
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? version = null,
    Object? region = null,
    Object? validFrom = null,
    Object? validUntil = null,
    Object? downloadedAt = null,
    Object? sizeBytes = freezed,
  }) {
    return _then(_value.copyWith(
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as String,
      region: null == region
          ? _value.region
          : region // ignore: cast_nullable_to_non_nullable
              as String,
      validFrom: null == validFrom
          ? _value.validFrom
          : validFrom // ignore: cast_nullable_to_non_nullable
              as DateTime,
      validUntil: null == validUntil
          ? _value.validUntil
          : validUntil // ignore: cast_nullable_to_non_nullable
              as DateTime,
      downloadedAt: null == downloadedAt
          ? _value.downloadedAt
          : downloadedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      sizeBytes: freezed == sizeBytes
          ? _value.sizeBytes
          : sizeBytes // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TimetableVersionImplCopyWith<$Res>
    implements $TimetableVersionCopyWith<$Res> {
  factory _$$TimetableVersionImplCopyWith(_$TimetableVersionImpl value,
          $Res Function(_$TimetableVersionImpl) then) =
      __$$TimetableVersionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String version,
      String region,
      DateTime validFrom,
      DateTime validUntil,
      DateTime downloadedAt,
      int? sizeBytes});
}

/// @nodoc
class __$$TimetableVersionImplCopyWithImpl<$Res>
    extends _$TimetableVersionCopyWithImpl<$Res, _$TimetableVersionImpl>
    implements _$$TimetableVersionImplCopyWith<$Res> {
  __$$TimetableVersionImplCopyWithImpl(_$TimetableVersionImpl _value,
      $Res Function(_$TimetableVersionImpl) _then)
      : super(_value, _then);

  /// Create a copy of TimetableVersion
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? version = null,
    Object? region = null,
    Object? validFrom = null,
    Object? validUntil = null,
    Object? downloadedAt = null,
    Object? sizeBytes = freezed,
  }) {
    return _then(_$TimetableVersionImpl(
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as String,
      region: null == region
          ? _value.region
          : region // ignore: cast_nullable_to_non_nullable
              as String,
      validFrom: null == validFrom
          ? _value.validFrom
          : validFrom // ignore: cast_nullable_to_non_nullable
              as DateTime,
      validUntil: null == validUntil
          ? _value.validUntil
          : validUntil // ignore: cast_nullable_to_non_nullable
              as DateTime,
      downloadedAt: null == downloadedAt
          ? _value.downloadedAt
          : downloadedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      sizeBytes: freezed == sizeBytes
          ? _value.sizeBytes
          : sizeBytes // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TimetableVersionImpl implements _TimetableVersion {
  const _$TimetableVersionImpl(
      {required this.version,
      required this.region,
      required this.validFrom,
      required this.validUntil,
      required this.downloadedAt,
      this.sizeBytes});

  factory _$TimetableVersionImpl.fromJson(Map<String, dynamic> json) =>
      _$$TimetableVersionImplFromJson(json);

  @override
  final String version;
  @override
  final String region;
  @override
  final DateTime validFrom;
  @override
  final DateTime validUntil;
  @override
  final DateTime downloadedAt;
  @override
  final int? sizeBytes;

  @override
  String toString() {
    return 'TimetableVersion(version: $version, region: $region, validFrom: $validFrom, validUntil: $validUntil, downloadedAt: $downloadedAt, sizeBytes: $sizeBytes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TimetableVersionImpl &&
            (identical(other.version, version) || other.version == version) &&
            (identical(other.region, region) || other.region == region) &&
            (identical(other.validFrom, validFrom) ||
                other.validFrom == validFrom) &&
            (identical(other.validUntil, validUntil) ||
                other.validUntil == validUntil) &&
            (identical(other.downloadedAt, downloadedAt) ||
                other.downloadedAt == downloadedAt) &&
            (identical(other.sizeBytes, sizeBytes) ||
                other.sizeBytes == sizeBytes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, version, region, validFrom,
      validUntil, downloadedAt, sizeBytes);

  /// Create a copy of TimetableVersion
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TimetableVersionImplCopyWith<_$TimetableVersionImpl> get copyWith =>
      __$$TimetableVersionImplCopyWithImpl<_$TimetableVersionImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TimetableVersionImplToJson(
      this,
    );
  }
}

abstract class _TimetableVersion implements TimetableVersion {
  const factory _TimetableVersion(
      {required final String version,
      required final String region,
      required final DateTime validFrom,
      required final DateTime validUntil,
      required final DateTime downloadedAt,
      final int? sizeBytes}) = _$TimetableVersionImpl;

  factory _TimetableVersion.fromJson(Map<String, dynamic> json) =
      _$TimetableVersionImpl.fromJson;

  @override
  String get version;
  @override
  String get region;
  @override
  DateTime get validFrom;
  @override
  DateTime get validUntil;
  @override
  DateTime get downloadedAt;
  @override
  int? get sizeBytes;

  /// Create a copy of TimetableVersion
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TimetableVersionImplCopyWith<_$TimetableVersionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
