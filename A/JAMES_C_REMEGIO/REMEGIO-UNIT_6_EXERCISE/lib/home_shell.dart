import 'package:flutter/material.dart';

import 'gallery_screen.dart';
import 'motion.dart';
import 'pet_screen.dart';
import 'profile_screen.dart';

/// Keeps Profile, My Pet, and Gallery alive in an [IndexedStack].
class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = <Widget>[
    ProfileScreen(),
    PetScreen(),
    GalleryScreen(),
  ];

  void _selectTab(int index) {
    if (index == _selectedIndex) {
      return;
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final Duration duration = motionDuration(
      context,
      const Duration(milliseconds: 220),
    );

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        sizing: StackFit.expand,
        children: _pages,
      ),
      bottomNavigationBar: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: scheme.outlineVariant)),
        ),
        child: NavigationBar(
          selectedIndex: _selectedIndex,
          animationDuration: duration,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          onDestinationSelected: _selectTab,
          destinations: const <NavigationDestination>[
            NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person),
              label: 'Profile',
              tooltip: 'Profile',
            ),
            NavigationDestination(
              icon: Icon(Icons.smart_toy_outlined),
              selectedIcon: Icon(Icons.smart_toy),
              label: 'My Pet',
              tooltip: 'My Pet',
            ),
            NavigationDestination(
              icon: Icon(Icons.photo_outlined),
              selectedIcon: Icon(Icons.photo),
              label: 'Gallery',
              tooltip: 'Gallery',
            ),
          ],
        ),
      ),
    );
  }
}
