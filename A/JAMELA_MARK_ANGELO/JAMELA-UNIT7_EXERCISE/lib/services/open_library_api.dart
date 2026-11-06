import 'dart:convert';

import 'package:http/http.dart' as http;

import 'api_exception.dart';

import '../models/book.dart';

class OpenLibraryApi {
  Future<List<Book>> search(String query) async {
    final uri = Uri.https('openlibrary.org', '/search.json', {
      'q': query,
      'limit': '20',
      'fields': 'key,title,author_name,first_publish_year,cover_i',
    });

    String parseOpenLibraryDescription(dynamic descriptionJson) {
      return switch (descriptionJson) {
        final String text => text,
        {'value': final String text} => text,
        _ => 'No description yet.',
      };
    }

    final response = await http.get(uri);
    if (response.statusCode != 200) {
      throw ApiException(
          'Open Library request failed (${response.statusCode}).');
    }

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final docs = body['docs'] as List<dynamic>? ?? const [];

    return docs
        .map((item) => Book.fromJson(Map<String, dynamic>.from(item as Map)))
        .toList();
  }
}

String openLibraryId(Book book) {
  return book.id;
}

String? openLibraryCoverUrl(Book book) {
  return book.coverUrl;
}
