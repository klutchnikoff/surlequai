import 'package:surlequai/models/departure.dart';
import 'package:surlequai/models/timetable_version.dart';
import 'package:surlequai/services/api_service.dart';
import 'package:surlequai/services/storage_service.dart';

/// Service de gestion des grilles horaires
///
/// VERSION SIMPLIFIÉE (v1.0) :
/// Ne gère plus les grilles GTFS complexes ni SQLite.
/// Sert de façade pour récupérer les horaires "offline" depuis le cache JSON simple.
///
/// TODO(v1.1): REFACTORING À PRÉVOIR
/// Ce service est devenu largement obsolète depuis la migration vers ApiService.
/// La plupart de ses méthodes retournent des valeurs hardcodées (ex: checkForUpdate → false).
/// Candidat pour suppression : migrer les responsabilités restantes vers StorageService.
class TimetableService {
  // ignore: unused_field
  final ApiService _apiService;
  final StorageService _storageService;

  TimetableService({
    required ApiService apiService,
    required StorageService storageService,
  })  : _apiService = apiService,
        _storageService = storageService;

  /// Initialise le service
  Future<void> init() async {
    await _storageService.init();
  }

  /// (Obsolète/Simplifié) Vérifie les mises à jour
  /// Retourne toujours false car on n'utilise plus de grilles statiques versionnées
  Future<bool> checkForUpdate({String? region}) async {
    return false;
  }

  /// (Obsolète) Télécharge une grille
  Future<bool> downloadAndImportTimetable({
    required String version,
    String? region,
  }) async {
    return true; 
  }

  /// Récupère les horaires depuis le cache local (Mode Offline)
  ///
  /// Retourne :
  /// 1. Les données du cache JSON si disponibles
  /// 2. Les mocks (si mode dev et pas de cache)
  /// 3. Liste vide sinon
  Future<List<Departure>> getTheoreticalDepartures({
    required String fromStationId,
    required String toStationId,
    required DateTime datetime,
    String? tripId,
  }) async {
    // 1. Essayer le cache local (nouveau StorageService)
    final cachedDepartures = await _storageService.getCachedDepartures(
      fromStationId, 
      toStationId
    );

    if (cachedDepartures.isNotEmpty) {
      // Filtrer les départs passés ou trop lointains si nécessaire ?
      // Pour l'instant on retourne tout le cache, le UI filtrera
      return cachedDepartures;
    }

    // 2. Si pas de cache, on ne retourne rien (pas de mocks)
    return [];
  }

  // --- Helpers ---

  // Gardé pour compatibilité interface, retourne null
  TimetableVersion? get currentVersion => null;
  bool get hasLocalTimetable => false;
}