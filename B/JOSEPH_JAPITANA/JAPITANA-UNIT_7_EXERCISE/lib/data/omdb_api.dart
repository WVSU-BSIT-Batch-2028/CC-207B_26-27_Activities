import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config.dart';
import '../models/movie.dart';
import '../models/pick_details.dart';
import 'api_exception.dart';

class OmdbApi {
  OmdbApi({http.Client? client}) : client = client ?? http.Client();

  final http.Client client;

  Future<Map<String, dynamic>> _getJson(Map<String, String> params) async {
    final uri = Uri.https('www.omdbapi.com', '/', {
      'apikey': omdbKey,
      ...params,
    });

    final http.Response response;
    try {
      response = await client.get(uri).timeout(const Duration(seconds: 10));
    } on TimeoutException {
      throw const ApiException('OMDb took too long. Try again.');
    } on http.ClientException {
      throw const ApiException(
        'No connection. Check your internet and try again.',
      );
    }

    if (response.statusCode == 401) {
      throw const ApiException('The OMDb key was rejected. Check keys.json.');
    }
    if (response.statusCode != 200) {
      throw ApiException('OMDb answered ${response.statusCode}.');
    }
    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  Future<List<Movie>> search(String query) async {
    final json = await _getJson({'s': query, 'type': 'movie'});

    // OMDb answers 200 even for "not found", so check the Response field.
    if (json['Response'] == 'False') {
      final error = json['Error'] as String?;
      if (error == 'Movie not found!') return const [];
      if (error == 'Too many results.') {
        throw const ApiException('Try a more specific search.');
      }
      throw ApiException(error ?? 'OMDb could not answer.');
    }

    final results = (json['Search'] as List<dynamic>?) ?? const [];
    return [
      for (final item in results) Movie.fromJson(item as Map<String, dynamic>),
    ];
  }

  Future<PickDetails> fetchDetails(String imdbId) async {
    final json = await _getJson({'i': imdbId, 'plot': 'short'});

    if (json['Response'] == 'False') {
      throw ApiException(json['Error'] as String? ?? 'OMDb could not answer.');
    }

    // OMDb sends the text "N/A" for anything it doesn't know.
    String? clean(Object? value) =>
        (value is String && value != 'N/A') ? value : null;

    final subtitle = [clean(json['Year']), clean(json['Genre'])]
        .whereType<String>()
        .join(' · ');

    return PickDetails(
      title: clean(json['Title']) ?? 'Untitled',
      subtitle: subtitle.isEmpty ? null : subtitle,
      description: clean(json['Plot']),
      imageUrl: clean(json['Poster']),
    );
  }
}