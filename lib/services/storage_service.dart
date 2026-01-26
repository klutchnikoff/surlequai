import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:surlequai/models/departure.dart';

/// Service de stockage local (Cache JSON)
///
/// Remplace l'ancien stockage SQLite.
/// Stocke les réponses API (liste de départs) dans des fichiers JSON locaux.
///
/// Structure :
/// - Un fichier par trajet : `cache_fromID_toID.json`
/// - Contient : timestamp de mise à jour + liste des départs
class StorageService {
  Directory? _cacheDir;

  /// Initialise le service (prépare le dossier de cache)
  Future<void> init() async {
    if (_cacheDir != null) return;

    try {
      final appDir = await getApplicationDocumentsDirectory();
      _cacheDir = Directory(join(appDir.path, 'schedules_cache'));
      if (!await _cacheDir!.exists()) {
        await _cacheDir!.create(recursive: true);
      }
    } catch (e) {
      debugPrint('Erreur init StorageService: $e');
      // Fallback sur dossier temporaire si échec (rare)
      _cacheDir = await getTemporaryDirectory();
    }
  }

  /// Sauvegarde les départs pour un trajet donné
  Future<void> saveCachedDepartures(
    String fromStationId,
    String toStationId,
    List<Departure> departures,
  ) async {
    if (_cacheDir == null) await init();

    try {
      final file = _getFile(fromStationId, toStationId);
      final jsonMap = {
        'updated_at': DateTime.now().toIso8601String(),
        'departures': departures.map((d) => d.toJson()).toList(),
      };
      
      await file.writeAsString(jsonEncode(jsonMap));
    } catch (e) {
      debugPrint('Erreur sauvegarde cache: $e');
    }
  }

  /// Récupère les départs en cache pour un trajet
  /// Retourne une liste vide si pas de cache ou erreur
  Future<List<Departure>> getCachedDepartures(
    String fromStationId,
    String toStationId,
  ) async {
    if (_cacheDir == null) await init();

    try {
      final file = _getFile(fromStationId, toStationId);
      if (!await file.exists()) {
        return [];
      }

      final content = await file.readAsString();
      final jsonMap = jsonDecode(content);
      
      // Vérification basique (optionnelle) de l'âge du cache
      // final updatedAt = DateTime.parse(jsonMap['updated_at']);
      // if (DateTime.now().difference(updatedAt).inHours > 48) return [];

      final list = jsonMap['departures'] as List;
      return list.map((d) => Departure.fromJson(d)).toList();
    } catch (e) {
      debugPrint('Erreur lecture cache: $e');
      return [];
    }
  }

  /// Récupère la date de dernière mise à jour du cache pour ce trajet
  Future<DateTime?> getLastUpdate(String fromStationId, String toStationId) async {
     if (_cacheDir == null) await init();
     try {
       final file = _getFile(fromStationId, toStationId);
       if (!await file.exists()) return null;
       
       final content = await file.readAsString();
       final jsonMap = jsonDecode(content);
       return DateTime.parse(jsonMap['updated_at']);
     } catch (e) {
       return null;
     }
  }

  File _getFile(String fromId, String toId) {
    // Nettoyer les IDs pour le nom de fichier (enlever stop_area:SNCF:)
    final cleanFrom = fromId.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_');
    final cleanTo = toId.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_');
    return File(join(_cacheDir!.path, 'cache_${cleanFrom}_${cleanTo}.json'));
  }
}