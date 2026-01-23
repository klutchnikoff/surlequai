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
                  Text(
                    viewModel.title,
                    style: AppTextStyles.medium.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  if (viewModel.hasDepartures)
                    _buildDepartureInfo(context)
                  else
                    _buildNoDeparturesInfo(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDepartureInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(viewModel.time ?? '', style: AppTextStyles.huge),
            Text(viewModel.platform ?? '', style: AppTextStyles.large),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          viewModel.statusText ?? '',
          style: AppTextStyles.medium.copyWith(color: viewModel.statusColor),
        ),
        const SizedBox(height: 24),
        if (viewModel.subsequentDepartures != null)
          Text(
            viewModel.subsequentDepartures!, // This one is safe due to the check
            style: AppTextStyles.small.copyWith(color: AppColors.secondary),
          ),
      ],
    );
  }

  Widget _buildNoDeparturesInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(viewModel.noTrainTimeDisplay ?? '--:--', style: AppTextStyles.huge),
            // No platform for "no departures" state, keep it empty or add placeholder
          ],
        ),
        const SizedBox(height: 8),
        Text(
          viewModel.noTrainStatusDisplay ?? 'Aucun train prévu pour l\'instant',
          style: AppTextStyles.medium.copyWith(color: viewModel.noTrainStatusColor ?? AppColors.secondary),
        ),
        const SizedBox(height: 24),
        // No subsequent departures for "no departures" state
      ],
    );
  }
}
