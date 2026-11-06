import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config.dart';
import '../models/details.dart';
import '../models/movie.dart';
import 'api_exception.dart';

class OmdbApi {
  const OmdbApi();

  Future<Map<String, dynamic>> _get(Map<String, String> query) async {
    if (omdbKey.isEmpty) {
      throw const ApiException(
        'OMDb key is missing. Run the app with --dart-define=OMDB_KEY=your-key',
      );
    }

    final uri = Uri.https('www.omdbapi.com', '/', {
      'apikey': omdbKey,
      ...query,
    });

    final response = await http.get(uri);
    if (response.statusCode != 200) {
      throw ApiException('OMDb error (${response.statusCode}).');
    }

    return jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
  }

  Future<List<Movie>> search(String query) async {
    final json = await _get({'s': query, 'type': 'movie'});

    if (json['Response'] == 'False') {
      final error = json['Error'] as String? ?? 'OMDb error';
      if (error == 'Movie not found!') return const [];
      throw ApiException(error);
    }

    final results = json['Search'] as List<dynamic>;

    return [
      for (final result in results)
        Movie.fromJson(result as Map<String, dynamic>),
    ];
  }

  Future<Details> details(String imdbId) async {
    final json = await _get({'i': imdbId, 'plot': 'short'});

    if (json['Response'] == 'False') {
      throw ApiException(json['Error'] as String? ?? 'OMDb error');
    }

    final poster = json['Poster'] as String?;
    final plot = json['Plot'] as String?;

    return Details(
      title: json['Title'] as String? ?? '',
      summary: plot == null || plot == 'N/A' ? 'No plot yet.' : plot,
      imageUrl: poster == null || poster == 'N/A' ? null : poster,
    );
  }
}
