import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/movie.dart';
import 'api_exception.dart';

const omdbKey = String.fromEnvironment('OMDB_KEY');

class OmdbApi {
  Future<Map<String, dynamic>> _get(Map<String, String> params) async {
    final uri = Uri.https('www.omdbapi.com', '/', {
      'apikey': omdbKey,
      ...params,
    });
    final response = await http.get(uri);
    if (response.statusCode != 200) {
      throw ApiException('OMDb error (${response.statusCode}).');
    }
    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  Future<List<Movie>> search(String query) async {
    final json = await _get({'s': query, 'type': 'movie'});
    // OMDb says "not found" with status 200, so check the body too.
    if (json['Response'] == 'False') {
      final error = json['Error'] as String? ?? 'OMDb error';
      if (error == 'Movie not found!') return const []; // empty, not an error
      throw ApiException(error); // e.g. "Invalid API key!"
    }
    final list = (json['Search'] as List<dynamic>?) ?? const [];
    return list.map((m) => Movie.fromJson(m as Map<String, dynamic>)).toList();
  }

  /// Details of one movie, e.g. imdbId = "tt0816692".
  Future<Map<String, dynamic>> details(String imdbId) async {
    final json = await _get({'i': imdbId, 'plot': 'short'});
    if (json['Response'] == 'False') {
      throw ApiException(json['Error'] as String? ?? 'OMDb error');
    }
    return json;
  }
}
