import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:surlequai/models/departure.dart';
import 'package:surlequai/models/station.dart';
import 'package:surlequai/models/timetable_version.dart';
import 'package:surlequai/services/api_key_service.dart';
import 'package:surlequai/utils/constants.dart';
import 'package:surlequai/utils/navitia_config.dart';

/// Service d'accès à l'API SNCF via Navitia
///
/// Gère les appels HTTP vers l'API Navitia pour récupérer :
/// - Les départs en temps réel
/// - La recherche de gares
/// - Les versions de grilles horaires
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

  ApiService({
    http.Client? client,
    ApiKeyService? apiKeyService,
  })  : _client = client ?? http.Client(),
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
    Map<String, String>? queryParameters,
  }) async {
    try {
      final baseUrl = NavitiaConfig.getBaseUrl(useCustomKey: _useCustomKey);
      
      // Construction de l'URL
      final uri = Uri.parse('$baseUrl/$endpoint').replace(
        queryParameters: queryParameters,
      );

      if (AppConstants.enableDebugLogs) {
        debugPrint('[ApiService] GET: $uri');
      }

      // Appel HTTP avec timeout
      final response = await _client
          .get(uri, headers: NavitiaConfig.getAuthHeaders(customKey: _customKey))
          .timeout(AppConstants.apiTimeout);

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else if (response.statusCode == 401) {
        throw const HttpException('Clé API invalide ou expirée');
      } else if (response.statusCode == 404) {
        // Pour une 404, on peut vouloir l'info de ce qui n'a pas été trouvé,
        // mais une exception générique suffit souvent.
        throw HttpException('Ressource non trouvée (404) : $uri');
      } else {
        throw HttpException(
            'Erreur API: ${response.statusCode} - ${response.body}');
      }
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

  /// Récupère la version actuelle de la grille horaire
  Future<TimetableVersion> getTimetableVersion({String? region}) async {
    // L'API Navitia ne fournit pas de metadata sur les versions
    // On retourne une version par défaut pour l'instant
    return TimetableVersion(
      version: '2026-current',
      region: region ?? 'france',
      validFrom: DateTime(2026, 1, 1),
      validUntil: DateTime(2026, 12, 31),
      downloadedAt: DateTime.now(),
      sizeBytes: null,
    );
  }

  /// Récupère les départs en temps réel entre deux gares
  Future<List<Departure>> getRealtimeDepartures({
    required String fromStationId,
    required String toStationId,
    required DateTime datetime,
    int count = 10,
  }) async {
    final jsonData = await _get(
      'coverage/${NavitiaConfig.coverage}/stop_areas/$fromStationId/departures',
      queryParameters: {
        'from_datetime': _formatNavitiaDateTime(datetime),
        'count': count.toString(),
        'data_freshness': 'realtime',
      },
    );

    final departures = _parseDepartures(jsonData, toStationId);

    if (AppConstants.enableDebugLogs) {
      debugPrint('[ApiService] Parsed ${departures.length} departures');
    }

    return departures;
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
      },
    );

    final departures = _parseJourneys(jsonData);

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
      },
    );

    final departures = _parseJourneys(jsonData);

    if (AppConstants.enableDebugLogs) {
      debugPrint('[ApiService] Parsed ${departures.length} theoretical schedules');
    }

    return departures;
  }

  /// Récupère les horaires théoriques avec cache (un appel API par jour maximum)
  Future<List<Departure>> getTheoreticalSchedule({
    required String fromStationId,
    required String toStationId,
    required DateTime datetime,
    int count = AppConstants.maxTrainsPerDay,
  }) async {
    // Calculer le jour de service (change à 4h du matin, pas à minuit)
    final serviceDay = _getServiceDay(datetime);
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
          debugPrint('[ApiService] ✅ Cache hit: ${departures.length} departures');
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
      debugPrint('[ApiService] ❌ Cache miss, fetching theoretical schedule from API');
    }

    final departures = await _fetchTheoreticalJourneys(
      fromStationId: fromStationId,
      toStationId: toStationId,
      datetime: datetime,
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

  String _getServiceDay(DateTime datetime) {
    final hour = datetime.hour;
    if (hour < AppConstants.defaultServiceDayStartHour) {
      final previousDay = datetime.subtract(const Duration(days: 1));
      return '${previousDay.year}-${previousDay.month.toString().padLeft(2, '0')}-${previousDay.day.toString().padLeft(2, '0')}';
    }
    return '${datetime.year}-${datetime.month.toString().padLeft(2, '0')}-${datetime.day.toString().padLeft(2, '0')}';
  }

  String _getCacheKey(String fromStationId, String toStationId, String serviceDay) {
    final fromId = fromStationId.split(':').last;
    final toId = toStationId.split(':').last;
    return 'journeys_${fromId}_${toId}_$serviceDay';
  }

  /// Recherche des gares par nom (autocomplete)
  Future<List<Station>> searchStations(
    String query,
    {
    int limit = 10,
  }) async {
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

    final stations = _parseStations(jsonData);

    if (AppConstants.enableDebugLogs) {
      debugPrint('[ApiService] Found ${stations.length} stations');
    }

    return stations;
  }

  /// Parse les départs depuis la réponse JSON Navitia
  List<Departure> _parseDepartures(
    Map<String, dynamic> jsonData,
    String toStationId,
  ) {
    final departuresList = jsonData['departures'] as List<dynamic>? ?? [];
    final departures = <Departure>[];

    for (final depJson in departuresList) {
      try {
        final stopDateTime = depJson['stop_date_time'] as Map<String, dynamic>;
        final displayInfo = depJson['display_informations'] as Map<String, dynamic>?;
        final network = displayInfo?['network'] as String? ?? 'unknown';

        final networkUpper = network.toUpperCase();
        final isExpensiveTrain = networkUpper.contains('TGV') ||
                                networkUpper.contains('OUIGO') ||
                                networkUpper.contains('TRANSILIEN');

        if (isExpensiveTrain) {
          continue;
        }

        final baseDateTime = stopDateTime['base_departure_date_time'] as String;
        final scheduledTime = _parseNavitiaDateTime(baseDateTime);

        final actualDateTime = stopDateTime['departure_date_time'] as String;
        final actualTime = _parseNavitiaDateTime(actualDateTime);

        final delayMinutes = actualTime.difference(scheduledTime).inMinutes;

        DepartureStatus status;
        if (stopDateTime['data_freshness'] == 'base_schedule' ||
            delayMinutes == 0) {
          status = DepartureStatus.onTime;
        } else if (delayMinutes > 0) {
          status = DepartureStatus.delayed;
        } else {
          status = DepartureStatus.onTime;
        }

        final platform = stopDateTime['platform'] as String? ?? '?';

        final tripId = depJson['display_informations']?['trip_short_name'] ??
            depJson['route']?['id'] ??
            'unknown';

        departures.add(Departure(
          id: '$tripId-${scheduledTime.millisecondsSinceEpoch}',
          scheduledTime: scheduledTime,
          platform: platform,
          status: status,
          delayMinutes: delayMinutes.abs(),
        ));
      } catch (e) {
        if (AppConstants.enableDebugLogs) {
          debugPrint('[ApiService] Failed to parse departure: $e');
        }
      }
    }
    return departures;
  }

  /// Parse les itinéraires depuis la réponse JSON Navitia
  List<Departure> _parseJourneys(Map<String, dynamic> jsonData) {
    final journeysList = jsonData['journeys'] as List<dynamic>? ?? [];
    final departures = <Departure>[];

    for (final journeyJson in journeysList) {
      try {
        final nbTransfers = journeyJson['nb_transfers'] as int? ?? 0;
        if (nbTransfers != 0) continue;

        final sections = journeyJson['sections'] as List<dynamic>? ?? [];
        if (sections.isEmpty) continue;

        final trainSection = sections.firstWhere(
          (s) => s['type'] == 'public_transport',
          orElse: () => null,
        );

        if (trainSection == null) continue;

        final displayInfo = trainSection['display_informations'] as Map<String, dynamic>?;
        if (displayInfo == null) continue;

        final network = displayInfo['network'] as String? ?? 'unknown';
        final networkUpper = network.toUpperCase();
        final isExpensiveTrain = networkUpper.contains('TGV') ||
                                networkUpper.contains('OUIGO') ||
                                networkUpper.contains('TRANSILIEN');

        if (isExpensiveTrain) {
          continue;
        }

        final departureDateTime = trainSection['departure_date_time'] as String;
        final scheduledTime = _parseNavitiaDateTime(departureDateTime);

        final baseDepartureDateTime = trainSection['base_departure_date_time'] as String?;
        final baseScheduledTime = baseDepartureDateTime != null
            ? _parseNavitiaDateTime(baseDepartureDateTime)
            : scheduledTime;

        final arrivalDateTime = trainSection['arrival_date_time'] as String;
        final arrivalTime = _parseNavitiaDateTime(arrivalDateTime);

        final durationMinutes = arrivalTime.difference(scheduledTime).inMinutes;
        final delayMinutes = scheduledTime.difference(baseScheduledTime).inMinutes;

        DepartureStatus status;
        if (trainSection['data_freshness'] == 'base_schedule' || delayMinutes == 0) {
          status = DepartureStatus.onTime;
        } else if (delayMinutes > 0) {
          status = DepartureStatus.delayed;
        } else {
          status = DepartureStatus.onTime;
        }

        final stopDateTime = trainSection['stop_date_times'] as List<dynamic>? ?? [];
        final firstStop = stopDateTime.isNotEmpty ? stopDateTime.first : null;
        final platform = firstStop?['departure_stop_point']?['platform'] as String? ?? '?';

        final tripId = displayInfo['trip_short_name'] ??
                      trainSection['id'] ??
                      'unknown';

        departures.add(Departure(
          id: '$tripId-${scheduledTime.millisecondsSinceEpoch}',
          scheduledTime: scheduledTime,
          platform: platform,
          status: status,
          delayMinutes: delayMinutes.abs(),
          durationMinutes: durationMinutes,
        ));
      } catch (e) {
        if (AppConstants.enableDebugLogs) {
          debugPrint('[ApiService] Failed to parse journey: $e');
        }
      }
    }
    return departures;
  }

  /// Parse les gares depuis la réponse JSON Navitia
  List<Station> _parseStations(Map<String, dynamic> jsonData) {
    final placesList = jsonData['places'] as List<dynamic>? ?? [];
    final stations = <Station>[];

    for (final placeJson in placesList) {
      try {
        if (placeJson['embedded_type'] != 'stop_area') continue;

        final stopArea = placeJson['stop_area'] as Map<String, dynamic>?;
        if (stopArea == null) continue;

        final id = stopArea['id'] as String;
        final name = stopArea['name'] as String;

        stations.add(Station(id: id, name: name));
      } catch (e) {
        if (AppConstants.enableDebugLogs) {
          debugPrint('[ApiService] Failed to parse station: $e');
        }
      }
    }
    return stations;
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

  DateTime _parseNavitiaDateTime(String navitiaDate) {
    final year = int.parse(navitiaDate.substring(0, 4));
    final month = int.parse(navitiaDate.substring(4, 6));
    final day = int.parse(navitiaDate.substring(6, 8));
    final hour = int.parse(navitiaDate.substring(9, 11));
    final minute = int.parse(navitiaDate.substring(11, 13));
    final second = int.parse(navitiaDate.substring(13, 15));

    return DateTime(year, month, day, hour, minute, second);
  }

  Future<List<int>> downloadTimetable({
    required String version,
    String? region,
  }) async {
    throw UnimplementedError(
        'Téléchargement GTFS non disponible avec Navitia. '
        'Utilisez les données temps réel uniquement.');
  }

  void dispose() {
    _client.close();
  }
}