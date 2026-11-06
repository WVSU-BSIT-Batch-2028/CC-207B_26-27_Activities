import 'package:flutter/material.dart';

import '../data/api_exception.dart';
import '../data/omdb_api.dart';
import '../data/open_library_api.dart';
import '../data/pick.dart';
import '../data/pick_source.dart';
import 'pick_detail_screen.dart';

class PickListTab extends StatefulWidget {
  const PickListTab({
    super.key,
    required this.source,
    required this.books,
    required this.movies,
  });

  final PickSource source;
  final OpenLibraryApi books;
  final OmdbApi movies;

  @override
  State<PickListTab> createState() => _PickListTabState();
}

class _PickListTabState extends State<PickListTab> {
  late Future<List<Pick>> _picks;

  @override
  void initState() {
    super.initState();
    _picks = widget.source.fetchPicks();
  }

  Future<void> _refresh() async {
    final request = widget.source.fetchPicks();
    setState(() {
      _picks = request;
    });
    await request;
  }

  void _openPick(Pick pick) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
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
    return FutureBuilder<List<Pick>>(
      future: _picks,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting &&
            !snapshot.hasError) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          final error = snapshot.error;
          final message = error is ApiException
              ? error.message
              : 'Could not load recommendations from Strapi.';
          return _RefreshableMessage(
            message: message,
            action: TextButton.icon(
              onPressed: _refresh,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Try again'),
            ),
            onRefresh: _refresh,
          );
        }

        final picks = snapshot.data ?? const [];
        if (picks.isEmpty) {
          return _RefreshableMessage(
            message: 'No picks yet. Publish your recommendations in Strapi.',
            onRefresh: _refresh,
          );
        }

        return RefreshIndicator(
          onRefresh: _refresh,
          child: ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(12),
            itemCount: picks.length,
            separatorBuilder: (_, _) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final pick = picks[index];
              return Card(
                margin: EdgeInsets.zero,
                child: ListTile(
                  leading: CircleAvatar(
                    child: Icon(
                      pick.kind == PickKind.book
                          ? Icons.menu_book_rounded
                          : Icons.movie_outlined,
                    ),
                  ),
                  title: Text(
                    pick.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    pick.note,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => _openPick(pick),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _RefreshableMessage extends StatelessWidget {
  const _RefreshableMessage({
    required this.message,
    required this.onRefresh,
    this.action,
  });

  final String message;
  final Widget? action;
  final Future<void> Function()? onRefresh;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh ?? () async {},
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(24),
        children: [
          const SizedBox(height: 100),
          Icon(
            Icons.library_books_outlined,
            size: 44,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 16),
          Text(message, textAlign: TextAlign.center),
          if (action != null) ...[
            const SizedBox(height: 8),
            Center(child: action),
          ],
        ],
      ),
    );
  }
}
