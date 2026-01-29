import 'package:flutter_test/flutter_test.dart';
import 'package:surlequai/models/departure.dart';
import 'package:surlequai/models/direction_card_view_model.dart';
import 'package:surlequai/theme/colors.dart';

void main() {
  group('DirectionCardViewModel Tests', () {
    // Date de référence pour tous les tests : 28 Janvier 2026 à 10h00
    final fixedNow = DateTime(2026, 1, 28, 10, 0);

    test('should return WithDepartures when a train is available soon', () {
      final departure = Departure(
        id: '1',
        scheduledTime: fixedNow.add(const Duration(minutes: 15)), // 10:15
        platform: 'A',
        status: DepartureStatus.onTime,
      );

      final viewModel = DirectionCardViewModel.fromDepartures(
        title: 'Test Trip',
        departures: [departure],
        serviceDayStartTime: 4,
        now: fixedNow,
      );

      expect(viewModel, isA<DirectionCardWithDepartures>());
      final vm = viewModel as DirectionCardWithDepartures;
      expect(vm.time, '10:15');
      expect(vm.platform, 'Voie A');
      expect(vm.statusColor, AppColors.onTime);
    });

    test('should handle delayed trains correctly', () {
      final departure = Departure(
        id: '2',
        scheduledTime: fixedNow.add(const Duration(minutes: 10)), // 10:10
        delayMinutes: 5, // Réel: 10:15
        platform: 'B',
        status: DepartureStatus.delayed,
      );

      final viewModel = DirectionCardViewModel.fromDepartures(
        title: 'Delayed Trip',
        departures: [departure],
        serviceDayStartTime: 4,
        now: fixedNow,
      );

      final vm = viewModel as DirectionCardWithDepartures;
      expect(vm.statusText, '+5 min');
      expect(vm.statusColor, AppColors.delayed);
    });

    test('should return NoDepartures (nextTrainTomorrow) when no trains today', () {
      // Train demain à 8h00
      final tomorrowDeparture = Departure(
        id: '3',
        scheduledTime: fixedNow.add(const Duration(days: 1)).copyWith(hour: 8, minute: 0),
        platform: 'C',
        status: DepartureStatus.onTime,
      );

      final viewModel = DirectionCardViewModel.fromDepartures(
        title: 'Tomorrow Trip',
        departures: [tomorrowDeparture],
        serviceDayStartTime: 4,
        now: fixedNow,
      );

      expect(viewModel, isA<DirectionCardNoDepartures>());
      final vm = viewModel as DirectionCardNoDepartures;
      expect(vm.noTrainStatusDisplay, contains('Premier train demain: 08:00'));
    });
    
    test('should ignore trains already departed', () {
      // Train passé il y a 5 min (09:55)
      final pastDeparture = Departure(
        id: '4',
        scheduledTime: fixedNow.subtract(const Duration(minutes: 5)),
        platform: 'D',
        status: DepartureStatus.onTime,
      );

      final viewModel = DirectionCardViewModel.fromDepartures(
        title: 'Past Trip',
        departures: [pastDeparture],
        serviceDayStartTime: 4,
        now: fixedNow,
      );

      expect(viewModel, isA<DirectionCardNoDepartures>());
      final vm = viewModel as DirectionCardNoDepartures;
      expect(vm.noTrainStatusDisplay, contains('Aucun train prévu'));
    });
  });
}

// Extension utilitaire pour faciliter la copie de DateTime
extension DateTimeExtension on DateTime {
  DateTime copyWith({int? hour, int? minute}) {
    return DateTime(year, month, day, hour ?? this.hour, minute ?? this.minute);
  }
}
