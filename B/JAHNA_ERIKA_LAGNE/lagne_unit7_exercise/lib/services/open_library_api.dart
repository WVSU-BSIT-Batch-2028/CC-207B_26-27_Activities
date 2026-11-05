
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/book.dart';

class OpenLibraryApi {
  static const String _baseUrl = 'openlibrary.org';

  Future<List<Book>> searchBooks(String query) async {
    final uri = Uri.https(
      _baseUrl,
      '/search.json',
      {
        'q': query,
        'fields':
            'key,title,author_name,first_publish_year,cover_i',
        'limit': '20',
      },
    );

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception(
        'Unable to retrieve books. Please try again.',
      );
    }

    final Map<String, dynamic> data =
        jsonDecode(response.body) as Map<String, dynamic>;

    final List<dynamic> results = data['docs'] ?? [];

    return results
        .whereType<Map<String, dynamic>>()
        .map((json) => Book.fromJson(json))
        .where((book) => book.id.isNotEmpty)
        .toList();
  }

  Future<Map<String, dynamic>> getBookDetails(String workId) async {
    final cleanId = workId.startsWith('/')
        ? workId.substring(1)
        : workId;

    final uri = Uri.https(_baseUrl, '/$cleanId.json');

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Unable to retrieve book details.');
    }

    return jsonDecode(response.body) as Map<String, dynamic>;
  }
}
