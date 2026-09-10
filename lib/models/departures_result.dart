import 'package:surlequai/models/departure.dart';
import 'package:surlequai/models/data_failure.dart';

/// Les données et leur provenance voyagent ensemble jusqu'à l'affichage.
class DeparturesResult {
  final List<Departure> departures;
  final DateTime? fetchedAt;
  final bool fromNetwork;
  final DataFailure? failure;

  DeparturesResult({
    List<Departure> departures = const [],
    this.fetchedAt,
    this.fromNetwork = false,
    this.failure,
  }) : departures = List.unmodifiable(departures);

  DeparturesResult asOffline({DataFailure? failure}) => DeparturesResult(
    departures: departures.map((d) => d.asOffline()).toList(),
    fetchedAt: fetchedAt,
    failure: failure ?? this.failure,
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
