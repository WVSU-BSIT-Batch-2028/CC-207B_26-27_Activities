import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie.dart';

import '../models/movie_details.dart';

class OmdbApi {
  final String _apiKey = const String.fromEnvironment('OMDB_KEY');

  Future<List<Movie>> search(String query) async {
    if (_apiKey.isEmpty) {
      throw Exception('OMDb API key is missing.');
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
      throw Exception('Failed to load movies: ${response.statusCode}');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;

    if (json['Response'] == 'False') {
      if (json['Error'] == 'Movie not found!') {
        return [];
      }

      throw Exception(json['Error'] ?? 'Something went wrong.');
    }

    final results = json['Search'] as List<dynamic>;

    return results
        .map((item) => Movie.fromJson(item as Map<String, dynamic>))
        .toList();
  }
    
  Future<MovieDetails> getMovieDetails(String imdbId) async {
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
        'Failed to load movie details: ${response.statusCode}',
      );
    }

    final json = jsonDecode(response.body)
        as Map<String, dynamic>;

    if (json['Response'] == 'False') {
      throw Exception(
        json['Error'] ?? 'Something went wrong.',
      );
    }

    return MovieDetails.fromJson(json);
  }

}