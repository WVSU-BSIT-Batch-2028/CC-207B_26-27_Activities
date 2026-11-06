import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';
import 'dart:async';

// --- Environment Constants & Global Instances ---
const omdbKey = String.fromEnvironment('OMDB_KEY');
const cmsSpace = String.fromEnvironment('CMS_SPACE');
const cmsToken = String.fromEnvironment('CMS_TOKEN');

final openLibraryApi = OpenLibraryApi();
final omdbApi = OmdbApi();
final PickSource pickSource = ContentfulPickSource(
  spaceId: cmsSpace,
  token: cmsToken,
);

// --- Models ---
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
    authors: [...?(json['author_name'] as List<dynamic>?)?.cast<String>()],
    year: json['first_publish_year'] as int?,
    coverId: json['cover_i'] as int?,
  );
}

class Movie {
  final String imdbID;
  final String title;
  final String year;
  final String poster;

  const Movie({
    required this.imdbID,
    required this.title,
    required this.year,
    required this.poster,
  });

  factory Movie.fromJson(Map<String, dynamic> json) => Movie(
    imdbID: json['imdbID'] as String,
    title: json['Title'] as String,
    year: json['Year'] as String,
    poster: json['Poster'] as String? ?? 'N/A',
  );
}

class Pick {
  final String id;
  final String title;
  final String kind; // 'book' or 'movie'
  final String externalId;
  final String note;
  final int? coverId;

  const Pick({
    required this.id,
    required this.title,
    required this.kind,
    required this.externalId,
    required this.note,
    this.coverId,
  });

  factory Pick.fromContentful(Map<String, dynamic> json) {
    final fields = json['fields'] as Map<String, dynamic>? ?? json;
    final sys = json['sys'] as Map<String, dynamic>? ?? {};
    return Pick(
      id: sys['id'] as String? ?? json['id']?.toString() ?? '',
      title: fields['title'] as String? ?? 'Untitled',
      kind: fields['kind'] as String? ?? 'book',
      externalId: fields['externalId'] as String? ?? '',
      note: fields['note'] as String? ?? '',
    );
  }
}

// --- API Handlers ---
class ApiException implements Exception {
  final String message;
  ApiException(this.message);
  @override
  String toString() => message;
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
      throw ApiException(
        'Failed to load books (status ${response.statusCode})',
      );
    }
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final docs = data['docs'] as List<dynamic>? ?? [];
    return docs
        .map((doc) => Book.fromJson(doc as Map<String, dynamic>))
        .toList();
  }

  Future<Map<String, dynamic>> fetchDetails(String workId) async {
    final uri = Uri.https('openlibrary.org', '/works/$workId.json');
    final response = await http.get(uri);
    if (response.statusCode != 200) {
      throw ApiException('Failed to load book details');
    }
    return jsonDecode(response.body) as Map<String, dynamic>;
  }
}

class OmdbApi {
  Map<String, dynamic> _decodeResponse(http.Response response, String action) {
    final Object? decoded;
    try {
      decoded = jsonDecode(response.body);
    } on FormatException {
      throw ApiException(
        'OMDb $action failed (HTTP ${response.statusCode}): invalid response',
      );
    }
    if (decoded is! Map<String, dynamic>) {
      throw ApiException('OMDb returned an unexpected response');
    }
    if (response.statusCode != 200) {
      final error = decoded['Error'] as String?;
      throw ApiException(
        'OMDb $action failed (HTTP ${response.statusCode})'
        '${error == null ? '' : ': $error'}',
      );
    }
    return decoded;
  }

  Future<List<Movie>> search(String query) async {
    if (omdbKey.isEmpty) {
      throw ApiException('OMDb API Key Missing');
    }
    final uri = Uri.https('www.omdbapi.com', '/', {
      'apikey': omdbKey,
      's': query,
      'type': 'movie',
    });
    final response = await http.get(uri);
    final json = _decodeResponse(response, 'movie search');
    if (json['Response'] == 'False') {
      final error = json['Error'] as String? ?? 'OMDb error';
      if (error == 'Movie not found!') return const [];
      throw ApiException(error);
    }
    final searchList = json['Search'] as List<dynamic>? ?? [];
    return searchList
        .map((m) => Movie.fromJson(m as Map<String, dynamic>))
        .toList();
  }

  Future<Map<String, dynamic>> fetchDetails(String imdbId) async {
    if (omdbKey.isEmpty) {
      throw ApiException('OMDb API Key Missing');
    }
    final uri = Uri.https('www.omdbapi.com', '/', {
      'apikey': omdbKey,
      'i': imdbId,
      'plot': 'short',
    });
    final response = await http.get(uri);
    final json = _decodeResponse(response, 'movie details');
    if (json['Response'] == 'False') {
      throw ApiException(json['Error'] as String? ?? 'OMDb error');
    }
    return json;
  }
}

abstract class PickSource {
  Future<List<Pick>> fetchPicks();
}

class ContentfulPickSource implements PickSource {
  final String spaceId;
  final String token;

  ContentfulPickSource({required this.spaceId, required this.token});

  @override
  Future<List<Pick>> fetchPicks() async {
    final uri = Uri.https(
      'cdn.contentful.com',
      '/spaces/$spaceId/environments/master/entries',
      {'access_token': token, 'content_type': 'pick', 'limit': '100'},
    );
    final response = await http.get(uri);
    final decoded = jsonDecode(response.body);
    if (response.statusCode != 200) {
      final message = decoded is Map<String, dynamic>
          ? decoded['message'] as String?
          : null;
      throw ApiException(
        'Failed to load picks from Contentful '
        '(status ${response.statusCode})'
        '${message == null ? '' : ': $message'}',
      );
    }
    if (decoded is! Map<String, dynamic> || decoded['items'] is! List) {
      throw ApiException('Contentful returned an unexpected response format');
    }
    final list = decoded['items'] as List<dynamic>;
    return list
        .map((item) => Pick.fromContentful(item as Map<String, dynamic>))
        .toList();
  }
}

// --- Shelf Screen & Tabs ---
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
            indicatorColor: Color(0xFF80CBC4),
            indicatorWeight: 4,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            unselectedLabelStyle: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
            tabs: [
              Tab(icon: Icon(Icons.star_rounded, size: 25), text: 'My Picks'),
              Tab(icon: Icon(Icons.menu_book_rounded, size: 25), text: 'Books'),
              Tab(
                icon: Icon(Icons.local_movies_rounded, size: 25),
                text: 'Movies',
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [MyPicksTab(), BooksTab(), MoviesTab()],
        ),
      ),
    );
  }
}

class BooksTab extends StatefulWidget {
  const BooksTab({super.key});

  @override
  State<BooksTab> createState() => _BooksTabState();
}

class _BooksTabState extends State<BooksTab> {
  Timer? _debounce;
  Future<List<Book>>? _resultsFuture;
  final TextEditingController _controller = TextEditingController();

  void _onChanged(String text) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      final query = text.trim();
      if (query.length < 3) {
        setState(() {
          _resultsFuture = null;
        });
        return;
      }
      setState(() {
        _resultsFuture = openLibraryApi.search(query);
      });
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _copyId(BuildContext context, String workId) {
    Clipboard.setData(ClipboardData(text: workId));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Copied ID: $workId to clipboard')));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _controller,
            onChanged: _onChanged,
            decoration: InputDecoration(
              labelText: 'Search books, e.g. hobbit',
              prefixIcon: const Icon(Icons.search_rounded),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _resultsFuture == null
                ? const Center(
                    child: Text('Type at least 3 characters to search books.'),
                  )
                : FutureBuilder<List<Book>>(
                    future: _resultsFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }
                      final books = snapshot.data ?? [];
                      if (books.isEmpty) {
                        return const Center(child: Text('Nothing found.'));
                      }
                      return ListView.builder(
                        itemCount: books.length,
                        itemBuilder: (context, index) {
                          final book = books[index];
                          final coverUrl = book.coverId != null
                              ? 'https://covers.openlibrary.org/b/id/${book.coverId}-M.jpg'
                              : null;
                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            child: ListTile(
                              leading: coverUrl != null
                                  ? Image.network(
                                      coverUrl,
                                      width: 45,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) =>
                                          const Icon(Icons.book),
                                    )
                                  : const Icon(Icons.book_rounded, size: 40),
                              title: Text(
                                book.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                '${book.authors.isNotEmpty ? book.authors.first : 'Unknown Author'} • ${book.year ?? 'N/A'}',
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.copy_rounded),
                                tooltip: 'Copy ID',
                                onPressed: () => _copyId(context, book.workId),
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => PickDetailScreen(
                                      pick: Pick(
                                        id: book.workId,
                                        title: book.title,
                                        kind: 'book',
                                        externalId: book.workId,
                                        note: '',
                                        coverId: book.coverId,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class MoviesTab extends StatefulWidget {
  const MoviesTab({super.key});

  @override
  State<MoviesTab> createState() => _MoviesTabState();
}

class _MoviesTabState extends State<MoviesTab> {
  Timer? _debounce;
  Future<List<Movie>>? _resultsFuture;
  final TextEditingController _controller = TextEditingController();

  void _onChanged(String text) {
    if (omdbKey.isEmpty) return;
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      final query = text.trim();
      if (query.length < 3) {
        setState(() {
          _resultsFuture = null;
        });
        return;
      }
      setState(() {
        _resultsFuture = omdbApi.search(query);
      });
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _copyId(BuildContext context, String imdbId) {
    Clipboard.setData(ClipboardData(text: imdbId));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Copied ID: $imdbId to clipboard')));
  }

  @override
  Widget build(BuildContext context) {
    if (omdbKey.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.vpn_key_off_rounded, size: 64, color: Colors.orange),
              SizedBox(height: 16),
              Text(
                'OMDb API Key Missing',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Please run the app with your OMDb key:\nflutter run --dart-define=OMDB_KEY=your-key',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _controller,
            onChanged: _onChanged,
            decoration: InputDecoration(
              labelText: 'Search movies, e.g. interstellar',
              prefixIcon: const Icon(Icons.search_rounded),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _resultsFuture == null
                ? const Center(
                    child: Text('Type at least 3 characters to search movies.'),
                  )
                : FutureBuilder<List<Movie>>(
                    future: _resultsFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }
                      final movies = snapshot.data ?? [];
                      if (movies.isEmpty) {
                        return const Center(child: Text('Nothing found.'));
                      }
                      return ListView.builder(
                        itemCount: movies.length,
                        itemBuilder: (context, index) {
                          final movie = movies[index];
                          final hasPoster = movie.poster != 'N/A';
                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            child: ListTile(
                              leading: hasPoster
                                  ? Image.network(
                                      movie.poster,
                                      width: 45,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) =>
                                          const Icon(Icons.movie),
                                    )
                                  : const Icon(Icons.movie_rounded, size: 40),
                              title: Text(
                                movie.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text('Year: ${movie.year}'),
                              trailing: IconButton(
                                icon: const Icon(Icons.copy_rounded),
                                tooltip: 'Copy ID',
                                onPressed: () => _copyId(context, movie.imdbID),
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => PickDetailScreen(
                                      pick: Pick(
                                        id: movie.imdbID,
                                        title: movie.title,
                                        kind: 'movie',
                                        externalId: movie.imdbID,
                                        note: '',
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class MyPicksTab extends StatefulWidget {
  const MyPicksTab({super.key});

  @override
  State<MyPicksTab> createState() => _MyPicksTabState();
}

class _MyPicksTabState extends State<MyPicksTab> {
  late Future<List<Pick>> _picksFuture;

  @override
  void initState() {
    super.initState();
    _loadPicks();
  }

  void _loadPicks() {
    _picksFuture = pickSource.fetchPicks();
  }

  Future<void> _refresh() async {
    setState(() {
      _loadPicks();
    });
    await _picksFuture;
  }

  @override
  Widget build(BuildContext context) {
    if (cmsSpace.isEmpty || cmsToken.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Text(
            'Contentful CMS Space ID or Token is missing.\nProvide them via --dart-define.',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _refresh,
      child: FutureBuilder<List<Pick>>(
        future: _picksFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return ListView(
              children: [
                const SizedBox(height: 100),
                Center(child: Text('Failed to load picks: ${snapshot.error}')),
              ],
            );
          }
          final picks = snapshot.data ?? [];
          if (picks.isEmpty) {
            return ListView(
              children: [
                const SizedBox(height: 100),
                const Center(child: Text('No picks published yet.')),
              ],
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: picks.length,
            itemBuilder: (context, index) {
              final pick = picks[index];
              final isBook = pick.kind == 'book';
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: Icon(
                    isBook ? Icons.book_rounded : Icons.movie_rounded,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  title: Text(
                    pick.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    pick.note,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PickDetailScreen(pick: pick),
                      ),
                    );
                  },
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
  late final Future<Map<String, dynamic>> _detailsFuture;

  @override
  void initState() {
    super.initState();
    if (widget.pick.kind == 'book') {
      _detailsFuture = openLibraryApi.fetchDetails(widget.pick.externalId);
    } else {
      _detailsFuture = omdbApi.fetchDetails(widget.pick.externalId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isBook = widget.pick.kind == 'book';

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
              child: Text('Error loading details: ${snapshot.error}'),
            );
          }
          final data = snapshot.data ?? {};

          String? imageUrl;
          String summary = 'No description yet.';

          if (isBook) {
            final covers = data['covers'] as List<dynamic>?;
            int? coverId = widget.pick.coverId;
            if (coverId == null && covers != null) {
              for (final cover in covers) {
                if (cover is int) {
                  coverId = cover;
                  break;
                }
              }
            }
            if (coverId != null) {
              imageUrl =
                  'https://covers.openlibrary.org/b/id/$coverId-L.jpg?default=false';
            } else {
              final bookId = widget.pick.externalId.split('/').last;
              final idType = RegExp(r'^OL\d+[WM]$').hasMatch(bookId)
                  ? 'olid'
                  : 'isbn';
              imageUrl =
                  'https://covers.openlibrary.org/b/$idType/$bookId-L.jpg?default=false';
            }
            final descRaw = data['description'];
            summary = switch (descRaw) {
              final String text => text,
              {'value': final String text} => text,
              _ => 'No description yet.',
            };
          } else {
            final poster = data['Poster'] as String? ?? 'N/A';
            if (poster != 'N/A') imageUrl = poster;
            summary = data['Plot'] as String? ?? 'No description yet.';
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (imageUrl != null)
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        imageUrl,
                        height: 220,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            const Icon(Icons.broken_image, size: 80),
                      ),
                    ),
                  ),
                const SizedBox(height: 16),
                Text(
                  widget.pick.title,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${isBook ? 'Book' : 'Movie'} • External ID: ${widget.pick.externalId}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.secondary,
                  ),
                ),
                const SizedBox(height: 20),
                if (widget.pick.note.isNotEmpty)
                  Card(
                    elevation: 0,
                    color: theme.colorScheme.surfaceContainerHighest
                        .withOpacity(0.4),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.format_quote_rounded,
                                color: theme.colorScheme.primary,
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Why I recommend it',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            widget.pick.note,
                            style: theme.textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 20),
                Text(
                  'Summary',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  summary,
                  style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
