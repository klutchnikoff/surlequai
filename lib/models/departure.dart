enum DepartureStatus { onTime, delayed, cancelled, offline }

class Departure {
  final String id;
  final DateTime scheduledTime;
  final String platform;
  final DepartureStatus status;
  final int delayMinutes;

  const Departure({
    required this.id,
    required this.scheduledTime,
    required this.platform,
    this.status = DepartureStatus.offline,
    this.delayMinutes = 0,
  });

  Departure copyWith({
    String? id,
    DateTime? scheduledTime,
    String? platform,
    DepartureStatus? status,
    int? delayMinutes,
  }) {
    return Departure(
      id: id ?? this.id,
      scheduledTime: scheduledTime ?? this.scheduledTime,
      platform: platform ?? this.platform,
      status: status ?? this.status,
      delayMinutes: delayMinutes ?? this.delayMinutes,
    );
  }
}
