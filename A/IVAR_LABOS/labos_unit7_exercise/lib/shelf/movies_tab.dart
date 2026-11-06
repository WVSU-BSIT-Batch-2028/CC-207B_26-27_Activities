import 'package:flutter/material.dart';

import 'config.dart';
import 'message_view.dart';
import 'omdb_api.dart';
import 'search_tab.dart';

class MoviesTab extends StatefulWidget {
  const MoviesTab({super.key});

  @override
  State<MoviesTab> createState() => _MoviesTabState();
}

class _MoviesTabState extends State<MoviesTab> {
  final _api = OmdbApi();

  Future<List<SearchResult>> _search(String query) async {
    final movies = await _api.search(query);
    return [
      for (final movie in movies)
        SearchResult(
          id: movie.imdbId,
          title: movie.title,
          subtitle: movie.year,
          imageUrl: movie.poster,
          fallbackIcon: Icons.movie,
        ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    if (omdbKey.isEmpty) {
      return const MessageView(
        icon: Icons.key_outlined,
        message:
            'Movie search needs a free OMDb key (omdbapi.com/apikey.aspx).\n\n'
            'Run the app with:\n'
            'flutter run --dart-define=OMDB_KEY=your-key',
      );
    }
    return SearchTab(hint: 'Search movies on OMDb', search: _search);
  }
}
