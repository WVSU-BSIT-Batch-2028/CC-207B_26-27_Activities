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
  final TextEditingController _controller = TextEditingController();

  Timer? _debounce;
  Future<List<Movie>>? _searchFuture;

  void _onSearchChanged(String query) {
    _debounce?.cancel();

    if (query.trim().length < 3) {
      setState(() {
        _searchFuture = null;
      });
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (!mounted) return;

      setState(() {
        _searchFuture = _api.search(query.trim());
      });
    });
  }

  void _copyMovieId(String id) {
    Clipboard.setData(ClipboardData(text: id));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('IMDb ID copied!'),
      ),
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            controller: _controller,
            onChanged: _onSearchChanged,
            decoration: const InputDecoration(
              labelText: 'Search movies',
              hintText: 'Enter at least 3 characters',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _searchFuture == null
                ? const Center(
                    child: Text('Search for a movie to get started.'),
                  )
                : FutureBuilder<List<Movie>>(
                    future: _searchFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      if (snapshot.hasError) {
                        return const Center(
                          child: Text(
                            'Something went wrong. Check your API key and try again.',
                          ),
                        );
                      }

                      final movies = snapshot.data ?? [];

                      if (movies.isEmpty) {
                        return const Center(
                          child: Text('No movies found.'),
                        );
                      }

                      return ListView.builder(
                        itemCount: movies.length,
                        itemBuilder: (context, index) {
                          final movie = movies[index];

                          return Card(
                            child: ListTile(
                              leading: movie.poster != 'N/A' &&
                                      movie.poster.isNotEmpty
                                  ? Image.network(
                                      movie.poster,
                                      width: 50,
                                      height: 70,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return const Icon(
                                          Icons.movie,
                                          size: 40,
                                        );
                                      },
                                    )
                                  : const Icon(
                                      Icons.movie,
                                      size: 40,
                                    ),
                              title: Text(movie.title),
                              subtitle: Text(movie.year),
                              trailing: IconButton(
                                icon: const Icon(Icons.copy),
                                tooltip: 'Copy IMDb ID',
                                onPressed: () {
                                  _copyMovieId(movie.id);
                                },
                              ),
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
