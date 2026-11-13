import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/book.dart';

class OpenLibraryApi {
  Future<List<Book>> search(String query) async {
    final url = Uri.https('openlibrary.org', '/search.json', {
      'q': query,
      'fields': 'key,title,author_name,first_publish_year,cover_i',
      'limit': '20',
    });

    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception('Failed to load books');
    }

    final data = jsonDecode(response.body);

    final List<dynamic> docs = data['docs'];

    return docs.map((json) => Book.fromJson(json)).toList();
  }
}
