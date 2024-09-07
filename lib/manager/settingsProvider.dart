import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  static const _darkModeKey = 'darkMode';
  bool _isDarkMode = false;

  SettingsProvider() {
    _loadPreferences();
  }

  bool get isDarkMode => _isDarkMode;

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool(_darkModeKey) ?? false;
    notifyListeners();
  }

  Future<void> toggleDarkMode(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = value;
    await prefs.setBool(_darkModeKey, _isDarkMode);
    notifyListeners();
  }
}
