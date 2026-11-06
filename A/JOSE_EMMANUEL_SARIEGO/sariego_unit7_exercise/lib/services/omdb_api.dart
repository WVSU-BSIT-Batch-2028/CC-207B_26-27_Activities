import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/movie.dart';

class OmdbApi {
  final String apiKey = const String.fromEnvironment('OMDB_KEY');

  Future<List<Movie>> search(String query) async {
    if (apiKey.isEmpty) {
      throw Exception('OMDb API key is missing.');
    }

    final uri = Uri.https('www.omdbapi.com', '/', {
      'apikey': apiKey,
      's': query,
      'type': 'movie',
    });

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Failed to load movies.');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;

    if (data['Response'] == 'False') {
      if (data['Error'] == 'Movie not found!') {
        return [];
      }

      throw Exception(data['Error'] ?? 'Something went wrong.');
    }

    final List<dynamic> results = data['Search'] ?? [];

    return results
        .map((item) => Movie.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<Map<String, dynamic>> getDetails(String imdbId) async {
    if (apiKey.isEmpty) {
      throw Exception('OMDb API key is missing.');
    }

    final uri = Uri.https('www.omdbapi.com', '/', {
      'apikey': apiKey,
      'i': imdbId,
      'plot': 'short',
    });

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Failed to load movie details.');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;

    if (data['Response'] == 'False') {
      throw Exception(data['Error'] ?? 'Movie details not found.');
    }

    return data;
  }
}
