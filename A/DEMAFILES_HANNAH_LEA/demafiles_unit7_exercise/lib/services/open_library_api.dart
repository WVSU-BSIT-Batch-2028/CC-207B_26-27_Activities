import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/book.dart';
import '../models/pick.dart';

class OpenLibraryApi {
  Future<List<Book>> search(String query) async {
    final uri = Uri.https('openlibrary.org', '/search.json', {
      'q': query,
      'fields': 'key,title,author_name,first_publish_year,cover_i',
      'limit': '20',
    });
    final response = await http.get(uri);
    if (response.statusCode != 200) {
      throw ApiException('Open Library error (${response.statusCode})');
    }
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final docs = (json['docs'] as List<dynamic>?) ?? [];
    return docs.map((d) => Book.fromJson(d as Map<String, dynamic>)).toList();
  }

  Future<MediaDetails> fetchDetails(String workId) async {
    final uri = Uri.https('openlibrary.org', '/works/$workId.json');
    final response = await http.get(uri);
    if (response.statusCode != 200) {
      throw ApiException('Open Library error (${response.statusCode})');
    }
    final json = jsonDecode(response.body) as Map<String, dynamic>;

    // The description comes in two shapes.
    final description = switch (json['description']) {
      final String text => text,
      {'value': final String text} => text,
      _ => 'No description yet.',
    };

    final covers = json['covers'] as List<dynamic>?;
    final coverId = (covers != null && covers.isNotEmpty) ? covers.first : null;

    return MediaDetails(
      title: json['title'] as String? ?? 'Unknown title',
      imageUrl: (coverId is int && coverId > 0)
          ? 'https://covers.openlibrary.org/b/id/$coverId-M.jpg'
          : null,
      year: json['first_publish_date'] as String?,
      summary: description,
    );
  }
}