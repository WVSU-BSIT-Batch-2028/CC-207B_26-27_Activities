import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../data/omdb_api.dart';
import '../../models/movie.dart';

class MovieSearchTab extends StatefulWidget {
  const MovieSearchTab({super.key, this.api});

  final OmdbApi? api;

  @override
  State<MovieSearchTab> createState() => _MovieSearchTabState();
}

class _MovieSearchTabState extends State<MovieSearchTab> {
  late final OmdbApi _api = widget.api ?? OmdbApi(apiKey: omdbKey);
  Timer? _debounce;
  Future<List<Movie>>? _results;

  void _onChanged(String text) {
    _debounce?.cancel();
    final query = text.trim();
    if (query.length < 3) {
      setState(() => _results = null);
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      final results = _api.search(query);
      setState(() {
        _results = results;
      });
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    if (widget.api == null) _api.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_api.apiKey.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Text(
            'OMDB_KEY is missing.\nRun the app with:\n'
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
            onChanged: _onChanged,
            decoration: const InputDecoration(
              hintText: 'Search movies (minimum 3 characters)',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
          ),
        ),
        Expanded(
          child: _results == null
              ? const Center(child: Text('Type at least 3 letters to search'))
              : FutureBuilder<List<Movie>>(
                  future: _results,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    final movies = snapshot.data ?? const <Movie>[];
                    if (movies.isEmpty) {
                      return const Center(child: Text('Nothing found'));
                    }
                    return ListView.builder(
                      itemCount: movies.length,
                      itemBuilder: (context, index) {
                        final movie = movies[index];
                        return ListTile(
                          leading: _MoviePoster(poster: movie.poster),
                          title: Text(movie.title),
                          subtitle: Text(movie.year),
                          trailing: IconButton(
                            tooltip: 'Copy movie ID',
                            icon: const Icon(Icons.copy),
                            onPressed: () async {
                              await Clipboard.setData(
                                ClipboardData(text: movie.imdbId),
                              );
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Copied ID: ${movie.imdbId}'),
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
}

class _MoviePoster extends StatelessWidget {
  const _MoviePoster({required this.poster});

  final String poster;

  @override
  Widget build(BuildContext context) {
    if (poster.isEmpty || poster == 'N/A') {
      return const Icon(Icons.movie, size: 40);
    }
    return Image.network(
      poster,
      width: 48,
      fit: BoxFit.cover,
      errorBuilder: (_, _, _) => const Icon(Icons.movie, size: 40),
    );
  }
}
