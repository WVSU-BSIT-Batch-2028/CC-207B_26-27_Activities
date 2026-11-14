// ===========================================================================
// CC 206 · 5.2 FLUTTER BASICS · every concept in ONE Dart file
// ===========================================================================
//
// How to run
//   * DartPad: open https://dartpad.dev, paste this whole file, press Run.
//   * Flutter project: replace lib/main.dart with this file, then `flutter run`.
//
// The app opens a menu with one screen per topic, in the same order as the
// slides. Search this file for "SECTION 7" (for example) to jump to a topic.
//
//  #  Screen                          Slides it goes with
//  1  Declarative UI & the lifecycle  Declarative UI: UI = f(state) · What Does setState() Do? · The StatefulWidget Lifecycle
//  2  Stateless vs Stateful           Stateless or Stateful? · setState
//  3  BuildContext                    BuildContext, Explained
//  4  Constraints & axes              Constraints Down, Sizes Up · Main Axis vs Cross Axis
//  5  Layout widgets                  Layout: Column, Row, Padding, Expanded, Container
//  6  Displaying content              Small Widgets, Combined · Match Content to Widgets · Visual Hierarchy
//  7  Theme & logical pixels          Style Through the Theme · Logical Pixels & Resolution
//  8  Text, icons & images            Value widgets: Text, Icon, Image, BoxFit
//  9  Four states of content          The Four States of Content
// 10  Lazy lists                      Lazy Lists: ListView.builder
// 11  Responsive layout               Responsive Content
// 12  Accessibility                   Accessible Content
// 13  Text fields                     Inputs Follow One Loop · TextField
// 14  Choosing the right input        Choosing the Right Input
// 15  Selection inputs                Checkbox, Switch, Radio, Slider, Dropdown
// 16  Forms & validation              Form, TextFormField, validators
// 17  When errors appear              When Should Errors Appear?
// 18  Affordance & feedback           Affordance and Feedback
// 19  Buttons                         Buttons
// 20  Gestures                        Dismissible, GestureDetector
// 21  Gesture arena                   The Gesture Arena
//
// Note: section 8 uses Image.asset('assets/images/campus.png'). DartPad
// cannot load local files, so those images show a placeholder there. In a
// Flutter project, add the image and list `assets/images/` in pubspec.yaml.
//
// Verified on Flutter 3.47.6 / Dart 3.13.5 (flutter analyze: no issues).
// ===========================================================================

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(const FlutterBasicsApp());

class FlutterBasicsApp extends StatelessWidget {
  const FlutterBasicsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '5.2 Flutter Basics',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.deepOrange),
      home: const TopicMenu(),
    );
  }
}

class Topic {
  const Topic(this.title, this.slides, this.icon, this.screen);

  final String title;
  final String slides;
  final IconData icon;
  final Widget screen;
}

const List<Topic> topics = [
  Topic(
    '1. Declarative UI & the lifecycle',
    'Declarative UI: UI = f(state) · What Does setState() Do? · The StatefulWidget Lifecycle',
    Icons.lightbulb,
    DeclarativeDemo(),
  ),
  Topic(
    '2. Stateless vs Stateful',
    'Stateless or Stateful? · setState',
    Icons.toggle_on,
    CounterDemo(),
  ),
  Topic(
    '3. BuildContext',
    'BuildContext, Explained',
    Icons.account_tree,
    BuildContextDemo(),
  ),
  Topic(
    '4. Constraints & axes',
    'Constraints Down, Sizes Up · Main Axis vs Cross Axis',
    Icons.straighten,
    ConstraintsDemo(),
  ),
  Topic(
    '5. Layout widgets',
    'Layout: Column, Row, Padding, Expanded, Container',
    Icons.dashboard,
    LayoutDemo(),
  ),
  Topic(
    '6. Displaying content',
    'Small Widgets, Combined · Match Content to Widgets · Visual Hierarchy',
    Icons.view_agenda,
    ContentWidgetsDemo(),
  ),
  Topic(
    '7. Theme & logical pixels',
    'Style Through the Theme · Logical Pixels & Resolution',
    Icons.palette,
    ThemeDemo(),
  ),
  Topic(
    '8. Text, icons & images',
    'Value widgets: Text, Icon, Image, BoxFit',
    Icons.image,
    TextIconImageDemo(),
  ),
  Topic(
    '9. Four states of content',
    'The Four States of Content',
    Icons.cloud_download,
    FourStatesDemo(),
  ),
  Topic(
    '10. Lazy lists',
    'Lazy Lists: ListView.builder',
    Icons.format_list_numbered,
    LazyListDemo(),
  ),
  Topic(
    '11. Responsive layout',
    'Responsive Content',
    Icons.devices,
    ResponsiveDemo(),
  ),
  Topic(
    '12. Accessibility',
    'Accessible Content',
    Icons.accessibility_new,
    AccessibilityDemo(),
  ),
  Topic(
    '13. Text fields',
    'Inputs Follow One Loop · TextField',
    Icons.text_fields,
    TextFieldDemo(),
  ),
  Topic(
    '14. Choosing the right input',
    'Choosing the Right Input',
    Icons.tune,
    ChoosingInputsDemo(),
  ),
  Topic(
    '15. Selection inputs',
    'Checkbox, Switch, Radio, Slider, Dropdown',
    Icons.check_box,
    SelectionInputsDemo(),
  ),
  Topic(
    '16. Forms & validation',
    'Form, TextFormField, validators',
    Icons.assignment,
    RegistrationFormDemo(),
  ),
  Topic(
    '17. When errors appear',
    'When Should Errors Appear?',
    Icons.error_outline,
    ValidationTimingDemo(),
  ),
  Topic(
    '18. Affordance & feedback',
    'Affordance and Feedback',
    Icons.touch_app,
    AffordanceDemo(),
  ),
  Topic('19. Buttons', 'Buttons', Icons.smart_button, ButtonsDemo()),
  Topic(
    '20. Gestures',
    'Dismissible, GestureDetector',
    Icons.swipe,
    GesturesDemo(),
  ),
  Topic(
    '21. Gesture arena',
    'The Gesture Arena',
    Icons.sports_mma,
    GestureArenaDemo(),
  ),
];

class TopicMenu extends StatelessWidget {
  const TopicMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('5.2 Flutter Basics')),
      body: ListView(
        children: [
          for (final topic in topics)
            ListTile(
              leading: Icon(topic.icon),
              title: Text(topic.title),
              subtitle: Text(topic.slides),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.of(context)
                  .push(MaterialPageRoute<void>(builder: (_) => topic.screen)),
            ),
        ],
      ),
    );
  }
}

// ===========================================================================
// SECTION 1: DECLARATIVE UI & THE LIFECYCLE
// Slides: Declarative UI: UI = f(state) · What Does setState() Do? · The StatefulWidget Lifecycle
// ===========================================================================

// 5.2 concept slides: "Declarative UI: UI = f(state)", "What Does setState()
// Do?" and "The StatefulWidget Lifecycle".
//
// Part 1: every part of the screen is computed from ONE variable, _isOn.
//         We never say "make the bulb yellow"; we change the state and
//         build() describes what the screen should look like now.
// Part 2: a child widget writes each lifecycle method to a log as it runs.
//         Show the child, change its colour, then hide it, and read the log.

class DeclarativeDemo extends StatefulWidget {
  const DeclarativeDemo({super.key});

  @override
  State<DeclarativeDemo> createState() => _DeclarativeDemoState();
}

class _DeclarativeDemoState extends State<DeclarativeDemo> {
  // ---- Part 1 state ----
  bool _isOn = false;

  // ---- Part 2 state ----
  bool _showChild = true;
  Color _childColor = Colors.teal;
  // The log lives in a ValueNotifier so that adding a line redraws only the
  // log box, not this whole screen (which would rebuild the child, which
  // would log "build()" again, forever).
  final ValueNotifier<List<String>> _log = ValueNotifier([]);

  void _addLog(String line) {
    // Called from the child's lifecycle methods. We must not change other
    // widgets while a frame is being built, so we update after the frame.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _log.value = [..._log.value, line];
    });
  }

  @override
  void dispose() {
    _log.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // UI = f(state): each value below is calculated from _isOn.
    final bulbColor = _isOn ? Colors.amber : Colors.grey.shade400;
    final label = _isOn ? 'The light is ON' : 'The light is OFF';
    final background = _isOn ? Colors.yellow.shade50 : Colors.blueGrey.shade50;

    return Scaffold(
      appBar: AppBar(title: const Text('Declarative UI & lifecycle')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            '1. UI = f(state)',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.all(16),
            color: background,
            child: Column(
              children: [
                Icon(Icons.lightbulb, size: 80, color: bulbColor),
                Text(label),
                Switch(
                  value: _isOn,
                  // The only thing the switch does is change the state.
                  // setState() tells Flutter "build() again, the data changed".
                  onChanged: (value) => setState(() => _isOn = value),
                ),
              ],
            ),
          ),
          const Divider(height: 32),
          Text(
            '2. The StatefulWidget lifecycle',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Wrap(
            spacing: 8,
            children: [
              FilledButton(
                onPressed: () => setState(() => _showChild = !_showChild),
                child: Text(_showChild ? 'Hide child' : 'Show child'),
              ),
              OutlinedButton(
                onPressed: _showChild
                    ? () => setState(
                        () => _childColor = _childColor == Colors.teal
                            ? Colors.deepOrange
                            : Colors.teal,
                      )
                    : null,
                child: const Text('Change colour'),
              ),
              TextButton(
                onPressed: () => _log.value = [],
                child: const Text('Clear log'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (_showChild) LifecycleBox(color: _childColor, onLog: _addLog),
          const SizedBox(height: 8),
          ValueListenableBuilder<List<String>>(
            valueListenable: _log,
            builder: (context, lines, _) => Container(
              padding: const EdgeInsets.all(8),
              color: Colors.black87,
              child: Text(
                lines.isEmpty ? '(log is empty)' : lines.join('\n'),
                key: const Key('lifecycle-log'),
                style: const TextStyle(
                  color: Colors.greenAccent,
                  fontFamily: 'monospace',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// The child whose lifecycle we watch.
class LifecycleBox extends StatefulWidget {
  const LifecycleBox({super.key, required this.color, required this.onLog});

  final Color color;
  final void Function(String line) onLog;

  @override
  State<LifecycleBox> createState() => _LifecycleBoxState();
}

class _LifecycleBoxState extends State<LifecycleBox> {
  int _taps = 0;

  @override
  void initState() {
    super.initState();
    // Runs ONCE, when the State is created. Start timers, controllers,
    // listeners and first data loads here.
    widget.onLog('initState()');
  }

  @override
  void didUpdateWidget(LifecycleBox oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Runs when the parent rebuilds and hands us a new widget (for example
    // a new colour). The State object is kept, so _taps is not lost.
    widget.onLog('didUpdateWidget()');
  }

  @override
  void dispose() {
    // Runs ONCE, when the widget leaves the screen for good.
    // Dispose controllers and cancel timers here.
    widget.onLog('dispose()');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    widget.onLog('build()');
    return Material(
      color: widget.color,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => setState(() => _taps++),
        child: SizedBox(
          height: 80,
          child: Center(
            child: Text(
              'Child widget: tapped $_taps times (tap me)',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}

// ===========================================================================
// SECTION 2: STATELESS VS STATEFUL
// Slides: Stateless or Stateful? · setState
// ===========================================================================

// 5.2 Widgets: StatelessWidget vs StatefulWidget, setState, and the
// State lifecycle (initState -> build -> dispose).
//
// Try this in class: change the step from 1 to 2 and press "r" (hot reload).
// The count on screen stays the same, because hot reload keeps the State.
// Press "R" (hot restart) and the count goes back to 0.

// A StatelessWidget has no data that changes over time.
// It only shows what its constructor was given.
class Greeting extends StatelessWidget {
  const Greeting({super.key, required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Text(
      'Hello, $name!',
      style: Theme.of(context).textTheme.headlineSmall,
    );
  }
}

// A StatefulWidget is two classes:
//   1. the widget (immutable configuration), and
//   2. its State object (data that can change, plus build()).
class CounterDemo extends StatefulWidget {
  const CounterDemo({super.key});

  @override
  State<CounterDemo> createState() => _CounterDemoState();
}

class _CounterDemoState extends State<CounterDemo> {
  int _count = 0; // the "state": data needed to build the UI

  @override
  void initState() {
    super.initState();
    // Runs ONCE when the State is created. Start timers,
    // create controllers, or load data here.
    debugPrint('initState');
  }

  void _increment() {
    // setState tells Flutter "my data changed, please call build() again".
    // Without setState, _count changes but the screen does NOT update.
    setState(() {
      _count++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // build() can run many times (after every setState, when the parent
    // rebuilds, when the theme changes...). Keep it fast and side-effect free.
    debugPrint('build: count = $_count');
    return Scaffold(
      appBar: AppBar(title: const Text('Stateless vs Stateful')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Greeting(name: 'CC 206'),
            const SizedBox(height: 24),
            const Text('You have pressed the button this many times:'),
            Text('$_count', style: Theme.of(context).textTheme.displayMedium),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _increment,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }

  @override
  void dispose() {
    // Runs when the widget is removed for good. Clean up controllers,
    // timers and listeners here.
    debugPrint('dispose');
    super.dispose();
  }
}

// ===========================================================================
// SECTION 3: BUILDCONTEXT
// Slides: BuildContext, Explained
// ===========================================================================

// 5.2 concept slide: "BuildContext, Explained".
//
// A BuildContext is a widget's position in the widget tree. Calls like
// Theme.of(context) walk UP the tree from that position until they find
// the nearest Theme, MediaQuery, Scaffold, ...
//
// The classic beginner bug is shown at the bottom: using a context that
// sits ABOVE the Scaffold, so Scaffold.of(context) finds nothing.

class BuildContextDemo extends StatelessWidget {
  const BuildContextDemo({super.key});

  @override
  Widget build(BuildContext context) {
    // This `context` belongs to BuildContextDemo, which is ABOVE the Scaffold
    // it creates below.
    final colors = Theme.of(context).colorScheme; // nearest Theme
    final size = MediaQuery.sizeOf(context); // nearest MediaQuery

    return Scaffold(
      appBar: AppBar(title: const Text('BuildContext')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            leading: CircleAvatar(backgroundColor: colors.primary),
            title: const Text('Theme.of(context).colorScheme.primary'),
            subtitle: const Text('Found by looking up the tree for a Theme'),
          ),
          ListTile(
            leading: const Icon(Icons.aspect_ratio),
            title: Text(
              'Screen: ${size.width.round()} x ${size.height.round()}',
            ),
            subtitle: const Text('MediaQuery.sizeOf(context)'),
          ),
          const Divider(),
          // A nested Theme: widgets below it get a different Theme.of(context).
          Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink),
            ),
            child: const ThemedSwatch(label: 'Inside a nested pink Theme'),
          ),
          const ThemedSwatch(label: 'Outside it (app Theme)'),
          const Divider(),
          // ScaffoldMessenger is above every Scaffold, so this context works.
          FilledButton(
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Found the ScaffoldMessenger!')),
            ),
            child: const Text('Show SnackBar'),
          ),
          const SizedBox(height: 8),
          // WRONG: this context is above our Scaffold, so Scaffold.of fails.
          OutlinedButton(
            onPressed: () {
              final scaffold = Scaffold.maybeOf(context);
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text(
                      scaffold == null
                          ? 'Wrong context: no Scaffold above it'
                          : 'Found a Scaffold',
                    ),
                  ),
                );
            },
            child: const Text('Scaffold.of with the WRONG context'),
          ),
          const SizedBox(height: 8),
          // RIGHT: Builder gives us a new context that sits INSIDE the Scaffold.
          Builder(
            builder: (innerContext) => OutlinedButton(
              onPressed: () {
                final scaffold = Scaffold.maybeOf(innerContext);
                ScaffoldMessenger.of(innerContext)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      content: Text(
                        scaffold == null
                            ? 'Wrong context: no Scaffold above it'
                            : 'Right context: found the Scaffold',
                      ),
                    ),
                  );
              },
              child: const Text('Scaffold.of with a Builder context'),
            ),
          ),
        ],
      ),
    );
  }
}

// A small widget that reads whatever Theme is closest to where it is placed.
class ThemedSwatch extends StatelessWidget {
  const ThemedSwatch({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Card(
      color: colors.primaryContainer,
      child: ListTile(
        leading: Icon(Icons.palette, color: colors.primary),
        title: Text(label),
      ),
    );
  }
}

// ===========================================================================
// SECTION 4: CONSTRAINTS & AXES
// Slides: Constraints Down, Sizes Up · Main Axis vs Cross Axis
// ===========================================================================

// 5.2 concept slides: "Constraints Down, Sizes Up" and
// "Main Axis vs Cross Axis".
//
// The layout rule: constraints go DOWN (parent tells child the min/max size),
// sizes go UP (child picks a size inside those limits), and the parent
// decides the POSITION.
//
// Tab 1 shows the rule with LayoutBuilder printing the constraints a child
// receives, plus the famous "RenderFlex overflowed" fix.
// Tab 2 is a playground: pick mainAxisAlignment / crossAxisAlignment and
// switch between Row and Column to see which way each axis runs.

class ConstraintsDemo extends StatelessWidget {
  const ConstraintsDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Constraints & axes'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Constraints'),
              Tab(text: 'Axis playground'),
            ],
          ),
        ),
        body: const TabBarView(children: [ConstraintsTab(), AxisPlayground()]),
      ),
    );
  }
}

// Shows the constraints a child receives, as text inside the child.
class ConstraintsLabel extends StatelessWidget {
  const ConstraintsLabel({super.key, this.color = Colors.orange});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        String fmt(double v) => v.isInfinite ? 'inf' : v.round().toString();
        return Container(
          color: color.withValues(alpha: 0.3),
          padding: const EdgeInsets.all(4),
          child: Text(
            'w ${fmt(constraints.minWidth)}..${fmt(constraints.maxWidth)}\n'
            'h ${fmt(constraints.minHeight)}..${fmt(constraints.maxHeight)}',
            style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
          ),
        );
      },
    );
  }
}

class ConstraintsTab extends StatelessWidget {
  const ConstraintsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final title = Theme.of(context).textTheme.titleMedium;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('Tight: SizedBox(120 x 60) forces one exact size', style: title),
        // Align is needed here: a ListView forces every child to its full
        // width, which would override our 120 (the parent always wins).
        // Remove the Align and hot reload to see it.
        const Align(
          alignment: Alignment.centerLeft,
          child: SizedBox(width: 120, height: 60, child: ConstraintsLabel()),
        ),
        const SizedBox(height: 16),
        Text(
          'Loose: Center lets the child be any size up to the max',
          style: title,
        ),
        const SizedBox(
          height: 80,
          child: Center(child: ConstraintsLabel(color: Colors.green)),
        ),
        const SizedBox(height: 16),
        Text('A Row gives children unlimited width (w ..inf)', style: title),
        const Row(children: [ConstraintsLabel(color: Colors.blue)]),
        const SizedBox(height: 16),
        Text('Expanded turns that into a tight, finite width', style: title),
        const Row(
          children: [Expanded(child: ConstraintsLabel(color: Colors.purple))],
        ),
        const SizedBox(height: 24),
        Text('Overflow fix', style: title),
        const Text(
          'A long Text in a Row asks for more width than the screen has, '
          'so Flutter paints a yellow-black "overflowed" stripe. Wrapping it '
          'in Expanded gives it the remaining width, so it wraps instead.',
        ),
        const SizedBox(height: 8),
        const Card(
          child: Padding(
            padding: EdgeInsets.all(8),
            child: Row(
              children: [
                Icon(Icons.info),
                SizedBox(width: 8),
                // Remove this Expanded and hot reload to see the overflow.
                Expanded(
                  child: Text(
                    'This sentence is far too long to fit on a single line of a '
                    'phone screen, so without Expanded it would overflow the Row.',
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class AxisPlayground extends StatefulWidget {
  const AxisPlayground({super.key});

  @override
  State<AxisPlayground> createState() => _AxisPlaygroundState();
}

class _AxisPlaygroundState extends State<AxisPlayground> {
  bool _isRow = true;
  MainAxisAlignment _main = MainAxisAlignment.start;
  CrossAxisAlignment _cross = CrossAxisAlignment.center;

  @override
  Widget build(BuildContext context) {
    // Three boxes of different sizes so cross-axis alignment is visible.
    final children = [
      _box(Colors.red, 40),
      _box(Colors.green, 60),
      _box(Colors.blue, 80),
    ];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        SegmentedButton<bool>(
          segments: const [
            ButtonSegment(
              value: true,
              label: Text('Row'),
              icon: Icon(Icons.east),
            ),
            ButtonSegment(
              value: false,
              label: Text('Column'),
              icon: Icon(Icons.south),
            ),
          ],
          selected: {_isRow},
          onSelectionChanged: (s) => setState(() => _isRow = s.first),
        ),
        const SizedBox(height: 8),
        Text(
          _isRow
              ? 'Row: main axis runs left to right, cross axis top to bottom.'
              : 'Column: main axis runs top to bottom, cross axis left to right.',
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<MainAxisAlignment>(
          initialValue: _main,
          decoration: const InputDecoration(labelText: 'mainAxisAlignment'),
          items: [
            for (final m in MainAxisAlignment.values)
              DropdownMenuItem(value: m, child: Text(m.name)),
          ],
          onChanged: (m) => setState(() => _main = m!),
        ),
        DropdownButtonFormField<CrossAxisAlignment>(
          initialValue: _cross,
          decoration: const InputDecoration(labelText: 'crossAxisAlignment'),
          items: [
            // baseline only works with text, so we leave it out here.
            for (final c in CrossAxisAlignment.values)
              if (c != CrossAxisAlignment.baseline)
                DropdownMenuItem(value: c, child: Text(c.name)),
          ],
          onChanged: (c) => setState(() => _cross = c!),
        ),
        const SizedBox(height: 16),
        Container(
          height: 240,
          decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
          child: _isRow
              ? Row(
                  mainAxisAlignment: _main,
                  crossAxisAlignment: _cross,
                  children: children,
                )
              : Column(
                  mainAxisAlignment: _main,
                  crossAxisAlignment: _cross,
                  children: children,
                ),
        ),
        const SizedBox(height: 8),
        Text(
          '${_isRow ? 'Row' : 'Column'}(mainAxisAlignment: ${_main.name}, '
          'crossAxisAlignment: ${_cross.name})',
          key: const Key('axis-code'),
          style: const TextStyle(fontFamily: 'monospace'),
        ),
      ],
    );
  }

  Widget _box(Color color, double size) =>
      Container(width: size, height: size, color: color);
}

// ===========================================================================
// SECTION 5: LAYOUT WIDGETS
// Slides: Layout: Column, Row, Padding, Expanded, Container
// ===========================================================================

// 5.2 Layout widgets: Column, Row, Padding, SizedBox, Expanded, Container.
// These are used in every other example, so they come first.

class LayoutDemo extends StatelessWidget {
  const LayoutDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Layout Basics')),
      // Padding adds space around its child
      body: Padding(
        padding: const EdgeInsets.all(16),
        // Column stacks children vertically
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Container = padding + color/border/radius + size, in one widget
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                border: Border.all(color: Colors.blue),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text('Container with padding, border and radius'),
            ),
            const SizedBox(height: 16), // fixed empty space
            // Row places children side by side
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(Icons.home, size: 40),
                Icon(Icons.school, size: 40),
                Icon(Icons.person, size: 40),
              ],
            ),
            const SizedBox(height: 16),

            // Expanded shares the leftover space. flex sets the ratio.
            Row(
              children: [
                Expanded(flex: 2, child: _ColorBox(Colors.red, 'flex: 2')),
                Expanded(flex: 1, child: _ColorBox(Colors.green, 'flex: 1')),
              ],
            ),
            const SizedBox(height: 16),

            // Expanded in a Column fills the remaining height
            Expanded(
              child: _ColorBox(Colors.orange, 'Expanded fills the rest'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ColorBox extends StatelessWidget {
  const _ColorBox(this.color, this.label);

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      color: color,
      alignment: Alignment.center,
      child: Text(label, style: const TextStyle(color: Colors.white)),
    );
  }
}

// ===========================================================================
// SECTION 6: DISPLAYING CONTENT
// Slides: Small Widgets, Combined · Match Content to Widgets · Visual Hierarchy
// ===========================================================================

// 5.2 concept slides: "Small Widgets, Combined", "Match Content to Widgets"
// and "Visual Hierarchy".
//
// Tab 1 builds one CourseCard out of small widgets you already know.
// Tab 2 shows which widget fits which kind of content.
// Tab 3 shows the same information with and without visual hierarchy.

class ContentWidgetsDemo extends StatelessWidget {
  const ContentWidgetsDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Displaying content'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Compose'),
              Tab(text: 'Match'),
              Tab(text: 'Hierarchy'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [ComposeTab(), MatchContentTab(), HierarchyTab()],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 1. Small widgets, combined
// ---------------------------------------------------------------------------

class Course {
  const Course(this.code, this.title, this.units, this.progress);

  final String code;
  final String title;
  final int units;
  final double progress; // 0.0 to 1.0
}

const courses = [
  Course('CC 206', 'Application Development', 3, 0.6),
  Course('CC 205', 'Data Structures', 3, 0.85),
  Course('GE 104', 'Mathematics in the Modern World', 3, 0.3),
];

// CourseCard = Card + Padding + Column + Row + CircleAvatar + Text + Chip
//              + LinearProgressIndicator. No new tricks, only combination.
// Because it is its own widget, we can reuse it for every course.
class CourseCard extends StatelessWidget {
  const CourseCard({super.key, required this.course});

  final Course course;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(child: Text(course.code.substring(0, 2))),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(course.title, style: text.titleMedium),
                      Text(course.code, style: text.bodySmall),
                    ],
                  ),
                ),
                Chip(label: Text('${course.units} units')),
              ],
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(value: course.progress),
            const SizedBox(height: 4),
            Text(
              '${(course.progress * 100).round()}% complete',
              style: text.labelSmall,
            ),
          ],
        ),
      ),
    );
  }
}

class ComposeTab extends StatelessWidget {
  const ComposeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [for (final course in courses) CourseCard(course: course)],
    );
  }
}

// ---------------------------------------------------------------------------
// 2. Match content to widgets
// ---------------------------------------------------------------------------

class MatchContentTab extends StatelessWidget {
  const MatchContentTab({super.key});

  @override
  Widget build(BuildContext context) {
    final heading = Theme.of(context).textTheme.titleMedium;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('Mixed-style text  →  Text.rich', style: heading),
        const Text.rich(
          TextSpan(
            children: [
              TextSpan(text: 'Deadline: '),
              TextSpan(
                text: 'Friday, 5 PM',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              TextSpan(text: ' (late work is not accepted)'),
            ],
          ),
        ),
        const Divider(height: 32),
        Text('One item with title + details  →  ListTile', style: heading),
        const ListTile(
          leading: Icon(Icons.person),
          title: Text('Juan Dela Cruz'),
          subtitle: Text('BSCS 2-A'),
          trailing: Icon(Icons.chevron_right),
        ),
        const Divider(height: 32),
        Text('Short tags or filters  →  Chip', style: heading),
        const Wrap(
          spacing: 8,
          children: [
            Chip(label: Text('Flutter')),
            Chip(label: Text('Dart')),
            Chip(avatar: Icon(Icons.star, size: 18), label: Text('Required')),
          ],
        ),
        const Divider(height: 32),
        Text('Many items you compare at a glance  →  GridView', style: heading),
        GridView.count(
          crossAxisCount: 4,
          shrinkWrap: true, // OK for a few items inside a ListView
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          children: [
            for (final icon in [
              Icons.home,
              Icons.school,
              Icons.book,
              Icons.calendar_month,
              Icons.map,
              Icons.chat,
              Icons.settings,
              Icons.person,
            ])
              Container(
                color: Theme.of(context).colorScheme.secondaryContainer,
                child: Icon(icon),
              ),
          ],
        ),
        const Divider(height: 32),
        Text('Rows and columns of data  →  DataTable', style: heading),
        DataTable(
          columns: const [
            DataColumn(label: Text('Student')),
            DataColumn(label: Text('Quiz'), numeric: true),
          ],
          rows: const [
            DataRow(cells: [DataCell(Text('Ana')), DataCell(Text('18'))]),
            DataRow(cells: [DataCell(Text('Ben')), DataCell(Text('15'))]),
          ],
        ),
        const Divider(height: 32),
        Text('Progress  →  progress indicators', style: heading),
        const Row(
          children: [
            CircularProgressIndicator(), // unknown length: spinner
            SizedBox(width: 16),
            Expanded(child: LinearProgressIndicator(value: 0.7)), // known: 70%
          ],
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// 3. Visual hierarchy
// ---------------------------------------------------------------------------

class HierarchyTab extends StatelessWidget {
  const HierarchyTab({super.key});

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('Flat: everything looks equally important'),
        const Card(
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Midterm Exam'),
                Text('October 20'),
                Text('Room 301'),
                Text('Bring a calculator and a blue pen'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        const Text('With hierarchy: size, weight, colour and spacing'),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1st: what is it? Biggest text.
                Text('Midterm Exam', style: text.headlineSmall),
                const SizedBox(height: 4),
                // 2nd: when and where. Medium, coloured.
                Text(
                  'October 20  ·  Room 301',
                  style: text.titleMedium?.copyWith(color: colors.primary),
                ),
                const SizedBox(height: 12),
                // 3rd: details. Small and quieter.
                Text(
                  'Bring a calculator and a blue pen',
                  style: text.bodyMedium?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'The textTheme scale (use these, not random font sizes):',
          style: text.titleSmall,
        ),
        for (final (name, style) in [
          ('displaySmall', text.displaySmall),
          ('headlineSmall', text.headlineSmall),
          ('titleLarge', text.titleLarge),
          ('titleMedium', text.titleMedium),
          ('bodyLarge', text.bodyLarge),
          ('bodyMedium', text.bodyMedium),
          ('labelSmall', text.labelSmall),
        ])
          Text(name, style: style),
      ],
    );
  }
}

// ===========================================================================
// SECTION 7: THEME & LOGICAL PIXELS
// Slides: Style Through the Theme · Logical Pixels & Resolution
// ===========================================================================

// 5.2 concept slides: "Style Through the Theme" and
// "Logical Pixels & Resolution".
//
// Style is set ONCE in ThemeData. Widgets read colours and text styles from
// the theme, so changing the seed colour or switching to dark mode restyles
// the whole app without touching any widget.

// In a real app the theme goes on MaterialApp, once, at the top:
//
//   MaterialApp(
//     theme: ThemeData(colorSchemeSeed: Colors.indigo),
//     darkTheme: ThemeData(
//         colorSchemeSeed: Colors.indigo, brightness: Brightness.dark),
//     themeMode: ThemeMode.system, // follow the phone's setting
//     home: ...,
//   )
//
// Here we wrap one screen in a Theme widget instead, so the example can
// change its own theme while it runs inside the examples menu.
class ThemeDemo extends StatefulWidget {
  const ThemeDemo({super.key});

  @override
  State<ThemeDemo> createState() => _ThemeDemoState();
}

class _ThemeDemoState extends State<ThemeDemo> {
  Color _seed = Colors.indigo;
  bool _dark = false;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        colorSchemeSeed: _seed,
        brightness: _dark ? Brightness.dark : Brightness.light,
      ),
      child: ThemeDemoHome(
        seed: _seed,
        dark: _dark,
        onSeedChanged: (c) => setState(() => _seed = c),
        onDarkChanged: (d) => setState(() => _dark = d),
      ),
    );
  }
}

class ThemeDemoHome extends StatelessWidget {
  const ThemeDemoHome({
    super.key,
    required this.seed,
    required this.dark,
    required this.onSeedChanged,
    required this.onDarkChanged,
  });

  final Color seed;
  final bool dark;
  final ValueChanged<Color> onSeedChanged;
  final ValueChanged<bool> onDarkChanged;

  static const seeds = {
    'Indigo': Colors.indigo,
    'Orange': Colors.deepOrange,
    'Green': Colors.green,
    'Pink': Colors.pink,
  };

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    // Logical pixels: Flutter sizes are in logical pixels (about 1/160 inch),
    // NOT in the screen's physical pixels.
    final size = MediaQuery.sizeOf(context);
    final ratio = MediaQuery.devicePixelRatioOf(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Theme & logical pixels')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Seed colour', style: text.titleMedium),
          Wrap(
            spacing: 8,
            children: [
              for (final entry in seeds.entries)
                ChoiceChip(
                  label: Text(entry.key),
                  selected: seed == entry.value,
                  onSelected: (_) => onSeedChanged(entry.value),
                ),
            ],
          ),
          SwitchListTile(
            title: const Text('Dark mode'),
            value: dark,
            onChanged: onDarkChanged,
          ),
          const Divider(),
          Text(
            'These widgets set NO colours themselves:',
            style: text.titleMedium,
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              FilledButton(onPressed: () {}, child: const Text('Filled')),
              OutlinedButton(onPressed: () {}, child: const Text('Outlined')),
              const Chip(label: Text('Chip')),
              Checkbox(value: true, onChanged: (_) {}),
            ],
          ),
          const SizedBox(height: 8),
          const Card(
            child: ListTile(
              leading: Icon(Icons.school),
              title: Text('A Card with a ListTile'),
              subtitle: Text('Colours come from Theme.of(context)'),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'When you do need a colour, take it from the colorScheme:',
            style: text.bodyMedium,
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.all(12),
            color: colors.primaryContainer,
            child: Text(
              'color: colorScheme.primaryContainer\n'
              'text:  colorScheme.onPrimaryContainer',
              style: TextStyle(color: colors.onPrimaryContainer),
            ),
          ),
          const Divider(height: 32),
          Text('Logical pixels', style: text.titleMedium),
          Text(
            'Screen size: ${size.width.round()} x ${size.height.round()} '
            'logical pixels',
          ),
          Text(
            'devicePixelRatio: ${ratio.toStringAsFixed(2)} '
            '(physical pixels per logical pixel)',
          ),
          Text(
            'Physical size: ${(size.width * ratio).round()} x '
            '${(size.height * ratio).round()} pixels',
          ),
          const SizedBox(height: 8),
          const Text(
            'This box is 100 x 100 logical pixels. It is about the '
            'same real size on every phone, whatever its resolution.',
          ),
          const SizedBox(height: 8),
          Container(width: 100, height: 100, color: colors.tertiary),
        ],
      ),
    );
  }
}

// ===========================================================================
// SECTION 8: TEXT, ICONS & IMAGES
// Slides: Value widgets: Text, Icon, Image, BoxFit
// ===========================================================================

// 5.2 Value widgets: Text, Icon, Image.asset, Image.network, BoxFit.
//
// For Image.asset to work, pubspec.yaml must list the asset folder:
//
//   flutter:
//     uses-material-design: true
//     assets:
//       - assets/images/        # the whole folder (note the trailing /)
//
// The path in code must match the path in pubspec.yaml exactly.
// Android RELEASE builds also need
//   <uses-permission android:name="android.permission.INTERNET"/>
// in android/app/src/main/AndroidManifest.xml for Image.network.

const String networkImageUrl = 'https://picsum.photos/id/1011/600/400';

class TextIconImageDemo extends StatelessWidget {
  const TextIconImageDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Text, Icons & Images')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ---- Text ----
          // const: this widget never changes, so Flutter creates it once
          // and can skip rebuilding it.
          const Text('Hello world'),
          const Text(
            'Styled text',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.indigo,
            ),
          ),
          Text(
            'Text from the app theme',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const Text(
            'A very long sentence that will be cut off with an ellipsis '
            'instead of wrapping onto many lines.',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const Divider(height: 32),

          // ---- Icon ----
          // Icons are font glyphs (vectors), so they stay sharp at any size.
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Icon(Icons.cake, color: Colors.red, size: 48),
              Icon(Icons.favorite, color: Colors.pink, size: 48),
              Icon(Icons.school, color: Colors.blue, size: 48),
            ],
          ),
          const Divider(height: 32),

          // ---- Image.asset: bundled inside the app ----
          const Text('Image.asset (bundled with the app)'),
          const SizedBox(height: 8),
          Image.asset(
            'assets/images/campus.png',
            height: 150,
            errorBuilder: (context, error, stack) =>
                const Icon(Icons.broken_image, size: 80),
          ),
          const Divider(height: 32),

          // ---- Image.network: downloaded at runtime ----
          const Text('Image.network (needs internet)'),
          const SizedBox(height: 8),
          Image.network(
            networkImageUrl,
            height: 150,
            // Shown while downloading
            loadingBuilder: (context, child, progress) {
              if (progress == null) return child; // finished loading
              return const SizedBox(
                height: 150,
                child: Center(child: CircularProgressIndicator()),
              );
            },
            // Shown if there is no internet or the URL is wrong
            errorBuilder: (context, error, stackTrace) => const SizedBox(
              height: 150,
              child: Center(child: Icon(Icons.broken_image, size: 48)),
            ),
          ),
          const Divider(height: 32),

          // ---- BoxFit: how an image fills its box (like CSS object-fit) ----
          const Text('BoxFit options in a 120 x 80 box'),
          const SizedBox(height: 8),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              for (final fit in [
                BoxFit.fill,
                BoxFit.cover,
                BoxFit.contain,
                BoxFit.fitWidth,
                BoxFit.fitHeight,
              ])
                Column(
                  children: [
                    Container(
                      width: 120,
                      height: 80,
                      color: Colors.grey.shade300,
                      child: Image.asset(
                        'assets/images/campus.png',
                        fit: fit,
                        errorBuilder: (context, error, stack) =>
                            const Icon(Icons.broken_image),
                      ),
                    ),
                    Text(fit.name),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }
}

// ===========================================================================
// SECTION 9: FOUR STATES OF CONTENT
// Slides: The Four States of Content
// ===========================================================================

// 5.2 concept slide: "The Four States of Content".
//
// Any content that is loaded (from the internet, a database, a file) is in
// one of four states, and the screen needs a design for EACH:
//   1. loading   2. success (has data)   3. empty (loaded, but nothing)   4. error
//
// FutureBuilder rebuilds when the Future finishes and gives us a snapshot
// that tells us which state we are in. Pick what the fake server returns,
// then press "Load".

enum ServerResult { data, empty, error }

// A pretend web service. In real code this would be an http call.
Future<List<String>> fetchAnnouncements(ServerResult result) async {
  await Future<void>.delayed(const Duration(seconds: 2)); // network delay
  return switch (result) {
    ServerResult.data => [
      'No classes on Friday (university event)',
      'Lab 3 deadline moved to Monday',
      'Midterm coverage posted on the class page',
    ],
    ServerResult.empty => <String>[],
    ServerResult.error => throw Exception('No internet connection'),
  };
}

class FourStatesDemo extends StatefulWidget {
  const FourStatesDemo({super.key});

  @override
  State<FourStatesDemo> createState() => _FourStatesDemoState();
}

class _FourStatesDemoState extends State<FourStatesDemo> {
  ServerResult _result = ServerResult.data;

  // Keep the Future in the State. Do NOT call fetchAnnouncements() inside
  // build(): build runs often, and each call would start a new download.
  late Future<List<String>> _future;

  @override
  void initState() {
    super.initState();
    _future = fetchAnnouncements(_result);
  }

  void _load() {
    // Block body on purpose: `setState(() => _future = ...)` would RETURN
    // the Future from the callback, and setState does not allow that.
    setState(() {
      _future = fetchAnnouncements(_result);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('The four states of content')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: SegmentedButton<ServerResult>(
                    segments: const [
                      ButtonSegment(
                        value: ServerResult.data,
                        label: Text('Data'),
                      ),
                      ButtonSegment(
                        value: ServerResult.empty,
                        label: Text('Empty'),
                      ),
                      ButtonSegment(
                        value: ServerResult.error,
                        label: Text('Error'),
                      ),
                    ],
                    selected: {_result},
                    onSelectionChanged: (s) =>
                        setState(() => _result = s.first),
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton(onPressed: _load, child: const Text('Load')),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: FutureBuilder<List<String>>(
              future: _future,
              builder: (context, snapshot) {
                // 1. LOADING: the Future has not finished yet.
                if (snapshot.connectionState != ConnectionState.done) {
                  return const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 12),
                        Text('Loading announcements...'),
                      ],
                    ),
                  );
                }

                // 4. ERROR: say what went wrong and offer a way out.
                if (snapshot.hasError) {
                  return StateMessage(
                    icon: Icons.wifi_off,
                    title: 'Could not load announcements',
                    message: '${snapshot.error}',
                    action: FilledButton.icon(
                      onPressed: _load,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Try again'),
                    ),
                  );
                }

                final items = snapshot.data!;

                // 3. EMPTY: loaded fine, but there is nothing to show.
                if (items.isEmpty) {
                  return const StateMessage(
                    icon: Icons.inbox,
                    title: 'No announcements yet',
                    message: 'New announcements from your teacher appear here.',
                  );
                }

                // 2. SUCCESS: show the data.
                return ListView(
                  children: [
                    for (final item in items)
                      ListTile(
                        leading: const Icon(Icons.campaign),
                        title: Text(item),
                      ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// One reusable layout for the empty and error states.
class StateMessage extends StatelessWidget {
  const StateMessage({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.action,
  });

  final IconData icon;
  final String title;
  final String message;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 64, color: Theme.of(context).colorScheme.outline),
            const SizedBox(height: 12),
            Text(title, style: text.titleMedium),
            const SizedBox(height: 4),
            Text(message, textAlign: TextAlign.center),
            if (action != null) ...[const SizedBox(height: 16), action!],
          ],
        ),
      ),
    );
  }
}

// ===========================================================================
// SECTION 10: LAZY LISTS
// Slides: Lazy Lists: ListView.builder
// ===========================================================================

// 5.2 concept slide: "Lazy Lists: ListView.builder".
//
// ListView(children: [...]) builds EVERY child up front.
// ListView.builder only builds the rows that are on screen (plus a small
// buffer) and builds more as you scroll. That is why it can show
// 10,000 rows without slowing down.
//
// The counter at the top shows how many rows have actually been built.
// Scroll and watch it grow slowly, not jump to 10,000.

class LazyListDemo extends StatefulWidget {
  const LazyListDemo({super.key});

  @override
  State<LazyListDemo> createState() => _LazyListDemoState();
}

class _LazyListDemoState extends State<LazyListDemo> {
  static const itemCount = 10000;

  // Which rows have been built at least once. A ValueNotifier, so updating
  // the counter does not rebuild the list itself.
  final ValueNotifier<int> _builtCount = ValueNotifier(0);
  final Set<int> _built = {};

  void _markBuilt(int index) {
    if (_built.add(index)) {
      // We are inside a build, so update the counter after this frame.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _builtCount.value = _built.length;
      });
    }
  }

  @override
  void dispose() {
    _builtCount.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lazy lists')),
      body: Column(
        children: [
          Material(
            color: Theme.of(context).colorScheme.secondaryContainer,
            child: ValueListenableBuilder<int>(
              valueListenable: _builtCount,
              builder: (context, count, _) => ListTile(
                leading: const Icon(Icons.construction),
                title: Text(
                  'Rows built so far: $count of $itemCount',
                  key: const Key('built-count'),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: itemCount,
              // Called only for rows that are about to appear on screen.
              itemBuilder: (context, index) {
                _markBuilt(index);
                return ListTile(
                  leading: CircleAvatar(child: Text('${index % 100}')),
                  title: Text('Student #${index + 1}'),
                  subtitle: Text(
                    'ID 2026-${(index + 1).toString().padLeft(5, '0')}',
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// For comparison (do NOT do this for long lists): every row is created
// immediately, even the 9,990 rows nobody scrolls to.
//
//   ListView(
//     children: [
//       for (var i = 0; i < 10000; i++) ListTile(title: Text('Student #$i')),
//     ],
//   )
//
// Use ListView.separated(...) when you want a divider between rows, and
// GridView.builder(...) for a lazy grid.

// ===========================================================================
// SECTION 11: RESPONSIVE LAYOUT
// Slides: Responsive Content
// ===========================================================================

// 5.2 concept slide: "Responsive Content".
//
// One app, three layouts, chosen by the space available:
//   width < 600        phone:  list only, NavigationBar at the bottom
//   600 <= width < 1000 tablet: NavigationRail on the left + list
//   width >= 1000       wide:   extended rail + list + detail side by side
//
// LayoutBuilder gives us the constraints from the parent, so the choice is
// based on the space THIS widget gets, not the whole screen.
// Try it: run on Chrome or desktop and resize the window.

const rooms = [
  'Room 301',
  'Room 302',
  'Computer Lab 1',
  'Computer Lab 2',
  'Library',
];

class ResponsiveDemo extends StatefulWidget {
  const ResponsiveDemo({super.key});

  @override
  State<ResponsiveDemo> createState() => _ResponsiveDemoState();
}

class _ResponsiveDemoState extends State<ResponsiveDemo> {
  int _tab = 0;
  int _selectedRoom = 0;

  static const destinations = [
    (Icons.meeting_room, 'Rooms'),
    (Icons.event, 'Schedule'),
    (Icons.person, 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final String sizeClass;
        if (width < 600) {
          sizeClass = 'phone';
        } else if (width < 1000) {
          sizeClass = 'tablet';
        } else {
          sizeClass = 'wide';
        }

        final list = ListView(
          children: [
            for (var i = 0; i < rooms.length; i++)
              ListTile(
                leading: const Icon(Icons.meeting_room),
                title: Text(rooms[i]),
                selected: sizeClass == 'wide' && i == _selectedRoom,
                onTap: () {
                  setState(() => _selectedRoom = i);
                  // On narrow screens there is no room for a detail pane,
                  // so the detail opens as a new page instead.
                  if (sizeClass != 'wide') {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => Scaffold(
                          appBar: AppBar(title: Text(rooms[i])),
                          body: RoomDetail(room: rooms[i]),
                        ),
                      ),
                    );
                  }
                },
              ),
          ],
        );

        return Scaffold(
          appBar: AppBar(
            title: Text('Responsive: $sizeClass (${width.round()} px wide)'),
          ),
          // Phone: bottom navigation bar.
          bottomNavigationBar: sizeClass == 'phone'
              ? NavigationBar(
                  selectedIndex: _tab,
                  onDestinationSelected: (i) => setState(() => _tab = i),
                  destinations: [
                    for (final (icon, label) in destinations)
                      NavigationDestination(icon: Icon(icon), label: label),
                  ],
                )
              : null,
          body: Row(
            children: [
              // Tablet and wide: navigation rail on the side.
              if (sizeClass != 'phone') ...[
                NavigationRail(
                  extended: sizeClass == 'wide',
                  labelType: sizeClass == 'wide'
                      ? NavigationRailLabelType.none
                      : NavigationRailLabelType.all,
                  selectedIndex: _tab,
                  onDestinationSelected: (i) => setState(() => _tab = i),
                  destinations: [
                    for (final (icon, label) in destinations)
                      NavigationRailDestination(
                        icon: Icon(icon),
                        label: Text(label),
                      ),
                  ],
                ),
                const VerticalDivider(width: 1),
              ],
              // Wide: list has a fixed width, detail takes the rest.
              if (sizeClass == 'wide') ...[
                SizedBox(width: 320, child: list),
                const VerticalDivider(width: 1),
                Expanded(child: RoomDetail(room: rooms[_selectedRoom])),
              ] else
                Expanded(child: list),
            ],
          ),
        );
      },
    );
  }
}

class RoomDetail extends StatelessWidget {
  const RoomDetail({super.key, required this.room});

  final String room;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.meeting_room, size: 96),
          Text(room, style: Theme.of(context).textTheme.headlineSmall),
          const Text('Capacity: 40  ·  Projector: yes'),
        ],
      ),
    );
  }
}

// ===========================================================================
// SECTION 12: ACCESSIBILITY
// Slides: Accessible Content
// ===========================================================================

// 5.2 concept slide: "Accessible Content".
//
// Accessible apps work for people who use screen readers (TalkBack on
// Android, VoiceOver on iPhone), large text, or have trouble tapping small
// targets. The flip switch shows a BAD version next to the GOOD one.
//
// Try it: turn on TalkBack/VoiceOver and swipe through both versions, or
// set the phone's font size to the largest and reopen the screen.

class AccessibilityDemo extends StatefulWidget {
  const AccessibilityDemo({super.key});

  @override
  State<AccessibilityDemo> createState() => _AccessibilityDemoState();
}

class _AccessibilityDemoState extends State<AccessibilityDemo> {
  bool _showBad = false;
  int _likes = 0;

  @override
  Widget build(BuildContext context) {
    final textScale = MediaQuery.textScalerOf(context).scale(10) / 10;

    return Scaffold(
      appBar: AppBar(title: const Text('Accessible content')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SwitchListTile(
            title: const Text('Show the inaccessible version'),
            value: _showBad,
            onChanged: (v) => setState(() => _showBad = v),
          ),
          Text(
            'Your text scale is ${textScale.toStringAsFixed(1)}x. '
            'Flutter Text widgets grow with it automatically.',
          ),
          const Divider(height: 32),
          if (_showBad) _badVersion() else _goodVersion(context),
        ],
      ),
    );
  }

  // ---------------- GOOD ----------------
  Widget _goodVersion(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Column(
      key: const Key('good-version'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Images that carry meaning get a description.
        Row(
          children: [
            Icon(Icons.warning, color: colors.error, semanticLabel: 'Warning'),
            const SizedBox(width: 8),
            const Expanded(child: Text('Submission closes tonight')),
          ],
        ),
        const SizedBox(height: 16),

        // 2. Icon-only buttons get a tooltip. The tooltip is also read
        //    aloud by the screen reader. IconButton is 48 x 48 by default.
        Row(
          children: [
            IconButton(
              tooltip: 'Like this post',
              icon: const Icon(Icons.thumb_up),
              onPressed: () => setState(() => _likes++),
            ),
            Text('$_likes likes'),
          ],
        ),
        const SizedBox(height: 16),

        // 3. Group things that belong together, so the screen reader says
        //    "Juan Dela Cruz, BSCS 2-A" once instead of three separate stops.
        const MergeSemantics(
          child: ListTile(
            leading: CircleAvatar(child: Text('JD')),
            title: Text('Juan Dela Cruz'),
            subtitle: Text('BSCS 2-A'),
          ),
        ),
        const SizedBox(height: 16),

        // 4. Custom widgets describe themselves with Semantics.
        Semantics(
          label: 'Course progress',
          value: '60 percent',
          child: const LinearProgressIndicator(value: 0.6),
        ),
        const SizedBox(height: 16),

        // 5. Text has strong contrast against its background.
        Container(
          padding: const EdgeInsets.all(12),
          color: colors.primary,
          child: Text(
            'Readable: onPrimary on primary',
            style: TextStyle(color: colors.onPrimary),
          ),
        ),
      ],
    );
  }

  // ---------------- BAD ----------------
  Widget _badVersion() {
    return Column(
      key: const Key('bad-version'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Screen reader says nothing useful about this icon.
        const Row(
          children: [
            Icon(Icons.warning, color: Colors.red),
            SizedBox(width: 8),
            Text('Submission closes tonight'),
          ],
        ),
        const SizedBox(height: 16),
        // 2. A tiny 20 x 20 tap target with no label.
        Row(
          children: [
            GestureDetector(
              onTap: () => setState(() => _likes++),
              child: const Icon(Icons.thumb_up, size: 20),
            ),
            const SizedBox(width: 8),
            Text('$_likes likes'),
          ],
        ),
        const SizedBox(height: 16),
        // 3. Fixed-height box: large text gets cut off.
        const SizedBox(
          height: 20,
          child: Text('Juan Dela Cruz · BSCS 2-A', overflow: TextOverflow.clip),
        ),
        const SizedBox(height: 16),
        // 5. Light grey on white: hard to read.
        Container(
          padding: const EdgeInsets.all(12),
          color: Colors.white,
          child: Text(
            'Hard to read: light grey on white',
            style: TextStyle(color: Colors.grey.shade300),
          ),
        ),
      ],
    );
  }
}

// ===========================================================================
// SECTION 13: TEXT FIELDS
// Slides: Inputs Follow One Loop · TextField
// ===========================================================================

// 5.2 Getting values from users: TextField, TextEditingController,
// InputDecoration, obscureText, keyboardType, and input formatters.

class TextFieldDemo extends StatefulWidget {
  const TextFieldDemo({super.key});

  @override
  State<TextFieldDemo> createState() => _TextFieldDemoState();
}

class _TextFieldDemoState extends State<TextFieldDemo> {
  String _searchTerm = '';
  bool _hidePassword = true;

  // A controller lets you set an initial value and read/clear the text.
  // Create it in the State (not inside build) and dispose it.
  final TextEditingController _emailController = TextEditingController(
    text: 'juan@example.com',
  );

  @override
  void dispose() {
    _emailController.dispose(); // always dispose controllers
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('TextFields')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ---- 1. onChanged: fires on every keystroke ----
          TextField(
            decoration: const InputDecoration(
              labelText: 'Search',
              prefixIcon: Icon(Icons.search),
            ),
            onChanged: (value) {
              setState(() => _searchTerm = value); // update the screen
            },
          ),
          const SizedBox(height: 8),
          Text('You typed: $_searchTerm'),
          const SizedBox(height: 24),

          // ---- 2. Controller with an initial value + decoration ----
          TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress, // shows @ on keyboard
            decoration: InputDecoration(
              labelText: 'Email', // floats above when focused
              hintText: 'you@email.com', // shown when empty
              helperText: 'We will never share your email',
              icon: const Icon(Icons.contact_mail), // OUTSIDE the field
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: _emailController.clear,
              ),
            ),
          ),
          const SizedBox(height: 24),

          // ---- 3. Hiding text (passwords) ----
          TextField(
            obscureText: _hidePassword,
            decoration: InputDecoration(
              labelText: 'Password',
              prefixIcon: const Icon(Icons.lock), // INSIDE the field
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: Icon(
                  _hidePassword ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() => _hidePassword = !_hidePassword);
                },
              ),
            ),
          ),
          const SizedBox(height: 24),

          // ---- 4. Restricting input with formatters ----
          // Formatters RESTRICT what can be typed.
          // (Checking if the value is valid is done in a Form; see example 06.)
          TextField(
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9 -]')),
              LengthLimitingTextInputFormatter(19),
            ],
            decoration: const InputDecoration(
              labelText: 'Credit card number',
              prefixIcon: Icon(Icons.credit_card),
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 24),

          TextField(
            keyboardType: TextInputType.phone,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly, // 0-9 only
              LengthLimitingTextInputFormatter(11),
            ],
            decoration: const InputDecoration(
              labelText: 'Mobile number',
              hintText: '09XXXXXXXXX',
              prefixIcon: Icon(Icons.phone),
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 24),

          FilledButton(
            onPressed: () {
              // Read the current text any time through the controller
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Email: ${_emailController.text}')),
              );
            },
            child: const Text('Show email'),
          ),
        ],
      ),
    );
  }
}

// ===========================================================================
// SECTION 14: CHOOSING THE RIGHT INPUT
// Slides: Choosing the Right Input
// ===========================================================================

// 5.2 concept slides: "Inputs Follow One Loop" and "Choosing the Right Input".
//
// Every input below follows the same loop:
//   user acts  ->  onChanged / onSelected gives us the new value
//              ->  setState() stores it
//              ->  build() runs and the widget shows the new value
//
// And each one is the best widget for its kind of answer. Typing a date
// or a number of guests into a TextField would invite mistakes.

enum Section { a, b, c }

const allCourses = [
  'Application Development',
  'Data Structures and Algorithms',
  'Discrete Mathematics',
  'Human Computer Interaction',
  'Information Management',
  'Networks and Communications',
  'Operating Systems',
  'Software Engineering',
];

class ChoosingInputsDemo extends StatefulWidget {
  const ChoosingInputsDemo({super.key});

  @override
  State<ChoosingInputsDemo> createState() => _ChoosingInputsDemoState();
}

class _ChoosingInputsDemoState extends State<ChoosingInputsDemo> {
  DateTime? _date;
  TimeOfDay? _time;
  Section _section = Section.a;
  int _groupSize = 3;
  double _hours = 2;
  bool _reminders = true;
  String? _course;

  Future<void> _pickDate() async {
    final now = DateTime.now();
    // showDatePicker returns null if the user cancels.
    final picked = await showDatePicker(
      context: context,
      initialDate: _date ?? now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _time ?? const TimeOfDay(hour: 9, minute: 0),
    );
    if (picked != null) setState(() => _time = picked);
  }

  @override
  Widget build(BuildContext context) {
    final heading = Theme.of(context).textTheme.titleSmall;
    final dateText = _date == null
        ? 'Not set'
        : '${_date!.year}-${_date!.month.toString().padLeft(2, '0')}-'
              '${_date!.day.toString().padLeft(2, '0')}';

    return Scaffold(
      appBar: AppBar(title: const Text('Choosing the right input')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'A date  →  date picker (no typos, no invalid dates)',
            style: heading,
          ),
          ListTile(
            leading: const Icon(Icons.event),
            title: Text('Consultation date: $dateText'),
            trailing: const Icon(Icons.edit_calendar),
            onTap: _pickDate,
          ),
          ListTile(
            leading: const Icon(Icons.schedule),
            title: Text('Time: ${_time?.format(context) ?? 'Not set'}'),
            trailing: const Icon(Icons.edit),
            onTap: _pickTime,
          ),
          const Divider(),
          Text('One of 2 to 5 options  →  SegmentedButton', style: heading),
          const SizedBox(height: 8),
          SegmentedButton<Section>(
            segments: const [
              ButtonSegment(value: Section.a, label: Text('Section A')),
              ButtonSegment(value: Section.b, label: Text('Section B')),
              ButtonSegment(value: Section.c, label: Text('Section C')),
            ],
            selected: {_section},
            onSelectionChanged: (s) => setState(() => _section = s.first),
          ),
          const Divider(height: 32),
          Text('A small whole number  →  stepper buttons', style: heading),
          Row(
            children: [
              IconButton.outlined(
                tooltip: 'Fewer members',
                icon: const Icon(Icons.remove),
                onPressed: _groupSize > 2
                    ? () => setState(() => _groupSize--)
                    : null,
              ),
              SizedBox(
                width: 120,
                child: Text(
                  'Group of $_groupSize',
                  textAlign: TextAlign.center,
                  key: const Key('group-size'),
                ),
              ),
              IconButton.outlined(
                tooltip: 'More members',
                icon: const Icon(Icons.add),
                onPressed: _groupSize < 6
                    ? () => setState(() => _groupSize++)
                    : null,
              ),
            ],
          ),
          const Divider(height: 32),
          Text('A value in a range  →  Slider', style: heading),
          Slider(
            value: _hours,
            min: 0,
            max: 8,
            divisions: 8,
            label: '${_hours.round()} h',
            onChanged: (v) => setState(() => _hours = v),
          ),
          Text('Study hours per day: ${_hours.round()}'),
          const Divider(height: 32),
          Text('On or off  →  Switch', style: heading),
          SwitchListTile(
            title: const Text('Deadline reminders'),
            value: _reminders,
            onChanged: (v) => setState(() => _reminders = v),
          ),
          const Divider(),
          Text(
            'One of MANY options  →  Autocomplete (type to filter)',
            style: heading,
          ),
          Autocomplete<String>(
            optionsBuilder: (value) => value.text.isEmpty
                ? const Iterable<String>.empty()
                : allCourses.where(
                    (c) => c.toLowerCase().contains(value.text.toLowerCase()),
                  ),
            onSelected: (c) => setState(() => _course = c),
            fieldViewBuilder: (context, controller, focusNode, onSubmitted) =>
                TextField(
                  controller: controller,
                  focusNode: focusNode,
                  decoration: const InputDecoration(
                    labelText: 'Course',
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
          ),
          const Divider(height: 32),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                'Summary: $dateText ${_time?.format(context) ?? ''}, '
                'Section ${_section.name.toUpperCase()}, group of $_groupSize, '
                '${_hours.round()} h/day, reminders ${_reminders ? 'on' : 'off'}, '
                'course: ${_course ?? 'none'}',
                key: const Key('inputs-summary'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ===========================================================================
// SECTION 15: SELECTION INPUTS
// Slides: Checkbox, Switch, Radio, Slider, Dropdown
// ===========================================================================

// 5.2 Other inputs: Checkbox, Switch, Radio (with RadioGroup), Slider,
// DropdownButton. Every onChanged calls setState, otherwise the screen
// would not update.

// One enum, used by both the radio buttons and the dropdown.
enum SearchType { web, image, news, shopping }

class SelectionInputsDemo extends StatefulWidget {
  const SelectionInputsDemo({super.key});

  @override
  State<SelectionInputsDemo> createState() => _SelectionInputsDemoState();
}

class _SelectionInputsDemoState extends State<SelectionInputsDemo> {
  bool _safeSearch = true;
  bool _darkMode = false;
  SearchType _radioChoice = SearchType.web;
  SearchType _dropdownChoice = SearchType.web;
  double _results = 25;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Selection Inputs')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ---- Checkbox ----
          // onChanged gives a bool? (nullable) because a checkbox can be
          // "tristate" (true / false / null).
          Row(
            children: [
              Checkbox(
                value: _safeSearch,
                onChanged: (bool? value) {
                  setState(() => _safeSearch = value ?? false);
                },
              ),
              const Text('Safe search on'),
            ],
          ),

          // CheckboxListTile: the label is tappable too (better UX)
          CheckboxListTile(
            title: const Text('Safe search on (ListTile version)'),
            value: _safeSearch,
            onChanged: (value) => setState(() => _safeSearch = value ?? false),
          ),

          // ---- Switch ----
          SwitchListTile(
            title: const Text('Dark mode'),
            value: _darkMode,
            onChanged: (bool value) => setState(() => _darkMode = value),
          ),
          const Divider(),

          // ---- Radio buttons ----
          // A RadioGroup holds the selected value. Only one Radio inside it
          // can be selected at a time.
          const Text('Search type (Radio)'),
          RadioGroup<SearchType>(
            groupValue: _radioChoice,
            onChanged: (SearchType? value) {
              if (value != null) setState(() => _radioChoice = value);
            },
            child: Column(
              children: [
                for (final type in SearchType.values)
                  RadioListTile<SearchType>(
                    title: Text(type.name),
                    value: type,
                  ),
              ],
            ),
          ),
          Text('Selected: ${_radioChoice.name}'),
          const Divider(),

          // ---- Slider ----
          Text('Number of results: ${_results.round()}'),
          Slider(
            min: 0,
            max: 100,
            divisions: 100, // needed for the label bubble
            label: _results.round().toString(),
            value: _results,
            onChanged: (double value) => setState(() => _results = value),
          ),
          const Divider(),

          // ---- DropdownButton ----
          const Text('Search type (Dropdown)'),
          DropdownButton<SearchType>(
            value: _dropdownChoice,
            isExpanded: true,
            items: [
              for (final type in SearchType.values)
                DropdownMenuItem(value: type, child: Text(type.name)),
            ],
            onChanged: (SearchType? value) {
              if (value != null) setState(() => _dropdownChoice = value);
            },
          ),
          const SizedBox(height: 24),

          // Summary: proves that every input really updated the state
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'safeSearch: $_safeSearch\n'
                'darkMode: $_darkMode\n'
                'radio: ${_radioChoice.name}\n'
                'dropdown: ${_dropdownChoice.name}\n'
                'results: ${_results.round()}',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ===========================================================================
// SECTION 16: FORMS & VALIDATION
// Slides: Form, TextFormField, validators
// ===========================================================================

// 5.2 Forms with validation: a Student Registration form.
// Uses Form + GlobalKey<FormState>, TextFormField validators,
// autovalidateMode, DropdownButtonFormField, a checkbox FormField,
// and validate() / save() / reset().

const List<String> yearLevels = [
  '1st Year',
  '2nd Year',
  '3rd Year',
  '4th Year',
];

class RegistrationFormDemo extends StatefulWidget {
  const RegistrationFormDemo({super.key});

  @override
  State<RegistrationFormDemo> createState() => _RegistrationFormDemoState();
}

class _RegistrationFormDemoState extends State<RegistrationFormDemo> {
  // The key gives us access to the Form's state: validate(), save(), reset()
  final _formKey = GlobalKey<FormState>();

  // Filled in by each field's onSaved when we call save()
  String _name = '';
  String _email = '';
  String? _yearLevel;

  void _submit() {
    // validate() runs every field's validator and shows error messages.
    // It returns true only when ALL validators return null.
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save(); // calls every onSaved
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registered $_name ($_email), $_yearLevel')),
      );
    }
  }

  void _reset() {
    _formKey.currentState!.reset(); // back to each field's initialValue
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Student Registration')),
      body: Form(
        key: _formKey,
        // Show errors as soon as the user starts editing a field
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // ---- Required text ----
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Full name',
                prefixIcon: Icon(Icons.person),
              ),
              textCapitalization: TextCapitalization.words,
              // A validator returns an error message, or null if valid.
              // The value is String? (it can be null), so check for that.
              validator: (String? value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your name';
                }
                return null;
              },
              onSaved: (String? value) => _name = value!.trim(),
            ),
            const SizedBox(height: 16),

            // ---- Email format ----
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email',
                hintText: 'you@wvsu.edu.ph',
                prefixIcon: Icon(Icons.email),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) return 'Email is required';
                final emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
                if (!emailPattern.hasMatch(value)) {
                  return 'Invalid email format';
                }
                return null;
              },
              onSaved: (value) => _email = value!,
            ),
            const SizedBox(height: 16),

            // ---- Password with length rule ----
            TextFormField(
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                prefixIcon: Icon(Icons.lock),
              ),
              validator: (value) => (value == null || value.length < 8)
                  ? 'Password must be at least 8 characters'
                  : null,
            ),
            const SizedBox(height: 16),

            // ---- Dropdown inside a form ----
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Year level',
                prefixIcon: Icon(Icons.school),
              ),
              items: [
                for (final level in yearLevels)
                  DropdownMenuItem(value: level, child: Text(level)),
              ],
              onChanged: (value) {}, // value is stored by onSaved below
              validator: (value) =>
                  value == null ? 'Please choose your year level' : null,
              onSaved: (value) => _yearLevel = value,
            ),
            const SizedBox(height: 16),

            // ---- Any widget can join a Form with FormField<T> ----
            FormField<bool>(
              initialValue: false,
              validator: (agreed) =>
                  agreed == true ? null : 'You must accept the terms',
              builder: (FormFieldState<bool> field) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('I agree to the terms and conditions'),
                      value: field.value ?? false,
                      onChanged: field.didChange, // updates the field's value
                    ),
                    if (field.hasError)
                      Text(
                        field.errorText!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                  ],
                );
              },
            ),
            const SizedBox(height: 24),

            Row(
              children: [
                Expanded(
                  child: FilledButton(
                    onPressed: _submit,
                    child: const Text('Register'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: _reset,
                    child: const Text('Reset'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ===========================================================================
// SECTION 17: WHEN ERRORS APPEAR
// Slides: When Should Errors Appear?
// ===========================================================================

// 5.2 concept slide: "When Should Errors Appear?".
//
// The same email field with the three AutovalidateMode settings.
// Type a few letters in each one and notice WHEN the red error shows up.
//
//   disabled          errors appear only when you press Submit
//                     (calm, but you find out late)
//   onUnfocus         errors appear when you leave the field
//                     (usually the best for forms)
//   onUserInteraction errors appear on every keystroke
//                     (instant, but it nags while you are still typing)

String? validateEmail(String? value) {
  if (value == null || value.trim().isEmpty) return 'Email is required';
  if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value.trim())) {
    return 'Enter a valid email, like juan@wvsu.edu.ph';
  }
  return null;
}

class ValidationTimingDemo extends StatelessWidget {
  const ValidationTimingDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('When should errors appear?')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          TimingCard(
            mode: AutovalidateMode.disabled,
            explanation: 'Checks only when you press Submit.',
          ),
          TimingCard(
            mode: AutovalidateMode.onUnfocus,
            explanation: 'Checks when you leave the field (tap the next one).',
          ),
          TimingCard(
            mode: AutovalidateMode.onUserInteraction,
            explanation: 'Checks after every keystroke.',
          ),
        ],
      ),
    );
  }
}

class TimingCard extends StatefulWidget {
  const TimingCard({super.key, required this.mode, required this.explanation});

  final AutovalidateMode mode;
  final String explanation;

  @override
  State<TimingCard> createState() => _TimingCardState();
}

class _TimingCardState extends State<TimingCard> {
  final _formKey = GlobalKey<FormState>();
  String _result = '';

  void _submit() {
    // validate() runs every validator in the form and shows their errors.
    final ok = _formKey.currentState!.validate();
    setState(() => _result = ok ? 'Looks good!' : '');
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'AutovalidateMode.${widget.mode.name}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(widget.explanation),
              const SizedBox(height: 8),
              TextFormField(
                autovalidateMode: widget.mode,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email (${widget.mode.name})',
                  border: const OutlineInputBorder(),
                ),
                validator: validateEmail,
              ),
              const SizedBox(height: 8),
              // A second field, so you have somewhere to move focus to.
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Name (${widget.mode.name})',
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  FilledButton(onPressed: _submit, child: const Text('Submit')),
                  const SizedBox(width: 12),
                  Text(_result),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ===========================================================================
// SECTION 18: AFFORDANCE & FEEDBACK
// Slides: Affordance and Feedback
// ===========================================================================

// 5.2 concept slide: "Affordance and Feedback".
//
// Affordance: it LOOKS like you can tap it (shape, colour, elevation, icon).
// Feedback:   when you DO tap it, the app answers right away
//             (ripple, pressed colour, spinner, message).
//
// Compare each pair below. Both halves run the same code when tapped;
// only one of them tells the user anything.

class AffordanceDemo extends StatefulWidget {
  const AffordanceDemo({super.key});

  @override
  State<AffordanceDemo> createState() => _AffordanceDemoState();
}

class _AffordanceDemoState extends State<AffordanceDemo> {
  int _silentTaps = 0;
  int _rippleTaps = 0;
  bool _saving = false;
  bool _agreed = false;

  // Pretend to save to a server for 2 seconds.
  Future<void> _save() async {
    setState(() => _saving = true); // feedback: show that work started
    await Future<void>.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() => _saving = false);
    // feedback: say that it finished
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Profile saved')));
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final heading = Theme.of(context).textTheme.titleMedium;

    return Scaffold(
      appBar: AppBar(title: const Text('Affordance and feedback')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('1. Does it look tappable?', style: heading),
          const SizedBox(height: 8),
          Row(
            children: [
              // Plain text: nothing says "tap me".
              Expanded(
                child: GestureDetector(
                  onTap: () {},
                  child: const Padding(
                    padding: EdgeInsets.all(12),
                    child: Text('Enroll', textAlign: TextAlign.center),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // A button: shape, fill and icon all say "tap me".
              Expanded(
                child: FilledButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.how_to_reg),
                  label: const Text('Enroll'),
                ),
              ),
            ],
          ),
          const Divider(height: 32),
          Text('2. Does it react when tapped?', style: heading),
          const SizedBox(height: 8),
          Row(
            children: [
              // GestureDetector: works, but shows nothing while you press.
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _silentTaps++),
                  child: Container(
                    height: 80,
                    color: colors.surfaceContainerHighest,
                    alignment: Alignment.center,
                    child: Text(
                      'GestureDetector\n$_silentTaps taps',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // InkWell inside Material: same tap, plus a ripple.
              Expanded(
                child: Material(
                  color: colors.surfaceContainerHighest,
                  child: InkWell(
                    onTap: () => setState(() => _rippleTaps++),
                    child: SizedBox(
                      height: 80,
                      child: Center(
                        child: Text(
                          'InkWell\n$_rippleTaps taps',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const Divider(height: 32),
          Text('3. Disabled until it can be used', style: heading),
          CheckboxListTile(
            title: const Text('I agree to the class rules'),
            value: _agreed,
            onChanged: (v) => setState(() => _agreed = v ?? false),
          ),
          // onPressed: null makes the button grey and untappable, which
          // tells the user there is something left to do first.
          FilledButton(
            onPressed: _agreed ? () {} : null,
            child: const Text('Join class'),
          ),
          const Divider(height: 32),
          Text('4. Show progress for slow actions', style: heading),
          const SizedBox(height: 8),
          FilledButton.icon(
            // Disabled while saving, so it can't be pressed twice.
            onPressed: _saving ? null : _save,
            icon: _saving
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.save),
            label: Text(_saving ? 'Saving...' : 'Save profile'),
          ),
        ],
      ),
    );
  }
}

// ===========================================================================
// SECTION 19: BUTTONS
// Slides: Buttons
// ===========================================================================

// 5.2 Buttons: ElevatedButton, FilledButton, OutlinedButton, TextButton,
// IconButton, FloatingActionButton, CupertinoButton.
// (FlatButton and RaisedButton were removed from Flutter. Use these instead.)

class ButtonsDemo extends StatefulWidget {
  const ButtonsDemo({super.key});

  @override
  State<ButtonsDemo> createState() => _ButtonsDemoState();
}

class _ButtonsDemoState extends State<ButtonsDemo> {
  int _volume = 0;
  String _lastPressed = 'nothing yet';

  // A named method can be passed directly to onPressed.
  // It must take no arguments and return void.
  void _onElevatedPressed() {
    setState(() => _lastPressed = 'ElevatedButton');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Buttons')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Last pressed: $_lastPressed'),
          const SizedBox(height: 16),

          // ---- ElevatedButton: floats above the page with a shadow ----
          // Discussion: why do we need the shadow?
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final e in [0.0, 2.0, 4.0, 8.0])
                ElevatedButton(
                  style: ElevatedButton.styleFrom(elevation: e),
                  onPressed: _onElevatedPressed,
                  child: Text('elevation: $e'),
                ),
            ],
          ),
          const SizedBox(height: 16),

          // ---- FilledButton / OutlinedButton / TextButton ----
          // From most to least emphasis.
          FilledButton(
            onPressed: () => setState(() => _lastPressed = 'FilledButton'),
            child: const Text('FilledButton (primary action)'),
          ),
          OutlinedButton(
            onPressed: () => setState(() => _lastPressed = 'OutlinedButton'),
            child: const Text('OutlinedButton (secondary action)'),
          ),
          TextButton(
            onPressed: () => setState(() => _lastPressed = 'TextButton'),
            child: const Text('TextButton (low emphasis)'),
          ),
          // onPressed: null DISABLES any button
          const TextButton(onPressed: null, child: Text('Disabled')),
          const SizedBox(height: 16),

          // ---- Buttons with icons ----
          ElevatedButton.icon(
            onPressed: () => setState(() => _lastPressed = 'Add to cart'),
            icon: const Icon(Icons.add_shopping_cart),
            label: const Text('Add to cart'),
          ),
          const SizedBox(height: 16),

          // ---- IconButton ----
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.volume_down),
                tooltip: 'Decrease volume by 10', // shown on long press
                onPressed: _volume == 0
                    ? null // disabled at 0
                    : () => setState(() => _volume -= 10),
              ),
              Text('Volume: $_volume'),
              IconButton(
                icon: const Icon(Icons.volume_up),
                tooltip: 'Increase volume by 10',
                onPressed: _volume == 100
                    ? null
                    : () => setState(() => _volume += 10),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // ---- CupertinoButton: iOS style ----
          // Looks native on iPhone; can feel out of place on Android.
          CupertinoButton(
            onPressed: () => setState(() => _lastPressed = 'CupertinoButton'),
            child: const Text('CupertinoButton'),
          ),
          CupertinoButton.filled(
            onPressed: () =>
                setState(() => _lastPressed = 'CupertinoButton.filled'),
            child: const Text('CupertinoButton.filled'),
          ),
        ],
      ),
      // ---- FloatingActionButton: the main action on the screen ----
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => setState(() => _lastPressed = 'FAB'),
        icon: const Icon(Icons.check),
        label: const Text('Done'),
      ),
    );
  }
}

// ===========================================================================
// SECTION 20: GESTURES
// Slides: Dismissible, GestureDetector
// ===========================================================================

// 5.2 Handling gestures: Dismissible (swipe to delete + undo) and
// GestureDetector (tap, double tap, long press, pinch/scale, swipe).

class GesturesDemo extends StatelessWidget {
  const GesturesDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Gestures'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Dismissible'),
              Tab(text: 'GestureDetector'),
            ],
          ),
        ),
        // Swiping between tabs is turned off: the TabBarView would otherwise
        // "win" the horizontal swipes meant for the widgets inside it.
        // Only one gesture recognizer can win each touch (the gesture arena).
        body: const TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: [DismissibleList(), GesturePlayground()],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Swipe a row left or right to delete it, with an UNDO button.
// ---------------------------------------------------------------------------
class DismissibleList extends StatefulWidget {
  const DismissibleList({super.key});

  @override
  State<DismissibleList> createState() => _DismissibleListState();
}

class _DismissibleListState extends State<DismissibleList> {
  final List<String> _students = [
    'Andres',
    'Gabriela',
    'Jose',
    'Melchora',
    'Apolinario',
    'Emilio',
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _students.length,
      itemBuilder: (context, index) {
        final name = _students[index];
        return Dismissible(
          // Each Dismissible needs a unique key so Flutter knows which
          // row was removed.
          key: ValueKey(name),
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 16),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          secondaryBackground: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 16),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          onDismissed: (DismissDirection direction) {
            // The row is gone from the screen, so remove it from the data too.
            setState(() => _students.removeAt(index));
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text('$name removed'),
                  action: SnackBarAction(
                    label: 'UNDO',
                    onPressed: () {
                      setState(() => _students.insert(index, name));
                    },
                  ),
                ),
              );
          },
          child: ListTile(
            leading: CircleAvatar(child: Text(name[0])),
            title: Text(name),
            subtitle: const Text('Swipe me left or right'),
          ),
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// GestureDetector: make ANY widget respond to gestures.
// Steps: 1) decide the gesture, 2) build the widget,
//        3) wrap it in GestureDetector, 4) connect gesture -> behavior.
// ---------------------------------------------------------------------------
class GesturePlayground extends StatefulWidget {
  const GesturePlayground({super.key});

  @override
  State<GesturePlayground> createState() => _GesturePlaygroundState();
}

class _GesturePlaygroundState extends State<GesturePlayground> {
  String _lastGesture =
      'Try tapping, double tapping, long pressing, '
      'swiping or pinching the box';
  Color _color = Colors.indigo;
  double _scale = 1.0;
  double _baseScale = 1.0; // scale when the pinch started
  double _swipeDistance = 0; // how far one finger moved sideways

  void _show(String gesture) => setState(() => _lastGesture = gesture);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(_lastGesture, textAlign: TextAlign.center),
        ),
        Expanded(
          child: Center(
            child: GestureDetector(
              onTap: () => _show('Tap'),
              onDoubleTap: () {
                setState(() {
                  _color = _color == Colors.indigo
                      ? Colors.teal
                      : Colors.indigo;
                });
                _show('Double tap: color changed');
              },
              onLongPress: () {
                setState(() => _scale = _baseScale = 1.0);
                _show('Long press: size reset');
              },
              // Scale gestures cover pinch AND one-finger pan, so a swipe is
              // detected here too, from how far one finger moved sideways.
              // (You can't use onScale* together with onPan*/onHorizontalDrag*
              // on the same GestureDetector.)
              onScaleStart: (details) {
                _baseScale = _scale;
                _swipeDistance = 0;
              },
              onScaleUpdate: (details) {
                if (details.pointerCount == 1) {
                  // One finger: add up the sideways movement for a swipe.
                  _swipeDistance += details.focalPointDelta.dx;
                } else {
                  // Two fingers: pinch to zoom. scale > 1 means spreading
                  // the fingers apart, scale < 1 means pinching in.
                  setState(() {
                    _scale = (_baseScale * details.scale).clamp(0.5, 3.0);
                  });
                  _show('Pinch: ${_scale.toStringAsFixed(2)}x');
                }
              },
              onScaleEnd: (details) {
                if (_swipeDistance > 50) {
                  _show('Swiped right');
                } else if (_swipeDistance < -50) {
                  _show('Swiped left');
                }
              },
              child: Transform.scale(
                scale: _scale,
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    color: _color,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    'Touch me',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ===========================================================================
// SECTION 21: GESTURE ARENA
// Slides: The Gesture Arena
// ===========================================================================

// 5.2 concept slide: "The Gesture Arena".
//
// When one touch could mean several gestures, every interested recogniser
// enters the "arena" and only ONE wins. The log at the bottom shows who won.
//
//   A. Nested taps: the inner (deepest) widget wins. The outer onTap never
//      runs for taps on the inner box.
//   B. Tap vs double tap: if a widget also listens for double tap, a single
//      tap must WAIT (about 300 ms) to be sure no second tap is coming.
//   C. Direction: inside a vertical ListView, a horizontal drag detector
//      wins sideways drags, and the list wins up/down drags.

class GestureArenaDemo extends StatefulWidget {
  const GestureArenaDemo({super.key});

  @override
  State<GestureArenaDemo> createState() => _GestureArenaDemoState();
}

class _GestureArenaDemoState extends State<GestureArenaDemo> {
  final List<String> _log = [];
  double _sliderX = 0;

  void _add(String line) {
    setState(() {
      _log.insert(0, line);
      if (_log.length > 6) _log.removeLast();
    });
  }

  @override
  Widget build(BuildContext context) {
    final heading = Theme.of(context).textTheme.titleMedium;
    return Scaffold(
      appBar: AppBar(title: const Text('The gesture arena')),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text('A. Nested taps', style: heading),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () => _add('A: OUTER box won'),
                  child: Container(
                    height: 140,
                    color: Colors.orange.shade200,
                    alignment: Alignment.center,
                    child: GestureDetector(
                      onTap: () => _add('A: INNER box won'),
                      child: Container(
                        width: 140,
                        height: 70,
                        color: Colors.deepOrange,
                        alignment: Alignment.center,
                        child: const Text(
                          'Inner',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
                const Text('Tap the orange edge, then the inner box.'),
                const SizedBox(height: 24),
                Text('B. Tap vs double tap', style: heading),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _tapBox(
                        label: 'onTap only\n(instant)',
                        color: Colors.green.shade200,
                        onTap: () => _add('B: tap (no waiting)'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _add('B: tap (waited for double tap)'),
                        onDoubleTap: () => _add('B: DOUBLE tap won'),
                        child: _tapBox(
                          label: 'onTap + onDoubleTap\n(single tap waits)',
                          color: Colors.blue.shade200,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  'C. Horizontal drag inside a vertical list',
                  style: heading,
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  // Only horizontal drags are claimed here. Vertical drags
                  // are left for the ListView, so the page still scrolls.
                  onHorizontalDragStart: (_) => _add('C: horizontal drag won'),
                  onHorizontalDragUpdate: (d) => setState(() {
                    _sliderX = (_sliderX + d.delta.dx).clamp(0, 200);
                  }),
                  child: Container(
                    key: const Key('drag-track'),
                    height: 70,
                    color: Colors.purple.shade100,
                    alignment: Alignment.centerLeft,
                    child: Transform.translate(
                      offset: Offset(_sliderX, 0),
                      child: const Padding(
                        padding: EdgeInsets.all(8),
                        child: Icon(Icons.swipe, size: 40),
                      ),
                    ),
                  ),
                ),
                const Text(
                  'Drag sideways to move the icon. Drag up/down on '
                  'it and the list scrolls instead.',
                ),
                // Extra space so the list can scroll.
                const SizedBox(height: 400),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            color: Colors.black87,
            padding: const EdgeInsets.all(8),
            child: Text(
              _log.isEmpty ? 'Winners appear here' : _log.join('\n'),
              key: const Key('arena-log'),
              style: const TextStyle(
                color: Colors.greenAccent,
                fontFamily: 'monospace',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tapBox({
    required String label,
    required Color color,
    VoidCallback? onTap,
  }) {
    final box = Container(
      height: 80,
      color: color,
      alignment: Alignment.center,
      child: Text(label, textAlign: TextAlign.center),
    );
    return onTap == null ? box : GestureDetector(onTap: onTap, child: box);
  }
}
