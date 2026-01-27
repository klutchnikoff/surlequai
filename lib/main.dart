import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:home_widget/home_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:surlequai/models/departure.dart';
import 'package:surlequai/models/trip.dart';
import 'package:surlequai/screens/home_screen.dart';
import 'package:surlequai/services/api_key_service.dart';
import 'package:surlequai/services/api_service.dart';
import 'package:surlequai/services/realtime_service.dart';
import 'package:surlequai/services/settings_provider.dart';
import 'package:surlequai/services/storage_service.dart';
import 'package:surlequai/services/timetable_service.dart';
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
void backgroundCallback(Uri? uri) async {
  // Indispensable pour utiliser les plugins (SharedPreferences, SQFlite) en background
  WidgetsFlutterBinding.ensureInitialized();

  // Charger les variables d'environnement en arrière-plan aussi
  try {
    await dotenv.load(fileName: '.env');
  } catch (e) {
    debugPrint('[Background] Fichier .env non disponible: $e');
  }

  debugPrint('--- Background Callback Started ---');

  // --- Initialisation des services ---
  final apiKeyService = ApiKeyService();
  final api = ApiService(apiKeyService: apiKeyService);
  await api.init(); // Charge la clé personnalisée si configurée

  final storage = StorageService();
  await storage.init(); 
  
  final timetableService = TimetableService(apiService: api, storageService: storage);
  await timetableService.init();

  final realtimeService = RealtimeService(
    apiService: api, 
    timetableService: timetableService,
    storageService: storage,
  );
  final widgetService = WidgetService();

  debugPrint('--- Services Initialized ---');

  // --- Logique de mise à jour ---
  final prefs = await SharedPreferences.getInstance();
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

  for (final trip in trips) {
    final now = DateTime.now();
    departuresGoByTrip[trip.id] = await realtimeService.getDeparturesWithRealtime(
      fromStationId: trip.stationA.id,
      toStationId: trip.stationB.id,
      datetime: now,
      tripId: trip.id,
    );
    departuresReturnByTrip[trip.id] = await realtimeService.getDeparturesWithRealtime(
      fromStationId: trip.stationB.id,
      toStationId: trip.stationA.id,
      datetime: now,
      tripId: trip.id,
    );
  }
  
  debugPrint('--- Saving data to widgets ---');

  // Appeler la méthode centralisée de WidgetService
  await widgetService.updateAllWidgets(
    allTrips: trips,
    departuresGoByTrip: departuresGoByTrip,
    departuresReturnByTrip: departuresReturnByTrip,
  );
  
  debugPrint('--- Background Callback Finished ---');
}

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Charger les variables d'environnement (.env)
  // Ne bloque pas si le fichier n'existe pas (mode développement)
  try {
    await dotenv.load(fileName: '.env');
    debugPrint('[Main] Fichier .env chargé avec succès');
  } catch (e) {
    debugPrint('[Main] Fichier .env non trouvé ou invalide: $e');
    debugPrint('[Main] L\'app fonctionnera en mode mock (sans données réelles)');
  }

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

  final timetableService = TimetableService(
    apiService: apiService,
    storageService: storageService,
  );
  await timetableService.init();

  final realtimeService = RealtimeService(
    apiService: apiService,
    timetableService: timetableService,
    storageService: storageService,
  );

  runApp(
    MultiProvider(
      providers: [
        // Services (pas de notification de changement, juste des instances partagées)
        Provider<ApiKeyService>.value(value: apiKeyService),
        Provider<ApiService>.value(value: apiService),
        Provider<StorageService>.value(value: storageService),
        Provider<TimetableService>.value(value: timetableService),
        Provider<RealtimeService>.value(value: realtimeService),

        // Providers avec état
        ChangeNotifierProvider(create: (context) => SettingsProvider()),
        ChangeNotifierProxyProvider<SettingsProvider, TripProvider>(
          create: (context) => TripProvider(context.read<SettingsProvider>()),
          update: (context, settings, previous) => previous!..update(),
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
    HomeWidget.widgetClicked.listen(_launchedFromWidget);
  }

  void _launchedFromWidget(Uri? uri) {
    if (uri != null) {
      // Si on utilise des Uris, on peut extraire le tripId
      // final tripId = uri.queryParameters['tripId'];
      // if (tripId != null) _switchToTrip(tripId);
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
  }

  /// Bascule vers le trajet correspondant au tripId
  void _switchToTrip(String tripId) {
    // Petit délai pour s'assurer que le provider est prêt si l'app vient de se lancer
    final tripProvider = context.read<TripProvider>();
    if (tripProvider.isLoading) {
      Future.delayed(const Duration(milliseconds: 500), () => _switchToTrip(tripId));
      return;
    }

    try {
      final trip = tripProvider.trips.firstWhere(
        (t) => t.id == tripId,
        orElse: () => tripProvider.trips.first,
      );
      tripProvider.setActiveTrip(trip);
    } catch (e) {
      // Ignorer si trip introuvable
    }
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
