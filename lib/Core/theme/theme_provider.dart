import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  bool _isDarkMode = true;
  bool _useSystemTheme = true; // Auto-detect system theme by default
  
  bool get isDarkMode => _isDarkMode;
  bool get useSystemTheme => _useSystemTheme;

  ThemeProvider() {
    _loadThemePreference();
  }

  // Load theme preference from storage
  Future<void> _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    _useSystemTheme = prefs.getBool('useSystemTheme') ?? true;
    
    if (_useSystemTheme) {
      // Use system theme
      _isDarkMode = _getSystemBrightness() == Brightness.dark;
    } else {
      // Use saved preference
      _isDarkMode = prefs.getBool('isDarkMode') ?? true;
    }
    notifyListeners();
  }

  // Get system brightness
  Brightness _getSystemBrightness() {
    return SchedulerBinding.instance.platformDispatcher.platformBrightness;
  }

  // Update theme based on system
  void updateSystemTheme(Brightness brightness) {
    if (_useSystemTheme) {
      _isDarkMode = brightness == Brightness.dark;
      notifyListeners();
    }
  }

  // Toggle between dark and light mode (disables system theme)
  Future<void> toggleTheme() async {
    _useSystemTheme = false;
    _isDarkMode = !_isDarkMode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('useSystemTheme', false);
    await prefs.setBool('isDarkMode', _isDarkMode);
    notifyListeners();
  }

  // Enable system theme
  Future<void> enableSystemTheme() async {
    _useSystemTheme = true;
    _isDarkMode = _getSystemBrightness() == Brightness.dark;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('useSystemTheme', true);
    notifyListeners();
  }

  // Set specific theme (disables system theme)
  Future<void> setTheme(bool isDark) async {
    _useSystemTheme = false;
    _isDarkMode = isDark;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('useSystemTheme', false);
    await prefs.setBool('isDarkMode', _isDarkMode);
    notifyListeners();
  }
}
