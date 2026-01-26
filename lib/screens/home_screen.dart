import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:surlequai/models/departure.dart';
import 'package:surlequai/screens/settings_screen.dart';
import 'package:surlequai/services/trip_provider.dart';
import 'package:surlequai/widgets/direction_card.dart';
import 'package:surlequai/widgets/last_update_indicator.dart';
import 'package:surlequai/widgets/schedules_modal.dart';
import 'package:surlequai/widgets/status_banner.dart';
import 'package:surlequai/widgets/trips_drawer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _showSchedulesModal(
      BuildContext context, String title, String fromStationId, String toStationId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Important for DraggableScrollableSheet
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SchedulesModal(
        title: title,
        fromStationId: fromStationId,
        toStationId: toStationId,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Watch for changes in the TripProvider
    final tripProvider = context.watch<TripProvider>();

    return Scaffold(
      drawer: const TripsDrawer(),
      appBar: AppBar(
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('SurLeQuai'),
            LastUpdateIndicator(lastUpdate: tripProvider.lastUpdate),
          ],
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Rafraîchir',
            onPressed: () {
              tripProvider.refreshDepartures();
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Paramètres',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: tripProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildContent(context, tripProvider),
    );
  }

  Widget _buildContent(BuildContext context, TripProvider tripProvider) {
    final viewModelGo = tripProvider.directionGoViewModel;
    final viewModelReturn = tripProvider.directionReturnViewModel;
    final activeTrip = tripProvider.activeTrip;

    // The viewModels can be null for a single frame before the provider is ready
    if (viewModelGo == null || viewModelReturn == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        // Bandeau d'état
        StatusBanner(status: tripProvider.connectionStatus),
        // Contenu principal
        Expanded(
          child: RefreshIndicator(
            onRefresh: () => tripProvider.refreshDepartures(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ListView(
                children: [
                  DirectionCard(
                    viewModel: viewModelGo,
                    onTap: activeTrip != null
                        ? () => _showSchedulesModal(
                              context,
                              viewModelGo.title,
                              activeTrip.stationA.id,
                              activeTrip.stationB.id,
                            )
                        : null,
                  ),
                  DirectionCard(
                    viewModel: viewModelReturn,
                    onTap: activeTrip != null
                        ? () => _showSchedulesModal(
                              context,
                              viewModelReturn.title,
                              activeTrip.stationB.id,
                              activeTrip.stationA.id,
                            )
                        : null,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
