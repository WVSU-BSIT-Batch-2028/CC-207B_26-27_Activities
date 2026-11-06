import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

const omdbKey = String.fromEnvironment('OMDB_KEY');
const sanityProjectId = String.fromEnvironment('SANITY_PROJECT_ID');
const sanityDataset = String.fromEnvironment(
  'SANITY_DATASET',
  defaultValue: 'production',
);

const _requestTimeout = Duration(seconds: 20);

class ApiException implements Exception {
  final String message;
  const ApiException(this.message);

  @override
  String toString() => message;
}

class Book {
  final String workId;
  final String title;
  final List<String> authors;
  final int? year;
  final int? coverId;

  const Book({
    required this.workId,
    required this.title,
    required this.authors,
    this.year,
    this.coverId,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    final rawAuthors = json['author_name'];
    final authors = rawAuthors is List
        ? rawAuthors.whereType<String>().toList()
        : <String>[];
    final rawYear = json['first_publish_year'];
    final rawCover = json['cover_i'];

    return Book(
      workId: (json['key']?.toString() ?? '').split('/').last,
      title: json['title']?.toString() ?? 'Untitled',
      authors: authors,
      year: rawYear is int ? rawYear : int.tryParse('$rawYear'),
      coverId: rawCover is int ? rawCover : int.tryParse('$rawCover'),
    );
  }

  String? get coverUrl => coverId == null || coverId! <= 0
      ? null
      : 'https://covers.openlibrary.org/b/id/$coverId-M.jpg';
}

class Movie {
  final String imdbId;
  final String title;
  final String year;
  final String? posterUrl;

  const Movie({
    required this.imdbId,
    required this.title,
    required this.year,
    this.posterUrl,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    final poster = json['Poster']?.toString();
    return Movie(
      imdbId: json['imdbID']?.toString() ?? '',
      title: json['Title']?.toString() ?? 'Untitled',
      year: json['Year']?.toString() ?? 'Year unknown',
      posterUrl: poster == null || poster.isEmpty || poster == 'N/A'
          ? null
          : poster,
    );
  }
}

class Pick {
  final String title;
  final String kind;
  final String externalId;
  final String note;

  const Pick({
    required this.title,
    required this.kind,
    required this.externalId,
    required this.note,
  });

  factory Pick.fromSanity(Map<String, dynamic> json) => Pick(
        title: json['title']?.toString() ?? 'Untitled',
        kind: (json['kind']?.toString() ?? '').trim().toLowerCase(),
        externalId: (json['externalId']?.toString() ?? '').trim(),
        note: json['note']?.toString() ?? '',
      );
}

class ExternalDetails {
  final String title;
  final String? year;
  final String? imageUrl;
  final String summary;

  const ExternalDetails({
    required this.title,
    this.year,
    this.imageUrl,
    required this.summary,
  });
}

class OpenLibraryApi {
  
  Future<List<Book>> search(String query) async {
    final cleanQuery = query.trim();

    if (cleanQuery.length < 3) {
      return [];
    }

    Future<http.Response> sendRequest(
      Map<String, String> parameters,
    ) async {
      final uri = Uri.https(
        'openlibrary.org',
        '/search.json',
        parameters,
      );

      debugPrint('Open Library URL: $uri');

      return http.get(
        uri,
        headers: {
          'Accept': 'application/json',
          'User-Agent': 'Unit7FlutterExercise/1.0',
        },
      ).timeout(const Duration(seconds: 20));
    }

    var response = await sendRequest({
      'q': cleanQuery,
      'fields':
          'key,title,author_name,first_publish_year,cover_i',
      'limit': '20',
    });

    debugPrint('Open Library HTTP: ${response.statusCode}');

    if (response.statusCode == 422) {
      debugPrint('Retrying Open Library with simpler query...');

      response = await sendRequest({
        'q': cleanQuery,
        'limit': '20',
      });

      debugPrint('Retry HTTP: ${response.statusCode}');
    }

    if (response.statusCode != 200) {
      debugPrint(
        'Open Library error: ${response.body.substring(
          0,
          response.body.length > 500 ? 500 : response.body.length,
        )}',
      );

      throw ApiException(
        'Open Library HTTP ${response.statusCode}',
      );
    }

    final json =
        jsonDecode(response.body) as Map<String, dynamic>;

    final docs = json['docs'] as List<dynamic>? ?? [];

    return docs
        .map(
          (item) => Book.fromJson(
            item as Map<String, dynamic>,
          ),
        )
        .toList();
  }

  Future<ExternalDetails> getDetails(String workId) async {
    final id = workId.trim().split('/').last;
    final uri = Uri.https('openlibrary.org', '/works/$id.json');

    try {
      final response = await http.get(uri).timeout(_requestTimeout);
      if (response.statusCode != 200) {
        throw ApiException('Book details HTTP ${response.statusCode}');
      }

      final json = jsonDecode(utf8.decode(response.bodyBytes))
          as Map<String, dynamic>;
      final description = switch (json['description']) {
        final String text => text,
        {'value': final String text} => text,
        _ => 'No description available.',
      };

      final rawCovers = json['covers'];
      final firstCover = rawCovers is List && rawCovers.isNotEmpty
          ? rawCovers.first
          : null;
      final coverId = firstCover is int && firstCover > 0
          ? firstCover
          : null;
      final publishDate = json['first_publish_date']?.toString() ?? '';
      final year = RegExp(r'\b\d{4}\b').firstMatch(publishDate)?.group(0);

      return ExternalDetails(
        title: json['title']?.toString() ?? 'Untitled',
        year: year,
        imageUrl: coverId == null
            ? null
            : 'https://covers.openlibrary.org/b/id/$coverId-M.jpg',
        summary: description,
      );
    } on TimeoutException {
      throw const ApiException('Book details timed out. Try again.');
    }
  }
}

class OmdbApi {
  final String apiKey;
  const OmdbApi(this.apiKey);

  Future<Map<String, dynamic>> _get(Map<String, String> parameters) async {
    if (apiKey.trim().isEmpty) {
      throw const ApiException(
        'OMDB_KEY is missing. Restart Flutter with your real OMDb API key.',
      );
    }

    final uri = Uri.https('www.omdbapi.com', '/', {
      'apikey': apiKey,
      ...parameters,
    });

    try {
      debugPrint('OMDb request started');
      final response = await http.get(uri).timeout(_requestTimeout);
      debugPrint('OMDb HTTP: ${response.statusCode}');

      if (response.statusCode != 200) {
        throw ApiException('OMDb HTTP ${response.statusCode}');
      }

      final json = jsonDecode(utf8.decode(response.bodyBytes))
          as Map<String, dynamic>;
      if (json['Response'] == 'False') {
        throw ApiException(json['Error']?.toString() ?? 'OMDb API error.');
      }
      return json;
    } on TimeoutException {
      throw const ApiException('Movie request timed out. Try again.');
    }
  }

  Future<List<Movie>> search(String query) async {
    try {
      final json = await _get({'s': query, 'type': 'movie'});
      final results = json['Search'];
      if (results is! List) return <Movie>[];
      return results
          .whereType<Map<String, dynamic>>()
          .map(Movie.fromJson)
          .where((movie) => movie.imdbId.isNotEmpty)
          .toList();
    } on ApiException catch (error) {
      if (error.message.toLowerCase().contains('movie not found')) {
        return <Movie>[];
      }
      rethrow;
    }
  }

  Future<ExternalDetails> getDetails(String imdbId) async {
    final json = await _get({'i': imdbId.trim(), 'plot': 'short'});
    final poster = json['Poster']?.toString();
    final plot = json['Plot']?.toString();

    return ExternalDetails(
      title: json['Title']?.toString() ?? 'Untitled',
      year: json['Year']?.toString(),
      imageUrl: poster == null || poster.isEmpty || poster == 'N/A'
          ? null
          : poster,
      summary: plot == null || plot.isEmpty || plot == 'N/A'
          ? 'No summary available.'
          : plot,
    );
  }
}

abstract class PickSource {
  Future<List<Pick>> fetchPicks();
}

class SanityPickSource implements PickSource {
  final String projectId;
  final String dataset;

  const SanityPickSource({
    required this.projectId,
    required this.dataset,
  });

  @override
  Future<List<Pick>> fetchPicks() async {
    if (projectId.trim().isEmpty || dataset.trim().isEmpty) {
      throw const ApiException(
        'Missing Sanity configuration. Pass SANITY_PROJECT_ID and SANITY_DATASET using --dart-define.',
      );
    }

    const query =
        '*[_type == "pick"] | order(_createdAt desc) '
        '{title, kind, externalId, note}';
    final uri = Uri.https(
      '$projectId.api.sanity.io',
      '/v2025-02-19/data/query/$dataset',
      {'query': query, 'perspective': 'published'},
    );

    try {
      debugPrint('Loading published picks from Sanity');
      final response = await http.get(uri).timeout(_requestTimeout);
      debugPrint('Sanity HTTP: ${response.statusCode}');

      if (response.statusCode != 200) {
        throw ApiException(
          'Sanity HTTP ${response.statusCode}. Check the project ID, dataset, '
          'published documents, public dataset permissions, and web CORS.',
        );
      }
      final json = jsonDecode(utf8.decode(response.bodyBytes))
          as Map<String, dynamic>;
      final result = json['result'];
      if (result is! List) {
        throw const ApiException('Sanity returned an unexpected response.');
      }
      return result
          .whereType<Map<String, dynamic>>()
          .map(Pick.fromSanity)
          .toList();
    } on TimeoutException {
      throw const ApiException('Sanity request timed out. Try again.');
    }
  }
}

class ShelfScreen extends StatelessWidget {
  const ShelfScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const DefaultTabController(
      length: 3,
      child: Column(
        children: [
          Material(
            child: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.favorite), text: 'My Picks'),
                Tab(icon: Icon(Icons.menu_book), text: 'Books'),
                Tab(icon: Icon(Icons.movie), text: 'Movies'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [MyPicksTab(), BooksTab(), MoviesTab()],
            ),
          ),
        ],
      ),
    );
  }
}

class _CoverImage extends StatelessWidget {
  final String? url;
  final IconData fallbackIcon;

  const _CoverImage({required this.url, required this.fallbackIcon});

  @override
  Widget build(BuildContext context) {
    Widget fallback() => Center(child: Icon(fallbackIcon, size: 30));
    if (url == null || url!.isEmpty) return fallback();

    return Image.network(
      url!,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => fallback(),
    );
  }
}

void _copyId(BuildContext context, String id) {
  Clipboard.setData(ClipboardData(text: id));
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Copied ID: $id')),
  );
}

class _SearchResults<T> extends StatelessWidget {
  final Future<List<T>>? future;
  final bool debouncePending;
  final String emptyPrompt;
  final Widget Function(BuildContext context, T item) tileBuilder;
  final VoidCallback onRetry;

  const _SearchResults({
    required this.future,
    required this.debouncePending,
    required this.emptyPrompt,
    required this.tileBuilder,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    if (debouncePending) {
      return const Center(child: CircularProgressIndicator());
    }
    if (future == null) {
      return Center(child: Text(emptyPrompt));
    }

    return FutureBuilder<List<T>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Error: ${snapshot.error}', textAlign: TextAlign.center),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: onRetry,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Try again'),
                  ),
                ],
              ),
            ),
          );
        }
        final items = snapshot.data ?? <T>[];
        if (items.isEmpty) {
          return const Center(child: Text('Nothing found.'));
        }
        return ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) => tileBuilder(context, items[index]),
        );
      },
    );
  }
}

class BooksTab extends StatefulWidget {
  const BooksTab({super.key});

  @override
  State<BooksTab> createState() => _BooksTabState();
}

class _BooksTabState extends State<BooksTab>
    with AutomaticKeepAliveClientMixin<BooksTab> {
  final OpenLibraryApi _api = OpenLibraryApi();
  final TextEditingController _controller = TextEditingController();
  Timer? _debounce;
  Future<List<Book>>? _results;
  bool _debouncePending = false;

  @override
  bool get wantKeepAlive => true;

  void _onChanged(String text) {
    _debounce?.cancel();
    final query = text.trim();
    debugPrint('Book search input: $query');

    setState(() {
      _results = null;
      _debouncePending = query.length >= 3;
    });

    if (query.length < 3) return;
    _debounce = Timer(const Duration(milliseconds: 500), _searchNow);
  }

  void _searchNow() {
    _debounce?.cancel();
    final query = _controller.text.trim();
    if (!mounted) return;

    if (query.length < 3) {
      setState(() {
        _results = null;
        _debouncePending = false;
      });
      return;
    }

    debugPrint('Searching Open Library: $query');
    setState(() {
      _debouncePending = false;
      _results = _api.search(query);
    });
  }

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
          padding: const EdgeInsets.all(12),
          child: TextField(
            controller: _controller,
            onChanged: _onChanged,
            onSubmitted: (_) => _searchNow(),
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              labelText: 'Search books (3+ letters)',
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.search),
              suffixIcon: IconButton(
                icon: const Icon(Icons.arrow_forward),
                tooltip: 'Search books now',
                onPressed: _searchNow,
              ),
            ),
          ),
        ),
        Expanded(
          child: _SearchResults<Book>(
            future: _results,
            debouncePending: _debouncePending,
            emptyPrompt: 'Type at least 3 letters to search books.',
            onRetry: _searchNow,
            tileBuilder: (context, book) => ListTile(
              leading: SizedBox(
                width: 45,
                height: 64,
                child: _CoverImage(
                  url: book.coverUrl,
                  fallbackIcon: Icons.menu_book,
                ),
              ),
              title: Text(book.title),
              subtitle: Text(
                '${book.authors.isEmpty ? 'Unknown author' : book.authors.first} '
                '· ${book.year?.toString() ?? 'Year unknown'}',
              ),
              trailing: IconButton(
                icon: const Icon(Icons.copy),
                tooltip: 'Copy book ID',
                onPressed: () => _copyId(context, book.workId),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class MoviesTab extends StatefulWidget {
  const MoviesTab({super.key});

  @override
  State<MoviesTab> createState() => _MoviesTabState();
}

class _MoviesTabState extends State<MoviesTab>
    with AutomaticKeepAliveClientMixin<MoviesTab> {
  final OmdbApi _api = const OmdbApi(omdbKey);
  final TextEditingController _controller = TextEditingController();
  Timer? _debounce;
  Future<List<Movie>>? _results;
  bool _debouncePending = false;

  @override
  bool get wantKeepAlive => true;

  void _onChanged(String text) {
    _debounce?.cancel();
    final query = text.trim();
    debugPrint('Movie search input: $query');

    setState(() {
      _results = null;
      _debouncePending = query.length >= 3;
    });

    if (query.length < 3) return;
    _debounce = Timer(const Duration(milliseconds: 500), _searchNow);
  }

  void _searchNow() {
    _debounce?.cancel();
    final query = _controller.text.trim();
    if (!mounted) return;

    if (query.length < 3) {
      setState(() {
        _results = null;
        _debouncePending = false;
      });
      return;
    }

    debugPrint('Searching OMDb: $query');
    setState(() {
      _debouncePending = false;
      _results = _api.search(query);
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    if (omdbKey.trim().isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: SelectableText(
            'OMDB_KEY is missing. Restart Flutter with: '
            '--dart-define=OMDB_KEY=your_actual_api_key\n\n'
            'An IMDb movie ID (such as tt0816692) is NOT an API key.',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: TextField(
            controller: _controller,
            onChanged: _onChanged,
            onSubmitted: (_) => _searchNow(),
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              labelText: 'Search movies (3+ letters)',
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.search),
              suffixIcon: IconButton(
                icon: const Icon(Icons.arrow_forward),
                tooltip: 'Search movies now',
                onPressed: _searchNow,
              ),
            ),
          ),
        ),
        Expanded(
          child: _SearchResults<Movie>(
            future: _results,
            debouncePending: _debouncePending,
            emptyPrompt: 'Type at least 3 letters to search movies.',
            onRetry: _searchNow,
            tileBuilder: (context, movie) => ListTile(
              leading: SizedBox(
                width: 45,
                height: 64,
                child: _CoverImage(
                  url: movie.posterUrl,
                  fallbackIcon: Icons.movie,
                ),
              ),
              title: Text(movie.title),
              subtitle: Text(movie.year),
              trailing: IconButton(
                icon: const Icon(Icons.copy),
                tooltip: 'Copy movie ID',
                onPressed: () => _copyId(context, movie.imdbId),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class MyPicksTab extends StatefulWidget {
  const MyPicksTab({super.key});

  @override
  State<MyPicksTab> createState() => _MyPicksTabState();
}

class _MyPicksTabState extends State<MyPicksTab> {
  final PickSource _source = const SanityPickSource(
    projectId: sanityProjectId,
    dataset: sanityDataset,
  );
  late Future<List<Pick>> _picks;

  @override
  void initState() {
    super.initState();
    _picks = _source.fetchPicks();
  }

  Future<void> _refresh() async {
    final next = _source.fetchPicks();
    setState(() => _picks = next);
    try {
      await next;
    } catch (_) {
      // FutureBuilder
    }
  }

  Widget _refreshableMessage(String message) {
    return RefreshIndicator(
      onRefresh: _refresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          const SizedBox(height: 120),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Center(child: Text(message, textAlign: TextAlign.center)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Pick>>(
      future: _picks,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return _refreshableMessage(
            'Error: ${snapshot.error}\nPull down to retry.',
          );
        }
        final picks = snapshot.data ?? <Pick>[];
        if (picks.isEmpty) {
          return _refreshableMessage(
            'No published picks yet. Pull down to refresh.',
          );
        }

        return RefreshIndicator(
          onRefresh: _refresh,
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: picks.length,
            itemBuilder: (context, index) {
              final pick = picks[index];
              final isBook = pick.kind == 'book';
              return ListTile(
                leading: Icon(isBook ? Icons.menu_book : Icons.movie),
                title: Text(pick.title),
                subtitle: Text(
                  pick.note,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => PickDetailScreen(pick: pick),
                  ),
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
  late Future<ExternalDetails> _details;

  Future<ExternalDetails> _load() async {
    final pick = widget.pick;
    if (pick.externalId.isEmpty) {
      throw const ApiException('This pick has no externalId.');
    }
    if (pick.kind == 'book') {
      return OpenLibraryApi().getDetails(pick.externalId);
    }
    if (pick.kind == 'movie') {
      return OmdbApi(omdbKey).getDetails(pick.externalId);
    }
    throw ApiException('Unknown pick kind: ${pick.kind}');
  }

  @override
  void initState() {
    super.initState();
    _details = _load();
  }

  void _retry() {
    setState(() => _details = _load());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.pick.title)),
      body: FutureBuilder<ExternalDetails>(
        future: _details,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Error: ${snapshot.error}', textAlign: TextAlign.center),
                    const SizedBox(height: 12),
                    OutlinedButton(
                      onPressed: _retry,
                      child: const Text('Try again'),
                    ),
                  ],
                ),
              ),
            );
          }

          final details = snapshot.data!;
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: 120,
                  height: 180,
                  child: _CoverImage(
                    url: details.imageUrl,
                    fallbackIcon: widget.pick.kind == 'book'
                        ? Icons.menu_book
                        : Icons.movie,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                details.title,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              if (details.year != null) ...[
                const SizedBox(height: 4),
                Text('Year: ${details.year}'),
              ],
              const SizedBox(height: 20),
              Text(
                'Why I recommend it',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 6),
              Text(widget.pick.note),
              const SizedBox(height: 20),
              Text('Summary', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 6),
              Text(details.summary),
            ],
          );
        },
      ),
    );
  }
}
