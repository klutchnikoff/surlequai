library;

/// Utilitaires de formatage pour l'affichage des données
///
/// Centralise tous les formateurs pour éviter la duplication de code
/// et garantir un formatage cohérent dans toute l'application.

class TimeFormatter {
  /// Formate une DateTime en heure (HH:mm)
  ///
  /// Exemple: DateTime(2026, 1, 24, 14, 12) → "14:12"
  static String formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  /// Formate une liste de DateTime en chaîne d'heures séparées par des espaces
  ///
  /// Exemple: [DateTime(14:12), DateTime(14:42)] → "14:12  14:42"
  static String formatTimeList(List<DateTime> dateTimes) {
    return dateTimes.map((dt) => formatTime(dt)).join('  ');
  }

  /// Formate une durée en minutes/heures lisible
  ///
  /// Exemples:
  /// - 5 → "5 min"
  /// - 60 → "1h"
  /// - 90 → "1h30"
  static String formatDuration(int minutes) {
    if (minutes < 60) {
      return '$minutes min';
    }

    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;

    if (remainingMinutes == 0) {
      return '${hours}h';
    }

    return '${hours}h${remainingMinutes.toString().padLeft(2, '0')}';
  }

  /// Formate un délai relatif (il y a X)
  ///
  /// Exemples:
  /// - 30 secondes → "il y a 30s"
  /// - 5 minutes → "il y a 5min"
  /// - 2 heures → "il y a 2h"
  static String formatRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return 'il y a ${difference.inSeconds}s';
    } else if (difference.inMinutes < 60) {
      return 'il y a ${difference.inMinutes}min';
    } else if (difference.inHours < 24) {
      return 'il y a ${difference.inHours}h';
    } else {
      return 'il y a ${difference.inDays}j';
    }
  }
}

class DateFormatter {
  /// Formate une date complète en français
  ///
  /// Exemple: DateTime(2026, 1, 24) → "Vendredi 24 janvier 2026"
  static String formatFullDate(DateTime dateTime) {
    final days = [
      'Lundi',
      'Mardi',
      'Mercredi',
      'Jeudi',
      'Vendredi',
      'Samedi',
      'Dimanche'
    ];
    final months = [
      'janvier',
      'février',
      'mars',
      'avril',
      'mai',
      'juin',
      'juillet',
      'août',
      'septembre',
      'octobre',
      'novembre',
      'décembre'
    ];

    final dayName = days[dateTime.weekday - 1];
    final monthName = months[dateTime.month - 1];

    return '$dayName ${dateTime.day} $monthName ${dateTime.year}';
  }

  /// Formate une date courte
  ///
  /// Exemple: DateTime(2026, 1, 24) → "24/01/2026"
  static String formatShortDate(DateTime dateTime) {
    return '${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year}';
  }
}
