import 'package:surlequai/models/station.dart';

/// Liste des principales gares françaises
///
/// Cette liste statique sera remplacée par l'API SNCF une fois
/// le service API implémenté. Elle contient les gares les plus
/// importantes du réseau TER et Intercités.
///
/// Format des IDs : codes UIC ou codes gare SNCF
class StationsData {
  StationsData._();

  static const List<Station> mainStations = [
    // Île-de-France (codes UIC 87XXXXX)
    Station(id: 'stop_area:SNCF:87391003', name: 'Paris Montparnasse'),
    Station(id: 'stop_area:SNCF:87686006', name: 'Paris Gare de Lyon'),
    Station(id: 'stop_area:SNCF:87271007', name: 'Paris Gare du Nord'),
    Station(id: 'stop_area:SNCF:87113001', name: 'Paris Gare de l\'Est'),
    Station(id: 'stop_area:SNCF:87547000', name: 'Paris Austerlitz'),
    Station(id: 'stop_area:SNCF:87384008', name: 'Paris St-Lazare'),
    Station(id: 'stop_area:SNCF:87001479', name: 'Versailles Chantiers'),
    Station(id: 'stop_area:SNCF:87393009', name: 'Marne-la-Vallée Chessy'),

    // Bretagne (codes UIC 87XXX)
    Station(id: 'stop_area:SNCF:87471003', name: 'Rennes'),
    Station(id: 'stop_area:SNCF:87473801', name: 'Brest'),
    Station(id: 'stop_area:SNCF:87477109', name: 'Quimper'),
    Station(id: 'stop_area:SNCF:87481758', name: 'Lorient'),
    Station(id: 'stop_area:SNCF:87481051', name: 'Vannes'),
    Station(id: 'stop_area:SNCF:87470005', name: 'Saint-Brieuc'),
    Station(id: 'stop_area:SNCF:87471847', name: 'Saint-Malo'),

    // Pays de la Loire
    Station(id: 'stop_area:SNCF:87481002', name: 'Nantes'),
    Station(id: 'stop_area:SNCF:87481000', name: 'Angers St-Laud'),
    Station(id: 'stop_area:SNCF:87386009', name: 'Le Mans'),
    Station(id: 'stop_area:SNCF:87485003', name: 'La Roche-sur-Yon'),
    Station(id: 'stop_area:SNCF:87486005', name: 'Laval'),

    // Nouvelle-Aquitaine
    Station(id: 'stop_area:SNCF:87581009', name: 'Bordeaux St-Jean'),
    Station(id: 'stop_area:SNCF:87386003', name: 'Poitiers'),
    Station(id: 'stop_area:SNCF:87484006', name: 'La Rochelle'),
    Station(id: 'stop_area:SNCF:87576009', name: 'Angoulême'),
    Station(id: 'stop_area:SNCF:87587006', name: 'Limoges Bénédictins'),
    Station(id: 'stop_area:SNCF:87584008', name: 'Pau'),
    Station(id: 'stop_area:SNCF:87581199', name: 'Bayonne'),
    Station(id: 'stop_area:SNCF:87581207', name: 'Biarritz'),

    // Occitanie
    Station(id: 'stop_area:SNCF:87611004', name: 'Toulouse Matabiau'),
    Station(id: 'stop_area:SNCF:87773002', name: 'Montpellier St-Roch'),
    Station(id: 'stop_area:SNCF:87774006', name: 'Perpignan'),
    Station(id: 'stop_area:SNCF:87781005', name: 'Narbonne'),
    Station(id: 'stop_area:SNCF:87782003', name: 'Béziers'),
    Station(id: 'stop_area:SNCF:87616003', name: 'Albi'),
    Station(id: 'stop_area:SNCF:87617009', name: 'Tarbes'),

    // Auvergne-Rhône-Alpes
    Station(id: 'stop_area:SNCF:87723197', name: 'Lyon Part-Dieu'),
    Station(id: 'stop_area:SNCF:87722025', name: 'Lyon Perrache'),
    Station(id: 'stop_area:SNCF:87747006', name: 'Grenoble'),
    Station(id: 'stop_area:SNCF:87745000', name: 'Chambéry'),
    Station(id: 'stop_area:SNCF:87747204', name: 'Annecy'),
    Station(id: 'stop_area:SNCF:87768002', name: 'Valence TGV'),
    Station(id: 'stop_area:SNCF:87734004', name: 'Clermont-Ferrand'),
    Station(id: 'stop_area:SNCF:87726000', name: 'Saint-Étienne Châteaucreux'),

    // Provence-Alpes-Côte d'Azur
    Station(id: 'stop_area:SNCF:87751008', name: 'Marseille St-Charles'),
    Station(id: 'stop_area:SNCF:87756056', name: 'Nice Ville'),
    Station(id: 'stop_area:SNCF:87757005', name: 'Toulon'),
    Station(id: 'stop_area:SNCF:87765008', name: 'Avignon TGV'),
    Station(id: 'stop_area:SNCF:87767004', name: 'Aix-en-Provence TGV'),
    Station(id: 'stop_area:SNCF:87755009', name: 'Cannes'),
    Station(id: 'stop_area:SNCF:87756007', name: 'Antibes'),

    // Grand Est
    Station(id: 'stop_area:SNCF:87212027', name: 'Strasbourg'),
    Station(id: 'stop_area:SNCF:87192039', name: 'Metz Ville'),
    Station(id: 'stop_area:SNCF:87141002', name: 'Nancy Ville'),
    Station(id: 'stop_area:SNCF:87171009', name: 'Reims'),
    Station(id: 'stop_area:SNCF:87182014', name: 'Mulhouse Ville'),
    Station(id: 'stop_area:SNCF:87182063', name: 'Colmar'),
    Station(id: 'stop_area:SNCF:87143008', name: 'Épinal'),

    // Bourgogne-Franche-Comté
    Station(id: 'stop_area:SNCF:87713040', name: 'Dijon Ville'),
    Station(id: 'stop_area:SNCF:87743005', name: 'Besançon Viotte'),
    Station(id: 'stop_area:SNCF:87182055', name: 'Belfort'),

    // Hauts-de-France
    Station(id: 'stop_area:SNCF:87286005', name: 'Lille Flandres'),
    Station(id: 'stop_area:SNCF:87223263', name: 'Lille Europe'),
    Station(id: 'stop_area:SNCF:87276006', name: 'Amiens'),
    Station(id: 'stop_area:SNCF:87284002', name: 'Arras'),
    Station(id: 'stop_area:SNCF:87223004', name: 'Calais Ville'),
    Station(id: 'stop_area:SNCF:87224006', name: 'Dunkerque'),

    // Normandie
    Station(id: 'stop_area:SNCF:87413005', name: 'Rouen Rive-Droite'),
    Station(id: 'stop_area:SNCF:87444000', name: 'Caen'),
    Station(id: 'stop_area:SNCF:87415000', name: 'Le Havre'),
    Station(id: 'stop_area:SNCF:87444158', name: 'Cherbourg'),

    // Centre-Val de Loire
    Station(id: 'stop_area:SNCF:87571000', name: 'Tours'),
    Station(id: 'stop_area:SNCF:87543009', name: 'Orléans'),
    Station(id: 'stop_area:SNCF:87576025', name: 'Bourges'),
    Station(id: 'stop_area:SNCF:87544007', name: 'Blois'),
  ];

  /// Recherche des gares par nom (insensible à la casse et aux accents)
  static List<Station> searchStations(String query) {
    if (query.isEmpty) {
      return mainStations;
    }

    final normalizedQuery = _normalizeString(query.toLowerCase());

    return mainStations.where((station) {
      final normalizedName = _normalizeString(station.name.toLowerCase());
      return normalizedName.contains(normalizedQuery);
    }).toList();
  }

  /// Normalise une chaîne en retirant les accents
  static String _normalizeString(String input) {
    const accents = 'ÀÁÂÃÄÅàáâãäåÒÓÔÕÖØòóôõöøÈÉÊËèéêëÇçÌÍÎÏìíîïÙÚÛÜùúûüÿÑñ';
    const withoutAccents =
        'AAAAAAaaaaaaOOOOOOooooooEEEEeeeeCcIIIIiiiiUUUUuuuuyNn';

    String result = input;
    for (int i = 0; i < accents.length; i++) {
      result = result.replaceAll(accents[i], withoutAccents[i]);
    }
    return result;
  }
}
