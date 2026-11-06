import 'dart:convert';
import 'package:http/http.dart' as http;
import 'book.dart';

class OpenLibraryApi {
  Future<List<Book>> search(String query) async {
    final uri = Uri.https(
      'openlibrary.org',
      '/search.json',
      {
        'q': query,
        'limit': '20',
      },
    );

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Open Library error: ${response.statusCode}');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final docs = json['docs'] as List<dynamic>? ?? [];

    return docs
        .where((item) => item is Map<String, dynamic> && item['key'] is String)
        .map((item) => Book.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
