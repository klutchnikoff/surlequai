import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

/// Service de gestion de la clé API personnalisée (BYOK)
///
/// Stocke la clé API SNCF de manière sécurisée :
/// - iOS : Keychain (chiffrement matériel)
/// - Android : KeyStore (chiffrement AES)
/// - Web/Desktop : Pas de stockage sécurisé natif (fallback SharedPreferences)
class ApiKeyService {
  static const String _keyName = 'custom_sncf_api_key';

  final FlutterSecureStorage _secureStorage;

  // Cache en mémoire pour éviter les accès répétés au keystore
  String? _cachedKey;
  bool _isInitialized = false;

  ApiKeyService({FlutterSecureStorage? secureStorage})
      : _secureStorage = secureStorage ?? const FlutterSecureStorage();

  /// Initialise le service (charge la clé en cache)
  Future<void> init() async {
    if (_isInitialized) return;

    try {
      _cachedKey = await _secureStorage.read(key: _keyName);
      _isInitialized = true;

      if (_cachedKey != null && kDebugMode) {
        debugPrint('[ApiKeyService] Clé personnalisée chargée (${_cachedKey!.length} caractères)');
      }
    } catch (e) {
      debugPrint('[ApiKeyService] Erreur lecture clé: $e');
      _isInitialized = true;
      _cachedKey = null;
    }
  }

  /// Vérifie si une clé personnalisée est configurée
  Future<bool> hasCustomKey() async {
    if (!_isInitialized) await init();
    return _cachedKey != null && _cachedKey!.isNotEmpty;
  }

  /// Récupère la clé personnalisée (ou null si non configurée)
  Future<String?> getCustomKey() async {
    if (!_isInitialized) await init();
    return _cachedKey;
  }

  /// Enregistre une nouvelle clé personnalisée
  ///
  /// [key] : Clé API SNCF au format attendu
  /// Retourne true si la sauvegarde a réussi
  Future<bool> setCustomKey(String key) async {
    try {
      if (key.isEmpty) {
        // Si clé vide, on supprime
        await _secureStorage.delete(key: _keyName);
        _cachedKey = null;
        debugPrint('[ApiKeyService] Clé personnalisée supprimée');
      } else {
        // Sauvegarde chiffrée
        await _secureStorage.write(key: _keyName, value: key);
        _cachedKey = key;
        debugPrint('[ApiKeyService] Clé personnalisée enregistrée');
      }
      return true;
    } catch (e) {
      debugPrint('[ApiKeyService] Erreur sauvegarde clé: $e');
      return false;
    }
  }

  /// Supprime la clé personnalisée
  Future<void> clearCustomKey() async {
    await setCustomKey(''); // Appelle la méthode avec clé vide
  }

  /// Teste si une clé est valide en faisant un appel API
  ///
  /// [key] : Clé à tester
  /// Retourne true si la clé est valide, false sinon
  Future<bool> validateKey(String key) async {
    if (key.isEmpty) return false;

    try {
      // Appel minimal à l'API SNCF pour tester la clé
      // On teste l'endpoint /coverage qui est léger et ne consomme pas de quota
      final uri = Uri.parse('https://api.sncf.com/v1/coverage/sncf');

      // Encode la clé en Base64 pour HTTP Basic Auth (format: "api_key:")
      final credentials = '$key:';
      final base64Credentials = base64.encode(utf8.encode(credentials));

      if (kDebugMode) {
        debugPrint('[ApiKeyService] Test de la clé API...');
      }

      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Basic $base64Credentials',
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 5));

      if (kDebugMode) {
        debugPrint('[ApiKeyService] Réponse API: ${response.statusCode}');
      }

      // Clé valide si status 200
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('[ApiKeyService] Erreur validation clé: $e');
      return false;
    }
  }
}
