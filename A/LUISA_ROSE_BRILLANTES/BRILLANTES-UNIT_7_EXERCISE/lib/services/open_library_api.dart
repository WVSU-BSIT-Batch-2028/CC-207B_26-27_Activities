import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/book.dart';

class OpenLibraryApi {
  Future<List<Book>> search(String query) async {
    final q = query.trim();
    if (q.length < 3) return const [];

    final uri = Uri.https('openlibrary.org', '/search.json', {
      'q': q,
      'fields': 'key,title,author_name,first_publish_year,cover_i',
      'limit': '20',
    });

    final response = await http.get(uri);
    if (response.statusCode != 200) {
      throw Exception('Open Library error: ${response.statusCode}');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final docs = (json['docs'] as List<dynamic>? ?? const [])
        .map((e) => e as Map<String, dynamic>)
        .toList();

    return docs.map(Book.fromJson).toList();
  }

  Future<Map<String, dynamic>> fetchDetail(String workId) async {
    final uri = Uri.https('openlibrary.org', '/works/$workId.json');
    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Open Library detail error: ${response.statusCode}');
    }

    return jsonDecode(response.body) as Map<String, dynamic>;
  }
}