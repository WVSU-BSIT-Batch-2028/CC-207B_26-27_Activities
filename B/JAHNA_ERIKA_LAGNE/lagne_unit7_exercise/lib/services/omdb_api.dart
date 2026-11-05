import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/movie.dart';

class OmdbApi {
  static const String _baseUrl = 'www.omdbapi.com';

  // Reads the API key when the app runs.
  static const String _apiKey = String.fromEnvironment('OMDB_KEY');

  bool get hasApiKey => _apiKey.isNotEmpty;

  Future<List<Movie>> searchMovies(String query) async {
    if (!hasApiKey) {
      throw Exception('OMDb API key is missing.');
    }

    final uri = Uri.https(
      _baseUrl,
      '/',
      {
        'apikey': _apiKey,
        's': query,
        'type': 'movie',
      },
    );

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Unable to connect to OMDb.');
    }

    final Map<String, dynamic> data =
        jsonDecode(response.body) as Map<String, dynamic>;

    if (data['Response'] == 'False') {
      throw Exception(data['Error'] ?? 'Movie not found!');
    }

    final List<dynamic> results = data['Search'] ?? [];

    return results
        .whereType<Map<String, dynamic>>()
        .map((json) => Movie.fromJson(json))
        .where((movie) => movie.id.isNotEmpty)
        .toList();
  }

  Future<Map<String, dynamic>> getMovieDetails(String movieId) async {
    if (!hasApiKey) {
      throw Exception('OMDb API key is missing.');
    }

    final uri = Uri.https(
      _baseUrl,
      '/',
      {
        'apikey': _apiKey,
        'i': movieId,
        'plot': 'short',
      },
    );

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Unable to retrieve movie details.');
    }

    final Map<String, dynamic> data =
        jsonDecode(response.body) as Map<String, dynamic>;

    if (data['Response'] == 'False') {
      throw Exception(data['Error'] ?? 'Movie details not found.');
    }

    return data;
  }
}