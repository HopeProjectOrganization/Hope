import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  void setThemeModeProvider(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }

  ThemeMode get getCurrentTheme => _themeMode;

  bool get isDarkTheme => _themeMode == ThemeMode.dark;

  bool isDark() {
    if (_themeMode == ThemeMode.system) {
      final brightness =
          WidgetsBinding.instance.platformDispatcher.platformBrightness;
      return brightness == Brightness.dark;
    }
    return _themeMode == ThemeMode.dark;
  }
}