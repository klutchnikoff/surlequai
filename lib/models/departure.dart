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
}
