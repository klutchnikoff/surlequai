import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:surlequai/models/departure.dart';
import 'package:surlequai/models/departures_result.dart';
import 'package:surlequai/models/direction_card_view_model.dart';
import 'package:surlequai/models/station.dart';
import 'package:surlequai/models/trip.dart';
import 'package:surlequai/services/api_service.dart';
import 'package:surlequai/services/realtime_service.dart';
import 'package:surlequai/services/settings_provider.dart';
import 'package:surlequai/services/storage_service.dart';
import 'package:surlequai/services/trip_provider.dart';
import 'package:surlequai/services/widget_service.dart';

class ControlledRealtime extends RealtimeService {
  final Map<String, Completer<DeparturesResult>> pending = {};
  final Map<String, DeparturesResult> cached = {};
  int calls = 0;
  ControlledRealtime(ApiService api, StorageService storage)
    : super(apiService: api, storageService: storage);
  @override
  Future<DeparturesResult> getCachedDepartures({
    required String fromStationId,
    required String toStationId,
  }) async => cached[fromStationId] ?? DeparturesResult();
  @override
  Future<DeparturesResult> getDeparturesWithRealtime({
    required String fromStationId,
    required String toStationId,
    required DateTime datetime,
  }) {
    calls++;
    return (pending[fromStationId] ??= Completer<DeparturesResult>()).future;
  }

  void complete(String from, DeparturesResult result) =>
      pending[from]!.complete(result);
}

class RecordingWidgets extends WidgetService {
  List<Trip> trips = [];
  Map<String, List<Departure>> go = {};
  Map<String, List<Departure>> back = {};
  @override
  Future<void> updateAllWidgets({
    required List<Trip> allTrips,
    required Map<String, List<Departure>> departuresGoByTrip,
    required Map<String, List<Departure>> departuresReturnByTrip,
    Map<String, DateTime?> lastUpdatesByTrip = const {},
    Map<String, TripDepartures> dataByTrip = const {},
    int? morningEveningSplitHour,
    int? serviceDayStartHour,
  }) async {
    trips = allTrips;
    go = departuresGoByTrip;
    back = departuresReturnByTrip;
  }

  @override
  Future<void> clearWidgetDataForTrip(String tripId) async {}
}

class BlockingClearStorage extends StorageService {
  final entered = Completer<void>();
  final release = Completer<void>();
  int clears = 0;
  @override
  Future<void> clearCache() async {
    clears++;
    entered.complete();
    await release.future;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const a = Trip(
    id: 'a',
    stationA: Station(id: 'A', name: 'A'),
    stationB: Station(id: 'B', name: 'B'),
    morningDirection: MorningDirection.aToB,
  );
  const b = Trip(
    id: 'b',
    stationA: Station(id: 'C', name: 'C'),
    stationB: Station(id: 'D', name: 'D'),
    morningDirection: MorningDirection.aToB,
  );
  late Directory temp;
  late ApiService api;
  late ControlledRealtime realtime;
  late RecordingWidgets widgets;
  late SettingsProvider settings;
  late TripProvider provider;
  late DateTime now;
  DeparturesResult result(
    String id,
    int minute, {
    bool online = true,
    DateTime? fetchedAt,
  }) => DeparturesResult(
    departures: [
      Departure(
        id: id,
        scheduledTime: DateTime(now.year, now.month, now.day, now.hour, minute),
        platform: '1',
        status: online ? DepartureStatus.onTime : DepartureStatus.offline,
      ),
    ],
    fetchedAt: fetchedAt ?? now,
    fromNetwork: online,
  );

  Future<void> start(
    List<Trip> trips, {
    String? activeId,
    StorageService? storage,
  }) async {
    SharedPreferences.setMockInitialValues({
      'trips': jsonEncode(trips.map((t) => t.toJson()).toList()),
      if (activeId != null) 'activeTripId': activeId,
    });
    settings = SettingsProvider();
    provider = TripProvider(
      settings,
      apiService: api,
      realtimeService: realtime,
      storageService: storage ?? StorageService(cacheDirectory: temp),
      widgetService: widgets,
      now: () => now,
      automaticUpdates: false,
    );
    await provider.ready;
  }

  Future<void> flush() async {
    for (var i = 0; i < 20; i++) {
      await Future<void>.delayed(Duration.zero);
    }
  }

  setUp(() async {
    now = DateTime(2026, 9, 8, 18);
    temp = await Directory.systemTemp.createTemp('surlequai-provider-');
    api = ApiService();
    realtime = ControlledRealtime(api, StorageService(cacheDirectory: temp));
    widgets = RecordingWidgets();
  });
  tearDown(() async {
    provider.dispose();
    settings.dispose();
    api.dispose();
    for (final pending in realtime.pending.values) {
      if (!pending.isCompleted) pending.complete(DeparturesResult());
    }
    await flush();
    await temp.delete(recursive: true);
  });

  test(
    'cache is visible while the first network requests are still pending',
    () async {
      final previous = now.subtract(const Duration(hours: 2));
      realtime.cached['A'] = result(
        'cachedA',
        10,
        online: false,
        fetchedAt: previous,
      );
      realtime.cached['B'] = result(
        'cachedB',
        20,
        online: false,
        fetchedAt: previous,
      );
      await start([a]);
      expect(provider.isLoading, false);
      expect(provider.lastUpdate, previous);
      expect(provider.departuresGo.single.id, 'cachedA');
      expect(realtime.calls, 2);
    },
  );

  test('offline fallback retains its original timestamp and banner', () async {
    await start([a]);
    final previous = now.subtract(const Duration(hours: 1));
    realtime.complete('A', result('a', 10, online: false, fetchedAt: previous));
    realtime.complete('B', result('b', 20, online: false, fetchedAt: previous));
    await flush();
    expect(provider.connectionStatus.name, 'offline');
    expect(provider.lastUpdate, previous);
  });

  test('evening display does not swap the raw lists sent to widgets', () async {
    await start([a]);
    realtime.complete('A', result('A-to-B', 10));
    realtime.complete('B', result('B-to-A', 20));
    await flush();
    expect(provider.directionGoViewModel!.title, 'B → A');
    expect(
      (provider.directionGoViewModel as DirectionCardWithDepartures).time,
      '18:20',
    );
    expect(widgets.go['a']!.single.id, 'A-to-B');
    expect(widgets.back['a']!.single.id, 'B-to-A');
  });

  test(
    'late results cannot change the selected trip or mix directions',
    () async {
      await start([a, b]);
      await provider.setActiveTrip(b);
      realtime.complete('C', result('C-to-D', 30));
      realtime.complete('D', result('D-to-C', 40));
      await flush();
      realtime.complete('A', result('A-to-B', 10));
      realtime.complete('B', result('B-to-A', 20));
      await flush();
      expect(provider.activeTrip!.id, 'b');
      expect(provider.departuresGo.single.id, 'C-to-D');
      expect(provider.departuresReturn.single.id, 'D-to-C');
      expect(provider.directionGoViewModel!.title, 'D → C');
    },
  );

  test('repeated refreshes share the same active requests', () async {
    await start([a]);
    final first = provider.refreshDepartures(feedback: false);
    final second = provider.refreshDepartures(feedback: false);
    expect(realtime.calls, 2);
    realtime.complete('A', result('a', 10));
    realtime.complete('B', result('b', 20));
    await Future.wait([first, second]);
  });

  test(
    'clock tick removes departed trains without needing network results',
    () async {
      await start([a]);
      realtime.complete('A', result('a', 1));
      realtime.complete('B', result('b', 1));
      await flush();
      now = now.add(const Duration(minutes: 2));
      provider.tick();
      expect(provider.directionGoViewModel, isA<DirectionCardNoDepartures>());
    },
  );

  test('cache deletion waits for pending requests and blocks overlapping refreshes', () async {
    final storage = BlockingClearStorage();
    await start([a], storage: storage);
    final clear = provider.clearCache();
    final sameClear = provider.clearCache();
    await provider.refreshDepartures(feedback: false);
    expect(realtime.calls, 2);
    expect(storage.clears, 0);
    realtime.complete('A', result('a', 10));
    realtime.complete('B', result('b', 20));
    await storage.entered.future;
    realtime.pending.clear();
    await provider.refreshDepartures(feedback: false);
    expect(realtime.calls, 2);
    storage.release.complete();
    await Future.wait([clear, sameClear]);
    await flush();
    expect(storage.clears, 1);
    expect(provider.departuresGo, isEmpty);
    expect(provider.departuresReturn, isEmpty);
    expect(widgets.go['a'], isEmpty);
    expect(widgets.back['a'], isEmpty);

    final refresh = provider.refreshDepartures(feedback: false);
    expect(realtime.calls, 4);
    realtime.complete('A', result('new-a', 30));
    realtime.complete('B', result('new-b', 40));
    await refresh;
    expect(provider.departuresGo.single.id, 'new-a');
  });

  test('saved active trip is restored', () async {
    await start([a, b], activeId: 'b');
    expect(provider.activeTrip!.id, 'b');
  });

  test('removing the last favorite clears widget configuration', () async {
    await start([a]);
    realtime.complete('A', result('a', 10));
    realtime.complete('B', result('b', 20));
    await flush();
    expect(await provider.removeTrip('a'), isNull);
    expect(provider.activeTrip, isNull);
    expect(widgets.trips, isEmpty);
    expect((await SharedPreferences.getInstance()).getString('trips'), '[]');
  });

  test(
    'disposal during network fetch never notifies disposed listeners',
    () async {
      await start([a]);
      provider.dispose();
      realtime.complete('A', result('a', 10));
      realtime.complete('B', result('b', 20));
      await flush();
      // tearDown must not dispose the same ChangeNotifier twice.
      provider = TripProvider(
        settings,
        apiService: api,
        realtimeService: realtime,
        widgetService: widgets,
        automaticUpdates: false,
      );
      await provider.ready;
    },
  );
}
