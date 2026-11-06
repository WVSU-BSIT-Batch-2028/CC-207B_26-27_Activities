
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
        'fields': 'key,title,author_name,first_publish_year,cover_i',
        'limit': '20',
      },
    );

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Failed to load books. Please try again.');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final results = data['docs'] as List<dynamic>;

    return results
        .map((item) => Book.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
