import 'package:flutter/foundation.dart';
import 'package:surlequai/models/departure.dart';
import 'package:surlequai/models/timetable_version.dart';
import 'package:surlequai/services/api_service.dart';
import 'package:surlequai/services/storage_service.dart';
import 'package:surlequai/utils/mock_data.dart';
import 'package:surlequai/utils/navitia_config.dart';

/// Service de gestion des grilles horaires théoriques
///
/// Responsabilités :
/// - Vérifier si une nouvelle grille horaire est disponible
/// - Télécharger et importer les grilles horaires
/// - Récupérer les horaires théoriques depuis le cache local
/// - Gérer le cycle de vie des grilles (téléchargement, stockage, expiration)
class TimetableService {
  final ApiService _apiService;
  final StorageService _storageService;

  // Cache mémoire de la version actuelle
  TimetableVersion? _currentVersion;

  TimetableService({
    required ApiService apiService,
    required StorageService storageService,
  })  : _apiService = apiService,
        _storageService = storageService;

  /// Initialise le service (charge la version actuelle depuis SQLite)
  Future<void> init() async {
    await _storageService.init();
    _currentVersion = await _storageService.getCurrentTimetable();
  }

  /// Vérifie s'il existe une nouvelle version de grille horaire
  ///
  /// Retourne true si une mise à jour est disponible, false sinon
  Future<bool> checkForUpdate({String? region}) async {
    try {
      final latestVersion =
          await _apiService.getTimetableVersion(region: region);

      // Pas de version locale → mise à jour disponible
      if (_currentVersion == null) return true;

      // Compare les versions
      return latestVersion.isNewerThan(_currentVersion);
    } catch (e) {
      // En cas d'erreur réseau, considère qu'il n'y a pas de mise à jour
      return false;
    }
  }

  /// Télécharge et importe une nouvelle grille horaire
  ///
  /// Steps :
  /// 1. Télécharge le fichier GTFS/JSON depuis l'API
  /// 2. Parse les données
  /// 3. Importe dans SQLite (table departures)
  /// 4. Sauvegarde les métadonnées (table timetables)
  /// 5. Supprime les anciennes grilles expirées
  ///
  /// Retourne true en cas de succès, false sinon
  Future<bool> downloadAndImportTimetable({
    required String version,
    String? region,
  }) async {
    try {
      // 1. Télécharge la grille
      // ignore: unused_local_variable
      final data = await _apiService.downloadTimetable(
        version: version,
        region: region,
      );

      // TODO Phase 2: Parser le fichier GTFS ou JSON
      // final parsedDepartures = _parseGTFS(data);

      // 2. Sauvegarde les métadonnées
      final timetableVersion = await _apiService.getTimetableVersion(
        region: region,
      );
      // ignore: unused_local_variable
      final timetableId = await _storageService.saveTimetable(timetableVersion);

      // 3. Importe les départs (Phase 2)
      // await _storageService.saveDepartures(timetableId, parsedDepartures);

      // 4. Met à jour le cache mémoire
      _currentVersion = timetableVersion;

      // 5. Nettoie les anciennes grilles
      await _storageService.clearOldTimetables();

      return true;
    } catch (e) {
      // Log l'erreur (en production, on utiliserait un logger)
      debugPrint('Erreur lors du téléchargement de la grille : $e');
      return false;
    }
  }

  /// Récupère les horaires théoriques pour un trajet et une date
  ///
  /// Mode développement (sans clé API) : Retourne mock data
  /// Mode production (avec clé API) : Retourne liste vide (attente cache GTFS)
  /// Phase 2 future : Interrogera la base SQLite locale
  Future<List<Departure>> getTheoreticalDepartures({
    required String fromStationId,
    required String toStationId,
    required DateTime datetime,
    String? tripId, // Phase 1: utilisé pour les mocks
  }) async {
    // Si clé API configurée : ne pas utiliser les mocks
    // Les données viendront de l'API temps réel
    if (NavitiaConfig.isConfigured) {
      // TODO Phase 2: Interroger cache SQLite local (horaires théoriques)
      return []; // Pas de cache pour l'instant
    }

    // Mode développement sans clé API : utiliser les mocks
    if (tripId != null) {
      final isGo = _isGoDirection(tripId, fromStationId, toStationId);
      final suffix = isGo ? '_go' : '_return';
      return InitialMockData.departuresData['$tripId$suffix'] ?? [];
    }

    return [];

    // TODO Phase 2: Vraie requête SQLite
    // return await _storageService.getDepartures(
    //   fromStationId: fromStationId,
    //   toStationId: toStationId,
    //   date: datetime,
    // );
  }

  /// Retourne la version actuelle de la grille horaire (si disponible)
  TimetableVersion? get currentVersion => _currentVersion;

  /// Vérifie si une grille horaire locale existe
  bool get hasLocalTimetable => _currentVersion != null;

  /// Détermine si c'est la direction "go" (A→B) ou "return" (B→A)
  ///
  /// Phase 1 helper pour les mocks
  bool _isGoDirection(String tripId, String fromId, String toId) {
    // Trouve le trip correspondant dans InitialMockData
    final trip = InitialMockData.initialTrips.firstWhere(
      (t) => t.id == tripId,
      orElse: () => InitialMockData.initialTrips.first,
    );

    // Direction "go" si fromId correspond à stationA
    return trip.stationA.id == fromId;
  }
}
