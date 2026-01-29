import 'package:flutter/material.dart';
import 'package:surlequai/models/departure.dart';
import 'package:surlequai/theme/colors.dart';
import 'package:surlequai/utils/constants.dart';
import 'package:surlequai/utils/formatters.dart';

sealed class DirectionCardViewModel {
  final String title;
  final Color statusBarColor;

  const DirectionCardViewModel({
    required this.title,
    required this.statusBarColor,
  });

  /// Factory statique pour créer le ViewModel à partir d'une liste de départs.
  /// Cette méthode contient toute la logique de présentation (Business Logic -> UI).
  static DirectionCardViewModel fromDepartures({
    required String title,
    required List<Departure> departures,
    required int serviceDayStartTime,
  }) {
    final now = DateTime.now();

    // Calcule la fin de la "journée de service actuelle"
    // La journée de service va de dayStartTime (ex: 4h) à dayStartTime du lendemain
    DateTime endOfServiceDay;
    if (now.hour < serviceDayStartTime) {
      // Entre minuit et dayStartTime (ex: 1h du matin)
      // → La journée de service se termine à dayStartTime (4h) aujourd'hui
      endOfServiceDay = DateTime(now.year, now.month, now.day, serviceDayStartTime);
    } else {
      // Après dayStartTime → journée se termine à dayStartTime (4h) demain
      final tomorrow = now.add(const Duration(days: 1));
      endOfServiceDay = DateTime(tomorrow.year, tomorrow.month, tomorrow.day, serviceDayStartTime);
    }

    // Filtre les trains "aujourd'hui" (avant la fin de journée de service)
    // IMPORTANT : On compare l'heure RÉELLE de départ (heure prévue + retard)
    final trainsToday = departures.where((d) {
      final actualDepartureTime = d.scheduledTime.add(Duration(minutes: d.delayMinutes));
      return actualDepartureTime.isAfter(now) &&
             d.scheduledTime.isBefore(endOfServiceDay);
    }).toList();

    // Trier par heure réelle de départ (gère les retards importants)
    trainsToday.sort((a, b) {
      final aActual = a.scheduledTime.add(Duration(minutes: a.delayMinutes));
      final bActual = b.scheduledTime.add(Duration(minutes: b.delayMinutes));
      return aActual.compareTo(bActual);
    });

    // Filtre les trains "demain" (après la fin de journée de service)
    final trainsTomorrow =
        departures.where((d) => d.scheduledTime.isAfter(endOfServiceDay)).toList();

    // Cas 1 : Aucun train aujourd'hui, mais il y en a demain
    if (trainsToday.isEmpty && trainsTomorrow.isNotEmpty) {
      return DirectionCardNoDepartures.nextTrainTomorrow(
        title: title,
        tomorrowTime: TimeFormatter.formatTime(trainsTomorrow.first.scheduledTime),
      );
    }

    // Cas 2 : Aucun train du tout
    if (trainsToday.isEmpty && trainsTomorrow.isEmpty) {
      return DirectionCardNoDepartures.defaultEmpty(title: title);
    }

    // Cas 3 : Il y a des trains aujourd'hui
    // Le premier de la liste est celui qui part réellement le plus tôt
    final nextDeparture = trainsToday.first;

    // Limiter le nombre de départs suivants à afficher
    final subsequentDepartures =
        trainsToday
            .skip(1)
            .take(AppConstants.subsequentDeparturesCount)
            .toList();

    Color statusBarColor;
    String statusText;

    switch (nextDeparture.status) {
      case DepartureStatus.onTime:
        statusBarColor = AppColors.onTime;
        statusText = 'À l\'heure';
        break;
      case DepartureStatus.delayed:
        statusBarColor = AppColors.delayed;
        statusText = '+${nextDeparture.delayMinutes} min';
        break;
      case DepartureStatus.cancelled:
        statusBarColor = AppColors.cancelled;
        statusText = 'Supprimé';
        break;
      case DepartureStatus.offline:
        statusBarColor = AppColors.offline;
        statusText = 'Horaire prévu';
        break;
    }

    return DirectionCardWithDepartures(
      title: title,
      statusBarColor: statusBarColor,
      time: TimeFormatter.formatTime(nextDeparture.scheduledTime),
      platform: nextDeparture.platform == '?' ? '' : 'Voie ${nextDeparture.platform}',
      statusText: statusText,
      statusColor: statusBarColor,
      subsequentDepartures: subsequentDepartures.isNotEmpty
          ? 'Puis: ${TimeFormatter.formatTimeList(subsequentDepartures.map((d) => d.scheduledTime).toList())}'
          : null,
      durationMinutes: nextDeparture.durationMinutes,
    );
  }
}

class DirectionCardWithDepartures extends DirectionCardViewModel {
  final String time;
  final String platform;
  final String statusText;
  final Color statusColor;
  final String? subsequentDepartures;
  final int? durationMinutes; // Durée du trajet en minutes

  const DirectionCardWithDepartures({
    required super.title,
    required super.statusBarColor,
    required this.time,
    required this.platform,
    required this.statusText,
    required this.statusColor,
    this.subsequentDepartures,
    this.durationMinutes,
  });
}

class DirectionCardNoDepartures extends DirectionCardViewModel {
  final String noTrainTimeDisplay;
  final String noTrainStatusDisplay;
  final Color noTrainStatusColor;

  const DirectionCardNoDepartures({
    required super.title,
    required super.statusBarColor,
    required this.noTrainTimeDisplay,
    required this.noTrainStatusDisplay,
    required this.noTrainStatusColor,
  });

  factory DirectionCardNoDepartures.defaultEmpty({required String title}) {
    return DirectionCardNoDepartures(
      title: title,
      statusBarColor: AppColors.secondary,
      noTrainTimeDisplay: '__ : __',
      noTrainStatusDisplay: 'Aucun train prévu pour le moment.',
      noTrainStatusColor: AppColors.secondary,
    );
  }

  factory DirectionCardNoDepartures.nextTrainTomorrow({
    required String title,
    required String tomorrowTime,
  }) {
    return DirectionCardNoDepartures(
      title: title,
      statusBarColor: AppColors.secondary,
      noTrainTimeDisplay: '__ : __',
      noTrainStatusDisplay: 'Aucun train aujourd\'hui\nPremier train demain: $tomorrowTime',
      noTrainStatusColor: AppColors.secondary,
    );
  }
}