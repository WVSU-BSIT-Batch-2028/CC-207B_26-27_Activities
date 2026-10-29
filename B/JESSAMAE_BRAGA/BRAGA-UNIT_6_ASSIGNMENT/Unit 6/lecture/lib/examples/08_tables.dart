// Slides 35–39: Table, and DataTable for data the user can sort.
//
// Try it:
// 1. Switch "Use Rows and Columns instead". The columns no longer line up,
//    because each Column sizes itself without asking the others (slide 36).
// 2. Tap a DataTable header to sort by that column. Tap again to reverse.

import 'package:flutter/material.dart';

void main() => runApp(
  MaterialApp(
    theme: ThemeData(colorSchemeSeed: Colors.blueGrey),
    home: const TableDemo(),
  ),
);

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
