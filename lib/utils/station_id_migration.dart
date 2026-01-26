import 'package:surlequai/models/station.dart';
import 'package:surlequai/models/trip.dart';

/// Utilitaire de migration des anciens IDs de gares vers les IDs Navitia
///
/// Convertit les IDs simplifiés (ex: 'rennes') en IDs Navitia complets
/// (ex: 'stop_area:SNCF:87471003')
class StationIdMigration {
  StationIdMigration._();

  /// Mapping des anciens IDs simplifiés vers les IDs Navitia
  static const Map<String, String> _idMapping = {
    // Anciens IDs simplifiés → Nouveaux IDs Navitia
    'rennes': 'stop_area:SNCF:87471003',
    'nantes': 'stop_area:SNCF:87481002',
    'paris': 'stop_area:SNCF:87391003',
    'paris-montparnasse': 'stop_area:SNCF:87391003',
    'lyon': 'stop_area:SNCF:87723197',
    'lyon-part-dieu': 'stop_area:SNCF:87723197',
    'bordeaux': 'stop_area:SNCF:87581009',
    'toulouse': 'stop_area:SNCF:87611004',
    'marseille': 'stop_area:SNCF:87751008',
    'lille-flandres': 'stop_area:SNCF:87286005',
    'strasbourg': 'stop_area:SNCF:87212027',
    'nice': 'stop_area:SNCF:87756056',
  };

  /// Vérifie si un ID nécessite une migration (ancien format)
  static bool needsMigration(String stationId) {
    return _idMapping.containsKey(stationId);
  }

  /// Migre un ancien ID vers le nouveau format Navitia
  ///
  /// Si l'ID est déjà au bon format, le retourne tel quel
  static String migrateStationId(String oldId) {
    return _idMapping[oldId] ?? oldId;
  }

  /// Migre une Station complète
  static Station migrateStation(Station station) {
    final newId = migrateStationId(station.id);

    if (newId == station.id) {
      return station; // Pas de migration nécessaire
    }

    return Station(
      id: newId,
      name: station.name,
    );
  }

  /// Migre un Trip complet (avec ses deux gares)
  static Trip migrateTrip(Trip trip) {
    final newStationA = migrateStation(trip.stationA);
    final newStationB = migrateStation(trip.stationB);

    // Si aucune migration nécessaire, retourne le trip tel quel
    if (newStationA.id == trip.stationA.id &&
        newStationB.id == trip.stationB.id) {
      return trip;
    }

    return Trip(
      id: trip.id,
      stationA: newStationA,
      stationB: newStationB,
    );
  }

  /// Migre une liste complète de trips
  static List<Trip> migrateTrips(List<Trip> trips) {
    return trips.map(migrateTrip).toList();
  }

  /// Vérifie si une liste de trips contient des IDs à migrer
  static bool tripsNeedMigration(List<Trip> trips) {
    return trips.any((trip) =>
        needsMigration(trip.stationA.id) || needsMigration(trip.stationB.id));
  }
}
