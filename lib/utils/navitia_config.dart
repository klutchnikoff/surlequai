import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Configuration pour l'API Navitia (SNCF)
///
/// Gère l'authentification et les URLs de base pour les appels API
/// Supporte BYOK (Bring Your Own Key) pour les utilisateurs avancés
class NavitiaConfig {
  // Empêche l'instanciation
  NavitiaConfig._();

  /// Clé API Navitia par défaut (chargée depuis .env)
  static String get apiKey => dotenv.env['NAVITIA_API_KEY'] ?? '';

  /// URL de base de l'API SNCF/Navitia DIRECTE
  static const String directApiUrl = 'https://api.sncf.com/v1';

  /// URL de base du proxy Cloudflare (quand déployé)
  /// TODO: Mettre l'URL réelle après déploiement
  static const String proxyUrl = 'https://proxy.surlequai.app/api';

  /// Coverage SNCF (pour les requêtes spécifiques TER)
  static const String coverage = 'sncf';

  /// Vérifie si la clé API par défaut est configurée
  static bool get isConfigured => apiKey.isNotEmpty;

  /// Retourne l'URL de base à utiliser selon le mode (BYOK ou proxy)
  ///
  /// [useCustomKey] : Si true, utilise l'API directe (BYOK activé)
  /// [useCustomKey] : Si false, utilise le proxy (mode par défaut)
  static String getBaseUrl({required bool useCustomKey}) {
    return useCustomKey ? directApiUrl : proxyUrl;
  }

  /// Headers d'authentification pour les requêtes HTTP
  ///
  /// [customKey] : Clé API personnalisée (BYOK) si fournie
  /// Si customKey est fournie, utilise cette clé
  /// Sinon, utilise la clé par défaut du .env
  /// Si mode proxy (pas de customKey), pas besoin d'auth (géré par le proxy)
  static Map<String, String> getAuthHeaders({String? customKey}) {
    // Mode BYOK : utilise la clé personnalisée
    if (customKey != null && customKey.isNotEmpty) {
      final credentials = '$customKey:';
      final base64Credentials = base64.encode(utf8.encode(credentials));

      return {
        'Authorization': 'Basic $base64Credentials',
        'Content-Type': 'application/json',
      };
    }

    // Mode développement : utilise la clé .env (si disponible)
    if (isConfigured) {
      final credentials = '$apiKey:';
      final base64Credentials = base64.encode(utf8.encode(credentials));

      return {
        'Authorization': 'Basic $base64Credentials',
        'Content-Type': 'application/json',
      };
    }

    // Mode proxy : pas d'authentification (gérée par le proxy)
    return {
      'Content-Type': 'application/json',
    };
  }

  /// Headers d'authentification par défaut (compatibilité)
  static Map<String, String> get authHeaders => getAuthHeaders();

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
