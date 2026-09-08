import 'package:surlequai/models/departures_result.dart';
import 'package:surlequai/services/api_service.dart';
import 'package:surlequai/services/storage_service.dart';

class RealtimeService {
  final ApiService apiService;
  final StorageService storageService;
  final DateTime Function() _now;

  RealtimeService({
    required this.apiService,
    required this.storageService,
    DateTime Function()? now,
  }) : _now = now ?? DateTime.now;

  Future<DeparturesResult> getCachedDepartures({
    required String fromStationId,
    required String toStationId,
  }) => storageService.readCachedDepartures(fromStationId, toStationId);

  Future<DeparturesResult> getDeparturesWithRealtime({
    required String fromStationId,
    required String toStationId,
    required DateTime datetime,
  }) async {
    try {
      final departures = await apiService.getDirectJourneys(
        fromStationId: fromStationId,
        toStationId: toStationId,
        datetime: datetime,
        count: 6,
      );
      final fetchedAt = _now();
      // Une réponse vide est un succès et remplace aussi le cache précédent.
      await storageService.saveCachedDepartures(
        fromStationId,
        toStationId,
        departures,
        fetchedAt: fetchedAt,
      );
      return DeparturesResult(
        departures: departures,
        fetchedAt: fetchedAt,
        fromNetwork: true,
      );
    } catch (_) {
      return getCachedDepartures(
        fromStationId: fromStationId,
        toStationId: toStationId,
      );
    }
  }
}
