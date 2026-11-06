// Slides 48–52: Drawer navigation.
//
// Two ways to use a drawer item:
// 1. Swap the body of this same screen (what slide 42 describes).
//    Close the drawer first with Navigator.pop(context).
// 2. Push a new screen on top (what slides 51–52 do with pushNamed).
//    The new screen gets a back arrow instead of the hamburger.
//
// Try it: open the drawer, pick each page, then open Settings and go back.

import 'package:flutter/material.dart';

void main() => runApp(
  MaterialApp(
    theme: ThemeData(colorSchemeSeed: Colors.blue),
    home: const DrawerDemo(),
  ),
);

class DrawerPage {
  const DrawerPage(this.title, this.icon);

  final String title;
  final IconData icon;
}

const List<DrawerPage> drawerPages = [
  DrawerPage('Inbox', Icons.inbox),
  DrawerPage('Starred', Icons.star),
  DrawerPage('Sent', Icons.send),
];

class DrawerDemo extends StatefulWidget {
  const DrawerDemo({super.key});

  @override
  State<DrawerDemo> createState() => _DrawerDemoState();
}

class _DrawerDemoState extends State<DrawerDemo> {
  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    final DrawerPage page = drawerPages[_selected];

    return Scaffold(
      appBar: AppBar(title: Text(page.title)),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(page.icon, size: 80),
            Text('This is the ${page.title} page'),
          ],
        ),
      ),
      drawer: Drawer(
        // Drawer has one child. ListView gives us many children that scroll.
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
              ),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  'My Brand',
                  // display1 (slide 51) was removed. headlineSmall replaces it.
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
            ),
            for (int i = 0; i < drawerPages.length; i++)
              ListTile(
                leading: Icon(drawerPages[i].icon),
                title: Text(drawerPages[i].title),
                selected: i == _selected,
                onTap: () {
                  setState(() => _selected = i);
                  Navigator.pop(context); // close the drawer
                },
              ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                // Close the drawer first, or it will still be open
                // when the user comes back.
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingsScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: const Center(child: Text('Back arrow here, not a hamburger')),
    );
  }
}
