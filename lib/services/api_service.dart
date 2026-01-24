import 'package:surlequai/models/departure.dart';
import 'package:surlequai/models/station.dart';
import 'package:surlequai/models/timetable_version.dart';
import 'package:surlequai/utils/constants.dart';
import 'package:surlequai/utils/mock_data.dart';

/// Service d'accès à l'API SNCF (via proxy Cloudflare)
///
/// Phase 1 : Retourne des données mock pour permettre le développement
/// sans clés API. Les méthodes sont conçues pour être facilement
/// remplacées par de vrais appels HTTP.
///
/// Phase 2 : Implémentation avec http package et proxy Cloudflare Workers
class ApiService {
  // Phase 1 : Mock mode activé par défaut
  // Phase 2 : Sera remplacé par la vraie base URL du proxy
  final bool _useMockData = true;

  /// Récupère la version actuelle de la grille horaire
  ///
  /// Endpoint futur : GET /timetable/version?region=bretagne
  Future<TimetableVersion> getTimetableVersion({String? region}) async {
    // Simule délai réseau
    await Future.delayed(AppConstants.mockNetworkDelay);

    if (_useMockData) {
      // Mock : Grille horaire fictive v2026-A
      return TimetableVersion(
        version: '2026-A',
        region: region ?? 'bretagne',
        validFrom: DateTime(2025, 12, 15),
        validUntil: DateTime(2026, 6, 14),
        downloadedAt: DateTime.now().subtract(const Duration(days: 30)),
        sizeBytes: 15728640, // ~15 MB
      );
    }

    // TODO Phase 2: Vrai appel HTTP
    // final response = await http.get(
    //   Uri.parse('https://proxy.surlequai.app/timetable/version'),
    //   queryParameters: {'region': region ?? 'bretagne'},
    // );
    // return TimetableVersion.fromJson(jsonDecode(response.body));

    throw UnimplementedError('API réelle non encore implémentée');
  }

  /// Récupère les départs en temps réel entre deux gares
  ///
  /// Endpoint futur : GET /departures/realtime
  /// Query params : from, to, datetime, count
  Future<List<Departure>> getRealtimeDepartures({
    required String fromStationId,
    required String toStationId,
    required DateTime datetime,
    int count = 10,
  }) async {
    // Simule délai réseau
    await Future.delayed(AppConstants.mockNetworkDelay);

    if (_useMockData) {
      // Mock : Retourne les données déjà présentes dans InitialMockData
      // En réalité, on devrait filtrer par fromStationId/toStationId
      // Pour l'instant, on retourne toutes les données disponibles

      // Simuler qu'on récupère les données pour le trajet actif
      // (Dans la vraie implémentation, l'API filtrerait côté serveur)
      return InitialMockData.initialTrips.first.id == 'trip-rennes-nantes'
          ? InitialMockData.departuresData['trip-rennes-nantes_go'] ?? []
          : [];
    }

    // TODO Phase 2: Vrai appel HTTP
    // final response = await http.get(
    //   Uri.parse('https://proxy.surlequai.app/departures/realtime'),
    //   queryParameters: {
    //     'from': fromStationId,
    //     'to': toStationId,
    //     'datetime': datetime.toIso8601String(),
    //     'count': count.toString(),
    //   },
    // );
    // final json = jsonDecode(response.body);
    // return (json['departures'] as List)
    //     .map((d) => Departure.fromJson(d))
    //     .toList();

    throw UnimplementedError('API réelle non encore implémentée');
  }

  /// Recherche des gares par nom (autocomplete)
  ///
  /// Endpoint futur : GET /stations/search?q=renn&limit=10
  Future<List<Station>> searchStations(
    String query, {
    int limit = 10,
  }) async {
    // Simule délai réseau (plus court pour autocomplete)
    await Future.delayed(const Duration(milliseconds: 200));

    if (_useMockData) {
      // Mock : Utilise StationsData.searchStations (déjà implémenté)
      // Note : StationsData n'est pas encore importé ici, mais sera
      // utilisé par station_picker_screen directement
      // Ce endpoint est pour une future intégration API complète
      return [];
    }

    // TODO Phase 2: Vrai appel HTTP
    // final response = await http.get(
    //   Uri.parse('https://proxy.surlequai.app/stations/search'),
    //   queryParameters: {
    //     'q': query,
    //     'limit': limit.toString(),
    //   },
    // );
    // final json = jsonDecode(response.body);
    // return (json['stations'] as List)
    //     .map((s) => Station.fromJson(s))
    //     .toList();

    throw UnimplementedError('API réelle non encore implémentée');
  }

  /// Télécharge une grille horaire complète (GTFS ou JSON compressé)
  ///
  /// Endpoint futur : GET /timetable/download?version=2026-A&region=bretagne
  /// Retourne les données binaires à parser et importer dans SQLite
  Future<List<int>> downloadTimetable({
    required String version,
    String? region,
  }) async {
    // Simule délai réseau (téléchargement long ~10-50 MB)
    await Future.delayed(const Duration(seconds: 2));

    if (_useMockData) {
      // Mock : Retourne une liste vide (pas de vraies données GTFS)
      // En mode mock, on utilisera directement InitialMockData
      return [];
    }

    // TODO Phase 2: Vrai appel HTTP avec streaming
    // final response = await http.get(
    //   Uri.parse('https://proxy.surlequai.app/timetable/download'),
    //   queryParameters: {
    //     'version': version,
    //     'region': region ?? 'bretagne',
    //   },
    // );
    // return response.bodyBytes;

    throw UnimplementedError('API réelle non encore implémentée');
  }
}
