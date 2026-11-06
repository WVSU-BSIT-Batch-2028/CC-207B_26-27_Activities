import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

// BrandTitle and PageBody come from your main.dart
import 'main.dart';

// ---------------------------------------------------------------------------
// CONFIG  (values come from --dart-define when you run the app)
// ---------------------------------------------------------------------------
const omdbKey = String.fromEnvironment('OMDB_KEY');
const contentfulSpace = String.fromEnvironment('CONTENTFUL_SPACE');
const contentfulToken = String.fromEnvironment('CONTENTFUL_TOKEN');

class ApiException implements Exception {
  final String message;

  const ApiException(this.message);

  @override
  String toString() => message;
}

// Shape used by the detail screen, for both books and movies
class ItemDetails {
  final String title;
  final String? year;
  final String? imageUrl;
  final String summary;

  const ItemDetails({
    required this.title,
    required this.year,
    required this.imageUrl,
    required this.summary,
  });
}

// ---------------------------------------------------------------------------
// PART B: BOOKS (Open Library)
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
    required this.year,
    required this.coverId,
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
    final docs = json['docs'] as List<dynamic>;
    return [
      for (final doc in docs) Book.fromJson(doc as Map<String, dynamic>),
    ];
  }

  Future<ItemDetails> details(String workId) async {
    final uri = Uri.https('openlibrary.org', '/works/$workId.json');
    final response = await http.get(uri);
    if (response.statusCode != 200) {
      throw ApiException('Open Library error (${response.statusCode})');
    }
    final json = jsonDecode(response.body) as Map<String, dynamic>;

    // The description comes in two shapes; a switch handles both
    final description = switch (json['description']) {
      final String text => text, // "description": "..."
      {'value': final String text} => text, // {"type": ..., "value": "..."}
      _ => 'No description yet.',
    };

    final covers = (json['covers'] as List<dynamic>?)
            ?.whereType<int>()
            .where((id) => id > 0)
            .toList() ??
        <int>[];
    final date = json['first_publish_date'] as String?;
    final year = date == null ? null : RegExp(r'\d{4}').firstMatch(date)?.group(0);

    return ItemDetails(
      title: json['title'] as String? ?? 'Untitled',
      year: year,
      imageUrl: covers.isEmpty
          ? null
          : 'https://covers.openlibrary.org/b/id/${covers.first}-L.jpg',
      summary: description,
    );
  }
}

// ---------------------------------------------------------------------------
// PART C: MOVIES (OMDb)
// ---------------------------------------------------------------------------
class Movie {
  final String imdbId;
  final String title;
  final String year;
  final String? poster;

  const Movie({
    required this.imdbId,
    required this.title,
    required this.year,
    required this.poster,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    final poster = json['Poster'] as String?;
    return Movie(
      imdbId: json['imdbID'] as String,
      title: json['Title'] as String,
      year: json['Year'] as String? ?? '',
      // "N/A" means there is no poster
      poster: (poster == null || poster == 'N/A') ? null : poster,
    );
  }
}

class OmdbApi {
  Future<Map<String, dynamic>> _request(Map<String, String> query) async {
    if (omdbKey.isEmpty) {
      throw const ApiException(
        'No OMDb key. Run the app with --dart-define=OMDB_KEY=your-key',
      );
    }
    final uri = Uri.https('www.omdbapi.com', '/', {
      'apikey': omdbKey,
      ...query,
    });
    final response = await http.get(uri);
    if (response.statusCode != 200) {
      throw ApiException('OMDb error (${response.statusCode})');
    }
    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  Future<List<Movie>> search(String query) async {
    final json = await _request({'s': query, 'type': 'movie'});
    // OMDb says "not found" with status 200, so check the body too
    if (json['Response'] == 'False') {
      final error = json['Error'] as String? ?? 'OMDb error';
      if (error == 'Movie not found!') return const []; // empty, not an error
      throw ApiException(error); // e.g. "Invalid API key!"
    }
    final results = json['Search'] as List<dynamic>;
    return [
      for (final item in results) Movie.fromJson(item as Map<String, dynamic>),
    ];
  }

  Future<ItemDetails> details(String imdbId) async {
    final json = await _request({'i': imdbId, 'plot': 'short'});
    if (json['Response'] == 'False') {
      throw ApiException(json['Error'] as String? ?? 'OMDb error');
    }
    final poster = json['Poster'] as String?;
    final plot = json['Plot'] as String?;
    return ItemDetails(
      title: json['Title'] as String? ?? 'Untitled',
      year: json['Year'] as String?,
      imageUrl: (poster == null || poster == 'N/A') ? null : poster,
      summary: (plot == null || plot == 'N/A') ? 'No description yet.' : plot,
    );
  }
}

// ---------------------------------------------------------------------------
// PART D: PICKS (Contentful)
// ---------------------------------------------------------------------------
class Pick {
  final String id;
  final String title;
  final String kind; // 'book' or 'movie'
  final String externalId;
  final String note;

  const Pick({
    required this.id,
    required this.title,
    required this.kind,
    required this.externalId,
    required this.note,
  });

  bool get isBook => kind == 'book';

  // Contentful shape: {"sys": {"id": ...}, "fields": {"title": ..., ...}}
  factory Pick.fromJson(Map<String, dynamic> json) {
    final fields = json['fields'] as Map<String, dynamic>;
    return Pick(
      id: (json['sys'] as Map<String, dynamic>)['id'] as String,
      title: fields['title'] as String? ?? 'Untitled',
      kind: fields['kind'] as String? ?? 'book',
      externalId: fields['externalId'] as String? ?? '',
      note: fields['note'] as String? ?? '',
    );
  }
}

abstract interface class PickSource {
  Future<List<Pick>> fetchPicks();
}

class ContentfulPickSource implements PickSource {
  @override
  Future<List<Pick>> fetchPicks() async {
    if (contentfulSpace.isEmpty || contentfulToken.isEmpty) {
      throw const ApiException(
        'Missing CMS settings. Run the app with --dart-define=CONTENTFUL_SPACE=... '
        'and --dart-define=CONTENTFUL_TOKEN=...',
      );
    }
    final uri = Uri.https(
      'cdn.contentful.com',
      '/spaces/$contentfulSpace/environments/master/entries',
      {'content_type': 'pick'},
    );
    final response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $contentfulToken'},
    );
    if (response.statusCode != 200) {
      throw ApiException('CMS error (${response.statusCode})');
    }
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final items = json['items'] as List<dynamic>;
    return [
      for (final item in items) Pick.fromJson(item as Map<String, dynamic>),
    ];
  }
}

// ---------------------------------------------------------------------------
// SHARED SMALL WIDGETS
// ---------------------------------------------------------------------------

// Cover or poster, or an icon when there is no image
class _Cover extends StatelessWidget {
  final String? url;
  final IconData fallback;
  final double width;
  final double height;

  const _Cover({
    required this.url,
    required this.fallback,
    this.width = 48,
    this.height = 68,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    Widget icon() => ColoredBox(
          color: scheme.surfaceContainerHighest,
          child: Icon(fallback, color: scheme.onSurface),
        );

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        width: width,
        height: height,
        child: url == null
            ? icon()
            : Image.network(
                url!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stack) => icon(),
              ),
      ),
    );
  }
}

// Centered message used for idle, error and empty states
class _Message extends StatelessWidget {
  final IconData icon;
  final String text;

  const _Message({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48),
            const SizedBox(height: 12),
            Text(
              text,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

// Copies an ID and tells the user (Part B.e)
Future<void> _copyId(BuildContext context, String id) async {
  await Clipboard.setData(ClipboardData(text: id));
  if (!context.mounted) return;
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Copied ID: $id')),
  );
}

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
      leading: _Cover(url: imageUrl, fallback: fallbackIcon),
      title: Text(title, maxLines: 2, overflow: TextOverflow.ellipsis),
      subtitle: Text(subtitle, maxLines: 1, overflow: TextOverflow.ellipsis),
      trailing: IconButton(
        icon: const Icon(Icons.copy),
        tooltip: 'Copy ID',
        onPressed: () => _copyId(context, id),
      ),
    );
  }
}

class _SearchBox extends StatelessWidget {
  final String hint;
  final ValueChanged<String> onChanged;

  const _SearchBox({required this.hint, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: TextField(
        onChanged: onChanged,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search),
          hintText: hint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
      ),
    );
  }
}

// FutureBuilder with the four states: loading, error, nothing found, list
class _ResultsView<T> extends StatelessWidget {
  final Future<List<T>>? future;
  final String idleText;
  final Widget Function(BuildContext context, T item) itemBuilder;

  const _ResultsView({
    required this.future,
    required this.idleText,
    required this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    if (future == null) {
      return _Message(icon: Icons.search, text: idleText);
    }
    return FutureBuilder<List<T>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return _Message(
            icon: Icons.error_outline,
            text: 'Something went wrong:\n${snapshot.error}',
          );
        }
        final items = snapshot.data ?? <T>[];
        if (items.isEmpty) {
          return const _Message(icon: Icons.search_off, text: 'Nothing found');
        }
        return ListView.separated(
          itemCount: items.length,
          separatorBuilder: (context, index) => const Divider(height: 1),
          itemBuilder: (context, index) => itemBuilder(context, items[index]),
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// PART A: SHELF SCREEN (three tabs)
// ---------------------------------------------------------------------------
class ShelfScreen extends StatelessWidget {
  const ShelfScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const BrandTitle('My Shelf'),
          bottom: TabBar(
            labelColor: scheme.onPrimary,
            unselectedLabelColor: scheme.onPrimary.withValues(alpha: 0.6),
            indicatorColor: scheme.onPrimary,
            dividerHeight: 0,
            tabs: const [
              Tab(icon: Icon(Icons.favorite), text: 'My Picks'),
              Tab(icon: Icon(Icons.menu_book), text: 'Books'),
              Tab(icon: Icon(Icons.movie), text: 'Movies'),
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
// BOOKS TAB (debounced search)
// ---------------------------------------------------------------------------
class BooksTab extends StatefulWidget {
  const BooksTab({super.key});

  @override
  State<BooksTab> createState() => _BooksTabState();
}

class _BooksTabState extends State<BooksTab>
    with AutomaticKeepAliveClientMixin {
  final OpenLibraryApi _api = OpenLibraryApi();
  Timer? _debounce;
  Future<List<Book>>? _results;

  @override
  bool get wantKeepAlive => true;

  void _onChanged(String text) {
    _debounce?.cancel(); // the user typed again: forget the old timer
    _debounce = Timer(const Duration(milliseconds: 500), () {
      final query = text.trim();
      if (query.length < 3) return;
      // block body on purpose: setState must not return a Future
      setState(() {
        _results = _api.search(query);
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
        _SearchBox(hint: 'Search books, e.g. hobbit', onChanged: _onChanged),
        Expanded(
          child: _ResultsView<Book>(
            future: _results,
            idleText: 'Type at least 3 letters to search books',
            itemBuilder: (context, book) => _ResultTile(
              imageUrl: book.coverUrl,
              fallbackIcon: Icons.menu_book,
              title: book.title,
              subtitle: [
                book.authors.isEmpty ? 'Unknown author' : book.authors.first,
                if (book.year != null) '${book.year}',
              ].join(' · '),
              id: book.workId,
            ),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// MOVIES TAB (debounced search, needs the OMDb key)
// ---------------------------------------------------------------------------
class MoviesTab extends StatefulWidget {
  const MoviesTab({super.key});

  @override
  State<MoviesTab> createState() => _MoviesTabState();
}

class _MoviesTabState extends State<MoviesTab>
    with AutomaticKeepAliveClientMixin {
  final OmdbApi _api = OmdbApi();
  Timer? _debounce;
  Future<List<Movie>>? _results;

  @override
  bool get wantKeepAlive => true;

  void _onChanged(String text) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      final query = text.trim();
      if (query.length < 3) return;
      setState(() {
        _results = _api.search(query);
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

    // C.a: no key -> show how to pass it instead of searching
    if (omdbKey.isEmpty) {
      return const _Message(
        icon: Icons.key_off,
        text: 'No OMDb key yet.\n\nRun the app with:\n'
            'flutter run --dart-define=OMDB_KEY=your-key',
      );
    }

    return Column(
      children: [
        _SearchBox(
          hint: 'Search movies, e.g. interstellar',
          onChanged: _onChanged,
        ),
        Expanded(
          child: _ResultsView<Movie>(
            future: _results,
            idleText: 'Type at least 3 letters to search movies',
            itemBuilder: (context, movie) => _ResultTile(
              imageUrl: movie.poster,
              fallbackIcon: Icons.movie,
              title: movie.title,
              subtitle: movie.year,
              id: movie.imdbId,
            ),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// MY PICKS TAB (from the CMS, pull to refresh)
// ---------------------------------------------------------------------------
class MyPicksTab extends StatefulWidget {
  const MyPicksTab({super.key});

  @override
  State<MyPicksTab> createState() => _MyPicksTabState();
}

class _MyPicksTabState extends State<MyPicksTab>
    with AutomaticKeepAliveClientMixin {
  final PickSource _source = ContentfulPickSource();
  late Future<List<Pick>> _picks;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    // The request starts here, not in build()
    _picks = _source.fetchPicks();
  }

  Future<void> _refresh() async {
    final next = _source.fetchPicks();
    setState(() {
      _picks = next;
    });
    try {
      await next;
    } catch (_) {
      // the FutureBuilder shows the error
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final textTheme = Theme.of(context).textTheme;

    // Every state is a scrollable list so pull to refresh always works
    Widget scrollable(Widget child) => ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            SizedBox(
              height: 360,
              child: child,
            ),
          ],
        );

    return RefreshIndicator(
      onRefresh: _refresh,
      child: FutureBuilder<List<Pick>>(
        future: _picks,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return scrollable(
              const Center(child: CircularProgressIndicator()),
            );
          }
          if (snapshot.hasError) {
            return scrollable(
              _Message(
                icon: Icons.error_outline,
                text: 'Could not load picks:\n${snapshot.error}\n\nPull down to try again.',
              ),
            );
          }
          final picks = snapshot.data ?? <Pick>[];
          if (picks.isEmpty) {
            return scrollable(
              const _Message(
                icon: Icons.inbox,
                text: 'No picks yet. Publish some in your CMS.',
              ),
            );
          }
          return ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            itemCount: picks.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final pick = picks[index];
              return Card(
                clipBehavior: Clip.antiAlias,
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  leading: Icon(pick.isBook ? Icons.menu_book : Icons.movie),
                  title: Text(pick.title, style: textTheme.titleMedium),
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
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// PICK DETAIL (cover, year and summary come from the API)
// ---------------------------------------------------------------------------
class PickDetailScreen extends StatefulWidget {
  final Pick pick;

  const PickDetailScreen({super.key, required this.pick});

  @override
  State<PickDetailScreen> createState() => _PickDetailScreenState();
}

class _PickDetailScreenState extends State<PickDetailScreen> {
  late final Future<ItemDetails> _details;

  @override
  void initState() {
    super.initState();
    final pick = widget.pick;
    _details = pick.isBook
        ? OpenLibraryApi().details(pick.externalId)
        : OmdbApi().details(pick.externalId);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final pick = widget.pick;

    return Scaffold(
      appBar: AppBar(title: BrandTitle(pick.title)),
      body: FutureBuilder<ItemDetails>(
        future: _details,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return _Message(
              icon: Icons.error_outline,
              text: 'Could not load details:\n${snapshot.error}',
            );
          }
          final details = snapshot.data!;
          return PageBody(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: _Cover(
                    url: details.imageUrl,
                    fallback: pick.isBook ? Icons.menu_book : Icons.movie,
                    width: 200,
                    height: 280,
                  ),
                ),
                const SizedBox(height: 20),
                Text(details.title, style: textTheme.headlineSmall),
                const SizedBox(height: 4),
                Text(
                  [
                    pick.isBook ? 'Book' : 'Movie',
                    if (details.year != null) details.year!,
                    pick.externalId,
                  ].join(' · '),
                  style: textTheme.bodySmall,
                ),
                const SizedBox(height: 16),
                // My note from the CMS
                Card(
                  color: scheme.primary,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Why I recommend it',
                          style: textTheme.titleMedium
                              ?.copyWith(color: scheme.onPrimary),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          pick.note,
                          style: textTheme.bodyMedium
                              ?.copyWith(color: scheme.onPrimary),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Summary from the API
                Text('Summary', style: textTheme.titleMedium),
                const SizedBox(height: 8),
                Text(details.summary, style: textTheme.bodyMedium),
              ],
            ),
          );
        },
      ),
    );
  }
}