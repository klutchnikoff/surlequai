import 'package:surlequai/models/departure.dart';
import 'package:surlequai/services/api_service.dart';
import 'package:surlequai/services/timetable_service.dart';

/// Service de gestion des données temps réel
///
/// Responsabilités :
/// - Récupérer les données temps réel depuis l'API SNCF
/// - Fusionner horaires théoriques (cache local) + temps réel (API)
/// - Gérer les transitions online/offline
/// - Fournir des données enrichies (statut, retards, suppressions)
class RealtimeService {
  final ApiService _apiService;
  final TimetableService _timetableService;

  RealtimeService({
    required ApiService apiService,
    required TimetableService timetableService,
  })  : _apiService = apiService,
        _timetableService = timetableService;

  /// Récupère les départs avec données temps réel si disponibles
  ///
  /// Stratégie de fusion :
  /// 1. Charge horaires théoriques depuis cache local (toujours disponible)
  /// 2. Tente de récupérer temps réel depuis API
  /// 3. Si succès : Fusionne théorique + temps réel
  /// 4. Si échec : Retourne horaires théoriques avec statut "offline"
  ///
  /// Cette méthode garantit qu'on a toujours des données à afficher,
  /// même sans connexion réseau.
  Future<List<Departure>> getDeparturesWithRealtime({
    required String fromStationId,
    required String toStationId,
    required DateTime datetime,
    String? tripId, // Phase 1: pour accéder aux mocks
  }) async {
    // 1. Charge horaires théoriques (toujours disponible)
    final theoreticalDepartures =
        await _timetableService.getTheoreticalDepartures(
      fromStationId: fromStationId,
      toStationId: toStationId,
      datetime: datetime,
      tripId: tripId, // Passé en Phase 1 pour les mocks
    );

    // 2. Tente de récupérer temps réel
    try {
      final realtimeDepartures = await _apiService.getRealtimeDepartures(
        fromStationId: fromStationId,
        toStationId: toStationId,
        datetime: datetime,
      );

      // 3. Fusionne théorique + temps réel
      return _mergeDepartures(theoreticalDepartures, realtimeDepartures);
    } catch (e) {
      // 4. Erreur API → Retourne horaires théoriques avec statut "offline"
      // Note : En Phase 1 (mock), on ne devrait jamais arriver ici car pas d'exception
      return theoreticalDepartures
          .map((d) => d.copyWith(status: DepartureStatus.offline))
          .toList();
    }
  }

  /// Fusionne les horaires théoriques avec les données temps réel
  ///
  /// Logique :
  /// - Pour chaque départ théorique, cherche la correspondance temps réel
  /// - Si trouvé : Enrichit avec statut, retard, heure estimée
  /// - Si non trouvé : Garde l'horaire théorique tel quel
  ///
  /// Phase 1 : En mode mock, getRealtimeDepartures() retourne vide,
  /// donc on utilise directement les données théoriques qui contiennent
  /// déjà les statuts réalistes (onTime, delayed, cancelled)
  ///
  /// Phase 2 : Vraie fusion avec matching par trip_id ou scheduled_time
  List<Departure> _mergeDepartures(
    List<Departure> theoretical,
    List<Departure> realtime,
  ) {
    // Phase 1 : Mode mock - pas de vraies données temps réel
    // On retourne les données théoriques telles quelles car elles contiennent
    // déjà des statuts réalistes dans InitialMockData
    if (realtime.isEmpty) {
      return theoretical;
    }

    // Si on a des données temps réel (Phase 2), les utiliser
    return realtime;

    // TODO Phase 2: Vraie logique de fusion
    // final merged = <Departure>[];
    //
    // for (final theoreticalDep in theoretical) {
    //   // Cherche la correspondance dans les données temps réel
    //   final realtimeDep = realtime.firstWhere(
    //     (rt) =>
    //         rt.id == theoreticalDep.id ||
    //         _isSameScheduledTime(rt.scheduledTime, theoreticalDep.scheduledTime),
    //     orElse: () => theoreticalDep,
    //   );
    //
    //   if (realtimeDep != theoreticalDep) {
    //     // Trouvé une correspondance temps réel → l'utilise
    //     merged.add(realtimeDep);
    //   } else {
    //     // Pas de données temps réel pour ce départ → mode offline
    //     merged.add(theoreticalDep.copyWith(status: DepartureStatus.offline));
    //   }
    // }
    //
    // return merged;
  }

  /// Vérifie si deux heures correspondent (à 1 minute près)
  ///
  /// Utile pour matcher horaires théoriques et temps réel
  /// car l'heure exacte peut légèrement varier dans les données
  ///
  /// TODO Phase 2: Utilisé dans la vraie logique de fusion
  // ignore: unused_element
  bool _isSameScheduledTime(DateTime time1, DateTime time2) {
    final diff = time1.difference(time2).abs();
    return diff.inMinutes <= 1;
  }
}
