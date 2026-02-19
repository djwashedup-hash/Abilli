import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/theme_provider.dart';

class ThemeSelectorScreen extends StatelessWidget {
  const ThemeSelectorScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Theme'),
      ),
      body: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text(
                'CHOOSE YOUR STYLE',
                style: TextStyle(
                  fontSize: 12,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              
              _ThemeCard(
                name: 'Dark',
                description: 'Original GitHub-inspired dark theme',
                colors: const [Color(0xFF0D1117), Color(0xFF58A6FF)],
                isSelected: themeProvider.currentStyle == AppThemeStyle.dark,
                onTap: () => themeProvider.setTheme(AppThemeStyle.dark),
              ),
              
              _ThemeCard(
                name: 'Elegant',
                description: 'Luxury navy & gold aesthetic',
                colors: const [Color(0xFF0A1628), Color(0xFFD4AF37)],
                isSelected: themeProvider.currentStyle == AppThemeStyle.elegant,
                onTap: () => themeProvider.setTheme(AppThemeStyle.elegant),
              ),
              
              _ThemeCard(
                name: 'Corporate',
                description: 'Professional white & navy',
                colors: const [Color(0xFFFFFFFF), Color(0xFF003366)],
                isSelected: themeProvider.currentStyle == AppThemeStyle.corporate,
                onTap: () => themeProvider.setTheme(AppThemeStyle.corporate),
              ),
              
              _ThemeCard(
                name: 'Punk',
                description: 'Rebellious black & neon',
                colors: const [Color(0xFF0A0A0A), Color(0xFFFF006E)],
                isSelected: themeProvider.currentStyle == AppThemeStyle.punk,
                onTap: () => themeProvider.setTheme(AppThemeStyle.punk),
              ),
              
              _ThemeCard(
                name: 'Minimalist',
                description: 'Clean Scandinavian white & gray',
                colors: const [Color(0xFFFFFFFF), Color(0xFF212121)],
                isSelected: themeProvider.currentStyle == AppThemeStyle.minimalist,
                onTap: () => themeProvider.setTheme(AppThemeStyle.minimalist),
              ),
              
              _ThemeCard(
                name: 'Retro',
                description: '80s synthwave purple & neon',
                colors: const [Color(0xFF1A0A2E), Color(0xFFFF00FF)],
                isSelected: themeProvider.currentStyle == AppThemeStyle.retro,
                onTap: () => themeProvider.setTheme(AppThemeStyle.retro),
              ),
            ],
          );
        },
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
  
  const _ThemeCard({
    required this.name,
    required this.description,
    required this.colors,
    required this.isSelected,
    required this.onTap,
  });
  
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: isSelected 
                ? Border.all(color: colors[1], width: 2)
                : null,
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
                ),
              ),
              const SizedBox(width: 16),
              
              // Text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Checkmark
              if (isSelected)
                Icon(
                  Icons.check_circle,
                  color: colors[1],
                  size: 28,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
