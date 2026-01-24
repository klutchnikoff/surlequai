import 'package:surlequai/models/departure.dart';
import 'package:surlequai/models/trip.dart';
import 'package:surlequai/models/station.dart'; // Added missing import

// This class now only serves to provide initial, raw data.
// All logic is handled by the providers.
class InitialMockData {
  static final List<Trip> initialTrips = [
    const Trip(
      id: 'trip-1',
      stationA: Station(id: 'rennes', name: 'Rennes'),
      stationB: Station(id: 'nantes', name: 'Nantes'),
    ),
    const Trip(
      id: 'trip-2',
      stationA: Station(id: 'paris', name: 'Paris Montparnasse'),
      stationB: Station(id: 'lyon', name: 'Lyon Part-Dieu'),
    ),
    const Trip(
      id: 'trip-3',
      stationA: Station(id: 'bordeaux', name: 'Bordeaux St-Jean'),
      stationB: Station(id: 'toulouse', name: 'Toulouse Matabiau'),
    ),
  ];

  /// Génère des horaires réalistes pour une journée type TER
  ///
  /// Retourne une liste de départs pour un trajet donné, avec une densité
  /// plus importante aux heures de pointe (6h-9h et 16h-19h).
  static List<Departure> _generateRealisticDepartures({
    required String baseId,
    required int startHour,
    required List<String> platforms,
  }) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final departures = <Departure>[];

    // Horaires avec densité variable
    // Format: (heure, minute, voie_index, status, delay)
    final schedule = [
      // Début de matinée (5h-6h) - 2 trains
      (5, 42, 0, DepartureStatus.onTime, 0),
      (6, 12, 1, DepartureStatus.onTime, 0),
      // Heure de pointe matin (6h-9h) - 8 trains
      (6, 42, 0, DepartureStatus.onTime, 0),
      (7, 02, 2, DepartureStatus.delayed, 3),
      (7, 27, 1, DepartureStatus.onTime, 0),
      (7, 47, 0, DepartureStatus.onTime, 0),
      (8, 12, 2, DepartureStatus.onTime, 0),
      (8, 37, 1, DepartureStatus.delayed, 5),
      (8, 52, 0, DepartureStatus.onTime, 0),
      (9, 17, 2, DepartureStatus.onTime, 0),
      // Mi-journée (9h-16h) - 7 trains
      (9, 47, 1, DepartureStatus.onTime, 0),
      (10, 32, 0, DepartureStatus.onTime, 0),
      (11, 17, 2, DepartureStatus.cancelled, 0),
      (12, 12, 1, DepartureStatus.onTime, 0),
      (13, 42, 0, DepartureStatus.onTime, 0),
      (14, 27, 2, DepartureStatus.delayed, 8),
      (15, 47, 1, DepartureStatus.onTime, 0),
      // Heure de pointe soir (16h-19h) - 8 trains
      (16, 12, 0, DepartureStatus.onTime, 0),
      (16, 37, 2, DepartureStatus.onTime, 0),
      (17, 02, 1, DepartureStatus.delayed, 4),
      (17, 27, 0, DepartureStatus.onTime, 0),
      (17, 52, 2, DepartureStatus.onTime, 0),
      (18, 17, 1, DepartureStatus.onTime, 0),
      (18, 42, 0, DepartureStatus.delayed, 6),
      (19, 07, 2, DepartureStatus.onTime, 0),
      // Fin de soirée (19h-22h) - 4 trains
      (19, 42, 1, DepartureStatus.onTime, 0),
      (20, 27, 0, DepartureStatus.onTime, 0),
      (21, 12, 2, DepartureStatus.onTime, 0),
      (21, 52, 1, DepartureStatus.onTime, 0),
    ];

    for (var i = 0; i < schedule.length; i++) {
      final (hour, minute, platformIndex, status, delay) = schedule[i];
      final scheduledTime = today.add(Duration(hours: hour, minutes: minute));

      departures.add(Departure(
        id: '$baseId-$i',
        scheduledTime: scheduledTime,
        platform: platforms[platformIndex % platforms.length],
        status: status,
        delayMinutes: delay,
      ));
    }

    return departures;
  }

  static final Map<String, List<Departure>> departuresData = {
    // Trip 1: Rennes ⟷ Nantes (trajets TER réalistes)
    'trip-1_go': _generateRealisticDepartures(
      baseId: 'd-rennes-nantes',
      startHour: 5,
      platforms: ['3', '2', '4'],
    ),
    'trip-1_return': _generateRealisticDepartures(
      baseId: 'd-nantes-rennes',
      startHour: 5,
      platforms: ['1', '2', '3'],
    ),
    // Trip 2: Paris ⟷ Lyon (quelques trains pour tester)
    'trip-2_go': [
      Departure(
          id: 'd-paris-lyon-1',
          scheduledTime: DateTime.now().add(const Duration(minutes: 5)),
          platform: 'A',
          status: DepartureStatus.delayed,
          delayMinutes: 15),
      Departure(
          id: 'd-paris-lyon-2',
          scheduledTime: DateTime.now().add(const Duration(hours: 2)),
          platform: 'B',
          status: DepartureStatus.onTime),
    ],
    'trip-2_return': [],
    // Trip 3: Bordeaux ⟷ Toulouse (quelques trains pour tester)
    'trip-3_go': [],
    'trip-3_return': [
      Departure(
          id: 'd-toulouse-bordeaux-1',
          scheduledTime: DateTime.now().add(const Duration(minutes: 18)),
          platform: '7',
          status: DepartureStatus.onTime),
      Departure(
          id: 'd-toulouse-bordeaux-2',
          scheduledTime: DateTime.now().add(const Duration(hours: 1)),
          platform: '5',
          status: DepartureStatus.onTime),
    ],
  };
}
