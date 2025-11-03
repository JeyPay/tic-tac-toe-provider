import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

/// SHA512 of "PayServices" + underscore
const String _storageKey = "TicTacToe";

/// {@template preferences}
/// Contains all app preferences helper methods.
/// {@endtemplate}
class AppSharedPreferences {
  late SharedPreferences prefs;

  /// Initialize app Globals.preferences.
  Future<void> init({SharedPreferences? customSharedPreferences}) async {
    prefs = customSharedPreferences ?? await SharedPreferences.getInstance();
  }

  /// List all the keys available in the app Globals.preferences.
  Future<List<String>> getKeys() async {
    List<String> keys = prefs.getKeys().toList();
    return keys;
  }

  /// Clear all app Globals.preferences.
  Future<bool> clearAll() async {
    return await prefs.clear();
  }

  /// Set a string value to a given key.
  Future<bool> setString(String key, String? value) async {
    if (value == null) {
      return await prefs.remove(_storageKey + key);
    }
    return await prefs.setString(_storageKey + key, value);
  }

  /// Get a string stored in the preferences to a given key.
  String? getString(String key, {String? defaultValue}) {
    String? value = prefs.getString(_storageKey + key);
    if (value != null) {
      return value;
    } else {
      return defaultValue;
    }
  }

  Future<bool> setBool(String key, bool? value) async {
    if (value == null) {
      return await prefs.remove(_storageKey + key);
    }
    return await prefs.setBool(_storageKey + key, value);
  }

  bool? getBool(String key, {bool? defaultValue}) => prefs.getBool(_storageKey + key) ?? defaultValue;

  Future<bool> setInt(String key, int? value) async {
    if (value == null) {
      return await prefs.remove(_storageKey + key);
    }
    return await prefs.setInt(_storageKey + key, value);
  }

  int? getInt(String key, {int? defaultValue}) => prefs.getInt(_storageKey + key) ?? defaultValue;

  /// {@template Globals.preferences.ThemeMode}
  /// ThemeMode to use for the application (ThemeMode.light, ThemeMode.dark, ThemeMode.system)
  /// {@endtemplate}
  Future<bool> setThemeMode(String value) async {
    return await setString("ThemeMode", value);
  }

  /// {@macro Globals.preferences.ThemeMode}
  String getThemeMode() => getString("ThemeMode", defaultValue: "ThemeMode.system")!;

  ///
  /// Singleton Factory
  ///
  static final AppSharedPreferences _preferences = AppSharedPreferences._internal();
  factory AppSharedPreferences() {
    return _preferences;
  }
  AppSharedPreferences._internal();
}

final AppSharedPreferences preferences = AppSharedPreferences();
