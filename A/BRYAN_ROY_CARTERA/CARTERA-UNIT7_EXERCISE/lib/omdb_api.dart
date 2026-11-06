import 'dart:convert';
import 'package:http/http.dart' as http;
import 'movie.dart';

const String omdbKey = String.fromEnvironment('OMDB_KEY');

class ApiException implements Exception {
  final String message;

  ApiException(this.message);

  @override
  String toString() => message;
}

class OmdbApi {
  Future<List<Movie>> search(String query) async {
    if (omdbKey.isEmpty) {
      throw ApiException(
        'OMDb API key is missing. Please provide OMDB_KEY.',
      );
    }

    final uri = Uri.https(
      'www.omdbapi.com',
      '/',
      {
        'apikey': omdbKey,
        's': query,
        'type': 'movie',
      },
    );

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw ApiException(
        'OMDb error: ${response.statusCode}',
      );
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;

    if (data['Response'] == 'False') {
      final error = data['Error']?.toString() ?? 'Unknown error';

      if (error == 'Movie not found!') {
        return [];
      }

      throw ApiException(error);
    }

    final results = data['Search'] as List<dynamic>? ?? [];

    return results
        .where((item) => item is Map<String, dynamic>)
        .map(
          (item) => Movie.fromJson(
            item as Map<String, dynamic>,
          ),
        )
        .toList();
  }
}