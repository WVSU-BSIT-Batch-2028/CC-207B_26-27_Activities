import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../config.dart';
import '../data/omdb_api.dart';
import '../models/movie.dart';
import '../widgets/copy_id_button.dart';
import '../widgets/media_artwork.dart';

class MoviesTab extends StatefulWidget {
  const MoviesTab({super.key});

  @override
  State<MoviesTab> createState() => _MoviesTabState();
}

class _MoviesTabState extends State<MoviesTab> {
  final TextEditingController _controller = TextEditingController();
  late final http.Client _client;
  late final OmdbApi _api;
  Timer? _debounce;
  Future<List<Movie>>? _future;
  String _query = '';
  bool _waiting = false;

  @override
  void initState() {
    super.initState();
    _client = http.Client();
    _api = OmdbApi(_client, apiKey: omdbKey);
  }

  void _onChanged(String text) {
    _debounce?.cancel();
    final query = text.trim();
    setState(() {
      _query = query;
      _future = null;
      _waiting = query.length >= 3;
    });
    if (query.length < 3) return;
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      setState(() {
        _waiting = false;
        _future = _api.search(query);
      });
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    _client.close();
    super.dispose();
  }

  Widget _buildResults() {
    if (omdbKey.trim().isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'Add your OMDb key when running the app with '
            '--dart-define=OMDB_KEY=your-key to search for movies.',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
    if (_query.length < 3) {
      return const Center(child: Text('Search movie titles (3+ letters).'));
    }
    if (_waiting) return const Center(child: CircularProgressIndicator());
    final future = _future;
    if (future == null) return const SizedBox.shrink();
    return FutureBuilder<List<Movie>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('${snapshot.error}'));
        }
        final movies = snapshot.data ?? const <Movie>[];
        if (movies.isEmpty) return const Center(child: Text('Nothing found.'));
        return ListView.separated(
          itemCount: movies.length,
          separatorBuilder: (context, index) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final movie = movies[index];
            return ListTile(
              leading: MediaArtwork(url: movie.posterUrl, icon: Icons.movie),
              title: Text(
                movie.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(movie.year),
              trailing: CopyIdButton(id: movie.imdbId, label: 'Movie'),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
      children: [
        if (omdbKey.trim().isNotEmpty)
          TextField(
            controller: _controller,
            onChanged: _onChanged,
            decoration: const InputDecoration(
              labelText: 'Search movies',
              hintText: 'Movie title',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
          ),
        if (omdbKey.trim().isNotEmpty) const SizedBox(height: 12),
        Expanded(child: _buildResults()),
      ],
    ),
  );
}
