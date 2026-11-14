
import 'package:flutter/material.dart';

import '../data/orgs.dart';
import '../models/registration.dart';
import '../widgets/org_card.dart';
import '../widgets/state_message.dart';
import 'org_detail_screen.dart';

class OrgListScreen extends StatefulWidget {
  const OrgListScreen({super.key, required this.repository});

  final OrgRepository repository;

  @override
  State<OrgListScreen> createState() => _OrgListScreenState();
}

class _OrgListScreenState extends State<OrgListScreen> {
  late Future<List<Org>> _orgsFuture;
  final _searchController = TextEditingController();
  String _query = '';
  final Set<String> _hiddenIds = {};
  final Set<String> _favoriteIds = {};
  final Map<String, Registration> _registrations = {};

  @override
  void initState() {
    super.initState();

    // TODO 1: Start loading organizations once.
    _orgsFuture = widget.repository.fetchOrgs();
  }

  // EXPLAIN E2:
  // The controller is disposed to release its resources.
  // If it is not disposed, it can retain resources unnecessarily
  // after this screen is removed.
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // TODO 2: Reload organizations.
  void _reload() {
    setState(() {
      _orgsFuture = widget.repository.fetchOrgs();
    });
  }

  void _setServerMode(ServerMode mode) {
    widget.repository.mode = mode;
    _reload();
  }

  // TODO 3: Toggle an organization's favorite status.
  void _toggleFavorite(Org org) {
    setState(() {
      if (_favoriteIds.contains(org.id)) {
        _favoriteIds.remove(org.id);
      } else {
        _favoriteIds.add(org.id);
      }
    });
  }

  void _hide(Org org) {
    setState(() {
      _hiddenIds.add(org.id);
    });

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('${org.acronym} hidden'),
          action: SnackBarAction(
            label: 'UNDO',
            onPressed: () {
              setState(() {
                _hiddenIds.remove(org.id);
              });
            },
          ),
        ),
      );
  }

  // EXPLAIN E7:
  // Navigator.push returns a Future that completes with the value
  // passed to Navigator.pop on the pushed screen.
  Future<void> _openDetail(Org org) async {
    final registration = await Navigator.of(context).push<Registration>(
      MaterialPageRoute(
        builder: (_) => OrgDetailScreen(
          org: org,
          isMember: _registrations.containsKey(org.id),
        ),
      ),
    );

    if (registration != null && mounted) {
      setState(() {
        _registrations[org.id] = registration;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CICT Org Fair'),
        actions: [
          PopupMenuButton<ServerMode>(
            tooltip: 'Fake server mode',
            icon: const Icon(Icons.dns),
            onSelected: _setServerMode,
            itemBuilder: (_) => [
              for (final mode in ServerMode.values)
                CheckedPopupMenuItem<ServerMode>(
                  value: mode,
                  checked: widget.repository.mode == mode,
                  child: Text('Server: ${mode.name}'),
                ),
            ],
          ),
        ],
      ),
      body: FutureBuilder<List<Org>>(
        future: _orgsFuture,
        builder: (context, snapshot) {
          // 1. Loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const StateMessage(
              icon: Icons.hourglass_empty,
              text: 'Loading organizations...',
            );
          }

          // TODO 4: Error state with retry.
          if (snapshot.hasError) {
            final errorText = snapshot.error
                .toString()
                .replaceFirst('Exception: ', '');

            return StateMessage(
              icon: Icons.wifi_off,
              text: errorText,
              action: FilledButton.icon(
                onPressed: _reload,
                icon: const Icon(Icons.refresh),
                label: const Text('Try again'),
              ),
            );
          }

          final orgs = snapshot.data ?? const <Org>[];

          // TODO 5: Empty state with refresh.
          if (orgs.isEmpty) {
            return StateMessage(
              icon: Icons.inbox,
              text: 'No organizations have signed up for the fair yet.',
              action: OutlinedButton(
                onPressed: _reload,
                child: const Text('Refresh'),
              ),
            );
          }

          // Success
          return _buildOrgs(orgs);
        },
      ),
    );
  }

  Widget _buildOrgs(List<Org> orgs) {
    // EXPLAIN E4:
    // TextField.onChanged updates _query inside setState.
    // That triggers a rebuild, and this filter uses the updated query.
    final q = _query.trim().toLowerCase();

    final visible = orgs
        .where((org) => !_hiddenIds.contains(org.id))
        .where(
          (org) =>
              q.isEmpty ||
              org.name.toLowerCase().contains(q) ||
              org.acronym.toLowerCase().contains(q),
        )
        .toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              labelText: 'Search organizations',
              border: const OutlineInputBorder(),
              suffixIcon: _query.isEmpty
                  ? null
                  : IconButton(
                      tooltip: 'Clear search',
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        setState(() {
                          _query = '';
                        });
                      },
                    ),
            ),

            // TODO 6: Update the search query.
            onChanged: (value) {
              setState(() {
                _query = value;
              });
            },
          ),
        ),

        // EXPLAIN E5:
        // Expanded gives the list the remaining available height.
        // Without it, the Column may give the list unbounded vertical
        // constraints, causing a layout error.
        Expanded(
          child: visible.isEmpty
              ? const StateMessage(
                  icon: Icons.search_off,
                  text: 'No organizations match your search.',
                )
              : LayoutBuilder(
                  builder: (context, constraints) {
                    final columns = constraints.maxWidth < 600
                        ? 1
                        : (constraints.maxWidth < 1000 ? 2 : 3);

                    if (columns == 1) {
                      return ListView.builder(
                        itemCount: visible.length,
                        itemBuilder: (_, index) => _card(visible[index]),
                      );
                    }

                    return GridView.builder(
                      padding: const EdgeInsets.all(8),
                      gridDelegate:
                          SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: columns,
                        mainAxisExtent: 96,
                      ),
                      itemCount: visible.length,
                      itemBuilder: (_, index) => _card(visible[index]),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _card(Org org) {
    final card = OrgCard(
      org: org,
      isFavorite: _favoriteIds.contains(org.id),
      isMember: _registrations.containsKey(org.id),
      onTap: () => _openDetail(org),
      onLongPress: () => _toggleFavorite(org),
    );

    // TODO 7: Allow an organization card to be dismissed.
    return Dismissible(
      key: ValueKey(org.id),
      onDismissed: (_) => _hide(org),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      child: card,
    );
  }
}
