import 'package:flutter/material.dart';

import '../data/orgs.dart';
import '../models/registration.dart';

class MyOrgsScreen extends StatelessWidget {
  const MyOrgsScreen({
    super.key,
    required this.memberships,
    required this.onLeave,
  });

  final Map<String, Registration> memberships;
  final ValueChanged<Org> onLeave;

  Future<void> _confirmLeave(BuildContext context, Org org) async {
    final shouldLeave = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Leave ${org.acronym}?'),
        content: Text('You will no longer be a member of ${org.name}.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Leave'),
          ),
        ],
      ),
    );
    if (shouldLeave == true) onLeave(org);
  }

  @override
  Widget build(BuildContext context) {
    final orgs = sampleOrgs
        .where((org) => memberships.containsKey(org.id))
        .toList();
    return Scaffold(
      appBar: AppBar(title: const Text('My Orgs')),
      body: orgs.isEmpty
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.groups_outlined, size: 48),
                    SizedBox(height: 16),
                    Text(
                      'You have not joined any organizations yet.',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            )
          : ListView.builder(
              itemCount: orgs.length,
              itemBuilder: (context, index) {
                final org = orgs[index];
                final registration = memberships[org.id]!;
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text(org.acronym.characters.first),
                    ),
                    title: Text(org.name),
                    subtitle: Text(
                      '${registration.committee.label} committee · '
                      '${registration.hoursPerWeek} h/week',
                    ),
                    trailing: IconButton(
                      tooltip: 'Leave ${org.acronym}',
                      icon: const Icon(Icons.logout),
                      onPressed: () => _confirmLeave(context, org),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
