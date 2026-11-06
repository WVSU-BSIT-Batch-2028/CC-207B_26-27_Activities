import 'package:flutter/material.dart';

import '../api/omdb_api.dart';
import '../config.dart';
import '../models/movie.dart';
import '../widgets/copy_id_button.dart';
import '../widgets/cover_image.dart';
import '../widgets/omdb_setup_message.dart';
import '../widgets/search_page.dart';

/// OMDb search. An empty `OMDB_KEY` shows setup instructions and sends nothing.
class MoviesScreen extends StatefulWidget {
  const MoviesScreen({super.key, this.api, this.apiKey = omdbKey});

  final OmdbApi? api;
  final String apiKey;

  @override
  State<MoviesScreen> createState() => _MoviesScreenState();
}

class _MoviesScreenState extends State<MoviesScreen>
    with AutomaticKeepAliveClientMixin {
  OmdbApi? _api;
  bool _ownsApi = false;

  @override
  bool get wantKeepAlive => true;

  bool get _configured => widget.apiKey.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    if (!_configured) return;
    _ownsApi = widget.api == null;
    _api = widget.api ?? OmdbApi(apiKey: widget.apiKey);
  }

  @override
  void dispose() {
    if (_ownsApi) _api?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (!_configured || _api == null) {
      return const OmdbSetupMessage();
    }
    return SearchPage<Movie>(
      hint: 'Search movies',
      instructions: 'Type at least 3 letters to search OMDb.',
      search: _api!.search,
      itemBuilder: (BuildContext context, Movie movie) =>
          MovieResultTile(movie: movie),
    );
  }
}

class MovieResultTile extends StatelessWidget {
  const MovieResultTile({super.key, required this.movie});

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 12, 4, 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CoverImage(
              url: movie.posterUrl,
              fallbackIcon: Icons.movie_outlined,
              semanticLabel: 'Poster of ${movie.title}',
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    movie.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(movie.yearLabel, style: theme.textTheme.bodyMedium),
                ],
              ),
            ),
            CopyIdButton(id: movie.imdbId, tooltip: 'Copy IMDb ID'),
          ],
        ),
      ),
    );
  }
}
