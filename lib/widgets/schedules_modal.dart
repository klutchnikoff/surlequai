import 'package:flutter/material.dart';
import 'package:surlequai/models/departure.dart';
import 'package:surlequai/theme/colors.dart';
import 'package:surlequai/theme/text_styles.dart';

class SchedulesModal extends StatelessWidget {
  final String title;
  final List<Departure> departures;

  const SchedulesModal({
    super.key,
    required this.title,
    required this.departures,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final nextDepartureIndex = departures.indexWhere((d) => d.scheduledTime.isAfter(now));

    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.9,
      expand: false,
      builder: (_, controller) {
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
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Header
              Text('Tous les horaires', style: AppTextStyles.large),
              Text(title, style: AppTextStyles.small.copyWith(color: Colors.grey)),
              const SizedBox(height: 16),
              const Divider(),
              // List of departures
              Expanded(
                child: ListView.builder(
                  controller: controller,
                  itemCount: departures.length,
                  itemBuilder: (context, index) {
                    final departure = departures[index];
                    final isNext = index == nextDepartureIndex;
                    final isPast = departure.scheduledTime.isBefore(now);

                    TextStyle timeStyle;
                    TextStyle platformStyle;

                    if (isNext) {
                      timeStyle = AppTextStyles.medium.copyWith(color: AppColors.onTime, fontWeight: FontWeight.bold);
                      platformStyle = AppTextStyles.medium.copyWith(color: AppColors.onTime, fontWeight: FontWeight.bold);
                    } else if (isPast) {
                      timeStyle = AppTextStyles.medium.copyWith(color: AppColors.secondary, decoration: TextDecoration.lineThrough);
                      platformStyle = AppTextStyles.medium.copyWith(color: AppColors.secondary, decoration: TextDecoration.lineThrough);
                    } else {
                      timeStyle = AppTextStyles.medium;
                      platformStyle = AppTextStyles.medium;
                    }

                    return ListTile(
                      dense: true,
                      leading: isNext ? const Icon(Icons.arrow_forward_ios, color: AppColors.onTime, size: 16) : const SizedBox(width: 24),
                      title: Text(
                        '${departure.scheduledTime.hour.toString().padLeft(2, '0')}:${departure.scheduledTime.minute.toString().padLeft(2, '0')}',
                        style: timeStyle,
                      ),
                      trailing: Text('Voie ${departure.platform}', style: platformStyle),
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

