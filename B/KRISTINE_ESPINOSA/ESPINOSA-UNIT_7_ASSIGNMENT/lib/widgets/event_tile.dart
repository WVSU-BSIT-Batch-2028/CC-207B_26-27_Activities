import 'package:flutter/material.dart';

import '../data/orgs.dart';
import '../models/fair_event.dart';

const _days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
const _months = [
  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
];

String formatWhen(DateTime when) {
  final t = when.toLocal();
  final hour = t.hour % 12 == 0 ? 12 : t.hour % 12;
  final minute = t.minute.toString().padLeft(2, '0');
  final amPm = t.hour < 12 ? 'AM' : 'PM';
  return '${_days[t.weekday - 1]}, ${_months[t.month - 1]} ${t.day} · '
      '$hour:$minute $amPm';
}

String orgLabel(String orgId) {
  for (final org in sampleOrgs) {
    if (org.id == orgId) return org.acronym;
  }
  return orgId.toUpperCase();
}

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
    return ListTile(
      leading: event.cancelled
          ? Icon(Icons.event_busy, color: colors.error)
          : Icon(Icons.event, color: colors.primary),
      title: Text(
        event.title,
        style: event.cancelled
            ? const TextStyle(decoration: TextDecoration.lineThrough)
            : null,
      ),
      subtitle: Text('${formatWhen(event.startsAt)}\n$where'),
      trailing: event.cancelled ? const Chip(label: Text('Cancelled')) : null,
      isThreeLine: true,
    );
  }
}
