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
  final TextEditingController _controller = TextEditingController();

  Timer? _debounce;

  List<Movie> _movies = [];

  bool _isLoading = false;
  bool _hasSearched = false;

  String? _errorMessage;

  void _onSearchChanged(String value) {
    _debounce?.cancel();

    final query = value.trim();

    if (query.length < 3) {
      setState(() {
        _movies = [];
        _isLoading = false;
        _hasSearched = false;
        _errorMessage = null;
      });
      return;
    }

    _debounce = Timer(
      const Duration(milliseconds: 500),
      () => _searchMovies(query),
    );
  }

  Future<void> _searchMovies(String query) async {
    if (!_api.hasApiKey) {
      setState(() {
        _isLoading = false;
        _hasSearched = true;
        _errorMessage =
            'OMDb API key is missing. Please run the app with your API key.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _hasSearched = true;
      _errorMessage = null;
    });

    try {
      final results = await _api.searchMovies(query);

      if (!mounted) return;

      setState(() {
        _movies = results;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _movies = [];
        _isLoading = false;
        _errorMessage = e.toString().contains('Movie not found')
            ? 'Movie not found! Try another search.'
            : 'Something went wrong. Please try again.';
      });
    }
  }

  Future<void> _copyMovieId(Movie movie) async {
    await Clipboard.setData(
      ClipboardData(text: movie.id),
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Copied IMDb ID: ${movie.id}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Widget _buildPoster(Movie movie) {
    if (!movie.hasPoster) {
      return Container(
        width: 85,
        height: 120,
        color: Colors.pink.shade50,
        child: const Icon(
          Icons.movie,
          size: 40,
          color: Colors.pink,
        ),
      );
    }

    return Image.network(
      movie.poster,
      width: 85,
      height: 120,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          width: 85,
          height: 120,
          color: Colors.pink.shade50,
          child: const Icon(
            Icons.movie,
            size: 40,
            color: Colors.pink,
          ),
        );
      },
    );
  }

  Widget _buildMovieCard(Movie movie) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: _buildPoster(movie),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text('Year: ${movie.year}'),
                  const SizedBox(height: 8),
                  OutlinedButton.icon(
                    onPressed: () => _copyMovieId(movie),
                    icon: const Icon(Icons.copy, size: 16),
                    label: const Text('Copy IMDb ID'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessage(String message, IconData icon) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 45,
              color: Colors.pink,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
            ),
          ],
        ),
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
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            controller: _controller,
            onChanged: _onSearchChanged,
            decoration: InputDecoration(
              hintText: 'Search for movies...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _controller.clear();
                  _onSearchChanged('');
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
        ),
        Expanded(
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : _errorMessage != null
                  ? _buildMessage(
                      _errorMessage!,
                      Icons.error_outline,
                    )
                  : !_hasSearched
                      ? _buildMessage(
                          'Enter at least 3 characters to search for movies.',
                          Icons.movie,
                        )
                      : _movies.isEmpty
                          ? _buildMessage(
                              'No movies found. Try another search.',
                              Icons.search_off,
                            )
                          : ListView.builder(
                              itemCount: _movies.length,
                              itemBuilder: (context, index) {
                                return _buildMovieCard(
                                  _movies[index],
                                );
                              },
                            ),
        ),
      ],
    );
  }
}