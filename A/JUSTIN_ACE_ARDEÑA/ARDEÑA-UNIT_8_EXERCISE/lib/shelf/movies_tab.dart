import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'config.dart';
import 'movie.dart';
import 'omdb_api.dart';

/// Movies tab: search OMDb.
class MoviesTab extends StatefulWidget {
  const MoviesTab({super.key});

  @override
  State<MoviesTab> createState() => _MoviesTabState();
}

class _MoviesTabState extends State<MoviesTab>
    with AutomaticKeepAliveClientMixin {
  // Keeps this tab's State alive when the user swipes to another tab.
  @override
  bool get wantKeepAlive => true;

  final api = OmdbApi();
  Future<List<Movie>>? _results; // null until the first search

  // Same debounce as the Books tab: 500 ms after the last key, 3+ letters.
  Timer? _debounce;
  void _onChanged(String text) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      final query = text.trim();
      if (query.length < 3) return;
      // Block body on purpose: an arrow body would return the Future, and
      // setState does not allow that.
      setState(() {
        _results = api.search(query);
      });
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> _copy(Movie movie) async {
    await Clipboard.setData(ClipboardData(text: movie.imdbId));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Copied ${movie.imdbId}')),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // required by AutomaticKeepAliveClientMixin
    // Without a key OMDb cannot be used, so say how to pass it.
    if (omdbKey.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'No OMDb key. Run the app with\n'
            '--dart-define=OMDB_KEY=your-key\n'
            '(or add "OMDB_KEY" to cms.json and use '
            '--dart-define-from-file=cms.json).',
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
            onChanged: _onChanged,
            textInputAction: TextInputAction.search,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'Search movies (3+ letters)',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        Expanded(child: _buildResults()),
      ],
    );
  }

  Widget _buildResults() {
    final future = _results;
    if (future == null) {
      return const Center(child: Text('Type at least 3 letters to search.'));
    }
    return FutureBuilder<List<Movie>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text('${snapshot.error}', textAlign: TextAlign.center),
            ),
          );
        }
        final movies = snapshot.data!;
        if (movies.isEmpty) {
          return const Center(child: Text('Nothing found.'));
        }
        return ListView.builder(
          itemCount: movies.length,
          itemBuilder: (context, i) => _buildMovie(movies[i]),
        );
      },
    );
  }

  Widget _buildMovie(Movie movie) {
    final poster = movie.poster;
    return ListTile(
      leading: SizedBox(
        width: 48,
        height: 64,
        child: poster == null
            ? const Icon(Icons.movie)
            : Image.network(
                poster,
                fit: BoxFit.cover,
                webHtmlElementStrategy: WebHtmlElementStrategy.fallback,
                errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
              ),
      ),
      title: Text(movie.title, maxLines: 2, overflow: TextOverflow.ellipsis),
      subtitle: Text(movie.year),
      trailing: IconButton(
        tooltip: 'Copy IMDb id',
        icon: const Icon(Icons.copy),
        onPressed: () => _copy(movie),
      ),
    );
  }
}
