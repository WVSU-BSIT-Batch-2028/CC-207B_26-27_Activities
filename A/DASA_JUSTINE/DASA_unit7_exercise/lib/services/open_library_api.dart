import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/book.dart';
import '../models/book_details.dart';

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
      throw Exception(
        'Failed to load books: ${response.statusCode}',
      );
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final docs = json['docs'] as List<dynamic>;

    return docs
        .map((item) => Book.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<BookDetails> getBookDetails(String workKey) async {
    final uri = Uri.https(
      'openlibrary.org',
      '$workKey.json',
    );

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to load book details: ${response.statusCode}',
      );
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;

    final details = BookDetails.fromJson(json);

    final authorReferences = json['authors'] as List<dynamic>? ?? [];
    final authors = <String>[];

    for (final item in authorReferences) {
      final author = item as Map<String, dynamic>;
      final authorKey =
          (author['author'] as Map<String, dynamic>?)?['key'];

      if (authorKey == null) continue;

      final authorUri = Uri.https(
        'openlibrary.org',
        '$authorKey.json',
      );

      final authorResponse = await http.get(authorUri);

      if (authorResponse.statusCode == 200) {
        final authorJson =
            jsonDecode(authorResponse.body) as Map<String, dynamic>;

        final name = authorJson['name'];

        if (name != null) {
          authors.add(name.toString());
        }
      }
    }

    return BookDetails(
      title: details.title,
      description: details.description,
      authors: authors,
      subjects: details.subjects,
      covers: details.covers,
    );
  }
}