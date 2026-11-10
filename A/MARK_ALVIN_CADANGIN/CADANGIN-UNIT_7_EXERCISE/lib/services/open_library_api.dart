import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/book.dart';
import 'api_exception.dart';

class BookDetail {
  final String title;
  final String description;
  final String? coverUrl;

  const BookDetail({
    required this.title,
    required this.description,
    this.coverUrl,
  });
}

class OpenLibraryApi {
  final http.Client client;

  OpenLibraryApi([http.Client? client]) : client = client ?? http.Client();

  Future<List<Book>> search(String query) async {
    final uri = Uri.https('openlibrary.org', '/search.json', {
      'q': query,
      'fields': 'key,title,author_name,first_publish_year,cover_i',
      'limit': '20',
    });

    final response = await client.get(uri);
    if (response.statusCode != 200) {
      throw ApiException('Open Library returned status ${response.statusCode}');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final docs = json['docs'] as List<dynamic>? ?? [];
    return docs.map((d) => Book.fromJson(d as Map<String, dynamic>)).toList();
  }

  Future<BookDetail> getDetails(String workId) async {
    final uri = Uri.https('openlibrary.org', '/works/$workId.json');
    final response = await client.get(uri);
    if (response.statusCode != 200) {
      throw ApiException('Book details returned status ${response.statusCode}');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final title = json['title'] as String? ?? 'Untitled';

    final description = switch (json['description']) {
      final String text => text,
      {'value': final String text} => text,
      _ => 'No description yet.',
    };

    String? coverUrl;
    final covers = json['covers'] as List<dynamic>?;
    if (covers != null && covers.isNotEmpty && covers.first is int) {
      coverUrl = 'https://covers.openlibrary.org/b/id/${covers.first}-M.jpg';
    }

    return BookDetail(
      title: title,
      description: description,
      coverUrl: coverUrl,
    );
  }
}

