import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/book.dart';
import 'api_exception.dart';

class OpenLibraryApi {
  OpenLibraryApi(this.client);

  final http.Client client;

  Future<List<Book>> search(String query) async {
    final uri = Uri.https('openlibrary.org', '/search.json', {
      'q': query,
      'fields': 'key,title,author_name,first_publish_year,cover_i',
      'limit': '20',
    });
    final json = await _getJson(uri);
    final docs = json['docs'] as List<dynamic>? ?? const [];
    return docs
        .whereType<Map<String, dynamic>>()
        .map(Book.fromJson)
        .where((book) => book.workId.isNotEmpty && book.title.isNotEmpty)
        .toList();
  }

  Future<BookDetails> fetchDetails(String workId) async {
    final work = await _getJson(
      Uri.https('openlibrary.org', '/works/$workId.json'),
    );
    final firstDate = work['first_publish_date'] as String?;
    var year = _yearFrom(firstDate);
    var coverId = _firstCoverId(work['covers']);

    if (year == null || coverId == null) {
      try {
        final editions = await _getJson(
          Uri.https('openlibrary.org', '/works/$workId/editions.json', {
            'limit': '20',
          }),
        );
        final entries = editions['entries'] as List<dynamic>? ?? const [];
        for (final raw in entries.whereType<Map<String, dynamic>>()) {
          year ??= _yearFrom(raw['publish_date'] as String?);
          coverId ??= _firstCoverId(raw['covers']);
          if (year != null && coverId != null) break;
        }
      } on ApiException {
        if (year == null && coverId == null) rethrow;
      }
    }

    final title = work['title'] as String? ?? '';
    final summary = switch (work['description']) {
      final String text => text,
      {'value': final String text} => text,
      _ => 'No description yet.',
    };
    final artworkUrl = coverId == null || coverId <= 0
        ? null
        : 'https://covers.openlibrary.org/b/id/$coverId-L.jpg';
    return BookDetails(
      title: title,
      year: year,
      summary: summary,
      coverUrl: artworkUrl,
    );
  }

  Future<Map<String, dynamic>> _getJson(Uri uri) async {
    final http.Response response;
    try {
      response = await client.get(uri).timeout(const Duration(seconds: 15));
    } on Exception {
      throw const ApiException('Could not connect to Open Library. Try again.');
    }
    if (response.statusCode != 200) {
      throw ApiException(
        'Open Library answered ${response.statusCode}. Try again later.',
      );
    }
    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      throw const ApiException('Open Library returned an invalid response.');
    }
    return decoded;
  }

  String? _yearFrom(String? value) {
    if (value == null) return null;
    return RegExp(r'\d{4}').firstMatch(value)?.group(0);
  }

  int? _firstCoverId(Object? value) {
    if (value is! List<dynamic>) return null;
    for (final cover in value) {
      if (cover is int && cover > 0) return cover;
    }
    return null;
  }
}
