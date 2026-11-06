import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/book.dart';
import 'api_exception.dart';

class BookDetails {
  const BookDetails({
    required this.title,
    required this.coverId,
    required this.year,
    required this.description,
  });

  final String title;
  final int? coverId;
  final String? year;
  final String description;
}

class OpenLibraryApi {
  OpenLibraryApi({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Future<List<Book>> search(String query) async {
    final uri = Uri.https('openlibrary.org', '/search.json', {
      'q': query,
      'fields': 'key,title,author_name,first_publish_year,cover_i',
      'limit': '20',
    });
    final response = await _client.get(uri);
    if (response.statusCode != 200) {
      throw ApiException('Open Library answered ${response.statusCode}.');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final docs = json['docs'] as List<dynamic>? ?? const [];
    return docs
        .map((item) => Book.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<BookDetails> getDetails(String workId) async {
    final uri = Uri.https('openlibrary.org', '/works/$workId.json');
    final response = await _client.get(uri);
    if (response.statusCode != 200) {
      throw ApiException('Open Library answered ${response.statusCode}.');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final covers = json['covers'] as List<dynamic>?;
    final coverIds = covers?.whereType<int>().toList() ?? const <int>[];
    final coverId = coverIds.isEmpty ? null : coverIds.first;
    final description = switch (json['description']) {
      final String text => text,
      {'value': final String text} => text,
      _ => 'No description yet.',
    };

    return BookDetails(
      title: json['title'] as String? ?? 'Untitled',
      coverId: coverId,
      year: json['first_publish_date'] as String?,
      description: description,
    );
  }

  void close() => _client.close();
}
