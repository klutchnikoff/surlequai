import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:surlequai/models/settings.dart';
import 'package:surlequai/models/trip.dart';
import 'package:surlequai/services/settings_provider.dart';
import 'package:surlequai/services/trip_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Paramètres'),
        centerTitle: true,
      ),
      body: Consumer2<SettingsProvider, TripProvider>(
        builder: (context, settingsProvider, tripProvider, child) {
          return ListView(
            children: [
              _buildSectionTitle(context, 'AFFICHAGE'),
              _buildThemeSetting(context, settingsProvider),
              _buildDisplayOrderSetting(context, tripProvider),
              const Divider(),
              _buildTimeBehaviorSetting(context, settingsProvider),
              const Divider(),
              _buildSectionTitle(context, 'DONNÉES'),
              _buildClearCacheButton(context),
              const Divider(),
              // TODO: Add other sections (NOTIFICATIONS, INTERFACE, À PROPOS)
            ],
          );
        },
      ),
    );
  }

  Widget _buildClearCacheButton(BuildContext context) {
    return ListTile(
      title: const Text('Vider le cache'),
      subtitle: const Text('Supprime les horaires théoriques en cache'),
      leading: const Icon(Icons.delete_outline),
      onTap: () async {
        // Confirmation
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Vider le cache'),
            content: const Text(
                'Cela supprimera tous les horaires théoriques en cache. '
                'Les données seront rechargées à la prochaine consultation.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Annuler'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Vider'),
              ),
            ],
          ),
        );

        if (confirmed == true && context.mounted) {
          try {
            final prefs = await SharedPreferences.getInstance();
            final keys = prefs.getKeys();

            // Supprimer uniquement les clés de cache (commencent par "journeys_")
            int removed = 0;
            for (final key in keys) {
              if (key.startsWith('journeys_')) {
                await prefs.remove(key);
                removed++;
              }
            }

            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Cache vidé ($removed entrée${removed > 1 ? 's' : ''})'),
                  backgroundColor: Colors.green,
                ),
              );
            }
          } catch (e) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Erreur: $e'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          }
        }
      },
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Text(
        title,
        style: Theme.of(context)
            .textTheme
            .titleSmall
            ?.copyWith(color: Theme.of(context).colorScheme.primary),
      ),
    );
  }

  Widget _buildThemeSetting(
      BuildContext context, SettingsProvider settingsProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ListTile(
          title: Text('Thème'),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildThemeRadio(context, AppThemeMode.light, 'Clair'),
            _buildThemeRadio(context, AppThemeMode.system, 'Auto'),
            _buildThemeRadio(context, AppThemeMode.dark, 'Sombre'),
          ],
        ),
      ],
    );
  }

  Widget _buildThemeRadio(
      BuildContext context, AppThemeMode mode, String text) {
    final settingsProvider = context.watch<SettingsProvider>();

    return Expanded(
      child: RadioListTile<AppThemeMode>(
        title: Text(text),
        value: mode,
        groupValue: settingsProvider.themeMode,
        onChanged: (AppThemeMode? value) {
          if (value != null) {
            context.read<SettingsProvider>().setThemeMode(value);
          }
        },
      ),
    );
  }

  Widget _buildDisplayOrderSetting(
      BuildContext context, TripProvider tripProvider) {
    final activeTrip = tripProvider.activeTrip;

    if (activeTrip == null) {
      return const ListTile(
        title: Text('Ordre d\'affichage automatique'),
        subtitle: Text('Chargement...'),
        enabled: false,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ListTile(
          title: Text('Ordre d\'affichage automatique'),
          subtitle: Text(
              'Le trajet du matin est affiché en premier avant l\'heure de bascule.'),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
              'Trajet du matin pour "${activeTrip.stationA.name} ⟷ ${activeTrip.stationB.name}"',
              style: Theme.of(context).textTheme.titleSmall),
        ),
        _buildMorningDirectionRadio(context, MorningDirection.aToB,
            '${activeTrip.stationA.name} → ${activeTrip.stationB.name}'),
        _buildMorningDirectionRadio(context, MorningDirection.bToA,
            '${activeTrip.stationB.name} → ${activeTrip.stationA.name}'),
      ],
    );
  }

  Widget _buildMorningDirectionRadio(
      BuildContext context, MorningDirection direction, String text) {
    final tripProvider = context.watch<TripProvider>();
    return ListTile(
      title: Text(text),
      leading: Radio<MorningDirection>(
        value: direction,
        groupValue: tripProvider.activeTrip?.morningDirection,
        onChanged: (MorningDirection? value) {
          if (value != null) {
            context
                .read<TripProvider>()
                .updateActiveTripMorningDirection(value);
          }
        },
      ),
    );
  }

  Widget _buildTimeBehaviorSetting(
      BuildContext context, SettingsProvider settingsProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(context, 'COMPORTEMENT HORAIRE'),
        ListTile(
          title: const Text('Bascule matin/soir'),
          subtitle: Text(
              'Heure à partir de laquelle le trajet du soir est prioritaire : ${settingsProvider.morningEveningSplitTime}h'),
          trailing: const Icon(Icons.edit),
          onTap: () async {
            final TimeOfDay? picked = await showTimePicker(
              context: context,
              initialTime: TimeOfDay(
                  hour: settingsProvider.morningEveningSplitTime, minute: 0),
            );
            if (picked != null && context.mounted) {
              context
                  .read<SettingsProvider>()
                  .setMorningEveningSplitTime(picked.hour);
            }
          },
        ),
        ListTile(
          title: const Text('Début du jour de service'),
          subtitle: Text(
              'Heure de départ du premier train de la journée : ${settingsProvider.serviceDayStartTime}h'),
          trailing: const Icon(Icons.edit),
          onTap: () async {
            final TimeOfDay? picked = await showTimePicker(
              context: context,
              initialTime: TimeOfDay(
                  hour: settingsProvider.serviceDayStartTime, minute: 0),
            );
            if (picked != null && context.mounted) {
              context
                  .read<SettingsProvider>()
                  .setServiceDayStartTime(picked.hour);
            }
          },
        ),
      ],
    );
  }
}
