import 'dart:async';

import 'package:surlequai/models/transport_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:surlequai/models/departure.dart';
import 'package:surlequai/models/station.dart';
import 'package:surlequai/screens/station_picker_screen.dart';
import 'package:surlequai/services/api_service.dart';
import 'package:surlequai/services/settings_provider.dart';
import 'package:surlequai/utils/constants.dart';
import 'package:surlequai/widgets/schedules_modal.dart';

class SlowApi extends ApiService {
  final search = Completer<List<Station>>();
  final schedules = Completer<List<Departure>>();
  @override
  Future<List<Station>> searchStations(String query, {int limit = 10}) =>
      search.future;
  @override
  Future<List<Departure>> getTheoreticalSchedule({
    required String fromStationId,
    required String toStationId,
    required DateTime datetime,
    int count = AppConstants.maxTrainsPerDay,
    TransportPreferences transport = const TransportPreferences(),
    int serviceDayStartHour = 4,
  }) => schedules.future;
}

void main() {
  testWidgets('closing a station search before the response is safe', (
    tester,
  ) async {
    final api = SlowApi();
    addTearDown(api.dispose);
    await tester.pumpWidget(
      Provider<ApiService>.value(
        value: api,
        child: const MaterialApp(home: StationPickerScreen(title: 'Gare')),
      ),
    );
    await tester.enterText(find.byType(TextField), 'Paris');
    await tester.pump(const Duration(milliseconds: 501));
    await tester.pumpWidget(const SizedBox());
    api.search.complete([]);
    await tester.pump();
    expect(tester.takeException(), isNull);
  });
  testWidgets('clearing a pending search clears the text and spinner', (
    tester,
  ) async {
    final api = SlowApi();
    addTearDown(api.dispose);
    await tester.pumpWidget(
      Provider<ApiService>.value(
        value: api,
        child: const MaterialApp(home: StationPickerScreen(title: 'Gare')),
      ),
    );
    await tester.enterText(find.byType(TextField), 'Paris');
    await tester.pump(const Duration(milliseconds: 501));
    await tester.tap(find.byIcon(Icons.clear));
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(
      tester.widget<TextField>(find.byType(TextField)).controller!.text,
      isEmpty,
    );
    api.search.complete([]);
    await tester.pump();
  });
  testWidgets('closing the schedules sheet before loading finishes is safe', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    final api = SlowApi();
    final settings = SettingsProvider();
    addTearDown(api.dispose);
    addTearDown(settings.dispose);
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
    await tester.pumpWidget(const SizedBox());
    api.schedules.complete([]);
    await tester.pump();
    expect(tester.takeException(), isNull);
  });
}
