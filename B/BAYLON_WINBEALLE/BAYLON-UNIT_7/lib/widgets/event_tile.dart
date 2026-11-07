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
   // EXPLAIN E8: The Z means the time is in UTC (zero offset from Greenwich).
  // 05:00Z is the same moment as 1:00 PM in Iloilo (UTC+8). toLocal() converts
  // it to the phone's own time zone before we format it. Without it, a student
  // in Iloilo would see 5:00 AM, eight hours earlier than the real start time.
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
    return ListTile(
      leading: Icon(
        cancelled ? Icons.event_busy : Icons.event,
        color: cancelled ? colors.error : colors.primary,
      ),
      title: Text(
        event.title,
        style: cancelled
            ? const TextStyle(decoration: TextDecoration.lineThrough)
            : null,
      ),
      subtitle: Text('${formatWhen(event.startsAt)}\n$where'),
      trailing: cancelled ? const Chip(label: Text('Cancelled')) : null,
      isThreeLine: true,
    );
  }
}
