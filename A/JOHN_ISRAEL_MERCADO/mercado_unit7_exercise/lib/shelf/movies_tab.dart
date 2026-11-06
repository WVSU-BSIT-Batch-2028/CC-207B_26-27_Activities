import 'dart:async';

import 'package:flutter/material.dart';

import 'api.dart';
import 'common.dart';
import 'config.dart';
import 'models.dart';

class MoviesTab extends StatefulWidget {
  const MoviesTab({super.key});

  @override
  State<MoviesTab> createState() => _MoviesTabState();
}

class _MoviesTabState extends State<MoviesTab>
    with AutomaticKeepAliveClientMixin {
  final OmdbApi _api = OmdbApi();
  Timer? _debounce;
  Future<List<Movie>>? _results;

  @override
  bool get wantKeepAlive => true;

  void _onChanged(String text) {
    _debounce?.cancel();
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    if (omdbKey.isEmpty) {
      return const MessageBox(
        'No OMDb key found.\n\nRun the app with:\n'
        'flutter run --dart-define=OMDB_KEY=your-key',
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: TextField(
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              labelText: 'Search movies, e.g. avengers',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
            ),
            onChanged: _onChanged,
          ),
        ),
        Expanded(
          child: _results == null
              ? const MessageBox('Type at least 3 letters to search movies.')
              : FutureBuilder<List<Movie>>(
                  future: _results,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return MessageBox(
                        'Something went wrong: ${snapshot.error}',
                      );
                    }
                    final movies = snapshot.data!;
                    if (movies.isEmpty) {
                      return const MessageBox('Nothing found.');
                    }
                    return ListView.builder(
                      itemCount: movies.length,
                      itemBuilder: (context, index) {
                        final movie = movies[index];
                        return ResultTile(
                          leading: imageOrIcon(movie.poster, Icons.movie),
                          title: movie.title,
                          subtitle: movie.year,
                          id: movie.imdbId,
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
