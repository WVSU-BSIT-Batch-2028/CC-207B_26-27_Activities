import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/book.dart';
import '../models/movie.dart';

const omdbKey = String.fromEnvironment('OMDB_KEY');

class ApiException implements Exception {
  const ApiException(this.message);

  final String message;

  @override
  String toString() => message;
}

Future<http.Response> _get(Uri uri, http.Client? client) =>
    client == null ? http.get(uri) : client.get(uri);

Map<String, dynamic> _decodeObject(String body) {
  final decoded = jsonDecode(body);
  if (decoded is Map<String, dynamic>) return decoded;
  throw const ApiException('The server returned an invalid response.');
}

class OpenLibraryApi {
  const OpenLibraryApi({this.client});

  final http.Client? client;

  Future<List<Book>> search(String query) async {
    final uri = Uri.https('openlibrary.org', '/search.json', {
      'q': query,
      'fields': 'key,title,author_name,first_publish_year,cover_i',
      'limit': '20',
    });
    final response = await _get(uri, client);
    if (response.statusCode != 200) {
      throw ApiException(
        'Open Library request failed (${response.statusCode}).',
      );
    }
    final docs = _decodeObject(response.body)['docs'];
    if (docs is! List) {
      throw const ApiException('Open Library returned no results data.');
    }
    return docs.map((doc) {
      if (doc is! Map<String, dynamic>) {
        throw const ApiException('Open Library returned an invalid book.');
      }
      return Book.fromJson(doc);
    }).toList();
  }

  Future<BookWork> fetchWork(String workId) async {
    final uri = Uri.https('openlibrary.org', '/works/$workId.json');
    final response = await _get(uri, client);
    if (response.statusCode != 200) {
      throw ApiException(
        'Open Library request failed (${response.statusCode}).',
      );
    }
    return BookWork.fromJson(_decodeObject(response.body));
  }
}

class OmdbApi {
  const OmdbApi({this.key = omdbKey, this.client});

  final String key;
  final http.Client? client;

  Future<List<Movie>> search(String query) async {
    _requireKey();
    final uri = Uri.https('www.omdbapi.com', '/', {
      'apikey': key,
      's': query,
      'type': 'movie',
    });
    final response = await _get(uri, client);
    if (response.statusCode != 200) {
      throw ApiException('OMDb request failed (${response.statusCode}).');
    }
    final data = _decodeObject(response.body);
    if (data['Response'] == 'False') {
      final error = data['Error'] as String? ?? 'OMDb request failed.';
      if (error == 'Movie not found!') return const [];
      throw ApiException(error);
    }
    final results = data['Search'];
    if (results is! List) {
      throw const ApiException('OMDb returned no results data.');
    }
    return results.map((result) {
      if (result is! Map<String, dynamic>) {
        throw const ApiException('OMDb returned an invalid movie.');
      }
      return Movie.fromJson(result);
    }).toList();
  }

  Future<Movie> fetchById(String imdbId) async {
    _requireKey();
    final uri = Uri.https('www.omdbapi.com', '/', {
      'apikey': key,
      'i': imdbId,
      'plot': 'short',
    });
    final response = await _get(uri, client);
    if (response.statusCode != 200) {
      throw ApiException('OMDb request failed (${response.statusCode}).');
    }
    final data = _decodeObject(response.body);
    if (data['Response'] == 'False') {
      throw ApiException(data['Error'] as String? ?? 'OMDb request failed.');
    }
    return Movie.fromJson(data);
  }

  void _requireKey() {
    if (key.isEmpty) {
      throw const ApiException(
        'OMDb API key is missing. Run with --dart-define=OMDB_KEY=your-key.',
      );
    }
  }
}
