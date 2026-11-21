import 'package:flutter/material.dart';

import '../data/omdb_api.dart';
import '../data/open_library_api.dart';
import '../data/pick_source.dart';
import '../models/pick.dart';
import 'pick_detail_screen.dart';
import 'shelf_widgets.dart';

class PicksTab extends StatefulWidget {
  const PicksTab({
    super.key,
    required this.source,
    required this.books,
    required this.movies,
  });

  final PickSource source;
  final OpenLibraryApi books;
  final OmdbApi movies;

  @override
  State<PicksTab> createState() => _PicksTabState();
}

class _PicksTabState extends State<PicksTab>
    with AutomaticKeepAliveClientMixin {
  late Future<List<Pick>> _future;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _future = widget.source.fetchPicks();
  }

  Future<void> _refresh() async {
    final future = widget.source.fetchPicks();
    setState(() {
      _future = future;
    });
    try {
      await future;
    } catch (_) {}
  }

  void _open(Pick pick) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PickDetailScreen(
          pick: pick,
          books: widget.books,
          movies: widget.movies,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder<List<Pick>>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const CenterMessage(
            icon: Icons.hourglass_top,
            text: 'Loading my picks...',
            spinner: true,
          );
        }
        if (snapshot.hasError) {
          return CenterMessage(
            icon: Icons.cloud_off,
            text: '${snapshot.error}',
            action: FilledButton.icon(
              onPressed: _refresh,
              icon: const Icon(Icons.refresh),
              label: const Text('Try again'),
            ),
          );
        }
        final picks = snapshot.data!;
        return RefreshIndicator(
          onRefresh: _refresh,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              if (picks.isEmpty)
                const Padding(
                  padding: EdgeInsets.only(top: 120),
                  child: CenterMessage(
                    icon: Icons.bookmark_border,
                    text: 'No picks yet. Add some in the CMS.',
                  ),
                )
              else
                for (final pick in picks)
                  ListTile(
                    leading: Icon(
                      pick.kind == PickKind.book ? Icons.menu_book : Icons.movie,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    title: Text(pick.title),
                    subtitle: Text(pick.note, maxLines: 2, overflow: TextOverflow.ellipsis),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _open(pick),
                  ),
            ],
          ),
        );
      },
    );
  }
}
