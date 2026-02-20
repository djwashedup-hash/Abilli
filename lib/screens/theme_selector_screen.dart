// lib/screens/theme_selector_screen.dart
// Fixed - only 4 themes (removed elegant and retro)

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/theme_provider.dart';

class ThemeSelectorScreen extends StatelessWidget {
  const ThemeSelectorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final isDark = themeProvider.isDarkMode;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0D1117) : Colors.white,
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF161B22) : Colors.grey[100],
        elevation: 0,
        title: Text(
          'Choose Theme',
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDark ? Colors.white : Colors.black87,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Select Your Style',
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black87,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Personalize your Abilli experience',
            style: TextStyle(
              color: isDark ? Colors.grey[400] : Colors.grey[600],
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 24),

          // Dark Theme (GitHub-inspired)
          _ThemeCard(
            name: 'Dark',
            description: 'Original GitHub-inspired dark theme with blue accents',
            colors: const [Color(0xFF0D1117), Color(0xFF58A6FF)],
            isSelected: themeProvider.currentStyle == AppThemeStyle.dark,
            onTap: () => themeProvider.setTheme(AppThemeStyle.dark),
            isDark: isDark,
          ),

          const SizedBox(height: 16),

          // Corporate Theme
          _ThemeCard(
            name: 'Corporate',
            description: 'Professional blue-grey theme for business use',
            colors: const [Color(0xFFF8F9FA), Color(0xFF0052CC)],
            isSelected: themeProvider.currentStyle == AppThemeStyle.corporate,
            onTap: () => themeProvider.setTheme(AppThemeStyle.corporate),
            isDark: isDark,
          ),

          const SizedBox(height: 16),

          // Punk Theme
          _ThemeCard(
            name: 'Punk',
            description: 'Bold neon yellow on black with an anarchist edge',
            colors: const [Color(0xFF1a1a1a), Color(0xFFFFFF00)],
            isSelected: themeProvider.currentStyle == AppThemeStyle.punk,
            onTap: () => themeProvider.setTheme(AppThemeStyle.punk),
            isDark: isDark,
          ),

          const SizedBox(height: 16),

          // Minimalist Theme
          _ThemeCard(
            name: 'Minimalist',
            description: 'Clean black and white with subtle grey accents',
            colors: const [Color(0xFFFFFFFF), Color(0xFF000000)],
            isSelected: themeProvider.currentStyle == AppThemeStyle.minimalist,
            onTap: () => themeProvider.setTheme(AppThemeStyle.minimalist),
            isDark: isDark,
          ),
        ],
      ),
    );
  }
}

class _ThemeCard extends StatelessWidget {
  final String name;
  final String description;
  final List<Color> colors;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isDark;

  const _ThemeCard({
    required this.name,
    required this.description,
    required this.colors,
    required this.isSelected,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF161B22) : Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? colors[1]
                : isDark
                    ? const Color(0xFF30363D)
                    : Colors.grey[300]!,
            width: isSelected ? 3 : 1,
          ),
        ),
        child: Row(
          children: [
            // Color preview
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: colors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isDark ? Colors.white24 : Colors.black12,
                ),
              ),
            ),
            const SizedBox(width: 16),

            // Text content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black87,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            // Selection indicator
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: colors[1],
                size: 28,
              ),
          ],
        ),
      ),
    );
  }
}
