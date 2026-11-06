import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'item_details.dart';

import 'api_exception.dart';

const omdbKey = String.fromEnvironment('OMDB_KEY');

class Movie {
  final String imdbId;
  final String title;
  final String year;
  final String? poster;

  const Movie({
    required this.imdbId,
    required this.title,
    required this.year,
    this.poster,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    final poster = json['Poster'] as String?;
    return Movie(
      imdbId: json['imdbID'] as String,
      title: json['Title'] as String,
      year: json['Year'] as String,
      poster: (poster == null || poster == 'N/A') ? null : poster,
    );
  }
}

class OmdbApi {
  Future<List<Movie>> search(String query) async {
    final uri = Uri.https('www.omdbapi.com', '/', {
      'apikey': omdbKey,
      's': query,
      'type': 'movie',
    });
    final response = await http.get(uri);
    if (response.statusCode != 200) {
      throw ApiException('OMDb error (${response.statusCode})');
    }
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    if (json['Response'] == 'False') {
      final error = json['Error'] as String? ?? 'OMDb error';
      if (error == 'Movie not found!') return const []; 
      throw ApiException(error); 
    }
    final list = json['Search'] as List<dynamic>;
    return [for (final m in list) Movie.fromJson(m as Map<String, dynamic>)];
  }
    Future<ItemDetails> details(String imdbId) async {
    final uri = Uri.https('www.omdbapi.com', '/', {
      'apikey': omdbKey,
      'i': imdbId,
      'plot': 'short',
    });
    final response = await http.get(uri);
    if (response.statusCode != 200) {
      throw ApiException('OMDb error (${response.statusCode})');
    }
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    if (json['Response'] == 'False') {
      throw ApiException(json['Error'] as String? ?? 'OMDb error');
    }
    final poster = json['Poster'] as String?;
    final plot = json['Plot'] as String?;
    return ItemDetails(
      title: json['Title'] as String,
      imageUrl: (poster == null || poster == 'N/A') ? null : poster,
      summary: (plot == null || plot == 'N/A') ? 'No description yet.' : plot,
    );
  }
}

class MoviesTab extends StatefulWidget {
  const MoviesTab({super.key});

  @override
  State<MoviesTab> createState() => _MoviesTabState();
}

class _MoviesTabState extends State<MoviesTab> {
  final OmdbApi api = OmdbApi();
  Timer? _debounce;
  Future<List<Movie>>? _results;

  void _onChanged(String text) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      final query = text.trim();
      if (query.length < 3) return;
      setState(() {
        _results = api.search(query);
      });
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void _copyId(String id) {
    Clipboard.setData(ClipboardData(text: id));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Copied $id')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (omdbKey.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Text(
            'No OMDb key found. Run the app with:\n\n'
            'flutter run --dart-define=OMDB_KEY=210f5658',
            style: theme.textTheme.bodyMedium,
          ),
        ),
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: TextField(
            onChanged: _onChanged,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'Search movies (3+ letters)',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        Expanded(
          child: _results == null
              ? Center(
                  child: Text(
                    'Type at least 3 letters to search.',
                    style: theme.textTheme.bodyMedium,
                  ),
                )
              : FutureBuilder<List<Movie>>(
                  future: _results,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          'Error: ${snapshot.error}',
                          style: theme.textTheme.bodyMedium,
                        ),
                      );
                    }
                    final movies = snapshot.data!;
                    if (movies.isEmpty) {
                      return Center(
                        child: Text(
                          'Nothing found',
                          style: theme.textTheme.bodyMedium,
                        ),
                      );
                    }
                    return ListView(
                      children: [
                        for (final movie in movies)
                          ListTile(
                            leading: movie.poster == null
                                ? const Icon(Icons.movie, size: 40)
                                : Image.network(
                                    movie.poster!,
                                    width: 40,
                                    fit: BoxFit.cover,
                                    semanticLabel: 'Poster of ${movie.title}',
                                  ),
                            title: Text(movie.title),
                            subtitle: Text(movie.year),
                            trailing: IconButton(
                              icon: const Icon(Icons.copy),
                              tooltip: 'Copy ID',
                              onPressed: () => _copyId(movie.imdbId),
                            ),
                          ),
                      ],
                    );
                  },
                ),
        ),
      ],
    );
  }
}