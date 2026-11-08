import 'package:flutter/material.dart';

import '../data/orgs.dart';
import '../models/registration.dart';
import 'my_orgs_screen.dart';
import 'org_list_screen.dart';
import 'schedule_screen.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key, required this.repository});

  final OrgRepository repository;

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _selectedIndex = 0;
  final Map<String, Registration> _memberships = {};

  void _join(Org org, Registration registration) {
    setState(() => _memberships[org.id] = registration);
  }

  void _leave(Org org) {
    setState(() => _memberships.remove(org.id));
  }

  @override
  Widget build(BuildContext context) {
    final joinedCount = _memberships.length;
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          OrgListScreen(
            repository: widget.repository,
            memberships: _memberships,
            onJoined: _join,
          ),
          MyOrgsScreen(memberships: _memberships, onLeave: _leave),
          ScheduleScreen(memberships: _memberships),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() => _selectedIndex = index);
        },
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.storefront_outlined),
            selectedIcon: Icon(Icons.storefront),
            label: 'Orgs',
          ),
          NavigationDestination(
            icon: Badge(
              isLabelVisible: joinedCount > 0,
              label: Text('$joinedCount'),
              child: const Icon(Icons.badge_outlined),
            ),
            selectedIcon: Badge(
              isLabelVisible: joinedCount > 0,
              label: Text('$joinedCount'),
              child: const Icon(Icons.badge),
            ),
            label: 'My Orgs',
          ),
          const NavigationDestination(
            icon: Icon(Icons.calendar_month_outlined),
            selectedIcon: Icon(Icons.calendar_month),
            label: 'Schedule',
          ),
        ],
      ),
    );
  }
}
