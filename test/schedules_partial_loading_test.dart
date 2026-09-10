import 'dart:async';

import 'package:surlequai/models/transport_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:surlequai/models/departure.dart';
import 'package:surlequai/services/api_service.dart';
import 'package:surlequai/services/settings_provider.dart';
import 'package:surlequai/utils/constants.dart';
import 'package:surlequai/widgets/schedules_modal.dart';

class DailyApi extends ApiService {
  final requests = <Completer<List<Departure>>>[];
  final dates = <DateTime>[];

  @override
  Future<List<Departure>> getTheoreticalSchedule({
    required String fromStationId,
    required String toStationId,
    required DateTime datetime,
    int count = AppConstants.maxTrainsPerDay,
    TransportPreferences transport = const TransportPreferences(),
    int serviceDayStartHour = 4,
  }) {
    dates.add(datetime);
    final request = Completer<List<Departure>>();
    requests.add(request);
    return request.future;
  }

  void succeed(int day) => requests[day].complete([
    Departure(
      id: '$day',
      scheduledTime: dates[day].add(const Duration(hours: 2)),
      platform: '?',
      status: DepartureStatus.offline,
    ),
  ]);
}

void main() {
  for (final failedDay in [0, 1]) {
    testWidgets('available day remains visible when day $failedDay fails', (
      tester,
    ) async {
      SharedPreferences.setMockInitialValues({});
      final settings = SettingsProvider();
      final api = DailyApi();
      addTearDown(settings.dispose);
      addTearDown(api.dispose);
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            Provider<ApiService>.value(value: api),
            ChangeNotifierProvider<SettingsProvider>.value(value: settings),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: SchedulesModal(
                title: 'A → B',
                fromStationId: 'A',
                toStationId: 'B',
              ),
            ),
          ),
        ),
      );
      expect(api.requests, hasLength(2));
      api.succeed(1 - failedDay);
      await tester.pumpAndSettle();
      expect(find.byType(ListTile), findsOneWidget);
      expect(find.text('Chargement des autres horaires...'), findsOneWidget);
      api.requests[failedDay].completeError(Exception('offline'));
      await tester.pumpAndSettle();
      expect(find.byType(ListTile), findsOneWidget);
      expect(
        find.text(
          failedDay == 0
              ? 'Horaires d’aujourd’hui indisponibles.'
              : 'Horaires de demain indisponibles.',
        ),
        findsOneWidget,
      );
      expect(find.text('Chargement des autres horaires...'), findsNothing);
      expect(tester.takeException(), isNull);
    });
  }
}
