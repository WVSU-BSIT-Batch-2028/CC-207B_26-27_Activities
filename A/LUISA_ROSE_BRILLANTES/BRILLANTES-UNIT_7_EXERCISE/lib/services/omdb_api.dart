import 'dart:convert';
import 'package:http/http.dart' as http;

class OmdbApi {
  OmdbApi(this.apiKey);

  final String apiKey;

  Future<List<Map<String, dynamic>>> search(String query) async {
    final q = query.trim();
    if (q.isEmpty) return const [];

    final uri = Uri.https('www.omdbapi.com', '/', {
      'apikey': apiKey,
      's': q,
      'type': 'movie',
    });

    final response = await http.get(uri);
    if (response.statusCode != 200) {
      throw Exception('OMDb error: ${response.statusCode}');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    if (json['Response'] == 'False') {
      final error = json['Error'] as String? ?? 'OMDb error';
      if (error == 'Movie not found!') return const [];
      throw Exception(error);
    }

    return (json['Search'] as List<dynamic>? ?? const [])
        .map((e) => e as Map<String, dynamic>)
        .toList();
  }

  Future<Map<String, dynamic>> fetchDetail(String imdbId) async {
    final uri = Uri.https('www.omdbapi.com', '/', {
      'apikey': apiKey,
      'i': imdbId,
      'plot': 'short',
    });

    final response = await http.get(uri);
    if (response.statusCode != 200) {
      throw Exception('OMDb detail error: ${response.statusCode}');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    if (json['Response'] == 'False') {
      throw Exception(json['Error'] as String? ?? 'Movie not found');
    }

    return json;
  }
}