import 'package:flutter/material.dart';

import '../data/orgs.dart';
import '../models/registration.dart';
import '../widgets/org_card.dart';
import '../widgets/state_message.dart';
import 'org_detail_screen.dart';

class OrgListScreen extends StatefulWidget {
  const OrgListScreen({
    super.key,
    required this.repository,
    required this.memberships,
    required this.onJoined,
  });

  final OrgRepository repository;
  final Map<String, Registration> memberships;
  final void Function(Org org, Registration registration) onJoined;

  @override
  State<OrgListScreen> createState() => _OrgListScreenState();
}

class _OrgListScreenState extends State<OrgListScreen> {
  late Future<List<Org>> _orgsFuture;
  final _searchController = TextEditingController();
  String _query = '';
  final Set<String> _hiddenIds = {};
  final Set<String> _favoriteIds = {};
  final Set<OrgCategory> _selectedCategories = {};
  bool _isGrid = false;

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
      if (!_favoriteIds.add(org.id)) {
        _favoriteIds.remove(org.id);
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
    if (registration != null && mounted) widget.onJoined(org, registration);
  }

  void _toggleCategory(OrgCategory category) {
    setState(() {
      if (!_selectedCategories.add(category)) {
        _selectedCategories.remove(category);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CICT Org Fair'),
        actions: [
          IconButton(
            tooltip: _isGrid ? 'Show list' : 'Show grid',
            icon: Icon(_isGrid ? Icons.view_list : Icons.grid_view),
            onPressed: () => setState(() => _isGrid = !_isGrid),
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
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
              ),
              child: const Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  'CICT Org Fair 2026',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('About the fair'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/about');
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
      ),
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
            final errorText = snapshot.error.toString().replaceFirst(
              'Exception: ',
              '',
            );
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
        .where(
          (o) =>
              _selectedCategories.isEmpty ||
              _selectedCategories.contains(o.category),
        )
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
            onChanged: (value) => setState(() => _query = value),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              for (final category in OrgCategory.values)
                FilterChip(
                  label: Text(category.label),
                  selected: _selectedCategories.contains(category),
                  onSelected: (_) => _toggleCategory(category),
                ),
            ],
          ),
        ),
        Expanded(
          child: visible.isEmpty
              ? const StateMessage(
                  icon: Icons.search_off,
                  text: 'No organizations match your filters.',
                )
              : _isGrid
              ? GridView.builder(
                  padding: const EdgeInsets.all(8),
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 240,
                    mainAxisSpacing: 4,
                    crossAxisSpacing: 4,
                    mainAxisExtent: 220,
                  ),
                  itemCount: visible.length,
                  itemBuilder: (_, i) => _card(visible[i], isGrid: true),
                )
              : ListView.builder(
                  itemCount: visible.length,
                  itemBuilder: (_, i) => _card(visible[i]),
                ),
        ),
      ],
    );
  }

  Widget _card(Org org, {bool isGrid = false}) {
    final card = OrgCard(
      org: org,
      isFavorite: _favoriteIds.contains(org.id),
      isMember: widget.memberships.containsKey(org.id),
      isGrid: isGrid,
      onTap: () => _openDetail(org),
      onFavorite: () => _toggleFavorite(org),
    );
    if (isGrid) return card;
    return Dismissible(
      key: ValueKey(org.id),
      onDismissed: (_) => _hide(org),
      background: Container(
        color: Colors.red.shade100,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Icon(Icons.archive_outlined),
      ),
      child: card,
    );
  }
}
