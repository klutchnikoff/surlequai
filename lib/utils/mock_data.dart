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

  /// Génère des horaires avec un train toutes les 20 minutes
  ///
  /// Utile pour tester le rafraîchissement automatique du widget.
  /// Génère des trains de 5h00 à 22h00 (toutes les 20 minutes).
  static List<Departure> _generateEvery20MinutesDepartures({
    required String baseId,
    required List<String> platforms,
  }) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final departures = <Departure>[];

    int trainIndex = 0;

    // De 5h00 à 22h00, un train toutes les 20 minutes
    for (int hour = 5; hour <= 22; hour++) {
      for (int minute in [0, 20, 40]) {
        // Arrêter à 22h00 (pas 22h20, 22h40)
        if (hour == 22 && minute > 0) break;

        final scheduledTime = today.add(Duration(hours: hour, minutes: minute));

        // Varier un peu les statuts pour le réalisme
        DepartureStatus status;
        int delay = 0;

        if (trainIndex % 15 == 7) {
          // ~7% de trains supprimés
          status = DepartureStatus.cancelled;
        } else if (trainIndex % 7 == 3) {
          // ~14% de trains en retard
          status = DepartureStatus.delayed;
          delay = [3, 5, 8, 12][trainIndex % 4];
        } else {
          // ~79% de trains à l'heure
          status = DepartureStatus.onTime;
        }

        departures.add(Departure(
          id: '$baseId-$trainIndex',
          scheduledTime: scheduledTime,
          platform: platforms[trainIndex % platforms.length],
          status: status,
          delayMinutes: delay,
        ));

        trainIndex++;
      }
    }

    return departures;
  }

  static final Map<String, List<Departure>> departuresData = {
    // Trip 1: Rennes ⟷ Nantes (un train toutes les 20 minutes pour tests)
    'trip-1_go': _generateEvery20MinutesDepartures(
      baseId: 'd-rennes-nantes',
      platforms: ['3', '2', '4'],
    ),
    'trip-1_return': _generateEvery20MinutesDepartures(
      baseId: 'd-nantes-rennes',
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
