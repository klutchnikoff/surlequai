import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:surlequai/models/departure.dart';
import 'package:surlequai/models/direction_card_view_model.dart';
import 'package:surlequai/models/station.dart';
import 'package:surlequai/models/trip.dart';
import 'package:surlequai/services/settings_provider.dart';
import 'package:surlequai/theme/colors.dart';
import 'package:surlequai/utils/constants.dart';
import 'package:surlequai/utils/formatters.dart';
import 'package:surlequai/utils/mock_data.dart';
import 'package:uuid/uuid.dart';

class TripProvider with ChangeNotifier {
  // Public loading state
  bool isLoading = true;

  // Private state - now nullable or initialized empty
  List<Trip> _trips = [];
  Trip? _activeTrip;
  DirectionCardViewModel? _directionGoViewModel;
  DirectionCardViewModel? _directionReturnViewModel;

  List<Departure> _departuresGo = [];
  List<Departure> _departuresReturn = [];

  // Timestamp de la dernière mise à jour
  DateTime? _lastUpdate;

  // Dependencies
  final SettingsProvider _settingsProvider;

  // Public getters - now nullable
  List<Trip> get trips => _trips;
  Trip? get activeTrip => _activeTrip;
  DirectionCardViewModel? get directionGoViewModel => _directionGoViewModel;
  DirectionCardViewModel? get directionReturnViewModel =>
      _directionReturnViewModel;
  List<Departure> get departuresGo => _departuresGo;
  List<Departure> get departuresReturn => _departuresReturn;
  DateTime? get lastUpdate => _lastUpdate;

  TripProvider(this._settingsProvider) {
    _loadTrips();
  }

  Future<void> _loadTrips() async {
    final prefs = await SharedPreferences.getInstance();
    final tripsJson = prefs.getString(AppConstants.tripsStorageKey);

    if (tripsJson != null) {
      final List<dynamic> tripsData = jsonDecode(tripsJson);
      _trips = tripsData.map((data) => Trip.fromJson(data)).toList();
    } else {
      _trips = InitialMockData.initialTrips;
    }

    if (_trips.isNotEmpty) {
      _activeTrip = _trips.first;
      _buildViewModels();
      _lastUpdate = DateTime.now();
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> _saveTrips() async {
    final prefs = await SharedPreferences.getInstance();
    final tripsJson = jsonEncode(_trips.map((trip) => trip.toJson()).toList());
    await prefs.setString(AppConstants.tripsStorageKey, tripsJson);
  }

  void update() {
    if (!isLoading) {
      _buildViewModels();
      notifyListeners();
    }
  }

  /// Rafraîchit les données de départs (temps réel)
  ///
  /// Pour l'instant, recharge les mock data.
  /// TODO: Remplacer par un appel API une fois le service API implémenté
  Future<void> refreshDepartures() async {
    // Simule un délai réseau (à retirer une fois l'API réelle en place)
    await Future.delayed(AppConstants.mockNetworkDelay);

    // TODO: Une fois l'API implémentée, remplacer par :
    // final departures = await apiService.fetchDepartures(
    //   fromStationId: _activeTrip!.stationA.id,
    //   toStationId: _activeTrip!.stationB.id,
    // );
    // _departuresGo = departures;
    // etc.

    // Pour l'instant, on reconstruit juste les ViewModels avec les mock data
    _buildViewModels();
    _lastUpdate = DateTime.now();
    notifyListeners();

    // Feedback haptique pour indiquer que le rafraîchissement est terminé
    HapticFeedback.mediumImpact();
  }

  void _buildViewModels() {
    if (_activeTrip == null) return;

    final rawDeparturesGo =
        InitialMockData.departuresData['${_activeTrip!.id}_go'] ?? [];
    final rawDeparturesReturn =
        InitialMockData.departuresData['${_activeTrip!.id}_return'] ?? [];

    final goViewModel = _createViewModel(
      title: '${_activeTrip!.stationA.name} → ${_activeTrip!.stationB.name}',
      departures: rawDeparturesGo,
    );
    final returnViewModel = _createViewModel(
      title: '${_activeTrip!.stationB.name} → ${_activeTrip!.stationA.name}',
      departures: rawDeparturesReturn,
    );

    if (_shouldSwapOrder()) {
      _directionGoViewModel = returnViewModel;
      _directionReturnViewModel = goViewModel;
      _departuresGo = rawDeparturesReturn;
      _departuresReturn = rawDeparturesGo;
    } else {
      _directionGoViewModel = goViewModel;
      _directionReturnViewModel = returnViewModel;
      _departuresGo = rawDeparturesGo;
      _departuresReturn = rawDeparturesReturn;
    }
  }

  bool _shouldSwapOrder() {
    if (_activeTrip == null) return false;

    final hour = DateTime.now().hour;
    final splitTime = _settingsProvider.morningEveningSplitTime;

    final isEvening =
        hour >= splitTime && hour < AppConstants.serviceDayEndHour;

    if (isEvening && _activeTrip!.morningDirection == MorningDirection.aToB) {
      return true;
    }
    if (!isEvening && _activeTrip!.morningDirection == MorningDirection.bToA) {
      return true;
    }

    return false;
  }

  DirectionCardViewModel _createViewModel(
      {required String title, required List<Departure> departures}) {
    if (departures.isEmpty) {
      return DirectionCardNoDepartures.defaultEmpty(title: title);
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

    return DirectionCardWithDepartures(
      title: title,
      statusBarColor: statusBarColor,
      time: TimeFormatter.formatTime(nextDeparture.scheduledTime),
      platform: 'Voie ${nextDeparture.platform}',
      statusText: statusText,
      statusColor: statusBarColor,
      subsequentDepartures: subsequentDepartures.isNotEmpty
          ? 'Puis: ${TimeFormatter.formatTimeList(subsequentDepartures.map((d) => d.scheduledTime).toList())}'
          : null,
    );
  }

  void setActiveTrip(Trip trip) {
    if (_activeTrip?.id != trip.id) {
      _activeTrip = trip;
      _buildViewModels();
      notifyListeners();
    }
  }

  Future<void> updateActiveTripMorningDirection(
      MorningDirection direction) async {
    if (_activeTrip == null || _activeTrip!.morningDirection == direction) {
      return;
    }

    final updatedTrip = _activeTrip!.copyWith(morningDirection: direction);

    final tripIndex = _trips.indexWhere((t) => t.id == updatedTrip.id);
    if (tripIndex != -1) {
      _trips[tripIndex] = updatedTrip;
      _activeTrip = updatedTrip;
      await _saveTrips();
      _buildViewModels();
      notifyListeners();
    }
  }

  /// Ajoute un nouveau trajet
  ///
  /// Retourne un message d'erreur si l'ajout échoue, null sinon.
  Future<String?> addTrip({
    required Station stationA,
    required Station stationB,
    required MorningDirection morningDirection,
  }) async {
    // Validation : maximum de trajets atteint
    if (_trips.length >= AppConstants.maxFavoriteTrips) {
      return 'Vous avez atteint le nombre maximum de trajets (${AppConstants.maxFavoriteTrips})';
    }

    // Validation : même gare pour A et B
    if (stationA.id == stationB.id) {
      return 'Les gares de départ et d\'arrivée doivent être différentes';
    }

    // Validation : vérifier les doublons (même paire de gares, dans un sens ou l'autre)
    final isDuplicate = _trips.any((trip) {
      return (trip.stationA.id == stationA.id &&
              trip.stationB.id == stationB.id) ||
          (trip.stationA.id == stationB.id && trip.stationB.id == stationA.id);
    });

    if (isDuplicate) {
      return 'Ce trajet existe déjà';
    }

    // Créer le nouveau trajet
    final newTrip = Trip(
      id: 'trip-${const Uuid().v4()}',
      stationA: stationA,
      stationB: stationB,
      morningDirection: morningDirection,
    );

    _trips.add(newTrip);
    await _saveTrips();
    notifyListeners();

    return null; // Succès
  }

  /// Supprime un trajet
  ///
  /// Retourne un message d'erreur si la suppression échoue, null sinon.
  Future<String?> removeTrip(String tripId) async {
    // Validation : au moins un trajet doit rester
    if (_trips.length <= 1) {
      return 'Vous devez conserver au moins un trajet';
    }

    final tripIndex = _trips.indexWhere((t) => t.id == tripId);

    if (tripIndex == -1) {
      return 'Trajet introuvable';
    }

    _trips.removeAt(tripIndex);

    // Si le trajet supprimé était le trajet actif, basculer vers le premier
    if (_activeTrip?.id == tripId) {
      _activeTrip = _trips.first;
      _buildViewModels();
    }

    await _saveTrips();
    notifyListeners();

    return null; // Succès
  }
}
