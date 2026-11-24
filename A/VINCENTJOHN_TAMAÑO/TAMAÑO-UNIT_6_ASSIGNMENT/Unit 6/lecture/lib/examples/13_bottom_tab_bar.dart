// Slide 57: a TabBar at the bottom, done safely.
//
// Slide 57 puts a TabBar inside Material(color: colorScheme.primary).
// In Material 3 (the default since Flutter 3.16) a TabBar draws the selected
// tab in colorScheme.primary too, so the selected tab becomes invisible.
// Fix: set labelColor, unselectedLabelColor and indicatorColor.
//
// Try it: switch "Use slide 57 colours" on and look for the selected tab.

import 'package:flutter/material.dart';

void main() => runApp(
  MaterialApp(
    theme: ThemeData(colorSchemeSeed: Colors.blue),
    home: const BottomTabBarDemo(),
  ),
);

class BottomTabBarDemo extends StatefulWidget {
  const BottomTabBarDemo({super.key});

  @override
  State<BottomTabBarDemo> createState() => _BottomTabBarDemoState();
}

class _BottomTabBarDemoState extends State<BottomTabBarDemo> {
  bool _slideColours = false;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;

    const List<Tab> tabs = [
      Tab(icon: Icon(Icons.looks_one), text: 'Show A'),
      Tab(icon: Icon(Icons.looks_two), text: 'Show B'),
      Tab(icon: Icon(Icons.looks_3), text: 'Show C'),
    ];

    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(title: const Text('TabBar at the bottom')),
        body: TabBarView(
          children: [
            for (final name in ['A', 'B', 'C'])
              ListView(
                children: [
                  const SizedBox(height: 120),
                  Center(child: Text("I'm widget $name")),
                  SwitchListTile(
                    title: const Text('Use slide 57 colours'),
                    value: _slideColours,
                    onChanged: (value) => setState(() => _slideColours = value),
                  ),
                ],
              ),
          ],
        ),
        bottomNavigationBar: Material(
          color: colors.primary,
          child: SafeArea(
            child: _slideColours
                ? const TabBar(tabs: tabs)
                : TabBar(
                    labelColor: colors.onPrimary,
                    unselectedLabelColor: colors.onPrimary.withValues(
                      alpha: 0.7,
                    ),
                    indicatorColor: colors.onPrimary,
                    tabs: tabs,
                  ),
          ),
        ),
      ),
    );
  }
}
