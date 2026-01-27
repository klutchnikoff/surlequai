import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:home_widget/home_widget.dart';
import 'package:surlequai/models/departure.dart';
import 'package:surlequai/models/trip.dart';
import 'package:surlequai/utils/constants.dart';
import 'package:surlequai/utils/formatters.dart';
import 'package:surlequai/utils/trip_sorter.dart';

/// Service de gestion du widget écran d'accueil
///
/// Prépare et envoie les données de tous les trajets aux widgets natifs
/// (iOS WidgetKit / Android App Widget)
///
/// Utilise un système de clés préfixées par trip ID pour permettre
/// à plusieurs widgets d'afficher des trajets différents.
class WidgetService {
  // Nom du widget (Android uniquement) - Nom de la classe
  static const String _androidWidgetName = 'SurLeQuaiWidgetProvider';

  // Nom du App Group (iOS uniquement)
  static const String _iOSAppGroupId = 'group.com.surlequai.app';

  /// Récupère le prochain départ futur dans une liste
  ///
  /// Prend en compte le retard pour déterminer le train qui partira réellement en premier.
  /// Exemple : Si train A (17:00 +30 min) et train B (17:20), affiche train B car il part avant.
  Departure? _getNextDeparture(List<Departure> departures) {
    final now = DateTime.now();

    // Filtrer les trains dont l'heure réelle de départ est dans le futur
    final futureTrains = departures.where((d) {
      final actualDepartureTime = d.scheduledTime.add(Duration(minutes: d.delayMinutes));
      return actualDepartureTime.isAfter(now);
    }).toList();

    if (futureTrains.isEmpty) return null;

    // Trier par heure réelle de départ (heure prévue + retard)
    futureTrains.sort((a, b) {
      final aActual = a.scheduledTime.add(Duration(minutes: a.delayMinutes));
      final bActual = b.scheduledTime.add(Duration(minutes: b.delayMinutes));
      return aActual.compareTo(bActual);
    });

    // Retourner le train qui part réellement le plus tôt
    return futureTrains.first;
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
    int? morningEveningSplitHour,
    int? serviceDayStartHour,
  }) async {
    try {
      await HomeWidget.setAppGroupId(_iOSAppGroupId);

      final tripId = trip.id;
      final tripName = '${trip.stationA.name} ⟷ ${trip.stationB.name}';

      // Déterminer l'ordre d'affichage selon l'heure (logique matin/soir)
      // Utilise les préférences utilisateur si fournies, sinon les valeurs par défaut
      final shouldSwap = TripSorter.shouldSwapOrder(
        currentHour: DateTime.now().hour,
        morningEveningSplitHour: morningEveningSplitHour ?? AppConstants.defaultMorningEveningSplitHour,
        serviceDayStartHour: serviceDayStartHour ?? AppConstants.defaultServiceDayStartHour,
        morningDirection: trip.morningDirection,
      );

      // Si shouldSwap = true, on inverse : direction1 = B→A, direction2 = A→B
      final direction1Departures = shouldSwap ? departuresReturn : departuresGo;
      final direction2Departures = shouldSwap ? departuresGo : departuresReturn;
      final direction1Title = shouldSwap ? '→ ${trip.stationA.name}' : '→ ${trip.stationB.name}';
      final direction2Title = shouldSwap ? '→ ${trip.stationB.name}' : '→ ${trip.stationA.name}';

      // Nom du trajet
      await HomeWidget.saveWidgetData<String>('trip_${tripId}_name', tripName);

      // Direction 1 (priorité selon l'heure)
      final nextDep1 = _getNextDeparture(direction1Departures);
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

      // Direction 2 (secondaire selon l'heure)
      final nextDep2 = _getNextDeparture(direction2Departures);
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
    int? morningEveningSplitHour,
    int? serviceDayStartHour,
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
          morningEveningSplitHour: morningEveningSplitHour,
          serviceDayStartHour: serviceDayStartHour,
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

  /// Nettoie les données d'un trajet supprimé pour tous les widgets
  ///
  /// Cette méthode supprime toutes les clés SharedPreferences associées
  /// à un tripId spécifique. Les widgets qui affichaient ce trajet
  /// passeront automatiquement en mode "Trajet supprimé".
  Future<void> clearWidgetDataForTrip(String tripId) async {
    try {
      await HomeWidget.setAppGroupId(_iOSAppGroupId);

      // Supprimer toutes les clés associées à ce trajet
      await HomeWidget.saveWidgetData<String>('trip_${tripId}_name', null);
      await HomeWidget.saveWidgetData<String>('trip_${tripId}_direction1_title', null);
      await HomeWidget.saveWidgetData<String>('trip_${tripId}_direction1_time', null);
      await HomeWidget.saveWidgetData<String>('trip_${tripId}_direction1_platform', null);
      await HomeWidget.saveWidgetData<String>('trip_${tripId}_direction1_status', null);
      await HomeWidget.saveWidgetData<String>('trip_${tripId}_direction1_status_color', null);
      await HomeWidget.saveWidgetData<String>('trip_${tripId}_direction2_title', null);
      await HomeWidget.saveWidgetData<String>('trip_${tripId}_direction2_time', null);
      await HomeWidget.saveWidgetData<String>('trip_${tripId}_direction2_platform', null);
      await HomeWidget.saveWidgetData<String>('trip_${tripId}_direction2_status', null);
      await HomeWidget.saveWidgetData<String>('trip_${tripId}_direction2_status_color', null);
      await HomeWidget.saveWidgetData<String>('trip_${tripId}_last_update', null);

      // Déclencher le refresh des widgets pour qu'ils détectent le trajet supprimé
      await HomeWidget.updateWidget(
        androidName: _androidWidgetName,
        iOSName: 'SurLeQuaiWidget',
      );

      debugPrint('Données du trajet $tripId nettoyées des widgets');
    } catch (e) {
      debugPrint('Erreur lors du nettoyage des données du trajet $tripId : $e');
    }
  }
}
