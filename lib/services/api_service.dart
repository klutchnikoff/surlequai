import 'dart:async';
import 'dart:convert';
import 'dart:io';
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

  /// Construit l'URL complète selon le mode (BYOK ou proxy)
  String _buildUrl(String endpoint) {
    final baseUrl = NavitiaConfig.getBaseUrl(useCustomKey: _useCustomKey);
    return '$baseUrl/$endpoint';
  }

  /// Récupère les headers d'authentification selon le mode
  Map<String, String> _getHeaders() {
    return NavitiaConfig.getAuthHeaders(customKey: _customKey);
  }

  /// Récupère la version actuelle de la grille horaire
  ///
  /// Note : Navitia ne fournit pas directement cette info
  /// Pour l'instant, on retourne une version fictive
  /// TODO: Implémenter un endpoint custom si nécessaire
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
  ///
  /// [fromStationId] : ID de la gare de départ (format Navitia: stop_area:xxx)
  /// [toStationId] : ID de la gare d'arrivée (pour filtrer les directions)
  /// [datetime] : Date/heure de référence pour les départs
  /// [count] : Nombre maximum de départs à récupérer
  ///
  /// Retourne une liste de Departure avec statut temps réel (onTime/delayed/cancelled)
  Future<List<Departure>> getRealtimeDepartures({
    required String fromStationId,
    required String toStationId,
    required DateTime datetime,
    int count = 10,
  }) async {
    try {
      // Construction de l'URL avec paramètres
      final url = Uri.parse(_buildUrl('coverage/${NavitiaConfig.coverage}/stop_areas/$fromStationId/departures')).replace(
        queryParameters: {
          'from_datetime': _formatNavitiaDateTime(datetime),
          'count': count.toString(),
          'data_freshness': 'realtime', // Force les données temps réel
        },
      );

      if (AppConstants.enableDebugLogs) {
        print('[ApiService] Fetching departures: $url');
      }

      // Appel HTTP avec timeout
      final response = await _client
          .get(url, headers: _getHeaders())
          .timeout(AppConstants.apiTimeout);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as Map<String, dynamic>;
        final departures = _parseDepartures(jsonData, toStationId);

        if (AppConstants.enableDebugLogs) {
          print('[ApiService] Parsed ${departures.length} departures');
        }

        return departures;
      } else if (response.statusCode == 401) {
        throw HttpException('Clé API invalide ou expirée');
      } else if (response.statusCode == 404) {
        throw HttpException('Gare non trouvée: $fromStationId');
      } else {
        throw HttpException(
            'Erreur API: ${response.statusCode} - ${response.body}');
      }
    } on SocketException {
      // Pas de connexion réseau
      throw SocketException('Pas de connexion Internet');
    } on TimeoutException {
      // Timeout API
      throw TimeoutException('Délai d\'attente dépassé');
    } catch (e) {
      if (AppConstants.enableDebugLogs) {
        print('[ApiService] Error: $e');
      }
      rethrow;
    }
  }

  /// Récupère les itinéraires directs entre deux gares (trains sans correspondance)
  ///
  /// [fromStationId] : ID de la gare de départ (format Navitia: stop_area:xxx)
  /// [toStationId] : ID de la gare d'arrivée
  /// [datetime] : Date/heure de référence pour les départs
  /// [count] : Nombre maximum d'itinéraires à récupérer
  ///
  /// Retourne une liste de Departure correspondant aux trains directs uniquement
  Future<List<Departure>> getDirectJourneys({
    required String fromStationId,
    required String toStationId,
    required DateTime datetime,
    int count = 10,
  }) async {
    try {
      // Construction de l'URL avec paramètres
      final url = Uri.parse(_buildUrl('coverage/${NavitiaConfig.coverage}/journeys')).replace(
        queryParameters: {
          'from': fromStationId,
          'to': toStationId,
          'datetime': _formatNavitiaDateTime(datetime),
          'count': count.toString(),
          'data_freshness': 'realtime', // Force les données temps réel
          'min_nb_journeys': count.toString(),
          'max_nb_transfers': '0', // Trains directs uniquement
        },
      );

      if (AppConstants.enableDebugLogs) {
        print('[ApiService] Fetching journeys: $url');
      }

      // Appel HTTP avec timeout
      final response = await _client
          .get(url, headers: _getHeaders())
          .timeout(AppConstants.apiTimeout);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as Map<String, dynamic>;
        final departures = _parseJourneys(jsonData);

        if (AppConstants.enableDebugLogs) {
          print('[ApiService] Parsed ${departures.length} direct journeys');
        }

        return departures;
      } else if (response.statusCode == 401) {
        throw HttpException('Clé API invalide ou expirée');
      } else if (response.statusCode == 404) {
        throw HttpException('Gare non trouvée: $fromStationId ou $toStationId');
      } else {
        throw HttpException(
            'Erreur API: ${response.statusCode} - ${response.body}');
      }
    } on SocketException {
      // Pas de connexion réseau
      throw SocketException('Pas de connexion Internet');
    } on TimeoutException {
      // Timeout API
      throw TimeoutException('Délai d\'attente dépassé');
    } catch (e) {
      if (AppConstants.enableDebugLogs) {
        print('[ApiService] Error: $e');
      }
      rethrow;
    }
  }

  /// Récupère les horaires théoriques (sans temps réel) - méthode interne
  ///
  /// Identique à getDirectJourneys() mais avec data_freshness=base_schedule
  /// Utilisé par getTheoreticalSchedule() pour le cache
  Future<List<Departure>> _fetchTheoreticalJourneys({
    required String fromStationId,
    required String toStationId,
    required DateTime datetime,
    int count = AppConstants.maxTrainsPerDay,
  }) async {
    try {
      // Construction de l'URL avec paramètres
      final url = Uri.parse(_buildUrl('coverage/${NavitiaConfig.coverage}/journeys')).replace(
        queryParameters: {
          'from': fromStationId,
          'to': toStationId,
          'datetime': _formatNavitiaDateTime(datetime),
          'count': count.toString(),
          'data_freshness': 'base_schedule', // ⚠️ Horaires théoriques uniquement
          'max_nb_transfers': '0', // Trains directs uniquement
        },
      );

      if (AppConstants.enableDebugLogs) {
        print('[ApiService] Fetching theoretical schedule: $url');
      }

      // Appel HTTP avec timeout
      final response = await _client
          .get(url, headers: _getHeaders())
          .timeout(AppConstants.apiTimeout);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as Map<String, dynamic>;
        final departures = _parseJourneys(jsonData);

        if (AppConstants.enableDebugLogs) {
          print('[ApiService] Parsed ${departures.length} theoretical schedules');
        }

        return departures;
      } else if (response.statusCode == 401) {
        throw HttpException('Clé API invalide ou expirée');
      } else if (response.statusCode == 404) {
        throw HttpException('Gare non trouvée: $fromStationId ou $toStationId');
      } else {
        throw HttpException(
            'Erreur API: ${response.statusCode} - ${response.body}');
      }
    } on SocketException {
      // Pas de connexion réseau
      throw SocketException('Pas de connexion Internet');
    } on TimeoutException {
      // Timeout API
      throw TimeoutException('Délai d\'attente dépassé');
    } catch (e) {
      if (AppConstants.enableDebugLogs) {
        print('[ApiService] Error: $e');
      }
      rethrow;
    }
  }

  /// Récupère les horaires théoriques avec cache (un appel API par jour maximum)
  ///
  /// Utilisé pour la modale "Fiche horaire" : affiche les horaires théoriques
  /// (pas de temps réel) avec cache journalier.
  ///
  /// [count] : Nombre de trains à récupérer (défini par AppConstants.maxTrainsPerDay)
  ///
  /// Vérifie d'abord le cache SharedPreferences.
  /// Si le cache est valide (même jour de service), le retourne.
  /// Sinon, appelle l'API avec data_freshness=base_schedule et met à jour le cache.
  ///
  /// Le jour de service démarre à 4h du matin (AppConstants.defaultServiceDayStartHour)
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
      print('[ApiService] Cache key: $cacheKey');
    }

    // Vérifier le cache
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedJson = prefs.getString(cacheKey);

      if (cachedJson != null) {
        // Cache trouvé, parser et retourner
        // Maintenant qu'on utilise toujours maxTrainsPerDay, pas besoin de vérifier la taille
        // (le filtrage par jour se fait côté client dans la modale)
        final List<dynamic> jsonList = json.decode(cachedJson);
        final departures = jsonList.map((j) => Departure.fromJson(j)).toList();

        if (AppConstants.enableDebugLogs) {
          print('[ApiService] ✅ Cache hit: ${departures.length} departures');
        }

        return departures;
      }
    } catch (e) {
      if (AppConstants.enableDebugLogs) {
        print('[ApiService] ⚠️ Cache read error: $e');
      }
      // Continue avec l'appel API si erreur de cache
    }

    // Cache manquant ou invalide → appel API (horaires théoriques)
    if (AppConstants.enableDebugLogs) {
      print('[ApiService] ❌ Cache miss, fetching theoretical schedule from API');
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
      final jsonString = json.encode(jsonList);
      await prefs.setString(cacheKey, jsonString);

      if (AppConstants.enableDebugLogs) {
        print('[ApiService] 💾 Cached ${departures.length} departures');
      }
    } catch (e) {
      if (AppConstants.enableDebugLogs) {
        print('[ApiService] ⚠️ Cache write error: $e');
      }
      // Ne pas bloquer si erreur de cache
    }

    return departures;
  }

  /// Calcule le jour de service actuel
  ///
  /// Le jour de service change à 4h du matin (pas à minuit).
  /// Exemple : 2h du matin le 27/01 → jour de service = 26/01
  String _getServiceDay(DateTime datetime) {
    final hour = datetime.hour;

    // Si avant 4h du matin, on est encore dans le jour de service précédent
    if (hour < AppConstants.defaultServiceDayStartHour) {
      final previousDay = datetime.subtract(const Duration(days: 1));
      return '${previousDay.year}-${previousDay.month.toString().padLeft(2, '0')}-${previousDay.day.toString().padLeft(2, '0')}';
    }

    return '${datetime.year}-${datetime.month.toString().padLeft(2, '0')}-${datetime.day.toString().padLeft(2, '0')}';
  }

  /// Génère la clé de cache pour un trajet et un jour de service
  String _getCacheKey(String fromStationId, String toStationId, String serviceDay) {
    // Nettoyer les IDs pour le cache (enlever le préfixe stop_area:)
    final fromId = fromStationId.split(':').last;
    final toId = toStationId.split(':').last;
    return 'journeys_${fromId}_${toId}_$serviceDay';
  }

  /// Recherche des gares par nom (autocomplete)
  ///
  /// [query] : Terme de recherche (ex: "renn" pour Rennes)
  /// [limit] : Nombre maximum de résultats
  ///
  /// Retourne une liste de Station correspondant à la recherche
  Future<List<Station>> searchStations(
    String query, {
    int limit = 10,
  }) async {
    if (query.length < 2) {
      return []; // Minimum 2 caractères pour la recherche
    }

    try {
      // URL de recherche avec filtrage sur stop_area (gares)
      final url = Uri.parse(_buildUrl('coverage/${NavitiaConfig.coverage}/places')).replace(
        queryParameters: {
          'q': query,
          'type[]': 'stop_area',
          'count': limit.toString(),
        },
      );

      if (AppConstants.enableDebugLogs) {
        print('[ApiService] Searching stations: $url');
      }

      final response = await _client
          .get(url, headers: _getHeaders())
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as Map<String, dynamic>;
        final stations = _parseStations(jsonData);

        if (AppConstants.enableDebugLogs) {
          print('[ApiService] Found ${stations.length} stations');
        }

        return stations;
      } else {
        throw HttpException('Erreur recherche: ${response.statusCode}');
      }
    } on SocketException {
      throw SocketException('Pas de connexion Internet');
    } on TimeoutException {
      throw TimeoutException('Délai d\'attente dépassé');
    } catch (e) {
      if (AppConstants.enableDebugLogs) {
        print('[ApiService] Search error: $e');
      }
      rethrow;
    }
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
        // Extraire les infos de base
        final stopDateTime = depJson['stop_date_time'] as Map<String, dynamic>;
        final displayInfo = depJson['display_informations'] as Map<String, dynamic>?;
        final route = depJson['route'] as Map<String, dynamic>?;
        final direction = route?['direction'] as Map<String, dynamic>?;
        final directionName = direction?['name'] as String? ?? 'unknown';
        final network = displayInfo?['network'] as String? ?? 'unknown';

        // ⚠️ FILTRE DESTINATION TEMPORAIREMENT DÉSACTIVÉ
        // Pour tester avec des gares intermédiaires (ex: Rennes → Bruz → Nantes)
        // Le filtre par terminus strict ne fonctionne pas pour ces cas
        //
        // TODO: Implémenter une vraie vérification avec /journeys ou liste des arrêts

        // Filtrer par type de train : rejeter uniquement les trains chers/rapides
        // Stratégie : Liste noire plutôt que liste blanche
        // On rejette : TGV (cher), Ouigo (cher), Transilien (banlieue parisienne)
        // On accepte : TER (toutes marques régionales), Intercités, etc.
        final networkUpper = network.toUpperCase();

        // Rejeter les trains chers et de banlieue
        final isExpensiveTrain = networkUpper.contains('TGV') ||
                                networkUpper.contains('OUIGO') ||
                                networkUpper.contains('TRANSILIEN');

        if (isExpensiveTrain) {
          continue; // Ignorer TGV, Ouigo, Transilien
        }

        // Heure de départ prévue (scheduled)
        final baseDateTime = stopDateTime['base_departure_date_time'] as String;
        final scheduledTime = _parseNavitiaDateTime(baseDateTime);

        // Heure de départ réelle (avec retard si applicable)
        final actualDateTime = stopDateTime['departure_date_time'] as String;
        final actualTime = _parseNavitiaDateTime(actualDateTime);

        // Calcul du retard en minutes
        final delayMinutes = actualTime.difference(scheduledTime).inMinutes;

        // Déterminer le statut
        DepartureStatus status;
        if (stopDateTime['data_freshness'] == 'base_schedule' ||
            delayMinutes == 0) {
          status = DepartureStatus.onTime;
        } else if (delayMinutes > 0) {
          status = DepartureStatus.delayed;
        } else {
          status = DepartureStatus.onTime; // Avance rare mais possible
        }

        // Vérifier si le train est supprimé (disruptions)
        // TODO: Implémenter la vérification des disruptions
        // Pour l'instant on suppose qu'il n'y a pas de trains supprimés

        // Voie (si disponible)
        final platform = stopDateTime['platform'] as String? ?? '?';

        // ID unique du départ
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
          print('[ApiService] Failed to parse departure: $e');
        }
        // Continue avec les autres départs
      }
    }

    if (AppConstants.enableDebugLogs) {
      print('[ApiService] Parsed ${departures.length} departures (TGV/Ouigo/Transilien exclus)');
    }

    return departures;
  }

  /// Parse les itinéraires depuis la réponse JSON Navitia
  List<Departure> _parseJourneys(Map<String, dynamic> jsonData) {
    final journeysList = jsonData['journeys'] as List<dynamic>? ?? [];
    final departures = <Departure>[];

    for (final journeyJson in journeysList) {
      try {
        // Vérifier qu'il n'y a pas de correspondances
        final nbTransfers = journeyJson['nb_transfers'] as int? ?? 0;
        if (nbTransfers != 0) {
          continue; // Ignorer les trajets avec correspondances
        }

        // Extraire la section (il n'y en a qu'une pour un trajet direct)
        final sections = journeyJson['sections'] as List<dynamic>? ?? [];
        if (sections.isEmpty) continue;

        // Trouver la section de type "public_transport" (le train)
        final trainSection = sections.firstWhere(
          (s) => s['type'] == 'public_transport',
          orElse: () => null,
        );

        if (trainSection == null) continue;

        // Informations d'affichage du train
        final displayInfo = trainSection['display_informations'] as Map<String, dynamic>?;
        if (displayInfo == null) continue;

        final network = displayInfo['network'] as String? ?? 'unknown';

        // Filtrer par type de train (rejeter TGV, Ouigo, Transilien)
        final networkUpper = network.toUpperCase();
        final isExpensiveTrain = networkUpper.contains('TGV') ||
                                networkUpper.contains('OUIGO') ||
                                networkUpper.contains('TRANSILIEN');

        if (isExpensiveTrain) {
          continue;
        }

        // Informations de départ
        final departureDateTime = trainSection['departure_date_time'] as String;
        final scheduledTime = _parseNavitiaDateTime(departureDateTime);

        final baseDepartureDateTime = trainSection['base_departure_date_time'] as String?;
        final baseScheduledTime = baseDepartureDateTime != null
            ? _parseNavitiaDateTime(baseDepartureDateTime)
            : scheduledTime;

        // Informations d'arrivée
        final arrivalDateTime = trainSection['arrival_date_time'] as String;
        final arrivalTime = _parseNavitiaDateTime(arrivalDateTime);

        // Calcul de la durée du trajet
        final durationMinutes = arrivalTime.difference(scheduledTime).inMinutes;

        // Calcul du retard
        final delayMinutes = scheduledTime.difference(baseScheduledTime).inMinutes;

        // Déterminer le statut
        DepartureStatus status;
        if (trainSection['data_freshness'] == 'base_schedule' || delayMinutes == 0) {
          status = DepartureStatus.onTime;
        } else if (delayMinutes > 0) {
          status = DepartureStatus.delayed;
        } else {
          status = DepartureStatus.onTime;
        }

        // Voie de départ
        final stopDateTime = trainSection['stop_date_times'] as List<dynamic>? ?? [];
        final firstStop = stopDateTime.isNotEmpty ? stopDateTime.first : null;
        final platform = firstStop?['departure_stop_point']?['platform'] as String? ?? '?';

        // ID unique
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
          print('[ApiService] Failed to parse journey: $e');
        }
        // Continue avec les autres journeys
      }
    }

    if (AppConstants.enableDebugLogs) {
      print('[ApiService] Filtered to ${departures.length} direct journeys (TGV/Ouigo/Transilien exclus)');
    }

    return departures;
  }

  /// Parse les gares depuis la réponse JSON Navitia
  List<Station> _parseStations(Map<String, dynamic> jsonData) {
    final placesList = jsonData['places'] as List<dynamic>? ?? [];
    final stations = <Station>[];

    for (final placeJson in placesList) {
      try {
        // Vérifier que c'est bien une stop_area (gare)
        if (placeJson['embedded_type'] != 'stop_area') continue;

        final stopArea = placeJson['stop_area'] as Map<String, dynamic>?;
        if (stopArea == null) continue;

        final id = stopArea['id'] as String;
        final name = stopArea['name'] as String;

        stations.add(Station(id: id, name: name));
      } catch (e) {
        if (AppConstants.enableDebugLogs) {
          print('[ApiService] Failed to parse station: $e');
        }
      }
    }

    return stations;
  }

  /// Formate un DateTime au format Navitia (YYYYMMDDTHHmmss)
  String _formatNavitiaDateTime(DateTime datetime) {
    return '${datetime.year}'
        '${datetime.month.toString().padLeft(2, '0')}'
        '${datetime.day.toString().padLeft(2, '0')}'
        'T'
        '${datetime.hour.toString().padLeft(2, '0')}'
        '${datetime.minute.toString().padLeft(2, '0')}'
        '${datetime.second.toString().padLeft(2, '0')}';
  }

  /// Parse une date Navitia (YYYYMMDDTHHmmss) vers DateTime
  DateTime _parseNavitiaDateTime(String navitiaDate) {
    // Format: 20260126T143000
    final year = int.parse(navitiaDate.substring(0, 4));
    final month = int.parse(navitiaDate.substring(4, 6));
    final day = int.parse(navitiaDate.substring(6, 8));
    final hour = int.parse(navitiaDate.substring(9, 11));
    final minute = int.parse(navitiaDate.substring(11, 13));
    final second = int.parse(navitiaDate.substring(13, 15));

    return DateTime(year, month, day, hour, minute, second);
  }

  /// Télécharge une grille horaire complète (non implémenté pour Navitia)
  ///
  /// Note: Navitia ne fournit pas de téléchargement GTFS direct
  /// Cette fonctionnalité nécessiterait un backend custom
  Future<List<int>> downloadTimetable({
    required String version,
    String? region,
  }) async {
    throw UnimplementedError(
        'Téléchargement GTFS non disponible avec Navitia. '
        'Utilisez les données temps réel uniquement.');
  }

  /// Ferme le client HTTP
  void dispose() {
    _client.close();
  }
}
