import 'package:surlequai/models/departure.dart';
import 'package:surlequai/models/station.dart';
import 'package:surlequai/models/trip.dart';

class MockData {
  static final List<Trip> mockTrips = [
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

  static final Map<String, List<Departure>> _departuresGo = {
    'trip-1': [
      Departure(
        id: 'd-g-1',
        scheduledTime: DateTime.now().add(const Duration(minutes: 12)),
        platform: '3',
        status: DepartureStatus.onTime,
      ),
      Departure(
        id: 'd-g-2',
        scheduledTime: DateTime.now().add(const Duration(minutes: 42)),
        platform: '2',
        status: DepartureStatus.onTime,
      ),
    ],
    'trip-2': [
       Departure(
        id: 'd-g-p-1',
        scheduledTime: DateTime.now().add(const Duration(minutes: 5)),
        platform: 'A',
        status: DepartureStatus.delayed,
        delayMinutes: 15,
      ),
    ],
    'trip-3': [],
  };

  static final Map<String, List<Departure>> _departuresReturn = {
    'trip-1': [
      Departure(
        id: 'd-r-1',
        scheduledTime: DateTime.now().add(const Duration(minutes: 27)),
        platform: '1',
        status: DepartureStatus.delayed,
        delayMinutes: 5,
      ),
      Departure(
        id: 'd-r-2',
        scheduledTime: DateTime.now().add(const Duration(minutes: 57)),
        platform: '2',
        status: DepartureStatus.cancelled,
      ),
    ],
    'trip-2': [],
    'trip-3': [
      Departure(
        id: 'd-r-b-1',
        scheduledTime: DateTime.now().add(const Duration(minutes: 18)),
        platform: '7',
        status: DepartureStatus.onTime,
      ),
    ],
  };

  static List<Departure> getDeparturesGo(String tripId) {
    return _departuresGo[tripId] ?? [];
  }

  static List<Departure> getDeparturesReturn(String tripId) {
    return _departuresReturn[tripId] ?? [];
  }
}

