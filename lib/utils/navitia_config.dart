import 'dart:convert';

/// Configuration pour l'API Navitia (SNCF)
///
/// Gère l'authentification et les URLs de base pour les appels API
/// Supporte BYOK (Bring Your Own Key) pour les utilisateurs avancés
class NavitiaConfig {
  // Empêche l'instanciation
  NavitiaConfig._();

  /// URL de base de l'API SNCF/Navitia DIRECTE
  static const String directApiUrl = 'https://api.sncf.com/v1';

  /// URL de base du proxy Cloudflare Worker
  static const String proxyUrl = 'https://surlequai.nicolas-klutchnikoff.workers.dev';

  /// Coverage SNCF (pour les requêtes spécifiques TER)
  static const String coverage = 'sncf';

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
  /// Si customKey est fournie, utilise cette clé pour l'auth Basic
  /// Sinon (mode proxy par défaut), pas d'auth (gérée par le proxy)
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

    // Mode proxy par défaut : pas d'authentification (gérée par le proxy)
    return {
      'Content-Type': 'application/json',
    };
  }

  /// Headers d'authentification par défaut (compatibilité)
  @Deprecated('Use getAuthHeaders() with customKey parameter instead')
  static Map<String, String> get authHeaders => getAuthHeaders();
}
