import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/theme_provider.dart';
import '../screens/theme_selector_screen.dart';

/// Floating action button for quick theme switching.
/// 
/// Shows the current theme color and opens theme selector on tap.
/// Can be placed in any screen for easy access.
class FloatingThemeButton extends StatelessWidget {
  final bool mini;
  final EdgeInsets margin;
  
  const FloatingThemeButton({
    super.key,
    this.mini = true,
    this.margin = const EdgeInsets.only(right: 16, bottom: 80),
  });
  
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        // Get accent color based on current theme
        final accentColor = _getThemeAccentColor(themeProvider.currentStyle);
        
        return Container(
          margin: margin,
          child: FloatingActionButton(
            mini: mini,
            onPressed: () {
              _showThemePicker(context);
            },
            backgroundColor: accentColor,
            foregroundColor: Colors.white,
            elevation: 4,
            child: const Icon(Icons.palette),
          ),
        );
      },
    );
  }
  
  Color _getThemeAccentColor(AppThemeStyle style) {
    switch (style) {
      case AppThemeStyle.elegant:
        return const Color(0xFFD4AF37); // Gold
      case AppThemeStyle.corporate:
        return const Color(0xFF003366); // Navy
      case AppThemeStyle.punk:
        return const Color(0xFFFF006E); // Neon pink
      case AppThemeStyle.minimalist:
        return const Color(0xFF212121); // Dark gray
      case AppThemeStyle.retro:
        return const Color(0xFFFF00FF); // Neon magenta
      case AppThemeStyle.dark:
      default:
        return const Color(0xFF58A6FF); // GitHub blue
    }
  }
  
  void _showThemePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const ThemePickerSheet(),
    );
  }
}

/// Quick theme picker bottom sheet.
class ThemePickerSheet extends StatelessWidget {
  const ThemePickerSheet({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // Header
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                const Icon(Icons.palette_outlined),
                const SizedBox(width: 12),
                const Text(
                  'Quick Theme Switch',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ThemeSelectorScreen(),
                      ),
                    );
                  },
                  child: const Text('More'),
                ),
              ],
            ),
          ),
          
          // Theme grid
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    _ThemeQuickButton(
                      name: 'Dark',
                      color: const Color(0xFF58A6FF),
                      bgColor: const Color(0xFF0D1117),
                      isSelected: themeProvider.currentStyle == AppThemeStyle.dark,
                      onTap: () {
                        themeProvider.setTheme(AppThemeStyle.dark);
                        Navigator.pop(context);
                      },
                    ),
                    _ThemeQuickButton(
                      name: 'Elegant',
                      color: const Color(0xFFD4AF37),
                      bgColor: const Color(0xFF0A1628),
                      isSelected: themeProvider.currentStyle == AppThemeStyle.elegant,
                      onTap: () {
                        themeProvider.setTheme(AppThemeStyle.elegant);
                        Navigator.pop(context);
                      },
                    ),
                    _ThemeQuickButton(
                      name: 'Corp',
                      color: const Color(0xFF003366),
                      bgColor: const Color(0xFFFFFFFF),
                      isSelected: themeProvider.currentStyle == AppThemeStyle.corporate,
                      onTap: () {
                        themeProvider.setTheme(AppThemeStyle.corporate);
                        Navigator.pop(context);
                      },
                    ),
                    _ThemeQuickButton(
                      name: 'Punk',
                      color: const Color(0xFFFF006E),
                      bgColor: const Color(0xFF0A0A0A),
                      isSelected: themeProvider.currentStyle == AppThemeStyle.punk,
                      onTap: () {
                        themeProvider.setTheme(AppThemeStyle.punk);
                        Navigator.pop(context);
                      },
                    ),
                    _ThemeQuickButton(
                      name: 'Minimal',
                      color: const Color(0xFF212121),
                      bgColor: const Color(0xFFFFFFFF),
                      isSelected: themeProvider.currentStyle == AppThemeStyle.minimalist,
                      onTap: () {
                        themeProvider.setTheme(AppThemeStyle.minimalist);
                        Navigator.pop(context);
                      },
                    ),
                    _ThemeQuickButton(
                      name: 'Retro',
                      color: const Color(0xFFFF00FF),
                      bgColor: const Color(0xFF1A0A2E),
                      isSelected: themeProvider.currentStyle == AppThemeStyle.retro,
                      onTap: () {
                        themeProvider.setTheme(AppThemeStyle.retro);
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              );
            },
          ),
          
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}

class _ThemeQuickButton extends StatelessWidget {
  final String name;
  final Color color;
  final Color bgColor;
  final bool isSelected;
  final VoidCallback onTap;
  
  const _ThemeQuickButton({
    required this.name,
    required this.color,
    required this.bgColor,
    required this.isSelected,
    required this.onTap,
  });
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected ? color : Colors.transparent,
                width: 3,
              ),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.3),
                  blurRadius: isSelected ? 10 : 0,
                ),
              ],
            ),
            child: Center(
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            name,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              color: isSelected ? color : null,
            ),
          ),
        ],
      ),
    );
  }
}
