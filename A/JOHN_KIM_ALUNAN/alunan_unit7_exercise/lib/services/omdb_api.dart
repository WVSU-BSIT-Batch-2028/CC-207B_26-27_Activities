import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config.dart';
import '../models/movie.dart';
import 'api_exception.dart';

class OmdbApi {
  OmdbApi({String? key, http.Client? client})
    : _key = key ?? omdbKey,
      _client = client ?? http.Client();

  final String _key;
  final http.Client _client;

  Future<List<Movie>> search(String query) async {
    final json = await _get({'s': query, 'type': 'movie'});
    final results = json['Search'] as List<dynamic>? ?? const [];
    return results
        .whereType<Map<String, dynamic>>()
        .where((item) => item['imdbID'] is String)
        .map(Movie.fromJson)
        .toList();
  }

  Future<MovieDetails> fetchById(String imdbId) async {
    final json = await _get({'i': imdbId, 'plot': 'short'});
    return MovieDetails(
      title: json['Title'] as String? ?? 'Untitled',
      year: json['Year'] as String? ?? '',
      poster: json['Poster'] == 'N/A' ? null : json['Poster'] as String?,
      plot: json['Plot'] as String? ?? 'No summary yet.',
    );
  }

  Future<Map<String, dynamic>> _get(Map<String, String> parameters) async {
    final uri = Uri.https('www.omdbapi.com', '/', {
      'apikey': _key,
      ...parameters,
    });
    try {
      final response = await _client
          .get(uri)
          .timeout(const Duration(seconds: 10));
      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw ApiException('OMDb answered ${response.statusCode}.');
      }
      final decoded = jsonDecode(response.body);
      if (decoded is! Map<String, dynamic>) {
        throw const ApiException('OMDb returned an invalid response.');
      }
      if (decoded['Response'] == 'False') {
        final error = decoded['Error'] as String? ?? 'OMDb error';
        if (error == 'Movie not found!') return const {};
        throw ApiException(error);
      }
      return decoded;
    } on ApiException {
      rethrow;
    } on TimeoutException {
      throw const ApiException('OMDb took too long to answer.');
    } on http.ClientException {
      throw const ApiException('Could not connect to OMDb.');
    } on FormatException {
      throw const ApiException('OMDb returned invalid JSON.');
    }
  }
}
