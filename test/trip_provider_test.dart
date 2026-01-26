import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:surlequai/models/departure.dart';
import 'package:surlequai/models/station.dart';
import 'package:surlequai/models/trip.dart';
import 'package:surlequai/services/api_service.dart';
import 'package:surlequai/services/realtime_service.dart';
import 'package:surlequai/services/settings_provider.dart';
import 'package:surlequai/services/storage_service.dart';
import 'package:surlequai/services/timetable_service.dart';
import 'package:surlequai/services/trip_provider.dart';
import 'package:surlequai/services/widget_service.dart';

// Mocks manuels
class MockApiService extends ApiService {}

class MockStorageService extends StorageService {
  @override
  Future<void> init() async {}
  
  @override
  Future<void> saveCachedDepartures(String from, String to, List<Departure> deps) async {}
  
  @override
  Future<List<Departure>> getCachedDepartures(String from, String to) async => [];
}

class MockTimetableService extends TimetableService {
  MockTimetableService() : super(apiService: MockApiService(), storageService: MockStorageService());
  
  @override
  Future<void> init() async {}
  
  @override
  Future<List<Departure>> getTheoreticalDepartures({
    required String fromStationId,
    required String toStationId,
    required DateTime datetime,
    String? tripId,
  }) async => [];
}

class MockRealtimeService extends RealtimeService {
  MockRealtimeService() : super(
    apiService: MockApiService(), 
    timetableService: MockTimetableService(),
    storageService: MockStorageService()
  );

  @override
  Future<List<Departure>> getDeparturesWithRealtime({
    required String fromStationId,
    required String toStationId,
    required DateTime datetime,
    String? tripId,
  }) async {
    return [
      Departure(
        id: 'test-dep',
        scheduledTime: datetime.add(const Duration(minutes: 10)),
        platform: '1',
        status: DepartureStatus.onTime,
        delayMinutes: 0
      )
    ];
  }
}

class MockWidgetService extends WidgetService {
  @override
  Future<void> updateAllWidgets({
    required List<Trip> allTrips,
    required Map<String, List<Departure>> departuresGoByTrip,
    required Map<String, List<Departure>> departuresReturnByTrip,
  }) async {}
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  
  // Mock du channel pour HapticFeedback
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
    SystemChannels.platform,
    (MethodCall methodCall) async {
      return null;
    },
  );

  late TripProvider provider;
  late SettingsProvider settingsProvider;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    settingsProvider = SettingsProvider();
    
    provider = TripProvider(
      settingsProvider,
      apiService: MockApiService(),
      storageService: MockStorageService(),
      timetableService: MockTimetableService(),
      realtimeService: MockRealtimeService(),
      widgetService: MockWidgetService(),
    );
  });

  test('Initialisation correcte avec mocks', () async {
    // Attendre que le chargement asynchrone soit fini
    // Comme _loadTrips est appelé dans le constructeur mais est async, 
    // on doit attendre un peu ou utiliser un hack. 
    // TripProvider notifie quand c'est fini via isLoading = false
    
    // On attend que isLoading passe à false
    int retries = 0;
    while (provider.isLoading && retries < 10) {
      await Future.delayed(const Duration(milliseconds: 50));
      retries++;
    }

    expect(provider.isLoading, false);
    
    // Par défaut, s'il n'y a rien dans SharedPreferences, la liste est vide (plus de mocks)
    expect(provider.trips.isEmpty, true);
    expect(provider.activeTrip, isNull);
  });

  test('Ajout d\'un trajet', () async {
    // Attendre l'init
    while (provider.isLoading) await Future.delayed(const Duration(milliseconds: 10));

    final initialCount = provider.trips.length;
    
    final result = await provider.addTrip(
      stationA: const Station(id: 'sta-1', name: 'Gare A'),
      stationB: const Station(id: 'sta-2', name: 'Gare B'),
      morningDirection: MorningDirection.aToB
    );

    expect(result, null); // Pas d'erreur
    expect(provider.trips.length, initialCount + 1);
  });
}
