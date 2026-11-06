import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/book.dart';
import '../models/shelf_detail.dart';
import 'api_exception.dart';

export 'api_exception.dart';

class OpenLibraryApi {
  OpenLibraryApi({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Future<List<Book>> search(String query) async {
    final uri = Uri.https('openlibrary.org', '/search.json', {
      'q': query.trim(),
      'fields': 'key,title,author_name,first_publish_year,cover_i',
      'limit': '20',
    });

    try {
      final response = await _client
          .get(uri)
          .timeout(const Duration(seconds: 20));

      if (response.statusCode == 429) {
        throw const ApiException(
          'Open Library is receiving too many requests. Please try again later.',
        );
      }
      if (response.statusCode >= 500) {
        throw const ApiException(
          'Open Library is unavailable. Please try again later.',
        );
      }
      if (response.statusCode != 200) {
        throw ApiException('Book search failed (${response.statusCode}).');
      }

      final json = jsonDecode(response.body);
      if (json is! Map<String, dynamic> || json['docs'] is! List) {
        throw const FormatException();
      }
      return (json['docs'] as List<dynamic>)
          .map((item) => Book.fromJson(item as Map<String, dynamic>))
          .toList();
    } on TimeoutException {
      throw const ApiException('Book search timed out. Please try again.');
    } on http.ClientException {
      throw const ApiException(
        'Could not connect. Check your internet connection and try again.',
      );
    } on FormatException {
      throw const ApiException(
        'Open Library returned an unexpected response. Please try again.',
      );
    }
  }

  Future<ShelfDetail> details(String workId) async {
    if (!RegExp(r'^OL\d+W$').hasMatch(workId)) {
      throw const ApiException(
        'Invalid Open Library work ID. Copy the ID from Books.',
      );
    }
    try {
      final response = await _client
          .get(Uri.https('openlibrary.org', '/works/$workId.json'))
          .timeout(const Duration(seconds: 20));
      if (response.statusCode != 200) {
        throw ApiException(
          'Book details failed (${response.statusCode}). Please retry.',
        );
      }
      final json = jsonDecode(response.body);
      if (json is! Map<String, dynamic>) throw const FormatException();
      final description = switch (json['description']) {
        final String text when text.trim().isNotEmpty => text,
        {'value': final String text} when text.trim().isNotEmpty => text,
        _ => 'No description yet.',
      };
      final covers = (json['covers'] as List<dynamic>? ?? const [])
          .whereType<num>()
          .where((id) => id > 0);
      String? year = json['first_publish_date'] as String?;
      // The work endpoint often omits the year; its search index has it.
      try {
        final books = await search('key:/works/$workId');
        final matching = books.where((book) => book.workId == workId);
        if (matching.isNotEmpty && matching.first.year != null) {
          year = '${matching.first.year}';
        }
      } on ApiException {
        // An optional year lookup must not hide valid title/summary data.
      }
      return ShelfDetail(
        title: json['title'] as String? ?? 'Untitled book',
        summary: description,
        year: year,
        imageUrl: covers.isEmpty
            ? null
            : 'https://covers.openlibrary.org/b/id/${covers.first.toInt()}-L.jpg?default=false',
      );
    } on TimeoutException {
      throw const ApiException('Book details timed out. Please try again.');
    } on http.ClientException {
      throw const ApiException(
        'Could not connect. Check your internet connection and try again.',
      );
    } on FormatException {
      throw const ApiException('Open Library returned an unexpected response.');
    }
  }

  void close() => _client.close();
}
