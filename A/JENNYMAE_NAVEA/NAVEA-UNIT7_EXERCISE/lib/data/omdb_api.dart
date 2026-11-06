import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/movie.dart';
import 'api_exception.dart';

const omdbKey = String.fromEnvironment('OMDB_KEY');

class OmdbApi {
  OmdbApi({required this.apiKey, http.Client? client})
    : _client = client ?? http.Client();

  final String apiKey;
  final http.Client _client;

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

  Future<Movie> getDetails(String imdbId) async {
    final json = await _getJson({'i': imdbId, 'plot': 'short'});
    if (json['Response'] == 'False') {
      throw ApiException(json['Error'] as String? ?? 'OMDb error');
    }
    return Movie.fromJson(json);
  }

  Future<Map<String, dynamic>> _getJson(
    Map<String, String> parameters,
  ) async {
    if (apiKey.isEmpty) {
      throw const ApiException(
        'OMDB_KEY is missing. Run the app with --dart-define=OMDB_KEY=your-key.',
      );
    }
    final uri = Uri.https('www.omdbapi.com', '/', {
      'apikey': apiKey,
      ...parameters,
    });
    final response = await _client.get(uri);
    if (response.statusCode != 200) {
      throw ApiException('OMDb answered ${response.statusCode}.');
    }
    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  void close() => _client.close();
}
