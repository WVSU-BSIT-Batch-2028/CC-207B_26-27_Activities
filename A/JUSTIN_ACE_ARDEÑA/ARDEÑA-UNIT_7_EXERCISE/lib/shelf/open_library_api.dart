import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'api_exception.dart';
import 'book.dart';
import 'http_helper.dart';
import 'pick.dart';

/// Searches books on Open Library (no key needed).
class OpenLibraryApi {
  OpenLibraryApi({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Future<List<Book>> search(String query) async {
    // Uri.https adds the ? and & and encodes spaces for us.
    final uri = Uri.https('openlibrary.org', '/search.json', {
      'q': query,
      'fields': 'key,title,author_name,first_publish_year,cover_i',
      'limit': '20',
    });
    final http.Response response;
    try {
      response = await _client.get(uri).timeout(const Duration(seconds: 10));
    } on TimeoutException {
      throw const ApiException('Open Library took too long. Try again.');
    } on http.ClientException {
      throw const ApiException('No connection. Check your internet.');
    }
    if (response.statusCode != 200) {
      throw ApiException(
        'Open Library answered ${response.statusCode}. Try again later.',
      );
    }
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final docs = json['docs'] as List<dynamic>? ?? const [];
    return [
      for (final doc in docs) Book.fromJson(doc as Map<String, dynamic>),
    ];
  }

  /// Details of one work by its id (used by the pick detail screen).
  Future<PickDetail> work(String workId) async {
    final body = await fetchBody(
      _client,
      Uri.https('openlibrary.org', '/works/$workId.json'),
      name: 'Open Library',
    );
    final json = jsonDecode(body) as Map<String, dynamic>;
    // Open Library sends the description in two shapes: plain text, or
    // {"type": ..., "value": "text"}. The switch handles both.
    final description = switch (json['description']) {
      final String text => text,
      {'value': final String text} => text,
      _ => 'No description yet.',
    };
    final covers = json['covers'] as List<dynamic>?;
    // Some covers are -1 (placeholder), so only use real ids.
    final coverId = covers?.whereType<int>().where((id) => id > 0).firstOrNull;
    return PickDetail(
      title: json['title'] as String? ?? '',
      description: description,
      imageUrl: coverId == null
          ? null
          : 'https://covers.openlibrary.org/b/id/$coverId-L.jpg',
    );
  }
}

