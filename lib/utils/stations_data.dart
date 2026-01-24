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
    // Île-de-France
    Station(id: 'paris-montparnasse', name: 'Paris Montparnasse'),
    Station(id: 'paris-lyon', name: 'Paris Gare de Lyon'),
    Station(id: 'paris-nord', name: 'Paris Gare du Nord'),
    Station(id: 'paris-est', name: 'Paris Gare de l\'Est'),
    Station(id: 'paris-austerlitz', name: 'Paris Austerlitz'),
    Station(id: 'paris-st-lazare', name: 'Paris St-Lazare'),
    Station(id: 'paris-bercy', name: 'Paris Bercy'),
    Station(id: 'versailles', name: 'Versailles Chantiers'),
    Station(id: 'marne-la-vallee', name: 'Marne-la-Vallée Chessy'),

    // Bretagne
    Station(id: 'rennes', name: 'Rennes'),
    Station(id: 'brest', name: 'Brest'),
    Station(id: 'quimper', name: 'Quimper'),
    Station(id: 'lorient', name: 'Lorient'),
    Station(id: 'vannes', name: 'Vannes'),
    Station(id: 'saint-brieuc', name: 'Saint-Brieuc'),
    Station(id: 'saint-malo', name: 'Saint-Malo'),

    // Pays de la Loire
    Station(id: 'nantes', name: 'Nantes'),
    Station(id: 'angers', name: 'Angers St-Laud'),
    Station(id: 'le-mans', name: 'Le Mans'),
    Station(id: 'la-roche-sur-yon', name: 'La Roche-sur-Yon'),
    Station(id: 'laval', name: 'Laval'),

    // Nouvelle-Aquitaine
    Station(id: 'bordeaux', name: 'Bordeaux St-Jean'),
    Station(id: 'poitiers', name: 'Poitiers'),
    Station(id: 'la-rochelle', name: 'La Rochelle'),
    Station(id: 'angouleme', name: 'Angoulême'),
    Station(id: 'limoges', name: 'Limoges Bénédictins'),
    Station(id: 'pau', name: 'Pau'),
    Station(id: 'bayonne', name: 'Bayonne'),
    Station(id: 'biarritz', name: 'Biarritz'),

    // Occitanie
    Station(id: 'toulouse', name: 'Toulouse Matabiau'),
    Station(id: 'montpellier', name: 'Montpellier St-Roch'),
    Station(id: 'perpignan', name: 'Perpignan'),
    Station(id: 'narbonne', name: 'Narbonne'),
    Station(id: 'beziers', name: 'Béziers'),
    Station(id: 'albi', name: 'Albi'),
    Station(id: 'tarbes', name: 'Tarbes'),

    // Auvergne-Rhône-Alpes
    Station(id: 'lyon-part-dieu', name: 'Lyon Part-Dieu'),
    Station(id: 'lyon-perrache', name: 'Lyon Perrache'),
    Station(id: 'grenoble', name: 'Grenoble'),
    Station(id: 'chambery', name: 'Chambéry'),
    Station(id: 'annecy', name: 'Annecy'),
    Station(id: 'valence', name: 'Valence TGV'),
    Station(id: 'clermont-ferrand', name: 'Clermont-Ferrand'),
    Station(id: 'saint-etienne', name: 'Saint-Étienne Châteaucreux'),

    // Provence-Alpes-Côte d'Azur
    Station(id: 'marseille', name: 'Marseille St-Charles'),
    Station(id: 'nice', name: 'Nice Ville'),
    Station(id: 'toulon', name: 'Toulon'),
    Station(id: 'avignon', name: 'Avignon TGV'),
    Station(id: 'aix-en-provence', name: 'Aix-en-Provence TGV'),
    Station(id: 'cannes', name: 'Cannes'),
    Station(id: 'antibes', name: 'Antibes'),

    // Grand Est
    Station(id: 'strasbourg', name: 'Strasbourg'),
    Station(id: 'metz', name: 'Metz Ville'),
    Station(id: 'nancy', name: 'Nancy Ville'),
    Station(id: 'reims', name: 'Reims'),
    Station(id: 'mulhouse', name: 'Mulhouse Ville'),
    Station(id: 'colmar', name: 'Colmar'),
    Station(id: 'epinal', name: 'Épinal'),

    // Bourgogne-Franche-Comté
    Station(id: 'dijon', name: 'Dijon Ville'),
    Station(id: 'besancon', name: 'Besançon Viotte'),
    Station(id: 'belfort', name: 'Belfort'),

    // Hauts-de-France
    Station(id: 'lille-flandres', name: 'Lille Flandres'),
    Station(id: 'lille-europe', name: 'Lille Europe'),
    Station(id: 'amiens', name: 'Amiens'),
    Station(id: 'arras', name: 'Arras'),
    Station(id: 'calais', name: 'Calais Ville'),
    Station(id: 'dunkerque', name: 'Dunkerque'),

    // Normandie
    Station(id: 'rouen', name: 'Rouen Rive-Droite'),
    Station(id: 'caen', name: 'Caen'),
    Station(id: 'le-havre', name: 'Le Havre'),
    Station(id: 'cherbourg', name: 'Cherbourg'),

    // Centre-Val de Loire
    Station(id: 'tours', name: 'Tours'),
    Station(id: 'orleans', name: 'Orléans'),
    Station(id: 'bourges', name: 'Bourges'),
    Station(id: 'blois', name: 'Blois'),
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
