
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/movie.dart';

class OmdbApi {
  static const String _apiKey = String.fromEnvironment('OMDB_KEY');

  Future<List<Movie>> search(String query) async {
    if (_apiKey.isEmpty) {
      throw Exception(
        'OMDb API key is missing. Run the app with --dart-define=OMDB_KEY=YOUR_KEY',
      );
    }

    final uri = Uri.https(
      'www.omdbapi.com',
      '/',
      {
        'apikey': _apiKey,
        's': query,
        'type': 'movie',
      },
    );

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Failed to load movies');
    }

    final data = jsonDecode(response.body);

    if (data['Response'] == 'False') {
      if (data['Error'] == 'Movie not found!') {
        return [];
      }

      throw Exception(data['Error'] ?? 'Movie search failed');
    }

    final List results = data['Search'] ?? [];

    return results
        .map((movie) => Movie.fromJson(movie))
        .toList();
  }
}
