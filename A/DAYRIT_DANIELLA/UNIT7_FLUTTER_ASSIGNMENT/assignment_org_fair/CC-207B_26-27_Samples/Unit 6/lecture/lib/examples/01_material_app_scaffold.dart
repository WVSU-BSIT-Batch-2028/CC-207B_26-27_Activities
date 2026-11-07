// Slides 4–10: MaterialApp (the outer, invisible frame) and Scaffold (the
// inner, visible frame).
//
// Try it:
// 1. Switch "Custom leading icon" on. The hamburger button disappears,
//    because leading takes its spot (slides 9–10). The drawer still opens if
//    you swipe in from the left edge.
// 2. Turn the FAB and bottom bar off. Every part of a Scaffold is optional.
// 3. Tap "Open a bottom sheet".

import 'package:flutter/material.dart';

void main() => runApp(const ScaffoldApp());

class ScaffoldApp extends StatelessWidget {
  const ScaffoldApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // The name the OS shows in the app switcher.
      title: 'My Cool App',
      debugShowCheckedModeBanner: false,
      // Material 3 builds the whole colour scheme from one seed colour.
      // The old `primarySwatch:` (slide 5) no longer changes the colour scheme.
      theme: ThemeData(colorSchemeSeed: Colors.deepPurple),
      home: const ScaffoldDemo(),
    );
  }
}

class ScaffoldDemo extends StatefulWidget {
  const ScaffoldDemo({super.key});

  @override
  State<ScaffoldDemo> createState() => _ScaffoldDemoState();
}

class _ScaffoldDemoState extends State<ScaffoldDemo> {
  bool _customLeading = false;
  bool _showFab = true;
  bool _showBottomBar = true;
  int _fabTaps = 0;

  void _openBottomSheet() {
    showModalBottomSheet<void>(
      context: context,
      builder: (context) => const SizedBox(
        height: 200,
        child: Center(child: Text('Context-aware info goes here')),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // null means "let Flutter decide": a hamburger if there is a drawer,
        // a back arrow if there is a page to go back to.
        leading: _customLeading ? const Icon(Icons.traffic) : null,
        title: const Text('My Cool App'),
      ),
      drawer: const Drawer(child: Center(child: Text('I am the drawer'))),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Custom leading icon'),
            subtitle: const Text('Replaces the hamburger menu button'),
            value: _customLeading,
            onChanged: (value) => setState(() => _customLeading = value),
          ),
          SwitchListTile(
            title: const Text('Floating action button'),
            value: _showFab,
            onChanged: (value) => setState(() => _showFab = value),
          ),
          SwitchListTile(
            title: const Text('Bottom bar'),
            value: _showBottomBar,
            onChanged: (value) => setState(() => _showBottomBar = value),
          ),
          ListTile(
            leading: const Icon(Icons.vertical_align_top),
            title: const Text('Open a bottom sheet'),
            onTap: _openBottomSheet,
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text('FAB pressed $_fabTaps times'),
          ),
        ],
      ),
      floatingActionButton: _showFab
          ? FloatingActionButton(
              tooltip: 'Add',
              onPressed: () => setState(() => _fabTaps++),
              child: const Icon(Icons.add),
            )
          : null,
      bottomNavigationBar: _showBottomBar
          ? const BottomAppBar(
              child: Center(child: Text('bottomNavigationBar slot')),
            )
          : null,
    );
  }
}
