import 'package:flutter/material.dart';

import '../data/fair_data.dart';
import '../data/orgs.dart';
import '../models/registration.dart';

class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({super.key, required this.memberships});

  final Map<String, Registration> memberships;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final acronymToId = {for (final org in sampleOrgs) org.acronym: org.id};
    return Scaffold(
      appBar: AppBar(title: const Text('Booth schedule')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'CICT Org Fair · November 5, 2026',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  '8:00 AM to 3:00 PM · CICT Building lobby',
                  style: Theme.of(context).textTheme.bodyMedium
                      ?.copyWith(color: colors.onSurfaceVariant),
                ),
                if (memberships.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.check_circle, size: 18, color: colors.primary),
                      const SizedBox(width: 8),
                      Text(
                        'Your joined organizations are highlighted',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Text(
              'Booth assignments',
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Card(
                clipBehavior: Clip.antiAlias,
                margin: EdgeInsets.zero,
                child: Table(
                  columnWidths: const {
                    0: FlexColumnWidth(1.2),
                    1: FlexColumnWidth(0.8),
                    2: FlexColumnWidth(1.2),
                  },
                  border: TableBorder(
                    horizontalInside: BorderSide(color: colors.outlineVariant),
                    verticalInside: BorderSide(color: colors.outlineVariant),
                    top: BorderSide(color: colors.outlineVariant),
                    bottom: BorderSide(color: colors.outlineVariant),
                    left: BorderSide(color: colors.outlineVariant),
                    right: BorderSide(color: colors.outlineVariant),
                  ),
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  children: [
                    TableRow(
                      decoration: BoxDecoration(
                        color: colors.surfaceContainerHighest,
                      ),
                      children: const [
                        _ScheduleCell('Time', isHeader: true),
                        _ScheduleCell('Booth', isHeader: true),
                        _ScheduleCell('Organization', isHeader: true),
                      ],
                    ),
                    for (final slot in boothSchedule)
                      _buildScheduleRow(
                        slot,
                        isJoined: memberships.containsKey(
                          acronymToId[slot.orgAcronym],
                        ),
                        colors: colors,
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  TableRow _buildScheduleRow(
    BoothSlot slot, {
    required bool isJoined,
    required ColorScheme colors,
  }) {
    return TableRow(
      decoration: isJoined
          ? BoxDecoration(color: colors.primaryContainer)
          : null,
      children: [
        _ScheduleCell(slot.time),
        _ScheduleCell(slot.booth),
        _ScheduleCell(
          slot.orgAcronym,
          trailing: isJoined
              ? Icon(
                  Icons.check_circle,
                  color: colors.onPrimaryContainer,
                  size: 18,
                )
              : null,
        ),
      ],
    );
  }
}

class _ScheduleCell extends StatelessWidget {
  const _ScheduleCell(this.text, {this.isHeader = false, this.trailing});

  final String text;
  final bool isHeader;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      child: Row(
        children: [
          Expanded(
            child: Text(
              text,
              style: isHeader ? Theme.of(context).textTheme.titleSmall : null,
            ),
          ),
          if (trailing != null) ...[const SizedBox(width: 6), trailing!],
        ],
      ),
    );
  }
}
