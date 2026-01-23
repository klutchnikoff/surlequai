import 'package:surlequai/models/station.dart';

class Trip {
  final String id;
  final Station stationA;
  final Station stationB;

  const Trip({
    required this.id,
    required this.stationA,
    required this.stationB,
  });
}
