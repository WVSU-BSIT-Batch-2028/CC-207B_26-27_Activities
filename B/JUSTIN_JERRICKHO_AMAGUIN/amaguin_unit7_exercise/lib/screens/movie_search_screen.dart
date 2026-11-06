import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../config.dart' as config;
import '../models/movie.dart';
import '../services/omdb_api.dart';
import '../widgets/shelf_status.dart';

class MovieSearchScreen extends StatefulWidget {
  const MovieSearchScreen({super.key, this.api, this.apiKey = config.omdbKey});

  final OmdbApi? api;
  final String apiKey;

  @override
  State<MovieSearchScreen> createState() => _MovieSearchScreenState();
}

class _MovieSearchScreenState extends State<MovieSearchScreen>
    with AutomaticKeepAliveClientMixin {
  late final OmdbApi _api;
  Timer? _debounce;
  String _query = '';
  Future<List<Movie>>? _results;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _api = widget.api ?? OmdbApi(key: widget.apiKey);
  }

  void _onChanged(String text) {
    _debounce?.cancel();
    _query = text.trim();
    setState(() {
      _results = null;
    });
    if (_query.length < 3) return;
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (mounted) _search();
    });
  }

  void _search() {
    final next = _api.search(_query);
    next.ignore();
    setState(() {
      _results = next;
    });
  }

  Future<void> _copyId(Movie movie) async {
    await Clipboard.setData(ClipboardData(text: movie.imdbId));
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Copied ID: ${movie.imdbId}')));
  }

  @override
  void dispose() {
    _debounce?.cancel();
    if (widget.api == null) _api.close();
    super.dispose();
  }

  Widget _poster(Movie movie) {
    const fallback = Center(
      child: Icon(Icons.movie_outlined, semanticLabel: 'No poster available'),
    );
    final url = movie.posterUrl;
    return SizedBox(
      width: 48,
      height: 64,
      child: url == null
          ? fallback
          : ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Image.network(
                url,
                fit: BoxFit.cover,
                semanticLabel: 'Poster of ${movie.title}',
                errorBuilder: (_, _, _) => fallback,
                loadingBuilder: (_, child, progress) =>
                    progress == null ? child : fallback,
              ),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (_api.key.trim().isEmpty) {
      return const ShelfStatus(
        icon: Icons.key_outlined,
        message: 'Movie search needs your OMDb key.\n\nAdd OMDB_KEY to cms.json, then restart:\nflutter run --dart-define-from-file=cms.json\n\nOr pass --dart-define=OMDB_KEY=your-key',
      );
    }
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            onChanged: _onChanged,
            textInputAction: TextInputAction.search,
            decoration: const InputDecoration(
              labelText: 'Search movies',
              hintText: 'Type at least 3 characters',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
          ),
        ),
        Expanded(
          child: _results == null
              ? ShelfStatus(
                  icon: Icons.movie_outlined,
                  message: _query.length < 3
                      ? 'Type at least 3 characters to search for movies.'
                      : 'Waiting for you to finish typing…',
                )
              : FutureBuilder<List<Movie>>(
                  future: _results,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return ShelfStatus(
                        message: '${snapshot.error}',
                        icon: Icons.error_outline,
                        onRetry: _search,
                      );
                    }
                    final movies = snapshot.data ?? const <Movie>[];
                    if (movies.isEmpty) {
                      return const ShelfStatus(
                        message: 'Nothing found',
                        icon: Icons.search_off,
                      );
                    }
                    return ListView.separated(
                      padding: const EdgeInsets.fromLTRB(8, 0, 8, 16),
                      itemCount: movies.length,
                      separatorBuilder: (_, _) => const Divider(),
                      itemBuilder: (context, index) {
                        final movie = movies[index];
                        return ListTile(
                          leading: _poster(movie),
                          title: Text(movie.title),
                          subtitle: Text('${movie.year}\n${movie.imdbId}'),
                          isThreeLine: true,
                          trailing: IconButton(
                            tooltip: 'Copy ID for ${movie.title}',
                            onPressed: () => _copyId(movie),
                            icon: const Icon(Icons.copy_outlined),
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
