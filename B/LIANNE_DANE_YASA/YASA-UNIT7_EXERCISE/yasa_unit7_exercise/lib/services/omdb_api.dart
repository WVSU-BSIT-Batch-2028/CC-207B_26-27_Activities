
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/movie.dart';

class OmdbApi {
  static const String _apiKey = String.fromEnvironment('OMDB_KEY');

  Future<List<Movie>> search(String query) async {
    if (_apiKey.isEmpty) {
      throw Exception(
        'OMDb API key is missing. Run the app with --dart-define=OMDB_KEY=your-key',
      );
    }

    if (query.trim().isEmpty) {
      return [];
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
      throw Exception(
        'Failed to load movies. Status code: ${response.statusCode}',
      );
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;

    if (data['Response'] == 'False') {
      final error = data['Error'] as String? ?? '';

      if (error == 'Movie not found!') {
        return [];
      }

      throw Exception('OMDb API error: $error');
    }

    final results = data['Search'] as List<dynamic>? ?? [];

    return results.map((item) {
      return Movie.fromJson(item as Map<String, dynamic>);
    }).toList();
  }

  Future<Map<String, dynamic>> fetchDetails(String imdbId) async {
    if (_apiKey.isEmpty) {
      throw Exception('OMDb API key is missing.');
    }

    final uri = Uri.https(
      'www.omdbapi.com',
      '/',
      {
        'apikey': _apiKey,
        'i': imdbId,
        'plot': 'short',
      },
    );

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to load movie details. Status code: ${response.statusCode}',
      );
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;

    if (data['Response'] == 'False') {
      throw Exception(
        data['Error'] as String? ?? 'Movie details not found.',
      );
    }

    return data;
  }
}
