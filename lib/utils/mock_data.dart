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

  static final Map<String, List<Departure>> departuresData = {
    // Trip 1
    'trip-1_go': [
      Departure(id: 'd-g-1', scheduledTime: DateTime.now().add(const Duration(minutes: 12)), platform: '3', status: DepartureStatus.onTime),
      Departure(id: 'd-g-2', scheduledTime: DateTime.now().add(const Duration(minutes: 42)), platform: '2', status: DepartureStatus.onTime),
    ],
    'trip-1_return': [
      Departure(id: 'd-r-1', scheduledTime: DateTime.now().add(const Duration(minutes: 27)), platform: '1', status: DepartureStatus.delayed, delayMinutes: 5),
      Departure(id: 'd-r-2', scheduledTime: DateTime.now().add(const Duration(minutes: 57)), platform: '2', status: DepartureStatus.cancelled),
    ],
    // Trip 2
    'trip-2_go': [
       Departure(id: 'd-g-p-1', scheduledTime: DateTime.now().add(const Duration(minutes: 5)), platform: 'A', status: DepartureStatus.delayed, delayMinutes: 15),
    ],
    'trip-2_return': [],
    // Trip 3
    'trip-3_go': [],
    'trip-3_return': [
      Departure(id: 'd-r-b-1', scheduledTime: DateTime.now().add(const Duration(minutes: 18)), platform: '7', status: DepartureStatus.onTime),
    ],
  };
}