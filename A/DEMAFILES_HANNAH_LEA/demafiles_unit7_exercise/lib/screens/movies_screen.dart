import 'dart:async';

import 'package:flutter/material.dart';

import '../models/movie.dart';
import '../services/cms_service.dart';
import '../services/omdb_api.dart';
import 'books_screen.dart' show ResultTile;

class MoviesScreen extends StatefulWidget {
  const MoviesScreen({super.key});

  @override
  State<MoviesScreen> createState() => _MoviesScreenState();
}

class _MoviesScreenState extends State<MoviesScreen>
    with AutomaticKeepAliveClientMixin {
  final api = OmdbApi();
  Timer? _debounce;
  Future<List<Movie>>? _results;

  @override
  bool get wantKeepAlive => true;

  void _onChanged(String text) {
    _debounce?.cancel(); // the user typed again: forget the old timer
    final query = text.trim();
    if (query.length < 3) {
      if (_results != null) setState(() => _results = null);
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 500), () {
      final results = api.search(query);
      setState(() {
        _results = results;
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

    // Part C.a: when the key is empty, show how to pass it instead of searching.
    if (omdbKey.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'No OMDb key found.\n\nRun the app with:\n'
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
              labelText: 'Search movies, e.g. interstellar',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
          ),
        ),
        Expanded(
          child: _results == null
              ? const Center(child: Text('Type at least 3 letters to search.'))
              : FutureBuilder<List<Movie>>(
                  future: _results,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            'Something went wrong: ${snapshot.error}',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    }
                    final movies = snapshot.data!;
                    if (movies.isEmpty) {
                      return const Center(child: Text('Nothing found.'));
                    }
                    return ValueListenableBuilder<Set<String>>(
                      valueListenable: pickedIds,
                      builder: (context, ids, _) => ListView.builder(
                        itemCount: movies.length,
                        itemBuilder: (context, i) {
                          final m = movies[i];
                          return ResultTile(
                            imageUrl: m.poster,
                            fallbackIcon: Icons.movie_outlined,
                            title: m.title,
                            subtitle: m.year ?? 'n/a',
                            id: m.imdbId,
                            isPicked: ids.contains(m.imdbId),
                          );
                        },
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
