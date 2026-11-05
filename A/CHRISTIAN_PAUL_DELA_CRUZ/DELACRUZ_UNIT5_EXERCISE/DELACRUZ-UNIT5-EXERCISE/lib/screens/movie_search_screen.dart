import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data/media_apis.dart';
import '../models/movie.dart';
import '../widgets/cover_thumbnail.dart';

class MovieSearchScreen extends StatefulWidget {
  const MovieSearchScreen({super.key, this.api = const OmdbApi()});

  final OmdbApi api;

  @override
  State<MovieSearchScreen> createState() => _MovieSearchScreenState();
}

class _MovieSearchScreenState extends State<MovieSearchScreen> {
  Timer? _debounce;
  Future<List<Movie>>? _results;
  String _query = '';

  void _onChanged(String text) {
    _debounce?.cancel();
    final query = text.trim();
    setState(() {
      _query = query;
      _results = null;
    });
    if (query.length < 3) return;
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _results = widget.api.search(query);
        });
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> _copyId(Movie movie) async {
    await Clipboard.setData(ClipboardData(text: movie.imdbId));
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Copied ${movie.imdbId}')));
  }

  @override
  Widget build(BuildContext context) {
    if (omdbKey.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'OMDb API key is missing. Run with '
            '--dart-define=OMDB_KEY=your-key to search movies.',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            decoration: const InputDecoration(
              labelText: 'Search movies',
              hintText: 'Enter at least 3 letters',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
            onChanged: _onChanged,
          ),
        ),
        Expanded(
          child: _query.length < 3
              ? const Center(child: Text('Search for a movie by title.'))
              : _results == null
              ? const Center(child: Text('Searching shortly...'))
              : FutureBuilder<List<Movie>>(
                  future: _results,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Text(
                            'Could not search movies: ${snapshot.error}',
                          ),
                        ),
                      );
                    }
                    final movies = snapshot.data ?? const <Movie>[];
                    if (movies.isEmpty) {
                      return const Center(child: Text('Nothing found.'));
                    }
                    return ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      itemCount: movies.length,
                      separatorBuilder: (context, index) =>
                          const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final movie = movies[index];
                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 6,
                          ),
                          leading: CoverThumbnail(
                            url: movie.posterUrl,
                            fallbackIcon: Icons.movie_outlined,
                          ),
                          title: Text(movie.title),
                          subtitle: Text(movie.year),
                          trailing: IconButton(
                            tooltip: 'Copy movie ID',
                            icon: const Icon(Icons.copy),
                            onPressed: () => _copyId(movie),
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
