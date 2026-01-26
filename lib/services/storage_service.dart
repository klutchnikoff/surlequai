import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:surlequai/models/departure.dart';
import 'package:surlequai/models/timetable_version.dart';

/// Service de stockage local SQLite pour les horaires théoriques
///
/// Gère deux tables principales :
/// - timetables : Métadonnées des grilles horaires (versions, validité)
/// - departures : Départs théoriques (heure, voie, jours de circulation)
///
/// Permet un fonctionnement hors-ligne complet de l'application
///
/// Note : SQLite n'est disponible que sur iOS/Android.
/// Sur Web/Desktop, le service fonctionne en mode dégradé (pas de cache local).
class StorageService {
  static const String _databaseName = 'surlequai.db';
  static const int _databaseVersion = 1;

  Database? _database;

  /// Vérifie si on est sur une plateforme mobile (iOS/Android)
  bool get _isMobilePlatform {
    if (kIsWeb) return false;
    return Platform.isIOS || Platform.isAndroid;
  }

  /// Initialise la base de données SQLite
  ///
  /// Crée les tables si nécessaire, applique les index pour performances
  ///
  /// Note : Sur Web/Desktop, cette méthode ne fait rien (SQLite non supporté)
  Future<void> init() async {
    if (_database != null) return; // Déjà initialisée

    // SQLite n'est disponible que sur iOS/Android
    if (!_isMobilePlatform) {
      return; // Mode dégradé : pas de cache local sur Web/Desktop
    }

    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, _databaseName);

    _database = await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _createDatabase,
    );
  }

  /// Crée le schéma de base de données
  Future<void> _createDatabase(Database db, int version) async {
    // Table : Métadonnées grilles horaires
    await db.execute('''
      CREATE TABLE timetables (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        version TEXT NOT NULL,
        region TEXT NOT NULL,
        valid_from TEXT NOT NULL,
        valid_until TEXT NOT NULL,
        downloaded_at TEXT NOT NULL,
        file_size_bytes INTEGER,
        UNIQUE(version, region)
      )
    ''');

    // Table : Départs théoriques
    await db.execute('''
      CREATE TABLE departures (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        timetable_id INTEGER NOT NULL,
        from_station_id TEXT NOT NULL,
        from_station_name TEXT NOT NULL,
        to_station_id TEXT NOT NULL,
        to_station_name TEXT NOT NULL,
        departure_time TEXT NOT NULL,
        arrival_time TEXT NOT NULL,
        platform TEXT,
        days_mask TEXT NOT NULL,
        FOREIGN KEY (timetable_id) REFERENCES timetables(id)
      )
    ''');

    // Index pour recherches rapides par trajet et heure
    await db.execute('''
      CREATE INDEX idx_departures_route
      ON departures(from_station_id, to_station_id, departure_time)
    ''');

    await db.execute('''
      CREATE INDEX idx_departures_time
      ON departures(departure_time)
    ''');
  }

  /// Sauvegarde une grille horaire (métadonnées)
  Future<int> saveTimetable(TimetableVersion version) async {
    await _ensureInitialized();
    if (_database == null) return -1; // Mode dégradé sur Web/Desktop

    return await _database!.insert(
      'timetables',
      {
        'version': version.version,
        'region': version.region,
        'valid_from': version.validFrom.toIso8601String(),
        'valid_until': version.validUntil.toIso8601String(),
        'downloaded_at': version.downloadedAt?.toIso8601String() ??
            DateTime.now().toIso8601String(),
        'file_size_bytes': version.sizeBytes,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Récupère la grille horaire actuelle (la plus récente)
  Future<TimetableVersion?> getCurrentTimetable({String? region}) async {
    await _ensureInitialized();
    if (_database == null) return null; // Mode dégradé sur Web/Desktop

    final List<Map<String, dynamic>> results = await _database!.query(
      'timetables',
      where: region != null ? 'region = ?' : null,
      whereArgs: region != null ? [region] : null,
      orderBy: 'valid_from DESC',
      limit: 1,
    );

    if (results.isEmpty) return null;

    final row = results.first;
    return TimetableVersion(
      version: row['version'] as String,
      region: row['region'] as String,
      validFrom: DateTime.parse(row['valid_from'] as String),
      validUntil: DateTime.parse(row['valid_until'] as String),
      downloadedAt: DateTime.parse(row['downloaded_at'] as String),
      sizeBytes: row['file_size_bytes'] as int?,
    );
  }

  /// Sauvegarde une liste de départs théoriques (import grille)
  Future<void> saveDepartures(
    int timetableId,
    List<Departure> departures,
  ) async {
    await _ensureInitialized();
    if (_database == null) return; // Mode dégradé sur Web/Desktop

    final batch = _database!.batch();

    for (final departure in departures) {
      batch.insert('departures', {
        'timetable_id': timetableId,
        'from_station_id': departure.id, // Utilise l'ID comme référence
        'from_station_name': 'Station', // TODO: Extraire du context
        'to_station_id': departure.id,
        'to_station_name': 'Station',
        'departure_time': _formatTimeOfDay(departure.scheduledTime),
        'arrival_time': _formatTimeOfDay(
            departure.scheduledTime.add(const Duration(hours: 1))),
        'platform': departure.platform,
        'days_mask': '1111111', // Tous les jours par défaut (Lu-Di)
      });
    }

    await batch.commit(noResult: true);
  }

  /// Récupère les départs théoriques pour un trajet et une date
  Future<List<Departure>> getDepartures({
    required String fromStationId,
    required String toStationId,
    required DateTime date,
  }) async {
    await _ensureInitialized();

    // TODO Phase 2: Implémenter la vraie requête SQL avec filtre sur date/jours
    // Pour l'instant, retourne une liste vide car on utilise les mocks
    // Dans InitialMockData

    // final dayOfWeek = date.weekday; // 1=Lundi, 7=Dimanche
    // final dayMaskIndex = dayOfWeek - 1; // 0-6

    // final List<Map<String, dynamic>> results = await _database!.query(
    //   'departures',
    //   where: '''
    //     from_station_id = ? AND
    //     to_station_id = ? AND
    //     SUBSTR(days_mask, ?, 1) = '1'
    //   ''',
    //   whereArgs: [fromStationId, toStationId, dayMaskIndex + 1],
    //   orderBy: 'departure_time ASC',
    // );

    // return results.map((row) => _departureFromRow(row, date)).toList();

    return [];
  }

  /// Supprime les anciennes grilles horaires expirées
  Future<void> clearOldTimetables() async {
    await _ensureInitialized();
    if (_database == null) return; // Mode dégradé sur Web/Desktop

    final now = DateTime.now().toIso8601String();

    // Récupère les IDs des grilles expirées
    final List<Map<String, dynamic>> oldTimetables = await _database!.query(
      'timetables',
      columns: ['id'],
      where: 'valid_until < ?',
      whereArgs: [now],
    );

    if (oldTimetables.isEmpty) return;

    final oldIds = oldTimetables.map((t) => t['id'] as int).toList();

    // Supprime les départs associés
    await _database!.delete(
      'departures',
      where: 'timetable_id IN (${List.filled(oldIds.length, '?').join(', ')})',
      whereArgs: oldIds,
    );

    // Supprime les métadonnées
    await _database!.delete(
      'timetables',
      where: 'valid_until < ?',
      whereArgs: [now],
    );
  }

  /// Ferme la connexion à la base de données
  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }

  /// S'assure que la base de données est initialisée
  ///
  /// Sur Web/Desktop, ne fait rien (mode dégradé sans cache local)
  Future<void> _ensureInitialized() async {
    if (!_isMobilePlatform) {
      return; // Pas de cache local sur Web/Desktop
    }
    if (_database == null) {
      await init();
    }
  }

  /// Formate un DateTime en HH:mm:ss pour stockage
  String _formatTimeOfDay(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:'
        '${time.minute.toString().padLeft(2, '0')}:'
        '${time.second.toString().padLeft(2, '0')}';
  }

  /// Reconstruit un Departure depuis une ligne SQL
  ///
  /// Note : Cette méthode sera complétée en Phase 2 avec le vrai mapping
  ///
  /// TODO Phase 2: Utilisé dans getDepartures()
  // ignore: unused_element
  Departure _departureFromRow(Map<String, dynamic> row, DateTime date) {
    // Parse departure_time "HH:mm:ss"
    final timeParts = (row['departure_time'] as String).split(':');
    final departureTime = DateTime(
      date.year,
      date.month,
      date.day,
      int.parse(timeParts[0]),
      int.parse(timeParts[1]),
      int.parse(timeParts[2]),
    );

    return Departure(
      id: 'dep-${row['id']}',
      scheduledTime: departureTime,
      platform: row['platform'] as String? ?? '?',
      status: DepartureStatus.offline, // Horaire théorique
      delayMinutes: 0,
    );
  }
}
