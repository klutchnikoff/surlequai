import 'package:shared_preferences/shared_preferences.dart';

/// Choix globaux, capturés une fois par recherche (y compris en arrière-plan).
class TransportPreferences {
  final bool includeTgv;
  final bool includeCoach;
  const TransportPreferences({
    this.includeTgv = false,
    this.includeCoach = true,
  });

  static const storageKey = 'transport_preferences';
  String get cacheKey => '${includeTgv ? 1 : 0}${includeCoach ? 1 : 0}';
  static TransportPreferences read(SharedPreferences prefs) {
    final value = prefs.getString(storageKey);
    return TransportPreferences(
      includeTgv: value == '10' || value == '11',
      includeCoach: value != '00' && value != '10',
    );
  }

  List<String> get forbiddenUris => [
    if (!includeTgv) ...['commercial_mode:OUI', 'commercial_mode:TGVOUIGO'],
    // OUIGO Train Classique n'est pas un TGV.
    'commercial_mode:OUIGO_TC',
    if (!includeCoach) 'physical_mode:Coach',
    'physical_mode:RapidTransit',
    'physical_mode:Metro',
    'physical_mode:Tramway',
    'physical_mode:Bus',
  ];
}
