import 'package:http/http.dart' as http;

import 'api_exception.dart';
import 'book.dart';
import 'item_details.dart';

class OpenLibraryApi {
  OpenLibraryApi([http.Client? client]) : _client = client ?? http.Client();

  final http.Client _client;

  static const _who = 'Open Library';

  Future<List<Book>> search(String query) async {
    final uri = Uri.https('openlibrary.org', '/search.json', {
      'q': query,
      'fields': 'key,title,author_name,first_publish_year,cover_i',
      'limit': '20',
    });
    final json = await getJson(_client, uri, who: _who) as Map<String, dynamic>;
    final docs = json['docs'] as List<dynamic>;
    return [
      for (final doc in docs.cast<Map<String, dynamic>>()) Book.fromJson(doc),
    ];
  }

  Future<ItemDetails> details(String workId) async {
    final uri = Uri.https('openlibrary.org', '/works/$workId.json');
    final json = await getJson(_client, uri, who: _who) as Map<String, dynamic>;

    // Open Library's description comes in two shapes.
    final description = switch (json['description']) {
      final String text => text,
      {'value': final String text} => text,
      _ => 'No description yet.',
    };

    // covers can be missing, and can hold -1.
    String? imageUrl;
    if (json['covers'] case [final int first, ...] when first > 0) {
      imageUrl = 'https://covers.openlibrary.org/b/id/$first-L.jpg';
    }

    return ItemDetails(
      title: json['title'] as String? ?? 'Untitled',
      summary: description,
      subtitle: json['first_publish_date'] as String?,
      imageUrl: imageUrl,
    );
  }
}
