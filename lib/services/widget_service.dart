import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:home_widget/home_widget.dart';
import 'package:surlequai/models/departure.dart';
import 'package:surlequai/models/direction_card_view_model.dart';
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
    DateTime? now, // Pour les tests
  }) async {
    try {
      await HomeWidget.setAppGroupId(_iOSAppGroupId);

      final tripId = trip.id;
      final tripName = '${trip.stationA.name} ⟷ ${trip.stationB.name}';
      final referenceDate = now ?? DateTime.now();

      // Déterminer l'ordre d'affichage selon l'heure (logique matin/soir)
      final shouldSwap = TripSorter.shouldSwapOrder(
        currentHour: referenceDate.hour,
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

      // Helper pour sauvegarder une direction
      Future<void> saveDirection(String suffix, String title, List<Departure> departures) async {
        final vm = DirectionCardViewModel.fromDepartures(
          title: title,
          departures: departures,
          serviceDayStartTime: serviceDayStartHour ?? AppConstants.defaultServiceDayStartHour,
          now: referenceDate,
        );

        await HomeWidget.saveWidgetData<String>(
            'trip_${tripId}_${suffix}_title', vm.title);

        if (vm is DirectionCardWithDepartures) {
          await HomeWidget.saveWidgetData<String>(
              'trip_${tripId}_${suffix}_time', vm.time);
          await HomeWidget.saveWidgetData<String>(
              'trip_${tripId}_${suffix}_platform', vm.platform);
          await HomeWidget.saveWidgetData<String>(
              'trip_${tripId}_${suffix}_status', vm.statusText);
          await HomeWidget.saveWidgetData<String>(
              'trip_${tripId}_${suffix}_status_color', _getStatusColorHex(vm.statusType));
        } else if (vm is DirectionCardNoDepartures) {
          await HomeWidget.saveWidgetData<String>(
              'trip_${tripId}_${suffix}_time', vm.noTrainTimeDisplay);
          // Le widget natif n'a pas de champ "statusDisplay" long, on met "Aucun train" ou un texte court
          // TODO: Adapter le widget natif pour gérer les messages "Demain à 08:00" si possible
          // Pour l'instant on reste simple pour ne pas casser l'UI native
          await HomeWidget.saveWidgetData<String>(
              'trip_${tripId}_${suffix}_platform', '');
          await HomeWidget.saveWidgetData<String>(
              'trip_${tripId}_${suffix}_status', 'Aucun train');
          await HomeWidget.saveWidgetData<String>(
              'trip_${tripId}_${suffix}_status_color', 'secondary');
        }
      }

      // Sauvegarder Direction 1
      await saveDirection('direction1', direction1Title, direction1Departures);

      // Sauvegarder Direction 2
      await saveDirection('direction2', direction2Title, direction2Departures);

      // Timestamp de la dernière mise à jour
      await HomeWidget.saveWidgetData<String>(
          'trip_${tripId}_last_update', TimeFormatter.formatTime(referenceDate));
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