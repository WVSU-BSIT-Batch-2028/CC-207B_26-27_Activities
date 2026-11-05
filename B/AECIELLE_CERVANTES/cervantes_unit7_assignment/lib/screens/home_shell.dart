import 'package:flutter/material.dart';

import '../data/event_repository.dart';
import '../data/orgs.dart';
import '../models/membership.dart';
import 'my_orgs_screen.dart';
import 'org_list_screen.dart';
import 'schedule_screen.dart';
import 'events_screen.dart';

/// The app's frame: a NavigationBar with three destinations.
class HomeShell extends StatefulWidget {
  const HomeShell({
    super.key,
    required this.repository,
    required this.eventRepository,
  });

  final OrgRepository repository;
  final EventRepository eventRepository;

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  // EXPLAIN E1: In Part 1 the joined orgs were saved inside OrgListScreen.
  // Now they live here, in HomeShell. Which screens need this map, and why
  // can't one of those screens keep it for the others?
  final Map<String, Membership> _memberships = {};

  void _join(Membership membership) {
    // TODO 4: Save the membership in _memberships, keyed by the org's id.
    // Use setState so every tab rebuilds with the new map.
    setState(() {
      _memberships[membership.org.id] = membership;
    });
  }

  void _leave(Org org) {
    setState(() => _memberships.remove(org.id));
  }

@override
  Widget build(BuildContext context) {
    final pages = [
      OrgListScreen(
        repository: widget.repository,
        eventRepository: widget.eventRepository,
        memberships: _memberships,
        onJoined: _join,
      ),
      MyOrgsScreen(
        memberships: _memberships.values.toList(),
        onLeave: _leave,
        onBrowse: () => setState(() => _index = 0),
      ),
      EventsScreen(repository: widget.eventRepository), // <-- Add EventsScreen
      ScheduleScreen(joinedIds: _memberships.keys.toSet()),
    ];
    final count = _memberships.length;

    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) {
          setState(() {
            _index = i;
          });
        },
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.storefront_outlined),
            selectedIcon: Icon(Icons.storefront),
            label: 'Orgs',
          ),
          NavigationDestination(
            icon: Badge(
              label: Text('$count'),
              isLabelVisible: count > 0,
              child: const Icon(Icons.badge_outlined),
            ),
            selectedIcon: Badge(
              label: Text('$count'),
              isLabelVisible: count > 0,
              child: const Icon(Icons.badge),
            ),
            label: 'My Orgs',
          ),
          const NavigationDestination( // <-- Add "What's On" destination
            icon: Icon(Icons.event_outlined),
            selectedIcon: Icon(Icons.event),
            label: "What's On",
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