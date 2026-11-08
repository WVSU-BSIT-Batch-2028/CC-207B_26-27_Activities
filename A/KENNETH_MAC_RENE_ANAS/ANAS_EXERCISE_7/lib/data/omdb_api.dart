import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/movie.dart';
import 'api_exception.dart';

class OmdbApi {
  OmdbApi(this.client, {required this.apiKey});

  final http.Client client;
  final String apiKey;

  bool get isConfigured => apiKey.isNotEmpty;

  Future<List<Movie>> search(String query) async {
    final json = await _getJson({'s': query, 'type': 'movie'});
    if (json['Response'] == 'False') {
      final error = json['Error'] as String? ?? 'OMDb error';
      if (error == 'Movie not found!') return const [];
      throw ApiException(error);
    }
    final results = json['Search'] as List<dynamic>? ?? const [];
    return results
        .map((item) => Movie.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<Movie> fetchDetails(String imdbId) async {
    final json = await _getJson({'i': imdbId, 'plot': 'short'});
    if (json['Response'] == 'False') {
      throw ApiException(json['Error'] as String? ?? 'OMDb error');
    }
    return Movie.fromJson(json);
  }

  Future<Map<String, dynamic>> _getJson(Map<String, String> parameters) async {
    final uri = Uri.https('www.omdbapi.com', '/', {
      'apikey': apiKey,
      ...parameters,
    });
    final response = await client
        .get(uri)
        .timeout(
          const Duration(seconds: 15),
          onTimeout: () => throw const ApiException(
            'OMDb request timed out. Check your internet connection and retry.',
          ),
        );
    if (response.statusCode < 200 || response.statusCode >= 300) {
      try {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        final error = body['Error'] as String?;
        if (error != null) throw ApiException(error);
      } on FormatException {
        throw ApiException('OMDb returned HTTP ${response.statusCode}.');
      }
      throw ApiException('OMDb returned HTTP ${response.statusCode}.');
    }
    return jsonDecode(response.body) as Map<String, dynamic>;
  }
}
