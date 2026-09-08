import 'dart:convert';

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
          .setMockMethodCallHandler(const MethodChannel('home_widget'), (
            MethodCall methodCall,
          ) async {
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

      const stationA = Station(id: 'A', name: 'Gare A');
      const stationB = Station(id: 'B', name: 'Gare B');
      const trip = Trip(
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
        now: fixedNow,
        lastUpdate: fixedNow,
      );

      // Assert
      final colorCall = log.firstWhere(
        (call) =>
            call.method == 'saveWidgetData' &&
            call.arguments['id'] == 'trip_trip1_direction1_status_color',
      );

      expect(colorCall.arguments['data'], 'onTime');

      final timeCall = log.firstWhere(
        (call) =>
            call.method == 'saveWidgetData' &&
            call.arguments['id'] == 'trip_trip1_direction1_time',
      );
      expect(timeCall.arguments['data'], isNotNull);
    });

    test('updateWidgetForTrip saves correct color for delayed train', () async {
      // Arrange
      final fixedNow = DateTime(2026, 1, 29, 10, 0); // 10h00

      const trip = Trip(
        id: 'trip2',
        stationA: Station(id: 'A', name: 'A'),
        stationB: Station(id: 'B', name: 'B'),
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
        now: fixedNow,
        lastUpdate: fixedNow,
      );

      // Assert
      final colorCall = log.firstWhere(
        (call) =>
            call.method == 'saveWidgetData' &&
            call.arguments['id'] == 'trip_trip2_direction1_status_color',
      );

      expect(colorCall.arguments['data'], 'delayed');
    });
    test(
      'evening widget keeps titles paired with the correct trains',
      () async {
        final now = DateTime(2026, 9, 8, 18);
        const trip = Trip(
          id: 'evening',
          stationA: Station(id: 'A', name: 'A'),
          stationB: Station(id: 'B', name: 'B'),
          morningDirection: MorningDirection.aToB,
        );
        await widgetService.updateWidgetForTrip(
          trip: trip,
          now: now,
          lastUpdate: now,
          departuresGo: [
            Departure(
              id: 'go',
              platform: '?',
              scheduledTime: now.add(const Duration(minutes: 10)),
            ),
          ],
          departuresReturn: [
            Departure(
              id: 'back',
              platform: '?',
              scheduledTime: now.add(const Duration(minutes: 20)),
            ),
          ],
        );
        Object? saved(String suffix) => log
            .firstWhere(
              (call) =>
                  call.method == 'saveWidgetData' &&
                  call.arguments['id'] == 'trip_evening_$suffix',
            )
            .arguments['data'];
        expect(saved('direction1_title'), '→ A');
        expect(saved('direction1_time'), '18:20');
        expect(saved('direction2_title'), '→ B');
        expect(saved('direction2_time'), '18:10');
        expect(
          saved('next_departure'),
          now
              .add(const Duration(minutes: 10))
              .millisecondsSinceEpoch
              .toString(),
        );
      },
    );

    test(
      'iOS timeline expires live status and advances past departures',
      () async {
        final now = DateTime(2026, 9, 8, 10);
        widgetService = WidgetService(now: () => now);
        const trip = Trip(
          id: 'timeline',
          stationA: Station(id: 'A', name: 'A'),
          stationB: Station(id: 'B', name: 'B'),
          morningDirection: MorningDirection.aToB,
        );
        await widgetService.updateAllWidgets(
          allTrips: [trip],
          departuresGoByTrip: {
            'timeline': [
              Departure(
                id: 'go',
                scheduledTime: now.add(const Duration(minutes: 10)),
                status: DepartureStatus.delayed,
                delayMinutes: 3,
                platform: '2',
              ),
            ],
          },
          departuresReturnByTrip: const {},
          lastUpdatesByTrip: {'timeline': now},
        );
        final encoded =
            log
                    .firstWhere(
                      (call) =>
                          call.method == 'saveWidgetData' &&
                          call.arguments['id'] == 'widget_snapshot',
                    )
                    .arguments['data']
                as String;
        final frames = jsonDecode(encoded)['trips'][0]['frames'] as List;
        Map frameAt(int minutes) => frames.firstWhere(
          (frame) =>
              frame['date'] ==
              now.add(Duration(minutes: minutes)).millisecondsSinceEpoch,
        ) as Map;
        expect(frameAt(0)['direction1']['color'], 'delayed');
        expect(frameAt(5)['direction1']['color'], 'offline');
        expect(frameAt(5)['direction1']['platform'], '');
        expect(frameAt(10)['direction1']['color'], 'secondary');
        expect(log.last.method, 'updateWidget');
      },
    );
  });
}
