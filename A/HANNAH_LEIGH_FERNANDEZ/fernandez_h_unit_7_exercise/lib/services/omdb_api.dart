import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/movie.dart';
import 'api_exception.dart';

class OmdbApi {
  final String apiKey;

  OmdbApi({required this.apiKey});

  Future<List<Movie>> search(String query) async {
    final url = Uri.https('www.omdbapi.com', '/', {
      'apikey': apiKey,
      's': query,
      'type': 'movie',
    });

    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw ApiException('HTTP error: ${response.statusCode}');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    if (json['Response'] == 'False') {
      final error = json['Error'] as String? ?? 'OMDb error';
      if (error == 'Movie not found!') return const []; // empty, not an error
      throw ApiException(error); // e.g. "Invalid API key!"
    }

    final results = json['Search'] as List<dynamic>? ?? [];

    return results
        .map((item) => Movie.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
