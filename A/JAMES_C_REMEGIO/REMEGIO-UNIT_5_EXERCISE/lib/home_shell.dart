import 'package:flutter/material.dart';

import 'motion.dart';
import 'pet_screen.dart';
import 'profile_screen.dart';

/// Switches between Profile and My Pet with a bottom [NavigationBar].
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
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          for (var index = 0; index < _pages.length; index++)
            _TabFade(
              visible: index == _selectedIndex,
              duration: duration,
              child: _pages[index],
            ),
        ],
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
          ],
        ),
      ),
    );
  }
}

/// Fades a tab in or out while keeping its state mounted.
class _TabFade extends StatelessWidget {
  const _TabFade({
    required this.visible,
    required this.duration,
    required this.child,
  });

  final bool visible;
  final Duration duration;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !visible,
      child: ExcludeFocus(
        excluding: !visible,
        child: ExcludeSemantics(
          excluding: !visible,
          child: AnimatedOpacity(
            opacity: visible ? 1 : 0,
            duration: duration,
            curve: Curves.easeOut,
            child: TickerMode(enabled: visible, child: child),
          ),
        ),
      ),
    );
  }
}
