import 'package:http/http.dart' as http;

import '../models/book.dart';
import '../models/pick.dart';
import 'api_exception.dart';

class OpenLibraryApi {
  OpenLibraryApi(this.client);

  final http.Client client;

  Future<List<Book>> search(String query) async {
    final uri = Uri.https('openlibrary.org', '/search.json', {
      'q': query,
      'fields': 'key,title,author_name,first_publish_year,cover_i',
      'limit': '20',
    });
    final json =
        await getJson(client, uri, name: 'Open Library')
            as Map<String, dynamic>;
    final docs = json['docs'] as List<dynamic>? ?? const [];
    return [
      for (final doc in docs.cast<Map<String, dynamic>>()) Book.fromJson(doc),
    ];
  }

  Future<PickDetails> details(String workId) async {
    final uri = Uri.https('openlibrary.org', '/works/$workId.json');
    final json =
        await getJson(client, uri, name: 'Open Library')
            as Map<String, dynamic>;
    final description = switch (json['description']) {
      final String text => text,
      {'value': final String text} => text,
      _ => 'No description yet.',
    };
    final covers = json['covers'] as List<dynamic>?;
    final coverId = (covers != null && covers.isNotEmpty)
        ? covers.first as int
        : null;
    return PickDetails(
      title: json['title'] as String? ?? 'Untitled',
      summary: description,
      imageUrl: (coverId == null || coverId < 0)
          ? null
          : 'https://covers.openlibrary.org/b/id/$coverId-L.jpg',
    );
  }
}
