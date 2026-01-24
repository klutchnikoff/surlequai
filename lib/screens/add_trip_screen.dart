import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:surlequai/models/station.dart';
import 'package:surlequai/models/trip.dart';
import 'package:surlequai/screens/station_picker_screen.dart';
import 'package:surlequai/services/trip_provider.dart';
import 'package:surlequai/theme/text_styles.dart';

class AddTripScreen extends StatefulWidget {
  const AddTripScreen({super.key});

  @override
  State<AddTripScreen> createState() => _AddTripScreenState();
}

class _AddTripScreenState extends State<AddTripScreen> {
  Station? _stationA;
  Station? _stationB;
  MorningDirection _morningDirection = MorningDirection.aToB;
  bool _isLoading = false;

  Future<void> _selectStationA() async {
    final station = await Navigator.push<Station>(
      context,
      MaterialPageRoute(
        builder: (context) => const StationPickerScreen(
          title: 'Gare de départ',
        ),
      ),
    );

    if (station != null) {
      setState(() {
        _stationA = station;
      });
    }
  }

  Future<void> _selectStationB() async {
    final station = await Navigator.push<Station>(
      context,
      MaterialPageRoute(
        builder: (context) => const StationPickerScreen(
          title: 'Gare d\'arrivée',
        ),
      ),
    );

    if (station != null) {
      setState(() {
        _stationB = station;
      });
    }
  }

  Future<void> _addTrip() async {
    if (_stationA == null || _stationB == null) {
      _showErrorSnackBar('Veuillez sélectionner les deux gares');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final tripProvider = context.read<TripProvider>();
    final error = await tripProvider.addTrip(
      stationA: _stationA!,
      stationB: _stationB!,
      morningDirection: _morningDirection,
    );

    setState(() {
      _isLoading = false;
    });

    if (!mounted) return;

    if (error != null) {
      _showErrorSnackBar(error);
    } else {
      // Feedback haptique de succès
      HapticFeedback.lightImpact();
      // Fermer l'écran
      Navigator.pop(context);
      // Afficher un message de succès
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Trajet ${_stationA!.name} ⟷ ${_stationB!.name} ajouté'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final canSubmit = _stationA != null && _stationB != null && !_isLoading;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nouveau trajet'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Gare de départ
            const Text('Gare de départ', style: AppTextStyles.medium),
            const SizedBox(height: 8),
            _buildStationSelector(
              station: _stationA,
              hint: 'Sélectionner une gare de départ',
              onTap: _selectStationA,
            ),

            const SizedBox(height: 24),

            // Gare d'arrivée
            const Text('Gare d\'arrivée', style: AppTextStyles.medium),
            const SizedBox(height: 8),
            _buildStationSelector(
              station: _stationB,
              hint: 'Sélectionner une gare d\'arrivée',
              onTap: _selectStationB,
            ),

            const SizedBox(height: 32),

            // Direction du matin
            const Text('Direction du matin', style: AppTextStyles.medium),
            const SizedBox(height: 8),
            Text(
              'Quel trajet faites-vous le matin ?',
              style: AppTextStyles.small.copyWith(
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
            ),
            const SizedBox(height: 16),

            if (_stationA != null && _stationB != null) ...[
              RadioListTile<MorningDirection>(
                title: Text('${_stationA!.name} → ${_stationB!.name}'),
                value: MorningDirection.aToB,
                groupValue: _morningDirection,
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _morningDirection = value;
                    });
                  }
                },
              ),
              RadioListTile<MorningDirection>(
                title: Text('${_stationB!.name} → ${_stationA!.name}'),
                value: MorningDirection.bToA,
                groupValue: _morningDirection,
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _morningDirection = value;
                    });
                  }
                },
              ),
            ] else
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  'Sélectionnez d\'abord les deux gares',
                  style: AppTextStyles.small.copyWith(
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

            const SizedBox(height: 32),

            // Boutons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _isLoading ? null : () => Navigator.pop(context),
                    child: const Text('Annuler'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: canSubmit ? _addTrip : null,
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Ajouter'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStationSelector({
    required Station? station,
    required String hint,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).dividerColor,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Icon(Icons.train),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                station?.name ?? hint,
                style: station != null
                    ? AppTextStyles.medium
                    : AppTextStyles.medium.copyWith(
                        color: Theme.of(context).textTheme.bodySmall?.color,
                      ),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }
}
