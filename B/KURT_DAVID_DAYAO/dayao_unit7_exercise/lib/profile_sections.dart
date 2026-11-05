import 'package:flutter/material.dart';

import 'class_slot.dart';

class HobbiesCard extends StatelessWidget {
  const HobbiesCard({super.key, required this.hobbies});

  final List<String> hobbies;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('My Hobbies', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [for (final hobby in hobbies) Chip(label: Text(hobby))],
            ),
          ],
        ),
      ),
    );
  }
}

class ClassScheduleCard extends StatelessWidget {
  const ClassScheduleCard({super.key, required this.classes});

  final List<ClassSlot> classes;

  Widget _cell(String text, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: bold ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('My Class Schedule', style: theme.textTheme.titleLarge),
            const SizedBox(height: 12),
            Table(
              border: TableBorder.all(color: theme.colorScheme.outlineVariant),
              columnWidths: const {
                0: FixedColumnWidth(48),
                1: FixedColumnWidth(88),
                2: FlexColumnWidth(),
              },
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                TableRow(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                  ),
                  children: [
                    _cell('Day', bold: true),
                    _cell('Time', bold: true),
                    _cell('Subject', bold: true),
                  ],
                ),
                for (final slot in classes)
                  TableRow(
                    children: [
                      _cell(slot.day),
                      _cell(slot.time),
                      _cell(slot.subject),
                    ],
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
