import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/movie.dart';
import 'api_exception.dart';

class OmdbApi {
  OmdbApi(this.client, {required this.apiKey});

  final http.Client client;
  final String apiKey;

  Future<List<Movie>> search(String query) async {
    if (apiKey.trim().isEmpty) {
      throw const ApiException('Add your OMDb API key to search for movies.');
    }
    final json = await _getJson({'s': query, 'type': 'movie'});
    if (json['Response'] == 'False') {
      final error = json['Error'] as String? ?? 'OMDb error';
      if (error == 'Movie not found!') return const [];
      throw ApiException(error);
    }
    final results = json['Search'] as List<dynamic>? ?? const [];
    return results
        .whereType<Map<String, dynamic>>()
        .map(Movie.fromJson)
        .where((movie) => movie.imdbId.isNotEmpty)
        .toList();
  }

  Future<MovieDetails> fetchDetails(String imdbId) async {
    if (apiKey.trim().isEmpty) {
      throw const ApiException('Add your OMDb API key to view movie details.');
    }
    final json = await _getJson({'i': imdbId, 'plot': 'short'});
    if (json['Response'] == 'False') {
      throw ApiException(json['Error'] as String? ?? 'OMDb error');
    }
    final poster = json['Poster'] as String?;
    return MovieDetails(
      title: json['Title'] as String? ?? '',
      year: json['Year'] as String? ?? '',
      summary: json['Plot'] as String? ?? 'No plot summary available.',
      posterUrl: poster == null || poster == 'N/A' ? null : poster,
    );
  }

  Future<Map<String, dynamic>> _getJson(Map<String, String> parameters) async {
    final uri = Uri.https('www.omdbapi.com', '/', {
      'apikey': apiKey,
      ...parameters,
    });
    final http.Response response;
    try {
      response = await client.get(uri).timeout(const Duration(seconds: 15));
    } on Exception {
      throw const ApiException('Could not connect to OMDb. Try again.');
    }
    if (response.statusCode != 200) {
      throw ApiException(
        'OMDb answered ${response.statusCode}. Try again later.',
      );
    }
    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      throw const ApiException('OMDb returned an invalid response.');
    }
    return decoded;
  }
}
