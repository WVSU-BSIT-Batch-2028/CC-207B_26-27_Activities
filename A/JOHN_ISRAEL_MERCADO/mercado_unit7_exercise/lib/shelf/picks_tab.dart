import 'package:flutter/material.dart';

import 'api.dart';
import 'models.dart';
import 'pick_detail_screen.dart';

class PicksTab extends StatefulWidget {
  const PicksTab({super.key});

  @override
  State<PicksTab> createState() => _PicksTabState();
}

class _PicksTabState extends State<PicksTab>
    with AutomaticKeepAliveClientMixin {
  final PickSource _source = ContentfulPickSource();
  late Future<List<Pick>> _picks;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _picks = _source.fetchPicks();
  }

  Future<void> _refresh() async {
    setState(() {
      _picks = _source.fetchPicks();
    });
    try {
      await _picks;
    } catch (_) {}
  }

  Widget _scrollableMessage(String text) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        Padding(
          padding: const EdgeInsets.all(24),
          child: Text(text, textAlign: TextAlign.center),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
      onRefresh: _refresh,
      child: FutureBuilder<List<Pick>>(
        future: _picks,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return _scrollableMessage(
              'Could not load picks: ${snapshot.error}\n\nPull down to try again.',
            );
          }
          final picks = snapshot.data!;
          if (picks.isEmpty) {
            return _scrollableMessage(
              'No picks yet. Publish some in Contentful.',
            );
          }
          return ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: picks.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final pick = picks[index];
              return ListTile(
                leading: Icon(
                  pick.kind == 'movie' ? Icons.movie : Icons.menu_book,
                ),
                title: Text(pick.title),
                subtitle: Text(
                  pick.note,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PickDetailScreen(pick: pick),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
