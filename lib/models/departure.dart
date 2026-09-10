import 'package:freezed_annotation/freezed_annotation.dart';

part 'departure.freezed.dart';
part 'departure.g.dart';

enum DepartureStatus { onTime, delayed, cancelled, offline }

@freezed
abstract class Departure with _$Departure {
  const Departure._();

  /// scheduledTime est toujours l'heure théorique, même pour une réponse temps réel.
  DateTime get effectiveTime =>
      scheduledTime.add(Duration(minutes: delayMinutes));

  /// Le cache garde la dernière alerte sans la présenter comme actuelle.
  Departure asOffline() => copyWith(
    lastKnownStatus: lastKnownStatus ?? status,
    lastKnownDelayMinutes: lastKnownDelayMinutes ?? delayMinutes,
    status: DepartureStatus.offline,
    delayMinutes: 0,
    platform: '?',
  );

  const factory Departure({
    required String id,
    required DateTime scheduledTime,
    required String platform,
    @Default(DepartureStatus.offline) DepartureStatus status,
    @Default(0) int delayMinutes,
    int? durationMinutes,
    @Default(false) bool isCoach,
    DepartureStatus? lastKnownStatus,
    int? lastKnownDelayMinutes,
  }) = _Departure;

  factory Departure.fromJson(Map<String, dynamic> json) =>
      _$DepartureFromJson(json);
}
