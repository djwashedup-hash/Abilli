import 'package:flutter/material.dart';

/// Elegant theme — luxury navy & gold aesthetic.
class ElegantTheme {
  ElegantTheme._();

  static const Color bgPrimary    = Color(0xFF0A1628);
  static const Color bgSecondary  = Color(0xFF0F2040);
  static const Color bgTertiary   = Color(0xFF162952);
  static const Color border       = Color(0xFF1E3A6E);
  static const Color textPrimary  = Color(0xFFE8DCC8);
  static const Color textSecondary= Color(0xFFB8A890);
  static const Color textMuted    = Color(0xFF8A7A62);
  static const Color accent       = Color(0xFFD4AF37);
  static const Color accentLight  = Color(0xFFEDD56A);
  static const Color accentGreen  = Color(0xFF4CAF84);
  static const Color accentRed    = Color(0xFFE05252);

  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: bgPrimary,
      primaryColor: accent,
      colorScheme: const ColorScheme.dark(
        primary: accent,
        secondary: accentGreen,
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
          fontWeight: FontWeight.w600,
          letterSpacing: 1.2,
        ),
      ),
      cardTheme: CardThemeData(
        color: bgSecondary,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
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
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
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
