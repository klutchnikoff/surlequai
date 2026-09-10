import 'package:flutter/material.dart';
import 'package:surlequai/models/departure.dart';
import 'package:surlequai/models/data_failure.dart';
import 'package:surlequai/theme/colors.dart';
import 'package:surlequai/utils/constants.dart';
import 'package:surlequai/utils/formatters.dart';
import 'package:surlequai/utils/service_day.dart';

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
    bool fromNetwork = true,
    DataFailure? failure,
    DateTime? now, // Pour les tests
  }) {
    final referenceDate = now ?? DateTime.now();

    final endOfServiceDay = ServiceDay.next(
      ServiceDay.start(referenceDate, serviceDayStartTime),
    );
    final endOfNextDay = ServiceDay.next(endOfServiceDay);

    // Filtre les trains "aujourd'hui" (avant la fin de journée de service)
    // IMPORTANT : On compare l'heure RÉELLE de départ (heure prévue + retard)
    final trainsToday = departures.where((d) {
      final actualDepartureTime = d.effectiveTime;
      return actualDepartureTime.isAfter(referenceDate) &&
          d.scheduledTime.isBefore(endOfServiceDay);
    }).toList();

    // Trier par heure réelle de départ (gère les retards importants)
    trainsToday.sort((a, b) {
      final aActual = a.effectiveTime;
      final bActual = b.effectiveTime;
      return aActual.compareTo(bActual);
    });

    // Filtre les trains "demain" (après la fin de journée de service)
    final trainsTomorrow =
        departures
            .where(
              (d) =>
                  !d.scheduledTime.isBefore(endOfServiceDay) &&
                  d.scheduledTime.isBefore(endOfNextDay) &&
                  d.status != DepartureStatus.cancelled &&
                  d.lastKnownStatus != DepartureStatus.cancelled,
            )
            .toList()
          ..sort((a, b) => a.effectiveTime.compareTo(b.effectiveTime));

    final failureText = switch (failure) {
      DataFailure.authentication => 'Clé API à vérifier dans les paramètres.',
      DataFailure.rateLimited =>
        'Limite de requêtes atteinte. Réessayez plus tard.',
      DataFailure.server => 'Service horaires indisponible.',
      DataFailure.invalidData => 'Réponse horaires illisible.',
      DataFailure.timeout => 'Le service met trop de temps à répondre.',
      _ => null,
    };
    // Cas 1 : Aucun train aujourd'hui, mais il y en a demain
    if (trainsToday.isEmpty && trainsTomorrow.isNotEmpty) {
      return DirectionCardNoDepartures.nextTrainTomorrow(
        title: title,
        tomorrowTime:
            '${trainsTomorrow.first.isCoach ? 'Car · ' : ''}${TimeFormatter.formatTime(trainsTomorrow.first.scheduledTime)}',
        fromNetwork: fromNetwork,
      );
    }

    // Cas 2 : Aucun train du tout
    if (trainsToday.isEmpty && trainsTomorrow.isEmpty) {
      return DirectionCardNoDepartures.defaultEmpty(
        title: title,
        message:
            failureText ??
            (!fromNetwork ? 'Horaires indisponibles hors ligne.' : null),
      );
    }

    // Cas 3 : Il y a des trains aujourd'hui
    // Le premier de la liste est celui qui part réellement le plus tôt
    final nextDeparture = trainsToday.first;

    // Limiter le nombre de départs suivants à afficher
    final subsequentDepartures = trainsToday
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
        // Ce statut ne concerne plus que les données servies sans réseau :
        // le dire explicitement vaut mieux que « horaire prévu », que l'on
        // confondait avec un horaire théorique obtenu en ligne.
        statusText = nextDeparture.lastKnownStatus == DepartureStatus.cancelled
            ? 'Hors ligne · dernière info : supprimé'
            : nextDeparture.lastKnownStatus == DepartureStatus.delayed
            ? 'Hors ligne · dernier retard : +${nextDeparture.lastKnownDelayMinutes ?? 0} min'
            : 'Hors ligne';
        break;
    }

    return DirectionCardWithDepartures(
      title: title,
      statusBarColor: statusBarColor,
      time: TimeFormatter.formatTime(nextDeparture.scheduledTime),
      platform: nextDeparture.platform == '?'
          ? ''
          : 'Voie ${nextDeparture.platform}',
      statusText:
          '${nextDeparture.isCoach ? 'Car · ' : ''}$statusText${failureText == null ? '' : '\n$failureText'}',
      statusColor: statusBarColor,
      statusType: nextDeparture.status, // Nouveau champ
      subsequentDepartures: subsequentDepartures.isNotEmpty
          ? 'Puis : ${subsequentDepartures.map(_subsequent).join(' · ')}'
          : null,
      durationMinutes: nextDeparture.durationMinutes,
    );
  }

  static String _subsequent(Departure d) {
    final status = switch (d.status) {
      DepartureStatus.delayed => ' (+${d.delayMinutes} min)',
      DepartureStatus.cancelled => ' (supprimé)',
      DepartureStatus.offline => ' (hors ligne)',
      _ => '',
    };
    return '${d.isCoach ? 'Car ' : ''}${TimeFormatter.formatTime(d.scheduledTime)}$status';
  }
}

class DirectionCardWithDepartures extends DirectionCardViewModel {
  final String time;
  final String platform;
  final String statusText;
  final Color statusColor;
  final DepartureStatus statusType; // Nouveau champ pour la sémantique
  final String? subsequentDepartures;
  final int? durationMinutes; // Durée du trajet en minutes

  const DirectionCardWithDepartures({
    required super.title,
    required super.statusBarColor,
    required this.time,
    required this.platform,
    required this.statusText,
    required this.statusColor,
    required this.statusType,
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

  factory DirectionCardNoDepartures.defaultEmpty({
    required String title,
    String? message,
  }) {
    return DirectionCardNoDepartures(
      title: title,
      statusBarColor: AppColors.secondary,
      noTrainTimeDisplay: '__ : __',
      noTrainStatusDisplay:
          message ?? 'Aucun départ direct trouvé pour le moment.',
      noTrainStatusColor: AppColors.secondary,
    );
  }

  factory DirectionCardNoDepartures.nextTrainTomorrow({
    required String title,
    required String tomorrowTime,
    bool fromNetwork = true,
  }) {
    return DirectionCardNoDepartures(
      title: title,
      statusBarColor: AppColors.secondary,
      noTrainTimeDisplay: '__ : __',
      noTrainStatusDisplay: fromNetwork
          ? 'Prochain départ direct trouvé demain : $tomorrowTime'
          : 'Hors ligne · prochain départ enregistré demain : $tomorrowTime',
      noTrainStatusColor: AppColors.secondary,
    );
  }
}
