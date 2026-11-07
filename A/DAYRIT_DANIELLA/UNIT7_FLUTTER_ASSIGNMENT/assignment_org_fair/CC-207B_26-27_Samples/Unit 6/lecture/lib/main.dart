// CC 206 Advanced Flutter Topics: a menu that opens every example screen.
// Each file in lib/examples/ also has its own main(), so you can paste a
// single file into https://dartpad.dev and run it on its own.

import 'package:flutter/material.dart';

import 'examples/01_material_app_scaffold.dart' hide main;
import 'examples/02_safe_area.dart' hide main;
import 'examples/03_alignment_playground.dart' hide main;
import 'examples/04_flex_and_spacer.dart' hide main;
import 'examples/05_overflow_fixes.dart' hide main;
import 'examples/06_list_views.dart' hide main;
import 'examples/07_grid_view.dart' hide main;
import 'examples/08_tables.dart' hide main;
import 'examples/09_stack_navigation.dart' hide main;
import 'examples/10_drawer_navigation.dart' hide main;
import 'examples/11_tab_navigation.dart' hide main;
import 'examples/12_bottom_navigation.dart' hide main;
import 'examples/13_bottom_tab_bar.dart' hide main;
import 'examples/14_stack_widget.dart' hide main;

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
