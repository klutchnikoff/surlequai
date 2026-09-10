import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:surlequai/models/departure.dart';
import 'package:surlequai/models/transport_preferences.dart';
import 'package:surlequai/services/api_service.dart';
import 'package:surlequai/services/settings_provider.dart';
import 'package:surlequai/services/storage_service.dart';

import 'direct_journeys_test.dart' show journey;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() => SharedPreferences.setMockInitialValues({}));

  Map<String, dynamic> modeJourney(String brand, String physical) {
    final j = journey();
    final section = j['sections'][0];
    section['display_informations'] = {
      'network': brand,
      'commercial_mode': brand,
      'physical_mode': physical,
      'company': 'SNCF Voyageurs',
      'trip_short_name': brand,
    };
    return j;
  }

  test('default preferences survive restart and independent changes', () async {
    final settings = SettingsProvider();
    await settings.ready;
    expect(settings.transport.includeTgv, false);
    expect(settings.transport.includeCoach, true);
    await settings.setTransport(includeTgv: true);
    await settings.setTransport(includeCoach: false);
    final reloaded = SettingsProvider();
    await reloaded.ready;
    expect(reloaded.transport.includeTgv, true);
    expect(reloaded.transport.includeCoach, false);
    settings.dispose();
    reloaded.dispose();
  });

  for (final tgv in [false, true]) {
    for (final coach in [false, true]) {
      test('request and response respect TGV=$tgv coach=$coach', () async {
        final api = ApiService(
          client: MockClient((request) async {
            final excluded =
                request.url.queryParametersAll['forbidden_uris[]']!;
            expect(excluded.contains('commercial_mode:OUI'), !tgv);
            expect(excluded.contains('commercial_mode:TGVOUIGO'), !tgv);
            expect(excluded.contains('physical_mode:Coach'), !coach);
            expect(excluded.contains('physical_mode:LongDistanceTrain'), false);
            expect(request.url.queryParameters['max_nb_transfers'], '0');
            // Intentionally return excluded modes to check defensive mapping.
            return http.Response(
              jsonEncode({
                'journeys': [
                  modeJourney('TER', 'TER / Intercités'),
                  modeJourney('BreizhGo', 'Train grande vitesse'),
                  modeJourney('TGV INOUI', 'Train grande vitesse'),
                  modeJourney('OUIGO', 'Train grande vitesse'),
                  modeJourney('SNCF', 'Autocar'),
                  modeJourney('OUIGO Train Classique', 'Train grande vitesse'),
                ],
              }),
              200,
            );
          }),
        );
        addTearDown(api.dispose);
        final result = await api.getDirectJourneys(
          fromStationId: 'A',
          toStationId: 'B',
          datetime: DateTime(2026, 9, 8),
          transport: TransportPreferences(includeTgv: tgv, includeCoach: coach),
        );
        expect(result.length, 2 + (tgv ? 2 : 0) + (coach ? 1 : 0));
        expect(result.where((d) => d.isTgv).length, tgv ? 2 : 0);
        expect(result.where((d) => d.isCoach).length, coach ? 1 : 0);
        for (final d in result) {
          final restored = Departure.fromJson(d.toJson()).asOffline();
          expect(restored.transportPrefix, d.transportPrefix);
        }
      });
    }
  }

  test('offline cache never mixes transport preferences', () async {
    final dir = await Directory.systemTemp.createTemp('transport-cache');
    addTearDown(() => dir.delete(recursive: true));
    final storage = StorageService(cacheDirectory: dir);
    const enabled = TransportPreferences(includeTgv: true);
    await storage.saveCachedDepartures('A', 'B', [
      Departure(
        id: 'tgv',
        scheduledTime: DateTime.now(),
        platform: '?',
        isTgv: true,
      ),
    ], transport: enabled);
    expect((await storage.readCachedDepartures('A', 'B')).departures, isEmpty);
    expect(
      (await storage.readCachedDepartures(
        'A',
        'B',
        transport: enabled,
      )).departures.single.isTgv,
      true,
    );
    await storage.removeDirection('A', 'B');
    expect(
      (await storage.readCachedDepartures(
        'A',
        'B',
        transport: enabled,
      )).departures,
      isEmpty,
    );
  });

  test('theoretical cache separates options and transmits them', () async {
    var calls = 0;
    final api = ApiService(
      client: MockClient((request) async {
        calls++;
        final includeTgv = !request.url.queryParametersAll['forbidden_uris[]']!
            .contains('commercial_mode:OUI');
        return http.Response(
          jsonEncode({
            'journeys': [
              modeJourney(
                includeTgv ? 'TGV INOUI' : 'TER',
                includeTgv ? 'Train grande vitesse' : 'TER / Intercités',
              ),
            ],
          }),
          200,
        );
      }),
    );
    addTearDown(api.dispose);
    Future<List<Departure>> fetch(bool tgv) => api.getTheoreticalSchedule(
      fromStationId: 'A',
      toStationId: 'B',
      datetime: DateTime.now(),
      transport: TransportPreferences(includeTgv: tgv),
    );
    expect((await fetch(false)).single.isTgv, false);
    expect((await fetch(true)).single.isTgv, true);
    expect((await fetch(false)).single.isTgv, false);
    expect(calls, 2);
  });
}
