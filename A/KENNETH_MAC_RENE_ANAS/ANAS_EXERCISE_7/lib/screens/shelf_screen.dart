import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import '../data/contentful_pick_source.dart';
import '../data/omdb_api.dart';
import '../data/open_library_api.dart';
import '../models/book.dart';
import '../models/movie.dart';
import '../models/pick.dart';

const _contentfulSpaceId = String.fromEnvironment('CONTENTFUL_SPACE_ID');
const _contentfulDeliveryToken = String.fromEnvironment(
  'CONTENTFUL_DELIVERY_TOKEN',
);
const _contentfulEnvironment = String.fromEnvironment(
  'CONTENTFUL_ENVIRONMENT',
  defaultValue: 'master',
);
const _omdbKey = String.fromEnvironment('OMDB_KEY');

class ShelfScreen extends StatefulWidget {
  const ShelfScreen({super.key});

  @override
  State<ShelfScreen> createState() => _ShelfScreenState();
}

class _ShelfScreenState extends State<ShelfScreen> {
  late final http.Client _client;
  late final OpenLibraryApi _openLibrary;
  late final OmdbApi _omdb;
  late final ContentfulPickSource _contentful;

  @override
  void initState() {
    super.initState();
    _client = http.Client();
    _openLibrary = OpenLibraryApi(_client);
    _omdb = OmdbApi(_client, apiKey: _omdbKey);
    _contentful = ContentfulPickSource(
      _client,
      spaceId: _contentfulSpaceId,
      deliveryToken: _contentfulDeliveryToken,
      environment: _contentfulEnvironment,
    );
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
      child: Column(
        children: [
          const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.recommend_outlined), text: 'My Picks'),
              Tab(icon: Icon(Icons.menu_book_outlined), text: 'Books'),
              Tab(icon: Icon(Icons.local_movies_outlined), text: 'Movies'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                _MyPicksTab(
                  source: _contentful,
                  isConfigured:
                      _contentfulSpaceId.isNotEmpty &&
                      _contentfulDeliveryToken.isNotEmpty,
                  openLibrary: _openLibrary,
                  omdb: _omdb,
                ),
                _SearchTab<Book>(
                  search: _openLibrary.search,
                  idOf: (book) => book.workId,
                  imageUrlOf: (book) => book.coverUrl,
                  titleOf: (book) => book.title,
                  subtitleOf: (book) {
                    final author = book.authors.isEmpty
                        ? 'Author unknown'
                        : book.authors.first;
                    return book.year == null
                        ? author
                        : '$author • ${book.year}';
                  },
                  emptyQueryMessage: 'Search for a book by title or author.',
                ),
                _omdb.isConfigured
                    ? _SearchTab<Movie>(
                        search: _omdb.search,
                        idOf: (movie) => movie.imdbId,
                        imageUrlOf: (movie) => movie.posterUrl,
                        titleOf: (movie) => movie.title,
                        subtitleOf: (movie) => movie.year,
                        emptyQueryMessage: 'Search for a movie by title.',
                      )
                    : const _SetupMessage(
                        message:
                            'Add your OMDb key with '
                            '--dart-define=OMDB_KEY=your-key to search movies.',
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SetupMessage extends StatelessWidget {
  const _SetupMessage({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(message, textAlign: TextAlign.center),
      ),
    );
  }
}

class _MyPicksTab extends StatefulWidget {
  const _MyPicksTab({
    required this.source,
    required this.isConfigured,
    required this.openLibrary,
    required this.omdb,
  });

  final PickSource source;
  final bool isConfigured;
  final OpenLibraryApi openLibrary;
  final OmdbApi omdb;

  @override
  State<_MyPicksTab> createState() => _MyPicksTabState();
}

class _MyPicksTabState extends State<_MyPicksTab> {
  late Future<List<Pick>> _picksFuture;

  @override
  void initState() {
    super.initState();
    _picksFuture = widget.isConfigured
        ? widget.source.fetchPicks()
        : Future.value(const []);
  }

  Future<void> _refresh() {
    setState(() => _picksFuture = widget.source.fetchPicks());
    return _picksFuture.then<void>((_) {}, onError: (Object _) {});
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isConfigured) {
      return const _SetupMessage(
        message:
            'Configure CONTENTFUL_SPACE_ID and CONTENTFUL_DELIVERY_TOKEN '
            'to load your published picks.',
      );
    }

    return RefreshIndicator(
      onRefresh: _refresh,
      child: FutureBuilder<List<Pick>>(
        future: _picksFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: const [
                SizedBox(height: 180),
                Center(child: CircularProgressIndicator()),
              ],
            );
          }
          if (snapshot.hasError) {
            return ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(24),
              children: [
                const Icon(Icons.error_outline, size: 40),
                const SizedBox(height: 8),
                Text(
                  'Could not load picks: ${snapshot.error}',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Pull down to retry. Confirm the Contentful content type '
                  'ID is "pick" and its entries are published.',
                  textAlign: TextAlign.center,
                ),
              ],
            );
          }
          final picks = snapshot.data ?? const [];
          if (picks.isEmpty) {
            return ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: const [
                SizedBox(height: 180),
                Center(child: Text('No published picks yet.')),
              ],
            );
          }
          return ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: picks.length,
            separatorBuilder: (_, _) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final pick = picks[index];
              return ListTile(
                leading: Icon(
                  pick.kind == PickKind.book
                      ? Icons.menu_book_outlined
                      : Icons.local_movies_outlined,
                ),
                title: Text(pick.title),
                subtitle: Text(pick.note),
                isThreeLine: pick.note.length > 45,
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => PickDetailScreen(
                      pick: pick,
                      openLibrary: widget.openLibrary,
                      omdb: widget.omdb,
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

class _SearchTab<T> extends StatefulWidget {
  const _SearchTab({
    required this.search,
    required this.idOf,
    required this.imageUrlOf,
    required this.titleOf,
    required this.subtitleOf,
    required this.emptyQueryMessage,
  });

  final Future<List<T>> Function(String query) search;
  final String Function(T item) idOf;
  final String? Function(T item) imageUrlOf;
  final String Function(T item) titleOf;
  final String Function(T item) subtitleOf;
  final String emptyQueryMessage;

  @override
  State<_SearchTab<T>> createState() => _SearchTabState<T>();
}

class _SearchTabState<T> extends State<_SearchTab<T>> {
  final _controller = TextEditingController();
  Timer? _debounce;
  List<T> _items = const [];
  Object? _error;
  int _searchRevision = 0;
  bool _isDebouncing = false;
  bool _isSearching = false;
  bool _hasSearched = false;

  void _onChanged(String text) {
    _debounce?.cancel();
    final revision = ++_searchRevision;
    final query = text.trim();
    if (query.length < 3) {
      setState(() {
        _isDebouncing = false;
        _isSearching = false;
        _hasSearched = false;
        _items = const [];
        _error = null;
      });
      return;
    }
    setState(() {
      _isDebouncing = true;
      _isSearching = false;
      _hasSearched = false;
      _items = const [];
      _error = null;
    });
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      setState(() {
        _isDebouncing = false;
        _isSearching = true;
      });
      unawaited(_runSearch(query, revision));
    });
  }

  Future<void> _runSearch(String query, int revision) async {
    try {
      final items = await widget.search(query);
      if (!mounted || revision != _searchRevision) return;
      setState(() => _items = items);
    } catch (error) {
      if (!mounted || revision != _searchRevision) return;
      setState(() => _error = error);
    } finally {
      if (mounted && revision == _searchRevision) {
        setState(() {
          _isSearching = false;
          _hasSearched = true;
        });
      }
    }
  }

  Future<void> _copyId(T item) async {
    await Clipboard.setData(ClipboardData(text: widget.idOf(item)));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('ID copied. Paste it into Contentful.')),
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            controller: _controller,
            onChanged: _onChanged,
            decoration: const InputDecoration(
              labelText: 'Search',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
          ),
        ),
        Expanded(
          child: _isDebouncing
              ? const Center(child: Text('Searching in a moment…'))
              : _isSearching
              ? const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 12),
                      Text('Loading results…'),
                    ],
                  ),
                )
              : _error != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      'Search failed: $_error',
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              : !_hasSearched
              ? Center(
                  child: Text(
                    widget.emptyQueryMessage,
                    textAlign: TextAlign.center,
                  ),
                )
              : _items.isEmpty
              ? const Center(child: Text('Nothing found.'))
              : ListView.separated(
                  itemCount: _items.length,
                  separatorBuilder: (_, _) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final item = _items[index];
                    return ListTile(
                      leading: _CoverImage(url: widget.imageUrlOf(item)),
                      title: Text(widget.titleOf(item)),
                      subtitle: Text(widget.subtitleOf(item)),
                      trailing: IconButton(
                        tooltip: 'Copy ID',
                        icon: const Icon(Icons.copy),
                        onPressed: () => _copyId(item),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class _CoverImage extends StatelessWidget {
  const _CoverImage({required this.url});

  final String? url;

  @override
  Widget build(BuildContext context) {
    if (url == null) {
      return const SizedBox(
        width: 48,
        height: 64,
        child: Icon(Icons.image_not_supported_outlined),
      );
    }
    return Image.network(
      url!,
      width: 48,
      height: 64,
      fit: BoxFit.cover,
      errorBuilder: (_, _, _) => const SizedBox(
        width: 48,
        height: 64,
        child: Icon(Icons.image_not_supported_outlined),
      ),
    );
  }
}

class PickDetailScreen extends StatefulWidget {
  const PickDetailScreen({
    super.key,
    required this.pick,
    required this.openLibrary,
    required this.omdb,
  });

  final Pick pick;
  final OpenLibraryApi openLibrary;
  final OmdbApi omdb;

  @override
  State<PickDetailScreen> createState() => _PickDetailScreenState();
}

class _PickDetailScreenState extends State<PickDetailScreen> {
  late final Future<Object> _details;

  @override
  void initState() {
    super.initState();
    _details = switch (widget.pick.kind) {
      PickKind.book => widget.openLibrary.fetchDetails(widget.pick.externalId),
      PickKind.movie => widget.omdb.fetchDetails(widget.pick.externalId),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.pick.title)),
      body: FutureBuilder<Object>(
        future: _details,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'Could not load details: ${snapshot.error}',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
          final details = snapshot.data!;
          final title = details is Book
              ? details.title
              : (details as Movie).title;
          final imageUrl = details is Book
              ? details.coverUrl
              : (details as Movie).posterUrl;
          final summary = details is Book
              ? details.summary
              : (details as Movie).summary;
          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              if (imageUrl != null)
                Center(child: _DetailImage(url: imageUrl))
              else
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: Icon(Icons.image_not_supported_outlined, size: 72),
                  ),
                ),
              const SizedBox(height: 20),
              Text(title, style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 16),
              Text('My note', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 4),
              Text(widget.pick.note),
              const SizedBox(height: 20),
              Text('Summary', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 4),
              Text(summary.isEmpty ? 'No summary available.' : summary),
            ],
          );
        },
      ),
    );
  }
}

class _DetailImage extends StatelessWidget {
  const _DetailImage({required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      url,
      height: 260,
      fit: BoxFit.contain,
      errorBuilder: (_, _, _) => const SizedBox(
        height: 100,
        child: Icon(Icons.image_not_supported_outlined, size: 48),
      ),
    );
  }
}
