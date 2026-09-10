import 'package:surlequai/models/transport_preferences.dart';
import 'package:surlequai/models/departure.dart';

/// Adapte les trajets Navitia aux seules liaisons ferroviaires directes.
/// Une réponse illisible est une erreur, jamais une preuve d'absence de train.
class JourneyMapper {
  static List<Departure> parse(
    Map<String, dynamic> response, {
    TransportPreferences transport = const TransportPreferences(),
    required String fromStationId,
    required String toStationId,
  }) {
    final journeys = response['journeys'];
    if (journeys is! List || response['error'] != null) {
      throw const FormatException('Réponse horaires invalide');
    }
    final departures = <String, Departure>{};
    for (final raw in journeys) {
      final journey = raw as Map<String, dynamic>;
      if (journey['nb_transfers'] is! int) {
        throw const FormatException('Nombre de correspondances absent');
      }
      final sections = (journey['sections'] as List)
          .cast<Map<String, dynamic>>();
      final transports = sections
          .where((s) => s['type'] == 'public_transport')
          .toList();
      if (journey['nb_transfers'] != 0 || transports.length != 1) continue;
      final section = transports.single;
      final info = section['display_informations'] as Map<String, dynamic>;
      final mode = _mode(info, section, transport);
      if (mode == null) continue;
      // Navitia inclut des raccordements de durée nulle gare → quai.
      // Ils sont acceptés, contrairement aux parcours via une autre gare.
      if (_station(section['from']) != fromStationId ||
          _station(section['to']) != toStationId) {
        continue;
      }
      if (sections.any(
        (s) => s != section && (s['type'] != 'crow_fly' || s['duration'] != 0),
      )) {
        continue;
      }

      final actual = _date(section['departure_date_time']);
      final scheduled = _date(
        section['base_departure_date_time'] ?? section['departure_date_time'],
      );
      final arrival = _date(section['arrival_date_time']);
      if (arrival.isBefore(actual)) {
        throw const FormatException('Durée négative');
      }
      final delay = actual.difference(scheduled).inMinutes;
      final cancelled =
          (journey['status'] as String? ?? '').toUpperCase() == 'NO_SERVICE' ||
          _cancelled(response, section, scheduled);
      final stops = section['stop_date_times'] as List? ?? const [];
      final first = stops.isEmpty ? null : stops.first as Map<String, dynamic>;
      // Le champ réellement observé est stop_point, pas departure_stop_point.
      final point = first?['stop_point'] as Map<String, dynamic>?;
      final platform = first?['platform'] ?? point?['platform'];
      final trip = info['trip_short_name'] ?? section['id'];
      if (trip is! String || trip.isEmpty) {
        throw const FormatException('Train sans identifiant');
      }
      final departure = Departure(
        id: '$trip-${scheduled.millisecondsSinceEpoch}',
        scheduledTime: scheduled,
        delayMinutes: delay,
        durationMinutes: arrival.difference(actual).inMinutes,
        platform: platform is String && platform.trim().isNotEmpty
            ? platform.trim()
            : '?',
        isCoach: mode == 'coach',
        isTgv: mode == 'tgv',
        status: cancelled
            ? DepartureStatus.cancelled
            : delay > 0
            ? DepartureStatus.delayed
            : DepartureStatus.onTime,
      );
      departures[departure.id] = departure;
    }
    return departures.values.toList()
      ..sort((a, b) => a.effectiveTime.compareTo(b.effectiveTime));
  }

  static String? _station(dynamic place) {
    if (place is! Map) throw const FormatException('Arrêt absent');
    if (place['embedded_type'] == 'stop_area') return place['id'] as String?;
    final id =
        place['stop_point']?['stop_area']?['id'] ?? place['stop_area']?['id'];
    if (id is! String) throw const FormatException('Gare non identifiée');
    return id;
  }

  static String? _mode(
    Map<String, dynamic> info,
    Map<String, dynamic> section,
    TransportPreferences transport,
  ) {
    final branding = '${info['network']} ${info['commercial_mode']}'
        .toUpperCase();
    if (['TRANSILIEN', 'EUROSTAR', 'THALYS'].any(branding.contains)) {
      return null;
    }
    if (branding.contains('OUIGO TRAIN CLASSIQUE')) return null;
    final tgv = branding.contains('TGV') || branding.contains('OUIGO');
    if (tgv && !transport.includeTgv) return null;
    final links = section['links'] as List? ?? const [];
    final modeIds = links
        .where((l) => l['type'] == 'physical_mode')
        .map((l) => l['id'])
        .toSet();
    final physical = (info['physical_mode'] as String? ?? '').toLowerCase();
    if (physical.isEmpty && modeIds.isEmpty) {
      throw const FormatException('Mode de transport absent');
    }
    final coach =
        modeIds.contains('physical_mode:Coach') ||
        physical == 'autocar' ||
        physical == 'coach';
    // Observé à Rennes le 10/09/2026 : Nantes, Laval et Le Mans ont des
    // circulations BreizhGo étiquetées « Train grande vitesse ». La marque
    // régionale explicite permet de conserver ces TER sans admettre les TGV.
    final commercial = (info['commercial_mode'] as String? ?? '')
        .trim()
        .toUpperCase();
    final regional =
        commercial == 'BREIZHGO' ||
        commercial == 'NOMAD' ||
        commercial == 'TER' ||
        commercial.startsWith('TER ');
    if (coach && !transport.includeCoach) return null;
    final train =
        tgv ||
        modeIds.contains('physical_mode:Train') ||
        physical == 'ter / intercités' ||
        (regional &&
            (modeIds.contains('physical_mode:LongDistanceTrain') ||
                physical == 'train grande vitesse'));
    if (!coach && !train) return null;
    // Une marque régionale seule ne prouve pas qu'il s'agit d'un car SNCF.
    // On exige SNCF comme transporteur ou un identifiant de circulation SNCF.
    final sncf =
        (info['company'] as String? ?? '').toUpperCase().contains('SNCF') ||
        links.any(
          (l) =>
              l['type'] == 'vehicle_journey' &&
              (l['id'] as String? ?? '').startsWith('vehicle_journey:SNCF:'),
        );
    if (coach && !sncf) return null;
    return coach
        ? 'coach'
        : tgv
        ? 'tgv'
        : 'train';
  }

  static bool _cancelled(
    Map<String, dynamic> response,
    Map<String, dynamic> section,
    DateTime date,
  ) {
    final info = section['display_informations'] as Map<String, dynamic>;
    final refs = [
      ...?section['links'] as List?,
      ...?info['links'] as List?,
    ].where((l) => l['type'] == 'disruption').map((l) => l['id']).toSet();
    for (final disruption in response['disruptions'] as List? ?? const []) {
      if (!refs.contains(disruption['id']) ||
          disruption['severity']?['effect'] != 'NO_SERVICE') {
        continue;
      }
      final periods = disruption['application_periods'] as List? ?? const [];
      if (periods.any(
        (p) =>
            !date.isBefore(_date(p['begin'])) && date.isBefore(_date(p['end'])),
      )) {
        return true;
      }
    }
    return false;
  }

  static DateTime _date(dynamic value) {
    if (value is! String || !RegExp(r'^\d{8}T\d{6}$').hasMatch(value)) {
      throw const FormatException('Date Navitia invalide');
    }
    final date = DateTime(
      int.parse(value.substring(0, 4)),
      int.parse(value.substring(4, 6)),
      int.parse(value.substring(6, 8)),
      int.parse(value.substring(9, 11)),
      int.parse(value.substring(11, 13)),
      int.parse(value.substring(13, 15)),
    );
    final roundTrip =
        '${date.year.toString().padLeft(4, '0')}${date.month.toString().padLeft(2, '0')}${date.day.toString().padLeft(2, '0')}T${date.hour.toString().padLeft(2, '0')}${date.minute.toString().padLeft(2, '0')}${date.second.toString().padLeft(2, '0')}';
    if (roundTrip != value) {
      throw const FormatException('Date Navitia hors limites');
    }
    return date;
  }
}
