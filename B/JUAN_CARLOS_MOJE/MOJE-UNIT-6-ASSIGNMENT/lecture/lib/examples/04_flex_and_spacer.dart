// Slides 19–20: Expanded, flex, Spacer and SizedBox.
//
// Free space is shared out in proportion to each flex value:
// a box with flex 2 gets twice the share of a box with flex 1.
//
// Try it: move the sliders and predict the widths before you let go.

import 'package:flutter/material.dart';

void main() => runApp(
  MaterialApp(
    theme: ThemeData(colorSchemeSeed: Colors.teal),
    home: const FlexDemo(),
  ),
);

class FlexDemo extends StatefulWidget {
  const FlexDemo({super.key});

  @override
  State<FlexDemo> createState() => _FlexDemoState();
}

class _FlexDemoState extends State<FlexDemo> {
  int _flexA = 1;
  int _flexSpacer = 1;
  int _flexB = 2;

  Widget _slider(String label, int value, ValueChanged<int> onChanged) {
    return Row(
      children: [
        SizedBox(width: 90, child: Text('$label: $value')),
        Expanded(
          child: Slider(
            value: value.toDouble(),
            min: 1,
            max: 4,
            divisions: 3,
            label: '$value',
            onChanged: (v) => setState(() => onChanged(v.round())),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final int total = _flexA + _flexSpacer + _flexB;

    return Scaffold(
      appBar: AppBar(title: const Text('Expanded, flex & Spacer')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SizedBox(
            height: 60,
            child: Row(
              children: [
                const _Fixed(),
                Expanded(
                  flex: _flexA,
                  child: const _Stretchy('A', Colors.orange),
                ),
                Spacer(flex: _flexSpacer),
                Expanded(
                  flex: _flexB,
                  child: const _Stretchy('B', Colors.blue),
                ),
                // A SizedBox is a fixed gap in logical pixels, not a share.
                const SizedBox(width: 10),
                const _Fixed(),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'A gets $_flexA/$total, the Spacer gets $_flexSpacer/$total and '
            'B gets $_flexB/$total of the space left after the fixed boxes.',
          ),
          _slider('A flex', _flexA, (v) => _flexA = v),
          _slider('Spacer', _flexSpacer, (v) => _flexSpacer = v),
          _slider('B flex', _flexB, (v) => _flexB = v),
          const Divider(height: 32),
          Text(
            'Expanded vs Flexible',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          const Text('Expanded forces its child to fill its share:'),
          const SizedBox(
            height: 40,
            child: Row(
              children: [
                Expanded(
                  child: _Stretchy('Expanded', Colors.purple, width: 80),
                ),
                Expanded(child: _Stretchy('Expanded', Colors.pink, width: 80)),
              ],
            ),
          ),
          const SizedBox(height: 8),
          const Text('Flexible lets its child stay smaller than its share:'),
          const SizedBox(
            height: 40,
            child: Row(
              children: [
                Flexible(
                  child: _Stretchy('Flexible', Colors.purple, width: 80),
                ),
                Flexible(child: _Stretchy('Flexible', Colors.pink, width: 80)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Fixed extends StatelessWidget {
  const _Fixed();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      color: Colors.grey,
      child: const Icon(Icons.public),
    );
  }
}

class _Stretchy extends StatelessWidget {
  const _Stretchy(this.label, this.color, {this.width});

  final String label;
  final Color color;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: Key('stretchy-$label-${color.toARGB32()}'),
      width: width,
      color: color,
      alignment: Alignment.center,
      child: Text(label, style: const TextStyle(color: Colors.white)),
    );
  }
}
