import 'dart:async';

import 'package:flutter/material.dart';

import '../data/api_exception.dart';
import '../data/omdb_api.dart';
import '../models/movie.dart';
import '../widgets/copy_id_button.dart';
import '../widgets/error_view.dart';

class MoviesTab extends StatefulWidget {
  const MoviesTab({super.key});

  @override
  State<MoviesTab> createState() => _MoviesTabState();
}

class _MoviesTabState extends State<MoviesTab>
    with AutomaticKeepAliveClientMixin {
  final _api = OmdbApi();
  Timer? _debounce;
  String _query = '';
  Future<List<Movie>>? _results;

  @override
  bool get wantKeepAlive => true;

  void _search(String query) {
    setState(() {
      _query = query;
      _results = _api.search(query);
    });
  }

  void _onChanged(String text) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      final query = text.trim();
      if (!mounted || query.length < 3) return;
      _search(query);
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  Widget _buildResults() {
    final results = _results;
    if (results == null) {
      return const Center(child: Text('Type at least 3 letters to search.'));
    }
    return FutureBuilder<List<Movie>>(
      future: results,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return ErrorView(
            message: messageOf(snapshot.error!),
            onRetry: () => _search(_query),
          );
        }
        final movies = snapshot.data!;
        if (movies.isEmpty) return const Center(child: Text('Nothing found.'));
        return ListView.builder(
          itemCount: movies.length,
          itemBuilder: (context, i) {
            final movie = movies[i];
            return ListTile(
              leading: SizedBox(
                width: 44,
                child: movie.poster == null
                    ? const Icon(Icons.movie)
                    : Image.network(
                        movie.poster!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Icon(Icons.movie),
                      ),
              ),
              title: Text(movie.title),
              subtitle: Text(movie.year),
              trailing: CopyIdButton(id: movie.imdbId),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    // No key: show how to pass it instead of searching.
    if (omdbKey.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.vpn_key_off, size: 48),
              SizedBox(height: 12),
              Text('The OMDb key is missing. Run the app with:'),
              SizedBox(height: 8),
              SelectableText(
                'flutter run --dart-define=OMDB_KEY=your-key',
                style: TextStyle(fontFamily: 'monospace'),
              ),
            ],
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
              prefixIcon: Icon(Icons.search),
              hintText: 'Search movies (OMDb)',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        Expanded(child: _buildResults()),
      ],
    );
  }
}
