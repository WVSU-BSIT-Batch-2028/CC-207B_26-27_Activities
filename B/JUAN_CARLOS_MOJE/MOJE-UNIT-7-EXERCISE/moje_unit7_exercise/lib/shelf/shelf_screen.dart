import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import 'data.dart';

const omdbKey = String.fromEnvironment('OMDB_KEY');

class ShelfScreen extends StatefulWidget {
  const ShelfScreen({super.key});
  @override
  State<ShelfScreen> createState() => _ShelfScreenState();
}

class _ShelfScreenState extends State<ShelfScreen> {
  late final http.Client _client;
  late final OpenLibraryApi _books;
  late final OmdbApi _movies;
  late final PickSource _source;
  @override
  void initState() {
    super.initState();
    _client = http.Client();
    _books = OpenLibraryApi(_client);
    _movies = OmdbApi(_client, key: omdbKey);
    _source = ContentfulPickSource(
      _client,
      spaceId: const String.fromEnvironment('CMS_SPACE'),
      token: const String.fromEnvironment('CMS_TOKEN'),
      environment: const String.fromEnvironment(
        'CMS_ENVIRONMENT',
        defaultValue: 'master',
      ),
    );
  }

  @override
  void dispose() {
    _client.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => DefaultTabController(
    length: 3,
    child: Scaffold(
      appBar: AppBar(
        title: const Text('My Shelf'),
        bottom: const TabBar(
          tabs: [
            Tab(text: 'My Picks', icon: Icon(Icons.bookmark_outline)),
            Tab(text: 'Books', icon: Icon(Icons.menu_book_outlined)),
            Tab(text: 'Movies', icon: Icon(Icons.movie_outlined)),
          ],
        ),
      ),
      body: TabBarView(
        children: [
          PicksTab(source: _source, books: _books, movies: _movies),
          SearchTab(
            label: 'Books',
            search: (query) async => (await _books.search(query))
                .map(
                  (book) => SearchItem(
                    id: book.workId,
                    title: book.title,
                    image: book.cover,
                    subtitle:
                        '${book.authors.isEmpty ? 'Author unknown' : book.authors.first} · ${book.year ?? 'Year unknown'}',
                  ),
                )
                .toList(),
          ),
          omdbKey.isEmpty
              ? const SingleChildScrollView(
                  child: StateMessage(
                    icon: Icons.key_outlined,
                    title: 'Connect movie search',
                    message: 'Get a free key at omdbapi.com/apikey.aspx and activate it from your email. Add it as OMDB_KEY in cms.json, then restart the app:\n\nflutter run --dart-define-from-file=cms.json',
                  ),
                )
              : SearchTab(
                  label: 'Movies',
                  search: (query) async => (await _movies.search(query))
                      .map(
                        (movie) => SearchItem(
                          id: movie.id,
                          title: movie.title,
                          subtitle: movie.year,
                          image: movie.poster,
                        ),
                      )
                      .toList(),
                ),
        ],
      ),
    ),
  );
}

class StateMessage extends StatelessWidget {
  final IconData icon;
  final String title, message;
  final VoidCallback? onRetry;
  const StateMessage({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.onRetry,
  });
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(24),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 40, color: Theme.of(context).colorScheme.primary),
        const SizedBox(height: 16),
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(message, textAlign: TextAlign.center),
        if (onRetry != null) ...[
          const SizedBox(height: 16),
          OutlinedButton(onPressed: onRetry, child: const Text('Try again')),
        ],
      ],
    ),
  );
}

class Cover extends StatelessWidget {
  final String? url;
  final double width, height;
  const Cover({super.key, this.url, this.width = 50, this.height = 74});
  @override
  Widget build(BuildContext context) {
    final fallback = ColoredBox(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: const Center(child: Icon(Icons.auto_stories_outlined)),
    );
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        width: width,
        height: height,
        child: url == null
            ? fallback
            : Image.network(
                url!,
                fit: BoxFit.cover,
                errorBuilder: (_, error, stack) => fallback,
              ),
      ),
    );
  }
}

class SearchItem {
  final String id, title, subtitle;
  final String? image;
  const SearchItem({
    required this.id,
    required this.title,
    required this.subtitle,
    this.image,
  });
}

class SearchTab extends StatefulWidget {
  final String label;
  final Future<List<SearchItem>> Function(String) search;
  const SearchTab({super.key, required this.label, required this.search});
  @override
  State<SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab>
    with AutomaticKeepAliveClientMixin {
  final _controller = TextEditingController();
  Timer? _debounce;
  Future<List<SearchItem>>? _results;
  bool _waiting = false;
  @override
  bool get wantKeepAlive => true;
  void _onChanged(String text) {
    _debounce?.cancel();
    final query = text.trim();
    // Clear the old Future immediately so stale responses never replace a newer query.
    setState(() {
      _results = null;
      _waiting = query.length >= 3;
    });
    if (query.length < 3) return;
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      setState(() {
        _waiting = false;
        _results = widget.search(query);
      });
    });
  }

  void _retry() => setState(() {
    _results = widget.search(_controller.text.trim());
  });
  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            controller: _controller,
            onChanged: _onChanged,
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              labelText: 'Search ${widget.label.toLowerCase()}',
              hintText: widget.label == 'Books'
                  ? 'Try The Hobbit'
                  : 'Try Interstellar',
              helperText: 'Type at least 3 characters',
              prefixIcon: const Icon(Icons.search),
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                tooltip: 'Clear search',
                onPressed: () {
                  _controller.clear();
                  _onChanged('');
                },
                icon: const Icon(Icons.clear),
              ),
            ),
          ),
        ),
        Expanded(
          child: _waiting
              ? const Center(child: CircularProgressIndicator())
              : _results == null
              ? const SingleChildScrollView(
                  child: StateMessage(
                    icon: Icons.search,
                    title: 'Find your next favorite',
                    message: 'Search a title, then copy its ID to use in your CMS pick.',
                  ),
                )
              : FutureBuilder<List<SearchItem>>(
                  future: _results,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return SingleChildScrollView(
                        child: StateMessage(
                          icon: Icons.cloud_off,
                          title: 'Couldn’t load results',
                          message: '${snapshot.error}',
                          onRetry: _retry,
                        ),
                      );
                    }
                    final items = snapshot.data ?? [];
                    if (items.isEmpty) {
                      return const SingleChildScrollView(
                        child: StateMessage(
                          icon: Icons.search_off,
                          title: 'Nothing found',
                          message: 'Try a different title or spelling.',
                        ),
                      );
                    }
                    return ListView.separated(
                      padding: const EdgeInsets.fromLTRB(8, 0, 8, 16),
                      itemCount: items.length,
                      separatorBuilder: (_, index) => const Divider(),
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return ListTile(
                          leading: Cover(url: item.image),
                          title: Text(item.title),
                          subtitle: Text('${item.subtitle}\n${item.id}'),
                          isThreeLine: true,
                          trailing: IconButton(
                            tooltip: 'Copy ID',
                            icon: const Icon(Icons.copy_outlined),
                            onPressed: () async {
                              try {
                                await Clipboard.setData(
                                  ClipboardData(text: item.id),
                                );
                                if (!context.mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Copied ${item.id}')),
                                );
                              } catch (_) {
                                if (!context.mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Could not copy. Select the ID manually.',
                                    ),
                                  ),
                                );
                              }
                            },
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

class PicksTab extends StatefulWidget {
  final PickSource source;
  final OpenLibraryApi books;
  final OmdbApi movies;
  const PicksTab({
    super.key,
    required this.source,
    required this.books,
    required this.movies,
  });
  @override
  State<PicksTab> createState() => _PicksTabState();
}

class _PicksTabState extends State<PicksTab>
    with AutomaticKeepAliveClientMixin {
  late Future<List<Pick>> _picks;
  @override
  bool get wantKeepAlive => true;
  @override
  void initState() {
    super.initState();
    _picks = widget.source.fetchPicks();
  }

  Future<void> _refresh() async {
    final next = widget.source.fetchPicks();
    setState(() {
      _picks = next;
    });
    try {
      await next;
    } catch (_) {
      /* FutureBuilder displays the error. */
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
      onRefresh: _refresh,
      child: FutureBuilder<List<Pick>>(
        future: _picks,
        builder: (context, snapshot) {
          Widget? state;
          if (snapshot.connectionState != ConnectionState.done) {
            state = const Padding(
              padding: EdgeInsets.all(48),
              child: Center(child: CircularProgressIndicator()),
            );
          } else if (snapshot.hasError) {
            state = StateMessage(
              icon: Icons.cloud_off,
              title: 'Picks aren’t available yet',
              message:
                  '${snapshot.error}\n\nIn Contentful, publish a Pick content type (ID: pick) with title, kind, externalId and note.',
              onRetry: _refresh,
            );
          } else if (snapshot.data!.isEmpty) {
            state = StateMessage(
              icon: Icons.bookmark_add_outlined,
              title: 'Your shelf is waiting',
              message: 'Publish two book picks and two movie picks in Contentful, then pull down to refresh.',
              onRetry: _refresh,
            );
          }
          if (state != null) {
            return ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [state],
            );
          }
          final picks = snapshot.data!;
          return ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(12),
            itemCount: picks.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'My recommendations · pull down to refresh',
                        ),
                      ),
                      IconButton(
                        onPressed: _refresh,
                        tooltip: 'Refresh picks',
                        icon: const Icon(Icons.refresh),
                      ),
                    ],
                  ),
                );
              }
              final pick = picks[index - 1];
              return Card(
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: Icon(
                    pick.kind == 'book'
                        ? Icons.menu_book
                        : Icons.movie_outlined,
                  ),
                  title: Text(pick.title),
                  subtitle: Text(pick.note),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PickDetailScreen(
                        pick: pick,
                        books: widget.books,
                        movies: widget.movies,
                      ),
                    ),
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

class PickDetailScreen extends StatefulWidget {
  final Pick pick;
  final OpenLibraryApi books;
  final OmdbApi movies;
  const PickDetailScreen({
    super.key,
    required this.pick,
    required this.books,
    required this.movies,
  });
  @override
  State<PickDetailScreen> createState() => _PickDetailScreenState();
}

class _PickDetailScreenState extends State<PickDetailScreen> {
  late Future<ShelfDetail> _details;
  Future<ShelfDetail> _load() => widget.pick.kind == 'book'
      ? widget.books.details(widget.pick.externalId)
      : widget.movies.details(widget.pick.externalId);
  @override
  void initState() {
    super.initState();
    _details = _load();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(widget.pick.title)),
    body: FutureBuilder<ShelfDetail>(
      future: _details,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return SingleChildScrollView(
            child: StateMessage(
              icon: Icons.cloud_off,
              title: 'Couldn’t load details',
              message: '${snapshot.error}',
              onRetry: () => setState(() {
                _details = _load();
              }),
            ),
          );
        }
        final item = snapshot.data!;
        final theme = Theme.of(context);
        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 640),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Cover(url: item.image, width: 180, height: 260),
                  ),
                  const SizedBox(height: 20),
                  Text(item.title, style: theme.textTheme.headlineSmall),
                  const SizedBox(height: 8),
                  Text(item.year ?? 'Publication year unavailable'),
                  const SizedBox(height: 20),
                  Card(
                    color: theme.colorScheme.primaryContainer,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Why I recommend it',
                            style: theme.textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(widget.pick.note),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text('Summary', style: theme.textTheme.titleLarge),
                  const SizedBox(height: 8),
                  Text(item.summary, style: theme.textTheme.bodyLarge),
                  const SizedBox(height: 24),
                  Text(
                    widget.pick.kind == 'book'
                        ? 'Book data from Open Library'
                        : 'Movie data from OMDb',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ),
  );
}
