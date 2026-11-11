import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/api_exception.dart';
import '../models/movie.dart';

class OmdbApi {
  final String apiKey;

  const OmdbApi({required this.apiKey});

  Future<List<Movie>> search(String query) async {
    _requireKey();
    final uri = Uri.https(
      'www.omdbapi.com',
      '/',
      <String, String>{
        'apikey': apiKey,
        's': query,
        'type': 'movie',
      },
    );

    final json = await _getJson(uri);
    if (json['Response'] == 'False') {
      final error = json['Error'] as String? ?? 'OMDb error';
      if (error == 'Movie not found!') return const <Movie>[];
      throw ApiException(error);
    }

    final results = json['Search'];
    if (results is! List) return const <Movie>[];
    return results
        .whereType<Map<String, dynamic>>()
        .map(Movie.fromJson)
        .where((movie) => movie.imdbId.isNotEmpty)
        .toList(growable: false);
  }

  Future<MovieDetails> fetchDetails(String imdbId) async {
    _requireKey();
    final uri = Uri.https(
      'www.omdbapi.com',
      '/',
      <String, String>{
        'apikey': apiKey,
        'i': imdbId,
        'plot': 'short',
      },
    );

    final json = await _getJson(uri);
    if (json['Response'] == 'False') {
      throw ApiException(json['Error'] as String? ?? 'OMDb error');
    }
    return MovieDetails.fromJson(json);
  }

  void _requireKey() {
    if (apiKey.trim().isEmpty) {
      throw const ApiException(
        'OMDb API key is missing. Run the app with --dart-define=OMDB_KEY=your-key.',
      );
    }
  }

  Future<Map<String, dynamic>> _getJson(Uri uri) async {
    final response = await http.get(uri).timeout(const Duration(seconds: 20));
    if (response.statusCode != 200) {
      throw ApiException('OMDb request failed (${response.statusCode}).');
    }

    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      throw const ApiException('OMDb returned an unexpected response.');
    }
    return decoded;
  }
}
