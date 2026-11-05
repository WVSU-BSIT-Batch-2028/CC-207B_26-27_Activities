// Unit 7 Exercise: API models, requests, and the Contentful adapter.
import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

const omdbKey = String.fromEnvironment('OMDB_KEY');
const shelfCms = String.fromEnvironment('CMS', defaultValue: 'contentful');
const shelfSpace = String.fromEnvironment('CMS_SPACE');
const shelfToken = String.fromEnvironment('CMS_TOKEN');

class ApiException implements Exception {
  const ApiException(this.message);
  final String message;

  @override
  String toString() => message;
}

Future<Map<String, dynamic>> readShelfJson(
  http.Client client,
  Uri uri, {
  Map<String, String> headers = const {},
}) async {
  final http.Response response;
  try {
    response = await client
        .get(uri, headers: headers)
        .timeout(const Duration(seconds: 15));
  } on TimeoutException {
    throw const ApiException('The request timed out. Please try again.');
  } on http.ClientException {
    throw const ApiException(
      'Could not connect. Check your internet and retry.',
    );
  }

  if (response.statusCode != 200) {
    throw ApiException(switch (response.statusCode) {
      401 || 403 => 'Access refused. Check the API key and read permissions.',
      404 => 'Not found. Check the URL, IDs, and CMS environment.',
      429 => 'Too many requests. Wait a moment and try again.',
      >= 500 => 'The service is having problems. Please try again later.',
      final code => 'The service answered HTTP $code.',
    });
  }

  try {
    return jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
  } on FormatException {
    throw const ApiException('The service returned invalid JSON.');
  } on TypeError {
    throw const ApiException('The service returned an unexpected JSON format.');
  }
}

String? posterUrl(Object? value) {
  if (value is! String || value.isEmpty || value == 'N/A') return null;
  return value;
}

String? coverUrl(int? id) => id == null || id <= 0
    ? null
    : 'https://covers.openlibrary.org/b/id/$id-M.jpg?default=false';

class Book {
  const Book({
    required this.workId,
    required this.title,
    required this.authors,
    this.year,
    this.coverId,
  });

  final String workId;
  final String title;
  final List<String> authors;
  final int? year;
  final int? coverId;

  factory Book.fromJson(Map<String, dynamic> json) => Book(
    workId: (json['key'] as String).split('/').last,
    title: (json['title'] as String?) ?? 'Untitled book',
    authors: (json['author_name'] as List<dynamic>? ?? const [])
        .whereType<String>()
        .toList(),
    year: json['first_publish_year'] as int?,
    coverId: json['cover_i'] as int?,
  );
}

class ItemDetails {
  const ItemDetails({
    required this.title,
    required this.summary,
    this.imageUrl,
    this.year = '',
  });

  final String title;
  final String summary;
  final String? imageUrl;
  final String year;
}

class OpenLibraryApi {
  OpenLibraryApi(this.client);
  final http.Client client;

  Future<List<Book>> search(String query) async {
    if (query.trim().length < 3) return const [];
    final uri = Uri.https('openlibrary.org', '/search.json', {
      'q': query.trim(),
      'fields': 'key,title,author_name,first_publish_year,cover_i',
      'limit': '20',
    });
    final json = await readShelfJson(client, uri);
    final docs = json['docs'] as List<dynamic>? ?? const [];
    return docs
        .map((item) => Book.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<ItemDetails> details(String workId) async {
    if (!RegExp(r'^OL\d+W$').hasMatch(workId)) {
      throw const ApiException(
        'Use a work ID such as OL27482W, without /works/.',
      );
    }
    final json = await readShelfJson(
      client,
      Uri.https('openlibrary.org', '/works/$workId.json'),
    );
    final description = switch (json['description']) {
      final String text => text,
      {'value': final String text} => text,
      _ => 'No description yet.',
    };
    final covers = json['covers'] as List<dynamic>? ?? const [];
    final validCovers = covers.whereType<int>().where((id) => id > 0);
    var year = json['first_publish_date']?.toString() ?? '';

    // Works often omit the year. Ask search for its first publication year.
    // A missing year must not prevent the rest of the details from opening.
    if (year.isEmpty) {
      try {
        final metadata = await readShelfJson(
          client,
          Uri.https('openlibrary.org', '/search.json', {
            'q': 'key:/works/$workId',
            'fields': 'first_publish_year',
            'limit': '1',
          }),
        );
        final docs = metadata['docs'] as List<dynamic>? ?? const [];
        if (docs.isNotEmpty) {
          year = docs.first['first_publish_year']?.toString() ?? '';
        }
      } on ApiException {
        // The title, cover, and summary can still be shown without a year.
      }
    }

    return ItemDetails(
      title: json['title'] as String? ?? 'Untitled book',
      summary: description.isEmpty ? 'No description yet.' : description,
      imageUrl: coverUrl(validCovers.isEmpty ? null : validCovers.first),
      year: year,
    );
  }
}

class Movie {
  const Movie({
    required this.imdbId,
    required this.title,
    required this.year,
    this.poster,
  });

  final String imdbId;
  final String title;
  final String year;
  final String? poster;

  factory Movie.fromJson(Map<String, dynamic> json) => Movie(
    imdbId: json['imdbID'] as String,
    title: json['Title'] as String? ?? 'Untitled movie',
    year: json['Year'] as String? ?? '',
    poster: posterUrl(json['Poster']),
  );
}

class OmdbApi {
  OmdbApi(this.client, {this.key = omdbKey});
  final http.Client client;
  final String key;

  void _checkKey() {
    if (key.trim().isEmpty) {
      throw const ApiException('Add OMDB_KEY to cms.json and restart the app.');
    }
  }

  Future<List<Movie>> search(String query) async {
    _checkKey();
    if (query.trim().length < 3) return const [];
    final json = await readShelfJson(
      client,
      Uri.https('www.omdbapi.com', '/', {
        'apikey': key,
        's': query.trim(),
        'type': 'movie',
      }),
    );
    if (json['Response'] == 'False') {
      final error = json['Error'] as String? ?? 'OMDb error';
      if (error == 'Movie not found!') return const [];
      throw ApiException(error);
    }
    final items = json['Search'] as List<dynamic>? ?? const [];
    return items
        .map((item) => Movie.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<ItemDetails> details(String imdbId) async {
    _checkKey();
    if (!RegExp(r'^tt\d+$').hasMatch(imdbId)) {
      throw const ApiException('Use an IMDb ID such as tt0816692.');
    }
    final json = await readShelfJson(
      client,
      Uri.https('www.omdbapi.com', '/', {
        'apikey': key,
        'i': imdbId,
        'plot': 'short',
      }),
    );
    if (json['Response'] == 'False') {
      throw ApiException(
        json['Error'] as String? ?? 'Could not load the movie.',
      );
    }
    final plot = json['Plot'] as String? ?? '';
    return ItemDetails(
      title: json['Title'] as String? ?? 'Untitled movie',
      summary: plot.isEmpty || plot == 'N/A' ? 'No summary available.' : plot,
      imageUrl: posterUrl(json['Poster']),
      year: json['Year'] as String? ?? '',
    );
  }
}

class Pick {
  const Pick({
    required this.id,
    required this.title,
    required this.kind,
    required this.externalId,
    required this.note,
  });

  final String id;
  final String title;
  final String kind;
  final String externalId;
  final String note;

  factory Pick.fromContentful(Map<String, dynamic> json) {
    final fields = json['fields'] as Map<String, dynamic>;
    final kind = fields['kind'] as String? ?? '';
    if (kind != 'book' && kind != 'movie') {
      throw const ApiException('Every Pick must have kind book or movie.');
    }
    final externalId = fields['externalId'] as String? ?? '';
    if (externalId.trim().isEmpty) {
      throw const ApiException('A Pick is missing its externalId in the CMS.');
    }
    return Pick(
      id: (json['sys'] as Map<String, dynamic>)['id'] as String,
      title: fields['title'] as String? ?? 'Untitled pick',
      kind: kind,
      externalId: externalId.trim(),
      note: fields['note'] as String? ?? '',
    );
  }
}

abstract interface class PickSource {
  Future<List<Pick>> fetchPicks();
}

class ContentfulPickSource implements PickSource {
  ContentfulPickSource(
    this.client, {
    this.spaceId = shelfSpace,
    this.token = shelfToken,
    this.environment = 'master',
  });

  final http.Client client;
  final String spaceId;
  final String token;
  final String environment;

  @override
  Future<List<Pick>> fetchPicks() async {
    if (shelfCms != 'contentful') {
      throw const ApiException(
        'This Shelf uses Contentful. Set CMS=contentful.',
      );
    }
    if (spaceId.isEmpty || token.isEmpty) {
      throw const ApiException(
        'Add CMS_SPACE and CMS_TOKEN to cms.json, then run with '
        '--dart-define-from-file=cms.json.',
      );
    }
    final json = await readShelfJson(
      client,
      Uri.https(
        'cdn.contentful.com',
        '/spaces/$spaceId/environments/$environment/entries',
        {'content_type': 'pick', 'limit': '100'},
      ),
      headers: {'Authorization': 'Bearer $token'},
    );
    final items = json['items'] as List<dynamic>? ?? const [];
    return items
        .map((item) => Pick.fromContentful(item as Map<String, dynamic>))
        .toList();
  }
}
