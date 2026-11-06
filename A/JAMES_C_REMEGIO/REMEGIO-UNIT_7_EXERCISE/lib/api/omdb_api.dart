import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/movie.dart';
import '../models/movie_details.dart';
import 'api_exception.dart';
import 'http_json.dart';

/// OMDb search and title lookup. The key is compiled in with `OMDB_KEY`.
class OmdbApi {
  OmdbApi({required this.apiKey, http.Client? client})
      : _client = client ?? http.Client(),
        _ownsClient = client == null;

  final String apiKey;
  final http.Client _client;
  final bool _ownsClient;

  Future<List<Movie>> search(String query) async {
    _requireKey();
    final Uri uri = Uri.https('www.omdbapi.com', '/', {
      'apikey': apiKey,
      's': query.trim(),
      'type': 'movie',
    });
    final Map<String, dynamic> json = await _get(uri);
    return moviesFromSearch(json);
  }

  Future<MovieDetails> fetchById(String imdbId) async {
    _requireKey();
    final String id = imdbId.trim();
    if (id.isEmpty) {
      throw const ApiException('This movie has no IMDb ID.');
    }
    final Uri uri = Uri.https('www.omdbapi.com', '/', {
      'apikey': apiKey,
      'i': id,
      'plot': 'short',
    });
    final Map<String, dynamic> json = await _get(uri);
    return MovieDetails.fromJson(json);
  }

  /// OMDb reports an invalid key as HTTP 401 with `Response: False` in the body.
  /// A missing movie is HTTP 200 with the same shape. Both need the JSON.
  Future<Map<String, dynamic>> _get(Uri uri) async {
    final http.Response response;
    try {
      response = await _client.get(uri).timeout(const Duration(seconds: 10));
    } on TimeoutException {
      throw const ApiException('OMDb took too long to answer. Try again.');
    } on http.ClientException {
      throw const ApiException(
        'No connection. Check your internet and try again.',
      );
    }
    final Object? decoded = _decode(response);
    if (decoded is Map<String, dynamic>) return decoded;
    if (decoded is Map) return Map<String, dynamic>.from(decoded);
    throw const ApiException('OMDb sent a response that is not a JSON object.');
  }

  Object? _decode(http.Response response) {
    if (response.statusCode != 200 && response.statusCode != 401) {
      return decodeBody(response, 'OMDb');
    }
    try {
      return jsonDecode(response.body);
    } on FormatException {
      if (response.statusCode == 200) {
        throw const ApiException(
          'OMDb sent a response that is not valid JSON. Check the URL.',
        );
      }
      throw ApiException('OMDb answered ${response.statusCode}.');
    }
  }

  void _requireKey() {
    if (apiKey.trim().isEmpty) throw const MissingOmdbKey();
  }

  void close() {
    if (_ownsClient) _client.close();
  }
}

/// `Movie not found!` is an empty list. Any other `Response: False` is an error.
/// An invalid key arrives this way on both HTTP 200 and HTTP 401.
List<Movie> moviesFromSearch(Map<String, dynamic> json) {
  if (json['Response'] == 'False') {
    final Object? error = json['Error'];
    final String message = error is String ? error : 'OMDb error';
    if (message == 'Movie not found!') return const <Movie>[];
    throw ApiException(message);
  }
  final Object? search = json['Search'];
  if (search is! List) {
    throw const ApiException('OMDb sent a response the app could not read.');
  }
  final List<Movie> movies = <Movie>[];
  for (final Object? item in search) {
    if (item is! Map) {
      throw const ApiException('OMDb sent a movie the app could not read.');
    }
    try {
      movies.add(Movie.fromJson(Map<String, dynamic>.from(item)));
    } on TypeError {
      throw const ApiException('OMDb sent a movie the app could not read.');
    }
  }
  return movies;
}
