import 'package:home_widget/home_widget.dart';
import 'package:surlequai/models/departure.dart';
import 'package:surlequai/models/trip.dart';
import 'package:surlequai/utils/formatters.dart';

/// Service de gestion du widget écran d'accueil
///
/// Prépare et envoie les données du trajet actif au widget natif
/// (iOS WidgetKit / Android App Widget)
class WidgetService {
  // Clés pour les données partagées avec le widget natif
  static const String _keyTripName = 'trip_name';
  static const String _keyDirection1Title = 'direction1_title';
  static const String _keyDirection1Time = 'direction1_time';
  static const String _keyDirection1Platform = 'direction1_platform';
  static const String _keyDirection1Status = 'direction1_status';
  static const String _keyDirection1StatusColor = 'direction1_status_color';
  static const String _keyDirection2Title = 'direction2_title';
  static const String _keyDirection2Time = 'direction2_time';
  static const String _keyDirection2Platform = 'direction2_platform';
  static const String _keyDirection2Status = 'direction2_status';
  static const String _keyDirection2StatusColor = 'direction2_status_color';
  static const String _keyLastUpdate = 'last_update';

  // Nom du widget (Android uniquement) - Juste le nom de la classe (package ajouté auto)
  static const String _androidWidgetName = 'SurLeQuaiWidgetProvider';

  // Nom du App Group (iOS uniquement)
  static const String _iOSAppGroupId = 'group.com.surlequai.app';

  /// Met à jour les données du widget avec le trajet actif
  ///
  /// Prend les deux directions (go et return) et écrit les données
  /// du prochain train pour chaque direction dans le stockage partagé.
  Future<void> updateWidget({
    required Trip activeTrip,
    required List<Departure> departuresGo,
    required List<Departure> departuresReturn,
    required String direction1Title,
    required String direction2Title,
  }) async {
    try {
      // ignore: avoid_print
      print('📱 WidgetService.updateWidget called');

      // Configure le App Group pour iOS
      await HomeWidget.setAppGroupId(_iOSAppGroupId);

      // Nom du trajet
      final tripName =
          '${activeTrip.stationA.name} ⟷ ${activeTrip.stationB.name}';
      await HomeWidget.saveWidgetData<String>(_keyTripName, tripName);
      // ignore: avoid_print
      print('   Trip name: $tripName');

      // Direction 1 (premier train futur)
      final nextDep1 = _getNextDeparture(departuresGo);
      // ignore: avoid_print
      print('   Direction 1: ${nextDep1 != null ? "Train found" : "No train"}');
      if (nextDep1 != null) {
        final time = TimeFormatter.formatTime(nextDep1.scheduledTime);
        final platform = 'Voie ${nextDep1.platform}';
        final status = _getStatusText(nextDep1);
        final statusColor = _getStatusColorHex(nextDep1.status);

        await HomeWidget.saveWidgetData<String>(
            _keyDirection1Title, direction1Title);
        await HomeWidget.saveWidgetData<String>(_keyDirection1Time, time);
        await HomeWidget.saveWidgetData<String>(_keyDirection1Platform, platform);
        await HomeWidget.saveWidgetData<String>(_keyDirection1Status, status);
        await HomeWidget.saveWidgetData<String>(
            _keyDirection1StatusColor, statusColor);

        // ignore: avoid_print
        print('      $direction1Title - $time - $platform - $status ($statusColor)');
      } else {
        await HomeWidget.saveWidgetData<String>(
            _keyDirection1Title, direction1Title);
        await HomeWidget.saveWidgetData<String>(_keyDirection1Time, '__:__');
        await HomeWidget.saveWidgetData<String>(_keyDirection1Platform, '');
        await HomeWidget.saveWidgetData<String>(
            _keyDirection1Status, 'Aucun train');
        await HomeWidget.saveWidgetData<String>(
            _keyDirection1StatusColor, 'secondary');

        // ignore: avoid_print
        print('      $direction1Title - No train available');
      }

      // Direction 2
      final nextDep2 = _getNextDeparture(departuresReturn);
      // ignore: avoid_print
      print('   Direction 2: ${nextDep2 != null ? "Train found" : "No train"}');
      if (nextDep2 != null) {
        final time = TimeFormatter.formatTime(nextDep2.scheduledTime);
        final platform = 'Voie ${nextDep2.platform}';
        final status = _getStatusText(nextDep2);
        final statusColor = _getStatusColorHex(nextDep2.status);

        await HomeWidget.saveWidgetData<String>(
            _keyDirection2Title, direction2Title);
        await HomeWidget.saveWidgetData<String>(_keyDirection2Time, time);
        await HomeWidget.saveWidgetData<String>(_keyDirection2Platform, platform);
        await HomeWidget.saveWidgetData<String>(_keyDirection2Status, status);
        await HomeWidget.saveWidgetData<String>(
            _keyDirection2StatusColor, statusColor);

        // ignore: avoid_print
        print('      $direction2Title - $time - $platform - $status ($statusColor)');
      } else {
        await HomeWidget.saveWidgetData<String>(
            _keyDirection2Title, direction2Title);
        await HomeWidget.saveWidgetData<String>(_keyDirection2Time, '__:__');
        await HomeWidget.saveWidgetData<String>(_keyDirection2Platform, '');
        await HomeWidget.saveWidgetData<String>(
            _keyDirection2Status, 'Aucun train');
        await HomeWidget.saveWidgetData<String>(
            _keyDirection2StatusColor, 'secondary');

        // ignore: avoid_print
        print('      $direction2Title - No train available');
      }

      // Timestamp de la dernière mise à jour
      final now = DateTime.now();
      await HomeWidget.saveWidgetData<String>(
          _keyLastUpdate, TimeFormatter.formatTime(now));

      // Déclenche le refresh du widget natif
      // ignore: avoid_print
      print('   Triggering native widget update...');
      await HomeWidget.updateWidget(
        androidName: _androidWidgetName,
        iOSName: 'SurLeQuaiWidget',
      );
      // ignore: avoid_print
      print('📱 Widget update completed');
    } catch (e) {
      // Log l'erreur (en production, utiliser un logger)
      // ignore: avoid_print
      print('❌ Erreur lors de la mise à jour du widget : $e');
    }
  }

  /// Récupère le prochain départ futur dans une liste
  Departure? _getNextDeparture(List<Departure> departures) {
    final now = DateTime.now();
    try {
      return departures.firstWhere((d) => d.scheduledTime.isAfter(now));
    } catch (e) {
      return null; // Aucun départ futur
    }
  }

  /// Retourne le texte du statut pour affichage
  String _getStatusText(Departure departure) {
    switch (departure.status) {
      case DepartureStatus.onTime:
        return 'À l\'heure';
      case DepartureStatus.delayed:
        return '+${departure.delayMinutes} min';
      case DepartureStatus.cancelled:
        return 'Supprimé';
      case DepartureStatus.offline:
        return 'Horaire prévu';
    }
  }

  /// Retourne la couleur du statut en code (pour parsing côté natif)
  ///
  /// Codes : onTime, delayed, cancelled, offline, secondary
  /// Le code natif mappera ces codes vers les vraies couleurs
  String _getStatusColorHex(DepartureStatus status) {
    switch (status) {
      case DepartureStatus.onTime:
        return 'onTime';
      case DepartureStatus.delayed:
        return 'delayed';
      case DepartureStatus.cancelled:
        return 'cancelled';
      case DepartureStatus.offline:
        return 'offline';
    }
  }

  /// Configure le callback pour ouvrir l'app quand on tap sur le widget
  ///
  /// Cette méthode doit être appelée dans main() pour écouter les taps
  static Future<void> registerBackgroundCallback() async {
    await HomeWidget.setAppGroupId(_iOSAppGroupId);
  }
}
