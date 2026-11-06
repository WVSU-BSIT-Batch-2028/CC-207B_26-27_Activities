import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../config.dart';
import '../data/omdb_api.dart';
import '../models/movie.dart';

class MoviesTab extends StatefulWidget {
  const MoviesTab({super.key});

  @override
  State<MoviesTab> createState() => _MoviesTabState();
}

class _MoviesTabState extends State<MoviesTab>
    with AutomaticKeepAliveClientMixin {
  final _api = OmdbApi();
  Timer? _debounce;
  Future<List<Movie>>? _results;

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void _search(String text) {
    final query = text.trim();
    if (query.length < 3) return;
    if (!mounted) return;
    setState(() {
      _results = _api.search(query);
    });
  }

  void _onChanged(String text) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () => _search(text));
  }

  Future<void> _copyId(String id) async {
    await Clipboard.setData(ClipboardData(text: id));
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text('Copied $id')));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    if (omdbKey.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'No OMDb key found.\n\n'
            'Run the app with\n'
            '--dart-define=OMDB_KEY=yourkey\n'
            'or\n'
            '--dart-define-from-file=keys.json',
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
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              labelText: 'Search movies',
              border: OutlineInputBorder(),
            ),
            onChanged: _onChanged,
            onSubmitted: (text) {
              _debounce?.cancel();
              _search(text);
            },
          ),
        ),
        Expanded(child: _buildResults()),
      ],
    );
  }

  Widget _buildResults() {
    if (_results == null) {
      return const Center(child: Text('Type at least 3 letters to search.'));
    }
    return FutureBuilder<List<Movie>>(
      future: _results,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('${snapshot.error}'));
        }
        final movies = snapshot.data!;
        if (movies.isEmpty) {
          return const Center(child: Text('Nothing found.'));
        }
        return ListView.builder(
          itemCount: movies.length,
          itemBuilder: (context, i) => _buildTile(movies[i]),
        );
      },
    );
  }

  Widget _buildTile(Movie movie) {
    return ListTile(
      leading: SizedBox(
        width: 40,
        height: 56,
        child: movie.posterUrl == null
            ? const Icon(Icons.movie)
            : ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Image.network(
                  movie.posterUrl!,
                  fit: BoxFit.cover,
                  semanticLabel: 'Poster of ${movie.title}',
                  errorBuilder: (context, error, stack) =>
                      const Icon(Icons.movie),
                ),
              ),
      ),
      title: Text(movie.title),
      subtitle: movie.year == null ? null : Text(movie.year!),
      trailing: IconButton(
        tooltip: 'Copy ID',
        icon: const Icon(Icons.copy),
        onPressed: () => _copyId(movie.imdbId),
      ),
    );
  }
}