import 'package:http/http.dart' as http;

import 'api_exception.dart';
import 'config.dart';
import 'item_details.dart';
import 'movie.dart';

class OmdbApi {
  OmdbApi({http.Client? client, this.apiKey = omdbKey})
    : _client = client ?? http.Client();

  final http.Client _client;
  final String apiKey;

  static const _who = 'OMDb';

  Future<Map<String, dynamic>> _get(Map<String, String> params) async {
    final uri = Uri.https('www.omdbapi.com', '/', {
      'apikey': apiKey,
      ...params,
    });
    final response = await sendGet(_client, uri);
    // OMDb answers 401 (with a JSON body) for a bad key, and 200 for the rest.
    final code = response.statusCode;
    if (code != 200 && code != 401) {
      throw ApiException(statusMessage(_who, code));
    }
    try {
      return decodeJson(response, _who) as Map<String, dynamic>;
    } on ApiException {
      if (code == 401) {
        throw ApiException(statusMessage(_who, code));
      }
      rethrow;
    }
  }

  Future<List<Movie>> search(String query) async {
    final json = await _get({'s': query, 'type': 'movie'});

    // OMDb says "not found" with status 200, so check the body too.
    if (json['Response'] == 'False') {
      final error = json['Error'] as String? ?? 'OMDb error';
      if (error == 'Movie not found!') return const []; // empty, not an error
      throw ApiException(error); // e.g. "Invalid API key!"
    }

    final results = json['Search'] as List<dynamic>;
    return [
      for (final item in results.cast<Map<String, dynamic>>())
        Movie.fromJson(item),
    ];
  }

  Future<ItemDetails> details(String imdbId) async {
    final json = await _get({'i': imdbId, 'plot': 'short'});

    if (json['Response'] == 'False') {
      throw ApiException(json['Error'] as String? ?? 'OMDb error');
    }

    final plot = json['Plot'];
    return ItemDetails(
      title: json['Title'] as String? ?? 'Untitled',
      summary: plot is String && plot != 'N/A' ? plot : 'No description yet.',
      subtitle: json['Year'] as String?,
      imageUrl: posterOrNull(json['Poster']),
    );
  }
}
