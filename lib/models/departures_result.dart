import 'package:surlequai/models/departure.dart';

/// Les données et leur provenance voyagent ensemble jusqu'à l'affichage.
class DeparturesResult {
  final List<Departure> departures;
  final DateTime? fetchedAt;
  final bool fromNetwork;

  DeparturesResult({
    List<Departure> departures = const [],
    this.fetchedAt,
    this.fromNetwork = false,
  }) : departures = List.unmodifiable(departures);

  DeparturesResult asOffline() => DeparturesResult(
    departures: departures
        .map(
          (d) => d.copyWith(
            status: DepartureStatus.offline,
            delayMinutes: 0,
            platform: '?',
          ),
        )
        .toList(),
    fetchedAt: fetchedAt,
  );
}

class TripDepartures {
  final DeparturesResult go;
  final DeparturesResult back;

  const TripDepartures(this.go, this.back);

  bool get fromNetwork => go.fromNetwork && back.fromNetwork;

  // Afficher l'âge de la direction la moins fraîche, jamais celui du rendu.
  DateTime? get fetchedAt {
    final a = go.fetchedAt;
    final b = back.fetchedAt;
    if (a == null || b == null) return null;
    return a.isBefore(b) ? a : b;
  }
}
