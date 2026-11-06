import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/movie.dart';
import '../services/omdb_api.dart';

class MoviesScreen extends StatefulWidget {
  const MoviesScreen({super.key});

  @override
  State<MoviesScreen> createState() => _MoviesScreenState();
}

class _MoviesScreenState extends State<MoviesScreen> {
  final OmdbApi _api = OmdbApi();

  Timer? _debounce;
  Future<List<Movie>>? _searchFuture;

  String _query = '';
  bool _isDebouncing = false;

  void _onSearchChanged(String value) {
    _debounce?.cancel();

    final query = value.trim();

    setState(() {
      _query = query;
      _searchFuture = null;
      _isDebouncing = query.length >= 3;
    });

    if (query.length < 3) {
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (!mounted) return;

      setState(() {
        _isDebouncing = false;
        _searchFuture = _api.search(query);
      });
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void _copyMovieId(Movie movie) {
    Clipboard.setData(ClipboardData(text: movie.imdbId));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Copied ${movie.imdbId}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            onChanged: _onSearchChanged,
            decoration: const InputDecoration(
              labelText: 'Search movies',
              hintText: 'Enter at least 3 characters',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
          ),
        ),
        Expanded(
          child: _buildSearchResults(),
        ),
      ],
    );
  }

  Widget _buildSearchResults() {
    if (_query.isEmpty) {
      return const Center(
        child: Text('Search for a movie to get started.'),
      );
    }

    if (_query.length < 3) {
      return const Center(
        child: Text('Enter at least 3 characters to search.'),
      );
    }

    if (_isDebouncing) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    final future = _searchFuture;

    if (future == null) {
      return const SizedBox.shrink();
    }

    return FutureBuilder<List<Movie>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text('Error: ${snapshot.error}'),
            ),
          );
        }

        final movies = snapshot.data ?? [];

        if (movies.isEmpty) {
          return const Center(
            child: Text('Nothing found.'),
          );
        }

        return ListView.separated(
          itemCount: movies.length,
          separatorBuilder: (context, index) =>
              const Divider(height: 1),
          itemBuilder: (context, index) {
            final movie = movies[index];

            return ListTile(
              leading: movie.hasPoster
                  ? Image.network(
                      movie.poster,
                      width: 50,
                      height: 70,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.movie, size: 40);
                      },
                    )
                  : const Icon(Icons.movie, size: 40),
              title: Text(movie.title),
              subtitle: Text(movie.year),
              trailing: IconButton(
                icon: const Icon(Icons.copy),
                tooltip: 'Copy IMDb ID',
                onPressed: movie.imdbId.isEmpty
                    ? null
                    : () => _copyMovieId(movie),
              ),
            );
          },
        );
      },
    );
  }
}
