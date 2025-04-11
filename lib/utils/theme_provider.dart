import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ThemeMode {
  system,
  light,
  dark,
}

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  static const String _themeModeKey = 'theme_mode';

  ThemeProvider() {
    _loadThemeMode();
  }

  ThemeMode get themeMode => _themeMode;

  bool get isDarkMode {
    if (_themeMode == ThemeMode.system) {
      final brightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;
      return brightness == Brightness.dark;
    }
    return _themeMode == ThemeMode.dark;
  }

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    _saveThemeMode();
    _updateStatusBarColors();
    notifyListeners();
  }

  Future<void> _loadThemeMode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedMode = prefs.getString(_themeModeKey);
      if (savedMode != null) {
        _themeMode = ThemeMode.values.firstWhere(
              (element) => element.toString() == savedMode,
          orElse: () => ThemeMode.system,
        );
      }
      _updateStatusBarColors();
      notifyListeners();
    } catch (e) {
      // En cas d'erreur, utiliser le thème système par défaut
      _themeMode = ThemeMode.system;
    }
  }

  Future<void> _saveThemeMode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_themeModeKey, _themeMode.toString());
    } catch (e) {
      // Ignorer les erreurs de sauvegarde
    }
  }

  void _updateStatusBarColors() {
    bool isDark = isDarkMode;

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
    ));
  }
}