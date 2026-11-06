import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/movie.dart';

const omdbKey = String.fromEnvironment('OMDB_KEY');

class ApiException implements Exception {
  final String message;

  const ApiException(this.message);

  @override
  String toString() => message;
}

class OmdbApi {
  Future<List<Movie>> search(String query) async {
    if (omdbKey.isEmpty) {
      throw const ApiException(
        'OMDb API key is missing. Run the app with --dart-define=OMDB_KEY=your-key',
      );
    }

    final uri = Uri.https('www.omdbapi.com', '/', {
      'apikey': omdbKey,
      's': query,
      'type': 'movie',
    });

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw ApiException(
        'OMDb returned ${response.statusCode}: ${response.body}',
      );
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;

    if (json['Response'] == 'False') {
      final error = json['Error'] as String? ?? 'OMDb error';

      if (error == 'Movie not found!') {
        return const [];
      }

      throw ApiException(error);
    }

    final results = json['Search'] as List<dynamic>? ?? [];

    return results
        .map((item) => Movie.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
