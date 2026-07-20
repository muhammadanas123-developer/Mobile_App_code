import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/storage/preferences_service.dart';

/// ThemeMode provider used by `main.dart` (and historically imported from here).
final appThemeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  final prefs = ref.watch(preferencesServiceProvider);
  return ThemeModeNotifier(prefs);
});

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  final PreferencesService _prefs;

  ThemeModeNotifier(this._prefs) : super(ThemeMode.light) {
    _init();
  }

  void _init() {
    final mode = _prefs.getThemeMode();
    if (mode == 'dark') {
      state = ThemeMode.dark;
    } else if (mode == 'system') {
      state = ThemeMode.system;
    } else {
      state = ThemeMode.light;
    }
  }

  Future<void> toggleTheme() async {
    if (state == ThemeMode.light) {
      state = ThemeMode.dark;
      await _prefs.setThemeMode('dark');
    } else {
      state = ThemeMode.light;
      await _prefs.setThemeMode('light');
    }
  }
}