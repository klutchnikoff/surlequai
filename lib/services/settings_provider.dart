import 'package:surlequai/models/transport_preferences.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:surlequai/models/settings.dart';
import 'package:surlequai/utils/constants.dart';

class SettingsProvider with ChangeNotifier {
  late SharedPreferences _prefs;
  late final Future<void> ready;
  bool _disposed = false;

  TransportPreferences _transport = const TransportPreferences();
  TransportPreferences get transport => _transport;

  Future<void> setTransport({bool? includeTgv, bool? includeCoach}) async {
    await ready;
    final next = TransportPreferences(
      includeTgv: includeTgv ?? _transport.includeTgv,
      includeCoach: includeCoach ?? _transport.includeCoach,
    );
    if (next.cacheKey == _transport.cacheKey) return;
    _transport = next;
    await _prefs.setString(TransportPreferences.storageKey, next.cacheKey);
    if (!_disposed) notifyListeners();
  }

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
    _morningEveningSplitTime = AppConstants.defaultMorningEveningSplitHour;
    _serviceDayStartTime = AppConstants.defaultServiceDayStartHour;
    ready = _loadSettings();
  }

  Future<void> _loadSettings() async {
    _prefs = await SharedPreferences.getInstance();

    _transport = TransportPreferences.read(_prefs);

    // Load theme
    final themeIndex =
        _prefs.getInt(AppConstants.themeModeKey) ?? AppThemeMode.system.index;
    _themeMode = themeIndex >= 0 && themeIndex < AppThemeMode.values.length
        ? AppThemeMode.values[themeIndex]
        : AppThemeMode.system;

    // Load split time
    _morningEveningSplitTime =
        _prefs.getInt(AppConstants.splitTimeKey) ??
        AppConstants.defaultMorningEveningSplitHour;

    // Load service day start time
    _serviceDayStartTime =
        _prefs.getInt(AppConstants.dayStartTimeKey) ??
        AppConstants.defaultServiceDayStartHour;

    if (!_disposed) notifyListeners();
  }

  Future<void> setThemeMode(AppThemeMode mode) async {
    await ready;
    if (_themeMode == mode) return;
    _themeMode = mode;
    await _prefs.setInt(AppConstants.themeModeKey, mode.index);
    if (!_disposed) notifyListeners();
  }

  Future<void> setMorningEveningSplitTime(int hour) async {
    await ready;
    if (hour < 0 || hour > 23) throw ArgumentError.value(hour);
    if (_morningEveningSplitTime == hour) return;
    _morningEveningSplitTime = hour;
    await _prefs.setInt(AppConstants.splitTimeKey, hour);
    if (!_disposed) notifyListeners();
  }

  Future<void> setServiceDayStartTime(int hour) async {
    await ready;
    if (hour < 0 || hour > 23) throw ArgumentError.value(hour);
    if (_serviceDayStartTime == hour) return;
    _serviceDayStartTime = hour;
    await _prefs.setInt(AppConstants.dayStartTimeKey, hour);
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
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
