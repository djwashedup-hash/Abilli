import 'package:flutter/material.dart';

/// Corporate theme — professional white & navy.
class CorporateTheme {
  CorporateTheme._();

  static const Color bgPrimary    = Color(0xFFF5F7FA);
  static const Color bgSecondary  = Color(0xFFFFFFFF);
  static const Color bgTertiary   = Color(0xFFEEF1F6);
  static const Color border       = Color(0xFFD1D9E6);
  static const Color textPrimary  = Color(0xFF1A2B4A);
  static const Color textSecondary= Color(0xFF4A5D7A);
  static const Color textMuted    = Color(0xFF7A8EA8);
  static const Color accent       = Color(0xFF003366);
  static const Color accentLight  = Color(0xFF1A5296);
  static const Color accentGreen  = Color(0xFF1A7A4A);
  static const Color accentRed    = Color(0xFFB01C1C);

  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: bgPrimary,
      primaryColor: accent,
      colorScheme: const ColorScheme.light(
        primary: accent,
        secondary: accentGreen,
        surface: bgSecondary,
        error: accentRed,
        onPrimary: bgSecondary,
        onSecondary: bgSecondary,
        onSurface: textPrimary,
        onError: bgSecondary,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: accent,
        foregroundColor: bgSecondary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: bgSecondary,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      cardTheme: CardThemeData(
        color: bgSecondary,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: border),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: bgSecondary,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: accent, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        labelStyle: const TextStyle(color: textSecondary),
        hintStyle: const TextStyle(color: textMuted),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accent,
          foregroundColor: bgSecondary,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: bgSecondary,
        selectedItemColor: accent,
        unselectedItemColor: textMuted,
        type: BottomNavigationBarType.fixed,
        elevation: 2,
      ),
      dividerTheme: const DividerThemeData(color: border, thickness: 1, space: 1),
      textTheme: const TextTheme(
        bodyLarge:  TextStyle(color: textPrimary, fontSize: 16),
        bodyMedium: TextStyle(color: textPrimary, fontSize: 14),
        bodySmall:  TextStyle(color: textSecondary, fontSize: 12),
        titleLarge: TextStyle(color: textPrimary, fontSize: 16, fontWeight: FontWeight.w600),
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
