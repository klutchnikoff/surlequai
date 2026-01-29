// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'departure.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Departure _$DepartureFromJson(Map<String, dynamic> json) {
  return _Departure.fromJson(json);
}

/// @nodoc
mixin _$Departure {
  String get id => throw _privateConstructorUsedError;
  DateTime get scheduledTime => throw _privateConstructorUsedError;
  String get platform => throw _privateConstructorUsedError;
  DepartureStatus get status => throw _privateConstructorUsedError;
  int get delayMinutes => throw _privateConstructorUsedError;
  int? get durationMinutes => throw _privateConstructorUsedError;

  /// Serializes this Departure to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Departure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DepartureCopyWith<Departure> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DepartureCopyWith<$Res> {
  factory $DepartureCopyWith(Departure value, $Res Function(Departure) then) =
      _$DepartureCopyWithImpl<$Res, Departure>;
  @useResult
  $Res call(
      {String id,
      DateTime scheduledTime,
      String platform,
      DepartureStatus status,
      int delayMinutes,
      int? durationMinutes});
}

/// @nodoc
class _$DepartureCopyWithImpl<$Res, $Val extends Departure>
    implements $DepartureCopyWith<$Res> {
  _$DepartureCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Departure
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? scheduledTime = null,
    Object? platform = null,
    Object? status = null,
    Object? delayMinutes = null,
    Object? durationMinutes = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      scheduledTime: null == scheduledTime
          ? _value.scheduledTime
          : scheduledTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      platform: null == platform
          ? _value.platform
          : platform // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as DepartureStatus,
      delayMinutes: null == delayMinutes
          ? _value.delayMinutes
          : delayMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      durationMinutes: freezed == durationMinutes
          ? _value.durationMinutes
          : durationMinutes // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DepartureImplCopyWith<$Res>
    implements $DepartureCopyWith<$Res> {
  factory _$$DepartureImplCopyWith(
          _$DepartureImpl value, $Res Function(_$DepartureImpl) then) =
      __$$DepartureImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      DateTime scheduledTime,
      String platform,
      DepartureStatus status,
      int delayMinutes,
      int? durationMinutes});
}

/// @nodoc
class __$$DepartureImplCopyWithImpl<$Res>
    extends _$DepartureCopyWithImpl<$Res, _$DepartureImpl>
    implements _$$DepartureImplCopyWith<$Res> {
  __$$DepartureImplCopyWithImpl(
      _$DepartureImpl _value, $Res Function(_$DepartureImpl) _then)
      : super(_value, _then);

  /// Create a copy of Departure
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? scheduledTime = null,
    Object? platform = null,
    Object? status = null,
    Object? delayMinutes = null,
    Object? durationMinutes = freezed,
  }) {
    return _then(_$DepartureImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      scheduledTime: null == scheduledTime
          ? _value.scheduledTime
          : scheduledTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      platform: null == platform
          ? _value.platform
          : platform // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as DepartureStatus,
      delayMinutes: null == delayMinutes
          ? _value.delayMinutes
          : delayMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      durationMinutes: freezed == durationMinutes
          ? _value.durationMinutes
          : durationMinutes // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DepartureImpl implements _Departure {
  const _$DepartureImpl(
      {required this.id,
      required this.scheduledTime,
      required this.platform,
      this.status = DepartureStatus.offline,
      this.delayMinutes = 0,
      this.durationMinutes});

  factory _$DepartureImpl.fromJson(Map<String, dynamic> json) =>
      _$$DepartureImplFromJson(json);

  @override
  final String id;
  @override
  final DateTime scheduledTime;
  @override
  final String platform;
  @override
  @JsonKey()
  final DepartureStatus status;
  @override
  @JsonKey()
  final int delayMinutes;
  @override
  final int? durationMinutes;

  @override
  String toString() {
    return 'Departure(id: $id, scheduledTime: $scheduledTime, platform: $platform, status: $status, delayMinutes: $delayMinutes, durationMinutes: $durationMinutes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DepartureImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.scheduledTime, scheduledTime) ||
                other.scheduledTime == scheduledTime) &&
            (identical(other.platform, platform) ||
                other.platform == platform) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.delayMinutes, delayMinutes) ||
                other.delayMinutes == delayMinutes) &&
            (identical(other.durationMinutes, durationMinutes) ||
                other.durationMinutes == durationMinutes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, scheduledTime, platform,
      status, delayMinutes, durationMinutes);

  /// Create a copy of Departure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DepartureImplCopyWith<_$DepartureImpl> get copyWith =>
      __$$DepartureImplCopyWithImpl<_$DepartureImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DepartureImplToJson(
      this,
    );
  }
}

abstract class _Departure implements Departure {
  const factory _Departure(
      {required final String id,
      required final DateTime scheduledTime,
      required final String platform,
      final DepartureStatus status,
      final int delayMinutes,
      final int? durationMinutes}) = _$DepartureImpl;

  factory _Departure.fromJson(Map<String, dynamic> json) =
      _$DepartureImpl.fromJson;

  @override
  String get id;
  @override
  DateTime get scheduledTime;
  @override
  String get platform;
  @override
  DepartureStatus get status;
  @override
  int get delayMinutes;
  @override
  int? get durationMinutes;

  /// Create a copy of Departure
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DepartureImplCopyWith<_$DepartureImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
