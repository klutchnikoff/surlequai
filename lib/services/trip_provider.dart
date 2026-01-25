import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:surlequai/models/connection_status.dart';
import 'package:surlequai/models/departure.dart';
import 'package:surlequai/models/direction_card_view_model.dart';
import 'package:surlequai/models/station.dart';
import 'package:surlequai/models/trip.dart';
import 'package:surlequai/services/api_service.dart';
import 'package:surlequai/services/realtime_service.dart';
import 'package:surlequai/services/settings_provider.dart';
import 'package:surlequai/services/storage_service.dart';
import 'package:surlequai/services/timetable_service.dart';
import 'package:surlequai/services/widget_service.dart';
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

  // État de la connexion
  ConnectionStatus _connectionStatus = ConnectionStatus.offline;

  // Dependencies
  final SettingsProvider _settingsProvider;

  // Services (Phase 1 : avec mocks, Phase 2 : API réelle)
  late final ApiService _apiService;
  late final StorageService _storageService;
  late final TimetableService _timetableService;
  late final RealtimeService _realtimeService;
  late final WidgetService _widgetService;

  // Public getters - now nullable
  List<Trip> get trips => _trips;
  Trip? get activeTrip => _activeTrip;
  DirectionCardViewModel? get directionGoViewModel => _directionGoViewModel;
  DirectionCardViewModel? get directionReturnViewModel =>
      _directionReturnViewModel;
  List<Departure> get departuresGo => _departuresGo;
  List<Departure> get departuresReturn => _departuresReturn;
  DateTime? get lastUpdate => _lastUpdate;
  ConnectionStatus get connectionStatus => _connectionStatus;

  TripProvider(this._settingsProvider) {
    // Initialise les services
    _apiService = ApiService();
    _storageService = StorageService();
    _timetableService = TimetableService(
      apiService: _apiService,
      storageService: _storageService,
    );
    _realtimeService = RealtimeService(
      apiService: _apiService,
      timetableService: _timetableService,
    );
    _widgetService = WidgetService();

    _loadTrips();
  }

  Future<void> _loadTrips() async {
    // Initialise les services (SQLite, etc.)
    await _storageService.init();
    await _timetableService.init();

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
      await _buildViewModels();
      _lastUpdate = DateTime.now();
    }

    isLoading = false;
    notifyListeners();

    // Après avoir affiché les données locales, tente automatiquement
    // de se "connecter" pour passer en mode online
    // (En Phase 1 : simule juste le délai réseau, en Phase 2 : vrai appel API)
    if (_trips.isNotEmpty) {
      await refreshDepartures();
    }
  }

  Future<void> _saveTrips() async {
    final prefs = await SharedPreferences.getInstance();
    final tripsJson = jsonEncode(_trips.map((trip) => trip.toJson()).toList());
    await prefs.setString(AppConstants.tripsStorageKey, tripsJson);
  }

  Future<void> update() async {
    if (!isLoading) {
      await _buildViewModels();
      notifyListeners();
    }
  }

  /// Rafraîchit les données de départs (temps réel)
  ///
  /// Phase 1 : Utilise RealtimeService avec mock data
  /// Phase 2 : Fera de vrais appels API SNCF via le service
  Future<void> refreshDepartures() async {
    if (_activeTrip == null) return;

    // Passer en mode synchronisation
    _connectionStatus = ConnectionStatus.syncing;
    notifyListeners();

    try {
      // Utilise RealtimeService pour obtenir les départs avec temps réel
      // (Phase 1 : retourne les mocks, Phase 2 : fera le vrai appel API)
      await _buildViewModels();
      _lastUpdate = DateTime.now();

      // Succès : mode online
      _connectionStatus = ConnectionStatus.online;
      notifyListeners();

      // Feedback haptique pour indiquer que le rafraîchissement est terminé
      HapticFeedback.mediumImpact();
    } catch (e) {
      // En cas d'erreur, passer en mode erreur
      _connectionStatus = ConnectionStatus.error;
      notifyListeners();

      // Revenir en mode offline après 3 secondes
      Future.delayed(const Duration(seconds: 3), () {
        if (_connectionStatus == ConnectionStatus.error) {
          _connectionStatus = ConnectionStatus.offline;
          notifyListeners();
        }
      });
    }
  }

  Future<void> _buildViewModels() async {
    if (_activeTrip == null) return;

    // Phase 1 : RealtimeService utilise les mocks depuis InitialMockData
    // Phase 2 : RealtimeService fera les vrais appels API
    final now = DateTime.now();

    final rawDeparturesGo = await _realtimeService.getDeparturesWithRealtime(
      fromStationId: _activeTrip!.stationA.id,
      toStationId: _activeTrip!.stationB.id,
      datetime: now,
      tripId: _activeTrip!.id, // Phase 1: pour accéder aux mocks
    );

    final rawDeparturesReturn =
        await _realtimeService.getDeparturesWithRealtime(
      fromStationId: _activeTrip!.stationB.id,
      toStationId: _activeTrip!.stationA.id,
      datetime: now,
      tripId: _activeTrip!.id, // Phase 1: pour accéder aux mocks
    );

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

    // Met à jour le widget écran d'accueil avec les nouvelles données
    _updateWidget();
  }

  /// Met à jour le widget écran d'accueil
  Future<void> _updateWidget() async {
    if (_activeTrip == null ||
        _directionGoViewModel == null ||
        _directionReturnViewModel == null) {
      return;
    }

    await _widgetService.updateWidget(
      activeTrip: _activeTrip!,
      departuresGo: _departuresGo,
      departuresReturn: _departuresReturn,
      direction1Title: _directionGoViewModel!.title,
      direction2Title: _directionReturnViewModel!.title,
    );
  }

  bool _shouldSwapOrder() {
    if (_activeTrip == null) return false;

    final hour = DateTime.now().hour;
    final splitTime = _settingsProvider.morningEveningSplitTime;
    final dayStartTime = _settingsProvider.serviceDayStartTime;

    // Considère comme "soirée" :
    // - Entre splitTime (13h) et serviceDayEndHour (22h)
    // - OU entre minuit et dayStartTime (4h) car encore dans la journée de service précédente
    final isEvening =
        (hour >= splitTime && hour < AppConstants.serviceDayEndHour) ||
            (hour >= 0 && hour < dayStartTime);

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
    final now = DateTime.now();
    final dayStartTime = _settingsProvider.serviceDayStartTime;

    // Calcule la fin de la "journée de service actuelle"
    DateTime endOfServiceDay;
    if (now.hour < dayStartTime) {
      // Entre minuit et dayStartTime (ex: 1h du matin)
      // → La journée de service se termine à dayStartTime (4h)
      endOfServiceDay = DateTime(now.year, now.month, now.day, dayStartTime);
    } else {
      // Après dayStartTime → journée se termine à serviceDayEndHour (22h)
      endOfServiceDay = DateTime(now.year, now.month, now.day, AppConstants.serviceDayEndHour);
    }

    // Filtre les trains "aujourd'hui" (avant la fin de journée de service)
    final trainsToday = departures
        .where((d) =>
            d.scheduledTime.isAfter(now) &&
            d.scheduledTime.isBefore(endOfServiceDay))
        .toList();

    // Filtre les trains "demain" (après la fin de journée de service)
    final trainsTomorrow =
        departures.where((d) => d.scheduledTime.isAfter(endOfServiceDay)).toList();

    // Cas 1 : Aucun train aujourd'hui, mais il y en a demain
    if (trainsToday.isEmpty && trainsTomorrow.isNotEmpty) {
      return DirectionCardNoDepartures.nextTrainTomorrow(
        title: title,
        tomorrowTime: TimeFormatter.formatTime(trainsTomorrow.first.scheduledTime),
      );
    }

    // Cas 2 : Aucun train du tout
    if (trainsToday.isEmpty && trainsTomorrow.isEmpty) {
      return DirectionCardNoDepartures.defaultEmpty(title: title);
    }

    // Cas 3 : Il y a des trains aujourd'hui
    final nextDeparture = trainsToday.first;

    // Limiter le nombre de départs suivants à afficher
    final subsequentDepartures = trainsToday
        .skip(1)
        .take(AppConstants.subsequentDeparturesCount)
        .toList();

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

  Future<void> setActiveTrip(Trip trip) async {
    if (_activeTrip?.id != trip.id) {
      _activeTrip = trip;
      await _buildViewModels();
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
      await _buildViewModels();
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
      await _buildViewModels();
    }

    await _saveTrips();
    notifyListeners();

    return null; // Succès
  }
}
