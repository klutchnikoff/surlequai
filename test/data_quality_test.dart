import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:surlequai/models/data_failure.dart';
import 'package:surlequai/models/departure.dart';
import 'package:surlequai/models/direction_card_view_model.dart';
import 'package:surlequai/services/api_service.dart';
import 'package:surlequai/services/realtime_service.dart';
import 'package:surlequai/services/storage_service.dart';

void main() {
  final now = DateTime(2026, 9, 10, 8);
  late Directory temp;
  late StorageService storage;
  setUp(() async {
    temp = await Directory.systemTemp.createTemp('surlequai-quality-');
    storage = StorageService(cacheDirectory: temp, now: () => now);
    await storage.saveCachedDepartures('A', 'B', [
      Departure(
        id: 'cancelled',
        scheduledTime: now.add(const Duration(minutes: 10)),
        platform: '2',
        status: DepartureStatus.cancelled,
      ),
    ], fetchedAt: now.subtract(const Duration(minutes: 2)));
  });
  tearDown(() => temp.delete(recursive: true));

  for (final sample in [
    (200, '{}', DataFailure.invalidData),
    (200, '{"journeys":[{"nb_transfers":0}]}', DataFailure.invalidData),
    (401, 'Unauthorized', DataFailure.authentication),
    (429, 'Quota', DataFailure.rateLimited),
    (503, 'Unavailable', DataFailure.server),
  ]) {
    test(
      'HTTP ${sample.$1} ${sample.$2} retains dated cache and an actionable cause',
      () async {
        final api = ApiService(
          client: MockClient((_) async => http.Response(sample.$2, sample.$1)),
        );
        addTearDown(api.dispose);
        final result =
            await RealtimeService(
              apiService: api,
              storageService: storage,
              now: () => now,
            ).getDeparturesWithRealtime(
              fromStationId: 'A',
              toStationId: 'B',
              datetime: now,
            );
        expect(result.failure, sample.$3);
        expect(result.fetchedAt, now.subtract(const Duration(minutes: 2)));
        expect(
          result.departures.single.lastKnownStatus,
          DepartureStatus.cancelled,
        );
        expect(result.departures.single.platform, '?');
        final vm = DirectionCardViewModel.fromDepartures(
          title: 'A → B',
          departures: result.departures,
          fromNetwork: result.fromNetwork,
          failure: result.failure,
          serviceDayStartTime: 4,
          now: now,
        ) as DirectionCardWithDepartures;
        expect(vm.statusText, contains('dernière info : supprimé'));
        expect(
          (await storage.readCachedDepartures('A', 'B')).departures,
          hasLength(1),
        );
      },
    );
  }
  test(
    'no_solution is a valid empty result, other 404s remain failures',
    () async {
      final api = ApiService(
        client: MockClient(
          (_) async => http.Response(
            jsonEncode({
              'error': {'id': 'no_solution'},
            }),
            404,
          ),
        ),
      );
      addTearDown(api.dispose);
      expect(
        await api.getDirectJourneys(
          fromStationId: 'A',
          toStationId: 'B',
          datetime: now,
        ),
        isEmpty,
      );
    },
  );
  test(
    'Retry-After blocks repeated requests and allows recovery at the deadline',
    () async {
      var clock = now;
      var calls = 0;
      final api = ApiService(
        now: () => clock,
        client: MockClient((_) async {
          calls++;
          return calls == 1
              ? http.Response('quota', 429, headers: {'retry-after': '120'})
              : http.Response('{"journeys":[]}', 200);
        }),
      );
      addTearDown(api.dispose);
      Future<List<Departure>> fetch() => api.getDirectJourneys(
        fromStationId: 'A',
        toStationId: 'B',
        datetime: clock,
      );
      await expectLater(fetch(), throwsA(isA<ApiException>()));
      await expectLater(fetch(), throwsA(isA<ApiException>()));
      expect(calls, 1);
      clock = now.add(const Duration(seconds: 120));
      expect(await fetch(), isEmpty);
      expect(calls, 2);
    },
  );
  test('missing cache does not announce absence of trains', () {
    final vm = DirectionCardViewModel.fromDepartures(
      title: 'A → B',
      departures: [],
      fromNetwork: false,
      serviceDayStartTime: 4,
      now: now,
    ) as DirectionCardNoDepartures;
    expect(vm.noTrainStatusDisplay, contains('indisponibles'));
  });
  test('coach and following disruptions are visible on the shared card', () {
    final vm = DirectionCardViewModel.fromDepartures(
      title: 'A → B',
      departures: [
        Departure(
          id: 'coach',
          scheduledTime: now.add(const Duration(minutes: 5)),
          platform: '?',
          isCoach: true,
          status: DepartureStatus.onTime,
        ),
        Departure(
          id: 'cancelled',
          scheduledTime: now.add(const Duration(minutes: 10)),
          platform: '?',
          status: DepartureStatus.cancelled,
        ),
      ],
      serviceDayStartTime: 4,
      now: now,
    ) as DirectionCardWithDepartures;
    expect(vm.statusText, 'Car · À l\'heure');
    expect(vm.subsequentDepartures, contains('supprimé'));
  });
}
