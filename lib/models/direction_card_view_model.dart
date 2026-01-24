import 'package:flutter/material.dart';
import 'package:surlequai/theme/colors.dart';

sealed class DirectionCardViewModel {
  final String title;
  final Color statusBarColor;

  const DirectionCardViewModel({
    required this.title,
    required this.statusBarColor,
  });
}

class DirectionCardWithDepartures extends DirectionCardViewModel {
  final String time;
  final String platform;
  final String statusText;
  final Color statusColor;
  final String? subsequentDepartures;

  const DirectionCardWithDepartures({
    required super.title,
    required super.statusBarColor,
    required this.time,
    required this.platform,
    required this.statusText,
    required this.statusColor,
    this.subsequentDepartures,
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
}
