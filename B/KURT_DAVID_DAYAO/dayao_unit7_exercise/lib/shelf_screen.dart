// Unit 7 Exercise: Shelf tabs, debounced search, CMS picks, and API details.
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import 'shelf_data.dart';

class ShelfScreen extends StatefulWidget {
  const ShelfScreen({super.key});

  @override
  State<ShelfScreen> createState() => _ShelfScreenState();
}

class _ShelfScreenState extends State<ShelfScreen> {
  late final http.Client _client;
  late final OpenLibraryApi _books;
  late final OmdbApi _movies;
  late final ContentfulPickSource _picks;

  @override
  void initState() {
    super.initState();
    _client = http.Client();
    _books = OpenLibraryApi(_client);
    _movies = OmdbApi(_client);
    _picks = ContentfulPickSource(_client);
  }

  @override
  void dispose() {
    _client.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Shelf'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.bookmark), text: 'My Picks'),
              Tab(icon: Icon(Icons.menu_book), text: 'Books'),
              Tab(icon: Icon(Icons.movie), text: 'Movies'),
            ],
          ),
        ),
        body: SafeArea(
          child: TabBarView(
            children: [
              MyPicksPage(source: _picks, books: _books, movies: _movies),
              ShelfSearchPage(
                label: 'Search books',
                search: (query) async {
                  final books = await _books.search(query);
                  return [
                    for (final book in books)
                      ShelfSearchResult(
                        id: book.workId,
                        title: book.title,
                        subtitle:
                            '${book.authors.isEmpty ? 'Unknown author' : book.authors.first}\n'
                            '${book.year ?? 'Year unavailable'}',
                        imageUrl: coverUrl(book.coverId),
                        movie: false,
                      ),
                  ];
                },
              ),
              ShelfSearchPage(
                label: 'Search movies',
                configured: omdbKey.isNotEmpty,
                search: (query) async {
                  final movies = await _movies.search(query);
                  return [
                    for (final movie in movies)
                      ShelfSearchResult(
                        id: movie.imdbId,
                        title: movie.title,
                        subtitle: movie.year,
                        imageUrl: movie.poster,
                        movie: true,
                      ),
                  ];
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ShelfSearchResult {
  const ShelfSearchResult({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.movie,
    this.imageUrl,
  });

  final String id;
  final String title;
  final String subtitle;
  final bool movie;
  final String? imageUrl;
}

class ShelfSearchPage extends StatefulWidget {
  const ShelfSearchPage({
    super.key,
    required this.label,
    required this.search,
    this.configured = true,
  });

  final String label;
  final Future<List<ShelfSearchResult>> Function(String query) search;
  final bool configured;

  @override
  State<ShelfSearchPage> createState() => _ShelfSearchPageState();
}

class _ShelfSearchPageState extends State<ShelfSearchPage>
    with AutomaticKeepAliveClientMixin {
  Timer? _debounce;
  Future<List<ShelfSearchResult>>? _results;
  String _query = '';

  @override
  bool get wantKeepAlive => true;

  void _onChanged(String text) {
    _debounce?.cancel();
    setState(() {
      _query = text.trim();
      // Detach the previous Future so old results cannot replace this query.
      _results = null;
    });
    if (_query.length < 3) return;
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      setState(() {
        _results = widget.search(_query);
      });
    });
  }

  void _retry() {
    setState(() {
      _results = widget.search(_query);
    });
  }

  Future<void> _copyId(String id) async {
    try {
      await Clipboard.setData(ClipboardData(text: id));
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text('Copied ID: $id')));
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Could not copy. ID: $id')));
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (!widget.configured) {
      return const Padding(
        padding: EdgeInsets.all(24),
        child: Center(
          child: SelectableText(
            'Movies needs an OMDb key.\n\n'
            'Add "OMDB_KEY": "your-key" to cms.json and restart:\n\n'
            'flutter run -d edge --dart-define-from-file=cms.json\n\n'
            'You can also pass --dart-define=OMDB_KEY=your-key.',
          ),
        ),
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: TextField(
            onChanged: _onChanged,
            decoration: InputDecoration(
              labelText: widget.label,
              hintText: 'Type at least 3 characters',
              prefixIcon: const Icon(Icons.search),
              border: const OutlineInputBorder(),
            ),
          ),
        ),
        Expanded(
          child: _results == null
              ? Center(
                  child: Text(
                    _query.length < 3
                        ? 'Type at least 3 characters to search.'
                        : 'Waiting for you to finish typing...',
                  ),
                )
              : FutureBuilder<List<ShelfSearchResult>>(
                  future: _results,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return ShelfMessage(
                        text: '${snapshot.error}',
                        onRetry: _retry,
                      );
                    }
                    final results = snapshot.data ?? const [];
                    if (results.isEmpty) {
                      return const Center(child: Text('Nothing found.'));
                    }
                    return ListView.separated(
                      itemCount: results.length,
                      separatorBuilder: (_, index) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final item = results[index];
                        return ListTile(
                          leading: ShelfImage(
                            url: item.imageUrl,
                            movie: item.movie,
                          ),
                          title: Text(item.title),
                          subtitle: Text('${item.subtitle}\nID: ${item.id}'),
                          isThreeLine: true,
                          trailing: IconButton(
                            tooltip: 'Copy ${item.id}',
                            onPressed: () => _copyId(item.id),
                            icon: const Icon(Icons.copy),
                          ),
                        );
                      },
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class MyPicksPage extends StatefulWidget {
  const MyPicksPage({
    super.key,
    required this.source,
    required this.books,
    required this.movies,
  });

  final PickSource source;
  final OpenLibraryApi books;
  final OmdbApi movies;

  @override
  State<MyPicksPage> createState() => _MyPicksPageState();
}

class _MyPicksPageState extends State<MyPicksPage>
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
    final next = widget.source.fetchPicks();
    setState(() {
      _future = next;
    });
    try {
      await next;
    } catch (_) {
      // FutureBuilder displays the failure.
    }
  }

  Widget _scrollMessage(Widget child) => ListView(
    physics: const AlwaysScrollableScrollPhysics(),
    children: [Padding(padding: const EdgeInsets.all(24), child: child)],
  );

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
      onRefresh: _refresh,
      child: FutureBuilder<List<Pick>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return _scrollMessage(
              const Center(child: CircularProgressIndicator()),
            );
          }
          if (snapshot.hasError) {
            return _scrollMessage(
              ShelfMessage(text: '${snapshot.error}', onRetry: _refresh),
            );
          }
          final picks = snapshot.data ?? const [];
          if (picks.isEmpty) {
            return _scrollMessage(
              const Text('No picks yet. Publish your picks in Contentful.'),
            );
          }
          return ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: picks.length,
            separatorBuilder: (_, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final pick = picks[index];
              return ListTile(
                leading: Icon(
                  pick.kind == 'book' ? Icons.menu_book : Icons.movie,
                ),
                title: Text(pick.title),
                subtitle: Text(pick.note),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.push<void>(
                    context,
                    MaterialPageRoute<void>(
                      builder: (_) => PickDetailScreen(
                        pick: pick,
                        books: widget.books,
                        movies: widget.movies,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class PickDetailScreen extends StatefulWidget {
  const PickDetailScreen({
    super.key,
    required this.pick,
    required this.books,
    required this.movies,
  });

  final Pick pick;
  final OpenLibraryApi books;
  final OmdbApi movies;

  @override
  State<PickDetailScreen> createState() => _PickDetailScreenState();
}

class _PickDetailScreenState extends State<PickDetailScreen> {
  late Future<ItemDetails> _future;

  Future<ItemDetails> _load() => widget.pick.kind == 'book'
      ? widget.books.details(widget.pick.externalId)
      : widget.movies.details(widget.pick.externalId);

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: Text(widget.pick.title)),
      body: SafeArea(
        child: FutureBuilder<ItemDetails>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return ShelfMessage(
                text: '${snapshot.error}',
                onRetry: () {
                  setState(() {
                    _future = _load();
                  });
                },
              );
            }
            final detail = snapshot.data!;
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Center(
                  child: ShelfImage(
                    url: detail.imageUrl,
                    movie: widget.pick.kind == 'movie',
                    large: true,
                  ),
                ),
                const SizedBox(height: 16),
                Text(detail.title, style: textTheme.headlineSmall),
                Text(
                  detail.year.isEmpty ? 'Year unavailable' : detail.year,
                  style: textTheme.bodyMedium,
                ),
                const SizedBox(height: 20),
                Text('My note', style: textTheme.titleMedium),
                const SizedBox(height: 6),
                Text(widget.pick.note),
                const SizedBox(height: 20),
                Text('Summary', style: textTheme.titleMedium),
                const SizedBox(height: 6),
                Text(detail.summary),
                const SizedBox(height: 20),
                Text(
                  widget.pick.kind == 'book'
                      ? 'Book data and cover: Open Library'
                      : 'Movie data: OMDb',
                  style: textTheme.bodySmall,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class ShelfImage extends StatelessWidget {
  const ShelfImage({
    super.key,
    required this.url,
    required this.movie,
    this.large = false,
  });

  final String? url;
  final bool movie;
  final bool large;

  @override
  Widget build(BuildContext context) {
    final width = large ? 180.0 : 48.0;
    final height = large ? 260.0 : 68.0;
    Widget placeholder() => ColoredBox(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Center(
        child: Icon(
          movie ? Icons.movie : Icons.menu_book,
          size: large ? 64 : 28,
        ),
      ),
    );

    return SizedBox(
      width: width,
      height: height,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: url == null
            ? placeholder()
            : Image.network(
                url!,
                fit: large ? BoxFit.contain : BoxFit.cover,
                errorBuilder: (context, error, stack) => placeholder(),
              ),
      ),
    );
  }
}

class ShelfMessage extends StatelessWidget {
  const ShelfMessage({super.key, required this.text, required this.onRetry});
  final String text;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(text, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            FilledButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}
