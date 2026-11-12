import 'package:flutter/material.dart';
import '../models/pick.dart';
import '../services/cms_service.dart';
import '../services/omdb_api.dart';
import '../services/open_library_api.dart';

class PicksScreen extends StatefulWidget {
  const PicksScreen({super.key});

  @override
  State<PicksScreen> createState() => _PicksScreenState();
}

class _PicksScreenState extends State<PicksScreen>
    with AutomaticKeepAliveClientMixin {
  final PickSource source = ContentfulPickSource();
  late Future<List<Pick>> _future;

  @override
  bool get wantKeepAlive => true;

  Future<List<Pick>> _load() async {
    final picks = await source.fetchPicks();
    allPicks.value = picks;
    pickedIds.value = {for (final p in picks) p.externalId};
    return picks;
  }

  @override
  void initState() {
    super.initState();
    _future = _load(); 
  }

  Future<void> _refresh() async {
    final f = _load();
    setState(() => _future = f);
    try {
      await f;
    } catch (_) {
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder<List<Pick>>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                const SizedBox(height: 120),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        const Icon(Icons.error_outline, size: 48),
                        const SizedBox(height: 8),
                        Text('Could not load picks.\n${snapshot.error}',
                            textAlign: TextAlign.center),
                        const SizedBox(height: 12),
                        FilledButton(
                            onPressed: _refresh,
                            child: const Text('Try again')),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        final picks = snapshot.data!;
        if (picks.isEmpty) {
          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: const [
                SizedBox(height: 160),
                Center(child: Text('No picks yet.')),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: _refresh,
          child: ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: picks.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, i) {
              final p = picks[i];
              return ListTile(
                leading: Icon(
                  p.isBook ? Icons.menu_book_outlined : Icons.movie_outlined,
                ),
                title: Text(p.title),
                subtitle:
                    Text(p.note, maxLines: 2, overflow: TextOverflow.ellipsis),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => PickDetailScreen(pick: p)),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class PickDetailScreen extends StatefulWidget {
  final Pick pick;
  const PickDetailScreen({super.key, required this.pick});

  @override
  State<PickDetailScreen> createState() => _PickDetailScreenState();
}

class _PickDetailScreenState extends State<PickDetailScreen> {
  late Future<MediaDetails> _future;

  @override
  void initState() {
    super.initState();
    // Book -> Open Library, movie -> OMDb.
    _future = widget.pick.isBook
        ? OpenLibraryApi().fetchDetails(widget.pick.externalId)
        : OmdbApi().fetchDetails(widget.pick.externalId);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final pick = widget.pick;
    final fallbackIcon = pick.isBook ? Icons.menu_book_outlined : Icons.movie_outlined;

    return Scaffold(
      appBar: AppBar(title: Text(pick.title)),
      body: FutureBuilder<MediaDetails>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text('Could not load details.\n${snapshot.error}',
                    textAlign: TextAlign.center),
              ),
            );
          }
          final d = snapshot.data!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: d.imageUrl == null
                        ? Container(
                            width: 160,
                            height: 240,
                            color: theme.colorScheme.surfaceContainerHighest,
                            child: Icon(fallbackIcon, size: 64),
                          )
                        : Image.network(
                            d.imageUrl!,
                            height: 240,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              width: 160,
                              height: 240,
                              color: theme.colorScheme.surfaceContainerHighest,
                              child: Icon(fallbackIcon, size: 64),
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  d.title,
                  style: theme.textTheme.titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 2),
                Text(
                  '${pick.isBook ? 'Book · Open Library' : 'Movie · OMDb'} '
                  '${pick.externalId}'
                  '${d.year != null ? ' · ${d.year}' : ''}',
                  style: theme.textTheme.bodySmall,
                ),
                const SizedBox(height: 12),
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.format_quote,
                            color: theme.colorScheme.onSurface),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Why I recommend it',
                                style: theme.textTheme.labelMedium?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(pick.note,
                                  style: theme.textTheme.bodyMedium),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(d.summary, style: theme.textTheme.bodyMedium),
              ],
            ),
          );
        },
      ),
    );
  }
}