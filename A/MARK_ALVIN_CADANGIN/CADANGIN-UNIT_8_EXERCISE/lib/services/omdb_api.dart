import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/movie.dart';
import 'api_exception.dart';

class MovieDetail {
  final String title;
  final String year;
  final String? posterUrl;
  final String plot;
  final String? director;
  final String? genre;
  final String? rating;

  const MovieDetail({
    required this.title,
    required this.year,
    this.posterUrl,
    required this.plot,
    this.director,
    this.genre,
    this.rating,
  });
}

class OmdbApi {
  final String apiKey;
  final http.Client client;

  OmdbApi({required this.apiKey, http.Client? client})
      : client = client ?? http.Client();

  Future<List<Movie>> search(String query) async {
    if (apiKey.isEmpty) {
      throw const ApiException('OMDb API key is missing.');
    }

    final uri = Uri.https('www.omdbapi.com', '/', {
      'apikey': apiKey,
      's': query,
      'type': 'movie',
    });

    final response = await client.get(uri);
    if (response.statusCode != 200) {
      throw ApiException('OMDb server error (${response.statusCode})');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    if (json['Response'] == 'False') {
      final error = json['Error'] as String? ?? 'OMDb error';
      if (error == 'Movie not found!') return const [];
      throw ApiException(error);
    }

    final searchList = json['Search'] as List<dynamic>? ?? [];
    return searchList
        .map((m) => Movie.fromJson(m as Map<String, dynamic>))
        .toList();
  }

  Future<MovieDetail> getDetails(String imdbId) async {
    if (apiKey.isEmpty) {
      throw const ApiException('OMDb API key is missing.');
    }

    final uri = Uri.https('www.omdbapi.com', '/', {
      'apikey': apiKey,
      'i': imdbId,
      'plot': 'short',
    });

    final response = await client.get(uri);
    if (response.statusCode != 200) {
      throw ApiException('OMDb server error (${response.statusCode})');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    if (json['Response'] == 'False') {
      throw ApiException(json['Error'] as String? ?? 'Movie not found');
    }

    final poster = json['Poster'] as String?;
    final posterUrl = (poster != null && poster != 'N/A') ? poster : null;

    return MovieDetail(
      title: json['Title'] as String? ?? 'Untitled',
      year: json['Year'] as String? ?? '',
      posterUrl: posterUrl,
      plot: json['Plot'] as String? ?? 'No plot available.',
      director: json['Director'] as String?,
      genre: json['Genre'] as String?,
      rating: json['imdbRating'] as String?,
    );
  }
}

