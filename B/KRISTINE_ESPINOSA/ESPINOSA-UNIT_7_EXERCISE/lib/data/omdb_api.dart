import 'package:http/http.dart' as http;

import '../models/movie.dart';
import '../models/pick.dart';
import 'api_exception.dart';

class OmdbApi {
  OmdbApi(this.client, {required this.apiKey});

  final http.Client client;
  final String apiKey;

  Future<Map<String, dynamic>> _get(Map<String, String> query) async {
    final uri = Uri.https('www.omdbapi.com', '/', {'apikey': apiKey, ...query});
    final json =
        await getJson(client, uri, name: 'OMDb') as Map<String, dynamic>;
    if (json['Response'] == 'False') {
      final error = json['Error'] as String? ?? 'OMDb error';
      throw ApiException(error);
    }
    return json;
  }

  Future<List<Movie>> search(String query) async {
    try {
      final json = await _get({'s': query, 'type': 'movie'});
      final results = json['Search'] as List<dynamic>? ?? const [];
      return [
        for (final item in results.cast<Map<String, dynamic>>())
          Movie.fromJson(item),
      ];
    } on ApiException catch (e) {
      if (e.message == 'Movie not found!') return const [];
      rethrow;
    }
  }

  Future<PickDetails> details(String imdbId) async {
    final json = await _get({'i': imdbId, 'plot': 'short'});
    final poster = json['Poster'] as String?;
    final plot = json['Plot'] as String?;
    return PickDetails(
      title: json['Title'] as String? ?? 'Untitled',
      subtitle: json['Year'] as String? ?? '',
      summary: (plot == null || plot == 'N/A') ? 'No summary yet.' : plot,
      imageUrl: (poster == null || poster == 'N/A') ? null : poster,
    );
  }
}
