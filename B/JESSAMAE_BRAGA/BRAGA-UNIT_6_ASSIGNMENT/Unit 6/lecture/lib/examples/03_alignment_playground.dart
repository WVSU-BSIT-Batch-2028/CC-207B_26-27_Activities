// Slides 14–19: Row, Column, mainAxisAlignment and crossAxisAlignment.
//
// A playground for the tables on slides 17 and 18. Ask the class to
// predict where the boxes go before you tap each option.
//
// Try it:
// 1. Switch between Row and Column. The main axis flips with it.
// 2. Turn on "Expanded on the middle box". Every mainAxisAlignment now looks
//    the same. Why? Expanded takes all the free space, so there is nothing
//    left over to distribute (the code on slide 19 has this problem).

import 'package:flutter/material.dart';

void main() => runApp(
  MaterialApp(
    theme: ThemeData(colorSchemeSeed: Colors.teal),
    home: const AlignmentPlayground(),
  ),
);

class AlignmentPlayground extends StatefulWidget {
  const AlignmentPlayground({super.key});

  @override
  State<AlignmentPlayground> createState() => _AlignmentPlaygroundState();
}

class _AlignmentPlaygroundState extends State<AlignmentPlayground> {
  bool _isRow = true;
  bool _expandMiddle = false;
  MainAxisAlignment _main = MainAxisAlignment.start;
  CrossAxisAlignment _cross = CrossAxisAlignment.center;

  // baseline needs extra setup (textBaseline), so it is left out here.
  static const List<CrossAxisAlignment> _crossOptions = [
    CrossAxisAlignment.start,
    CrossAxisAlignment.center,
    CrossAxisAlignment.end,
    CrossAxisAlignment.stretch,
  ];

  @override
  Widget build(BuildContext context) {
    // Boxes of different sizes, so crossAxisAlignment has something to do.
    final List<Widget> boxes = [
      const _Box('A', Colors.orange, 50),
      _expandMiddle
          ? const Expanded(child: _Box('B', Colors.blue, 70))
          : const _Box('B', Colors.blue, 70),
      const _Box('C', Colors.green, 90),
    ];

    final Widget flex = _isRow
        ? Row(
            mainAxisAlignment: _main,
            crossAxisAlignment: _cross,
            children: boxes,
          )
        : Column(
            mainAxisAlignment: _main,
            crossAxisAlignment: _cross,
            children: boxes,
          );

    return Scaffold(
      appBar: AppBar(title: const Text('Alignment playground')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SegmentedButton<bool>(
            segments: const [
              ButtonSegment(value: true, label: Text('Row')),
              ButtonSegment(value: false, label: Text('Column')),
            ],
            selected: {_isRow},
            onSelectionChanged: (s) => setState(() => _isRow = s.first),
          ),
          const SizedBox(height: 12),
          Container(
            key: const Key('stage'),
            height: 260,
            color: Colors.grey.shade300,
            child: flex,
          ),
          Text(
            _isRow
                ? 'Row: main axis is horizontal, cross axis is vertical'
                : 'Column: main axis is vertical, cross axis is horizontal',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 12),
          Text(
            'mainAxisAlignment',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          Wrap(
            spacing: 8,
            children: [
              for (final option in MainAxisAlignment.values)
                ChoiceChip(
                  label: Text(option.name),
                  selected: _main == option,
                  onSelected: (_) => setState(() => _main = option),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'crossAxisAlignment',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          Wrap(
            spacing: 8,
            children: [
              for (final option in _crossOptions)
                ChoiceChip(
                  label: Text(option.name),
                  selected: _cross == option,
                  onSelected: (_) => setState(() => _cross = option),
                ),
            ],
          ),
          SwitchListTile(
            title: const Text('Expanded on the middle box'),
            value: _expandMiddle,
            onChanged: (value) => setState(() => _expandMiddle = value),
          ),
          if (_expandMiddle)
            const Text(
              'Expanded took all the free space, '
              'so mainAxisAlignment has nothing left to share out.',
            ),
        ],
      ),
    );
  }
}

class _Box extends StatelessWidget {
  const _Box(this.label, this.color, this.size);

  final String label;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: Key('box-$label'),
      width: size,
      height: size,
      color: color,
      alignment: Alignment.center,
      child: Text(label, style: const TextStyle(color: Colors.white)),
    );
  }
}
