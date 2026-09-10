import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:surlequai/models/departure.dart';
import 'package:surlequai/models/direction_card_view_model.dart';
import 'package:surlequai/services/api_service.dart';

Map<String, dynamic> journey({
  String status = '',
  String freshness = 'realtime',
}) => {
  'nb_transfers': 0,
  'status': status,
  'sections': [
    {
      'type': 'public_transport',
      'id': 'train123',
      'display_informations': {
        'network': 'TER',
        'trip_short_name': '123',
        'physical_mode': 'TER / Intercités',
      },
      'from': {'id': 'A', 'embedded_type': 'stop_area'},
      'to': {'id': 'B', 'embedded_type': 'stop_area'},
      'base_departure_date_time': '20260908T100000',
      'departure_date_time': freshness == 'base_schedule'
          ? '20260908T100000'
          : '20260908T100500',
      'arrival_date_time': '20260908T103500',
      'data_freshness': freshness,
    },
  ],
};

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() => SharedPreferences.setMockInitialValues({}));
  Future<List<Departure>> fetch({
    String status = '',
    String freshness = 'realtime',
  }) async {
    final api = ApiService(
      client: MockClient((request) async {
        expect(request.url.path, '/coverage/sncf/journeys');
        expect(request.url.queryParameters['from'], 'A');
        expect(request.url.queryParameters['to'], 'B');
        return http.Response(
          jsonEncode({
            'journeys': [journey(status: status, freshness: freshness)],
          }),
          200,
        );
      }),
    );
    addTearDown(api.dispose);
    return api.getDirectJourneys(
      fromStationId: 'A',
      toStationId: 'B',
      datetime: DateTime(2026, 9, 8, 9),
    );
  }

  test('journey API to card counts a five-minute delay exactly once', () async {
    final departures = await fetch();
    expect(departures.single.scheduledTime, DateTime(2026, 9, 8, 10));
    expect(departures.single.effectiveTime, DateTime(2026, 9, 8, 10, 5));
    final vm = DirectionCardViewModel.fromDepartures(
      title: 'A → B',
      departures: departures,
      serviceDayStartTime: 4,
      now: DateTime(2026, 9, 8, 10, 2),
    ) as DirectionCardWithDepartures;
    expect(vm.time, '10:00');
    expect(vm.statusText, '+5 min');
    expect(
      DirectionCardViewModel.fromDepartures(
        title: 'A → B',
        departures: departures,
        serviceDayStartTime: 4,
        now: DateTime(2026, 9, 8, 10, 6),
      ),
      isA<DirectionCardNoDepartures>(),
    );
  });
  test('NO_SERVICE is mapped to a cancellation', () async {
    expect(
      (await fetch(status: 'NO_SERVICE')).single.status,
      DepartureStatus.cancelled,
    );
  });
  test(
    'unchanged base schedules are announced on time, not as offline',
    () async {
      // Hors connexion reste réservé au cache local : une réponse théorique
      // obtenue en ligne ne doit pas emprunter cette convention d'affichage.
      expect(
        (await fetch(freshness: 'base_schedule')).single.status,
        DepartureStatus.onTime,
      );
    },
  );
  test(
    'custom service start participates in the daily cache key and query',
    () async {
      final times = <String>[];
      final api = ApiService(
        client: MockClient((request) async {
          times.add(request.url.queryParameters['datetime']!);
          return http.Response('{"journeys":[]}', 200);
        }),
      );
      addTearDown(api.dispose);
      final now = DateTime.now();
      final date = DateTime(now.year, now.month, now.day, 10);
      for (final hour in [4, 6, 6]) {
        await api.getTheoreticalSchedule(
          fromStationId: 'A',
          toStationId: 'B',
          datetime: date,
          serviceDayStartHour: hour,
        );
      }
      expect(times.length, 2);
      expect(times.first.endsWith('T040000'), true);
      expect(times.last.endsWith('T060000'), true);
    },
  );
}
