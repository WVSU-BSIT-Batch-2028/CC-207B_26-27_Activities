import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'models.dart';
import 'services/open_library_api.dart';
import 'services/omdb_api.dart';
import 'services/pick_source.dart';
import 'pick_detail_screen.dart';

class ShelfScreen extends StatelessWidget {
  final String omdbKey;
  final PickSource pickSource;

  const ShelfScreen({
    super.key,
    required this.omdbKey,
    required this.pickSource,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Shelf'),
          elevation: 2,
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.favorite), text: 'My Picks'),
              Tab(icon: Icon(Icons.menu_book), text: 'Books'),
              Tab(icon: Icon(Icons.movie), text: 'Movies'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            MyPicksTab(pickSource: pickSource, omdbKey: omdbKey),
            const BooksTab(),
            MoviesTab(omdbKey: omdbKey),
          ],
        ),
      ),
    );
  }
}

class MyPicksTab extends StatefulWidget {
  final PickSource pickSource;
  final String omdbKey;

  const MyPicksTab({super.key, required this.pickSource, required this.omdbKey});

  @override
  State<MyPicksTab> createState() => _MyPicksTabState();
}

class _MyPicksTabState extends State<MyPicksTab> {
  late Future<List<Pick>> _picksFuture;

  @override
  void initState() {
    super.initState();
    _reload();
  }

  void _reload() {
    setState(() {
      _picksFuture = widget.pickSource.fetchPicks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => _reload(),
      child: FutureBuilder<List<Pick>>(
        future: _picksFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Failed to load picks: ${snapshot.error}'),
                  const SizedBox(height: 8),
                  ElevatedButton(onPressed: _reload, child: const Text('Retry')),
                ],
              ),
            );
          }
          final picks = snapshot.data ?? [];
          if (picks.isEmpty) {
            return const Center(child: Text('No picks added yet.'));
          }

          return ListView.builder(
            itemCount: picks.length,
            itemBuilder: (context, index) {
              final pick = picks[index];
              return ListTile(
                leading: Icon(pick.kind == 'book' ? Icons.menu_book : Icons.movie),
                title: Text(pick.title),
                subtitle: Text(pick.note, maxLines: 2, overflow: TextOverflow.ellipsis),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PickDetailScreen(pick: pick, omdbKey: widget.omdbKey),
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

class BooksTab extends StatefulWidget {
  const BooksTab({super.key});

  @override
  State<BooksTab> createState() => _BooksTabState();
}

class _BooksTabState extends State<BooksTab> {
  final _api = OpenLibraryApi();
  Timer? _debounce;
  Future<List<Book>>? _results;

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
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            decoration: const InputDecoration(
              hintText: 'Search books, e.g. hobbit',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
            onChanged: _onChanged,
          ),
        ),
        Expanded(
          child: _results == null
              ? const Center(child: Text('Type at least 3 letters to search'))
              : FutureBuilder<List<Book>>(
                  future: _results,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    final books = snapshot.data ?? [];
                    if (books.isEmpty) return const Center(child: Text('Nothing found'));

                    return ListView.builder(
                      itemCount: books.length,
                      itemBuilder: (context, index) {
                        final book = books[index];
                        final author = book.authors.isNotEmpty ? book.authors.first : 'Unknown author';
                        final year = book.year != null ? ' · ${book.year}' : '';

                        return ListTile(
                          leading: book.coverId != null
                              ? Image.network(
                                  'https://covers.openlibrary.org/b/id/${book.coverId}-S.jpg',
                                  width: 40,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => const Icon(Icons.book),
                                )
                              : const Icon(Icons.book),
                          title: Text(book.title),
                          subtitle: Text('$author$year'),
                          trailing: IconButton(
                            icon: const Icon(Icons.copy),
                            onPressed: () {
                              Clipboard.setData(ClipboardData(text: book.workId));
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Copied ID: ${book.workId}')),
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
    );
  }
}

class MoviesTab extends StatefulWidget {
  final String omdbKey;
  const MoviesTab({super.key, required this.omdbKey});

  @override
  State<MoviesTab> createState() => _MoviesTabState();
}

class _MoviesTabState extends State<MoviesTab> {
  Timer? _debounce;
  Future<List<Movie>>? _results;

  void _onChanged(String text) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      final query = text.trim();
      if (query.length < 3) return;
      setState(() {
        _results = OmdbApi(apiKey: widget.omdbKey).search(query);
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
    if (widget.omdbKey.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'OMDb API key missing.\nPass it with --dart-define=OMDB_KEY=your_key',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            decoration: const InputDecoration(
              hintText: 'Search movies, e.g. interstellar',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
            onChanged: _onChanged,
          ),
        ),
        Expanded(
          child: _results == null
              ? const Center(child: Text('Type at least 3 letters to search'))
              : FutureBuilder<List<Movie>>(
                  future: _results,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    final movies = snapshot.data ?? [];
                    if (movies.isEmpty) return const Center(child: Text('Nothing found'));

                    return ListView.builder(
                      itemCount: movies.length,
                      itemBuilder: (context, index) {
                        final movie = movies[index];
                        return ListTile(
                          leading: movie.poster != null
                              ? Image.network(
                                  movie.poster!,
                                  width: 40,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => const Icon(Icons.movie),
                                )
                              : const Icon(Icons.movie),
                          title: Text(movie.title),
                          subtitle: Text(movie.year),
                          trailing: IconButton(
                            icon: const Icon(Icons.copy),
                            onPressed: () {
                              Clipboard.setData(ClipboardData(text: movie.imdbId));
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Copied ID: ${movie.imdbId}')),
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
    );
  }
}