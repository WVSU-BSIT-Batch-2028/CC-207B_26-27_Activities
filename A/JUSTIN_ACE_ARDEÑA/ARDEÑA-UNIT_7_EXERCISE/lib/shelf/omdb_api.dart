import 'dart:convert';

import 'package:http/http.dart' as http;

import 'api_exception.dart';
import 'config.dart';
import 'http_helper.dart';
import 'movie.dart';
import 'pick.dart';

/// Searches movies on OMDb (needs a key).
class OmdbApi {
  OmdbApi({http.Client? client, this.key = omdbKey})
      : _client = client ?? http.Client();

  final http.Client _client;
  final String key;

  Future<List<Movie>> search(String query) async {
    final uri = Uri.https('www.omdbapi.com', '/', {
      'apikey': key,
      's': query,
      'type': 'movie',
    });
    final body = await fetchBody(_client, uri, name: 'OMDb');
    // OMDb answers 200 even for errors, so the body must be checked too.
    final json = jsonDecode(body) as Map<String, dynamic>;
    if (json['Response'] == 'False') {
      final error = json['Error'] as String? ?? 'OMDb error';
      if (error == 'Movie not found!') return const [];
      throw ApiException(error);
    }
    final results = json['Search'] as List<dynamic>? ?? const [];
    return [
      for (final item in results) Movie.fromJson(item as Map<String, dynamic>),
    ];
  }

  /// Details of one movie by its IMDb id (used by the pick detail screen).
  Future<PickDetail> details(String imdbId) async {
    final uri = Uri.https('www.omdbapi.com', '/', {
      'apikey': key,
      'i': imdbId,
      'plot': 'short',
    });
    final body = await fetchBody(_client, uri, name: 'OMDb');
    final json = jsonDecode(body) as Map<String, dynamic>;
    if (json['Response'] == 'False') {
      throw ApiException(json['Error'] as String? ?? 'OMDb error');
    }
    final poster = json['Poster'] as String?;
    return PickDetail(
      title: json['Title'] as String? ?? '',
      description: json['Plot'] as String? ?? 'No plot yet.',
      imageUrl: (poster == null || poster == 'N/A') ? null : poster,
    );
  }
}

