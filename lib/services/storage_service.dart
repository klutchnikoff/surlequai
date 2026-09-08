import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:surlequai/models/departure.dart';
import 'package:surlequai/models/departures_result.dart';
import 'package:uuid/uuid.dart';

/// Cache des derniers départs consultés, par direction (pas une grille GTFS).
class StorageService {
  Directory? _cacheDir;
  Future<void>? _initializing;
  final DateTime Function() _now;

  StorageService({Directory? cacheDirectory, DateTime Function()? now})
    : _cacheDir = cacheDirectory,
      _now = now ?? DateTime.now;

  Future<void> init() => _initializing ??= _init();

  Future<void> _init() async {
    if (_cacheDir == null) {
      try {
        final appDir = await getApplicationDocumentsDirectory();
        _cacheDir = Directory(join(appDir.path, 'schedules_cache'));
      } catch (_) {
        final tempDir = await getTemporaryDirectory();
        _cacheDir = Directory(join(tempDir.path, 'schedules_cache'));
      }
    }
    await _cacheDir!.create(recursive: true);
  }

  Future<void> saveCachedDepartures(
    String from,
    String to,
    List<Departure> departures, {
    DateTime? fetchedAt,
  }) async {
    File? temporary;
    try {
      await init();
      final file = _getFile(from, to);
      temporary = File('${file.path}.${const Uuid().v4()}.tmp');
      await temporary.writeAsString(
        jsonEncode({
          // Le format précédent contenait l'heure réelle dans scheduledTime.
          'version': 2,
          'updated_at': (fetchedAt ?? _now()).toIso8601String(),
          'departures': departures.map((d) => d.toJson()).toList(),
        }),
        flush: true,
      );
      await temporary.rename(file.path);
    } catch (e) {
      debugPrint('Erreur sauvegarde cache: $e');
    } finally {
      if (temporary != null && await temporary.exists()) {
        await temporary.delete();
      }
    }
  }

  Future<DeparturesResult> readCachedDepartures(String from, String to) async {
    try {
      await init();
      final file = _getFile(from, to);
      if (!await file.exists()) return DeparturesResult();
      final data =
          jsonDecode(await file.readAsString()) as Map<String, dynamic>;
      final updated = DateTime.parse(data['updated_at'] as String);
      if (data['version'] != 2 ||
          _now().difference(updated).inHours >= 48 ||
          updated.isAfter(_now())) {
        return DeparturesResult();
      }
      return DeparturesResult(
        departures: (data['departures'] as List)
            .map((d) => Departure.fromJson(d as Map<String, dynamic>))
            .toList(),
        fetchedAt: updated,
      ).asOffline();
    } catch (e) {
      debugPrint('Erreur lecture cache: $e');
      return DeparturesResult();
    }
  }

  Future<void> clearCache() async {
    await init();
    await for (final file in _cacheDir!.list()) {
      if (file is File && basename(file.path).startsWith('cache_')) {
        await file.delete();
      }
    }
  }

  Future<void> removeDirection(String from, String to) async {
    await init();
    final file = _getFile(from, to);
    if (await file.exists()) await file.delete();
  }

  File _getFile(String from, String to) {
    final a = from.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_');
    final b = to.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_');
    return File(join(_cacheDir!.path, 'cache_${a}_$b.json'));
  }
}
