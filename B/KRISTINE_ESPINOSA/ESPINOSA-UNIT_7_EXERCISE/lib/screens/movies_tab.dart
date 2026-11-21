import 'dart:async';

import 'package:flutter/material.dart';

import '../data/omdb_api.dart';
import '../models/movie.dart';
import 'shelf_widgets.dart';

class MoviesTab extends StatefulWidget {
  const MoviesTab({super.key, required this.api});

  final OmdbApi api;

  @override
  State<MoviesTab> createState() => _MoviesTabState();
}

class _MoviesTabState extends State<MoviesTab>
    with AutomaticKeepAliveClientMixin {
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
        _results = widget.api.search(query);
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
    if (widget.api.apiKey.isEmpty) {
      return const CenterMessage(
        icon: Icons.key_off,
        text:
            'No OMDb key yet.\nGet a free key at omdbapi.com/apikey.aspx, then run:\n'
            'flutter run --dart-define=OMDB_KEY=your-key\n'
            '(or add "OMDB_KEY" to your .json file)',
      );
    }
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: TextField(
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              labelText: 'Search movies',
              helperText: 'Type at least 3 letters',
              border: OutlineInputBorder(),
            ),
            onChanged: _onChanged,
          ),
        ),
        Expanded(child: _buildResults()),
      ],
    );
  }

  Widget _buildResults() {
    final results = _results;
    if (results == null) {
      return const CenterMessage(
        icon: Icons.movie,
        text: 'Search OMDb for a movie.',
      );
    }
    return FutureBuilder<List<Movie>>(
      future: results,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const CenterMessage(
            icon: Icons.hourglass_top,
            text: 'Searching...',
            spinner: true,
          );
        }
        if (snapshot.hasError) {
          return CenterMessage(
            icon: Icons.cloud_off,
            text: '${snapshot.error}',
          );
        }
        final movies = snapshot.data!;
        if (movies.isEmpty) {
          return const CenterMessage(
            icon: Icons.search_off,
            text: 'Nothing found',
          );
        }
        return ListView.builder(
          itemCount: movies.length,
          itemBuilder: (context, i) {
            final movie = movies[i];
            return ListTile(
              leading: CoverImage(
                url: movie.posterUrl,
                fallbackIcon: Icons.movie,
                label: 'Poster of ${movie.title}',
              ),
              title: Text(movie.title),
              subtitle: Text('${movie.year}\n${movie.imdbId}'),
              isThreeLine: true,
              trailing: CopyIdButton(id: movie.imdbId),
            );
          },
        );
      },
    );
  }
}
