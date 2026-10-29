// Slides 11–13: SafeArea.
//
// The notch, status bar, rounded corners and home indicator take up a
// different amount of space on every phone. Don't hard-code numbers like
// "44 points": ask Flutter with MediaQuery.paddingOf(context).
//
// Try it on a phone or emulator with a notch (DartPad and desktop report 0):
// switch SafeArea off and watch the text slide under the status bar.
// Rotate to landscape to see the side insets.
//
// Note: an AppBar already keeps itself clear of the status bar, so this
// screen has no AppBar on purpose.

import 'package:flutter/material.dart';

void main() => runApp(
  MaterialApp(
    theme: ThemeData(colorSchemeSeed: Colors.green),
    home: const SafeAreaDemo(),
  ),
);

class SafeAreaDemo extends StatefulWidget {
  const SafeAreaDemo({super.key});

  @override
  State<SafeAreaDemo> createState() => _SafeAreaDemoState();
}

class _SafeAreaDemoState extends State<SafeAreaDemo> {
  bool _useSafeArea = true;

  @override
  Widget build(BuildContext context) {
    final EdgeInsets insets = MediaQuery.paddingOf(context);

    // Material (not Container) behind the content, so the switch's ink
    // splash can paint on it.
    final Widget content = Material(
      color: Colors.lightGreen.shade200,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Top-left corner of my content', key: Key('top-text')),
            const SizedBox(height: 16),
            Text(
              'This device reserves:\n'
              'top ${insets.top}, bottom ${insets.bottom}, '
              'left ${insets.left}, right ${insets.right} logical pixels',
            ),
            SwitchListTile(
              title: const Text('Wrap in SafeArea'),
              value: _useSafeArea,
              onChanged: (value) => setState(() => _useSafeArea = value),
            ),
            if (Navigator.canPop(context))
              TextButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back),
                label: const Text('Back'),
              ),
          ],
        ),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.lightBlue.shade100, // the "unsafe" area
      body: _useSafeArea ? SafeArea(child: content) : content,
    );
  }
}
