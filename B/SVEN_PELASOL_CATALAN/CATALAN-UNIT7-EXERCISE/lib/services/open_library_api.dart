import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/api_exception.dart';
import '../models/book.dart';

class OpenLibraryApi {
  Future<List<Book>> search(String query) async {
    final uri = Uri.https(
      'openlibrary.org',
      '/search.json',
      <String, String>{
        'q': query,
        'fields': 'key,title,author_name,first_publish_year,cover_i',
        'limit': '20',
      },
    );

    final response = await http.get(uri).timeout(const Duration(seconds: 20));
    if (response.statusCode != 200) {
      throw ApiException(
        'Open Library request failed (${response.statusCode}). Please try again.',
      );
    }

    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      throw const ApiException('Open Library returned an unexpected response.');
    }

    final docs = decoded['docs'];
    if (docs is! List) return const <Book>[];

    return docs
        .whereType<Map<String, dynamic>>()
        .map(Book.fromJson)
        .toList(growable: false);
  }

  Future<BookDetails> fetchDetails(String workId) async {
    final uri = Uri.https('openlibrary.org', '/works/$workId.json');
    final response = await http.get(uri).timeout(const Duration(seconds: 20));
    if (response.statusCode != 200) {
      throw ApiException(
        'Could not load book details (${response.statusCode}).',
      );
    }

    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      throw const ApiException('Open Library returned invalid book details.');
    }
    return BookDetails.fromJson(decoded);
  }
}
