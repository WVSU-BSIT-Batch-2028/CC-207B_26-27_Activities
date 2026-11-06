import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../config.dart';
import '../services/shelf_api.dart';
import 'pick_detail_screen.dart';

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

// 1. MY PICKS TAB
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
    setState(() {
      _picksFuture = ContentfulPickSource.fetchPicks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => _loadPicks(),
      child: FutureBuilder<List<Pick>>(
        future: _picksFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final picks = snapshot.data ?? [];
          if (picks.isEmpty) {
            return const Center(child: Text('No picks added yet.'));
          }
          return ListView.separated(
            itemCount: picks.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final pick = picks[index];
              return ListTile(
                leading: Icon(
                  pick.kind == 'book' ? Icons.menu_book : Icons.movie,
                  color: Colors.pink,
                ),
                title: Text(pick.title),
                subtitle: Text(
                  pick.note,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
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
              );
            },
          );
        },
      ),
    );
  }
}

// 2. BOOKS TAB (DEBOUNCED SEARCH)
class BooksTab extends StatefulWidget {
  const BooksTab({super.key});

  @override
  State<BooksTab> createState() => _BooksTabState();
}

class _BooksTabState extends State<BooksTab> {
  Timer? _debounce;
  Future<List<Book>>? _results;

  void _onChanged(String text) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      final query = text.trim();
      if (query.length < 3) return;
      setState(() {
        _results = OpenLibraryApi.search(query);
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
            onChanged: _onChanged,
            decoration: const InputDecoration(
              hintText: 'Search books, e.g. hobbit',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
          ),
        ),
        Expanded(
          child: _results == null
              ? const Center(child: Text('Type 3+ letters to search.'))
              : FutureBuilder<List<Book>>(
                  future: _results,
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
                        final authorStr = book.authors.isNotEmpty
                            ? book.authors.first
                            : 'Unknown Author';
                        return ListTile(
                          leading: book.coverUrl != null
                              ? Image.network(book.coverUrl!, width: 40, fit: BoxFit.cover)
                              : const Icon(Icons.book),
                          title: Text(book.title),
                          subtitle: Text('$authorStr ${book.year ?? ''}'),
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

// 3. MOVIES TAB (OMDB SEARCH)
class MoviesTab extends StatefulWidget {
  const MoviesTab({super.key});

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
        _results = OmdbApi.search(query);
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
    if (AppConfig.omdbKey.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'OMDb key missing!\nRun with --dart-define=OMDB_KEY=yourkey',
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
            onChanged: _onChanged,
            decoration: const InputDecoration(
              hintText: 'Search movies, e.g. Interstellar',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
          ),
        ),
        Expanded(
          child: _results == null
              ? const Center(child: Text('Type 3+ letters to search.'))
              : FutureBuilder<List<Movie>>(
                  future: _results,
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
                        return ListTile(
                          leading: movie.poster != null
                              ? Image.network(movie.poster!, width: 40, fit: BoxFit.cover)
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