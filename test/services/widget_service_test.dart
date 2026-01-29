import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:surlequai/models/departure.dart';
import 'package:surlequai/models/station.dart';
import 'package:surlequai/models/trip.dart';
import 'package:surlequai/services/widget_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('WidgetService Tests', () {
    late WidgetService widgetService;
    final List<MethodCall> log = <MethodCall>[];

    setUp(() {
      widgetService = WidgetService();
      log.clear();
      
      // Mock du channel home_widget
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(const MethodChannel('home_widget'), (MethodCall methodCall) async {
        log.add(methodCall);
        return true; // Simule un succès pour toutes les méthodes (saveWidgetData, setAppGroupId, etc.)
      });
    });

    tearDown(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(const MethodChannel('home_widget'), null);
    });

    test('updateWidgetForTrip saves correct data for on-time train', () async {
      // Arrange
      final fixedNow = DateTime(2026, 1, 29, 10, 0); // 10h00
      
      final stationA = const Station(id: 'A', name: 'Gare A');
      final stationB = const Station(id: 'B', name: 'Gare B');
      final trip = Trip(
        id: 'trip1',
        stationA: stationA,
        stationB: stationB,
        morningDirection: MorningDirection.aToB,
      );

      final departure = Departure(
        id: 'dep1',
        scheduledTime: fixedNow.add(const Duration(minutes: 10)), // 10:10
        platform: 'Voie 1',
        status: DepartureStatus.onTime,
      );

      // Act
      await widgetService.updateWidgetForTrip(
        trip: trip,
        departuresGo: [departure],
        departuresReturn: [],
        morningEveningSplitHour: 12,
        serviceDayStartHour: 4,
        now: fixedNow, // Injection de dépendance
      );

      // Assert
      final colorCall = log.firstWhere((call) => 
        call.method == 'saveWidgetData' && 
        call.arguments['id'] == 'trip_trip1_direction1_status_color'
      );
      
      expect(colorCall.arguments['data'], 'onTime');
      
      final timeCall = log.firstWhere((call) => 
        call.method == 'saveWidgetData' && 
        call.arguments['id'] == 'trip_trip1_direction1_time'
      );
      expect(timeCall.arguments['data'], isNotNull);
    });

    test('updateWidgetForTrip saves correct color for delayed train', () async {
      // Arrange
      final fixedNow = DateTime(2026, 1, 29, 10, 0); // 10h00

      final trip = Trip(
        id: 'trip2',
        stationA: const Station(id: 'A', name: 'A'),
        stationB: const Station(id: 'B', name: 'B'),
        morningDirection: MorningDirection.aToB,
      );

      final departure = Departure(
        id: 'dep2',
        scheduledTime: fixedNow.add(const Duration(minutes: 10)), // 10:10
        platform: 'Voie 2',
        status: DepartureStatus.delayed,
        delayMinutes: 5,
      );

      // Act
      await widgetService.updateWidgetForTrip(
        trip: trip,
        departuresGo: [departure],
        departuresReturn: [],
        now: fixedNow, // Injection de dépendance
      );

      // Assert
      final colorCall = log.firstWhere((call) => 
        call.method == 'saveWidgetData' && 
        call.arguments['id'] == 'trip_trip2_direction1_status_color'
      );
      
      expect(colorCall.arguments['data'], 'delayed');
    });
  });
}