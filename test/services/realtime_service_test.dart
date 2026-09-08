import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:surlequai/models/departure.dart';
import 'package:surlequai/services/api_service.dart';
import 'package:surlequai/services/storage_service.dart';
import 'package:surlequai/services/realtime_service.dart';

void main() {
  late Directory temp;
  late StorageService storage;
  final now = DateTime(2026, 9, 8, 10);
  final old = now.subtract(const Duration(hours: 1));
  setUp(() async {
    temp = await Directory.systemTemp.createTemp('surlequai-cache-');
    storage = StorageService(cacheDirectory: temp, now: () => now);
    await storage.saveCachedDepartures('A', 'B', [
      Departure(
        id: 'cached',
        scheduledTime: now.add(const Duration(minutes: 10)),
        platform: '2',
        status: DepartureStatus.delayed,
        delayMinutes: 15,
      ),
    ], fetchedAt: old);
  });
  tearDown(() => temp.delete(recursive: true));

  test(
    'network failure returns dated cache without stale delay or platform',
    () async {
      final api = ApiService(
        client: MockClient((_) async => throw const SocketException('offline')),
      );
      addTearDown(api.dispose);
      final service = RealtimeService(
        apiService: api,
        storageService: storage,
        now: () => now,
      );
      final result = await service.getDeparturesWithRealtime(
        fromStationId: 'A',
        toStationId: 'B',
        datetime: now,
      );
      expect(result.fromNetwork, false);
      expect(result.fetchedAt, old);
      expect(result.departures.single.status, DepartureStatus.offline);
      expect(result.departures.single.delayMinutes, 0);
      expect(result.departures.single.platform, '?');
    },
  );
  test('successful empty response clears old departures', () async {
    final api = ApiService(
      client: MockClient(
        (_) async => http.Response(jsonEncode({'journeys': []}), 200),
      ),
    );
    addTearDown(api.dispose);
    final service = RealtimeService(
      apiService: api,
      storageService: storage,
      now: () => now,
    );
    final result = await service.getDeparturesWithRealtime(
      fromStationId: 'A',
      toStationId: 'B',
      datetime: now,
    );
    expect(result.fromNetwork, true);
    expect(result.departures, isEmpty);
    expect((await storage.readCachedDepartures('A', 'B')).departures, isEmpty);
  });
  test('cache older than 48 hours is ignored', () async {
    final stale = StorageService(
      cacheDirectory: temp,
      now: () => now.add(const Duration(days: 3)),
    );
    expect((await stale.readCachedDepartures('A', 'B')).fetchedAt, isNull);
  });
  test('clearing cache preserves unrelated files', () async {
    final unrelated = File('${temp.path}/unrelated.txt');
    await unrelated.writeAsString('keep');
    await storage.clearCache();
    expect((await storage.readCachedDepartures('A', 'B')).departures, isEmpty);
    expect(await unrelated.exists(), true);
  });
}
