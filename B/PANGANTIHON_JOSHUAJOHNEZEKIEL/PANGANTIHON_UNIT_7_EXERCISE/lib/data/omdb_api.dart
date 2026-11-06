import 'package:http/http.dart' as http;

import 'api_exception.dart';
import 'movie.dart';

class OmdbApi {
  OmdbApi(this.client, {required this.apiKey});

  final http.Client client;
  final String apiKey;

  Future<List<Movie>> search(String query) async {
    _requireKey();
    final json = await getJson(
      client,
      Uri.https('www.omdbapi.com', '/', {
        'apikey': apiKey,
        's': query,
        'type': 'movie',
      }),
      service: 'OMDb',
    );
    if (json['Response'] == 'False') {
      final error = json['Error'] as String? ?? 'OMDb error';
      if (error == 'Movie not found!') return const [];
      throw ApiException(error);
    }
    final results = json['Search'];
    if (results is! List) {
      throw const ApiException('OMDb returned no movie results.');
    }
    return results
        .whereType<Map<String, dynamic>>()
        .map(Movie.fromJson)
        .toList();
  }

  Future<Movie> getDetails(String imdbId) async {
    _requireKey();
    final json = await getJson(
      client,
      Uri.https('www.omdbapi.com', '/', {
        'apikey': apiKey,
        'i': imdbId,
        'plot': 'short',
      }),
      service: 'OMDb',
    );
    if (json['Response'] == 'False') {
      throw ApiException(json['Error'] as String? ?? 'OMDb error');
    }
    return Movie.fromJson(json);
  }

  void _requireKey() {
    if (apiKey.isEmpty) {
      throw const ApiException('Add your OMDB_KEY to the app launch settings.');
    }
  }
}
