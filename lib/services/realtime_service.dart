import 'package:surlequai/models/departure.dart';
import 'package:surlequai/services/api_service.dart';
import 'package:surlequai/services/storage_service.dart';
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
  final StorageService? _storageService;

  RealtimeService({
    required ApiService apiService,
    required TimetableService timetableService,
    StorageService? storageService,
  })  : _apiService = apiService,
        _timetableService = timetableService,
        _storageService = storageService;

  /// Récupère les départs avec données temps réel si disponibles
  ///
  /// Stratégie de fusion :
  /// 1. Charge horaires théoriques depuis cache local (toujours disponible)
  /// 2. Tente de récupérer temps réel depuis API
  /// 3. Si succès : 
  ///    - Sauvegarde dans le cache local (Mise à jour)
  ///    - Fusionne théorique + temps réel
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

    // 2. Tente de récupérer temps réel (itinéraires directs, SANS cache)
    try {
      final realtimeDepartures = await _apiService.getDirectJourneys(
        fromStationId: fromStationId,
        toStationId: toStationId,
        datetime: datetime,
        count: 6, // Augmenté à 6 pour avoir un cache un peu plus fourni
      );

      // SAUVEGARDE DANS LE CACHE (Nouveau)
      if (realtimeDepartures.isNotEmpty && _storageService != null) {
        // On sauvegarde ces données fraîches comme nouveau référentiel "théorique/offline"
        // On les convertit en "offline" pour le stockage futur (optionnel, 
        // ou on les garde tel quel et le getCached les repassera en offline si besoin)
        // Le mieux est de stocker tel quel.
        await _storageService!.saveCachedDepartures(
          fromStationId, 
          toStationId, 
          realtimeDepartures
        );
      }

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
  /// - Si données temps réel disponibles : les utiliser
  /// - Si liste vide : retourner liste vide (affichera "Aucun train")
  /// - Si horaires théoriques disponibles (cache GTFS) : les enrichir avec temps réel
  List<Departure> _mergeDepartures(
    List<Departure> theoretical,
    List<Departure> realtime,
  ) {
    // Si on a des données temps réel, les utiliser (même si vide)
    // Liste vide = API OK mais aucun train trouvé → "Aucun train"
    if (realtime.isNotEmpty) {
      return realtime;
    }

    // Si pas de données temps réel mais horaires théoriques disponibles
    // (futur cache GTFS), les marquer comme "offline"
    if (theoretical.isNotEmpty) {
      return theoretical
          .map((d) => d.copyWith(status: DepartureStatus.offline))
          .toList();
    }

    // Aucune donnée disponible
    return [];

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
