import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:surlequai/models/connection_status.dart';
import 'package:surlequai/models/departure.dart';
import 'package:surlequai/models/departures_result.dart';
import 'package:surlequai/models/direction_card_view_model.dart';
import 'package:surlequai/models/station.dart';
import 'package:surlequai/models/trip.dart';
import 'package:surlequai/services/api_service.dart';
import 'package:surlequai/services/realtime_service.dart';
import 'package:surlequai/services/settings_provider.dart';
import 'package:surlequai/services/storage_service.dart';
import 'package:surlequai/services/widget_service.dart';
import 'package:surlequai/utils/constants.dart';
import 'package:surlequai/utils/station_id_migration.dart';
import 'package:surlequai/utils/trip_sorter.dart';
import 'package:uuid/uuid.dart';

class TripProvider with ChangeNotifier {
  final SettingsProvider _settingsProvider;
  final DateTime Function() _now;
  final bool automaticUpdates;
  late final ApiService _apiService;
  late final StorageService _storageService;
  late final RealtimeService _realtimeService;
  late final WidgetService _widgetService;
  final bool _ownsApi;
  late final Future<void> ready;

  bool isLoading = true;
  bool _disposed = false;
  bool _foreground = true;
  final List<Trip> _trips = [];
  Trip? _activeTrip;
  final Map<String, TripDepartures> _data = {};
  final Map<String, Future<void>> _requests = {};
  DateTime? _lastAttempt;
  DateTime? _lastOtherTripsRefresh;
  Timer? _timer;
  Future<void> _widgetWrites = Future.value();
  int _selection = 0;
  int _cacheGeneration = 0;
  Future<void>? _clearingCache;
  DirectionCardViewModel? _directionGoViewModel;
  DirectionCardViewModel? _directionReturnViewModel;
  bool _swapped = false;
  ConnectionStatus _connectionStatus = ConnectionStatus.offline;

  List<Trip> get trips => List.unmodifiable(_trips);
  Trip? get activeTrip => _activeTrip;
  DirectionCardViewModel? get directionGoViewModel => _directionGoViewModel;
  DirectionCardViewModel? get directionReturnViewModel =>
      _directionReturnViewModel;
  TripDepartures? get _activeData {
    final data = _data[_activeTrip?.id];
    if (data == null) return null;
    DeparturesResult current(DeparturesResult result) {
      final fetched = result.fetchedAt;
      if (result.fromNetwork &&
          (fetched == null ||
              _now().difference(fetched) >
                  AppConstants.refreshInterval + AppConstants.apiTimeout)) {
        return result.asOffline();
      }
      return result;
    }

    return TripDepartures(current(data.go), current(data.back));
  }

  // Les données restent toujours A→B et B→A. Seuls les ViewModels sont ordonnés.
  List<Departure> get departuresGo => _activeData?.go.departures ?? const [];
  List<Departure> get departuresReturn =>
      _activeData?.back.departures ?? const [];
  DateTime? get lastUpdate => _activeData?.fetchedAt;
  ConnectionStatus get connectionStatus => _connectionStatus;
  bool get isSwapped => _swapped;

  TripProvider(
    this._settingsProvider, {
    ApiService? apiService,
    StorageService? storageService,
    RealtimeService? realtimeService,
    WidgetService? widgetService,
    DateTime Function()? now,
    this.automaticUpdates = true,
  }) : _now = now ?? DateTime.now,
       _ownsApi = apiService == null {
    _apiService = apiService ?? ApiService();
    _storageService = storageService ?? StorageService();
    _realtimeService =
        realtimeService ??
        RealtimeService(
          apiService: _apiService,
          storageService: _storageService,
        );
    _widgetService = widgetService ?? WidgetService();
    _settingsProvider.addListener(_settingsChanged);
    ready = _loadTrips();
  }

  void _notify() {
    if (!_disposed) notifyListeners();
  }

  Future<void> _loadTrips() async {
    try {
      await _settingsProvider.ready;
      if (_ownsApi) await _apiService.init();
      final prefs = await SharedPreferences.getInstance();
      final json = prefs.getString(AppConstants.tripsStorageKey);
      if (json != null) {
        final raw = jsonDecode(json) as List;
        // Un favori invalide ne doit pas faire disparaître tous les autres.
        for (final entry in raw) {
          try {
            _trips.add(StationIdMigration.migrateTrip(Trip.fromJson(entry)));
          } catch (e) {
            debugPrint('Favori illisible: $e');
          }
        }
      }
      if (_disposed) return;
      if (_trips.isNotEmpty) {
        final activeId = prefs.getString(AppConstants.activeTripIdKey);
        _activeTrip = _trips.firstWhere(
          (t) => t.id == activeId,
          orElse: () => _trips.first,
        );
        await _loadCache(_activeTrip!);
      }
    } catch (e) {
      debugPrint('Erreur chargement des trajets: $e');
    } finally {
      isLoading = false;
      _buildViewModels();
      _notify();
    }
    if (_disposed) return;
    if (automaticUpdates) {
      _timer = Timer.periodic(const Duration(seconds: 15), (_) => tick());
    }
    // ready signifie « cache visible », sans attendre le réseau.
    unawaited(refreshDepartures(forceRefreshWidgets: false, feedback: false));
  }

  Future<void> _saveTrips() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      AppConstants.tripsStorageKey,
      jsonEncode(_trips.map((t) => t.toJson()).toList()),
    );
    if (_activeTrip == null) {
      await prefs.remove(AppConstants.activeTripIdKey);
    } else {
      await prefs.setString(AppConstants.activeTripIdKey, _activeTrip!.id);
    }
  }

  Future<void> _loadCache(Trip trip) async {
    if (_clearingCache != null) return;
    final generation = _cacheGeneration;
    final results = await Future.wait([
      _realtimeService.getCachedDepartures(
        fromStationId: trip.stationA.id,
        toStationId: trip.stationB.id,
      ),
      _realtimeService.getCachedDepartures(
        fromStationId: trip.stationB.id,
        toStationId: trip.stationA.id,
      ),
    ]);
    if (!_disposed &&
        generation == _cacheGeneration &&
        _trips.any((t) => t.id == trip.id)) {
      _data.putIfAbsent(trip.id, () => TripDepartures(results[0], results[1]));
    }
  }

  /// Regroupe les demandes simultanées pour un même trajet.
  Future<void> _refreshTrip(Trip trip) {
    if (_clearingCache != null) return Future.value();
    if (_requests.containsKey(trip.id)) return _requests[trip.id]!;
    final future = _fetchTrip(trip);
    _requests[trip.id] = future;
    return future;
  }

  Future<void> _fetchTrip(Trip trip) async {
    try {
      final date = _now();
      final results = await Future.wait([
        _realtimeService.getDeparturesWithRealtime(
          fromStationId: trip.stationA.id,
          toStationId: trip.stationB.id,
          datetime: date,
        ),
        _realtimeService.getDeparturesWithRealtime(
          fromStationId: trip.stationB.id,
          toStationId: trip.stationA.id,
          datetime: date,
        ),
      ]);
      if (!_disposed && _trips.any((t) => t.id == trip.id)) {
        _data[trip.id] = TripDepartures(results[0], results[1]);
      }
    } catch (e) {
      debugPrint('Erreur rafraîchissement: $e');
      final previous = _data[trip.id];
      if (previous != null && !_disposed) {
        _data[trip.id] = TripDepartures(
          previous.go.asOffline(),
          previous.back.asOffline(),
        );
      }
    } finally {
      _requests.remove(trip.id);
      if (!_disposed && _activeTrip?.id == trip.id) {
        _buildViewModels();
        _notify();
      }
    }
  }

  Future<void> refreshDepartures({
    bool forceRefreshWidgets = true,
    bool feedback = true,
  }) async {
    final trip = _activeTrip;
    if (_disposed || isLoading || trip == null || _clearingCache != null) {
      return;
    }
    final generation = _cacheGeneration;
    _lastAttempt = _now();
    final request = _refreshTrip(trip);
    _connectionStatus = ConnectionStatus.syncing;
    _notify();
    await request;
    if (_disposed) return;
    await _publishWidgets();
    if (_disposed || generation != _cacheGeneration) return;
    if (feedback &&
        _activeTrip?.id == trip.id &&
        _activeData?.fromNetwork == true) {
      unawaited(HapticFeedback.mediumImpact());
    }
    if (forceRefreshWidgets ||
        _lastOtherTripsRefresh == null ||
        _now().difference(_lastOtherTripsRefresh!) >=
            const Duration(minutes: 5)) {
      _lastOtherTripsRefresh = _now();
      // Les autres favoris ne bloquent pas le rendu du trajet actif.
      for (final other in List<Trip>.of(_trips)) {
        if (_disposed || generation != _cacheGeneration) return;
        if (other.id != trip.id) await _refreshTrip(other);
      }
      if (!_disposed) await _publishWidgets();
    }
  }

  void _buildViewModels() {
    final trip = _activeTrip;
    if (trip == null) {
      _directionGoViewModel = null;
      _directionReturnViewModel = null;
      _swapped = false;
      _connectionStatus = ConnectionStatus.offline;
      return;
    }
    final date = _now();
    _swapped = TripSorter.shouldSwapOrder(
      currentHour: date.hour,
      morningEveningSplitHour: _settingsProvider.morningEveningSplitTime,
      serviceDayStartHour: _settingsProvider.serviceDayStartTime,
      morningDirection: trip.morningDirection,
    );
    final go = DirectionCardViewModel.fromDepartures(
      title: '${trip.stationA.name} → ${trip.stationB.name}',
      departures: departuresGo,
      fromNetwork: _activeData?.go.fromNetwork ?? false,
      failure: _activeData?.go.failure,
      now: date,
      serviceDayStartTime: _settingsProvider.serviceDayStartTime,
    );
    final back = DirectionCardViewModel.fromDepartures(
      title: '${trip.stationB.name} → ${trip.stationA.name}',
      departures: departuresReturn,
      fromNetwork: _activeData?.back.fromNetwork ?? false,
      failure: _activeData?.back.failure,
      now: date,
      serviceDayStartTime: _settingsProvider.serviceDayStartTime,
    );
    _directionGoViewModel = _swapped ? back : go;
    _directionReturnViewModel = _swapped ? go : back;
    _connectionStatus = _requests.containsKey(trip.id)
        ? ConnectionStatus.syncing
        : (_activeData?.fromNetwork == true
              ? ConnectionStatus.online
              : ConnectionStatus.offline);
  }

  void _settingsChanged() {
    if (isLoading || _disposed) return;
    _buildViewModels();
    _notify();
    unawaited(_publishWidgets());
  }

  /// Le temps qui passe actualise le rendu même sans réponse réseau.
  void tick() {
    if (_disposed || !_foreground || isLoading) return;
    _buildViewModels();
    _notify();
    final interval = _activeData?.fromNetwork == true
        ? AppConstants.refreshInterval
        : AppConstants.refreshIntervalOffline;
    if (_lastAttempt == null || _now().difference(_lastAttempt!) >= interval) {
      unawaited(refreshDepartures(forceRefreshWidgets: false, feedback: false));
    }
  }

  void setForeground(bool value) {
    if (_disposed || _foreground == value) return;
    _foreground = value;
    if (value) {
      _buildViewModels();
      _notify();
      unawaited(refreshDepartures(forceRefreshWidgets: false, feedback: false));
    }
  }

  /// Sérialiser les écritures empêche une ancienne publication de finir en dernier.
  Future<void> _publishWidgets({String? removedTripId}) {
    _widgetWrites = _widgetWrites
        .then((_) async {
          if (_disposed) return;
          if (removedTripId != null) {
            await _widgetService.clearWidgetDataForTrip(removedTripId);
          }
          final currentTrips = List<Trip>.of(_trips);
          await _widgetService.updateAllWidgets(
            allTrips: currentTrips,
            dataByTrip: Map.of(_data),
            departuresGoByTrip: {
              for (final t in currentTrips)
                t.id: _data[t.id]?.go.departures ?? [],
            },
            departuresReturnByTrip: {
              for (final t in currentTrips)
                t.id: _data[t.id]?.back.departures ?? [],
            },
            lastUpdatesByTrip: {
              for (final t in currentTrips) t.id: _data[t.id]?.fetchedAt,
            },
            morningEveningSplitHour: _settingsProvider.morningEveningSplitTime,
            serviceDayStartHour: _settingsProvider.serviceDayStartTime,
          );
        })
        .catchError((Object e) {
          debugPrint('Erreur publication widgets: $e');
        });
    return _widgetWrites;
  }

  Future<void> setActiveTrip(Trip trip) async {
    if (_disposed ||
        _activeTrip?.id == trip.id ||
        !_trips.any((t) => t.id == trip.id)) {
      return;
    }
    final selection = ++_selection;
    _activeTrip = trip;
    _buildViewModels();
    _notify();
    await _saveTrips();
    await _loadCache(trip);
    if (_disposed || selection != _selection) return;
    _buildViewModels();
    _notify();
    // Le sélecteur peut se fermer dès que le cache est visible.
    unawaited(refreshDepartures(forceRefreshWidgets: false, feedback: false));
  }

  Future<void> updateActiveTripMorningDirection(
    MorningDirection direction,
  ) async {
    final trip = _activeTrip;
    if (trip == null || trip.morningDirection == direction) return;
    final updated = trip.copyWith(morningDirection: direction);
    _trips[_trips.indexWhere((t) => t.id == trip.id)] = updated;
    _activeTrip = updated;
    _buildViewModels();
    _notify();
    await _saveTrips();
    await _publishWidgets();
  }

  Future<String?> addTrip({
    required Station stationA,
    required Station stationB,
    required MorningDirection morningDirection,
  }) async {
    await ready;
    if (_trips.length >= AppConstants.maxFavoriteTrips) {
      return 'Vous avez atteint le nombre maximum de trajets (${AppConstants.maxFavoriteTrips})';
    }
    if (stationA.id == stationB.id) {
      return 'Les gares de départ et d’arrivée doivent être différentes';
    }
    if (_trips.any(
      (t) =>
          (t.stationA.id == stationA.id && t.stationB.id == stationB.id) ||
          (t.stationA.id == stationB.id && t.stationB.id == stationA.id),
    )) {
      return 'Ce trajet existe déjà';
    }
    final trip = Trip(
      id: 'trip-${const Uuid().v4()}',
      stationA: stationA,
      stationB: stationB,
      morningDirection: morningDirection,
    );
    _trips.add(trip);
    try {
      await setActiveTrip(trip);
      await _publishWidgets();
      return null;
    } catch (e) {
      return 'Impossible d’enregistrer le trajet';
    }
  }

  Future<String?> removeTrip(String tripId) async {
    final index = _trips.indexWhere((t) => t.id == tripId);
    if (index == -1) return 'Trajet introuvable';
    final removed = _trips.removeAt(index);
    _data.remove(tripId);
    if (_activeTrip?.id == tripId) {
      ++_selection;
      _activeTrip = null;
      if (_trips.isNotEmpty) await setActiveTrip(_trips.first);
    }
    await _saveTrips();
    _buildViewModels();
    _notify();
    await _publishWidgets(removedTripId: tripId);
    // Ne pas supprimer un cache en cours d'écriture.
    await _requests[tripId];
    await _storageService.removeDirection(
      removed.stationA.id,
      removed.stationB.id,
    );
    await _storageService.removeDirection(
      removed.stationB.id,
      removed.stationA.id,
    );
    return null;
  }

  Future<void> clearCache() {
    return _clearingCache ??= _clearCache().whenComplete(() {
      _clearingCache = null;
    });
  }

  Future<void> _clearCache() async {
    // Bloquer les nouveaux chargements avant d’attendre ceux déjà en cours.
    _cacheGeneration++;
    await Future.wait(_requests.values.toList());
    await _storageService.clearCache();
    await _apiService.clearTheoreticalCache();
    _data.clear();
    _buildViewModels();
    _notify();
    await _publishWidgets();
  }

  @override
  void dispose() {
    _disposed = true;
    _timer?.cancel();
    _settingsProvider.removeListener(_settingsChanged);
    if (_ownsApi) _apiService.dispose();
    super.dispose();
  }
}
