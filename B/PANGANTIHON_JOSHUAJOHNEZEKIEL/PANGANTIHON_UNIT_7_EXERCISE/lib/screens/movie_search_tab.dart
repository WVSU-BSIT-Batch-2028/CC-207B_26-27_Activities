import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data/movie.dart';
import '../data/omdb_api.dart';
import '../data/pick_source.dart';
import 'catalog_search_tab.dart';

class MovieSearchTab extends StatelessWidget {
  const MovieSearchTab({super.key, required this.api});

  final OmdbApi api;

  @override
  Widget build(BuildContext context) {
    return CatalogSearchTab<Movie>(
      hint: 'Search movies',
      disabledMessage: omdbKey.isEmpty
          ? 'Add your free OMDb key to the launch settings with --dart-define=OMDB_KEY=your-key, then restart the app.'
          : null,
      search: api.search,
      resultTile: (context, movie) => Card(
        margin: EdgeInsets.zero,
        child: ListTile(
          minVerticalPadding: 10,
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CatalogCover(
              icon: Icons.movie_outlined,
              imageUrl: movie.hasPoster ? movie.poster : null,
            ),
          ),
          title: Text(
            movie.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(movie.year),
          trailing: IconButton(
            tooltip: 'Copy IMDb ID',
            icon: const Icon(Icons.copy_rounded),
            onPressed: () => _copyId(context, movie.imdbId),
          ),
        ),
      ),
    );
  }

  Future<void> _copyId(BuildContext context, String id) async {
    await Clipboard.setData(ClipboardData(text: id));
    if (!context.mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Copied IMDb ID: $id')));
  }
}
