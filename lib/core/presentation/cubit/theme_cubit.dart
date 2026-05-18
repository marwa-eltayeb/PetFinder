import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petfinder/core/theming/theme_service.dart';

class ThemeCubit extends Cubit<ThemeMode> {

  final ThemeService _themeService;
  ThemeCubit(this._themeService) : super(_themeService.getThemeMode());

  void toggleTheme() {
    final newTheme = _themeService.toggle(state);
    emit(newTheme);
  }

  void setTheme(ThemeMode mode) {
    _themeService.setThemeMode(mode);
    emit(mode);
  }

  void loadSavedTheme() {
    final savedTheme = _themeService.getThemeMode();
    emit(savedTheme);
  }
}