import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider for SharedPreferences instance, overridden in main.dart.
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences has not been initialized');
});

/// Provider for PreferencesService.
final preferencesServiceProvider = Provider<PreferencesService>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return PreferencesService(prefs);
});

/// PreferencesService manages non-sensitive local storage like user role, theme mode, and preferences.
class PreferencesService {
  final SharedPreferences _prefs;

  PreferencesService(this._prefs);

  static const String _userRoleKey = 'user_role';
  static const String _themeModeKey = 'theme_mode';
  static const String _firstTimeKey = 'first_time';

  /// Save selected user role ('customer' or 'owner')
  Future<void> setUserRole(String role) async {
    await _prefs.setString(_userRoleKey, role);
  }

  /// Get selected user role (defaults to 'customer')
  String getUserRole() {
    return _prefs.getString(_userRoleKey) ?? 'customer';
  }

  /// Save active theme mode ('light', 'dark', 'system')
  Future<void> setThemeMode(String mode) async {
    await _prefs.setString(_themeModeKey, mode);
  }

  /// Get active theme mode (defaults to 'light' since Lumiere brand matches Light theme screens well)
  String getThemeMode() {
    return _prefs.getString(_themeModeKey) ?? 'light';
  }

  /// Check if this is the app's first launch
  bool isFirstTime() {
    return _prefs.getBool(_firstTimeKey) ?? true;
  }

  Future<void> setFirstTime(bool value) async {
    await _prefs.setBool(_firstTimeKey, value);
  }

  /// Clear preferences on logout
  Future<void> clearPreferences() async {
    await _prefs.remove(_userRoleKey);
  }
}