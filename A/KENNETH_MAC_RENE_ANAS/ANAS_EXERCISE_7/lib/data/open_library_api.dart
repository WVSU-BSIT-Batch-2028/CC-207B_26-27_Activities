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
    final docs = (json['docs'] as List<dynamic>? ?? const []);
    return docs
        .map((item) => Book.fromSearchJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<Book> fetchDetails(String workId) async {
    final uri = Uri.https('openlibrary.org', '/works/$workId.json');
    final json = await _getJson(uri);
    return Book.fromDetailsJson(workId, json);
  }

  Future<Map<String, dynamic>> _getJson(Uri uri) async {
    final response = await client
        .get(uri)
        .timeout(
          const Duration(seconds: 15),
          onTimeout: () => throw const ApiException(
            'Open Library request timed out. Check your internet connection and retry.',
          ),
        );
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiException('Open Library returned HTTP ${response.statusCode}.');
    }
    return jsonDecode(response.body) as Map<String, dynamic>;
  }
}
