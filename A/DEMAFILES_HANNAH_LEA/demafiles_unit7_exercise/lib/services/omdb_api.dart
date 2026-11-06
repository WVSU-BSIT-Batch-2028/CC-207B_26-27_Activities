import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie.dart';
import '../models/pick.dart';

const omdbKey = String.fromEnvironment('OMDB_KEY');

class OmdbApi {
  Future<List<Movie>> search(String query) async {
    final uri = Uri.https('www.omdbapi.com', '/', {
      'apikey': omdbKey,
      's': query,
      'type': 'movie',
    });
    final response = await http.get(uri);
    if (response.statusCode != 200) {
      throw ApiException('OMDb error (${response.statusCode})');
    }
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    if (json['Response'] == 'False') {
      final error = json['Error'] as String? ?? 'OMDb error';
      if (error == 'Movie not found!') return const []; // empty, not an error
      throw ApiException(error); // e.g. "Invalid API key!"
    }
    final results = (json['Search'] as List<dynamic>?) ?? [];
    return results
        .map((m) => Movie.fromJson(m as Map<String, dynamic>))
        .toList();
  }

  Future<MediaDetails> fetchDetails(String imdbId) async {
    final uri = Uri.https('www.omdbapi.com', '/', {
      'apikey': omdbKey,
      'i': imdbId,
      'plot': 'short',
    });
    final response = await http.get(uri);
    if (response.statusCode != 200) {
      throw ApiException('OMDb error (${response.statusCode})');
    }
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    if (json['Response'] == 'False') {
      throw ApiException(json['Error'] as String? ?? 'OMDb error');
    }
    final poster = json['Poster'] as String?;
    final plot = json['Plot'] as String?;
    return MediaDetails(
      title: json['Title'] as String? ?? 'Unknown title',
      imageUrl: (poster == null || poster == 'N/A') ? null : poster,
      year: json['Year'] as String?,
      summary: (plot == null || plot == 'N/A') ? 'No description yet.' : plot,
    );
  }
}