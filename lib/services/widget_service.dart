import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:home_widget/home_widget.dart';
import 'package:surlequai/models/departure.dart';
import 'package:surlequai/models/direction_card_view_model.dart';
import 'package:surlequai/models/trip.dart';
import 'package:surlequai/utils/constants.dart';
import 'package:surlequai/utils/formatters.dart';
import 'package:surlequai/utils/service_day.dart';
import 'package:surlequai/utils/trip_sorter.dart';

/// Contrat unique Flutter → widgets : directions, dates complètes et provenance.
class WidgetService {
  static const appGroupId = 'group.com.surlequai.app';
  final DateTime Function() _now;

  WidgetService({DateTime Function()? now}) : _now = now ?? DateTime.now;
  bool get _supported =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS);

  Future<void> saveAllTrips(List<Trip> trips) async {
    if (!_supported) return;
    await HomeWidget.setAppGroupId(appGroupId);
    await HomeWidget.saveWidgetData<String>(
      'trips',
      jsonEncode(trips.map((t) => t.toJson()).toList()),
    );
  }

  Map<String, String> _direction(
    String title,
    List<Departure> departures,
    int dayStart,
    DateTime date,
  ) {
    final vm = DirectionCardViewModel.fromDepartures(
      title: title,
      departures: departures,
      serviceDayStartTime: dayStart,
      now: date,
    );
    return switch (vm) {
      DirectionCardWithDepartures() => {
        'title': vm.title,
        'time': vm.time,
        'platform': vm.platform,
        'status': vm.statusText,
        'color': vm.statusType.name,
      },
      DirectionCardNoDepartures() => {
        'title': vm.title,
        'time': vm.noTrainTimeDisplay,
        'platform': '',
        'status': vm.noTrainStatusDisplay,
        'color': 'secondary',
      },
    };
  }

  Map<String, dynamic> _frame(
    Trip trip,
    List<Departure> go,
    List<Departure> back,
    int split,
    int dayStart,
    DateTime date,
    DateTime? fetchedAt,
  ) {
    // Une timeline locale ne peut pas prolonger indéfiniment un statut temps réel.
    if (fetchedAt == null ||
        date.difference(fetchedAt) >= const Duration(minutes: 5)) {
      List<Departure> offline(List<Departure> list) => list
          .map(
            (d) => d.copyWith(
              status: DepartureStatus.offline,
              delayMinutes: 0,
              platform: '?',
            ),
          )
          .toList();
      go = offline(go);
      back = offline(back);
    }
    final swap = TripSorter.shouldSwapOrder(
      currentHour: date.hour,
      morningEveningSplitHour: split,
      serviceDayStartHour: dayStart,
      morningDirection: trip.morningDirection,
    );
    final a = _direction('→ ${trip.stationB.name}', go, dayStart, date);
    final b = _direction('→ ${trip.stationA.name}', back, dayStart, date);
    return {
      'date': date.millisecondsSinceEpoch,
      'direction1': swap ? b : a,
      'direction2': swap ? a : b,
    };
  }

  Future<void> updateWidgetForTrip({
    required Trip trip,
    required List<Departure> departuresGo,
    required List<Departure> departuresReturn,
    int? morningEveningSplitHour,
    int? serviceDayStartHour,
    DateTime? now,
    DateTime? lastUpdate,
  }) async {
    if (!_supported) return;
    await HomeWidget.setAppGroupId(appGroupId);
    final date = now ?? _now();
    final frame = _frame(
      trip,
      departuresGo,
      departuresReturn,
      morningEveningSplitHour ?? AppConstants.defaultMorningEveningSplitHour,
      serviceDayStartHour ?? AppConstants.defaultServiceDayStartHour,
      date,
      lastUpdate,
    );
    await HomeWidget.saveWidgetData<String>(
      'trip_${trip.id}_name',
      '${trip.stationA.name} ⟷ ${trip.stationB.name}',
    );
    for (final suffix in ['direction1', 'direction2']) {
      final direction = frame[suffix] as Map<String, String>;
      for (final entry in direction.entries) {
        final field = entry.key == 'color' ? 'status_color' : entry.key;
        await HomeWidget.saveWidgetData<String>(
          'trip_${trip.id}_${suffix}_$field',
          entry.value,
        );
      }
    }
    await HomeWidget.saveWidgetData<String>(
      'trip_${trip.id}_last_update',
      lastUpdate == null
          ? 'Jamais'
          : '${DateFormatter.formatShortDate(lastUpdate)} ${TimeFormatter.formatTime(lastUpdate)}',
    );
    final future =
        [
            ...departuresGo,
            ...departuresReturn,
          ].map((d) => d.effectiveTime).where((d) => d.isAfter(date)).toList()
          ..sort();
    await HomeWidget.saveWidgetData<String>(
      'trip_${trip.id}_next_departure',
      future.isEmpty ? null : future.first.millisecondsSinceEpoch.toString(),
    );
  }

  Future<void> updateAllWidgets({
    required List<Trip> allTrips,
    required Map<String, List<Departure>> departuresGoByTrip,
    required Map<String, List<Departure>> departuresReturnByTrip,
    Map<String, DateTime?> lastUpdatesByTrip = const {},
    int? morningEveningSplitHour,
    int? serviceDayStartHour,
  }) async {
    if (!_supported) return;
    await saveAllTrips(allTrips);
    final now = _now();
    final split =
        morningEveningSplitHour ?? AppConstants.defaultMorningEveningSplitHour;
    final dayStart =
        serviceDayStartHour ?? AppConstants.defaultServiceDayStartHour;
    final snapshots = <Map<String, dynamic>>[];
    for (final trip in allTrips) {
      final go = departuresGoByTrip[trip.id] ?? [];
      final back = departuresReturnByTrip[trip.id] ?? [];
      final updated = lastUpdatesByTrip[trip.id];
      await updateWidgetForTrip(
        trip: trip,
        departuresGo: go,
        departuresReturn: back,
        morningEveningSplitHour: split,
        serviceDayStartHour: dayStart,
        lastUpdate: updated,
        now: now,
      );
      // Préparer les changements de train, de fraîcheur et de jour pour WidgetKit.
      final dates = <DateTime>{now};
      final end = ServiceDay.next(
        ServiceDay.next(ServiceDay.start(now, dayStart)),
      );
      for (final d in [...go, ...back]) {
        dates.add(d.scheduledTime);
        dates.add(d.effectiveTime);
      }
      if (updated != null) dates.add(updated.add(const Duration(minutes: 5)));
      for (var offset = 0; offset <= 2; offset++) {
        dates.add(DateTime(now.year, now.month, now.day + offset, split));
        dates.add(DateTime(now.year, now.month, now.day + offset, dayStart));
      }
      final timeline =
          dates.where((d) => !d.isBefore(now) && !d.isAfter(end)).toList()
            ..sort();
      snapshots.add({
        'id': trip.id,
        'name': '${trip.stationA.name} ⟷ ${trip.stationB.name}',
        'updatedAt': updated?.millisecondsSinceEpoch,
        'frames': timeline
            .map((d) => _frame(trip, go, back, split, dayStart, d, updated))
            .toList(),
      });
    }
    // Un seul JSON évite que WidgetKit lise un mélange de deux publications.
    await HomeWidget.saveWidgetData<String>(
      'widget_snapshot',
      jsonEncode({'trips': snapshots}),
    );
    await HomeWidget.updateWidget(
      androidName: 'SurLeQuaiWidgetProvider',
      iOSName: 'SurLeQuaiWidget',
    );
  }

  Future<void> clearWidgetDataForTrip(String tripId) async {
    if (!_supported) return;
    for (final field in [
      'name',
      'last_update',
      'next_departure',
      for (final direction in ['direction1', 'direction2'])
        for (final key in [
          'title',
          'time',
          'platform',
          'status',
          'status_color',
        ])
          '${direction}_$key',
    ]) {
      await HomeWidget.saveWidgetData<String>('trip_${tripId}_$field', null);
    }
  }
}
