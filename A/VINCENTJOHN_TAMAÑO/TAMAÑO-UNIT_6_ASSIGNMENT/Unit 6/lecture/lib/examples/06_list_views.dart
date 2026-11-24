// Slides 23–28: ListView, ListView.builder and ListView.separated.
//
// Try it:
// 1. Pick "builder", scroll a little, then tap the counter button.
//    Only the rows that came on screen were built, not all 1000.
//    That is what "lazy" means (slide 27).
// 2. Pick "separated" to see a divider between rows and a "sponsored"
//    row after every 5 people (slide 25).
// 3. Tap a person: lists are for doing something with an item.

import 'package:flutter/material.dart';

void main() => runApp(
  MaterialApp(
    theme: ThemeData(colorSchemeSeed: Colors.indigo),
    home: const ListViewDemo(),
  ),
);

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
