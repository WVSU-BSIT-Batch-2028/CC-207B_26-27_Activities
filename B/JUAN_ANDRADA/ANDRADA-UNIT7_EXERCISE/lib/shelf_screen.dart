import 'dart:async';
import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

// Put in the app when it is built: --dart-define-from-file=cms.json
const omdbKey = String.fromEnvironment('OMDB_KEY');
const cmsSpace = String.fromEnvironment('CMS_SPACE');
const cmsToken = String.fromEnvironment('CMS_TOKEN');

final openLibraryApi = OpenLibraryApi();
final omdbApi = OmdbApi();
final PickSource pickSource = ContentfulPickSource(
  spaceId: cmsSpace,
  token: cmsToken,
);

// ---------------------------------------------------------------------------
// Shared API helper
// ---------------------------------------------------------------------------

/// A problem the user should read: no internet, a bad key, and so on.
class ApiException implements Exception {
  const ApiException(this.message);

  final String message;

  @override
  String toString() => message;
}

/// Sends a GET request. The messages never include the URL, because the
/// OMDb URL has the key in it.
Future<http.Response> _get(http.Client client, Uri uri, String apiName) async {
  try {
    return await client.get(uri).timeout(const Duration(seconds: 10));
  } on TimeoutException {
    throw ApiException('$apiName took too long to answer. Try again.');
  } on http.ClientException {
    throw const ApiException(
      'No connection. Check your internet and try again.',
    );
  }
}

/// What the details screen shows, the same for a book and a movie.
class PickDetails {
  const PickDetails({
    required this.title,
    required this.summary,
    this.imageUrl,
  });

  final String title;
  final String summary;
  final String? imageUrl;
}

// ---------------------------------------------------------------------------
// Books (Open Library)
// ---------------------------------------------------------------------------

class Book {
  const Book({
    required this.workId,
    required this.title,
    required this.authors,
    this.year,
    this.coverId,
  });

  factory Book.fromJson(Map<String, dynamic> json) => Book(
    workId: (json['key'] as String).split('/').last,
    title: json['title'] as String,
    // author_name is missing for some books, and it is a list.
    authors: [...?(json['author_name'] as List<dynamic>?)?.cast<String>()],
    year: json['first_publish_year'] as int?,
    coverId: json['cover_i'] as int?,
  );

  final String workId;
  final String title;
  final List<String> authors;
  final int? year;
  final int? coverId;

  String? get coverUrl => coverId == null ? null : _coverUrl(coverId!);
}

String _coverUrl(int coverId) =>
    'https://covers.openlibrary.org/b/id/$coverId-M.jpg';

class OpenLibraryApi {
  OpenLibraryApi({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Future<List<Book>> search(String query) async {
    final uri = Uri.https('openlibrary.org', '/search.json', {
      'q': query,
      'fields': 'key,title,author_name,first_publish_year,cover_i',
      'limit': '20',
    });
    final response = await _get(_client, uri, 'Open Library');
    if (response.statusCode != 200) {
      throw ApiException('Open Library answered ${response.statusCode}.');
    }
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    return [
      for (final doc in json['docs'] as List<dynamic>)
        Book.fromJson(doc as Map<String, dynamic>),
    ];
  }

  Future<PickDetails> fetchDetails(String workId) async {
    final uri = Uri.https('openlibrary.org', '/works/$workId.json');
    final response = await _get(_client, uri, 'Open Library');
    if (response.statusCode != 200) {
      throw ApiException(
        'Open Library could not find this book (${response.statusCode}). '
        'Check its externalId in the CMS.',
      );
    }
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    // The description comes in two shapes.
    final description = switch (json['description']) {
      final String text => text,
      {'value': final String text} => text,
      _ => 'No description yet.',
    };
    // Open Library marks a removed cover with a negative number.
    final covers = (json['covers'] as List<dynamic>? ?? const [])
        .whereType<int>()
        .where((id) => id > 0);
    return PickDetails(
      title: json['title'] as String? ?? '',
      summary: description,
      imageUrl: covers.isEmpty ? null : _coverUrl(covers.first),
    );
  }
}

// ---------------------------------------------------------------------------
// Movies (OMDb)
// ---------------------------------------------------------------------------

class Movie {
  const Movie({
    required this.imdbId,
    required this.title,
    required this.year,
    this.posterUrl,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    final poster = json['Poster'] as String?;
    return Movie(
      imdbId: json['imdbID'] as String,
      title: json['Title'] as String,
      year: json['Year'] as String,
      // OMDb sends the text "N/A" when there is no poster.
      posterUrl: poster == 'N/A' ? null : poster,
    );
  }

  final String imdbId;
  final String title;
  final String year;
  final String? posterUrl;
}

class OmdbApi {
  OmdbApi({http.Client? client, this.apiKey = omdbKey})
    : _client = client ?? http.Client();

  final http.Client _client;
  final String apiKey;

  Future<List<Movie>> search(String query) async {
    final uri = Uri.https('www.omdbapi.com', '/', {
      'apikey': apiKey,
      's': query,
      'type': 'movie',
    });
    final json = await _getBody(uri);
    if (json['Response'] == 'False') {
      final error = json['Error'] as String? ?? 'OMDb error';
      if (error == 'Movie not found!') return const []; // empty, not an error
      throw ApiException(error); // e.g. "Invalid API key!"
    }
    return [
      for (final item in json['Search'] as List<dynamic>)
        Movie.fromJson(item as Map<String, dynamic>),
    ];
  }

  Future<PickDetails> fetchDetails(String imdbId) async {
    if (apiKey.isEmpty) {
      throw const ApiException('Movie details need an OMDb key.');
    }
    final uri = Uri.https('www.omdbapi.com', '/', {
      'apikey': apiKey,
      'i': imdbId,
      'plot': 'short',
    });
    final json = await _getBody(uri);
    if (json['Response'] == 'False') {
      throw ApiException(json['Error'] as String? ?? 'OMDb error');
    }
    final poster = json['Poster'] as String?;
    final plot = json['Plot'] as String?;
    return PickDetails(
      title: json['Title'] as String? ?? '',
      summary: plot == null || plot == 'N/A' ? 'No description yet.' : plot,
      imageUrl: poster == 'N/A' ? null : poster,
    );
  }

  // OMDb says "not found" with status 200, and a bad key also sends this
  // JSON, so the callers check the body, not only the status code.
  Future<Map<String, dynamic>> _getBody(Uri uri) async {
    final response = await _get(_client, uri, 'OMDb');
    try {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } on FormatException {
      throw ApiException('OMDb answered ${response.statusCode}.');
    }
  }
}

// ---------------------------------------------------------------------------
// Picks (Contentful)
// ---------------------------------------------------------------------------

/// A recommendation from the CMS. It only stores the ID and my note; the
/// cover, the year and the summary come from the APIs.
class Pick {
  const Pick({
    required this.id,
    required this.title,
    required this.kind,
    required this.externalId,
    required this.note,
  });

  final String id;
  final String title;

  /// 'book' or 'movie'.
  final String kind;
  final String externalId;
  final String note;
}

abstract interface class PickSource {
  Future<List<Pick>> fetchPicks();
}

class ContentfulPickSource implements PickSource {
  ContentfulPickSource({
    required this.spaceId,
    required this.token,
    http.Client? client,
    this.environment = 'master',
  }) : _client = client ?? http.Client();

  final String spaceId;

  /// The Content Delivery API token (read-only, published entries).
  final String token;
  final String environment;
  final http.Client _client;

  @override
  Future<List<Pick>> fetchPicks() async {
    final uri = Uri.https(
      'cdn.contentful.com',
      '/spaces/$spaceId/environments/$environment/entries',
      {'content_type': 'pick', 'limit': '100'},
    );
    final http.Response response;
    try {
      response = await _client
          .get(uri, headers: {'Authorization': 'Bearer $token'})
          .timeout(const Duration(seconds: 10));
    } on TimeoutException {
      throw const ApiException('Contentful took too long to answer. Try again.');
    } on http.ClientException {
      throw const ApiException(
        'No connection. Check your internet and try again.',
      );
    }
    switch (response.statusCode) {
      case 200:
        break;
      case 401 || 403:
        throw ApiException(
          'Contentful refused the request (${response.statusCode}). '
          'Check your token.',
        );
      case 404:
        throw const ApiException(
          'Contentful could not find the picks (404). '
          'Check the space ID and the content type name.',
        );
      case >= 500:
        throw ApiException(
          'Contentful is having problems (${response.statusCode}). '
          'Try again later.',
        );
      default:
        throw ApiException('Contentful answered ${response.statusCode}.');
    }
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    return (json['items'] as List<dynamic>).map<Pick>((item) {
      // Contentful leaves empty fields out of the JSON.
      final fields = item['fields'] as Map<String, dynamic>;
      return Pick(
        id: item['sys']['id'] as String,
        title: fields['title'] as String? ?? '',
        kind: fields['kind'] as String? ?? '',
        externalId: fields['externalId'] as String? ?? '',
        note: fields['note'] as String? ?? '',
      );
    }).toList();
  }
}

/// Loads the details from the right API for this pick.
Future<PickDetails> fetchPickDetails(Pick pick) => switch (pick.kind) {
  'book' => openLibraryApi.fetchDetails(pick.externalId),
  'movie' => omdbApi.fetchDetails(pick.externalId),
  _ => Future.error(
    ApiException('The kind of this pick must be book or movie, not "${pick.kind}".'),
  ),
};

// ---------------------------------------------------------------------------
// Shelf screen: three tabs of its own
// ---------------------------------------------------------------------------

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
              Tab(icon: Icon(Icons.star_outline), text: 'My Picks'),
              Tab(icon: Icon(Icons.menu_book), text: 'Books'),
              Tab(icon: Icon(Icons.movie_outlined), text: 'Movies'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            MyPicksTab(),
            BooksTab(),
            MoviesTab(),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// My Picks tab: loading, error, empty and the list, with pull to refresh
// ---------------------------------------------------------------------------

class MyPicksTab extends StatefulWidget {
  const MyPicksTab({super.key, this.source});

  /// Null means the real CMS. A test can pass its own source.
  final PickSource? source;

  @override
  State<MyPicksTab> createState() => _MyPicksTabState();
}

class _MyPicksTabState extends State<MyPicksTab>
    with AutomaticKeepAliveClientMixin {
  late Future<List<Pick>> _future;

  PickSource get _source => widget.source ?? pickSource;

  bool get _configured => widget.source != null || cmsSpace.isNotEmpty;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    // Here, not in build(): build() runs many times, and each run would
    // send another request.
    _future = _configured ? _source.fetchPicks() : Future.value(const []);
  }

  Future<void> _refresh() async {
    final future = _source.fetchPicks();
    setState(() {
      _future = future;
    });
    try {
      await future;
    } catch (_) {
      // The FutureBuilder shows the error.
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    if (!_configured) {
      return const _Message(
        icon: Icons.key_off,
        text:
            'My Picks needs your CMS values. Run the app with '
            '--dart-define-from-file=cms.json',
      );
    }
    return FutureBuilder<List<Pick>>(
      future: _future,
      builder: (context, snapshot) {
        // During a refresh, keep showing the old list.
        if (snapshot.connectionState != ConnectionState.done &&
            !snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return _Message(
            icon: Icons.cloud_off,
            text: '${snapshot.error}',
            action: FilledButton.icon(
              onPressed: _refresh,
              icon: const Icon(Icons.refresh),
              label: const Text('Try again'),
            ),
          );
        }
        final picks = snapshot.data ?? const <Pick>[];
        // On the web and desktop a mouse can't drag a list by default, so
        // allow it here to make pull to refresh work.
        return ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(
            dragDevices: {...PointerDeviceKind.values},
          ),
          child: RefreshIndicator(
            onRefresh: _refresh,
            child: ListView(
              // Lets you pull to refresh even when the list is short.
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                if (picks.isEmpty)
                  const Padding(
                    padding: EdgeInsets.only(top: 120),
                    child: _Message(
                      icon: Icons.star_outline,
                      text: 'No picks yet. Publish some in the CMS.',
                    ),
                  )
                else
                  for (final pick in picks) _PickTile(pick: pick),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _PickTile extends StatelessWidget {
  const _PickTile({required this.pick});

  final Pick pick;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        pick.kind == 'book' ? Icons.menu_book : Icons.movie_outlined,
        color: Theme.of(context).colorScheme.primary,
      ),
      title: Text(pick.title),
      subtitle: Text(pick.note),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute<void>(builder: (_) => PickDetailScreen(pick: pick)),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Pick details: my note from the CMS + the data from the API
// ---------------------------------------------------------------------------

class PickDetailScreen extends StatefulWidget {
  const PickDetailScreen({super.key, required this.pick});

  final Pick pick;

  @override
  State<PickDetailScreen> createState() => _PickDetailScreenState();
}

class _PickDetailScreenState extends State<PickDetailScreen> {
  late Future<PickDetails> _future;

  @override
  void initState() {
    super.initState();
    _future = fetchPickDetails(widget.pick);
  }

  void _retry() {
    setState(() {
      _future = fetchPickDetails(widget.pick);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.pick.title)),
      body: FutureBuilder<PickDetails>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return _Message(
              icon: Icons.cloud_off,
              text: '${snapshot.error}',
              action: FilledButton.icon(
                onPressed: _retry,
                icon: const Icon(Icons.refresh),
                label: const Text('Try again'),
              ),
            );
          }
          return _buildDetails(context, snapshot.data!);
        },
      ),
    );
  }

  Widget _buildDetails(BuildContext context, PickDetails details) {
    final textTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: SizedBox(
                  width: 180,
                  height: 270,
                  child: PosterImage(
                    url: details.imageUrl,
                    fallbackIcon: widget.pick.kind == 'book'
                        ? Icons.menu_book
                        : Icons.movie_outlined,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(details.title, style: textTheme.headlineSmall),
              const SizedBox(height: 16),
              Text('My note', style: textTheme.titleMedium),
              const SizedBox(height: 4),
              Text(widget.pick.note, style: textTheme.bodyMedium),
              const SizedBox(height: 16),
              Text('Summary', style: textTheme.titleMedium),
              const SizedBox(height: 4),
              Text(details.summary, style: textTheme.bodyMedium),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Books and Movies tabs
// ---------------------------------------------------------------------------

class BooksTab extends StatelessWidget {
  const BooksTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SearchTab<Book>(
      label: 'Search books',
      search: openLibraryApi.search,
      itemBuilder: (book) => ResultTile(
        imageUrl: book.coverUrl,
        fallbackIcon: Icons.menu_book,
        title: book.title,
        subtitle: [
          if (book.authors.isNotEmpty) book.authors.first,
          if (book.year != null) '${book.year}',
        ].join(' · '),
        id: book.workId,
      ),
    );
  }
}

class MoviesTab extends StatelessWidget {
  const MoviesTab({super.key});

  @override
  Widget build(BuildContext context) {
    if (omdbKey.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'Movie search needs an OMDb key. Run the app with '
            '--dart-define=OMDB_KEY=your-key '
            'or --dart-define-from-file=cms.json',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
    return SearchTab<Movie>(
      label: 'Search movies',
      search: omdbApi.search,
      itemBuilder: (movie) => ResultTile(
        imageUrl: movie.posterUrl,
        fallbackIcon: Icons.movie_outlined,
        title: movie.title,
        subtitle: movie.year,
        id: movie.imdbId,
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Search box + results, used by both the Books and the Movies tab
// ---------------------------------------------------------------------------

class SearchTab<T> extends StatefulWidget {
  const SearchTab({
    super.key,
    required this.label,
    required this.search,
    required this.itemBuilder,
  });

  final String label;
  final Future<List<T>> Function(String query) search;
  final Widget Function(T item) itemBuilder;

  @override
  State<SearchTab<T>> createState() => _SearchTabState<T>();
}

// The keep-alive mixin keeps the results when you switch to another inner tab.
class _SearchTabState<T> extends State<SearchTab<T>>
    with AutomaticKeepAliveClientMixin {
  Timer? _debounce;
  Future<List<T>>? _results;

  @override
  bool get wantKeepAlive => true;

  void _onChanged(String text) {
    _debounce?.cancel(); // the user typed again: forget the old timer
    _debounce = Timer(const Duration(milliseconds: 500), () {
      final query = text.trim();
      if (query.length < 3) return;
      // A block body: an arrow here would hand the Future back to setState,
      // and Flutter rejects that in debug mode.
      setState(() {
        _results = widget.search(query);
      });
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
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
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              labelText: widget.label,
              border: const OutlineInputBorder(),
            ),
            onChanged: _onChanged,
          ),
        ),
        Expanded(child: _buildResults()),
      ],
    );
  }

  Widget _buildResults() {
    final results = _results;
    if (results == null) {
      return const _Message(
        icon: Icons.search,
        text: 'Type at least 3 letters to search.',
      );
    }
    return FutureBuilder<List<T>>(
      future: results,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return _Message(icon: Icons.cloud_off, text: '${snapshot.error}');
        }
        final items = snapshot.data ?? const [];
        if (items.isEmpty) {
          return const _Message(icon: Icons.search_off, text: 'Nothing found');
        }
        return ListView.builder(
          itemCount: items.length,
          itemBuilder: (_, i) => widget.itemBuilder(items[i]),
        );
      },
    );
  }
}

class _Message extends StatelessWidget {
  const _Message({required this.icon, required this.text, this.action});

  final IconData icon;
  final String text;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 12),
            Text(text, textAlign: TextAlign.center),
            if (action != null) ...[const SizedBox(height: 12), action!],
          ],
        ),
      ),
    );
  }
}

/// One search result: the image, the text and a button that copies the ID.
class ResultTile extends StatelessWidget {
  const ResultTile({
    super.key,
    required this.imageUrl,
    required this.fallbackIcon,
    required this.title,
    required this.subtitle,
    required this.id,
  });

  final String? imageUrl;
  final IconData fallbackIcon;
  final String title;
  final String subtitle;
  final String id;

  Future<void> _copyId(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: id));
    if (!context.mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text('Copied $id')));
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: SizedBox(
        width: 40,
        height: 56,
        child: PosterImage(url: imageUrl, fallbackIcon: fallbackIcon),
      ),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: IconButton(
        tooltip: 'Copy ID',
        icon: const Icon(Icons.copy),
        onPressed: () => _copyId(context),
      ),
    );
  }
}

/// A cover or poster, or an icon when there is none or it fails to load.
class PosterImage extends StatelessWidget {
  const PosterImage({super.key, required this.url, required this.fallbackIcon});

  final String? url;
  final IconData fallbackIcon;

  @override
  Widget build(BuildContext context) {
    final imageUrl = url;
    if (imageUrl == null) return Icon(fallbackIcon);
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: Image.network(
        imageUrl,
        fit: BoxFit.cover,
        // On the web some image servers block direct downloads; this lets
        // the browser show them anyway.
        webHtmlElementStrategy: WebHtmlElementStrategy.fallback,
        errorBuilder: (_, _, _) => Icon(fallbackIcon),
      ),
    );
  }
}
