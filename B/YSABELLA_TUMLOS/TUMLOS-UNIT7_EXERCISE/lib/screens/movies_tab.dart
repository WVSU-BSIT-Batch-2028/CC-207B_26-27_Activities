import 'package:flutter/material.dart';

import '../config.dart';
import '../models/movie.dart';
import '../services/omdb_api.dart';
import '../widgets/copy_id_button.dart';
import '../widgets/message_view.dart';
import '../widgets/network_cover.dart';
import '../widgets/search_tab.dart';
import '../widgets/shelf_card.dart';

class MoviesTab extends StatelessWidget {
  const MoviesTab({super.key});

  static const _api = OmdbApi();

  @override
  Widget build(BuildContext context) {
    if (omdbKey.isEmpty) {
      return const MessageView(
        icon: Icons.key_rounded,
        text:
            'Add your OMDb key to search movies.\n\n'
            'Run the app with:\n'
            'flutter run --dart-define=OMDB_KEY=your-key',
      );
    }

    return SearchTab<Movie>(
      hint: 'Search movies by title',
      search: _api.search,
      itemBuilder: (context, movie) => ShelfCard(
        leading: NetworkCover(
          url: movie.poster,
          width: 52,
          height: 76,
          icon: Icons.movie_rounded,
        ),
        title: movie.title,
        subtitle: movie.year,
        trailing: CopyIdButton(id: movie.imdbId),
      ),
    );
  }
}
