import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/movie.dart';
import '../models/pick_details.dart';
import 'open_library_api.dart' show ApiException;

class OmdbApi {
  OmdbApi(this.apiKey, {http.Client? client})
      : client = client ?? http.Client();

  final String apiKey;
  final http.Client client;

  Future<Map<String, dynamic>> _getJson(Map<String, String> params) async {
    final uri = Uri.https('www.omdbapi.com', '/', {'apikey': apiKey, ...params});

    final http.Response response;
    try {
      response = await client.get(uri).timeout(const Duration(seconds: 10));
    } on TimeoutException {
      throw const ApiException('OMDb took too long. Try again.');
    } on http.ClientException {
      throw const ApiException('No connection. Check your internet.');
    }
    if (response.statusCode != 200) {
      throw ApiException('OMDb answered ${response.statusCode}.');
    }
    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  Future<List<Movie>> search(String query) async {
    final json = await _getJson({'s': query, 'type': 'movie'});

    // OMDb says "not found" with status 200, so check the body too.
    if (json['Response'] == 'False') {
      final error = json['Error'] as String? ?? 'OMDb error';
      if (error == 'Movie not found!') return const []; // empty, not an error
      throw ApiException(error); // e.g. "Invalid API key!"
    }

    final items = json['Search'] as List<dynamic>? ?? const [];
    return [
      for (final item in items) Movie.fromJson(item as Map<String, dynamic>),
    ];
  }

  /// Details of one movie by its IMDb ID, e.g. tt0816692.
  Future<PickDetails> details(String imdbId) async {
    final json = await _getJson({'i': imdbId, 'plot': 'short'});
    if (json['Response'] == 'False') {
      throw ApiException(json['Error'] as String? ?? 'OMDb error');
    }
    final poster = json['Poster'] as String?;
    return PickDetails(
      title: json['Title'] as String? ?? '',
      summary: json['Plot'] as String? ?? 'No description yet.',
      year: json['Year'] as String?,
      imageUrl: (poster == null || poster == 'N/A') ? null : poster,
    );
  }
}