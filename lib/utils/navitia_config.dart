import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Configuration pour l'API Navitia (SNCF)
///
/// Gère l'authentification et les URLs de base pour les appels API
class NavitiaConfig {
  // Empêche l'instanciation
  NavitiaConfig._();

  /// Clé API Navitia (chargée depuis .env)
  static String get apiKey => dotenv.env['NAVITIA_API_KEY'] ?? '';

  /// URL de base de l'API SNCF/Navitia
  static String get baseUrl =>
      dotenv.env['NAVITIA_API_BASE_URL'] ?? 'https://api.sncf.com/v1';

  /// Coverage SNCF (pour les requêtes spécifiques TER)
  static const String coverage = 'sncf';

  /// Vérifie si la clé API est configurée
  static bool get isConfigured => apiKey.isNotEmpty;

  /// Headers d'authentification pour les requêtes HTTP
  /// Navitia utilise HTTP Basic Auth avec la clé API comme username
  static Map<String, String> get authHeaders {
    if (!isConfigured) {
      throw Exception(
          'Clé API Navitia non configurée. Créez un fichier .env avec NAVITIA_API_KEY');
    }

    // Encode la clé API en Base64 pour HTTP Basic Auth
    // Format: "Basic base64(api_key:)"
    final credentials = '$apiKey:';
    final base64Credentials = base64.encode(utf8.encode(credentials));

    return {
      'Authorization': 'Basic $base64Credentials',
      'Content-Type': 'application/json',
    };
  }

  /// Construit l'URL complète pour un endpoint
  static String buildUrl(String endpoint) {
    return '$baseUrl/$endpoint';
  }

  /// URL pour la recherche de gares
  static String searchPlacesUrl(String query) {
    return buildUrl('coverage/$coverage/places?q=$query&type[]=stop_area');
  }

  /// URL pour les départs depuis une gare
  static String departuresUrl(String stopAreaId) {
    return buildUrl('coverage/$coverage/stop_areas/$stopAreaId/departures');
  }

  /// URL pour les itinéraires entre deux gares
  static String journeysUrl() {
    return buildUrl('coverage/$coverage/journeys');
  }
}
