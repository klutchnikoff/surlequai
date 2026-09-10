import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:surlequai/models/departure.dart';
import 'package:surlequai/models/data_failure.dart';
import 'package:surlequai/models/navitia/navitia_models.dart';
import 'package:surlequai/models/station.dart';
import 'package:surlequai/services/api_key_service.dart';
import 'package:surlequai/utils/constants.dart';
import 'package:surlequai/utils/navitia_config.dart';
import 'package:surlequai/utils/service_day.dart';
import 'package:surlequai/services/journey_mapper.dart';

/// Service d'accès à l'API SNCF via Navitia
///
/// Gère les appels HTTP vers l'API Navitia pour récupérer :
/// - Les départs en temps réel
/// - La recherche de gares
///
/// Supporte BYOK (Bring Your Own Key) :
/// - Si clé personnalisée configurée → Appel direct à api.sncf.com
/// - Sinon → Appel via proxy Cloudflare (mode par défaut)
///
/// Gestion d'erreurs incluse :
/// - SocketException : Pas de connexion réseau
/// - TimeoutException : Timeout API
/// - HttpException : Erreurs HTTP (401, 404, 500, etc.)
class ApiService {
  final http.Client _client;
  final ApiKeyService _apiKeyService;

  // Cache de la clé personnalisée pour éviter lectures répétées
  String? _customKey;
  bool _useCustomKey = false;
  DateTime? _retryNotBefore;
  final DateTime Function() _now;

  ApiService({
    http.Client? client,
    ApiKeyService? apiKeyService,
    DateTime Function()? now,
  }) : _now = now ?? DateTime.now,
       _client = client ?? http.Client(),
       _apiKeyService = apiKeyService ?? ApiKeyService();

  /// Initialise le service (charge la clé personnalisée si configurée)
  Future<void> init() async {
    await _apiKeyService.init();
    _useCustomKey = await _apiKeyService.hasCustomKey();
    if (_useCustomKey) {
      _customKey = await _apiKeyService.getCustomKey();
    }
  }

  /// Méthode centrale pour effectuer les appels HTTP
  /// Gère la construction d'URL, les headers, les timeouts et les erreurs communes.
  Future<Map<String, dynamic>> _get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final retryAt = _retryNotBefore;
      if (retryAt != null && _now().isBefore(retryAt)) {
        throw ApiException(
          429,
          'Limite de requêtes atteinte',
          retryAfter: retryAt.difference(_now()),
        );
      }
      final baseUrl = NavitiaConfig.getBaseUrl(useCustomKey: _useCustomKey);

      // Construction de l'URL
      final uri = Uri.parse('$baseUrl/$endpoint')
          .replace(queryParameters: queryParameters);

      if (AppConstants.enableDebugLogs) {
        debugPrint('[ApiService] GET: $uri');
      }

      // Appel HTTP avec timeout
      final response = await _client
          .get(
            uri,
            headers: NavitiaConfig.getAuthHeaders(customKey: _customKey),
          )
          .timeout(AppConstants.apiTimeout);

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      }
      if (response.statusCode == 404 && endpoint.endsWith('/journeys')) {
        try {
          final body = jsonDecode(response.body);
          if (body is Map &&
              body['error'] is Map &&
              body['error']['id'] == 'no_solution') {
            return {'journeys': <dynamic>[]};
          }
        } on FormatException {
          // Une page d'erreur HTML reste une erreur HTTP, pas un résultat vide.
        }
      }
      final retrySeconds = int.tryParse(response.headers['retry-after'] ?? '');
      if (response.statusCode == 429) {
        _retryNotBefore = _now().add(
          Duration(seconds: (retrySeconds ?? 60).clamp(1, 86400)),
        );
      }
      throw ApiException(
        response.statusCode,
        response.statusCode == 401
            ? 'Clé API invalide ou expirée'
            : 'Service horaires indisponible (${response.statusCode})',
        retryAfter: retrySeconds == null
            ? null
            : Duration(seconds: retrySeconds),
      );
    } on SocketException {
      throw const SocketException('Pas de connexion Internet');
    } on TimeoutException {
      throw TimeoutException('Délai d\'attente dépassé');
    } catch (e) {
      if (AppConstants.enableDebugLogs) {
        debugPrint('[ApiService] Error: $e');
      }
      rethrow;
    }
  }

  /// Récupère les départs en temps réel entre deux gares
  Future<List<Departure>> getRealtimeDepartures({
    required String fromStationId,
    required String toStationId,
    required DateTime datetime,
    int count = 10,
  }) async {
    return getDirectJourneys(
      fromStationId: fromStationId,
      toStationId: toStationId,
      datetime: datetime,
      count: count,
    );
  }

  /// Récupère les itinéraires directs entre deux gares (trains sans correspondance)
  Future<List<Departure>> getDirectJourneys({
    required String fromStationId,
    required String toStationId,
    required DateTime datetime,
    int count = 10,
  }) async {
    final jsonData = await _get(
      'coverage/${NavitiaConfig.coverage}/journeys',
      queryParameters: {
        'from': fromStationId,
        'to': toStationId,
        'datetime': _formatNavitiaDateTime(datetime),
        'count': count.toString(),
        'data_freshness': 'realtime',
        'min_nb_journeys': count.toString(),
        'max_nb_transfers': '0',
        'forbidden_uris[]': [
          'physical_mode:LongDistanceTrain',
          'physical_mode:RapidTransit',
          'physical_mode:Metro',
          'physical_mode:Tramway',
          'physical_mode:Bus',
        ],
      },
    );

    final departures = JourneyMapper.parse(
      jsonData,
      fromStationId: fromStationId,
      toStationId: toStationId,
    );

    if (AppConstants.enableDebugLogs) {
      debugPrint('[ApiService] Parsed ${departures.length} direct journeys');
    }

    return departures;
  }

  /// Récupère les horaires théoriques (sans temps réel) - méthode interne
  Future<List<Departure>> _fetchTheoreticalJourneys({
    required String fromStationId,
    required String toStationId,
    required DateTime datetime,
    int count = AppConstants.maxTrainsPerDay,
  }) async {
    final jsonData = await _get(
      'coverage/${NavitiaConfig.coverage}/journeys',
      queryParameters: {
        'from': fromStationId,
        'to': toStationId,
        'datetime': _formatNavitiaDateTime(datetime),
        'count': count.toString(),
        'data_freshness': 'base_schedule',
        'max_nb_transfers': '0',
        'forbidden_uris[]': [
          'physical_mode:LongDistanceTrain',
          'physical_mode:RapidTransit',
          'physical_mode:Metro',
          'physical_mode:Tramway',
          'physical_mode:Bus',
        ],
      },
    );

    final departures = JourneyMapper.parse(
      jsonData,
      fromStationId: fromStationId,
      toStationId: toStationId,
    );

    if (AppConstants.enableDebugLogs) {
      debugPrint(
        '[ApiService] Parsed ${departures.length} theoretical schedules',
      );
    }

    return departures;
  }

  /// Récupère les horaires théoriques avec cache (un appel API par jour maximum)
  Future<List<Departure>> getTheoreticalSchedule({
    required String fromStationId,
    required String toStationId,
    required DateTime datetime,
    int count = AppConstants.maxTrainsPerDay,
    int serviceDayStartHour = AppConstants.defaultServiceDayStartHour,
  }) async {
    // Calculer le jour de service (change à 4h du matin, pas à minuit)
    final serviceStart = ServiceDay.start(datetime, serviceDayStartHour);
    final serviceDay = serviceStart.toIso8601String();
    await _pruneTheoreticalCache();
    final cacheKey = _getCacheKey(fromStationId, toStationId, serviceDay);

    if (AppConstants.enableDebugLogs) {
      debugPrint('[ApiService] Cache key: $cacheKey');
    }

    // Vérifier le cache
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedJson = prefs.getString(cacheKey);

      if (cachedJson != null) {
        final List<dynamic> jsonList = jsonDecode(cachedJson);
        final departures = jsonList.map((j) => Departure.fromJson(j)).toList();

        if (AppConstants.enableDebugLogs) {
          debugPrint(
            '[ApiService] ✅ Cache hit: ${departures.length} departures',
          );
        }

        return departures;
      }
    } catch (e) {
      if (AppConstants.enableDebugLogs) {
        debugPrint('[ApiService] ⚠️ Cache read error: $e');
      }
    }

    // Cache manquant ou invalide → appel API
    if (AppConstants.enableDebugLogs) {
      debugPrint(
        '[ApiService] ❌ Cache miss, fetching theoretical schedule from API',
      );
    }

    final departures = await _fetchTheoreticalJourneys(
      fromStationId: fromStationId,
      toStationId: toStationId,
      datetime: serviceStart,
      count: count,
    );

    // Sauvegarder dans le cache
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = departures.map((d) => d.toJson()).toList();
      final jsonString = jsonEncode(jsonList);
      await prefs.setString(cacheKey, jsonString);

      if (AppConstants.enableDebugLogs) {
        debugPrint('[ApiService] 💾 Cached ${departures.length} departures');
      }
    } catch (e) {
      if (AppConstants.enableDebugLogs) {
        debugPrint('[ApiService] ⚠️ Cache write error: $e');
      }
    }

    return departures;
  }

  /// Recherche des gares par nom (autocomplete)
  Future<List<Station>> searchStations(String query, {int limit = 10}) async {
    if (query.length < 2) {
      return [];
    }

    final jsonData = await _get(
      'coverage/${NavitiaConfig.coverage}/places',
      queryParameters: {
        'q': query,
        'type[]': 'stop_area',
        'count': limit.toString(),
      },
    );

    final response = NavitiaResponse.fromJson(jsonData);
    final stations = _mapStations(response.places ?? []);

    if (AppConstants.enableDebugLogs) {
      debugPrint('[ApiService] Found ${stations.length} stations');
    }

    return stations;
  }

  // --- MAPPING METHODS ---

  List<Station> _mapStations(List<NavitiaPlace> places) {
    final stations = <Station>[];

    for (final place in places) {
      try {
        if (place.embeddedType != 'stop_area') continue;

        final stopArea = place.stopArea;
        if (stopArea == null) continue;

        stations.add(Station(id: stopArea.id, name: stopArea.name));
      } catch (e) {
        if (AppConstants.enableDebugLogs) {
          debugPrint('[ApiService] Failed to map station: $e');
        }
      }
    }
    return stations;
  }

  // --- UTILS ---

  Future<void> clearTheoreticalCache() async {
    final prefs = await SharedPreferences.getInstance();
    for (final key in prefs.getKeys().where((k) => k.startsWith('journeys_'))) {
      await prefs.remove(key);
    }
  }

  Future<void> _pruneTheoreticalCache() async {
    final prefs = await SharedPreferences.getInstance();
    final cutoff = DateTime.now().subtract(const Duration(days: 2));
    for (final key in prefs.getKeys().where((k) => k.startsWith('journeys_'))) {
      final date = DateTime.tryParse(key.split('_').last);
      if (!key.startsWith('journeys_v3_') ||
          date == null ||
          date.isBefore(cutoff)) {
        await prefs.remove(key);
      }
    }
  }

  String _getCacheKey(
    String fromStationId,
    String toStationId,
    String serviceDay,
  ) {
    final fromId = fromStationId.split(':').last;
    final toId = toStationId.split(':').last;
    return 'journeys_v3_${fromId}_${toId}_$serviceDay';
  }

  String _formatNavitiaDateTime(DateTime datetime) {
    return '${datetime.year}'
        '${datetime.month.toString().padLeft(2, '0')}'
        '${datetime.day.toString().padLeft(2, '0')}'
        'T'
        '${datetime.hour.toString().padLeft(2, '0')}'
        '${datetime.minute.toString().padLeft(2, '0')}'
        '${datetime.second.toString().padLeft(2, '0')}';
  }

  void dispose() {
    _client.close();
  }
}
