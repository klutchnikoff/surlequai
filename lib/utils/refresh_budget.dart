/// Cadence des réveils du widget.
///
/// Le quota de l'API amont est partagé par tous les utilisateurs : un réveil
/// inutile consomme un budget commun. Le widget interroge donc fréquemment à
/// l'approche d'un départ, rarement le reste du temps, et pas la nuit.
///
/// Cette classe est la référence unique : Flutter publie l'échéance calculée
/// ici, et les widgets natifs la consomment au lieu de la recalculer.
class RefreshBudget {
  const RefreshBudget._();

  /// Fenêtre avant un départ où la précision prime sur l'économie. Elle reste
  /// courte : sur une ligne desservie toutes les demi-heures, une fenêtre large
  /// maintiendrait la cadence fine en permanence.
  static const preciseWindow = Duration(minutes: 15);

  /// Cadence dans cette fenêtre : un retard n'évolue pas de minute en minute.
  static const preciseInterval = Duration(minutes: 10);

  /// Cadence hors de cette fenêtre, et quand aucun départ n'est connu.
  static const idleInterval = Duration(minutes: 30);

  /// Tolérance avant de considérer que le réveil a été manqué.
  static const grace = Duration(minutes: 1);

  static const activeFromHour = 5;
  static const activeUntilHour = 23;

  /// Instant du prochain réveil, à partir de [after].
  ///
  /// Hors plage active, le réveil est reporté à la reprise du service. Loin
  /// d'un départ, on se contente d'un réveil espacé, quitte à viser l'entrée
  /// dans la fenêtre de précision.
  static DateTime nextRefresh(DateTime after, {DateTime? nextDeparture}) {
    final resume = _resume(after);
    if (resume != null) return resume;
    if (nextDeparture == null || !nextDeparture.isAfter(after)) {
      return after.add(idleInterval);
    }
    final untilDeparture = nextDeparture.difference(after);
    if (untilDeparture <= preciseWindow) {
      return after.add(
        untilDeparture < preciseInterval ? untilDeparture : preciseInterval,
      );
    }
    final toWindow = untilDeparture - preciseWindow;
    return after.add(toWindow < idleInterval ? toWindow : idleInterval);
  }

  /// Vrai lorsque le réveil attendu a été manqué d'au moins [grace].
  ///
  /// C'est ce qui distingue des données simplement espacées, encore valables,
  /// de données que plus rien ne rafraîchit — les seules à mériter la mention
  /// « hors ligne ».
  static bool isStale({
    required DateTime now,
    DateTime? fetchedAt,
    DateTime? nextDeparture,
  }) {
    if (fetchedAt == null) return true;
    // Inclusif : l'instant même de l'échéance est celui où la timeline place
    // son entrée de bascule, elle doit donc déjà être périmée.
    return !now.isBefore(
      nextRefresh(fetchedAt, nextDeparture: nextDeparture).add(grace),
    );
  }

  /// Début de la prochaine plage active, ou null si elle est déjà ouverte.
  static DateTime? _resume(DateTime from) {
    if (from.hour >= activeFromHour && from.hour < activeUntilHour) return null;
    return DateTime(
      from.year,
      from.month,
      from.day + (from.hour >= activeUntilHour ? 1 : 0),
      activeFromHour,
    );
  }
}
