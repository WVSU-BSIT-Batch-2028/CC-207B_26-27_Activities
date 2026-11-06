
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/book.dart';

class OpenLibraryApi {
  Future<List<Book>> search(String query) async {
    final uri = Uri.https(
      'openlibrary.org',
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
        'Failed to load books. Status code: ${response.statusCode}',
      );
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;

    final docs = json['docs'] as List<dynamic>;

    return docs
        .map((doc) => Book.fromJson(doc as Map<String, dynamic>))
        .toList();
  }

    Future<Map<String, dynamic>> getWork(String workId) async {
    final uri = Uri.https(
      'openlibrary.org',
      '/works/$workId.json',
    );

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Failed to load book details.');
    }

    return jsonDecode(response.body) as Map<String, dynamic>;
  }
}
