import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiException implements Exception {
  final String message;
  const ApiException(this.message);
  @override
  String toString() => message;
}

Future<Map<String, dynamic>> getJson(
  http.Client client,
  Uri uri, {
  Map<String, String>? headers,
}) async {
  try {
    final response = await client
        .get(uri, headers: headers)
        .timeout(const Duration(seconds: 20));
    if (response.statusCode != 200) {
      throw ApiException(
        'Request failed (${response.statusCode}). Check the service settings and try again.',
      );
    }
    final data = jsonDecode(response.body);
    if (data is! Map<String, dynamic>) throw const FormatException();
    return data;
  } on TimeoutException {
    throw const ApiException('The request took too long. Please try again.');
  } on http.ClientException {
    throw const ApiException(
      'Unable to connect. Check your internet connection and try again.',
    );
  } on FormatException {
    throw const ApiException(
      'The service returned unreadable data. Please try again.',
    );
  }
}

String? imageUrl(dynamic value) {
  if (value is! String || value == 'N/A') return null;
  final uri = Uri.tryParse(value);
  return uri != null && uri.scheme == 'https' && uri.host.isNotEmpty
      ? value
      : null;
}

class Book {
  final String workId, title;
  final List<String> authors;
  final int? year, coverId;
  const Book({
    required this.workId,
    required this.title,
    this.authors = const [],
    this.year,
    this.coverId,
  });
  factory Book.fromJson(Map<String, dynamic> json) => Book(
    workId: (json['key'] as String).split('/').last,
    title: json['title'] as String,
    authors: [...?(json['author_name'] as List<dynamic>?)?.cast<String>()],
    year: json['first_publish_year'] as int?,
    coverId: json['cover_i'] as int?,
  );
  String? get cover => coverId == null
      ? null
      : 'https://covers.openlibrary.org/b/id/$coverId-M.jpg';
}

class Movie {
  final String id, title, year;
  final String? poster;
  const Movie({
    required this.id,
    required this.title,
    required this.year,
    this.poster,
  });
  factory Movie.fromJson(Map<String, dynamic> json) => Movie(
    id: json['imdbID'] as String,
    title: json['Title'] as String,
    year: json['Year'] as String? ?? 'Year unknown',
    poster: imageUrl(json['Poster']),
  );
}

class ShelfDetail {
  final String title, summary;
  final String? image, year;
  const ShelfDetail({
    required this.title,
    required this.summary,
    this.image,
    this.year,
  });
}

class OpenLibraryApi {
  final http.Client client;
  OpenLibraryApi(this.client);
  Future<List<Book>> search(String query) async {
    final json = await getJson(
      client,
      Uri.https('openlibrary.org', '/search.json', {
        'q': query.trim(),
        'fields': 'key,title,author_name,first_publish_year,cover_i',
        'limit': '20',
      }),
    );
    return (json['docs'] as List<dynamic>)
        .map((e) => Book.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<ShelfDetail> details(String id) async {
    if (!RegExp(r'^OL\d+W$').hasMatch(id)) {
      throw const ApiException(
        'This pick needs an Open Library work ID, such as OL27482W.',
      );
    }
    final json = await getJson(
      client,
      Uri.https('openlibrary.org', '/works/$id.json'),
    );
    final description = switch (json['description']) {
      final String text => text,
      {'value': final String text} => text,
      _ => 'No description yet.',
    };
    final covers = (json['covers'] as List<dynamic>? ?? [])
        .whereType<int>()
        .where((id) => id > 0);
    return ShelfDetail(
      title: json['title'] as String? ?? 'Untitled book',
      summary: description,
      year: json['first_publish_date'] as String?,
      image: covers.isEmpty
          ? null
          : 'https://covers.openlibrary.org/b/id/${covers.first}-L.jpg',
    );
  }
}

class OmdbApi {
  final http.Client client;
  final String key;
  OmdbApi(this.client, {required this.key});
  Future<Map<String, dynamic>> _get(Map<String, String> query) {
    if (key.isEmpty) {
      throw const ApiException(
        'Add OMDB_KEY to cms.json and restart with --dart-define-from-file=cms.json.',
      );
    }
    return getJson(
      client,
      Uri.https('www.omdbapi.com', '/', {'apikey': key, ...query}),
    );
  }

  Future<List<Movie>> search(String query) async {
    final json = await _get({'s': query.trim(), 'type': 'movie'});
    if (json['Response'] == 'False') {
      final error = json['Error'] as String? ?? 'OMDb error';
      if (error == 'Movie not found!') return const [];
      throw ApiException(error);
    }
    return (json['Search'] as List<dynamic>)
        .map((e) => Movie.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<ShelfDetail> details(String id) async {
    if (!RegExp(r'^tt\d+$').hasMatch(id)) {
      throw const ApiException(
        'This pick needs an IMDb ID, such as tt0816692.',
      );
    }
    final json = await _get({'i': id, 'plot': 'short'});
    if (json['Response'] == 'False') {
      throw ApiException(json['Error'] as String? ?? 'Movie unavailable.');
    }
    return ShelfDetail(
      title: json['Title'] as String? ?? 'Untitled movie',
      summary: json['Plot'] == 'N/A'
          ? 'No summary yet.'
          : json['Plot'] as String? ?? 'No summary yet.',
      image: imageUrl(json['Poster']),
      year: json['Year'] as String?,
    );
  }
}

class Pick {
  final String title, kind, externalId, note;
  const Pick({
    required this.title,
    required this.kind,
    required this.externalId,
    required this.note,
  });
  factory Pick.fromJson(Map<String, dynamic> fields) {
    final kind = fields['kind'];
    if (kind != 'book' && kind != 'movie') {
      throw const ApiException(
        'A CMS pick has an invalid kind. Use book or movie.',
      );
    }
    final id = fields['externalId'];
    if (id is! String || id.trim().isEmpty) {
      throw const ApiException('A CMS pick is missing its externalId.');
    }
    return Pick(
      title: fields['title'] as String? ?? 'Untitled pick',
      kind: kind as String,
      externalId: id.trim(),
      note: fields['note'] as String? ?? '',
    );
  }
}

abstract interface class PickSource {
  Future<List<Pick>> fetchPicks();
}

class ContentfulPickSource implements PickSource {
  final http.Client client;
  final String spaceId, token, environment;
  ContentfulPickSource(
    this.client, {
    required this.spaceId,
    required this.token,
    this.environment = 'master',
  });
  @override
  Future<List<Pick>> fetchPicks() async {
    if (spaceId.isEmpty || token.isEmpty) {
      throw const ApiException(
        'Connect Contentful with CMS_SPACE and CMS_TOKEN in cms.json, then restart using --dart-define-from-file=cms.json.',
      );
    }
    final picks = <Pick>[];
    int total;
    do {
      final json = await getJson(
        client,
        Uri.https(
          'cdn.contentful.com',
          '/spaces/$spaceId/environments/$environment/entries',
          {
            'content_type': 'pick',
            'order': 'sys.createdAt',
            'limit': '100',
            'skip': '${picks.length}',
          },
        ),
        headers: {'Authorization': 'Bearer $token'},
      );
      final items = json['items'] as List<dynamic>;
      total = json['total'] as int? ?? items.length;
      picks.addAll(
        items.map(
          (item) => Pick.fromJson(
            (item as Map<String, dynamic>)['fields'] as Map<String, dynamic>,
          ),
        ),
      );
      if (items.isEmpty) break;
    } while (picks.length < total);
    return picks;
  }
}
