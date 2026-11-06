import 'dart:convert';

import 'package:http/http.dart' as http;

import 'config.dart';
import 'models.dart';

class ApiException implements Exception {
  final String message;

  ApiException(this.message);

  @override
  String toString() => message;
}

Future<Object?> getJson(Uri uri, {Map<String, String>? headers}) async {
  final response = await http.get(uri, headers: headers);
  if (response.statusCode != 200) {
    throw ApiException('Server answered with ${response.statusCode}');
  }
  return jsonDecode(response.body);
}

class OpenLibraryApi {
  Future<List<Book>> search(String query) async {
    final uri = Uri.https('openlibrary.org', '/search.json', {
      'q': query,
      'fields': 'key,title,author_name,first_publish_year,cover_i',
      'limit': '20',
    });
    final json = await getJson(uri) as Map<String, dynamic>;
    final docs = json['docs'] as List<dynamic>? ?? [];
    return [for (final doc in docs) Book.fromJson(doc as Map<String, dynamic>)];
  }

  Future<ItemDetails> details(String workId) async {
    final uri = Uri.https('openlibrary.org', '/works/$workId.json');
    final json = await getJson(uri) as Map<String, dynamic>;

    final description = switch (json['description']) {
      final String text => text,
      {'value': final String text} => text,
      _ => 'No description yet.',
    };

    final covers = (json['covers'] as List<dynamic>?)?.cast<int>() ?? [];
    final coverId = covers.where((id) => id > 0).firstOrNull;

    return ItemDetails(
      title: json['title'] as String? ?? 'Untitled',
      imageUrl: coverId == null
          ? null
          : 'https://covers.openlibrary.org/b/id/$coverId-L.jpg',
      summary: description,
    );
  }
}

class OmdbApi {
  Future<Map<String, dynamic>> _call(Map<String, String> params) async {
    final uri = Uri.https('www.omdbapi.com', '/', {
      'apikey': omdbKey,
      ...params,
    });
    final json = await getJson(uri) as Map<String, dynamic>;

    if (json['Response'] == 'False') {
      final error = json['Error'] as String? ?? 'OMDb error';
      if (error == 'Movie not found!') return {'Search': <dynamic>[]};
      throw ApiException(error);
    }
    return json;
  }

  Future<List<Movie>> search(String query) async {
    final json = await _call({'s': query, 'type': 'movie'});
    final list = json['Search'] as List<dynamic>? ?? [];
    return [for (final m in list) Movie.fromJson(m as Map<String, dynamic>)];
  }

  Future<ItemDetails> details(String imdbId) async {
    final json = await _call({'i': imdbId, 'plot': 'short'});
    final poster = json['Poster'] as String?;
    return ItemDetails(
      title: json['Title'] as String? ?? 'Untitled',
      imageUrl: (poster == null || poster == 'N/A') ? null : poster,
      summary: json['Plot'] as String? ?? 'No plot yet.',
    );
  }
}

abstract class PickSource {
  Future<List<Pick>> fetchPicks();
}

class ContentfulPickSource implements PickSource {
  @override
  Future<List<Pick>> fetchPicks() async {
    final uri = Uri.https(
      'cdn.contentful.com',
      '/spaces/$cfSpace/environments/$cfEnvironment/entries',
      {'content_type': cfContentType},
    );
    final json = await getJson(
      uri,
      headers: {'Authorization': 'Bearer $cfToken'},
    ) as Map<String, dynamic>;
    final items = json['items'] as List<dynamic>? ?? [];
    return [
      for (final item in items) Pick.fromJson(item as Map<String, dynamic>),
    ];
  }
}
