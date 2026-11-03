import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import '../config.dart';
import '../models/book.dart';
import '../models/movie.dart';
import '../models/pick.dart';
import '../services/omdb_api.dart';
import '../services/open_library_api.dart';
import '../services/pick_source.dart';
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
              Tab(icon: Icon(Icons.recommend), text: 'My Picks'),
              Tab(icon: Icon(Icons.menu_book), text: 'Books'),
              Tab(icon: Icon(Icons.movie), text: 'Movies'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _MyPicksTab(),
            _BookSearchTab(),
            _MovieSearchTab(),
          ],
        ),
      ),
    );
  }
}

class _MyPicksTab extends StatefulWidget {
  const _MyPicksTab();

  @override
  State<_MyPicksTab> createState() => _MyPicksTabState();
}

class _MyPicksTabState extends State<_MyPicksTab> {
  late final PickSource _pickSource;
  late Future<List<Pick>> _picksFuture;

  @override
  void initState() {
    super.initState();
    _pickSource = ContentfulPickSource(
      http.Client(),
      spaceId: cmsSpace,
      token: cmsToken,
    );
    _picksFuture = _pickSource.fetchPicks();
  }

  Future<void> _refresh() async {
    setState(() {
      _picksFuture = _pickSource.fetchPicks();
    });
    await _picksFuture;
  }

  @override
  Widget build(BuildContext context) {
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
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.error_outline,
                              size: 48, color: Colors.red),
                          const SizedBox(height: 12),
                          Text(
                            snapshot.error.toString(),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          FilledButton.icon(
                            onPressed: _refresh,
                            icon: const Icon(Icons.refresh),
                            label: const Text('Try Again'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          }

          final picks = snapshot.data ?? [];
          if (picks.isEmpty) {
            return ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: const Center(
                    child: Text('No recommendations yet. Add some in Contentful!'),
                  ),
                ),
              ],
            );
          }

          return ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: picks.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final pick = picks[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: pick.isBook
                      ? Colors.teal.withValues(alpha: 0.15)
                      : Colors.deepPurple.withValues(alpha: 0.15),
                  child: Icon(
                    pick.isBook ? Icons.menu_book : Icons.movie,
                    color: pick.isBook ? Colors.teal : Colors.deepPurple,
                  ),
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
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => PickDetailScreen(pick: pick),
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

class _BookSearchTab extends StatefulWidget {
  const _BookSearchTab();

  @override
  State<_BookSearchTab> createState() => _BookSearchTabState();
}

class _BookSearchTabState extends State<_BookSearchTab> {
  final _api = OpenLibraryApi();
  final _controller = TextEditingController();
  Timer? _debounce;
  Future<List<Book>>? _results;
  String _currentQuery = '';

  void _onChanged(String text) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      final query = text.trim();
      if (query.length < 3) return;
      setState(() {
        _currentQuery = query;
        _results = _api.search(query);
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
          padding: const EdgeInsets.all(12.0),
          child: TextField(
            controller: _controller,
            decoration: InputDecoration(
              hintText: 'Search books on Open Library (min 3 letters)...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _controller.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _controller.clear();
                        setState(() {
                          _results = null;
                          _currentQuery = '';
                        });
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            ),
            onChanged: _onChanged,
          ),
        ),
        Expanded(
          child: _results == null
              ? const Center(
                  child: Text('Type at least 3 letters to search books.'),
                )
              : FutureBuilder<List<Book>>(
                  future: _results,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.error_outline,
                                  size: 40, color: Colors.red),
                              const SizedBox(height: 8),
                              Text(snapshot.error.toString(),
                                  textAlign: TextAlign.center),
                              const SizedBox(height: 12),
                              FilledButton(
                                onPressed: () {
                                  setState(() {
                                    _results = _api.search(_currentQuery);
                                  });
                                },
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    final books = snapshot.data ?? [];
                    if (books.isEmpty) {
                      return const Center(child: Text('Nothing found'));
                    }

                    return ListView.separated(
                      itemCount: books.length,
                      separatorBuilder: (context, index) =>
                          const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final book = books[index];
                        final author = book.authors.isNotEmpty
                            ? book.authors.first
                            : 'Unknown author';
                        final yearStr =
                            book.year != null ? ' (${book.year})' : '';

                        return ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: book.coverUrl != null
                                ? Image.network(
                                    book.coverUrl!,
                                    width: 44,
                                    height: 60,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) =>
                                        _coverPlaceholder(),
                                  )
                                : _coverPlaceholder(),
                          ),
                          title: Text(
                            book.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text(
                            '$author$yearStr\nID: ${book.workId}',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          isThreeLine: true,
                          trailing: IconButton(
                            icon: const Icon(Icons.copy),
                            tooltip: 'Copy ID for CMS',
                            onPressed: () {
                              Clipboard.setData(
                                ClipboardData(text: book.workId),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'Copied "${book.workId}" to clipboard!'),
                                  duration: const Duration(seconds: 2),
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
    );
  }

  Widget _coverPlaceholder() {
    return Container(
      width: 44,
      height: 60,
      color: Colors.grey[300],
      child: const Icon(Icons.book, color: Colors.grey),
    );
  }
}

class _MovieSearchTab extends StatefulWidget {
  const _MovieSearchTab();

  @override
  State<_MovieSearchTab> createState() => _MovieSearchTabState();
}

class _MovieSearchTabState extends State<_MovieSearchTab> {
  late final OmdbApi _api;
  final _controller = TextEditingController();
  Timer? _debounce;
  Future<List<Movie>>? _results;
  String _currentQuery = '';

  @override
  void initState() {
    super.initState();
    _api = OmdbApi(apiKey: omdbKey);
  }

  void _onChanged(String text) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      final query = text.trim();
      if (query.length < 3) return;
      setState(() {
        _currentQuery = query;
        _results = _api.search(query);
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
    if (omdbKey.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.key_off, size: 48, color: Colors.orange),
              const SizedBox(height: 12),
              const Text(
                'OMDb API key is missing!',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              const Text(
                'Pass your OMDb key with:\n'
                '--dart-define=OMDB_KEY=your-key\n'
                'or use config.json with --dart-define-from-file=config.json',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: TextField(
            controller: _controller,
            decoration: InputDecoration(
              hintText: 'Search movies on OMDb (min 3 letters)...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _controller.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _controller.clear();
                        setState(() {
                          _results = null;
                          _currentQuery = '';
                        });
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            ),
            onChanged: _onChanged,
          ),
        ),
        Expanded(
          child: _results == null
              ? const Center(
                  child: Text('Type at least 3 letters to search movies.'),
                )
              : FutureBuilder<List<Movie>>(
                  future: _results,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.error_outline,
                                  size: 40, color: Colors.red),
                              const SizedBox(height: 8),
                              Text(snapshot.error.toString(),
                                  textAlign: TextAlign.center),
                              const SizedBox(height: 12),
                              FilledButton(
                                onPressed: () {
                                  setState(() {
                                    _results = _api.search(_currentQuery);
                                  });
                                },
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    final movies = snapshot.data ?? [];
                    if (movies.isEmpty) {
                      return const Center(child: Text('Nothing found'));
                    }

                    return ListView.separated(
                      itemCount: movies.length,
                      separatorBuilder: (context, index) =>
                          const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final movie = movies[index];

                        return ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: movie.posterUrl != null
                                ? Image.network(
                                    movie.posterUrl!,
                                    width: 44,
                                    height: 60,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) =>
                                        _posterPlaceholder(),
                                  )
                                : _posterPlaceholder(),
                          ),
                          title: Text(
                            movie.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text(
                            'Year: ${movie.year ?? 'N/A'}\nID: ${movie.imdbId}',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          isThreeLine: true,
                          trailing: IconButton(
                            icon: const Icon(Icons.copy),
                            tooltip: 'Copy ID for CMS',
                            onPressed: () {
                              Clipboard.setData(
                                ClipboardData(text: movie.imdbId),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'Copied "${movie.imdbId}" to clipboard!'),
                                  duration: const Duration(seconds: 2),
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
    );
  }

  Widget _posterPlaceholder() {
    return Container(
      width: 44,
      height: 60,
      color: Colors.grey[300],
      child: const Icon(Icons.movie, color: Colors.grey),
    );
  }
}
