
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
    _orgsFuture = widget.repository.fetchOrgs();
  }

  // EXPLAIN E2: Why dispose the search controller?
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _reload() {
    setState(() {
      _orgsFuture = widget.repository.fetchOrgs();
    });
  }

  void _setServerMode(ServerMode mode) {
    widget.repository.mode = mode;
    _reload();
  }

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
    setState(() => _hiddenIds.add(org.id));

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('${org.acronym} hidden'),
          action: SnackBarAction(
            label: 'UNDO',
            onPressed: () {
              setState(() => _hiddenIds.remove(org.id));
            },
          ),
        ),
      );
  }

  // EXPLAIN E7: What does Navigator.push return?
  Future<void> _openDetail(Org org) async {
    final registration = await Navigator.of(context).push<Registration>(
      MaterialPageRoute(
        builder: (_) => OrgDetailScreen(
          org: org,
          isMember: _registrations.containsKey(org.id),
        ),
      ),
    );

    if (registration != null) {
      setState(() => _registrations[org.id] = registration);
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
                CheckedPopupMenuItem(
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
          // Loading state
          if (snapshot.connectionState != ConnectionState.done) {
            return const StateMessage(
              icon: Icons.hourglass_top,
              text: 'Loading organizations...',
              showSpinner: true,
            );
          }

          // TODO 4: Error state
          if (snapshot.hasError) {
            return StateMessage(
              icon: Icons.wifi_off,
              text: snapshot.error
                  .toString()
                  .replaceFirst('Exception: ', ''),
              action: FilledButton.icon(
                onPressed: _reload,
                icon: const Icon(Icons.refresh),
                label: const Text('Try again'),
              ),
            );
          }

          final orgs = snapshot.data ?? const <Org>[];

          // TODO 5: Empty state
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

          // Success state
          return _buildOrgs(orgs);
        },
      ),
    );
  }

  Widget _buildOrgs(List<Org> orgs) {
    final q = _query.trim().toLowerCase();

    final visible = orgs
        .where((o) => !_hiddenIds.contains(o.id))
        .where(
          (o) =>
              q.isEmpty ||
              o.name.toLowerCase().contains(q) ||
              o.acronym.toLowerCase().contains(q),
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
                        setState(() => _query = '');
                      },
                    ),
            ),

            // TODO 6: Update the search query
            onChanged: (value) {
              setState(() => _query = value);
            },
          ),
        ),

        // Expanded gives the list the remaining available height.
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
                        itemBuilder: (_, i) => _card(visible[i]),
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
                      itemBuilder: (_, i) => _card(visible[i]),
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

    // TODO 7: Swipe an organization card to hide it.
    return Dismissible(
      key: ValueKey(org.id),
      onDismissed: (_) => _hide(org),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.all(16),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: card,
    );
  }
}
