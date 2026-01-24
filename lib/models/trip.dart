import 'package:surlequai/models/station.dart';

enum MorningDirection { aToB, bToA }

class Trip {
  final String id;
  final Station stationA;
  final Station stationB;
  final MorningDirection morningDirection;

  const Trip({
    required this.id,
    required this.stationA,
    required this.stationB,
    this.morningDirection =
        MorningDirection.aToB, // Default to A->B as morning trip
  });

  Trip copyWith({
    MorningDirection? morningDirection,
  }) {
    return Trip(
      id: id,
      stationA: stationA,
      stationB: stationB,
      morningDirection: morningDirection ?? this.morningDirection,
    );
  }

  factory Trip.fromJson(Map<String, dynamic> json) {
    return Trip(
      id: json['id'],
      stationA: Station.fromJson(json['stationA']),
      stationB: Station.fromJson(json['stationB']),
      morningDirection: MorningDirection.values[json['morningDirection'] ?? 0],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'stationA': stationA.toJson(),
      'stationB': stationB.toJson(),
      'morningDirection': morningDirection.index,
    };
  }
}
