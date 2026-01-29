import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:surlequai/models/settings.dart';
import 'package:surlequai/models/trip.dart';
import 'package:surlequai/screens/about_screen.dart';
import 'package:surlequai/services/api_key_service.dart';
import 'package:surlequai/services/settings_provider.dart';
import 'package:surlequai/services/trip_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController _apiKeyController = TextEditingController();
  bool _isTestingKey = false;
  bool _isSavingKey = false;
  String? _keyTestResult;

  @override
  void initState() {
    super.initState();
    // Charger la clé après le premier frame pour avoir accès au Provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadCustomKey();
    });
  }

  @override
  void dispose() {
    _apiKeyController.dispose();
    super.dispose();
  }

  /// Charge la clé personnalisée si elle existe
  Future<void> _loadCustomKey() async {
    final apiKeyService = context.read<ApiKeyService>();
    final customKey = await apiKeyService.getCustomKey();
    if (customKey != null && mounted) {
      setState(() {
        _apiKeyController.text = customKey;
      });
    }
  }
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
              _buildSectionTitle(context, 'AVANCÉ'),
              _buildCustomApiKeySetting(context),
              const Divider(),
              _buildSectionTitle(context, 'À PROPOS'),
              _buildAboutButton(context),
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
        RadioGroup<AppThemeMode>(
          groupValue: settingsProvider.themeMode,
          onChanged: (AppThemeMode? value) {
            if (value != null) {
              context.read<SettingsProvider>().setThemeMode(value);
            }
          },
          child: Column(
            children: [
              _buildThemeRadio(context, AppThemeMode.light, 'Clair'),
              _buildThemeRadio(context, AppThemeMode.system, 'Auto'),
              _buildThemeRadio(context, AppThemeMode.dark, 'Sombre'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildThemeRadio(
      BuildContext context, AppThemeMode mode, String text) {
    return RadioListTile<AppThemeMode>(
      title: Text(text),
      value: mode,
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
        RadioGroup<MorningDirection>(
          groupValue: tripProvider.activeTrip?.morningDirection,
          onChanged: (MorningDirection? value) {
            if (value != null) {
              context
                  .read<TripProvider>()
                  .updateActiveTripMorningDirection(value);
            }
          },
          child: Column(
            children: [
              _buildMorningDirectionRadio(context, MorningDirection.aToB,
                  '${activeTrip.stationA.name} → ${activeTrip.stationB.name}'),
              _buildMorningDirectionRadio(context, MorningDirection.bToA,
                  '${activeTrip.stationB.name} → ${activeTrip.stationA.name}'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMorningDirectionRadio(
      BuildContext context, MorningDirection direction, String text) {
    return ListTile(
      title: Text(text),
      leading: Radio<MorningDirection>(
        value: direction,
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

  Widget _buildCustomApiKeySetting(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ListTile(
          title: Text('Clé API personnalisée (BYOK)'),
          subtitle: Text(
            'Utilisez votre propre clé API SNCF pour bypasser le proxy.\n'
            'Recommandé uniquement pour les utilisateurs avancés.',
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: TextField(
            controller: _apiKeyController,
            decoration: InputDecoration(
              labelText: 'Clé API Navitia',
              hintText: 'Collez votre clé ici (optionnel)',
              border: const OutlineInputBorder(),
              suffixIcon: _apiKeyController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        setState(() {
                          _apiKeyController.clear();
                          _keyTestResult = null;
                        });
                      },
                    )
                  : null,
            ),
            obscureText: true,
            maxLines: 1,
            onChanged: (_) {
              setState(() {
                _keyTestResult = null; // Reset le test quand on modifie
              });
            },
          ),
        ),
        const SizedBox(height: 8),
        if (_keyTestResult != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Icon(
                  _keyTestResult == 'valid'
                      ? Icons.check_circle
                      : Icons.error,
                  color: _keyTestResult == 'valid'
                      ? Colors.green
                      : Colors.red,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _keyTestResult == 'valid'
                        ? 'Clé valide ✓'
                        : 'Clé invalide ou erreur réseau',
                    style: TextStyle(
                      color: _keyTestResult == 'valid'
                          ? Colors.green
                          : Colors.red,
                    ),
                  ),
                ),
              ],
            ),
          ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _isTestingKey || _apiKeyController.text.isEmpty
                      ? null
                      : _testApiKey,
                  icon: _isTestingKey
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.science),
                  label: const Text('Tester'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _isSavingKey ? null : _saveApiKey,
                  icon: _isSavingKey
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.save),
                  label: const Text('Enregistrer'),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: TextButton.icon(
            onPressed: _openSncfWebsite,
            icon: const Icon(Icons.open_in_new, size: 16),
            label: const Text(
              'Obtenir une clé sur numerique.sncf.com',
              style: TextStyle(fontSize: 12),
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            'ℹ️ Si configurée, votre clé sera utilisée pour appeler '
            'directement l\'API SNCF (bypass du proxy). '
            'Laissez vide pour utiliser le proxy par défaut.',
            style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
          ),
        ),
      ],
    );
  }

  Future<void> _testApiKey() async {
    final key = _apiKeyController.text.trim();
    if (key.isEmpty) return;

    setState(() {
      _isTestingKey = true;
      _keyTestResult = null;
    });

    try {
      final apiKeyService = context.read<ApiKeyService>();
      final isValid = await apiKeyService.validateKey(key);

      if (mounted) {
        setState(() {
          _keyTestResult = isValid ? 'valid' : 'invalid';
          _isTestingKey = false;
        });

        // Feedback haptique
        if (isValid) {
          HapticFeedback.lightImpact();
        } else {
          HapticFeedback.heavyImpact();
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _keyTestResult = 'invalid';
          _isTestingKey = false;
        });
        HapticFeedback.heavyImpact();
      }
    }
  }

  Future<void> _saveApiKey() async {
    setState(() {
      _isSavingKey = true;
    });

    try {
      final apiKeyService = context.read<ApiKeyService>();
      final key = _apiKeyController.text.trim();
      final success = await apiKeyService.setCustomKey(key);

      if (mounted) {
        setState(() {
          _isSavingKey = false;
        });

        if (success) {
          HapticFeedback.lightImpact();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                key.isEmpty
                    ? 'Clé personnalisée supprimée'
                    : 'Clé personnalisée enregistrée',
              ),
              backgroundColor: Colors.green,
            ),
          );

          // Demander un redémarrage de l'app pour prendre en compte la nouvelle clé
          _showRestartDialog();
        } else {
          HapticFeedback.heavyImpact();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Erreur lors de l\'enregistrement'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isSavingKey = false;
        });
        HapticFeedback.heavyImpact();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showRestartDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Redémarrage requis'),
        content: const Text(
          'Pour que la nouvelle clé API soit prise en compte, '
          'vous devez redémarrer l\'application.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _openSncfWebsite() async {
    final uri = Uri.parse('https://numerique.sncf.com');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Impossible d\'ouvrir le lien'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    }
  }

  Widget _buildAboutButton(BuildContext context) {
    return ListTile(
      title: const Text('Mentions légales'),
      subtitle: const Text('Informations sur l\'application'),
      leading: const Icon(Icons.info_outline),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AboutScreen()),
        );
      },
    );
  }
}
