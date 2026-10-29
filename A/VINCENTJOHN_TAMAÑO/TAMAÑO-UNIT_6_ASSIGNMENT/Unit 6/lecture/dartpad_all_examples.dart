// DartPad-ready version of the Unit 6 Flutter examples.
// Paste this file into DartPad with Flutter selected.

import 'package:flutter/material.dart';

void main() => runApp(const AdvancedExamplesApp());

class AdvancedExamplesApp extends StatelessWidget {
  const AdvancedExamplesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CC 206 Advanced Flutter',
      theme: ThemeData(colorSchemeSeed: Colors.deepPurple),
      home: const ExampleMenu(),
      // Example 9 uses a named route, so the menu app registers it too.
      routes: shopRoutes,
    );
  }
}

class Example {
  const Example(this.title, this.slides, this.icon, this.screen);

  final String title;
  final String slides;
  final IconData icon;
  final Widget screen;
}

const List<Example> examples = [
  Example(
    '1. MaterialApp & Scaffold',
    'Slides 4–10',
    Icons.web_asset,
    ScaffoldDemo(),
  ),
  Example('2. SafeArea', 'Slides 11–13', Icons.smartphone, SafeAreaDemo()),
  Example(
    '3. Alignment playground',
    'Slides 14–19',
    Icons.align_horizontal_center,
    AlignmentPlayground(),
  ),
  Example(
    '4. Expanded, flex & Spacer',
    'Slides 19–20',
    Icons.width_normal,
    FlexDemo(),
  ),
  Example(
    '5. Fixing overflow',
    'Slides 21–23',
    Icons.warning_amber,
    OverflowDemo(),
  ),
  Example('6. ListView', 'Slides 23–28', Icons.list, ListViewDemo()),
  Example('7. GridView', 'Slides 29–34', Icons.grid_view, GridViewDemo()),
  Example('8. Tables', 'Slides 35–39', Icons.table_chart, TableDemo()),
  Example(
    '9. Stack navigation & dialogs',
    'Slides 41–47',
    Icons.layers,
    ShopHome(),
  ),
  Example('10. Drawer navigation', 'Slides 48–52', Icons.menu, DrawerDemo()),
  Example('11. Tab navigation', 'Slides 53–56', Icons.tab, TabDemo()),
  Example(
    '12. Bottom navigation (NavigationBar)',
    'Slide 57',
    Icons.space_dashboard,
    BottomNavDemo(),
  ),
  Example(
    '13. TabBar at the bottom',
    'Slide 57',
    Icons.tab_unselected,
    BottomTabBarDemo(),
  ),
  Example(
    '14. Stack widget (not navigation)',
    'New',
    Icons.filter_none,
    StackWidgetDemo(),
  ),
];

class ExampleMenu extends StatelessWidget {
  const ExampleMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CC 206 Advanced Flutter')),
      body: ListView.builder(
        itemCount: examples.length,
        itemBuilder: (context, index) {
          final Example example = examples[index];
          return ListTile(
            leading: Icon(example.icon),
            title: Text(example.title),
            subtitle: Text(example.slides),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => example.screen),
            ),
          );
        },
      ),
    );
  }
}

// Slides 4–10: MaterialApp (the outer, invisible frame) and Scaffold (the
// inner, visible frame).
//
// Try it:
// 1. Switch "Custom leading icon" on. The hamburger button disappears,
//    because leading takes its spot (slides 9–10). The drawer still opens if
//    you swipe in from the left edge.
// 2. Turn the FAB and bottom bar off. Every part of a Scaffold is optional.
// 3. Tap "Open a bottom sheet".

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

// Slides 19–20: Expanded, flex, Spacer and SizedBox.
//
// Free space is shared out in proportion to each flex value:
// a box with flex 2 gets twice the share of a box with flex 1.
//
// Try it: move the sliders and predict the widths before you let go.

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

// Slides 21–23: Not enough space, and how to fix overflow.
//
// Scrolling is only one fix. Each card shows a different overflow and the
// widget that fixes it. Switch "Show the problem" on to see the yellow and
// black stripes, then off to see the fix.
//
// Fix 1: long text in a Row     -> Expanded + maxLines + ellipsis
// Fix 2: too many chips in a Row -> Wrap (flows onto the next line)
// Fix 3: too much in a Column    -> SingleChildScrollView

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

// Slides 23–28: ListView, ListView.builder and ListView.separated.
//
// Try it:
// 1. Pick "builder", scroll a little, then tap the counter button.
//    Only the rows that came on screen were built, not all 1000.
//    That is what "lazy" means (slide 27).
// 2. Pick "separated" to see a divider between rows and a "sponsored"
//    row after every 5 people (slide 25).
// 3. Tap a person: lists are for doing something with an item.

/// A typed model instead of `dynamic` or a Map, so the editor can check us.
class Person {
  const Person({required this.name, required this.email});

  final String name;
  final String email;

  String get initials => name.split(' ').map((part) => part[0]).join();
}

const List<String> _first = ['Ana', 'Ben', 'Carla', 'Dante', 'Ella', 'Felix'];
const List<String> _last = ['Reyes', 'Santos', 'Cruz', 'Garcia', 'Lim'];

final List<Person> people = List.generate(1000, (i) {
  final String name = '${_first[i % _first.length]} ${_last[i % _last.length]}';
  return Person(name: name, email: 'student$i@example.com');
});

enum ListKind { children, builder, separated }

class ListViewDemo extends StatefulWidget {
  const ListViewDemo({super.key});

  @override
  State<ListViewDemo> createState() => _ListViewDemoState();
}

class _ListViewDemoState extends State<ListViewDemo> {
  ListKind _kind = ListKind.builder;

  // Only for this demo: remembers which rows itemBuilder has built.
  final Set<int> _built = {};

  Widget _personTile(Person person) {
    return ListTile(
      leading: CircleAvatar(child: Text(person.initials)),
      title: Text(person.name),
      subtitle: Text(person.email),
      onTap: () => ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text('You tapped ${person.name}'))),
    );
  }

  Widget _buildList() {
    switch (_kind) {
      case ListKind.children:
        // Fine for a few fixed widgets. Every child is built up front.
        return ListView(
          children: [
            _personTile(people[0]),
            _personTile(people[1]),
            _personTile(people[2]),
          ],
        );
      case ListKind.builder:
        return ListView.builder(
          itemCount: people.length,
          itemBuilder: (context, index) {
            _built.add(index);
            final Person person = people[index];
            return _personTile(person);
          },
        );
      case ListKind.separated:
        return ListView.separated(
          itemCount: people.length,
          itemBuilder: (context, index) => _personTile(people[index]),
          separatorBuilder: (context, index) => (index + 1) % 5 == 0
              ? const ListTile(
                  tileColor: Color(0xFFFFF3C4),
                  leading: Icon(Icons.campaign),
                  title: Text('Sponsored: CICT Org Fair'),
                )
              : const Divider(height: 1),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ListView')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: SegmentedButton<ListKind>(
              segments: const [
                ButtonSegment(
                  value: ListKind.children,
                  label: Text('children'),
                ),
                ButtonSegment(value: ListKind.builder, label: Text('builder')),
                ButtonSegment(
                  value: ListKind.separated,
                  label: Text('separated'),
                ),
              ],
              selected: {_kind},
              onSelectionChanged: (s) => setState(() => _kind = s.first),
            ),
          ),
          Expanded(child: _buildList()),
        ],
      ),
      floatingActionButton: _kind == ListKind.builder
          ? FloatingActionButton.extended(
              icon: const Icon(Icons.calculate),
              label: const Text('How many were built?'),
              onPressed: () => ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text(
                      'itemBuilder has built ${_built.length} of '
                      '${people.length} rows so far',
                    ),
                  ),
                ),
            )
          : null,
    );
  }
}

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

// Slides 35–39: Table, and DataTable for data the user can sort.
//
// Try it:
// 1. Switch "Use Rows and Columns instead". The columns no longer line up,
//    because each Column sizes itself without asking the others (slide 36).
// 2. Tap a DataTable header to sort by that column. Tap again to reverse.

class Sale {
  const Sale(this.name, this.january, this.february, this.march);

  final String name;
  final int january;
  final int february;
  final int march;

  int get total => january + february + march;
}

const List<Sale> sales = [
  Sale('Ana', 3742, 5573, 4323),
  Sale('Benjamin', 3823, 4500, 3277),
  Sale('Carla', 4105, 3988, 5012),
];

class TableDemo extends StatefulWidget {
  const TableDemo({super.key});

  @override
  State<TableDemo> createState() => _TableDemoState();
}

class _TableDemoState extends State<TableDemo> {
  bool _useRowsAndColumns = false;
  int _sortColumn = 0;
  bool _ascending = true;

  // Slide 38 uses `style: bold` without defining it. This is the fix.
  static const TextStyle bold = TextStyle(fontWeight: FontWeight.bold);

  Widget _cell(String text, {TextStyle? style, bool number = false}) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Text(
        text,
        style: style,
        textAlign: number ? TextAlign.right : TextAlign.left,
      ),
    );
  }

  Widget _table() {
    return Table(
      border: TableBorder.all(color: Colors.grey.shade400),
      // The name column sizes to its content; the month columns share the rest.
      columnWidths: const {0: IntrinsicColumnWidth()},
      children: [
        TableRow(
          decoration: BoxDecoration(color: Colors.blueGrey.shade100),
          children: [
            _cell('Salesperson', style: bold),
            _cell('January', style: bold),
            _cell('February', style: bold),
            _cell('March', style: bold),
          ],
        ),
        for (final sale in sales)
          TableRow(
            children: [
              _cell(sale.name),
              _cell('${sale.january}', number: true),
              _cell('${sale.february}', number: true),
              _cell('${sale.march}', number: true),
            ],
          ),
      ],
    );
  }

  // The "before" version: one Column per table column, each sized on its own.
  Widget _rowsAndColumns() {
    Widget column(String header, List<String> values) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _cell(header, style: bold),
        for (final value in values) _cell(value),
      ],
    );

    return Row(
      children: [
        column('Salesperson', [for (final s in sales) s.name]),
        column('Jan', [for (final s in sales) '${s.january}']),
        column('February', [for (final s in sales) '${s.february}']),
        column('Mar', [for (final s in sales) '${s.march}']),
      ],
    );
  }

  List<Sale> get _sorted {
    // Dart 3 switch expression: pick what to sort by.
    final Comparable<Object> Function(Sale) key = switch (_sortColumn) {
      0 => (s) => s.name,
      1 => (s) => s.january,
      2 => (s) => s.february,
      3 => (s) => s.march,
      _ => (s) => s.total,
    };
    final List<Sale> list = [...sales]
      ..sort((a, b) => key(a).compareTo(key(b)));
    return _ascending ? list : list.reversed.toList();
  }

  void _sort(int column, bool ascending) {
    setState(() {
      _sortColumn = column;
      _ascending = ascending;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tables')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Use Rows and Columns instead'),
            value: _useRowsAndColumns,
            onChanged: (value) => setState(() => _useRowsAndColumns = value),
          ),
          _useRowsAndColumns ? _rowsAndColumns() : _table(),
          const Divider(height: 40),
          Text(
            'DataTable (tap a header to sort)',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          // A DataTable can be wider than a phone, so let it scroll sideways.
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              sortColumnIndex: _sortColumn,
              sortAscending: _ascending,
              columns: [
                DataColumn(label: const Text('Name'), onSort: _sort),
                DataColumn(
                  label: const Text('Jan'),
                  numeric: true,
                  onSort: _sort,
                ),
                DataColumn(
                  label: const Text('Feb'),
                  numeric: true,
                  onSort: _sort,
                ),
                DataColumn(
                  label: const Text('Mar'),
                  numeric: true,
                  onSort: _sort,
                ),
                DataColumn(
                  label: const Text('Total'),
                  numeric: true,
                  onSort: _sort,
                ),
              ],
              rows: [
                for (final sale in _sorted)
                  DataRow(
                    cells: [
                      DataCell(Text(sale.name)),
                      DataCell(Text('${sale.january}')),
                      DataCell(Text('${sale.february}')),
                      DataCell(Text('${sale.march}')),
                      DataCell(Text('${sale.total}')),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Slides 41–47: Stack navigation (push and pop), plus dialogs (slide 43).
//
// A tiny shop that shows the four things students need most:
// 1. Push a screen and pass it data through its constructor.
// 2. Pop a screen and send a result back (await the push).
// 3. Named routes with `arguments` (slides 44–45).
// 4. A dialog that returns the user's answer.
//
// Try it: open a product, add it to the cart, open the cart, place the order.
// Use the AppBar back arrow or the Android back button at any point.

/// Named routes, registered on MaterialApp (slide 44).
final Map<String, WidgetBuilder> shopRoutes = {
  CheckoutScreen.routeName: (context) => const CheckoutScreen(),
};

class Product {
  const Product(this.name, this.price, this.icon);

  final String name;
  final double price;
  final IconData icon;
}

const List<Product> products = [
  Product('Notebook', 45, Icons.menu_book),
  Product('Ballpen', 12, Icons.edit),
  Product('USB drive', 350, Icons.usb),
  Product('Headphones', 799, Icons.headphones),
];

class ShopHome extends StatefulWidget {
  const ShopHome({super.key});

  @override
  State<ShopHome> createState() => _ShopHomeState();
}

class _ShopHomeState extends State<ShopHome> {
  final List<Product> _cart = [];

  Future<void> _openProduct(Product product) async {
    // 1 + 2: pass the product in, and wait for the screen to pop with a result.
    final bool? added = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (context) => ProductScreen(product: product)),
    );
    if (added == true) {
      setState(() => _cart.add(product));
    }
  }

  Future<void> _openCheckout() async {
    // 3: a named route. `arguments` can be any object.
    final Object? placed = await Navigator.pushNamed(
      context,
      CheckoutScreen.routeName,
      arguments: List<Product>.of(_cart),
    );
    // After an await, check the screen is still showing before using context.
    if (placed == true && mounted) {
      setState(_cart.clear);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Order placed. Thank you!')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shop'),
        actions: [
          IconButton(
            tooltip: 'Cart',
            onPressed: _cart.isEmpty ? null : _openCheckout,
            icon: Badge(
              label: Text('${_cart.length}'),
              isLabelVisible: _cart.isNotEmpty,
              child: const Icon(Icons.shopping_cart),
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          for (final product in products)
            ListTile(
              leading: Icon(product.icon),
              title: Text(product.name),
              subtitle: Text('₱${product.price.toStringAsFixed(2)}'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _openProduct(product),
            ),
        ],
      ),
    );
  }
}

class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    // Scaffold adds the back arrow for us because there is a screen below.
    return Scaffold(
      appBar: AppBar(title: Text(product.name)),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(product.icon, size: 96),
            Text(
              '₱${product.price.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              icon: const Icon(Icons.add_shopping_cart),
              label: const Text('Add to cart'),
              // Pop with a result for the screen that pushed us.
              onPressed: () => Navigator.pop(context, true),
            ),
          ],
        ),
      ),
    );
  }
}

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  static const String routeName = '/checkout';

  Future<void> _placeOrder(BuildContext context, double total) async {
    // 4: showDialog returns whatever the dialog pops with.
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Place order?'),
        content: Text('You will pay ₱${total.toStringAsFixed(2)}.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Place order'),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Named routes receive their data through the route's settings.
    final List<Product> cart =
        ModalRoute.of(context)!.settings.arguments as List<Product>;
    final double total = cart.fold(0, (sum, p) => sum + p.price);

    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: ListView(
        children: [
          for (final product in cart)
            ListTile(
              leading: Icon(product.icon),
              title: Text(product.name),
              trailing: Text('₱${product.price.toStringAsFixed(2)}'),
            ),
          const Divider(),
          ListTile(
            title: const Text('Total'),
            trailing: Text(
              '₱${total.toStringAsFixed(2)}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: FilledButton(
              onPressed: () => _placeOrder(context, total),
              child: const Text('Place order'),
            ),
          ),
        ],
      ),
    );
  }
}

// Slides 48–52: Drawer navigation.
//
// Two ways to use a drawer item:
// 1. Swap the body of this same screen (what slide 42 describes).
//    Close the drawer first with Navigator.pop(context).
// 2. Push a new screen on top (what slides 51–52 do with pushNamed).
//    The new screen gets a back arrow instead of the hamburger.
//
// Try it: open the drawer, pick each page, then open Settings and go back.

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

// Slide 57: Bottom navigation, the Material 3 way.
//
// NavigationBar is the Material 3 widget made for bottom navigation.
// We store the selected index ourselves and show the matching page.
//
// Try it: tap + on Home, switch to Search and back. The count is still there
// because IndexedStack keeps every page alive and only shows one.
// Turn "Keep pages alive" off and try again.

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

// Slide 57: a TabBar at the bottom, done safely.
//
// Slide 57 puts a TabBar inside Material(color: colorScheme.primary).
// In Material 3 (the default since Flutter 3.16) a TabBar draws the selected
// tab in colorScheme.primary too, so the selected tab becomes invisible.
// Fix: set labelColor, unselectedLabelColor and indicatorColor.
//
// Try it: switch "Use slide 57 colours" on and look for the selected tab.

class BottomTabBarDemo extends StatefulWidget {
  const BottomTabBarDemo({super.key});

  @override
  State<BottomTabBarDemo> createState() => _BottomTabBarDemoState();
}

class _BottomTabBarDemoState extends State<BottomTabBarDemo> {
  bool _slideColours = false;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;

    const List<Tab> tabs = [
      Tab(icon: Icon(Icons.looks_one), text: 'Show A'),
      Tab(icon: Icon(Icons.looks_two), text: 'Show B'),
      Tab(icon: Icon(Icons.looks_3), text: 'Show C'),
    ];

    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(title: const Text('TabBar at the bottom')),
        body: TabBarView(
          children: [
            for (final name in ['A', 'B', 'C'])
              ListView(
                children: [
                  const SizedBox(height: 120),
                  Center(child: Text("I'm widget $name")),
                  SwitchListTile(
                    title: const Text('Use slide 57 colours'),
                    value: _slideColours,
                    onChanged: (value) => setState(() => _slideColours = value),
                  ),
                ],
              ),
          ],
        ),
        bottomNavigationBar: Material(
          color: colors.primary,
          child: SafeArea(
            child: _slideColours
                ? const TabBar(tabs: tabs)
                : TabBar(
                    labelColor: colors.onPrimary,
                    unselectedLabelColor: colors.onPrimary.withValues(
                      alpha: 0.7,
                    ),
                    indicatorColor: colors.onPrimary,
                    tabs: tabs,
                  ),
          ),
        ),
      ),
    );
  }
}

// Not in the deck yet: the Stack *widget*.
//
// The outline lists "Stack" under Navigation, meaning the stack of screens
// that Navigator pushes and pops. Flutter also has a Stack *layout widget*
// that piles children on top of each other. Students mix the two up, so
// show both by name.
//
// Try it: drag the sliders to move the badge with Positioned.

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
