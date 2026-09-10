import 'dart:async';
import 'dart:io';

import 'package:surlequai/models/transport_preferences.dart';
import 'package:surlequai/models/data_failure.dart';
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
    TransportPreferences transport = const TransportPreferences(),
    required String fromStationId,
    required String toStationId,
  }) => storageService.readCachedDepartures(
    fromStationId,
    toStationId,
    transport: transport,
  );

  Future<DeparturesResult> getDeparturesWithRealtime({
    TransportPreferences transport = const TransportPreferences(),
    required String fromStationId,
    required String toStationId,
    required DateTime datetime,
  }) async {
    try {
      final departures = await apiService.getDirectJourneys(
        transport: transport,
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
        transport: transport,
      );
      return DeparturesResult(
        departures: departures,
        fetchedAt: fetchedAt,
        fromNetwork: true,
      );
    } catch (error) {
      final failure = switch (error) {
        SocketException() => DataFailure.network,
        TimeoutException() => DataFailure.timeout,
        ApiException(statusCode: 401 || 403) => DataFailure.authentication,
        ApiException(statusCode: 429) => DataFailure.rateLimited,
        HttpException() => DataFailure.server,
        _ => DataFailure.invalidData,
      };
      final cached = await getCachedDepartures(
        transport: transport,
        fromStationId: fromStationId,
        toStationId: toStationId,
      );
      return cached.asOffline(failure: failure);
    }
  }
}
