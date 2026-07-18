import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/app_settings.dart';

class SettingsRepository {
  SettingsRepository(this._prefs);

  final SharedPreferences _prefs;

  static const _themeModeKey = 'theme_mode';

  Future<AppSettings> loadSettings() async {
    final themeModeString = _prefs.getString(_themeModeKey);

    return AppSettings(themeMode: _themeModeFromString(themeModeString));
  }

  Future<void> saveThemeMode(ThemeMode themeMode) async {
    await _prefs.setString(_themeModeKey, _themeModeToString(themeMode));
  }

  ThemeMode _themeModeFromString(String? value) {
    switch (value) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
      default:
        return ThemeMode.system;
    }
  }

  String _themeModeToString(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
    }
  }
}
