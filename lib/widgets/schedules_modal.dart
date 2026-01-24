import 'package:flutter/material.dart';
import 'package:surlequai/models/departure.dart';
import 'package:surlequai/theme/app_theme.dart';
import 'package:surlequai/theme/colors.dart';
import 'package:surlequai/theme/text_styles.dart';
import 'package:surlequai/utils/formatters.dart';

class SchedulesModal extends StatefulWidget {
  final String title;
  final List<Departure> departures;

  const SchedulesModal({
    super.key,
    required this.title,
    required this.departures,
  });

  @override
  State<SchedulesModal> createState() => _SchedulesModalState();
}

class _SchedulesModalState extends State<SchedulesModal> {
  bool _hasScrolled = false;

  void _scrollToNextDeparture(
      ScrollController controller, int nextDepartureIndex) {
    // Ne scroller qu'une seule fois
    if (_hasScrolled || nextDepartureIndex == -1) return;

    _hasScrolled = true;

    // Attendre que le widget soit construit avant de scroller
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!controller.hasClients) return;

      // Hauteur approximative d'un ListTile dense
      const itemHeight = 56.0;

      // Calculer la position à scroller (avec un petit offset pour voir le titre)
      final offset = nextDepartureIndex * itemHeight;

      // Scroller avec animation douce
      controller.animateTo(
        offset,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final nextDepartureIndex =
        widget.departures.indexWhere((d) => d.scheduledTime.isAfter(now));

    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.9,
      expand: false,
      builder: (_, controller) {
        // Scroller vers le prochain train après le build
        _scrollToNextDeparture(controller, nextDepartureIndex);
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag handle
              Center(
                child: Container(
                  height: 5,
                  width: 40,
                  decoration: BoxDecoration(
                    color: AppTheme.getTertiaryColor(context),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Header
              const Text('Tous les horaires', style: AppTextStyles.large),
              Text(widget.title,
                  style: AppTextStyles.small.copyWith(
                      color: AppTheme.getSecondaryTextColor(context))),
              const SizedBox(height: 16),
              const Divider(),
              // List of departures
              Expanded(
                child: ListView.builder(
                  controller: controller,
                  itemCount: widget.departures.length,
                  itemBuilder: (context, index) {
                    final departure = widget.departures[index];
                    final isNext = index == nextDepartureIndex;
                    final isPast = departure.scheduledTime.isBefore(now);

                    // Déterminer la couleur selon le statut
                    Color statusColor;
                    switch (departure.status) {
                      case DepartureStatus.onTime:
                        statusColor = AppColors.onTime;
                        break;
                      case DepartureStatus.delayed:
                        statusColor = AppColors.delayed;
                        break;
                      case DepartureStatus.cancelled:
                        statusColor = AppColors.cancelled;
                        break;
                      case DepartureStatus.offline:
                        statusColor = AppColors.offline;
                        break;
                    }

                    TextStyle timeStyle;
                    TextStyle platformStyle;

                    if (isNext) {
                      // Prochain train : couleur selon statut + gras
                      timeStyle = AppTextStyles.medium.copyWith(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                        decoration:
                            departure.status == DepartureStatus.cancelled
                                ? TextDecoration.lineThrough
                                : null,
                      );
                      platformStyle = AppTextStyles.medium.copyWith(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                        decoration:
                            departure.status == DepartureStatus.cancelled
                                ? TextDecoration.lineThrough
                                : null,
                      );
                    } else if (isPast) {
                      // Trains passés : gris + barré
                      timeStyle = AppTextStyles.medium.copyWith(
                          color: AppColors.secondary,
                          decoration: TextDecoration.lineThrough);
                      platformStyle = AppTextStyles.medium.copyWith(
                          color: AppColors.secondary,
                          decoration: TextDecoration.lineThrough);
                    } else {
                      // Trains futurs : style normal
                      timeStyle = AppTextStyles.medium;
                      platformStyle = AppTextStyles.medium;
                    }

                    return ListTile(
                      dense: true,
                      leading: isNext
                          ? Icon(Icons.arrow_forward_ios,
                              color: statusColor, size: 16)
                          : const SizedBox(width: 24),
                      title: Text(
                        TimeFormatter.formatTime(departure.scheduledTime),
                        style: timeStyle,
                      ),
                      trailing: Text('Voie ${departure.platform}',
                          style: platformStyle),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
