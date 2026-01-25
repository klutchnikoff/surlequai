import 'dart:convert';

import 'package:flutter/foundation.dart';
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

  // Nom du widget (Android uniquement) - Nom de la classe
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
      // Configure le App Group pour iOS
      await HomeWidget.setAppGroupId(_iOSAppGroupId);

      // Nom de l'app (branding)
      await HomeWidget.saveWidgetData<String>(_keyTripName, 'SurLeQuai');

      // Direction 1 (premier train futur)
      final nextDep1 = _getNextDeparture(departuresGo);
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
      } else {
        await HomeWidget.saveWidgetData<String>(
            _keyDirection1Title, direction1Title);
        await HomeWidget.saveWidgetData<String>(_keyDirection1Time, '__:__');
        await HomeWidget.saveWidgetData<String>(_keyDirection1Platform, '');
        await HomeWidget.saveWidgetData<String>(
            _keyDirection1Status, 'Aucun train');
        await HomeWidget.saveWidgetData<String>(
            _keyDirection1StatusColor, 'secondary');
      }

      // Direction 2
      final nextDep2 = _getNextDeparture(departuresReturn);
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
      } else {
        await HomeWidget.saveWidgetData<String>(
            _keyDirection2Title, direction2Title);
        await HomeWidget.saveWidgetData<String>(_keyDirection2Time, '__:__');
        await HomeWidget.saveWidgetData<String>(_keyDirection2Platform, '');
        await HomeWidget.saveWidgetData<String>(
            _keyDirection2Status, 'Aucun train');
        await HomeWidget.saveWidgetData<String>(
            _keyDirection2StatusColor, 'secondary');
      }

      // Timestamp de la dernière mise à jour
      final now = DateTime.now();
      await HomeWidget.saveWidgetData<String>(
          _keyLastUpdate, TimeFormatter.formatTime(now));

      // Déclenche le refresh du widget natif
      await HomeWidget.updateWidget(
        androidName: _androidWidgetName,
        iOSName: 'SurLeQuaiWidget',
      );
    } catch (e) {
      // En cas d'erreur, on ignore silencieusement
      // Le widget continuera d'afficher les anciennes données
      debugPrint('Erreur lors de la mise à jour du widget : $e');
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

  /// Sauvegarde la liste de tous les trajets pour la configuration du widget
  ///
  /// Cette méthode est utilisée par la Configuration Activity Android
  /// pour afficher la liste des trajets disponibles.
  Future<void> saveAllTrips(List<Trip> trips) async {
    try {
      await HomeWidget.setAppGroupId(_iOSAppGroupId);

      // Convertir la liste des trajets en JSON
      final tripsJson = jsonEncode(
        trips.map((trip) => trip.toJson()).toList(),
      );

      await HomeWidget.saveWidgetData<String>('trips', tripsJson);
    } catch (e) {
      debugPrint('Erreur lors de la sauvegarde de la liste des trajets : $e');
    }
  }

  /// Met à jour les données d'un trajet spécifique pour les widgets
  ///
  /// Cette méthode sauvegarde les données d'un trajet avec un préfixe
  /// pour permettre à plusieurs widgets d'afficher des trajets différents.
  ///
  /// Format des clés : trip_{tripId}_direction1_time, etc.
  Future<void> updateWidgetForTrip({
    required Trip trip,
    required List<Departure> departuresGo,
    required List<Departure> departuresReturn,
  }) async {
    try {
      await HomeWidget.setAppGroupId(_iOSAppGroupId);

      final tripId = trip.id;
      final tripName = '${trip.stationA.name} ⟷ ${trip.stationB.name}';
      // Juste la destination (pas le départ) pour réduire la redondance
      final direction1Title = '→ ${trip.stationB.name}';
      final direction2Title = '→ ${trip.stationA.name}';

      // Nom du trajet
      await HomeWidget.saveWidgetData<String>('trip_${tripId}_name', tripName);

      // Direction 1 (A → B)
      final nextDep1 = _getNextDeparture(departuresGo);
      if (nextDep1 != null) {
        final time = TimeFormatter.formatTime(nextDep1.scheduledTime);
        final platform = 'Voie ${nextDep1.platform}';
        final status = _getStatusText(nextDep1);
        final statusColor = _getStatusColorHex(nextDep1.status);

        await HomeWidget.saveWidgetData<String>(
            'trip_${tripId}_direction1_title', direction1Title);
        await HomeWidget.saveWidgetData<String>(
            'trip_${tripId}_direction1_time', time);
        await HomeWidget.saveWidgetData<String>(
            'trip_${tripId}_direction1_platform', platform);
        await HomeWidget.saveWidgetData<String>(
            'trip_${tripId}_direction1_status', status);
        await HomeWidget.saveWidgetData<String>(
            'trip_${tripId}_direction1_status_color', statusColor);
      } else {
        await HomeWidget.saveWidgetData<String>(
            'trip_${tripId}_direction1_title', direction1Title);
        await HomeWidget.saveWidgetData<String>(
            'trip_${tripId}_direction1_time', '__:__');
        await HomeWidget.saveWidgetData<String>(
            'trip_${tripId}_direction1_platform', '');
        await HomeWidget.saveWidgetData<String>(
            'trip_${tripId}_direction1_status', 'Aucun train');
        await HomeWidget.saveWidgetData<String>(
            'trip_${tripId}_direction1_status_color', 'secondary');
      }

      // Direction 2 (B → A)
      final nextDep2 = _getNextDeparture(departuresReturn);
      if (nextDep2 != null) {
        final time = TimeFormatter.formatTime(nextDep2.scheduledTime);
        final platform = 'Voie ${nextDep2.platform}';
        final status = _getStatusText(nextDep2);
        final statusColor = _getStatusColorHex(nextDep2.status);

        await HomeWidget.saveWidgetData<String>(
            'trip_${tripId}_direction2_title', direction2Title);
        await HomeWidget.saveWidgetData<String>(
            'trip_${tripId}_direction2_time', time);
        await HomeWidget.saveWidgetData<String>(
            'trip_${tripId}_direction2_platform', platform);
        await HomeWidget.saveWidgetData<String>(
            'trip_${tripId}_direction2_status', status);
        await HomeWidget.saveWidgetData<String>(
            'trip_${tripId}_direction2_status_color', statusColor);
      } else {
        await HomeWidget.saveWidgetData<String>(
            'trip_${tripId}_direction2_title', direction2Title);
        await HomeWidget.saveWidgetData<String>(
            'trip_${tripId}_direction2_time', '__:__');
        await HomeWidget.saveWidgetData<String>(
            'trip_${tripId}_direction2_platform', '');
        await HomeWidget.saveWidgetData<String>(
            'trip_${tripId}_direction2_status', 'Aucun train');
        await HomeWidget.saveWidgetData<String>(
            'trip_${tripId}_direction2_status_color', 'secondary');
      }

      // Timestamp de la dernière mise à jour
      final now = DateTime.now();
      await HomeWidget.saveWidgetData<String>(
          'trip_${tripId}_last_update', TimeFormatter.formatTime(now));
    } catch (e) {
      debugPrint(
          'Erreur lors de la mise à jour du widget pour le trajet ${trip.id} : $e');
    }
  }

  /// Met à jour tous les widgets en sauvegardant les données de tous les trajets
  ///
  /// Cette méthode est appelée quand les données sont rafraîchies pour mettre
  /// à jour tous les widgets actifs (qui peuvent afficher des trajets différents).
  Future<void> updateAllWidgets({
    required List<Trip> allTrips,
    required Map<String, List<Departure>> departuresGoByTrip,
    required Map<String, List<Departure>> departuresReturnByTrip,
  }) async {
    try {
      // Sauvegarder la liste des trajets pour la configuration
      await saveAllTrips(allTrips);

      // Sauvegarder les données de chaque trajet
      for (final trip in allTrips) {
        final departuresGo = departuresGoByTrip[trip.id] ?? [];
        final departuresReturn = departuresReturnByTrip[trip.id] ?? [];

        await updateWidgetForTrip(
          trip: trip,
          departuresGo: departuresGo,
          departuresReturn: departuresReturn,
        );
      }

      // Déclencher le refresh de tous les widgets natifs
      await HomeWidget.updateWidget(
        androidName: _androidWidgetName,
        iOSName: 'SurLeQuaiWidget',
      );
    } catch (e) {
      debugPrint('Erreur lors de la mise à jour de tous les widgets : $e');
    }
  }
}
