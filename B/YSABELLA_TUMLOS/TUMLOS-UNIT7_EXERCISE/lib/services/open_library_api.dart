import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/book.dart';
import '../models/details.dart';
import 'api_exception.dart';

class OpenLibraryApi {
  const OpenLibraryApi();

  Future<List<Book>> search(String query) async {
    final uri = Uri.https('openlibrary.org', '/search.json', {
      'q': query,
      'fields': 'key,title,author_name,first_publish_year,cover_i',
      'limit': '20',
    });

    final response = await http.get(uri);
    if (response.statusCode != 200) {
      throw ApiException('Open Library error (${response.statusCode}).');
    }

    final json = jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
    final docs = json['docs'] as List<dynamic>;

    return [
      for (final doc in docs) Book.fromJson(doc as Map<String, dynamic>),
    ];
  }

  Future<Details> details(String workId) async {
    var path = '/works/$workId.json';

    for (var attempt = 0; attempt < 3; attempt++) {
      final response = await http.get(Uri.https('openlibrary.org', path));
      if (response.statusCode != 200) {
        throw ApiException('Open Library error (${response.statusCode}).');
      }

      final json = jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;

      final type = (json['type'] as Map<String, dynamic>?)?['key'];
      if (type == '/type/redirect') {
        path = '${json['location']}.json';
        continue;
      }

      final description = switch (json['description']) {
        final String text => text,
        {'value': final String text} => text,
        _ => 'No description yet.',
      };

      final covers = [...?(json['covers'] as List<dynamic>?)?.cast<int>()];
      final coverId = covers.where((id) => id > 0).firstOrNull;

      return Details(
        title: json['title'] as String? ?? '',
        summary: description,
        imageUrl: coverId == null
            ? null
            : 'https://covers.openlibrary.org/b/id/$coverId-L.jpg',
      );
    }

    throw const ApiException('Open Library redirected too many times.');
  }
}
