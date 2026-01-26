import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:surlequai/models/departure.dart';
import 'package:surlequai/models/station.dart';
import 'package:surlequai/models/timetable_version.dart';
import 'package:surlequai/utils/constants.dart';
import 'package:surlequai/utils/navitia_config.dart';

/// Service d'accès à l'API SNCF via Navitia
///
/// Gère les appels HTTP vers l'API Navitia pour récupérer :
/// - Les départs en temps réel
/// - La recherche de gares
/// - Les versions de grilles horaires
///
/// Gestion d'erreurs incluse :
/// - SocketException : Pas de connexion réseau
/// - TimeoutException : Timeout API
/// - HttpException : Erreurs HTTP (401, 404, 500, etc.)
class ApiService {
  final http.Client _client;

  ApiService({http.Client? client}) : _client = client ?? http.Client();

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
      final url = Uri.parse(NavitiaConfig.departuresUrl(fromStationId)).replace(
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
          .get(url, headers: NavitiaConfig.authHeaders)
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
      final url = Uri.parse(NavitiaConfig.searchPlacesUrl(query)).replace(
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
          .get(url, headers: NavitiaConfig.authHeaders)
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
        // Vérifier si ce train va vers la destination souhaitée
        final route = depJson['route'] as Map<String, dynamic>?;
        final direction = route?['direction'] as Map<String, dynamic>?;
        final directionStopAreaId = direction?['id'] as String?;

        // Filtrer : garder seulement les trains qui vont vers toStationId
        // Navitia peut retourner le stop_point (quai) ou stop_area (gare)
        // On compare en retirant le préfixe stop_point: si présent
        if (directionStopAreaId != null) {
          final cleanDirectionId = directionStopAreaId.replaceFirst('stop_point:', 'stop_area:');
          final cleanToStationId = toStationId.replaceFirst('stop_point:', 'stop_area:');

          // Si les IDs ne matchent pas, on ignore ce départ
          if (!cleanDirectionId.contains(cleanToStationId.split(':').last) &&
              !cleanToStationId.contains(cleanDirectionId.split(':').last)) {
            if (AppConstants.enableDebugLogs) {
              print('[ApiService] Skipping train to $directionStopAreaId (looking for $toStationId)');
            }
            continue; // Train ne va pas vers la bonne destination
          }
        }

        // Extraire les données de départ
        final stopDateTime = depJson['stop_date_time'] as Map<String, dynamic>;
        final displayInfo =
            depJson['display_informations'] as Map<String, dynamic>?;

        // Filtrer par type de train : garder TER et Intercités
        // Exclut TGV (trop cher pour usage quotidien)
        final network = displayInfo?['network'] as String? ?? '';
        final networkUpper = network.toUpperCase();

        // Accepter : TER, Intercités
        // Rejeter : TGV, Ouigo, etc.
        final isTER = networkUpper.contains('TER');
        final isIntercites = networkUpper.contains('INTERCITÉS') ||
                            networkUpper.contains('INTERCITES');

        if (!isTER && !isIntercites) {
          if (AppConstants.enableDebugLogs) {
            print('[ApiService] Skipping train type: $network');
          }
          continue; // Ignorer TGV, Ouigo, etc.
        }

        // Heure de départ prévue
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
      print('[ApiService] Filtered to ${departures.length} TER departures going to destination');
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
