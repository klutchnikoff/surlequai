import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:surlequai/screens/add_trip_screen.dart';
import 'package:surlequai/services/trip_provider.dart';
import 'package:surlequai/theme/colors.dart';
import 'package:surlequai/theme/text_styles.dart';
import 'package:surlequai/utils/constants.dart';

class TripsDrawer extends StatelessWidget {
  const TripsDrawer({super.key});

  Future<void> _confirmDeleteTrip(
      BuildContext context, String tripId, String tripName) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer le trajet'),
        content: Text('Voulez-vous vraiment supprimer le trajet $tripName ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      final tripProvider = context.read<TripProvider>();
      final error = await tripProvider.removeTrip(tripId);

      if (context.mounted) {
        if (error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(error),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
        } else {
          // Feedback haptique de succès
          HapticFeedback.lightImpact();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Trajet $tripName supprimé'),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      }
    }
  }

  Future<void> _navigateToAddTrip(BuildContext context) async {
    Navigator.pop(context); // Fermer le drawer d'abord
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddTripScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Using `watch` so the drawer rebuilds and shows the new active trip
    final tripProvider = context.watch<TripProvider>();
    final allTrips = tripProvider.trips;
    final activeTrip = tripProvider.activeTrip;
    final canAddMoreTrips = allTrips.length < AppConstants.maxFavoriteTrips;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: AppColors.primary,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Mes trajets',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ],
            ),
          ),
          for (var trip in allTrips)
            ListTile(
              leading: Icon(
                trip.id == activeTrip?.id ? Icons.arrow_forward_ios : null,
                size: 16,
                color: Theme.of(context).primaryColor,
              ),
              title: Text('${trip.stationA.name} ⟷ ${trip.stationB.name}'),
              trailing: IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: () => _confirmDeleteTrip(
                  context,
                  trip.id,
                  '${trip.stationA.name} ⟷ ${trip.stationB.name}',
                ),
                tooltip: 'Supprimer',
              ),
              selected: trip.id == activeTrip?.id,
              selectedTileColor:
                  Theme.of(context).primaryColor.withValues(alpha: 0.1),
              onTap: () {
                // Using `read` here as we are in a callback, not the build method
                context.read<TripProvider>().setActiveTrip(trip);
                Navigator.pop(context); // Close the drawer
              },
            ),
          const Divider(),
          ListTile(
            leading: Icon(
              Icons.add,
              color: canAddMoreTrips ? null : Theme.of(context).disabledColor,
            ),
            title: Text(
              'Ajouter un trajet',
              style: canAddMoreTrips
                  ? null
                  : TextStyle(color: Theme.of(context).disabledColor),
            ),
            subtitle: Text(
              '${allTrips.length}/${AppConstants.maxFavoriteTrips} trajets',
              style: AppTextStyles.tiny,
            ),
            enabled: canAddMoreTrips,
            onTap: canAddMoreTrips ? () => _navigateToAddTrip(context) : null,
          ),
        ],
      ),
    );
  }
}
