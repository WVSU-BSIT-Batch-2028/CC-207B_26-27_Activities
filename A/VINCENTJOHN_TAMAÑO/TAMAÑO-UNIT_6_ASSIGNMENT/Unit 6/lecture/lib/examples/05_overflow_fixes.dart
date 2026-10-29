// Slides 21–23: Not enough space, and how to fix overflow.
//
// Scrolling is only one fix. Each card shows a different overflow and the
// widget that fixes it. Switch "Show the problem" on to see the yellow and
// black stripes, then off to see the fix.
//
// Fix 1: long text in a Row     -> Expanded + maxLines + ellipsis
// Fix 2: too many chips in a Row -> Wrap (flows onto the next line)
// Fix 3: too much in a Column    -> SingleChildScrollView

import 'package:flutter/material.dart';

void main() => runApp(
  MaterialApp(
    theme: ThemeData(colorSchemeSeed: Colors.amber),
    home: const OverflowDemo(),
  ),
);

class OverflowDemo extends StatelessWidget {
  const OverflowDemo({super.key});

  static const String headline =
      'Flutter news: a very long headline that will never fit on one line of a phone';

  static const List<String> tags = [
    'Flutter',
    'Dart',
    'Layouts',
    'Lists',
    'Grids',
    'Tables',
    'Navigation',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fixing overflow')),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          _ProblemCard(
            title: '1. Long text in a Row',
            problem: const Row(
              children: [
                Icon(Icons.newspaper),
                SizedBox(width: 8),
                Text(headline),
              ],
            ),
            fixed: const Row(
              children: [
                Icon(Icons.newspaper),
                SizedBox(width: 8),
                // Expanded gives the Text a width limit,
                // and ellipsis cuts it off neatly.
                Expanded(
                  child: Text(
                    headline,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          _ProblemCard(
            title: '2. Too many chips in a Row',
            problem: Row(
              children: [for (final tag in tags) Chip(label: Text(tag))],
            ),
            fixed: Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [for (final tag in tags) Chip(label: Text(tag))],
            ),
          ),
          _ProblemCard(
            title: '3. Too much in a short Column',
            problem: SizedBox(
              height: 150,
              child: Column(
                children: [
                  for (int i = 1; i <= 6; i++)
                    ListTile(title: Text('Field $i')),
                ],
              ),
            ),
            fixed: SizedBox(
              height: 150,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    for (int i = 1; i <= 6; i++)
                      ListTile(title: Text('Field $i')),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProblemCard extends StatefulWidget {
  const _ProblemCard({
    required this.title,
    required this.problem,
    required this.fixed,
  });

  final String title;
  final Widget problem;
  final Widget fixed;

  @override
  State<_ProblemCard> createState() => _ProblemCardState();
}

class _ProblemCardState extends State<_ProblemCard> {
  bool _showProblem = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.title, style: Theme.of(context).textTheme.titleMedium),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Show the problem'),
              value: _showProblem,
              onChanged: (value) => setState(() => _showProblem = value),
            ),
            _showProblem ? widget.problem : widget.fixed,
          ],
        ),
      ),
    );
  }
}
