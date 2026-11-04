import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/book.dart';
import 'api_exception.dart';

class OpenLibraryApi {
  Future<List<Book>> search(String query) async {
    // Uri.https encodes spaces and symbols for you.
    final uri = Uri.https('openlibrary.org', '/search.json', {
      'q': query,
      'fields': 'key,title,author_name,first_publish_year,cover_i',
      'limit': '20',
    });
    final response = await http.get(uri);
    if (response.statusCode != 200) {
      throw ApiException('Open Library error (${response.statusCode}).');
    }
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final docs = (json['docs'] as List<dynamic>?) ?? const [];
    return docs.map((d) => Book.fromJson(d as Map<String, dynamic>)).toList();
  }

  /// Details of one work, e.g. workId = "OL27482W".
  Future<Map<String, dynamic>> work(String workId) async {
    final uri = Uri.https('openlibrary.org', '/works/$workId.json');
    final response = await http.get(uri);
    if (response.statusCode == 404) {
      throw ApiException('Book not found. Check the externalId in your CMS.');
    }
    if (response.statusCode != 200) {
      throw ApiException('Open Library error (${response.statusCode}).');
    }
    return jsonDecode(response.body) as Map<String, dynamic>;
  }
}
