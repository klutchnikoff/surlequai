import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:surlequai/services/api_service.dart';
import 'package:surlequai/services/api_key_service.dart';

void main() {
  group('ApiService Tests', () {
    late ApiService apiService;

    // JSON de réponse factice pour les départs
    final mockDeparturesResponse = {
      'departures': [
        {
          'display_informations': {
            'direction': 'Paris',
            'trip_short_name': '12345',
            'network': 'TER'
          },
          'stop_date_time': {
            'base_departure_date_time': '20260128T100000',
            'departure_date_time': '20260128T100500', // 5 min de retard
            'data_freshness': 'realtime',
            'platform': 'A'
          }
        }
      ]
    };

    test('getRealtimeDepartures returns list on 200 OK', () async {
      // Arrange
      final client = MockClient((request) async {
        return http.Response(json.encode(mockDeparturesResponse), 200);
      });
      
      // On injecte le MockClient
      apiService = ApiService(client: client, apiKeyService: ApiKeyService());

      // Act
      final result = await apiService.getRealtimeDepartures(
        fromStationId: 'stop_area:DATA',
        toStationId: 'stop_area:DATA2',
        datetime: DateTime(2026, 1, 28, 10, 0),
      );

      // Assert
      expect(result.length, 1);
      expect(result.first.platform, 'A');
      expect(result.first.delayMinutes, 5); // 10:05 - 10:00
    });

    test('getRealtimeDepartures throws HttpException on 401 Unauthorized', () async {
      // Arrange
      final client = MockClient((request) async {
        return http.Response('Unauthorized', 401);
      });
      apiService = ApiService(client: client, apiKeyService: ApiKeyService());

      // Act & Assert
      expect(
        () async => await apiService.getRealtimeDepartures(
          fromStationId: 'stop_area:DATA',
          toStationId: 'stop_area:DATA2',
          datetime: DateTime.now(),
        ),
        throwsA(isA<HttpException>()),
      );
    });

    test('getRealtimeDepartures throws HttpException on 404 Not Found', () async {
      // Arrange
      final client = MockClient((request) async {
        return http.Response('Not Found', 404);
      });
      apiService = ApiService(client: client, apiKeyService: ApiKeyService());

      // Act & Assert
      expect(
        () async => await apiService.getRealtimeDepartures(
          fromStationId: 'stop_area:UNKNOWN',
          toStationId: 'stop_area:DATA2',
          datetime: DateTime.now(),
        ),
        throwsA(isA<HttpException>()),
      );
    });
  });
}
