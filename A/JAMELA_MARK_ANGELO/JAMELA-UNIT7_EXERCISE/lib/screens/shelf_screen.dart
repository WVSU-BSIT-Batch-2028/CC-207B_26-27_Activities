import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import '../models/pick.dart';
import '../services/contentful_pick_source.dart';
import '../services/open_library_api.dart';
import '../services/omdb_api.dart';

const contentfulSpaceId = String.fromEnvironment('CONTENTFUL_SPACE_ID');
const contentfulEnvironment =
    String.fromEnvironment('CONTENTFUL_ENVIRONMENT', defaultValue: 'master');
const contentfulToken = String.fromEnvironment('CONTENTFUL_DELIVERY_TOKEN');
const omdbKey = String.fromEnvironment('OMDB_KEY');

class ShelfScreen extends StatelessWidget {
  const ShelfScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Shelf'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'My Picks'),
              Tab(text: 'Books'),
              Tab(text: 'Movies'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            PicksTab(),
            SearchTab(kind: 'book'),
            SearchTab(kind: 'movie'),
          ],
        ),
      ),
    );
  }
}

class PicksTab extends StatefulWidget {
  const PicksTab({super.key});

  @override
  State<PicksTab> createState() => _PicksTabState();
}

class _PicksTabState extends State<PicksTab> {
  late Future<List<Pick>> _picksFuture;

  @override
  void initState() {
    super.initState();
    _picksFuture = _loadPicks();
  }

  Future<List<Pick>> _loadPicks() {
    if (contentfulSpaceId.isEmpty || contentfulToken.isEmpty) {
      return Future<List<Pick>>.error(
        Exception('Set your Contentful --dart-define values before running.'),
      );
    }

    return ContentfulPickSource(
      spaceId: contentfulSpaceId,
      environment: contentfulEnvironment,
      deliveryToken: contentfulToken,
    ).fetchPicks();
  }

  Future<void> _refresh() async {
    final nextRequest = _loadPicks();
    setState(() => _picksFuture = nextRequest);
    await nextRequest;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Pick>>(
      future: _picksFuture,
      builder: (context, snapshot) {
        final picks = snapshot.data ?? const <Pick>[];

        return RefreshIndicator(
          onRefresh: _refresh,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              if (snapshot.connectionState == ConnectionState.waiting)
                const ListTile(title: Text('Loading picks...'))
              else if (snapshot.hasError)
                ListTile(title: Text('Could not load picks: ${snapshot.error}'))
              else if (picks.isEmpty)
                const ListTile(title: Text('Nothing found.'))
              else
                ...picks.map(
                  (pick) => ListTile(
                    leading: Icon(
                      pick.kind == 'book' ? Icons.book : Icons.movie,
                    ),
                    title: Text(pick.title),
                    subtitle: Text(pick.note),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => PickDetailScreen(pick: pick),
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class PickDetailScreen extends StatefulWidget {
  const PickDetailScreen({super.key, required this.pick});

  final Pick pick;

  @override
  State<PickDetailScreen> createState() => _PickDetailScreenState();
}

class _PickDetailScreenState extends State<PickDetailScreen> {
  late final Future<Map<String, dynamic>> _detailsFuture;

  @override
  void initState() {
    super.initState();
    _detailsFuture = _loadDetails();
  }

  Future<Map<String, dynamic>> _loadDetails() async {
    final isBook = widget.pick.kind.toLowerCase() == 'book';

    if (isBook) {
      final uri = Uri.https(
        'openlibrary.org',
        '/works/${widget.pick.externalId}.json',
      );
      final response = await http.get(uri);

      if (response.statusCode != 200) {
        throw Exception(
          'Open Library request failed (${response.statusCode}).',
        );
      }

      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final descriptionValue = json['description'];

      String description;
      if (descriptionValue is String) {
        description = descriptionValue;
      } else if (descriptionValue is Map) {
        description =
            descriptionValue['value']?.toString() ?? 'No description yet.';
      } else {
        description = 'No description yet.';
      }

      final covers = (json['covers'] as List<dynamic>? ?? const [])
          .whereType<int>()
          .toList();

      return {
        'title': json['title'] as String? ?? widget.pick.title,
        'summary': description,
        'imageUrl': covers.isEmpty
            ? null
            : 'https://covers.openlibrary.org/b/id/${covers.first}-L.jpg',
      };
    }

    if (omdbKey.isEmpty) {
      throw Exception('Set OMDB_KEY using --dart-define when running.');
    }

    final uri = Uri.https('www.omdbapi.com', '/', {
      'apikey': omdbKey,
      'i': widget.pick.externalId,
      'plot': 'short',
    });
    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('OMDb request failed (${response.statusCode}).');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    if (json['Response'] == 'False') {
      throw Exception(json['Error'] as String? ?? 'Movie not found.');
    }

    final poster = json['Poster'] as String?;
    return {
      'title': json['Title'] as String? ?? widget.pick.title,
      'summary': json['Plot'] as String? ?? 'No plot available.',
      'imageUrl': poster == null || poster == 'N/A' ? null : poster,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.pick.title)),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _detailsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text('Could not load details: ${snapshot.error}'),
              ),
            );
          }

          final details = snapshot.data!;
          final imageUrl = details['imageUrl'] as String?;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (imageUrl != null)
                Center(
                  child: Image.network(
                    imageUrl,
                    height: 260,
                    errorBuilder: (_, __, ___) =>
                        const Icon(Icons.menu_book, size: 100),
                  ),
                )
              else
                const Center(child: Icon(Icons.menu_book, size: 100)),
              const SizedBox(height: 16),
              Text(
                details['title'] as String,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              Text(
                'Why I recommend it',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(widget.pick.note),
              const SizedBox(height: 16),
              Text(
                widget.pick.kind.toLowerCase() == 'book'
                    ? 'Description'
                    : 'Plot',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(details['summary'] as String),
            ],
          );
        },
      ),
    );
  }
}

class SearchTab extends StatefulWidget {
  const SearchTab({super.key, required this.kind});

  final String kind;

  @override
  State<SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  final TextEditingController _controller = TextEditingController();
  Timer? _debounce;
  Future<List<_SearchResult>>? _searchFuture;
  String _query = '';

  bool get _isBookSearch => widget.kind == 'book';

  void _onSearchChanged(String value) {
    _debounce?.cancel();

    final query = value.trim();
    setState(() {
      _query = query;
      _searchFuture = null;
    });

    if (query.length < 3) return;

    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (!mounted) return;

      setState(() {
        _searchFuture =
            _isBookSearch ? _searchBooks(query) : _searchMovies(query);
      });
    });
  }

  Future<List<_SearchResult>> _searchBooks(String query) async {
    final books = await OpenLibraryApi().search(query);

    return books
        .map(
          (book) => _SearchResult(
            id: book.id,
            title: book.title,
            subtitle: [
              if (book.authors.isNotEmpty) book.authors.first,
              if (book.year != null) book.year.toString(),
            ].join(' • '),
            imageUrl: book.coverUrl,
          ),
        )
        .toList();
  }

  Future<List<_SearchResult>> _searchMovies(String query) async {
    if (omdbKey.isEmpty) {
      throw Exception('Missing OMDb key. Set OMDB_KEY in env.json.');
    }

    final movies = await OmdbApi(omdbKey).search(query);

    return movies
        .map((movie) {
          final poster = movie['Poster'] as String?;

          return _SearchResult(
            id: movie['imdbID'] as String? ?? '',
            title: movie['Title'] as String? ?? 'Untitled',
            subtitle: movie['Year'] as String? ?? '',
            imageUrl: poster == null || poster == 'N/A' ? null : poster,
          );
        })
        .where((movie) => movie.id.isNotEmpty)
        .toList();
  }

  Future<void> _copyId(String id) async {
    await Clipboard.setData(ClipboardData(text: id));
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Copied ID: $id')),
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
    final future = _searchFuture;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: TextField(
            controller: _controller,
            onChanged: _onSearchChanged,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              hintText: _isBookSearch ? 'Search books' : 'Search movies',
              border: const OutlineInputBorder(),
              suffixIcon: _controller.text.isEmpty
                  ? null
                  : IconButton(
                      tooltip: 'Clear search',
                      onPressed: () {
                        _controller.clear();
                        _onSearchChanged('');
                      },
                      icon: const Icon(Icons.clear),
                    ),
            ),
          ),
        ),
        Expanded(
          child: future == null
              ? Center(
                  child: Text(
                    _query.length < 3
                        ? 'Enter at least 3 letters to search.'
                        : 'Waiting to search...',
                  ),
                )
              : FutureBuilder<List<_SearchResult>>(
                  future: future,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            'Search failed: ${snapshot.error}',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    }

                    final results = snapshot.data ?? [];
                    if (results.isEmpty) {
                      return const Center(child: Text('Nothing found.'));
                    }

                    return ListView.builder(
                      itemCount: results.length,
                      itemBuilder: (context, index) {
                        final result = results[index];

                        return ListTile(
                          leading: _SearchCover(imageUrl: result.imageUrl),
                          title: Text(result.title),
                          subtitle: Text(
                            result.subtitle.isEmpty
                                ? result.id
                                : '${result.subtitle}\n${result.id}',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          isThreeLine: result.subtitle.isNotEmpty,
                          trailing: IconButton(
                            tooltip: 'Copy ID',
                            icon: const Icon(Icons.copy),
                            onPressed: () => _copyId(result.id),
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

class _SearchResult {
  const _SearchResult({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
  });

  final String id;
  final String title;
  final String subtitle;
  final String? imageUrl;
}

class _SearchCover extends StatelessWidget {
  const _SearchCover({required this.imageUrl});

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final fallback = Container(
      width: 52,
      height: 68,
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      alignment: Alignment.center,
      child: const Icon(Icons.menu_book),
    );

    if (imageUrl == null) return fallback;

    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: Image.network(
        imageUrl!,
        width: 52,
        height: 68,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => fallback,
      ),
    );
  }
}
