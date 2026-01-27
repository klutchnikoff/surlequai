import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:surlequai/screens/add_trip_screen.dart';
import 'package:surlequai/screens/settings_screen.dart';
import 'package:surlequai/services/trip_provider.dart';
import 'package:surlequai/widgets/direction_card.dart';
import 'package:surlequai/widgets/last_update_indicator.dart';
import 'package:surlequai/widgets/schedules_modal.dart';
import 'package:surlequai/widgets/status_banner.dart';
import 'package:surlequai/widgets/trips_drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    // Quand l'app revient au premier plan, forcer un rafraîchissement
    if (state == AppLifecycleState.resumed) {
      final tripProvider = context.read<TripProvider>();
      tripProvider.refreshDepartures();
    }
  }

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
    // Cas : Aucun trajet configuré (premier lancement ou tout supprimé)
    if (tripProvider.trips.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.train, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              'Bienvenue sur le quai !',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Configurez votre premier trajet\npour voir les prochains départs.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddTripScreen()),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('Ajouter mon trajet'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      );
    }

    final viewModelGo = tripProvider.directionGoViewModel;
    final viewModelReturn = tripProvider.directionReturnViewModel;
    final activeTrip = tripProvider.activeTrip;

    // Si on a des trajets mais que les viewModels ne sont pas encore prêts (chargement initial)
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
