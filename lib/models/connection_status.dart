/// État de la connexion de l'application
///
/// Utilisé pour afficher les bandeaux d'information appropriés
/// à l'utilisateur selon l'état du réseau et de la synchronisation.
enum ConnectionStatus {
  /// Connecté avec succès, données temps réel disponibles
  online,

  /// Mode hors connexion, affichage des horaires théoriques uniquement
  offline,

  /// Synchronisation en cours (refresh des données)
  syncing,

  /// Erreur lors de la récupération des données
  error,
}
