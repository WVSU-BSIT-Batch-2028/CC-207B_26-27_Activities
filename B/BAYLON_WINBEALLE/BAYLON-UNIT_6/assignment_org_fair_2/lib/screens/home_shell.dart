import 'package:flutter/material.dart';

import '../data/orgs.dart';
import '../models/membership.dart';
import 'my_orgs_screen.dart';
import 'org_list_screen.dart';
import 'schedule_screen.dart';

/// The app's frame: a NavigationBar with three destinations.
class HomeShell extends StatefulWidget {
  const HomeShell({super.key, required this.repository});

  final OrgRepository repository;

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  // OrgListScreen, MyOrgsScreen and ScheduleScreen all need the
  // joined orgs (see build(), lines 39-49). OrgListScreen shows which orgs
  // are joined and saves new ones, MyOrgsScreen lists them, and
  // ScheduleScreen highlights their rows. These screens are siblings, and a
  // screen can't read or change the state of another screen, so none of them
  // can keep the map for the others. I lifted it up to their closest common
  // parent, HomeShell, which passes it down and gets changes back through
  // callbacks like onJoined and onLeave. When setState runs here, all three
  // tabs rebuild with the same data.
  final Map<String, Membership> _memberships = {};

void _join(Membership membership) {
  // TODO 4: Save the membership in _memberships, keyed by the org's id.
  //   Use setState so every tab rebuilds with the new map.
  setState(() => _memberships[membership.org.id] = membership);
}

  void _leave(Org org) {
    setState(() => _memberships.remove(org.id));
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      OrgListScreen(
        repository: widget.repository,
        memberships: _memberships,
        onJoined: _join,
      ),
      MyOrgsScreen(
        memberships: _memberships.values.toList(),
        onLeave: _leave,
        onBrowse: () => setState(() => _index = 0),
      ),
      ScheduleScreen(joinedIds: _memberships.keys.toSet()),
    ];
    final count = _memberships.length;

    return Scaffold(
      // EXPLAIN E2:IndexedStack keeps it. It builds all three pages once and
      // only shows the one at index _index, so the hidden pages stay in the
      // widget tree. Their State objects, including OrgListScreen's search
      // controller and text, are never disposed. With pages[_index] (C1), the
      // old page leaves the tree on every switch and its State is destroyed,
      // so the search box comes back empty.
      // TODO 1: Show only pages[_index], but keep every page alive.
      //   Replace pages[_index] with an IndexedStack.
body: IndexedStack(index: _index, children: pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        // TODO 2: Switch to the destination the user tapped.
onDestinationSelected: (i) => setState(() => _index = i),
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.storefront_outlined),
            selectedIcon: Icon(Icons.storefront),
            label: 'Orgs',
          ),
          NavigationDestination(
            // TODO 3: Wrap both icons in a Badge that shows how many orgs
            //   the student joined (count). Hide the badge when count is 0.
            icon: Badge(
              isLabelVisible: count > 0,
              label: Text('$count'),
              child: const Icon(Icons.badge_outlined),
            ),
            selectedIcon: Badge(
              isLabelVisible: count > 0,
              label: Text('$count'),
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
