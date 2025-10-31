import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeService {
  static const _themeKey = 'theme_mode';
  final SharedPreferences _prefs;

  ThemeService(this._prefs);

  ThemeMode getThemeMode() {
    final value = _prefs.getString(_themeKey);
    return _parseThemeMode(value);
  }

  void setThemeMode(ThemeMode mode) {
    final value = _themeModToString(mode);
    _prefs.setString(_themeKey, value);
  }

  ThemeMode toggle(ThemeMode current) {
    final next = current == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;

    setThemeMode(next);
    return next;
  }

  ThemeMode _parseThemeMode(String? value) {
    switch (value) {
      case 'dark':
        return ThemeMode.dark;
      case 'light':
      default:
        return ThemeMode.light;
    }
  }

  String _themeModToString(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.light:
      default:
        return 'light';
    }
  }
}