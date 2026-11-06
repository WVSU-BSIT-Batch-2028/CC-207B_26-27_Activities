// lib/shelf_screen.dart  (CC 207B Unit 7 - My Profile App part 3)
//
// Run with:
// flutter run \
//   --dart-define=OMDB_KEY=your-omdb-key \
//   --dart-define=CMS_SPACE=your-space-id \
//   --dart-define=CMS_TOKEN=your-delivery-api-token

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

const omdbKey = String.fromEnvironment('OMDB_KEY');
const contentfulSpace = String.fromEnvironment('CMS_SPACE');
const contentfulToken = String.fromEnvironment('CMS_TOKEN');

// ---------------------------------------------------------------------------
// Shared
// ---------------------------------------------------------------------------

class ApiException implements Exception {
  final String message;
  ApiException(this.message);

  @override
  String toString() => message;
}

// ---------------------------------------------------------------------------
// Models
// ---------------------------------------------------------------------------

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

  factory Book.fromJson(Map<String, dynamic> json) => Book(
        workId: (json['key'] as String).split('/').last,
        title: json['title'] as String,
        // author_name is missing for some books, and it is a list.
        authors: [...?(json['author_name'] as List<dynamic>?)?.cast<String>()],
        year: json['first_publish_year'] as int?,
        coverId: json['cover_i'] as int?,
      );

  String? get coverUrl => coverId == null
      ? null
      : 'https://covers.openlibrary.org/b/id/$coverId-M.jpg';
}

class Movie {
  final String imdbId;
  final String title;
  final String year;
  final String? poster;

  const Movie({
    required this.imdbId,
    required this.title,
    required this.year,
    this.poster,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    final poster = json['Poster'] as String?;
    return Movie(
      imdbId: json['imdbID'] as String,
      title: json['Title'] as String,
      year: json['Year'] as String? ?? '',
      // OMDb uses "N/A" when there is no poster.
      poster: (poster == null || poster == 'N/A') ? null : poster,
    );
  }
}

class Pick {
  final String title;
  final String kind; // 'book' or 'movie'
  final String externalId;
  final String note;

  const Pick({
    required this.title,
    required this.kind,
    required this.externalId,
    required this.note,
  });

  bool get isBook => kind == 'book';
}

/// What the detail screen needs, whichever API it came from.
class PickDetails {
  final String? imageUrl;
  final String title;
  final String subtitle;
  final String summary;

  const PickDetails({
    required this.imageUrl,
    required this.title,
    required this.subtitle,
    required this.summary,
  });
}

// ---------------------------------------------------------------------------
// APIs
// ---------------------------------------------------------------------------

class OpenLibraryApi {
  Future<List<Book>> search(String query) async {
    final uri = Uri.https('openlibrary.org', '/search.json', {
      'q': query,
      'fields': 'key,title,author_name,first_publish_year,cover_i',
      'limit': '20',
    });
    final response = await http.get(uri);
    if (response.statusCode != 200) {
      throw ApiException('Open Library error (${response.statusCode})');
    }
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final docs = json['docs'] as List<dynamic>? ?? const [];
    return docs
        .map((doc) => Book.fromJson(doc as Map<String, dynamic>))
        .toList();
  }

  Future<PickDetails> details(String workId) async {
    final uri = Uri.https('openlibrary.org', '/works/$workId.json');
    final response = await http.get(uri);
    if (response.statusCode != 200) {
      throw ApiException('Open Library error (${response.statusCode})');
    }
    final json = jsonDecode(response.body) as Map<String, dynamic>;

    // The description comes in two shapes.
    final description = switch (json['description']) {
      final String text => text,
      {'value': final String text} => text,
      _ => 'No description yet.',
    };

    final covers = json['covers'] as List<dynamic>?;
    final coverId = (covers != null && covers.isNotEmpty) ? covers.first : null;

    final firstPublish = json['first_publish_date'] as String?;
    return PickDetails(
      imageUrl: coverId is int
          ? 'https://covers.openlibrary.org/b/id/$coverId-L.jpg'
          : null,
      title: json['title'] as String? ?? 'Untitled',
      subtitle: firstPublish == null ? 'Book' : 'Book • $firstPublish',
      summary: description,
    );
  }
}

class OmdbApi {
  Future<List<Movie>> search(String query) async {
    final uri = Uri.https('www.omdbapi.com', '/', {
      'apikey': omdbKey,
      's': query,
      'type': 'movie',
    });
    final response = await http.get(uri);
    if (response.statusCode != 200) {
      throw ApiException('OMDb error (${response.statusCode})');
    }
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    if (json['Response'] == 'False') {
      final error = json['Error'] as String? ?? 'OMDb error';
      if (error == 'Movie not found!') return const []; // empty, not an error
      throw ApiException(error); // e.g. "Invalid API key!"
    }
    final results = json['Search'] as List<dynamic>? ?? const [];
    return results
        .map((m) => Movie.fromJson(m as Map<String, dynamic>))
        .toList();
  }

  Future<PickDetails> details(String imdbId) async {
    final uri = Uri.https('www.omdbapi.com', '/', {
      'apikey': omdbKey,
      'i': imdbId,
      'plot': 'short',
    });
    final response = await http.get(uri);
    if (response.statusCode != 200) {
      throw ApiException('OMDb error (${response.statusCode})');
    }
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    if (json['Response'] == 'False') {
      throw ApiException(json['Error'] as String? ?? 'OMDb error');
    }
    final poster = json['Poster'] as String?;
    final year = json['Year'] as String?;
    return PickDetails(
      imageUrl: (poster == null || poster == 'N/A') ? null : poster,
      title: json['Title'] as String? ?? 'Untitled',
      subtitle: year == null ? 'Movie' : 'Movie • $year',
      summary: json['Plot'] as String? ?? 'No description yet.',
    );
  }
}

// ---------------------------------------------------------------------------
// CMS (Contentful)
// ---------------------------------------------------------------------------

abstract interface class PickSource {
  Future<List<Pick>> fetchPicks();
}

class ContentfulPickSource implements PickSource {
  @override
  Future<List<Pick>> fetchPicks() async {
    if (contentfulSpace.isEmpty || contentfulToken.isEmpty) {
      throw ApiException(
        'Missing CMS settings. Run with '
        '--dart-define=CMS_SPACE=... '
        '--dart-define=CMS_TOKEN=...',
      );
    }
    // Content type ID is "pick" (the content type named Pick).
    final uri = Uri.https(
      'cdn.contentful.com',
      '/spaces/$contentfulSpace/environments/master/entries',
      {'access_token': contentfulToken, 'content_type': 'pick'},
    );
    final response = await http.get(uri);
    if (response.statusCode != 200) {
      String details = response.body.trim();
      try {
        final error = jsonDecode(response.body) as Map<String, dynamic>;
        final message = error['message'] as String?;
        if (message != null && message.isNotEmpty) details = message;
      } on FormatException {
        // Keep the raw response when Contentful does not return JSON.
      }
      throw ApiException(
        'Contentful error (${response.statusCode})'
        '${details.isEmpty ? '' : ': $details'}',
      );
    }
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final items = json['items'] as List<dynamic>? ?? const [];
    return items.map((item) {
      final fields =
          (item as Map<String, dynamic>)['fields'] as Map<String, dynamic>;
      return Pick(
        title: fields['title'] as String? ?? 'Untitled',
        kind: (fields['kind'] as String? ?? 'book').toLowerCase(),
        externalId: fields['externalId'] as String? ?? '',
        note: fields['note'] as String? ?? '',
      );
    }).toList();
  }
}

// ---------------------------------------------------------------------------
// Part A: Shelf tab
// ---------------------------------------------------------------------------

class ShelfScreen extends StatelessWidget {
  const ShelfScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'SHELF',
            style: TextStyle(letterSpacing: 1.4, fontWeight: FontWeight.w800),
          ),
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
// Parts B and C: searching (debounce + FutureBuilder), shared by both tabs
// ---------------------------------------------------------------------------

class _ResultTile extends StatelessWidget {
  final String? imageUrl;
  final IconData fallbackIcon;
  final String title;
  final String subtitle;
  final String id;

  const _ResultTile({
    required this.imageUrl,
    required this.fallbackIcon,
    required this.title,
    required this.subtitle,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: SizedBox(
        width: 44,
        height: 60,
        child: imageUrl == null
            ? Icon(fallbackIcon, size: 32)
            : ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.network(
                  imageUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Icon(fallbackIcon, size: 32),
                ),
              ),
      ),
      title: Text(title, maxLines: 2, overflow: TextOverflow.ellipsis),
      subtitle: subtitle.isEmpty ? null : Text(subtitle),
      trailing: IconButton(
        tooltip: 'Copy ID',
        icon: const Icon(Icons.copy),
        onPressed: () async {
          await Clipboard.setData(ClipboardData(text: id));
          if (!context.mounted) return;
          ScaffoldMessenger.of(context)
            ..clearSnackBars()
            ..showSnackBar(SnackBar(content: Text('Copied $id')));
        },
      ),
    );
  }
}

/// A search box with a 500 ms debounce, a 3-letter minimum and a FutureBuilder.
class _SearchTab<T> extends StatefulWidget {
  final Future<List<T>> Function(String query) search;
  final Widget Function(T item) itemBuilder;
  final String hint;

  const _SearchTab({
    required this.search,
    required this.itemBuilder,
    required this.hint,
  });

  @override
  State<_SearchTab<T>> createState() => _SearchTabState<T>();
}

class _SearchTabState<T> extends State<_SearchTab<T>> {
  Timer? _debounce;
  Future<List<T>>? _results;

  void _search(String text) {
    final query = text.trim();
    if (query.length < 3 || !mounted) return;
    final future = widget.search(query);
    // Block body on purpose: a callback that returns a Future makes
    // setState throw before it rebuilds, so the UI would never update.
    setState(() {
      _results = future;
    });
  }

  void _onChanged(String text) {
    _debounce?.cancel(); // the user typed again: forget the old timer
    _debounce = Timer(const Duration(milliseconds: 500), () => _search(text));
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            onChanged: _onChanged,
            onSubmitted: (text) {
              _debounce?.cancel();
              _search(text);
            },
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              hintText: widget.hint,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ),
        Expanded(
          child: _results == null
              ? const Center(child: Text('Type at least 3 letters to search.'))
              : FutureBuilder<List<T>>(
                  future: _results,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Text(
                            'Something went wrong: ${snapshot.error}',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    }
                    final items = snapshot.data ?? <T>[];
                    if (items.isEmpty) {
                      return const Center(child: Text('Nothing found'));
                    }
                    return ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (_, i) => widget.itemBuilder(items[i]),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class BooksTab extends StatefulWidget {
  const BooksTab({super.key});

  @override
  State<BooksTab> createState() => _BooksTabState();
}

class _BooksTabState extends State<BooksTab>
    with AutomaticKeepAliveClientMixin {
  final _api = OpenLibraryApi();

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return _SearchTab<Book>(
      hint: 'Search books (Open Library)',
      search: _api.search,
      itemBuilder: (book) => _ResultTile(
        imageUrl: book.coverUrl,
        fallbackIcon: Icons.menu_book,
        title: book.title,
        subtitle: [
          if (book.authors.isNotEmpty) book.authors.first,
          if (book.year != null) '${book.year}',
        ].join(' • '),
        id: book.workId,
      ),
    );
  }
}

class MoviesTab extends StatefulWidget {
  const MoviesTab({super.key});

  @override
  State<MoviesTab> createState() => _MoviesTabState();
}

class _MoviesTabState extends State<MoviesTab>
    with AutomaticKeepAliveClientMixin {
  final _api = OmdbApi();

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (omdbKey.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: SelectableText(
            'No OMDb key found.\n\nRun the app with:\n'
            'flutter run --dart-define=OMDB_KEY=your-key',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
    return _SearchTab<Movie>(
      hint: 'Search movies (OMDb)',
      search: _api.search,
      itemBuilder: (movie) => _ResultTile(
        imageUrl: movie.poster,
        fallbackIcon: Icons.movie,
        title: movie.title,
        subtitle: movie.year,
        id: movie.imdbId,
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Part D: My Picks (CMS) + detail screen (API)
// ---------------------------------------------------------------------------

class MyPicksTab extends StatefulWidget {
  const MyPicksTab({super.key});

  @override
  State<MyPicksTab> createState() => _MyPicksTabState();
}

class _MyPicksTabState extends State<MyPicksTab>
    with AutomaticKeepAliveClientMixin {
  final PickSource _source = ContentfulPickSource();
  late Future<List<Pick>> _future;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _future = _source.fetchPicks(); // the request starts here, not in build()
  }

  Future<void> _refresh() async {
    final next = _source.fetchPicks();
    setState(() {
      _future = next;
    });
    try {
      await next;
    } catch (_) {
      // the FutureBuilder shows the error state
    }
  }

  Widget _scrollable(Widget child) => ListView(
        // ListView keeps pull-to-refresh working in the error/empty states.
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(
            height: 320,
            child: Center(
              child: Padding(padding: const EdgeInsets.all(24), child: child),
            ),
          ),
        ],
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
            return _scrollable(const CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return _scrollable(
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Could not load picks: ${snapshot.error}',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: _refresh,
                    child: const Text('Try again'),
                  ),
                ],
              ),
            );
          }
          final picks = snapshot.data ?? const <Pick>[];
          if (picks.isEmpty) {
            return _scrollable(const Text('No picks yet.'));
          }
          return ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: picks.length,
            itemBuilder: (context, i) {
              final pick = picks[i];
              return ListTile(
                leading: Icon(pick.isBook ? Icons.menu_book : Icons.movie),
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

class PickDetailScreen extends StatefulWidget {
  final Pick pick;

  const PickDetailScreen({super.key, required this.pick});

  @override
  State<PickDetailScreen> createState() => _PickDetailScreenState();
}

class _PickDetailScreenState extends State<PickDetailScreen> {
  late final Future<PickDetails> _future;

  @override
  void initState() {
    super.initState();
    final pick = widget.pick;
    _future = pick.isBook
        ? OpenLibraryApi().details(pick.externalId)
        : OmdbApi().details(pick.externalId);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final pick = widget.pick;
    return Scaffold(
      appBar: AppBar(title: Text(pick.isBook ? 'BOOK' : 'MOVIE')),
      body: FutureBuilder<PickDetails>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
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
          final d = snapshot.data!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 640),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: SizedBox(
                        height: 280,
                        child: d.imageUrl == null
                            ? Icon(
                                pick.isBook ? Icons.menu_book : Icons.movie,
                                size: 96,
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Image.network(
                                  d.imageUrl!,
                                  fit: BoxFit.contain,
                                  errorBuilder: (_, __, ___) =>
                                      const Icon(Icons.broken_image, size: 96),
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      d.title,
                      style: theme.textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 4),
                    Text(d.subtitle, style: theme.textTheme.bodyMedium),
                    const SizedBox(height: 18),
                    Text(
                      'My note',
                      style: theme.textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 6),
                    Text(pick.note),
                    const SizedBox(height: 18),
                    Text(
                      'Summary',
                      style: theme.textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 6),
                    Text(d.summary),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}