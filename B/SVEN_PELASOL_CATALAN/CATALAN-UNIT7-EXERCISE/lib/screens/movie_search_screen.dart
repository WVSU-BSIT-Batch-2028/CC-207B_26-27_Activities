import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/api_exception.dart';
import '../models/movie.dart';
import '../services/omdb_api.dart';

const String omdbKey = String.fromEnvironment('OMDB_KEY');

class MovieSearchScreen extends StatefulWidget {
  const MovieSearchScreen({super.key});

  @override
  State<MovieSearchScreen> createState() => _MovieSearchScreenState();
}

class _MovieSearchScreenState extends State<MovieSearchScreen> {
  late final OmdbApi _api = const OmdbApi(apiKey: omdbKey);
  final TextEditingController _controller = TextEditingController();
  Timer? _debounce;
  Future<List<Movie>>? _results;
  String _query = '';
  int _searchGeneration = 0;

  void _onChanged(String text) {
    _debounce?.cancel();
    final query = text.trim();
    final generation = ++_searchGeneration;
    setState(() {
      _query = query;
      _results = null;
    });

    if (query.length < 3 || omdbKey.isEmpty) return;

    // Start the request only after the user has stopped typing for 500 ms.
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _startSearch(query, generation);
    });
  }

  void _startSearch(String query, int generation) {
    if (!mounted || generation != _searchGeneration || omdbKey.isEmpty) return;
    debugPrint('[Movies] Starting OMDb search for: $query');
    final request = _api.search(query);
    setState(() {
      _results = request;
    });
  }

  void _submitSearch(String text) {
    _debounce?.cancel();
    final query = text.trim();
    final generation = ++_searchGeneration;
    setState(() => _query = query);
    if (query.length >= 3 && omdbKey.isNotEmpty) {
      _startSearch(query, generation);
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchGeneration++;
    _controller.dispose();
    super.dispose();
  }

  Future<void> _copyId(Movie movie) async {
    await Clipboard.setData(ClipboardData(text: movie.imdbId));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Copied IMDb ID: ${movie.imdbId}')),
    );
  }

  Widget _poster(Movie movie) {
    if (movie.posterUrl == null) {
      return const SizedBox(
        width: 52,
        height: 76,
        child: Icon(Icons.movie_outlined, size: 34),
      );
    }
    return Image.network(
      movie.posterUrl!,
      width: 52,
      height: 76,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => const SizedBox(
        width: 52,
        height: 76,
        child: Icon(Icons.movie_outlined, size: 34),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (omdbKey.isEmpty) {
      return ListView(
        padding: const EdgeInsets.all(24),
        children: const [
          Icon(Icons.key_outlined, size: 48),
          SizedBox(height: 12),
          Text(
            'OMDb API key required',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 8),
          Text(
            'Get a free key at omdbapi.com/apikey.aspx, then run the app with '
            '--dart-define=OMDB_KEY=your-key. Restart the app after adding the key.',
            textAlign: TextAlign.center,
          ),
        ],
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
          child: TextField(
            controller: _controller,
            onChanged: _onChanged,
            onSubmitted: _submitSearch,
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              labelText: 'Search movies',
              hintText: 'Try Interstellar',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: IconButton(
                tooltip: 'Clear search',
                onPressed: () {
                  _controller.clear();
                  _onChanged('');
                },
                icon: const Icon(Icons.close),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ),
        Expanded(child: _buildResults()),
      ],
    );
  }

  Widget _buildResults() {
    if (_query.length < 3) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text('Enter at least 3 characters to search OMDb.'),
        ),
      );
    }
    if (_results == null) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 12),
            Text('Waiting 500 ms before searching…'),
          ],
        ),
      );
    }

    return FutureBuilder<List<Movie>>(
      future: _results,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          final error = snapshot.error;
          final message = error is ApiException ? error.message : '$error';
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text('Could not search movies: $message'),
            ),
          );
        }
        final movies = snapshot.data ?? const <Movie>[];
        if (movies.isEmpty) {
          return const Center(child: Text('Nothing found. Try another title.'));
        }

        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
          itemCount: movies.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final movie = movies[index];
            return ListTile(
              contentPadding: const EdgeInsets.symmetric(vertical: 6),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: _poster(movie),
              ),
              title: Text(movie.title, maxLines: 2, overflow: TextOverflow.ellipsis),
              subtitle: Text(movie.year),
              trailing: IconButton(
                tooltip: 'Copy IMDb ID',
                onPressed: () => _copyId(movie),
                icon: const Icon(Icons.copy_outlined),
              ),
            );
          },
        );
      },
    );
  }
}
