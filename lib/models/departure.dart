enum DepartureStatus { onTime, delayed, cancelled, offline }

class Departure {
  final String id;
  final DateTime scheduledTime;
  final String platform;
  final DepartureStatus status;
  final int delayMinutes;
  final int? durationMinutes; // Durée du trajet (null si inconnue)

  const Departure({
    required this.id,
    required this.scheduledTime,
    required this.platform,
    this.status = DepartureStatus.offline,
    this.delayMinutes = 0,
    this.durationMinutes,
  });

  Departure copyWith({
    String? id,
    DateTime? scheduledTime,
    String? platform,
    DepartureStatus? status,
    int? delayMinutes,
    int? durationMinutes,
  }) {
    return Departure(
      id: id ?? this.id,
      scheduledTime: scheduledTime ?? this.scheduledTime,
      platform: platform ?? this.platform,
      status: status ?? this.status,
      delayMinutes: delayMinutes ?? this.delayMinutes,
      durationMinutes: durationMinutes ?? this.durationMinutes,
    );
  }

  /// Convertit en JSON pour le cache
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'scheduledTime': scheduledTime.toIso8601String(),
      'platform': platform,
      'status': status.name,
      'delayMinutes': delayMinutes,
      'durationMinutes': durationMinutes,
    };
  }

  /// Crée depuis JSON (cache)
  factory Departure.fromJson(Map<String, dynamic> json) {
    return Departure(
      id: json['id'] as String,
      scheduledTime: DateTime.parse(json['scheduledTime'] as String),
      platform: json['platform'] as String,
      status: DepartureStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => DepartureStatus.offline,
      ),
      delayMinutes: json['delayMinutes'] as int? ?? 0,
      durationMinutes: json['durationMinutes'] as int?,
    );
  }
}
