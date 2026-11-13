import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../config.dart';
import '../data/pick_source.dart';
import '../models/book.dart';
import '../models/pick.dart';
import '../services/open_library_api.dart';
import '../services/omdb_api.dart';
import 'pick_detail_screen.dart';

// ─── ShelfScreen ──────────────────────────────────────────────────────────────

class ShelfScreen extends StatelessWidget {
  const ShelfScreen({super.key, required this.pickSource});

  final PickSource pickSource;

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
              Tab(icon: Icon(Icons.book_outlined), text: 'Books'),
              Tab(icon: Icon(Icons.movie_outlined), text: 'Movies'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _MyPicksTab(pickSource: pickSource),
            // Do NOT use const here — prevents Flutter from skipping rebuilds.
            _BooksTab(),   // ignore: prefer_const_constructors
            _MoviesTab(),  // ignore: prefer_const_constructors
          ],
        ),
      ),
    );
  }
}

// ─── Books tab ────────────────────────────────────────────────────────────────

class _BooksTab extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  _BooksTab();

  @override
  State<_BooksTab> createState() => _BooksTabState();
}

class _BooksTabState extends State<_BooksTab>
    with AutomaticKeepAliveClientMixin {
  final OpenLibraryApi _api = OpenLibraryApi();
  final TextEditingController _controller = TextEditingController();
  Timer? _debounce;

  // null = user hasn't typed yet → show "Type to search"
  Future<List<Book>>? _results;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (!mounted) return;

      final query = _controller.text.trim();
      if (query.length < 3) {
        if (_results != null) {
          setState(() {
            _results = null;
          });
        }
        return;
      }

      final future = _api.search(query);
      setState(() {
        _results = future;
      });
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.removeListener(_onTextChanged);
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
            autofocus: false,
            decoration: const InputDecoration(
              hintText: 'Search books, e.g. hobbit',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
          ),
        ),
        Expanded(
          child: _results == null
              ? const Center(child: Text('Type to search books'))
              : FutureBuilder<List<Book>>(
                  future: _results,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    final books = snapshot.data ?? const <Book>[];
                    if (books.isEmpty) {
                      return const Center(child: Text('Nothing found'));
                    }
                    return ListView.builder(
                      itemCount: books.length,
                      itemBuilder: (context, index) {
                        final book = books[index];
                        final author = book.authors.isNotEmpty
                            ? book.authors.first
                            : 'Unknown author';
                        final yearText =
                            book.year != null ? ' · ${book.year}' : '';
                        return ListTile(
                          leading: book.coverId != null
                              ? Image.network(
                                  'https://covers.openlibrary.org/b/id/${book.coverId}-S.jpg',
                                  width: 40,
                                  height: 56,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) =>
                                      const Icon(Icons.book_outlined, size: 36),
                                )
                              : const Icon(Icons.book_outlined, size: 36),
                          title: Text(book.title),
                          subtitle: Text('$author$yearText'),
                          trailing: IconButton(
                            icon: const Icon(Icons.copy),
                            tooltip: 'Copy book ID',
                            onPressed: () {
                              Clipboard.setData(
                                  ClipboardData(text: book.workId));
                              ScaffoldMessenger.of(context)
                                ..hideCurrentSnackBar()
                                ..showSnackBar(SnackBar(
                                  content: Text('Copied ID: ${book.workId}'),
                                ));
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

// ─── Movies tab ───────────────────────────────────────────────────────────────

class _MoviesTab extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  _MoviesTab();

  @override
  State<_MoviesTab> createState() => _MoviesTabState();
}

class _MoviesTabState extends State<_MoviesTab>
    with AutomaticKeepAliveClientMixin {
  final OmdbApi _api = OmdbApi(omdbKey);
  final TextEditingController _controller = TextEditingController();
  Timer? _debounce;
  Future<List<Map<String, dynamic>>>? _results;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (!mounted) return;

      final query = _controller.text.trim();
      if (query.length < 3) {
        if (_results != null) {
          setState(() {
            _results = null;
          });
        }
        return;
      }

      final future = _api.search(query);
      setState(() {
        _results = future;
      });
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    if (omdbKey.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'No OMDb key found.\n\n'
            'Run the app with:\n'
            'flutter run --dart-define=OMDB_KEY=your-key',
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
            autofocus: false,
            decoration: const InputDecoration(
              hintText: 'Search movies, e.g. interstellar',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
          ),
        ),
        Expanded(
          child: _results == null
              ? const Center(child: Text('Type to search movies'))
              : FutureBuilder<List<Map<String, dynamic>>>(
                  future: _results,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    final movies =
                        snapshot.data ?? const <Map<String, dynamic>>[];
                    if (movies.isEmpty) {
                      return const Center(child: Text('Nothing found'));
                    }
                    return ListView.builder(
                      itemCount: movies.length,
                      itemBuilder: (context, index) {
                        final movie = movies[index];
                        final title = movie['Title'] as String? ?? 'Untitled';
                        final year = movie['Year'] as String? ?? '';
                        final poster = movie['Poster'] as String? ?? '';
                        final imdbId = movie['imdbID'] as String? ?? '';
                        final hasPoster =
                            poster.isNotEmpty && poster != 'N/A';
                        return ListTile(
                          leading: hasPoster
                              ? Image.network(
                                  poster,
                                  width: 40,
                                  height: 56,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => const Icon(
                                      Icons.movie_outlined,
                                      size: 36),
                                )
                              : const Icon(Icons.movie_outlined, size: 36),
                          title: Text(title),
                          subtitle: Text(year),
                          trailing: IconButton(
                            icon: const Icon(Icons.copy),
                            tooltip: 'Copy movie ID',
                            onPressed: () {
                              Clipboard.setData(ClipboardData(text: imdbId));
                              ScaffoldMessenger.of(context)
                                ..hideCurrentSnackBar()
                                ..showSnackBar(SnackBar(
                                  content: Text('Copied ID: $imdbId'),
                                ));
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

// ─── My Picks tab ─────────────────────────────────────────────────────────────

class _MyPicksTab extends StatefulWidget {
  const _MyPicksTab({required this.pickSource});

  final PickSource pickSource;

  @override
  State<_MyPicksTab> createState() => _MyPicksTabState();
}

class _MyPicksTabState extends State<_MyPicksTab> {
  late Future<List<Pick>> _future;

  @override
  void initState() {
    super.initState();
    _future = widget.pickSource.fetchPicks();
  }

  Future<void> _refresh() async {
    setState(() => _future = widget.pickSource.fetchPicks());
    await _future.catchError((_) => <Pick>[]);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Pick>>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView(
              children: [
                const SizedBox(height: 160),
                Center(child: Text('Error: ${snapshot.error}')),
              ],
            ),
          );
        }

        final picks = snapshot.data ?? const <Pick>[];

        if (picks.isEmpty) {
          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView(
              children: const [
                SizedBox(height: 160),
                Center(child: Text('No picks yet.')),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: _refresh,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: picks.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final pick = picks[index];
              return ListTile(
                leading: Icon(
                  pick.kind == PickKind.movie
                      ? Icons.movie_outlined
                      : Icons.book_outlined,
                ),
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
          ),
        );
      },
    );
  }
}
