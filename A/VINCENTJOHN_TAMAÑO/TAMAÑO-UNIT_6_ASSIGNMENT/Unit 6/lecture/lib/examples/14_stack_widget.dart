// Not in the deck yet: the Stack *widget*.
//
// The outline lists "Stack" under Navigation, meaning the stack of screens
// that Navigator pushes and pops. Flutter also has a Stack *layout widget*
// that piles children on top of each other. Students mix the two up, so
// show both by name.
//
// Try it: drag the sliders to move the badge with Positioned.

import 'package:flutter/material.dart';

void main() => runApp(
  MaterialApp(
    theme: ThemeData(colorSchemeSeed: Colors.purple),
    home: const StackWidgetDemo(),
  ),
);

class StackWidgetDemo extends StatefulWidget {
  const StackWidgetDemo({super.key});

  @override
  State<StackWidgetDemo> createState() => _StackWidgetDemoState();
}

class _StackWidgetDemoState extends State<StackWidgetDemo> {
  double _top = 8;
  double _right = 8;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Stack widget (layout)')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: Stack(
              // The first child is at the bottom, the last child is on top.
              children: [
                Container(
                  width: 240,
                  height: 160,
                  color: Colors.purple.shade100,
                  alignment: Alignment.center,
                  child: const Icon(Icons.landscape, size: 80),
                ),
                const Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: ColoredBox(
                    color: Colors.black54,
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Text(
                        'Caption on top of the picture',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: _top,
                  right: _right,
                  child: const Chip(label: Text('NEW')),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text('top: ${_top.round()}'),
          Slider(
            value: _top,
            max: 100,
            onChanged: (v) => setState(() => _top = v),
          ),
          Text('right: ${_right.round()}'),
          Slider(
            value: _right,
            max: 150,
            onChanged: (v) => setState(() => _right = v),
          ),
        ],
      ),
    );
  }
}
