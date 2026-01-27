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
import 'package:surlequai/utils/station_id_migration.dart';
import 'package:surlequai/utils/trip_sorter.dart';
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

  // Services
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

  TripProvider(
    this._settingsProvider, {
    ApiService? apiService,
    StorageService? storageService,
    TimetableService? timetableService,
    RealtimeService? realtimeService,
    WidgetService? widgetService,
  }) {
    // Initialise les services (ou utilise ceux injectés)
    _apiService = apiService ?? ApiService();
    _storageService = storageService ?? StorageService();
    _timetableService = timetableService ??
        TimetableService(
          apiService: _apiService,
          storageService: _storageService,
        );
    _realtimeService = realtimeService ??
        RealtimeService(
          apiService: _apiService,
          timetableService: _timetableService,
          storageService: _storageService,
        );
    _widgetService = widgetService ?? WidgetService();

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

      // Migration automatique des anciens IDs vers les IDs Navitia
      if (StationIdMigration.tripsNeedMigration(_trips)) {
        debugPrint('[TripProvider] Migration des IDs de gares détectée...');
        _trips = StationIdMigration.migrateTrips(_trips);
        // Sauvegarde les trips migrés
        await _saveTrips();
        debugPrint('[TripProvider] Migration terminée et sauvegardée');
      }
    } else {
      _trips = [];
    }

    if (_trips.isNotEmpty) {
      _activeTrip = _trips.first;
      await _buildViewModels();
      _lastUpdate = DateTime.now();
    } else {
      _activeTrip = null;
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
  Future<void> refreshDepartures() async {
    if (_activeTrip == null) return;

    // Passer en mode synchronisation
    _connectionStatus = ConnectionStatus.syncing;
    notifyListeners();

    try {
      // Récupère les départs avec temps réel via RealtimeService
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

    final now = DateTime.now();

    final rawDeparturesGo = await _realtimeService.getDeparturesWithRealtime(
      fromStationId: _activeTrip!.stationA.id,
      toStationId: _activeTrip!.stationB.id,
      datetime: now,
      tripId: _activeTrip!.id,
    );

    final rawDeparturesReturn =
        await _realtimeService.getDeparturesWithRealtime(
      fromStationId: _activeTrip!.stationB.id,
      toStationId: _activeTrip!.stationA.id,
      datetime: now,
      tripId: _activeTrip!.id,
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

    // Préparer les données de tous les trajets pour les widgets
    final departuresGoByTrip = <String, List<Departure>>{};
    final departuresReturnByTrip = <String, List<Departure>>{};

    for (final trip in _trips) {
      try {
        final now = DateTime.now();

        // Récupérer les départs pour ce trajet
        final departuresGo = await _realtimeService.getDeparturesWithRealtime(
          fromStationId: trip.stationA.id,
          toStationId: trip.stationB.id,
          datetime: now,
          tripId: trip.id,
        );

        final departuresReturn = await _realtimeService.getDeparturesWithRealtime(
          fromStationId: trip.stationB.id,
          toStationId: trip.stationA.id,
          datetime: now,
          tripId: trip.id,
        );

        departuresGoByTrip[trip.id] = departuresGo;
        departuresReturnByTrip[trip.id] = departuresReturn;
      } catch (e) {
        debugPrint('Erreur lors de la mise à jour du trajet ${trip.id}: $e');
        // En cas d'erreur, ajouter des listes vides pour ce trajet
        departuresGoByTrip[trip.id] = [];
        departuresReturnByTrip[trip.id] = [];
      }
    }

    // Mettre à jour tous les widgets (sauvegarde + déclenchement du refresh)
    // Cela va sauvegarder les données ET déclencher onUpdate() côté Android
    // qui va planifier le WorkManager pour les mises à jour automatiques
    await _widgetService.updateAllWidgets(
      allTrips: _trips,
      departuresGoByTrip: departuresGoByTrip,
      departuresReturnByTrip: departuresReturnByTrip,
      morningEveningSplitHour: _settingsProvider.morningEveningSplitTime,
      serviceDayStartHour: _settingsProvider.serviceDayStartTime,
    );
  }

  bool _shouldSwapOrder() {
    if (_activeTrip == null) return false;

    return TripSorter.shouldSwapOrder(
      currentHour: DateTime.now().hour,
      morningEveningSplitHour: _settingsProvider.morningEveningSplitTime,
      serviceDayStartHour: _settingsProvider.serviceDayStartTime,
      morningDirection: _activeTrip!.morningDirection,
    );
  }

  DirectionCardViewModel _createViewModel(
      {required String title, required List<Departure> departures}) {
    final now = DateTime.now();
    final dayStartTime = _settingsProvider.serviceDayStartTime;

    // Calcule la fin de la "journée de service actuelle"
    // La journée de service va de dayStartTime (4h) à dayStartTime (4h) du lendemain
    DateTime endOfServiceDay;
    if (now.hour < dayStartTime) {
      // Entre minuit et dayStartTime (ex: 1h du matin)
      // → La journée de service se termine à dayStartTime (4h) aujourd'hui
      endOfServiceDay = DateTime(now.year, now.month, now.day, dayStartTime);
    } else {
      // Après dayStartTime → journée se termine à dayStartTime (4h) demain
      final tomorrow = now.add(const Duration(days: 1));
      endOfServiceDay = DateTime(tomorrow.year, tomorrow.month, tomorrow.day, dayStartTime);
    }

    // Filtre les trains "aujourd'hui" (avant la fin de journée de service)
    // IMPORTANT : On compare l'heure RÉELLE de départ (heure prévue + retard)
    final trainsToday = departures.where((d) {
      final actualDepartureTime = d.scheduledTime.add(Duration(minutes: d.delayMinutes));
      return actualDepartureTime.isAfter(now) &&
             d.scheduledTime.isBefore(endOfServiceDay);
    }).toList();

    // Trier par heure réelle de départ (gère les retards importants)
    trainsToday.sort((a, b) {
      final aActual = a.scheduledTime.add(Duration(minutes: a.delayMinutes));
      final bActual = b.scheduledTime.add(Duration(minutes: b.delayMinutes));
      return aActual.compareTo(bActual);
    });

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
    // Le premier de la liste est celui qui part réellement le plus tôt
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
      durationMinutes: nextDeparture.durationMinutes,
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
    
    // Si c'est le premier trajet, ou pour basculer directement sur le nouveau,
    // on le définit comme actif. Cela déclenche aussi le chargement des données.
    await setActiveTrip(newTrip);
    
    // notifyListeners() est déjà appelé par setActiveTrip, mais saveTrips a pu changer l'état
    // setActiveTrip notifie.
    
    return null; // Succès
  }

  /// Supprime un trajet
  ///
  /// Retourne un message d'erreur si la suppression échoue, null sinon.
  Future<String?> removeTrip(String tripId) async {
    final tripIndex = _trips.indexWhere((t) => t.id == tripId);

    if (tripIndex == -1) {
      return 'Trajet introuvable';
    }

    _trips.removeAt(tripIndex);

    if (_trips.isEmpty) {
      _activeTrip = null;
      _directionGoViewModel = null;
      _directionReturnViewModel = null;
    } else if (_activeTrip?.id == tripId) {
      // Si le trajet supprimé était le trajet actif, basculer vers le premier
      _activeTrip = _trips.first;
      await _buildViewModels();
    }
    // Si on a supprimé un trajet non actif, pas besoin de rebuild les viewModels
    // mais il faut quand même sauvegarder et notifier.

    await _saveTrips();
    notifyListeners();

    // Nettoyer les données du trajet supprimé des widgets
    await _widgetService.clearWidgetDataForTrip(tripId);

    // Mettre à jour les widgets avec les trajets restants
    _updateWidget();

    return null; // Succès
  }
}
