import 'package:flutter/material.dart';
import 'package:surlequai/theme/colors.dart'; // Import AppColors

class DirectionCardViewModel {
  final String title;
  final Color statusBarColor;
  final bool hasDepartures;
  
  // Details for when there are departures
  final String? time;
  final String? platform;
  final String? statusText;
  final Color? statusColor;
  final String? subsequentDepartures;

  // Details for when there are NO departures (refined display)
  final String? noTrainTimeDisplay;
  final String? noTrainStatusDisplay;
  final Color? noTrainStatusColor;

  const DirectionCardViewModel({
    required this.title,
    required this.statusBarColor,
    required this.hasDepartures,
    this.time,
    this.platform,
    this.statusText,
    this.statusColor,
    this.subsequentDepartures,
    this.noTrainTimeDisplay,
    this.noTrainStatusDisplay,
    this.noTrainStatusColor,
  });

  factory DirectionCardViewModel.noDepartures({required String title}) {
    return DirectionCardViewModel(
      title: title,
      statusBarColor: AppColors.secondary, // Use a consistent grey from AppColors
      hasDepartures: false,
      noTrainTimeDisplay: '__ : __', // As requested
      noTrainStatusDisplay: 'Aucun train prévu pour le moment.', // As requested
      noTrainStatusColor: AppColors.secondary, // Use the same grey as status bar
    );
  }
}
