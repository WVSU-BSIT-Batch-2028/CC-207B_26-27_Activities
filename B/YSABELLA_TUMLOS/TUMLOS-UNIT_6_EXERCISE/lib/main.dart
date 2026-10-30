import 'package:flutter/material.dart';

import 'screens/gallery_screen.dart';
import 'screens/pet_screen.dart';
import 'screens/profile_screen.dart';
import 'widgets/aurora_background.dart';
import 'widgets/glass_nav_wrapper.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF6B1F34),
      brightness: Brightness.dark,
    ).copyWith(
      surface: const Color(0xFF0F0B0E),
      onSurface: const Color(0xFFF3EAE4),
      onSurfaceVariant: const Color(0xFFC9BDB7),
      primary: const Color(0xFFD8B98A),
      onPrimary: const Color(0xFF2A1D0C),
      primaryContainer: const Color(0xFF4A1625),
      onPrimaryContainer: const Color(0xFFF3D9C0),
      secondary: const Color(0xFFB98A8F),
      secondaryContainer: const Color(0xFF3A1A24),
      onSecondaryContainer: const Color(0xFFF3EAE4),
      tertiary: const Color(0xFFE3B7A0),
      outline: const Color(0xFF8A7780),
      outlineVariant: const Color(0xFF5A4650),
    );

    return MaterialApp(
      title: 'Ysabella Nicole D. Tumlos',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: scheme,
        scaffoldBackgroundColor: Colors.transparent,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: true,
        ),
        navigationBarTheme: const NavigationBarThemeData(
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
        ),
        chipTheme: ChipThemeData(
          backgroundColor: scheme.primary.withValues(alpha: 0.08),
          side: BorderSide(color: scheme.primary.withValues(alpha: 0.45)),
          labelStyle: TextStyle(color: scheme.onSurface),
        ),
        cardTheme: CardThemeData(
          color: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: BorderSide(
              color: scheme.primary.withValues(alpha: 0.28),
              width: 1.2,
            ),
          ),
        ),
      ),
      home: const HomeShell(),
    );
  }
}

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _selectedIndex = 0;

  static const List<Widget> _screens = [
    ProfileScreen(),
    PetScreen(),
    GalleryScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return AuroraBackground(
      child: Scaffold(
        body: IndexedStack(index: _selectedIndex, children: _screens),
        bottomNavigationBar: GlassNavWrapper(
          child: NavigationBar(
            height: 68,
            selectedIndex: _selectedIndex,
            onDestinationSelected: (index) =>
                setState(() => _selectedIndex = index),
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.person_outline_rounded),
                selectedIcon: Icon(Icons.person_rounded),
                label: 'Profile',
              ),
              NavigationDestination(
                icon: Icon(Icons.pets_outlined),
                selectedIcon: Icon(Icons.pets),
                label: 'My Pet',
              ),
              NavigationDestination(
                icon: Icon(Icons.photo_library_outlined),
                selectedIcon: Icon(Icons.photo_library_rounded),
                label: 'Gallery',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
