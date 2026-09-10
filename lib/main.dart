import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:surlequai/models/transport_preferences.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:home_widget/home_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:surlequai/models/departure.dart';
import 'package:surlequai/models/departures_result.dart';
import 'package:surlequai/models/trip.dart';
import 'package:surlequai/screens/home_screen.dart';
import 'package:surlequai/services/api_key_service.dart';
import 'package:surlequai/services/api_service.dart';
import 'package:surlequai/services/realtime_service.dart';
import 'package:surlequai/services/settings_provider.dart';
import 'package:surlequai/services/storage_service.dart';
import 'package:surlequai/services/trip_provider.dart';
import 'package:surlequai/services/widget_service.dart';
import 'package:surlequai/theme/app_theme.dart';
import 'package:surlequai/utils/constants.dart';

/// Vérifie si on est sur une plateforme mobile (iOS/Android)
bool get isMobilePlatform {
  if (kIsWeb) return false;
  return Platform.isIOS || Platform.isAndroid;
}

/// Callback pour les mises à jour en arrière-plan du widget
@pragma('vm:entry-point')
Future<void> backgroundCallback(Uri? uri) async {
  // Indispensable pour utiliser les plugins (SharedPreferences, SQFlite) en background
  WidgetsFlutterBinding.ensureInitialized();

  debugPrint('--- Background Callback Started ---');

  // --- Initialisation des services ---
  final apiKeyService = ApiKeyService();
  final api = ApiService(apiKeyService: apiKeyService);
  final storage = StorageService();

  final realtimeService = RealtimeService(
    apiService: api,
    storageService: storage,
  );
  final widgetService = WidgetService();

  try {
    await api.init();
    await storage.init();
    // --- Logique de mise à jour ---
    final prefs = await SharedPreferences.getInstance();
    await prefs.reload();
    final transport = TransportPreferences.read(prefs);
    final tripsJson = prefs.getString(AppConstants.tripsStorageKey);

    List<Trip> trips;
    if (tripsJson != null) {
      final List<dynamic> tripsData = jsonDecode(tripsJson);
      trips = tripsData.map((data) => Trip.fromJson(data)).toList();
    } else {
      trips = [];
    }

    if (trips.isEmpty) {
      debugPrint('--- No trips found, stopping ---');
      return;
    }

    debugPrint('--- Updating ${trips.length} trips ---');

    // Préparer les données pour updateAllWidgets
    final departuresGoByTrip = <String, List<Departure>>{};
    final departuresReturnByTrip = <String, List<Departure>>{};

    final lastUpdates = <String, DateTime?>{};
    final dataByTrip = <String, TripDepartures>{};
    for (final trip in trips) {
      final now = DateTime.now();
      final results = await Future.wait([
        realtimeService.getDeparturesWithRealtime(
          fromStationId: trip.stationA.id,
          toStationId: trip.stationB.id,
          datetime: now,
          transport: transport,
        ),
        realtimeService.getDeparturesWithRealtime(
          fromStationId: trip.stationB.id,
          toStationId: trip.stationA.id,
          datetime: now,
          transport: transport,
        ),
      ]);
      final go = results[0];
      final back = results[1];
      departuresGoByTrip[trip.id] = go.departures;
      departuresReturnByTrip[trip.id] = back.departures;
      dataByTrip[trip.id] = TripDepartures(go, back);
      lastUpdates[trip.id] = dataByTrip[trip.id]!.fetchedAt;
    }

    debugPrint('--- Saving data to widgets ---');

    // L'application a pu supprimer ou modifier un trajet pendant le réseau.
    await prefs.reload();
    if (prefs.getString(AppConstants.tripsStorageKey) != tripsJson ||
        TransportPreferences.read(prefs).cacheKey != transport.cacheKey) {
      return;
    }

    // Charger les préférences utilisateur pour l'ordre matin/soir
    final morningEveningSplitHour =
        prefs.getInt(AppConstants.splitTimeKey) ??
        AppConstants.defaultMorningEveningSplitHour;
    final serviceDayStartHour =
        prefs.getInt(AppConstants.dayStartTimeKey) ??
        AppConstants.defaultServiceDayStartHour;

    // Appeler la méthode centralisée de WidgetService
    await widgetService.updateAllWidgets(
      allTrips: trips,
      dataByTrip: dataByTrip,
      lastUpdatesByTrip: lastUpdates,
      departuresGoByTrip: departuresGoByTrip,
      departuresReturnByTrip: departuresReturnByTrip,
      morningEveningSplitHour: morningEveningSplitHour,
      serviceDayStartHour: serviceDayStartHour,
    );
  } catch (e) {
    debugPrint('Erreur actualisation widgets: $e');
  } finally {
    api.dispose();
  }
}

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Configuration des widgets uniquement sur iOS/Android
  if (isMobilePlatform) {
    await HomeWidget.setAppGroupId('group.com.surlequai.app');
    await HomeWidget.registerInteractivityCallback(backgroundCallback);
  }

  // Initialisation des services (singletons)
  final apiKeyService = ApiKeyService();
  final apiService = ApiService(apiKeyService: apiKeyService);
  await apiService.init(); // Charge la clé personnalisée si configurée

  final storageService = StorageService();
  await storageService.init();

  final realtimeService = RealtimeService(
    apiService: apiService,
    storageService: storageService,
  );

  runApp(
    MultiProvider(
      providers: [
        // Services (pas de notification de changement, juste des instances partagées)
        Provider<ApiKeyService>.value(value: apiKeyService),
        Provider<ApiService>.value(value: apiService),
        Provider<StorageService>.value(value: storageService),
        Provider<RealtimeService>.value(value: realtimeService),

        // Providers avec état
        ChangeNotifierProvider(create: (context) => SettingsProvider()),
        ChangeNotifierProvider(
          create: (context) => TripProvider(
            context.read<SettingsProvider>(),
            apiService: context.read<ApiService>(),
            storageService: context.read<StorageService>(),
            realtimeService: context.read<RealtimeService>(),
          ),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static const platform = MethodChannel('com.surlequai.app/widget');
  StreamSubscription<Uri?>? _widgetClicks;

  @override
  void initState() {
    super.initState();
    _handleWidgetLaunch();
    // On retire le splash screen après le premier rendu
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FlutterNativeSplash.remove();
    });
  }

  /// Gère le cas où l'app est lancée depuis un tap sur un widget
  void _handleWidgetLaunch() {
    if (!isMobilePlatform) return;
    HomeWidget.initiallyLaunchedFromHomeWidget().then(_launchedFromWidget);
    _widgetClicks = HomeWidget.widgetClicked.listen(_launchedFromWidget);
  }

  void _launchedFromWidget(Uri? uri) {
    if (uri != null) {
      final tripId = uri.queryParameters['tripId'];
      if (tripId != null) unawaited(_switchToTrip(tripId));
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _setupWidgetTapHandler();
  }

  /// Configure le handler pour basculer vers un trajet quand on tap sur un widget
  void _setupWidgetTapHandler() {
    if (!isMobilePlatform) return;
    platform.setMethodCallHandler((call) async {
      if (call.method == 'switchToTrip') {
        final tripId = call.arguments as String?;
        if (tripId != null) {
          _switchToTrip(tripId);
        }
      }
    });
    platform
        .invokeMethod<String>('takeInitialTrip')
        .then((id) {
          if (mounted && id != null) unawaited(_switchToTrip(id));
        })
        .catchError((Object _) {});
  }

  /// Bascule vers le trajet correspondant au tripId
  Future<void> _switchToTrip(String tripId) async {
    if (!mounted) return;
    final provider = context.read<TripProvider>();
    await provider.ready;
    if (!mounted) return;
    for (final trip in provider.trips) {
      if (trip.id == tripId) {
        await provider.setActiveTrip(trip);
        return;
      }
    }
  }

  @override
  void dispose() {
    _widgetClicks?.cancel();
    if (isMobilePlatform) platform.setMethodCallHandler(null);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settingsProvider, child) {
        return MaterialApp(
          title: 'SurLeQuai',
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          themeMode: settingsProvider.currentThemeMode,
          home: const HomeScreen(),
        );
      },
    );
  }
}
