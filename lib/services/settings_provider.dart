import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:surlequai/models/settings.dart';

class SettingsProvider with ChangeNotifier {
  // Keys
  static const String _themeModeKey = 'themeMode';
  static const String _splitTimeKey = 'splitTime';
  static const String _dayStartTimeKey = 'dayStartTime';

  late SharedPreferences _prefs;

  // State
  late AppThemeMode _themeMode;
  late int _morningEveningSplitTime; // Hour of the day (0-23)
  late int _serviceDayStartTime; // Hour of the day (0-23)

  // Getters
  AppThemeMode get themeMode => _themeMode;
  int get morningEveningSplitTime => _morningEveningSplitTime;
  int get serviceDayStartTime => _serviceDayStartTime;

  SettingsProvider() {
    // Default values
    _themeMode = AppThemeMode.system;
    _morningEveningSplitTime = 12; // 12 PM
    _serviceDayStartTime = 4; // 4 AM
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    _prefs = await SharedPreferences.getInstance();

    // Load theme
    final themeIndex =
        _prefs.getInt(_themeModeKey) ?? AppThemeMode.system.index;
    _themeMode = AppThemeMode.values[themeIndex];

    // Load split time
    _morningEveningSplitTime = _prefs.getInt(_splitTimeKey) ?? 12;

    // Load service day start time
    _serviceDayStartTime = _prefs.getInt(_dayStartTimeKey) ?? 4;

    notifyListeners();
  }

  Future<void> setThemeMode(AppThemeMode mode) async {
    if (_themeMode == mode) return;
    _themeMode = mode;
    await _prefs.setInt(_themeModeKey, mode.index);
    notifyListeners();
  }

  Future<void> setMorningEveningSplitTime(int hour) async {
    if (_morningEveningSplitTime == hour) return;
    _morningEveningSplitTime = hour;
    await _prefs.setInt(_splitTimeKey, hour);
    notifyListeners();
  }

  Future<void> setServiceDayStartTime(int hour) async {
    if (_serviceDayStartTime == hour) return;
    _serviceDayStartTime = hour;
    await _prefs.setInt(_dayStartTimeKey, hour);
    notifyListeners();
  }

  ThemeMode get currentThemeMode {
    switch (_themeMode) {
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
      case AppThemeMode.system:
        return ThemeMode.system;
    }
  }
}
