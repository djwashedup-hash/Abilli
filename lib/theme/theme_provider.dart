import 'package:flutter/material.dart';
import 'app_theme.dart';
import 'corporate_theme.dart';
import 'punk_theme.dart';
import 'minimalist_theme.dart';

enum AppThemeStyle {
  dark,      // Original GitHub dark
  corporate, // White & Navy
  punk,      // Black & Neon
  minimalist,// White & Gray
}

class ThemeProvider extends ChangeNotifier {
  AppThemeStyle _currentStyle = AppThemeStyle.dark;
  
  AppThemeStyle get currentStyle => _currentStyle;
  
  bool get isDarkMode => _currentStyle == AppThemeStyle.dark;
  
  Color get accentColor {
    switch (_currentStyle) {
      case AppThemeStyle.corporate:
        return const Color(0xFF001F3F);
      case AppThemeStyle.punk:
        return const Color(0xFFFF1493);
      case AppThemeStyle.minimalist:
        return const Color(0xFF424242);
      case AppThemeStyle.dark:
        return const Color(0xFF0D47A1);
    }
  }
  
  ThemeData get themeData {
    switch (_currentStyle) {
      case AppThemeStyle.corporate:
        return CorporateTheme.theme;
      case AppThemeStyle.punk:
        return PunkTheme.theme;
      case AppThemeStyle.minimalist:
        return MinimalistTheme.theme;
      case AppThemeStyle.dark:
        return AppTheme.darkTheme;
    }
  }
  
  String get currentThemeName {
    switch (_currentStyle) {
      case AppThemeStyle.corporate:
        return 'Corporate';
      case AppThemeStyle.punk:
        return 'Punk';
      case AppThemeStyle.minimalist:
        return 'Minimalist';
      case AppThemeStyle.dark:
        return 'Dark';
    }
  }
  
  void setTheme(AppThemeStyle style) {
    _currentStyle = style;
    notifyListeners();
  }
  
  void nextTheme() {
    const values = AppThemeStyle.values;
    final nextIndex = (values.indexOf(_currentStyle) + 1) % values.length;
    _currentStyle = values[nextIndex];
    notifyListeners();
  }
}
