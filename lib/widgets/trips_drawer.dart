import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:surlequai/services/trip_provider.dart';

class TripsDrawer extends StatelessWidget {
  const TripsDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    // Using `watch` so the drawer rebuilds and shows the new active trip
    final tripProvider = context.watch<TripProvider>();
    final allTrips = tripProvider.trips;
    final activeTrip = tripProvider.activeTrip;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Mes trajets',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
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
              selected: trip.id == activeTrip?.id,
              selectedTileColor: Theme.of(context).primaryColor.withOpacity(0.1),
              onTap: () {
                // Using `read` here as we are in a callback, not the build method
                context.read<TripProvider>().setActiveTrip(trip);
                Navigator.pop(context); // Close the drawer
              },
            ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.add),
            title: const Text('Ajouter un trajet'),
            onTap: () {
              // TODO: Handle "Add new trip"
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}

