import 'package:surlequai/models/departure.dart';
import 'package:surlequai/models/timetable_version.dart';
import 'package:surlequai/services/api_service.dart';
import 'package:surlequai/services/storage_service.dart';
import 'package:surlequai/utils/mock_data.dart';

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
      // ignore: avoid_print
      print('Erreur lors du téléchargement de la grille : $e');
      return false;
    }
  }

  /// Récupère les horaires théoriques pour un trajet et une date
  ///
  /// Phase 1 : Retourne les mock data depuis InitialMockData
  /// Phase 2 : Interrogera la base SQLite locale
  Future<List<Departure>> getTheoreticalDepartures({
    required String fromStationId,
    required String toStationId,
    required DateTime datetime,
  }) async {
    // Phase 1 : Mode mock
    // On utilise InitialMockData pour avoir des données réalistes

    // Logique simplifiée : Identifie le trajet par les IDs de stations
    // Dans la vraie implémentation, on ferait une requête SQL

    // Pour Rennes → Nantes
    if (fromStationId == 'stop_area:SNCF:87471003' &&
        toStationId == 'stop_area:SNCF:87481002') {
      return InitialMockData.departuresData['trip-rennes-nantes_go'] ?? [];
    }

    // Pour Nantes → Rennes
    if (fromStationId == 'stop_area:SNCF:87481002' &&
        toStationId == 'stop_area:SNCF:87471003') {
      return InitialMockData.departuresData['trip-rennes-nantes_return'] ?? [];
    }

    // Trajet inconnu → retourne vide
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
}
