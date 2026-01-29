import 'package:freezed_annotation/freezed_annotation.dart';

part 'departure.freezed.dart';
part 'departure.g.dart';

enum DepartureStatus { onTime, delayed, cancelled, offline }

@freezed
class Departure with _$Departure {
  const factory Departure({
    required String id,
    required DateTime scheduledTime,
    required String platform,
    @Default(DepartureStatus.offline) DepartureStatus status,
    @Default(0) int delayMinutes,
    int? durationMinutes,
  }) = _Departure;

  factory Departure.fromJson(Map<String, dynamic> json) => _$DepartureFromJson(json);
}