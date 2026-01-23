import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:surlequai/screens/home_screen.dart';
import 'package:surlequai/services/trip_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => TripProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SurLeQuai',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      darkTheme: ThemeData.dark(useMaterial3: true),
      themeMode: ThemeMode.system, // Use system theme
      home: const HomeScreen(),
    );
  }
}
