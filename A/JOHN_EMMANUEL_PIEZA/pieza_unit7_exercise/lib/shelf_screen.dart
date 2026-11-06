
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

const String _omdbKey = String.fromEnvironment('OMDB_KEY');
const String _contentfulSpace = String.fromEnvironment('CMS_SPACE');
const String _contentfulToken = String.fromEnvironment('CMS_TOKEN');
const String _contentfulEnvironment =
    String.fromEnvironment('CMS_ENVIRONMENT', defaultValue: 'master');

class ShelfPick {
  final String title;
  final String kind;
  final String externalId;
  final String note;

  const ShelfPick({
    required this.title,
    required this.kind,
    required this.externalId,
    required this.note,
  });

  factory ShelfPick.fromContentful(Map<String, dynamic> json) {
    final fields = (json['fields'] as Map<String, dynamic>?) ?? {};

    String read(String key) {
      final value = fields[key];
      if (value is Map<String, dynamic>) {
        return (value['en-US'] ?? value.values.firstOrNull ?? '').toString();
      }
      return value?.toString() ?? '';
    }

    return ShelfPick(
      title: read('title'),
      kind: read('kind').toLowerCase(),
      externalId: read('externalId'),
      note: read('note'),
    );
  }
}

class ShelfApiException implements Exception {
  final String message;
  const ShelfApiException(this.message);

  @override
  String toString() => message;
}

class OpenLibraryBook {
  final String workId;
  final String title;
  final List<String> authors;
  final int? year;
  final int? coverId;

  const OpenLibraryBook({
    required this.workId,
    required this.title,
    required this.authors,
    required this.year,
    required this.coverId,
  });

  factory OpenLibraryBook.fromJson(Map<String, dynamic> json) {
    return OpenLibraryBook(
      workId: (json['key'] as String).split('/').last,
      title: json['title'] as String? ?? 'Untitled',
      authors: [...?(json['author_name'] as List<dynamic>?)?.cast<String>()],
      year: json['first_publish_year'] as int?,
      coverId: json['cover_i'] as int?,
    );
  }

  String get coverUrl =>
      'https://covers.openlibrary.org/b/id/$coverId-M.jpg';
}

class OpenLibraryApi {
  Future<List<OpenLibraryBook>> search(String query) async {
    final uri = Uri.https('openlibrary.org', '/search.json', {
      'q': query,
      'fields': 'key,title,author_name,first_publish_year,cover_i',
      'limit': '20',
    });

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw ShelfApiException(
        'Open Library error (${response.statusCode}): ${response.body}',
      );
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final docs = (json['docs'] as List<dynamic>? ?? []);

    return docs
        .whereType<Map<String, dynamic>>()
        .map(OpenLibraryBook.fromJson)
        .toList();
  }

  Future<Map<String, dynamic>> details(String workId) async {
    final uri = Uri.https('openlibrary.org', '/works/$workId.json');
    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw ShelfApiException(
        'Could not load book details (${response.statusCode}): ${response.body}',
      );
    }

    return jsonDecode(response.body) as Map<String, dynamic>;
  }
}

class OmdbMovie {
  final String id;
  final String title;
  final String year;
  final String poster;

  const OmdbMovie({
    required this.id,
    required this.title,
    required this.year,
    required this.poster,
  });

  factory OmdbMovie.fromJson(Map<String, dynamic> json) => OmdbMovie(
        id: json['imdbID'] as String? ?? '',
        title: json['Title'] as String? ?? 'Untitled',
        year: json['Year'] as String? ?? 'Year unavailable',
        poster: json['Poster'] as String? ?? 'N/A',
      );
}

class OmdbApi {
  Future<List<OmdbMovie>> search(String query) async {
    if (_omdbKey.isEmpty) {
      throw const ShelfApiException(
        'OMDb API key is missing. Run with --dart-define=OMDB_KEY=your-key.',
      );
    }

    final uri = Uri.https('www.omdbapi.com', '/', {
      'apikey': _omdbKey,
      's': query,
      'type': 'movie',
    });

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw ShelfApiException('OMDb error (${response.statusCode}).');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;

    if (json['Response'] == 'False') {
      final error = json['Error'] as String? ?? 'OMDb error';
      if (error == 'Movie not found!') return [];
      throw ShelfApiException(error);
    }

    return (json['Search'] as List<dynamic>? ?? [])
        .whereType<Map<String, dynamic>>()
        .map(OmdbMovie.fromJson)
        .toList();
  }

  Future<Map<String, dynamic>> details(String id) async {
    if (_omdbKey.isEmpty) {
      throw const ShelfApiException('OMDb API key is not configured.');
    }

    final uri = Uri.https('www.omdbapi.com', '/', {
      'apikey': _omdbKey,
      'i': id,
      'plot': 'short',
    });

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw ShelfApiException('Could not load movie details.');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;

    if (json['Response'] == 'False') {
      throw ShelfApiException(json['Error'] as String? ?? 'OMDb error');
    }

    return json;
  }
}

// PickSource interface required by the Unit 7 assignment.
abstract class PickSource {
  Future<List<ShelfPick>> fetchPicks();
}

// Contentful implementation of PickSource.
class ContentfulPickSource implements PickSource {
  @override
  Future<List<ShelfPick>> fetchPicks() async {
    if (_contentfulSpace.isEmpty || _contentfulToken.isEmpty) {
      throw const ShelfApiException(
        'Contentful is not configured. Add CMS_SPACE and CMS_TOKEN when running the app.',
      );
    }

    final uri = Uri.https(
      'cdn.contentful.com',
      '/spaces/$_contentfulSpace/environments/$_contentfulEnvironment/entries',
      {
        'content_type': 'pick',
        'access_token': _contentfulToken,
        'limit': '100',
      },
    );

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw ShelfApiException(
        'Contentful error (${response.statusCode}). Check your Space ID, Delivery API token, and content type ID "pick".',
      );
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;

    return (json['items'] as List<dynamic>? ?? [])
        .whereType<Map<String, dynamic>>()
        .map(ShelfPick.fromContentful)
        .where((pick) => pick.title.isNotEmpty && pick.externalId.isNotEmpty)
        .toList();
  }
}

class ShelfScreen extends StatelessWidget {
  const ShelfScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Shelf'),
          centerTitle: true,
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white,
            indicatorColor: Colors.white,
            tabs: [
              Tab(
                icon: Icon(Icons.bookmark, color: Colors.white),
                text: 'My Picks',
              ),
              Tab(
                icon: Icon(Icons.menu_book, color: Colors.white),
                text: 'Books',
              ),
              Tab(
                icon: Icon(Icons.movie, color: Colors.white),
                text: 'Movies',
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            MyPicksTab(),
            BookSearchTab(),
            MovieSearchTab(),
          ],
        ),
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
  final ContentfulPickSource _source = ContentfulPickSource();
  late Future<List<ShelfPick>> _picksFuture;

  @override
  void initState() {
    super.initState();
    _picksFuture = _source.fetchPicks();
  }

  Future<void> _refresh() async {
    final future = _source.fetchPicks();

    setState(() {
      _picksFuture = future;
    });

    try {
      await future;
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ShelfPick>>(
      future: _picksFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return _MessageState(
            icon: Icons.cloud_off,
            message: snapshot.error.toString(),
            action: 'Try again',
            onPressed: _refresh,
          );
        }

        final picks = snapshot.data ?? [];

        if (picks.isEmpty) {
          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView(
              children: const [
                SizedBox(height: 150),
                Icon(Icons.bookmark_border, size: 56),
                SizedBox(height: 12),
                Center(child: Text('No picks found.')),
                Center(child: Text('Publish your picks in Contentful.')),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: _refresh,
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: picks.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final pick = picks[index];
              final isBook = pick.kind == 'book';

              return Card.outlined(
                child: ListTile(
                  leading: CircleAvatar(
                    child: Icon(isBook ? Icons.menu_book : Icons.movie),
                  ),
                  title: Text(pick.title),
                  subtitle: Text(
                    pick.note.isEmpty ? 'No note added.' : pick.note,
                  ),
                  trailing: const Icon(Icons.chevron_right),
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
          ),
        );
      },
    );
  }
}

class BookSearchTab extends StatefulWidget {
  const BookSearchTab({super.key});

  @override
  State<BookSearchTab> createState() => _BookSearchTabState();
}

class _BookSearchTabState extends State<BookSearchTab> {
  final OpenLibraryApi _api = OpenLibraryApi();
  final TextEditingController _controller = TextEditingController();
  Timer? _debounce;
  Future<List<OpenLibraryBook>>? _results;
  String _query = '';

  void _onChanged(String text) {
    _debounce?.cancel();
    final query = text.trim();

    setState(() {
      _query = query;
      _results = null;
    });

    if (query.length < 3) return;

    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (!mounted) return;

      final future = _api.search(query);

      setState(() {
        _results = future;
      });
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
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: TextField(
            controller: _controller,
            onChanged: _onChanged,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              hintText: 'Search books (at least 3 letters)',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _controller.clear();
                  _onChanged('');
                },
              ),
            ),
          ),
        ),
        Expanded(
          child: _query.length < 3
              ? const Center(child: Text('Type at least 3 letters to search.'))
              : _results == null
                  ? const Center(child: Text('Searching soon...'))
                  : FutureBuilder<List<OpenLibraryBook>>(
                      future: _results,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (snapshot.hasError) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Text(
                                snapshot.error.toString(),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          );
                        }

                        final books = snapshot.data ?? [];

                        if (books.isEmpty) {
                          return const Center(child: Text('Nothing found.'));
                        }

                        return ListView.separated(
                          padding: const EdgeInsets.all(12),
                          itemCount: books.length,
                          separatorBuilder: (_, __) => const Divider(),
                          itemBuilder: (context, index) {
                            final book = books[index];

                            return _SearchResultTile(
                              title: book.title,
                              subtitle: [
                                if (book.authors.isNotEmpty)
                                  book.authors.first,
                                if (book.year != null) '${book.year}',
                              ].join(' • '),
                              imageUrl:
                                  book.coverId == null ? null : book.coverUrl,
                              fallbackIcon: Icons.menu_book,
                              id: book.workId,
                              onOpen: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      _BookDetailScreen(book: book),
                                ),
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

class MovieSearchTab extends StatefulWidget {
  const MovieSearchTab({super.key});

  @override
  State<MovieSearchTab> createState() => _MovieSearchTabState();
}

class _MovieSearchTabState extends State<MovieSearchTab> {
  final OmdbApi _api = OmdbApi();
  final TextEditingController _controller = TextEditingController();
  Timer? _debounce;
  Future<List<OmdbMovie>>? _results;
  String _query = '';

  void _onChanged(String text) {
    _debounce?.cancel();
    final query = text.trim();

    setState(() {
      _query = query;
      _results = null;
    });

    if (query.length < 3) return;

    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (!mounted) return;

      final future = _api.search(query);

      setState(() {
        _results = future;
      });
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
    if (_omdbKey.isEmpty) {
      return const _MessageState(
        icon: Icons.key,
        message:
            'Add your OMDb key when running the app:\n--dart-define=OMDB_KEY=your-key',
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: TextField(
            controller: _controller,
            onChanged: _onChanged,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              hintText: 'Search movies (at least 3 letters)',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _controller.clear();
                  _onChanged('');
                },
              ),
            ),
          ),
        ),
        Expanded(
          child: _query.length < 3
              ? const Center(child: Text('Type at least 3 letters to search.'))
              : _results == null
                  ? const Center(child: Text('Searching soon...'))
                  : FutureBuilder<List<OmdbMovie>>(
                      future: _results,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (snapshot.hasError) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Text(
                                snapshot.error.toString(),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          );
                        }

                        final movies = snapshot.data ?? [];

                        if (movies.isEmpty) {
                          return const Center(child: Text('Nothing found.'));
                        }

                        return ListView.separated(
                          padding: const EdgeInsets.all(12),
                          itemCount: movies.length,
                          separatorBuilder: (_, __) => const Divider(),
                          itemBuilder: (context, index) {
                            final movie = movies[index];

                            return _SearchResultTile(
                              title: movie.title,
                              subtitle: movie.year,
                              imageUrl:
                                  movie.poster == 'N/A' ? null : movie.poster,
                              fallbackIcon: Icons.movie,
                              id: movie.id,
                              onOpen: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      _MovieDetailScreen(movie: movie),
                                ),
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

class _SearchResultTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? imageUrl;
  final IconData fallbackIcon;
  final String id;
  final VoidCallback onOpen;

  const _SearchResultTile({
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.fallbackIcon,
    required this.id,
    required this.onOpen,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      leading: SizedBox(
        width: 52,
        height: 68,
        child: imageUrl == null
            ? Icon(fallbackIcon, size: 36)
            : Image.network(
                imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    Icon(fallbackIcon, size: 36),
              ),
      ),
      title: Text(title, maxLines: 2, overflow: TextOverflow.ellipsis),
      subtitle: Text(subtitle.isEmpty ? 'Information unavailable' : subtitle),
      trailing: IconButton(
        tooltip: 'Copy ID',
        icon: const Icon(Icons.copy),
        onPressed: () async {
          await Clipboard.setData(ClipboardData(text: id));

          if (!context.mounted) return;

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Copied ID: $id')),
          );
        },
      ),
      onTap: onOpen,
    );
  }
}

class PickDetailScreen extends StatelessWidget {
  final ShelfPick pick;

  const PickDetailScreen({super.key, required this.pick});

  @override
  Widget build(BuildContext context) {
    final isBook = pick.kind == 'book';

    return Scaffold(
      appBar: AppBar(title: Text(pick.title)),
      body: isBook
          ? _PickBookDetail(pick: pick)
          : _PickMovieDetail(pick: pick),
    );
  }
}

class _PickBookDetail extends StatelessWidget {
  final ShelfPick pick;

  const _PickBookDetail({required this.pick});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: OpenLibraryApi().details(pick.externalId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text(snapshot.error.toString()));
        }

        final data = snapshot.data!;

        final description = switch (data['description']) {
          final String text => text,
          {'value': final String text} => text,
          _ => 'No description yet.',
        };

        final covers = data['covers'] as List<dynamic>?;

        final coverUrl = covers != null && covers.isNotEmpty
            ? 'https://covers.openlibrary.org/b/id/${covers.first}-L.jpg'
            : null;

        return _DetailContent(
          title: (data['title'] as String?) ?? pick.title,
          note: pick.note,
          summary: description,
          imageUrl: coverUrl,
          icon: Icons.menu_book,
          year: 'Open Library book',
        );
      },
    );
  }
}

class _PickMovieDetail extends StatelessWidget {
  final ShelfPick pick;

  const _PickMovieDetail({required this.pick});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: OmdbApi().details(pick.externalId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text(snapshot.error.toString()));
        }

        final data = snapshot.data!;

        return _DetailContent(
          title: data['Title'] as String? ?? pick.title,
          note: pick.note,
          summary: data['Plot'] as String? ?? 'No summary available.',
          imageUrl:
              (data['Poster'] == 'N/A') ? null : data['Poster'] as String?,
          icon: Icons.movie,
          year: data['Year'] as String? ?? 'Year unavailable',
        );
      },
    );
  }
}

class _BookDetailScreen extends StatelessWidget {
  final OpenLibraryBook book;

  const _BookDetailScreen({required this.book});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: OpenLibraryApi().details(book.workId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(title: Text(book.title)),
            body: Center(child: Text(snapshot.error.toString())),
          );
        }

        final data = snapshot.data!;

        final description = switch (data['description']) {
          final String text => text,
          {'value': final String text} => text,
          _ => 'No description yet.',
        };

        final covers = data['covers'] as List<dynamic>?;

        final coverUrl = covers != null && covers.isNotEmpty
            ? 'https://covers.openlibrary.org/b/id/${covers.first}-L.jpg'
            : (book.coverId == null ? null : book.coverUrl);

        return Scaffold(
          appBar: AppBar(title: Text(book.title)),
          body: _DetailContent(
            title: book.title,
            note: book.authors.join(', '),
            summary: description,
            imageUrl: coverUrl,
            icon: Icons.menu_book,
            year: book.year?.toString() ?? 'Year unavailable',
          ),
        );
      },
    );
  }
}

class _MovieDetailScreen extends StatelessWidget {
  final OmdbMovie movie;

  const _MovieDetailScreen({required this.movie});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: OmdbApi().details(movie.id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(title: Text(movie.title)),
            body: Center(child: Text(snapshot.error.toString())),
          );
        }

        final data = snapshot.data!;

        return Scaffold(
          appBar: AppBar(title: Text(movie.title)),
          body: _DetailContent(
            title: data['Title'] as String? ?? movie.title,
            note: data['Genre'] as String? ?? '',
            summary: data['Plot'] as String? ?? 'No summary available.',
            imageUrl:
                data['Poster'] == 'N/A' ? null : data['Poster'] as String?,
            icon: Icons.movie,
            year: data['Year'] as String? ?? movie.year,
          ),
        );
      },
    );
  }
}

class _DetailContent extends StatelessWidget {
  final String title;
  final String note;
  final String summary;
  final String? imageUrl;
  final IconData icon;
  final String year;

  const _DetailContent({
    required this.title,
    required this.note,
    required this.summary,
    required this.imageUrl,
    required this.icon,
    required this.year,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: SizedBox(
              height: 250,
              child: imageUrl == null
                  ? Icon(icon, size: 100)
                  : Image.network(
                      imageUrl!,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => Icon(icon, size: 100),
                    ),
            ),
          ),
          const SizedBox(height: 20),
          Text(title, style: theme.textTheme.headlineSmall),
          const SizedBox(height: 4),
          Text(year, style: theme.textTheme.bodyMedium),
          if (note.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text('My note', style: theme.textTheme.titleMedium),
            Text(note),
          ],
          const SizedBox(height: 16),
          Text('Summary', style: theme.textTheme.titleMedium),
          const SizedBox(height: 6),
          Text(summary),
        ],
      ),
    );
  }
}

class _MessageState extends StatelessWidget {
  final IconData icon;
  final String message;
  final String? action;
  final VoidCallback? onPressed;

  const _MessageState({
    required this.icon,
    required this.message,
    this.action,
    this.onPressed,
  });

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
            Text(message, textAlign: TextAlign.center),
            if (action != null && onPressed != null) ...[
              const SizedBox(height: 16),
              FilledButton(
                onPressed: onPressed,
                child: Text(action!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
