// Slides 29–34: GridView.extent, GridView.count and GridView.builder.
//
// Try it:
// 1. "extent": drag the slider. Flutter fits as many columns as it can
//    without any tile getting wider than maxCrossAxisExtent.
//    Rotate the phone (or resize the browser) and the column count changes.
// 2. "count": the column count stays fixed, whatever the screen width.
// 3. "builder": like ListView.builder, tiles are built only when needed.
//    .extent and .count build every child up front, so use .builder for
//    long or unknown-length data.

import 'package:flutter/material.dart';

void main() => runApp(
  MaterialApp(
    theme: ThemeData(colorSchemeSeed: Colors.deepOrange),
    home: const GridViewDemo(),
  ),
);

enum GridKind { extent, count, builder }

class GridViewDemo extends StatefulWidget {
  const GridViewDemo({super.key});

  @override
  State<GridViewDemo> createState() => _GridViewDemoState();
}

class _GridViewDemoState extends State<GridViewDemo> {
  GridKind _kind = GridKind.extent;
  double _maxExtent = 150;
  int _count = 2;

  static Widget _tile(int index) {
    return Card(
      color: Colors.primaries[index % Colors.primaries.length].shade100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.person, size: 40),
          Text('Student ${index + 1}'),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('GridView')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: SegmentedButton<GridKind>(
              segments: const [
                ButtonSegment(value: GridKind.extent, label: Text('extent')),
                ButtonSegment(value: GridKind.count, label: Text('count')),
                ButtonSegment(value: GridKind.builder, label: Text('builder')),
              ],
              selected: {_kind},
              onSelectionChanged: (s) => setState(() => _kind = s.first),
            ),
          ),
          if (_kind == GridKind.count)
            Slider(
              value: _count.toDouble(),
              min: 1,
              max: 5,
              divisions: 4,
              label: 'crossAxisCount: $_count',
              onChanged: (v) => setState(() => _count = v.round()),
            )
          else
            Slider(
              value: _maxExtent,
              min: 80,
              max: 300,
              divisions: 22,
              label: 'maxCrossAxisExtent: ${_maxExtent.round()}',
              onChanged: (v) => setState(() => _maxExtent = v),
            ),
          // LayoutBuilder tells us how wide the grid is, so we can show the
          // same arithmetic GridView does: columns = (width / extent) rounded up.
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final double width = constraints.maxWidth;
                final int columns = _kind == GridKind.count
                    ? _count
                    : (width / _maxExtent).ceil();
                return Column(
                  children: [
                    Text(
                      'Width ${width.round()} -> $columns columns',
                      key: const Key('grid-info'),
                    ),
                    Expanded(child: _buildGrid()),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGrid() {
    switch (_kind) {
      case GridKind.extent:
        return GridView.extent(
          maxCrossAxisExtent: _maxExtent,
          children: [for (int i = 0; i < 12; i++) _tile(i)],
        );
      case GridKind.count:
        return GridView.count(
          crossAxisCount: _count,
          children: [for (int i = 0; i < 12; i++) _tile(i)],
        );
      case GridKind.builder:
        return GridView.builder(
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: _maxExtent,
          ),
          itemCount: 500,
          itemBuilder: (context, index) => _tile(index),
        );
    }
  }
}
