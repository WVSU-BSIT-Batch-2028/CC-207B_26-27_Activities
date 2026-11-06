import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '/data/omdb_api.dart';
import '/models/movie.dart';

/// The key comes from --dart-define=OMDB_KEY=... when the app runs.
const omdbKey = String.fromEnvironment('OMDB_KEY');

class MoviesTab extends StatefulWidget {
  const MoviesTab({super.key});

  @override
  State<MoviesTab> createState() => _MoviesTabState();
}

class _MoviesTabState extends State<MoviesTab> {
  final _api = OmdbApi(omdbKey);
  final _controller = TextEditingController();
  Timer? _debounce;

  /// null until the first search starts.
  Future<List<Movie>>? _results;

  void _onChanged(String text) {
    _debounce?.cancel(); // the user typed again: forget the old timer
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
    _controller.dispose();
    super.dispose();
  }

  Future<void> _copyId(Movie movie) async {
    await Clipboard.setData(ClipboardData(text: movie.imdbId));
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text('Copied ${movie.imdbId}')));
  }

  Widget _poster(Movie movie) {
    const icon = Icon(Icons.movie, size: 32);
    final url = movie.poster;
    return SizedBox(
      width: 44,
      height: 60,
      child: url == null
          ? icon
          : Image.network(
              url,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stack) => icon,
            ),
    );
  }

  Widget _buildResults() {
    final results = _results;
    if (results == null) {
      return const Center(child: Text('Type at least 3 letters to search.'));
    }
    return FutureBuilder<List<Movie>>(
      future: results,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('${snapshot.error}'));
        }
        final movies = snapshot.data!;
        if (movies.isEmpty) {
          return const Center(child: Text('Nothing found.'));
        }
        return ListView.builder(
          itemCount: movies.length,
          itemBuilder: (context, i) {
            final movie = movies[i];
            return ListTile(
              leading: _poster(movie),
              title: Text(movie.title),
              subtitle: Text(movie.year),
              trailing: IconButton(
                tooltip: 'Copy ID',
                icon: const Icon(Icons.copy),
                onPressed: () => _copyId(movie),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // No key: show how to pass it instead of searching.
    if (omdbKey.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'No OMDb key yet.\n\n'
            'Get a free key at omdbapi.com/apikey.aspx, then run:\n\n'
            'flutter run --dart-define=OMDB_KEY=fbdc28ee',
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
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              labelText: 'Search movies',
              border: OutlineInputBorder(),
            ),
            onChanged: _onChanged,
          ),
        ),
        Expanded(child: _buildResults()),
      ],
    );
  }
}