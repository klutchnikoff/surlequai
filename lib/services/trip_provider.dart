import 'package:flutter/material.dart';
import 'package:surlequai/models/departure.dart';
import 'package:surlequai/models/direction_card_view_model.dart';
import 'package:surlequai/models/trip.dart';
import 'package:surlequai/theme/colors.dart';
import 'package:surlequai/utils/mock_data.dart';

class TripProvider with ChangeNotifier {
  // Private state
  late List<Trip> _trips;
  late Trip _activeTrip;
  late DirectionCardViewModel _directionGoViewModel;
  late DirectionCardViewModel _directionReturnViewModel;
  
  // Also keep raw departures for the modal for now
  late List<Departure> _departuresGo;
  late List<Departure> _departuresReturn;

  // Public getters
  List<Trip> get trips => _trips;
  Trip get activeTrip => _activeTrip;
  DirectionCardViewModel get directionGoViewModel => _directionGoViewModel;
  DirectionCardViewModel get directionReturnViewModel => _directionReturnViewModel;
  List<Departure> get departuresGo => _departuresGo;
  List<Departure> get departuresReturn => _departuresReturn;

  TripProvider() {
    _trips = MockData.mockTrips;
    _activeTrip = _trips.first;
    _buildViewModels();
  }

  void _buildViewModels() {
    _departuresGo = MockData.getDeparturesGo(_activeTrip.id);
    _departuresReturn = MockData.getDeparturesReturn(_activeTrip.id);

    _directionGoViewModel = _createViewModel(
      title: '${_activeTrip.stationA.name} → ${_activeTrip.stationB.name}',
      departures: _departuresGo,
    );
    _directionReturnViewModel = _createViewModel(
      title: '${_activeTrip.stationB.name} → ${_activeTrip.stationA.name}',
      departures: _departuresReturn,
    );
  }

  DirectionCardViewModel _createViewModel({required String title, required List<Departure> departures}) {
    if (departures.isEmpty) {
      return DirectionCardViewModel.noDepartures(title: title);
    }

    final nextDeparture = departures.first;
    final subsequentDepartures = departures.skip(1).toList();

    Color statusBarColor;
    String statusText;

    switch (nextDeparture.status) {
      case DepartureStatus.onTime:
        statusBarColor = AppColors.onTime;
        statusText = 'À l\'heure';
        break;
      case DepartureStatus.delayed:
        statusBarColor = AppColors.delayed;
        statusText = '+${nextDeparture.delayMinutes} min';
        break;
      case DepartureStatus.cancelled:
        statusBarColor = AppColors.cancelled;
        statusText = 'Supprimé';
        break;
      case DepartureStatus.offline:
        statusBarColor = AppColors.offline;
        statusText = 'Horaire prévu';
        break;
    }

    return DirectionCardViewModel(
      title: title,
      statusBarColor: statusBarColor,
      hasDepartures: true,
      time: '${nextDeparture.scheduledTime.hour.toString().padLeft(2, '0')}:${nextDeparture.scheduledTime.minute.toString().padLeft(2, '0')}',
      platform: 'Voie ${nextDeparture.platform}',
      statusText: statusText,
      statusColor: statusBarColor,
      subsequentDepartures: subsequentDepartures.isNotEmpty
          ? 'Puis: ${subsequentDepartures.map((d) => '${d.scheduledTime.hour.toString().padLeft(2, '0')}:${d.scheduledTime.minute.toString().padLeft(2, '0')}').join('  ')}'
          : null,
    );
  }

  void setActiveTrip(Trip trip) {
    if (_activeTrip.id != trip.id) {
      _activeTrip = trip;
      _buildViewModels();
      notifyListeners();
    }
  }

  // TODO: Add methods to add/remove trips
}

