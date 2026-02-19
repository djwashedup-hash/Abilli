import 'package:flutter/material.dart';

/// Minimalist theme — clean Scandinavian white & gray.
class MinimalistTheme {
  MinimalistTheme._();

  static const Color bgPrimary    = Color(0xFFFAFAFA);
  static const Color bgSecondary  = Color(0xFFFFFFFF);
  static const Color bgTertiary   = Color(0xFFF0F0F0);
  static const Color border       = Color(0xFFE0E0E0);
  static const Color textPrimary  = Color(0xFF212121);
  static const Color textSecondary= Color(0xFF616161);
  static const Color textMuted    = Color(0xFF9E9E9E);
  static const Color accent       = Color(0xFF212121);
  static const Color accentGreen  = Color(0xFF388E3C);
  static const Color accentRed    = Color(0xFFD32F2F);
  static const Color accentBlue   = Color(0xFF1565C0);

  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: bgPrimary,
      primaryColor: accent,
      colorScheme: const ColorScheme.light(
        primary: accent,
        secondary: accentBlue,
        surface: bgSecondary,
        error: accentRed,
        onPrimary: bgSecondary,
        onSecondary: bgSecondary,
        onSurface: textPrimary,
        onError: bgSecondary,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: bgSecondary,
        foregroundColor: textPrimary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.5,
        ),
      ),
      cardTheme: CardThemeData(
        color: bgSecondary,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
          side: const BorderSide(color: border),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: bgSecondary,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: accent, width: 1),
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          textStyle: const TextStyle(fontWeight: FontWeight.w500),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: bgSecondary,
        selectedItemColor: accent,
        unselectedItemColor: textMuted,
        type: BottomNavigationBarType.fixed,
        elevation: 1,
      ),
      dividerTheme: const DividerThemeData(color: border, thickness: 1, space: 1),
      textTheme: const TextTheme(
        bodyLarge:  TextStyle(color: textPrimary, fontSize: 16),
        bodyMedium: TextStyle(color: textPrimary, fontSize: 14),
        bodySmall:  TextStyle(color: textSecondary, fontSize: 12),
        titleLarge: TextStyle(color: textPrimary, fontSize: 16, fontWeight: FontWeight.w500),
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
