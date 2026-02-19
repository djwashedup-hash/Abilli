import 'package:flutter/material.dart';

/// Retro theme — 80s synthwave purple & neon.
class RetroTheme {
  RetroTheme._();

  static const Color bgPrimary    = Color(0xFF1A0A2E);
  static const Color bgSecondary  = Color(0xFF2D1B4E);
  static const Color bgTertiary   = Color(0xFF3D2560);
  static const Color border       = Color(0xFF5A3A8A);
  static const Color textPrimary  = Color(0xFFE8D5FF);
  static const Color textSecondary= Color(0xFFB09ED0);
  static const Color textMuted    = Color(0xFF7A6A9A);
  static const Color accent       = Color(0xFFFF00FF);
  static const Color accentCyan   = Color(0xFF00FFFF);
  static const Color accentGreen  = Color(0xFF00FF88);
  static const Color accentRed    = Color(0xFFFF3355);
  static const Color accentYellow = Color(0xFFFFFF00);

  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: bgPrimary,
      primaryColor: accent,
      colorScheme: const ColorScheme.dark(
        primary: accent,
        secondary: accentCyan,
        surface: bgSecondary,
        error: accentRed,
        onPrimary: bgPrimary,
        onSecondary: bgPrimary,
        onSurface: textPrimary,
        onError: bgPrimary,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: bgSecondary,
        foregroundColor: textPrimary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: accent,
          fontSize: 18,
          fontWeight: FontWeight.w700,
          letterSpacing: 2,
        ),
      ),
      cardTheme: CardThemeData(
        color: bgSecondary,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: border),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: bgTertiary,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: accent, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        labelStyle: const TextStyle(color: textSecondary),
        hintStyle: const TextStyle(color: textMuted),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accent,
          foregroundColor: bgPrimary,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: const TextStyle(fontWeight: FontWeight.w700, letterSpacing: 1),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: bgSecondary,
        selectedItemColor: accent,
        unselectedItemColor: textMuted,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      dividerTheme: const DividerThemeData(color: border, thickness: 1, space: 1),
      textTheme: const TextTheme(
        bodyLarge:  TextStyle(color: textPrimary, fontSize: 16),
        bodyMedium: TextStyle(color: textPrimary, fontSize: 14),
        bodySmall:  TextStyle(color: textSecondary, fontSize: 12),
        titleLarge: TextStyle(color: textPrimary, fontSize: 16, fontWeight: FontWeight.w700),
        labelSmall: TextStyle(color: textMuted, fontSize: 10),
      ),
    );
  }

  static const Color bgPrimaryColor     = bgPrimary;
  static const Color bgSecondaryColor   = bgSecondary;
  static const Color accentColor        = accent;
  static const Color accentGreenColor   = accentGreen;
  static const Color accentRedColor     = accentRed;
  static const Color textPrimaryColor   = textPrimary;
  static const Color textSecondaryColor = textSecondary;
  static const Color textMutedColor     = textMuted;
  static const Color borderColor        = border;
}
