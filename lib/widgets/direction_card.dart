import 'package:flutter/material.dart';
import 'package:surlequai/models/direction_card_view_model.dart';
import 'package:surlequai/theme/colors.dart';
import 'package:surlequai/theme/text_styles.dart';

class DirectionCard extends StatelessWidget {
  final DirectionCardViewModel viewModel;
  final VoidCallback? onTap;

  const DirectionCard({
    super.key,
    required this.viewModel,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 10,
              color: viewModel.statusBarColor,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          viewModel.title,
                          style: AppTextStyles.medium
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      if (viewModel is DirectionCardWithDepartures &&
                          (viewModel as DirectionCardWithDepartures).durationMinutes != null) ...[
                        const SizedBox(width: 8),
                        Icon(Icons.timer_outlined, size: 18, color: AppColors.secondary),
                        const SizedBox(width: 4),
                        Text(
                          '${(viewModel as DirectionCardWithDepartures).durationMinutes} min',
                          style: AppTextStyles.small.copyWith(color: AppColors.secondary),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 16),
                  switch (viewModel) {
                    DirectionCardWithDepartures vm =>
                      _buildDepartureInfo(context, vm),
                    DirectionCardNoDepartures vm =>
                      _buildNoDeparturesInfo(context, vm),
                  },
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDepartureInfo(
    BuildContext context,
    DirectionCardWithDepartures viewModel,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(viewModel.time, style: AppTextStyles.huge),
            Text(viewModel.platform, style: AppTextStyles.large),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          viewModel.statusText,
          style: AppTextStyles.medium.copyWith(color: viewModel.statusColor),
        ),
        const SizedBox(height: 24),
        if (viewModel.subsequentDepartures != null)
          Text(
            viewModel.subsequentDepartures!,
            style: AppTextStyles.small.copyWith(color: AppColors.secondary),
          ),
      ],
    );
  }

  Widget _buildNoDeparturesInfo(
    BuildContext context,
    DirectionCardNoDepartures viewModel,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(viewModel.noTrainTimeDisplay, style: AppTextStyles.huge),
            // No platform for "no departures" state, keep it empty or add placeholder
          ],
        ),
        const SizedBox(height: 8),
        Text(
          viewModel.noTrainStatusDisplay,
          style: AppTextStyles.medium
              .copyWith(color: viewModel.noTrainStatusColor),
        ),
        const SizedBox(height: 24),
        // No subsequent departures for "no departures" state
      ],
    );
  }
}
