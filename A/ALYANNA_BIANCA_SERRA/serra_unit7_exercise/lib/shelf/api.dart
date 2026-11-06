import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'config.dart';
import 'models.dart';

Future<Map<String, dynamic>> getJson(
  Uri uri, {
  Map<String, String> headers = const {},
}) async {
  final http.Response response;
  try {
    response = await http
        .get(uri, headers: headers)
        .timeout(const Duration(seconds: 10));
  } on TimeoutException {
    throw const ApiException('The server took too long to answer. Try again.');
  } on http.ClientException {
    throw const ApiException(
      'No connection. Check your internet and try again.',
    );
  }

  switch (response.statusCode) {
    case 200:
      return jsonDecode(response.body) as Map<String, dynamic>;
    case 401 || 403:
      throw ApiException(
        'The server refused the request (${response.statusCode}). '
        'Check your API key or token.',
      );
    case 404:
      throw const ApiException('Not found (404). Check the ID or the URL.');
    case >= 500:
      throw ApiException(
        'The server is having problems (${response.statusCode}). '
        'Try again later.',
      );
    default:
      throw ApiException('The server answered ${response.statusCode}.');
  }
}

class OpenLibraryApi {
  Future<List<Book>> search(String query) async {
    final uri = Uri.https('openlibrary.org', '/search.json', {
      'q': query,
      'fields': 'key,title,author_name,first_publish_year,cover_i',
      'limit': '20',
    });
    final json = await getJson(uri);
    final docs = (json['docs'] as List<dynamic>?) ?? const [];
    return [for (final doc in docs) Book.fromJson(doc as Map<String, dynamic>)];
  }

  Future<PickDetails> details(String workId) async {
    final json = await getJson(
      Uri.https('openlibrary.org', '/works/$workId.json'),
    );

    final description = switch (json['description']) {
      final String text => text, 
      {'value': final String text} => text, 
      _ => 'No description yet.',
    };

    final covers = (json['covers'] as List<dynamic>?) ?? const [];
    final coverId = covers.whereType<int>().where((id) => id > 0).firstOrNull;

    final year = switch (json['first_publish_date']) {
      final String date => date,
      _ => null,
    };

    return PickDetails(
      summary: description,
      imageUrl: coverId == null
          ? null
          : 'https://covers.openlibrary.org/b/id/$coverId-L.jpg',
      year: year,
    );
  }
}

class OmdbApi {
  void _requireKey() {
    if (omdbKey.isEmpty) {
      throw const ApiException(
        'The OMDb key is missing. Run the app with --dart-define-from-file=cms.json',
      );
    }
  }

  Future<List<Movie>> search(String query) async {
    _requireKey();
    final uri = Uri.https('www.omdbapi.com', '/', {
      'apikey': omdbKey,
      's': query,
      'type': 'movie',
    });
    final json = await getJson(uri);

    if (json['Response'] == 'False') {
      final error = json['Error'] as String? ?? 'OMDb error';
      if (error == 'Movie not found!') return const []; // empty, not an error
      throw ApiException(error); // e.g. "Invalid API key!"
    }

    final results = (json['Search'] as List<dynamic>?) ?? const [];
    return [
      for (final item in results) Movie.fromJson(item as Map<String, dynamic>),
    ];
  }

  Future<PickDetails> details(String imdbId) async {
    _requireKey();
    final uri = Uri.https('www.omdbapi.com', '/', {
      'apikey': omdbKey,
      'i': imdbId,
      'plot': 'short',
    });
    final json = await getJson(uri);

    if (json['Response'] == 'False') {
      throw ApiException(json['Error'] as String? ?? 'OMDb error');
    }

    final poster = json['Poster'] as String?;
    final plot = json['Plot'] as String?;
    return PickDetails(
      summary: (plot == null || plot == 'N/A') ? 'No description yet.' : plot,
      imageUrl: (poster == null || poster == 'N/A') ? null : poster,
      year: json['Year'] as String?,
    );
  }
}

abstract interface class PickSource {
  Future<List<Pick>> fetchPicks();
}

class ContentfulPickSource implements PickSource {
  ContentfulPickSource({
    required this.spaceId,
    required this.token,
    this.environment = 'master',
  });

  final String spaceId;

  final String token;
  final String environment;

  @override
  Future<List<Pick>> fetchPicks() async {
    if (spaceId.isEmpty || token.isEmpty) {
      throw const ApiException(
        'CMS_SPACE and CMS_TOKEN are missing. '
        'Run the app with --dart-define-from-file=cms.json',
      );
    }

    final uri = Uri.https(
      'cdn.contentful.com',
      '/spaces/$spaceId/environments/$environment/entries',
      {'content_type': 'pick', 'order': 'sys.createdAt', 'limit': '100'},
    );
    final json = await getJson(
      uri,
      headers: {'Authorization': 'Bearer $token'},
    );

    final items = (json['items'] as List<dynamic>?) ?? const [];
    return [for (final item in items) _toPick(item as Map<String, dynamic>)];
  }

  Pick _toPick(Map<String, dynamic> item) {
    final sys = item['sys'] as Map<String, dynamic>;
    final fields = (item['fields'] as Map<String, dynamic>?) ?? const {};

    return Pick(
      id: sys['id'] as String,
      title: fields['title'] as String? ?? '',
      kind: (fields['kind'] as String? ?? '').trim().toLowerCase(),
      externalId: (fields['externalId'] as String? ?? '').trim(),
      note: fields['note'] as String? ?? '',
    );
  }
}
