import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:surlequai/models/departure.dart';
import 'package:surlequai/services/journey_mapper.dart';

void main() {
  late Map<String, dynamic> data;
  setUp(
    () => data = jsonDecode(
      File('test/fixtures/bruz_rennes_20260910.json').readAsStringSync(),
    ),
  );
  Map<String, dynamic> train() => (data['journeys'][0]['sections'] as List)
      .firstWhere((s) => s['type'] == 'public_transport');
  List<Departure> parse() => JourneyMapper.parse(
    data,
    fromStationId: 'stop_area:SNCF:87471037',
    toStationId: 'stop_area:SNCF:87471003',
  );

  test('observed Bruz response keeps normal trains on time without inventing a platform', () {
    final results = parse();
    expect(results, hasLength(2));
    expect(results.first.scheduledTime, DateTime(2026, 9, 10, 8, 9));
    expect(results.first.status, DepartureStatus.onTime);
    expect(results.first.platform, '?');
    expect(results.first.isCoach, false);
  });
  test('SNCF coach between the same stations is identified as a coach', () {
    train()['display_informations']['physical_mode'] = 'Autocar';
    train()['links'] = [
      {'type': 'physical_mode', 'id': 'physical_mode:Coach'},
    ];
    expect(parse().first.isCoach, true);
  });
  test('regional coach without SNCF provenance is excluded', () {
    train()['display_informations']['physical_mode'] = 'Autocar';
    train()['display_informations']['company'] = 'Transport métropolitain';
    train()['links'] = [
      {'type': 'physical_mode', 'id': 'physical_mode:Coach'},
    ];
    expect(parse(), hasLength(1));
  });
  test('TGV with network SNCF is excluded through commercial mode', () {
    train()['display_informations']['network'] = 'SNCF';
    train()['display_informations']['commercial_mode'] = 'TGV INOUI';
    expect(parse(), hasLength(1));
  });
  test('urban bus is excluded', () {
    train()['display_informations']['physical_mode'] = 'Bus';
    train()['links'] = [
      {'type': 'physical_mode', 'id': 'physical_mode:Bus'},
    ];
    expect(parse(), hasLength(1));
  });
  test('a train reached by walking to another station is excluded', () {
    train()['from']['stop_point']['stop_area']['id'] = 'stop_area:OTHER';
    expect(parse(), hasLength(1));
  });
  test('walking itineraries and multiple transport sections are excluded', () {
    data['journeys'][0]['sections'].add({
      'type': 'street_network',
      'duration': 60,
    });
    expect(parse(), hasLength(1));
    data['journeys'][0]['sections'].add(Map<String, dynamic>.from(train()));
    expect(parse(), hasLength(1));
  });
  test(
    'missing journeys and corrupt dates cannot masquerade as an empty response',
    () {
      expect(
        () => JourneyMapper.parse({}, fromStationId: 'A', toStationId: 'B'),
        throwsFormatException,
      );
      train()['departure_date_time'] = '20260230T080900';
      expect(parse, throwsFormatException);
    },
  );
  test('known empty response is valid', () {
    data['journeys'] = [];
    expect(parse(), isEmpty);
  });
  test(
    'explicit delay takes precedence over a contradictory freshness marker',
    () {
      train()['departure_date_time'] = '20260910T081400';
      final result = parse().first;
      expect(result.status, DepartureStatus.delayed);
      expect(result.delayMinutes, 5);
      expect(result.effectiveTime, DateTime(2026, 9, 10, 8, 14));
    },
  );
  test(
    'only linked cancellation in its application period affects the train',
    () {
      data['disruptions'] = [
        {
          'id': 'cancelled',
          'severity': {'effect': 'NO_SERVICE'},
          'application_periods': [
            {'begin': '20260910T080000', 'end': '20260910T090000'},
          ],
        },
      ];
      expect(parse().first.status, DepartureStatus.onTime);
      train()['display_informations']['links'].add({
        'type': 'disruption',
        'id': 'cancelled',
      });
      expect(parse().first.status, DepartureStatus.cancelled);
      data['disruptions'][0]['application_periods'][0]['end'] =
          '20260910T080500';
      expect(parse().first.status, DepartureStatus.onTime);
    },
  );
  test('platform uses stop_point and duplicates are removed', () {
    train()['stop_date_times'][0]['stop_point']['platform'] = ' 2 ';
    data['journeys'].add(data['journeys'][0]);
    final result = parse();
    expect(result, hasLength(2));
    expect(result.first.platform, '2');
  });
}
