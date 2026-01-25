import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:home_widget/home_widget.dart';
import 'package:provider/provider.dart';
import 'package:surlequai/screens/home_screen.dart';
import 'package:surlequai/services/settings_provider.dart';
import 'package:surlequai/services/trip_provider.dart';
import 'package:surlequai/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Configure le widget callback
  await HomeWidget.setAppGroupId('group.com.surlequai.app');

  runApp(
    MultiProvider(
      providers: [
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
    _setupWidgetTapHandler();
  }

  /// Configure le handler pour basculer vers un trajet quand on tap sur un widget
  void _setupWidgetTapHandler() {
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
    // Récupérer le TripProvider depuis le context
    final tripProvider = context.read<TripProvider>();

    // Trouver le trajet correspondant au tripId
    final trip = tripProvider.trips.firstWhere(
      (t) => t.id == tripId,
      orElse: () => tripProvider.trips.first,
    );

    // Basculer vers ce trajet
    tripProvider.setActiveTrip(trip);
  }

  @override
  Widget build(BuildContext context) {
    // Using a Consumer to get a BuildContext that is a descendant of the provider
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
