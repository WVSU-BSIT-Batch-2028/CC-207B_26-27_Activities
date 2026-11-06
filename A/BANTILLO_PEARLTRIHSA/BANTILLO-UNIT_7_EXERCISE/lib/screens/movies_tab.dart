import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/movie.dart';
import '../services/omdb_api.dart';

class MoviesTab extends StatefulWidget {
  const MoviesTab({super.key});

  @override
  State<MoviesTab> createState() => _MoviesTabState();
}

class _MoviesTabState extends State<MoviesTab> {
  final OmdbApi _api = OmdbApi();
  final TextEditingController _searchController = TextEditingController();

  Timer? _debounce;
  Future<List<Movie>>? _moviesFuture;
  bool _isDebouncing = false;

  void _searchMovies(String value) {
    _debounce?.cancel();

    final query = value.trim();

    if (query.length < 3) {
      setState(() {
        _moviesFuture = null;
        _isDebouncing = false;
      });
      return;
    }

    setState(() {
      _isDebouncing = true;
      _moviesFuture = null;
    });

    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (!mounted) return;

      setState(() {
        _isDebouncing = false;
        _moviesFuture = _api.search(query);
      });
    });
  }

  void _copyImdbId(String imdbId) {
    Clipboard.setData(ClipboardData(text: imdbId));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('IMDb ID copied!')),
    );
  }

  Widget _buildSearchResults() {
    if (_isDebouncing) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_moviesFuture == null) {
      return const Center(
        child: Text('Search for a movie using at least 3 characters.'),
      );
    }

    return FutureBuilder<List<Movie>>(
      future: _moviesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
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
              leading: SizedBox(
                width: 50,
                height: 75,
                child: movie.poster != null
                    ? Image.network(
                        movie.poster!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.movie_outlined);
                        },
                      )
                    : const Icon(Icons.movie_outlined),
              ),
              title: Text(movie.title),
              subtitle: Text(movie.year),
              trailing: IconButton(
                icon: const Icon(Icons.copy),
                tooltip: 'Copy IMDb ID',
                onPressed: () => _copyImdbId(movie.imdbId),
              ),
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (omdbKey.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'OMDb API key is missing.\n\n'
            'Run the app with:\n'
            '--dart-define=OMDB_KEY=your-key',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            onChanged: _searchMovies,
            decoration: InputDecoration(
              labelText: 'Search for a movie...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _searchController.clear();
                  _searchMovies('');
                },
              ),
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(child: _buildSearchResults()),
        ],
      ),
    );
  }
}