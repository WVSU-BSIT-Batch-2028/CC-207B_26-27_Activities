import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'contentful_pick_source.dart';
import 'pick.dart';
import 'pick_detail_screen.dart';
import 'pick_source.dart';

/// My Picks tab: the books and movies picked in the CMS.
class PicksTab extends StatefulWidget {
  const PicksTab({super.key});

  @override
  State<PicksTab> createState() => _PicksTabState();
}

class _PicksTabState extends State<PicksTab>
    with AutomaticKeepAliveClientMixin {
  // Keeps this tab's State alive when the user swipes to another tab.
  @override
  bool get wantKeepAlive => true;

  final PickSource _source = ContentfulPickSource(http.Client());
  late Future<List<Pick>> _future;

  // The request starts here, once, and again only in _refresh. If it were
  // in build(), every rebuild would send a new request.
  @override
  void initState() {
    super.initState();
    _future = _source.fetchPicks();
  }

  // Starts a new request and waits for it, so the pull-to-refresh spinner
  // stays until the CMS answers. Errors are shown by the FutureBuilder.
  Future<void> _refresh() async {
    setState(() {
      _future = _source.fetchPicks();
    });
    try {
      await _future;
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // required by AutomaticKeepAliveClientMixin
    return FutureBuilder<List<Pick>>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return _scrollable(
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.cloud_off, size: 48),
                const SizedBox(height: 12),
                Text('${snapshot.error}', textAlign: TextAlign.center),
                const SizedBox(height: 12),
                FilledButton.icon(
                  onPressed: _refresh,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                ),
              ],
            ),
          );
        }
        final picks = snapshot.data!;
        if (picks.isEmpty) {
          return _scrollable(const Center(child: Text('No picks yet.')));
        }
        return RefreshIndicator(
          onRefresh: _refresh,
          child: ListView.builder(
            // Lets you pull to refresh even when the list is short.
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: picks.length,
            itemBuilder: (context, i) => _buildPick(picks[i]),
          ),
        );
      },
    );
  }

  /// Error and empty messages also need to be pullable, so they go inside
  /// a scrollable that fills the screen.
  Widget _scrollable(Widget child) {
    return RefreshIndicator(
      onRefresh: _refresh,
      child: LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            // Full width, so the message is centered on the screen.
            child: SizedBox(
              width: double.infinity,
              child: Padding(padding: const EdgeInsets.all(24), child: child),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPick(Pick pick) {
    return ListTile(
      leading: Icon(pick.isBook ? Icons.menu_book : Icons.movie),
      title: Text(pick.title, maxLines: 2, overflow: TextOverflow.ellipsis),
      subtitle: pick.note.isEmpty
          ? null
          : Text(pick.note, maxLines: 2, overflow: TextOverflow.ellipsis),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => PickDetailScreen(pick: pick)),
      ),
    );
  }
}
