import 'package:flutter/material.dart';

import '../data/orgs.dart';
import '../models/membership.dart';
import '../models/registration.dart';
import '../widgets/org_card.dart';
import '../widgets/org_tile.dart';
import '../widgets/state_message.dart';
import 'about_screen.dart';
import 'org_detail_screen.dart';

class OrgListScreen extends StatefulWidget {
  const OrgListScreen({
    super.key,
    required this.repository,
    required this.memberships,
    required this.onJoined,
  });

  final OrgRepository repository;

  /// The orgs the student joined. HomeShell owns this map.
  final Map<String, Membership> memberships;

  /// Call this to tell HomeShell about a new membership.
  final ValueChanged<Membership> onJoined;

  @override
  State<OrgListScreen> createState() => _OrgListScreenState();
}

class _OrgListScreenState extends State<OrgListScreen> {
  late Future<List<Org>> _orgsFuture;
  final _searchController = TextEditingController();
  String _query = '';
  final Set<String> _hiddenIds = {};
  final Set<String> _favoriteIds = {};

  /// The categories picked with the filter chips. Empty means "all".
  final Set<OrgCategory> _categories = {};
  bool _showGrid = false;

  @override
  void initState() {
    super.initState();
    _orgsFuture = widget.repository.fetchOrgs();
  }

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
      if (!_favoriteIds.remove(org.id)) _favoriteIds.add(org.id);
    });
  }

  void _toggleCategory(OrgCategory category, bool selected) {
    // TODO 7: Add the category to _categories when it is selected, and
    setState(() {
  if (selected) {
    _categories.add(category);
  } else {
    _categories.remove(category);
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
            onPressed: () => setState(() => _hiddenIds.remove(org.id)),
          ),
        ),
      );
  }

  Future<void> _openDetail(Org org) async {
    final registration = await Navigator.of(context).push<Registration>(
      MaterialPageRoute(
        builder: (_) => OrgDetailScreen(
          org: org,
          isMember: widget.memberships.containsKey(org.id),
        ),
      ),
    );
    if (registration != null) {
      // TODO 5: This screen no longer saves the registration itself.
      //   Wrap it in a Membership and pass it up with widget.onJoined.
      widget.onJoined(Membership(org: org, registration: registration));
    }
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
            ),
            child: const Align(
              alignment: Alignment.bottomLeft,
              child: Text('CICT Org Fair 2026', style: TextStyle(fontSize: 22)),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('About the fair'),
            // EXPLAIN E3: The drawer is a layer on top of the current screen. If I
            // only push the About screen, the drawer stays open underneath it,
            // and it is still open when the user comes back (C4). Navigator.pop
            // closes the drawer first, so About opens from a clean Orgs screen.
            // TODO 6: Close the drawer, then open the About screen by its
            //   route name (AboutScreen.routeName).
onTap: () {
  Navigator.pop(context);
  Navigator.pushNamed(context, AboutScreen.routeName);
},
          ),
          ListTile(
            leading: const Icon(Icons.refresh),
            title: const Text('Reload orgs'),
            onTap: () {
              Navigator.pop(context);
              _reload();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CICT Org Fair'),
        actions: [
          IconButton(
            tooltip: _showGrid ? 'Show as list' : 'Show as grid',
            icon: Icon(_showGrid ? Icons.view_list : Icons.grid_view),
            onPressed: () => setState(() => _showGrid = !_showGrid),
          ),
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
      drawer: _buildDrawer(),
      body: FutureBuilder<List<Org>>(
        future: _orgsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const StateMessage(
              icon: Icons.hourglass_top,
              text: 'Loading organizations...',
              showSpinner: true,
            );
          }
          if (snapshot.hasError) {
            return StateMessage(
              icon: Icons.wifi_off,
              text: snapshot.error.toString().replaceFirst('Exception: ', ''),
              action: FilledButton.icon(
                onPressed: _reload,
                icon: const Icon(Icons.refresh),
                label: const Text('Try again'),
              ),
            );
          }
          final orgs = snapshot.data ?? const <Org>[];
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
          return _buildOrgs(orgs);
        },
      ),
    );
  }

  Widget _buildOrgs(List<Org> orgs) {
    final q = _query.trim().toLowerCase();
    final visible = orgs
        .where((o) => !_hiddenIds.contains(o.id))
        .where((o) =>
            q.isEmpty ||
            o.name.toLowerCase().contains(q) ||
            o.acronym.toLowerCase().contains(q))
        // TODO 8: Keep only the orgs whose category is in _categories.
        //   When no chip is selected (_categories is empty), keep them all.
.where((o) => _categories.isEmpty || _categories.contains(o.category))
        .toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
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
            onChanged: (value) => setState(() => _query = value),
          ),
        ),
        // EXPLAIN E4: Wrap moves the chips that don't fit onto the next line, so
        // every chip stays visible. A Row never wraps. It gives its children
        // a fixed line, so when the chips are wider than the screen it
        // overflows and shows the yellow and black stripe (C2).
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Wrap(
            spacing: 8,
            children: [
              for (final category in OrgCategory.values)
                FilterChip(
                  label: Text(category.label),
                  selected: _categories.contains(category),
                  onSelected: (selected) => _toggleCategory(category, selected),
                ),
            ],
          ),
        ),
        Expanded(
          child: visible.isEmpty
              ? const StateMessage(
                  icon: Icons.search_off,
                  text: 'No organizations match your search.',
                )
              : _showGrid
                  ? _buildGrid(visible)
                  : ListView.builder(
                      itemCount: visible.length,
                      itemBuilder: (_, i) => _card(visible[i]),
                    ),
        ),
      ],
    );
  }

  Widget _buildGrid(List<Org> visible) {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      // EXPLAIN E5: The column count is ceil((width + spacing) / (maxExtent +
      // spacing)). On a 360-wide phone with 8px padding, 344px is usable, so
      // (344+8)/208 rounds up to 2 columns, and each tile is (344-8)/2 = 168
      // wide. On a 1000-wide window, 984px is usable, so (984+8)/208 rounds up
      // to 5 columns, and each tile is (984-4*8)/5 = 190.4 wide. So no tile
      // is wider than 200, and the count grows with the screen.
      // TODO 9: Let the screen width decide the number of columns.
      //   Use SliverGridDelegateWithMaxCrossAxisExtent with
      //   maxCrossAxisExtent: 200, spacing 8 both ways, and
      //   childAspectRatio: 0.9.
gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
  maxCrossAxisExtent: 200,
  mainAxisSpacing: 8,
  crossAxisSpacing: 8,
  childAspectRatio: 0.9,
),
      itemCount: visible.length,
      itemBuilder: (_, i) {
        final org = visible[i];
        return OrgTile(
          org: org,
          isFavorite: _favoriteIds.contains(org.id),
          isMember: widget.memberships.containsKey(org.id),
          onTap: () => _openDetail(org),
          onLongPress: () => _toggleFavorite(org),
        );
      },
    );
  }

  Widget _card(Org org) {
    final card = OrgCard(
      org: org,
      isFavorite: _favoriteIds.contains(org.id),
      isMember: widget.memberships.containsKey(org.id),
      onTap: () => _openDetail(org),
      onLongPress: () => _toggleFavorite(org),
    );
    return Dismissible(
      key: ValueKey(org.id),
      onDismissed: (_) => _hide(org),
      background: Container(
        color: Theme.of(context).colorScheme.errorContainer,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 24),
        child: const Icon(Icons.visibility_off),
      ),
      child: card,
    );
  }
}
