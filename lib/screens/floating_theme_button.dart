// lib/screens/floating_theme_button.dart
// Fixed - only 4 themes (removed elegant and retro)

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/theme_provider.dart';

class FloatingThemeButton extends StatelessWidget {
  const FloatingThemeButton({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final isDark = themeProvider.isDarkMode;

    return FloatingActionButton.small(
      onPressed: () => _showThemeMenu(context, themeProvider),
      backgroundColor: isDark ? const Color(0xFF238636) : const Color(0xFF0052CC),
      child: const Icon(Icons.palette, color: Colors.white),
    );
  }

  void _showThemeMenu(BuildContext context, ThemeProvider themeProvider) {
    final isDark = themeProvider.isDarkMode;

    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? const Color(0xFF161B22) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey[700] : Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Quick Theme Switch',
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black87,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // Dark
              _QuickThemeTile(
                name: 'Dark',
                color: const Color(0xFF58A6FF),
                isSelected: themeProvider.currentStyle == AppThemeStyle.dark,
                onTap: () {
                  themeProvider.setTheme(AppThemeStyle.dark);
                  Navigator.pop(context);
                },
                isDark: isDark,
              ),

              // Corporate
              _QuickThemeTile(
                name: 'Corporate',
                color: const Color(0xFF0052CC),
                isSelected: themeProvider.currentStyle == AppThemeStyle.corporate,
                onTap: () {
                  themeProvider.setTheme(AppThemeStyle.corporate);
                  Navigator.pop(context);
                },
                isDark: isDark,
              ),

              // Punk
              _QuickThemeTile(
                name: 'Punk',
                color: const Color(0xFFFFFF00),
                isSelected: themeProvider.currentStyle == AppThemeStyle.punk,
                onTap: () {
                  themeProvider.setTheme(AppThemeStyle.punk);
                  Navigator.pop(context);
                },
                isDark: isDark,
              ),

              // Minimalist
              _QuickThemeTile(
                name: 'Minimalist',
                color: isDark ? Colors.white : Colors.black,
                isSelected: themeProvider.currentStyle == AppThemeStyle.minimalist,
                onTap: () {
                  themeProvider.setTheme(AppThemeStyle.minimalist);
                  Navigator.pop(context);
                },
                isDark: isDark,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickThemeTile extends StatelessWidget {
  final String name;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isDark;

  const _QuickThemeTile({
    required this.name,
    required this.color,
    required this.isSelected,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isDark ? Colors.white24 : Colors.black12,
          ),
        ),
      ),
      title: Text(
        name,
        style: TextStyle(
          color: isDark ? Colors.white : Colors.black87,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      trailing: isSelected
          ? Icon(Icons.check_circle, color: color)
          : null,
    );
  }
}
