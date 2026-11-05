import 'package:flutter/material.dart';

import '../data/orgs.dart';
import '../models/fair_event.dart';

const _days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
const _months = [
  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', //
  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
];

/// "Sun, Nov 8 · 1:00 PM", in the phone's own time zone.
String formatWhen(DateTime when) {
  // EXPLAIN E8: The CMS sends "2026-11-08T05:00:00.000Z". What does the Z
  // mean, and why do we call toLocal() before showing the time? What would
  // a student in Iloilo see without it?
  final t = when.toLocal();
  final hour = t.hour % 12 == 0 ? 12 : t.hour % 12;
  final minute = t.minute.toString().padLeft(2, '0');
  final amPm = t.hour < 12 ? 'AM' : 'PM';
  return '${_days[t.weekday - 1]}, ${_months[t.month - 1]} ${t.day} · '
      '$hour:$minute $amPm';
}

/// The org's acronym, or the raw id if the CMS has an org the app
/// does not know yet.
String orgLabel(String orgId) {
  for (final org in sampleOrgs) {
    if (org.id == orgId) return org.acronym;
  }
  return orgId.toUpperCase();
}

/// One event in a list.
class EventTile extends StatelessWidget {
  const EventTile({super.key, required this.event, this.showOrg = true});

  final FairEvent event;
  final bool showOrg;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final where = showOrg
        ? '${orgLabel(event.orgId)} · ${event.venue}'
        : event.venue;
    final cancelled = event.cancelled;
    final details = [
      formatWhen(event.startsAt),
      where,
      if (event.description.isNotEmpty) event.description,
    ].join('\n');
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        minVerticalPadding: 12,
        leading: Icon(
          cancelled ? Icons.event_busy : Icons.event,
          color: cancelled ? colors.error : colors.primary,
          size: 28,
        ),
        title: Text(
          event.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: (Theme.of(context).textTheme.titleMedium ?? const TextStyle())
              .copyWith(
                fontWeight: FontWeight.w600,
                decoration: cancelled ? TextDecoration.lineThrough : null,
                decorationColor: colors.onSurface,
                color: cancelled ? colors.onSurfaceVariant : colors.onSurface,
              ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            details,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: colors.onSurfaceVariant,
              height: 1.35,
            ),
          ),
        ),
        isThreeLine: true,
        trailing: cancelled
            ? Chip(
                label: const Text('Cancelled'),
                visualDensity: VisualDensity.compact,
                backgroundColor: colors.errorContainer,
                labelStyle: TextStyle(
                  color: colors.onErrorContainer,
                  fontWeight: FontWeight.w700,
                ),
                side: BorderSide.none,
                padding: EdgeInsets.zero,
              )
            : null,
      ),
    );
  }
}
