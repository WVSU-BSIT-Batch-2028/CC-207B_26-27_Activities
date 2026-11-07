import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/book.dart';
import 'api_exception.dart';

class OpenLibraryApi {
  OpenLibraryApi([http.Client? client]) : _client = client ?? http.Client();

  final http.Client _client;

  Future<List<Book>> search(String query) async {
    final uri = Uri.https('openlibrary.org', '/search.json', {
      'q': query,
      'fields': 'key,title,author_name,first_publish_year,cover_i',
      'limit': '20',
    });
    final json = await _get(uri);
    final docs = json['docs'] as List<dynamic>? ?? const [];
    return docs
        .whereType<Map<String, dynamic>>()
        .where((doc) => doc['key'] is String && doc['title'] is String)
        .map(Book.fromJson)
        .toList();
  }

  Future<BookDetails> fetchWork(String workId) async {
    final json = await _get(
      Uri.https('openlibrary.org', '/works/$workId.json'),
    );
    final description = switch (json['description']) {
      final String text => text,
      {'value': final String text} => text,
      _ => 'No description yet.',
    };
    final covers = (json['covers'] as List<dynamic>?)
        ?.whereType<int>()
        .where((id) => id >= 0);
    return BookDetails(
      title: json['title'] as String? ?? 'Untitled',
      description: description,
      coverId: covers?.firstOrNull,
      year: _yearFrom(json['first_publish_date'] as String?),
    );
  }

  Future<Map<String, dynamic>> _get(Uri uri) async {
    try {
      final response = await _client
          .get(uri)
          .timeout(const Duration(seconds: 10));
      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw ApiException('Open Library answered ${response.statusCode}.');
      }
      final decoded = jsonDecode(response.body);
      if (decoded is! Map<String, dynamic>) {
        throw const ApiException('Open Library returned an invalid response.');
      }
      return decoded;
    } on ApiException {
      rethrow;
    } on TimeoutException {
      throw const ApiException('Open Library took too long to answer.');
    } on http.ClientException {
      throw const ApiException('Could not connect to Open Library.');
    } on FormatException {
      throw const ApiException('Open Library returned invalid JSON.');
    }
  }

  int? _yearFrom(String? date) {
    final match = RegExp(r'\b\d{4}\b').firstMatch(date ?? '');
    return match == null ? null : int.tryParse(match.group(0)!);
  }
}
