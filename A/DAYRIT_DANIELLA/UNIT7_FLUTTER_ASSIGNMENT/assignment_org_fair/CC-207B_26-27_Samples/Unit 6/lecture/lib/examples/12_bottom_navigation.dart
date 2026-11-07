// Slide 57: Bottom navigation, the Material 3 way.
//
// NavigationBar is the Material 3 widget made for bottom navigation.
// We store the selected index ourselves and show the matching page.
//
// Try it: tap + on Home, switch to Search and back. The count is still there
// because IndexedStack keeps every page alive and only shows one.
// Turn "Keep pages alive" off and try again.

import 'package:flutter/material.dart';

void main() => runApp(
  MaterialApp(
    theme: ThemeData(colorSchemeSeed: Colors.green),
    home: const BottomNavDemo(),
  ),
);

class BottomNavDemo extends StatefulWidget {
  const BottomNavDemo({super.key});

  @override
  State<BottomNavDemo> createState() => _BottomNavDemoState();
}

class _BottomNavDemoState extends State<BottomNavDemo> {
  int _index = 0;
  bool _keepAlive = true;

  static const List<String> _titles = ['Home', 'Search', 'Profile'];

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      const _CountingPage(key: ValueKey('Home'), title: 'Home'),
      const _CountingPage(key: ValueKey('Search'), title: 'Search'),
      SwitchListTile(
        title: const Text('Keep pages alive (IndexedStack)'),
        value: _keepAlive,
        onChanged: (value) => setState(() => _keepAlive = value),
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: Text(_titles[_index])),
      body: _keepAlive
          ? IndexedStack(index: _index, children: pages)
          : pages[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(icon: Icon(Icons.search), label: 'Search'),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class _CountingPage extends StatefulWidget {
  const _CountingPage({super.key, required this.title});

  final String title;

  @override
  State<_CountingPage> createState() => _CountingPageState();
}

class _CountingPageState extends State<_CountingPage> {
  int _count = 0;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${widget.title} count: $_count',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          IconButton.filled(
            tooltip: 'Add one on ${widget.title}',
            onPressed: () => setState(() => _count++),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
