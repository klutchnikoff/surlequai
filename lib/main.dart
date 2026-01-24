import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:surlequai/screens/home_screen.dart';
import 'package:surlequai/services/settings_provider.dart';
import 'package:surlequai/services/trip_provider.dart';

void main() {
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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Using a Consumer to get a BuildContext that is a descendant of the provider
    return Consumer<SettingsProvider>(
      builder: (context, settingsProvider, child) {
        return MaterialApp(
          title: 'SurLeQuai',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
            useMaterial3: true,
          ),
          darkTheme: ThemeData.dark(useMaterial3: true),
          themeMode: settingsProvider.currentThemeMode, // Use theme from provider
          home: const HomeScreen(),
        );
      },
    );
  }
}
