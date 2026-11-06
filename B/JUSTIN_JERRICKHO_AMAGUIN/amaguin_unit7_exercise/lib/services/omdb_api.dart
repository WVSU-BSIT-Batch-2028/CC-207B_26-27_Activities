import 'package:http/http.dart' as http;

import '../models/movie.dart';
import '../models/shelf_detail.dart';
import 'http_json.dart';
import 'api_exception.dart';

class OmdbApi {
  OmdbApi({required this.key, http.Client? client})
    : _client = client ?? http.Client();

  final String key;
  final http.Client _client;

  Future<Map<String, dynamic>> _request(Map<String, String> parameters) async {
    if (key.trim().isEmpty) {
      throw const ApiException('Add OMDB_KEY to cms.json and restart the app.');
    }
    return getJson(
      _client,
      Uri.https('www.omdbapi.com', '/', {'apikey': key, ...parameters}),
    );
  }

  Future<List<Movie>> search(String query) async {
    final json = await _request({'s': query.trim(), 'type': 'movie'});
    if (json['Response'] == 'False') {
      final error = json['Error'] as String? ?? 'OMDb error';
      if (error == 'Movie not found!') return const [];
      throw ApiException(error);
    }
    final results = json['Search'];
    if (results is! List) {
      throw const ApiException('OMDb returned an unexpected search response.');
    }
    return results
        .map((item) => Movie.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<ShelfDetail> details(String imdbId) async {
    if (!RegExp(r'^tt\d+$').hasMatch(imdbId)) {
      throw const ApiException('Invalid IMDb ID. Copy the ID from Movies.');
    }
    final json = await _request({'i': imdbId, 'plot': 'short'});
    if (json['Response'] == 'False') {
      throw ApiException(json['Error'] as String? ?? 'OMDb error');
    }
    final plot = json['Plot'] as String?;
    return ShelfDetail(
      title: json['Title'] as String? ?? 'Untitled movie',
      year: json['Year'] as String?,
      imageUrl: posterUrlFromJson(json['Poster']),
      summary: plot == null || plot.isEmpty || plot == 'N/A'
          ? 'No summary available.'
          : plot,
    );
  }

  void close() => _client.close();
}
