library;

/// Constantes globales de l'application
///
/// Centralise toutes les valeurs magiques et paramètres configurables
/// pour faciliter la maintenance et la cohérence.

class AppConstants {
  // Empêche l'instanciation de cette classe
  AppConstants._();

  /// === TEMPS ET RAFRAÎCHISSEMENT ===

  /// Intervalle de rafraîchissement des données en mode online
  static const Duration refreshInterval = Duration(seconds: 60);

  /// Intervalle de rafraîchissement en mode offline (tentative de reconnexion)
  static const Duration refreshIntervalOffline = Duration(minutes: 5);

  /// Timeout pour les requêtes API
  static const Duration apiTimeout = Duration(seconds: 10);

  /// Durée de vie du cache en mémoire pour les données temps réel
  static const Duration realtimeCacheDuration = Duration(seconds: 60);

  /// === TRAJETS ET FAVORIS ===

  /// Nombre maximum de trajets favoris autorisés
  static const int maxFavoriteTrips = 10;

  /// Nombre de départs à afficher dans la modal "Tous les horaires"
  static const int maxDeparturesInModal = 50;

  /// Nombre de départs suivants à afficher sur l'écran principal (après le prochain)
  static const int subsequentDeparturesCount = 2;

  /// === HORAIRES ET COMPORTEMENT ===

  /// Heure par défaut de bascule matin/soir (en heures, format 24h)
  static const int defaultMorningEveningSplitHour = 13;

  /// Heure de début du jour de service (en heures, format 24h)
  static const int defaultServiceDayStartHour = 4;

  /// Heure de fin de la journée de service (après, on affiche les trains du lendemain)
  static const int serviceDayEndHour = 22;

  /// === NOTIFICATIONS ===

  /// Délai par défaut avant le départ pour notification (en minutes)
  static const int defaultNotificationMinutesBefore = 10;

  /// Délais disponibles pour les notifications (en minutes)
  static const List<int> notificationMinutesOptions = [5, 10, 15, 20];

  /// === INTERFACE UTILISATEUR ===

  /// Durée des animations rapides (transitions légères)
  static const Duration shortAnimationDuration = Duration(milliseconds: 150);

  /// Durée des animations normales (transitions standard)
  static const Duration normalAnimationDuration = Duration(milliseconds: 300);

  /// Durée des animations lentes (transitions importantes)
  static const Duration longAnimationDuration = Duration(milliseconds: 500);

  /// Taille de l'icône pour les boutons d'action
  static const double actionIconSize = 24.0;

  /// === STOCKAGE ===

  /// Clé pour le stockage des trajets favoris
  static const String tripsStorageKey = 'trips';

  /// Clé pour le trajet actif
  static const String activeTripIdKey = 'activeTripId';

  /// Taille estimée du cache SQLite par région (en bytes)
  /// 50 MB = 50 * 1024 * 1024
  static const int estimatedCacheSizePerRegion = 52428800;

  /// === API ET RÉSEAU ===

  /// URL de base du proxy Cloudflare (à configurer plus tard)
  /// Sera définie une fois le Worker déployé
  static const String? apiBaseUrl =
      null; // TODO: Configurer après déploiement Worker

  /// Nombre maximum de tentatives de retry pour les appels API
  static const int maxApiRetries = 3;

  /// Délai entre les tentatives de retry (backoff exponentiel)
  static const Duration retryDelay = Duration(seconds: 2);

  /// === DÉVELOPPEMENT ===

  /// Mode debug pour activer les logs détaillés
  static const bool enableDebugLogs =
      true; // TODO: Passer à false en production

  /// Utiliser les mock data au lieu de l'API réelle
  static const bool useMockData =
      true; // TODO: Passer à false une fois API configurée
}
