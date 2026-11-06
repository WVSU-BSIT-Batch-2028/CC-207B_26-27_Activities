import 'dart:convert';

import 'package:http/http.dart' as http;

import 'api_exception.dart';

class OmdbApi {
  OmdbApi(this.apiKey);

  final String apiKey;

  Future<List<Map<String, dynamic>>> search(String query) async {
    final uri = Uri.https('www.omdbapi.com', '/', {
      'apikey': apiKey,
      's': query,
      'type': 'movie',
    });

    final response = await http.get(uri);
    if (response.statusCode != 200) {
      throw ApiException('OMDb request failed (${response.statusCode}).');
    }

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    if (body['Response'] == 'False') {
      final message = body['Error'] as String? ?? 'OMDb request failed.';
      if (message == 'Movie not found!') return [];
      throw Exception(message); // For example, an invalid API key.
    }

    return (body['Search'] as List<dynamic>)
        .map((item) => Map<String, dynamic>.from(item as Map))
        .toList();
  }
}
