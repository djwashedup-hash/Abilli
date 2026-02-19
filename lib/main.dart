import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/receipt_scanner_screen.dart';
import 'screens/add_purchase_screen.dart';
import 'screens/monthly_report_screen.dart';
import 'screens/alternatives_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/theme_selector_screen.dart';
import 'services/purchase_service.dart';
import 'theme/theme_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PurchaseService()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: const AbilliApp(),
    ),
  );
}

class AbilliApp extends StatelessWidget {
  const AbilliApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'Abilli',
          debugShowCheckedModeBanner: false,
          theme: themeProvider.themeData,
          home: const MainNavigationScreen(),
        );
      },
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});
  
  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;
  
  final _screens = const [
    ReceiptScannerScreen(),
    AddPurchaseScreen(),
    AlternativesScreen(),
    MonthlyReportScreen(),
    SettingsScreen(),
  ];
  
  final _titles = const [
    'Scan Receipt',
    'Add Purchase',
    'Alternatives',
    'Report',
    'Settings',
  ];
  
  @override
  void initState() {
    super.initState();
    _initializeService();
  }
  
  Future<void> _initializeService() async {
    final service = context.read<PurchaseService>();
    await service.initialize();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_currentIndex]),
        actions: [
          // Theme switcher button
          IconButton(
            icon: const Icon(Icons.palette_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ThemeSelectorScreen(),
                ),
              );
            },
            tooltip: 'Change Theme',
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.document_scanner_outlined),
            activeIcon: Icon(Icons.document_scanner),
            label: 'Scan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            activeIcon: Icon(Icons.add_circle),
            label: 'Manual',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.swap_horiz_outlined),
            activeIcon: Icon(Icons.swap_horiz),
            label: 'Alternatives',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pie_chart_outline),
            activeIcon: Icon(Icons.pie_chart),
            label: 'Report',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            activeIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
