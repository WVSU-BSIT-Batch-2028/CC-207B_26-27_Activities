import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/book.dart';

class OpenLibraryApi {
  Future<List<Book>> search(String query) async {
    if (query.trim().isEmpty) {
      return [];
    }

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

    final data = jsonDecode(response.body) as Map<String, dynamic>;

    final docs = data['docs'] as List<dynamic>;

    return docs.map((item) {
      return Book.fromJson(item as Map<String, dynamic>);
    }).toList();
  }
  
  Future<Map<String, dynamic>> fetchDetails(String workId) async {
    final uri = Uri.https(
      'openlibrary.org',
      '/works/$workId.json',
    );

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to load book details. Status code: ${response.statusCode}',
      );
    }

    return jsonDecode(response.body) as Map<String, dynamic>;
  }
}
