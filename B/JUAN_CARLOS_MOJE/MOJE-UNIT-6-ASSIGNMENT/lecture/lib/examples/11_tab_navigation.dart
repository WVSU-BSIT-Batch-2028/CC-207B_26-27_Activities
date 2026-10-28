// Slides 53–56: Tab navigation with DefaultTabController, TabBar and
// TabBarView.
//
// The rule from slide 56: the number of Tabs, the number of TabBarView
// children, and DefaultTabController.length must all be the same.
//
// Try it (a good "why?" question for class):
// 1. Tap + a few times on tab A and on tab B.
// 2. Go to tab C, then come back.
// 3. Tab A kept its count, tab B lost it. TabBarView throws away pages you
//    can't see. Tab A asks to be kept alive with AutomaticKeepAliveClientMixin.

import 'package:flutter/material.dart';

void main() => runApp(
  MaterialApp(
    theme: ThemeData(colorSchemeSeed: Colors.indigo),
    home: const TabDemo(),
  ),
);

class TabDemo extends StatelessWidget {
  const TabDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Tab navigation'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.looks_one), text: 'Show A'),
              Tab(icon: Icon(Icons.looks_two), text: 'Show B'),
              Tab(icon: Icon(Icons.looks_3), text: 'Show C'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            CounterPage(label: 'A', keepAlive: true),
            CounterPage(label: 'B', keepAlive: false),
            Center(child: Text("I'm widget C")),
          ],
        ),
      ),
    );
  }
}

class CounterPage extends StatefulWidget {
  const CounterPage({super.key, required this.label, required this.keepAlive});

  final String label;
  final bool keepAlive;

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage>
    with AutomaticKeepAliveClientMixin {
  int _count = 0;

  @override
  bool get wantKeepAlive => widget.keepAlive;

  @override
  Widget build(BuildContext context) {
    super.build(context); // required by AutomaticKeepAliveClientMixin
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("I'm widget ${widget.label}"),
          Text(
            'Count: $_count',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          Text(widget.keepAlive ? '(kept alive)' : '(rebuilt from scratch)'),
          IconButton.filled(
            tooltip: 'Add one on ${widget.label}',
            onPressed: () => setState(() => _count++),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
