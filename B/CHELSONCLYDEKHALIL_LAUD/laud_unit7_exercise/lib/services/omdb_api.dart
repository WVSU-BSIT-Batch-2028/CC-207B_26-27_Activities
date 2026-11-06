import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models.dart';

class ApiException implements Exception {
  final String message;
  ApiException(this.message);

  @override
  String toString() => message;
}

class OmdbApi {
  final String apiKey;
  final http.Client client;

  OmdbApi({required this.apiKey, http.Client? client}) : client = client ?? http.Client();

  Future<List<Movie>> search(String query) async {
    if (apiKey.isEmpty) {
      throw ApiException('OMDb API Key is missing');
    }

    final uri = Uri.https('www.omdbapi.com', '/', {
      'apikey': apiKey,
      's': query,
      'type': 'movie',
    });

    final response = await client.get(uri);
    final json = jsonDecode(response.body) as Map<String, dynamic>;

    if (json['Response'] == 'False') {
      final error = json['Error'] as String? ?? 'OMDb error';
      if (error == 'Movie not found!') return const [];
      throw ApiException(error);
    }

    final list = json['Search'] as List<dynamic>;
    return list.map((item) => Movie.fromJson(item as Map<String, dynamic>)).toList();
  }

  Future<Map<String, dynamic>> fetchDetails(String imdbId) async {
    final uri = Uri.https('www.omdbapi.com', '/', {
      'apikey': apiKey,
      'i': imdbId,
      'plot': 'short',
    });

    final response = await client.get(uri);
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    if (json['Response'] == 'False') {
      throw ApiException(json['Error'] as String? ?? 'Failed to fetch details');
    }
    return json;
  }
}