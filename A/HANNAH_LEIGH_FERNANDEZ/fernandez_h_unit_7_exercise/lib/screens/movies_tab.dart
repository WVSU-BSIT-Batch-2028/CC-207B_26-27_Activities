import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/movie.dart';
import '../services/omdb_api.dart';

const omdbKey = String.fromEnvironment('OMDB_KEY');

class MoviesTab extends StatefulWidget {
  const MoviesTab({super.key});

  @override
  State<MoviesTab> createState() => _MoviesTabState();
}

class _MoviesTabState extends State<MoviesTab> {
  late final OmdbApi api;

  final TextEditingController _controller = TextEditingController();

  Timer? _debounce;
  Future<List<Movie>>? _results;

  @override
  void initState() {
    super.initState();
    api = OmdbApi(apiKey: omdbKey);
  }

  void _onChanged(String text) {
    _debounce?.cancel();

    final query = text.trim();

    if (query.length < 3) {
      setState(() {
        _results = null;
      });
      return;
    }

    if (omdbKey.isEmpty) return;

    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (!mounted) return;

      setState(() {
        _results = api.search(query);
      });
    });
  }

  void _copyId(String id) {
    Clipboard.setData(ClipboardData(text: id));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: Text('Copied IMDb ID: $id'),
      ),
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  Widget _message(IconData icon, String text, Color color) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48, color: color),
            const SizedBox(height: 12),
            Text(text, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    if (omdbKey.isEmpty) {
      return _message(
        Icons.key_off,
        'OMDb API key is missing.\n\n'
        'Run your app with:\n'
        '--dart-define=OMDB_KEY=your-key',
        colors.error,
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: TextField(
            controller: _controller,
            onChanged: _onChanged,
            decoration: InputDecoration(
              hintText: 'Search movies (e.g. Inception)...',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: colors.surfaceContainerHighest,
              contentPadding: const EdgeInsets.symmetric(vertical: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(28),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),

        Expanded(
          child: _results == null
              ? _message(
                  Icons.movie_filter_outlined,
                  'Search for at least 3 letters',
                  colors.outline,
                )
              : FutureBuilder<List<Movie>>(
                  future: _results,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return _message(
                        Icons.error_outline,
                        'Error: ${snapshot.error}',
                        colors.error,
                      );
                    }

                    final movies = snapshot.data ?? [];

                    if (movies.isEmpty) {
                      return _message(
                        Icons.search_off,
                        'Nothing found',
                        colors.outline,
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemCount: movies.length,
                      itemBuilder: (context, index) {
                        final movie = movies[index];

                        final hasPoster =
                            movie.poster.isNotEmpty && movie.poster != 'N/A';

                        final placeholder = Container(
                          width: 50,
                          height: 70,
                          color: colors.primaryContainer,
                          child: Icon(
                            Icons.movie,
                            size: 28,
                            color: colors.onPrimaryContainer,
                          ),
                        );

                        return Card(
                          elevation: 0,
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 6,
                          ),
                          color: colors.surfaceContainerLow,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            side: BorderSide(color: colors.outlineVariant),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: hasPoster
                                  ? Image.network(
                                      movie.poster,
                                      width: 50,
                                      height: 70,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                            return placeholder;
                                          },
                                    )
                                  : placeholder,
                            ),

                            title: Text(
                              movie.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),

                            subtitle: Text(movie.year),

                            trailing: IconButton(
                              icon: Icon(Icons.copy, color: colors.outline),
                              tooltip: 'Copy IMDb ID',
                              onPressed: () => _copyId(movie.imdbId),
                            ),
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
