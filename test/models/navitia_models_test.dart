import 'package:flutter_test/flutter_test.dart';
import 'package:surlequai/models/navitia/navitia_models.dart';

void main() {
  group('Navitia Models Parsing Tests', () {
    
    test('NavitiaResponse should parse empty JSON without crashing', () {
      // Teste que les champs optionnels (List?) sont bien nullables
      final json = <String, dynamic>{};
      final response = NavitiaResponse.fromJson(json);
      
      expect(response.departures, isNull);
      expect(response.journeys, isNull);
      expect(response.places, isNull);
    });

    test('NavitiaDeparture should parse valid departure with nested objects', () {
      final json = {
        'stop_date_time': {
          'departure_date_time': '20260128T100000',
          'base_departure_date_time': '20260128T100000',
          'data_freshness': 'realtime',
          'platform': 'A'
        },
        'display_informations': {
          'network': 'TER',
          'direction': 'Paris',
          'trip_short_name': '12345'
        },
        'route': {
          'id': 'route:1',
          'name': 'Ligne 1'
        }
      };

      final departure = NavitiaDeparture.fromJson(json);
      
      expect(departure.stopDateTime.platform, 'A');
      expect(departure.stopDateTime.dataFreshness, 'realtime');
      expect(departure.displayInformation?.network, 'TER');
      expect(departure.displayInformation?.tripShortName, '12345');
      expect(departure.route?.name, 'Ligne 1');
    });

    test('NavitiaDeparture should throw if required "stop_date_time" is missing', () {
      final json = {
        'display_informations': {}
        // stop_date_time est manquant mais marqué 'required' dans le modèle
      };

      // json_serializable avec null-safety lève une erreur (TypeError ou CheckedFromJsonException)
      expect(() => NavitiaDeparture.fromJson(json), throwsA(anything));
    });

    test('NavitiaJourney should parse sections correctly', () {
      final json = {
        'nb_transfers': 0,
        'sections': [
          {
            'type': 'public_transport',
            'id': 'train:123',
            'departure_date_time': '20260128T100000',
            'display_informations': {
               'network': 'TGV'
            }
          }
        ]
      };

      final journey = NavitiaJourney.fromJson(json);
      expect(journey.nbTransfers, 0);
      expect(journey.sections, hasLength(1));
      expect(journey.sections!.first.type, 'public_transport');
      expect(journey.sections!.first.displayInformation?.network, 'TGV');
    });

    test('NavitiaPlace should parse stop_area correctly', () {
      final json = {
        'id': 'place:1',
        'name': 'Gare de Lyon',
        'embedded_type': 'stop_area',
        'stop_area': {
          'id': 'stop_area:GL',
          'name': 'Paris Gare de Lyon'
        }
      };

      final place = NavitiaPlace.fromJson(json);
      expect(place.embeddedType, 'stop_area');
      expect(place.stopArea?.id, 'stop_area:GL');
      expect(place.stopArea?.name, 'Paris Gare de Lyon');
    });
  });
}
