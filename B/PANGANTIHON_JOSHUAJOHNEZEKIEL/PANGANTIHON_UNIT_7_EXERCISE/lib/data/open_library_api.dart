import 'package:http/http.dart' as http;

import 'api_exception.dart';
import 'book.dart';

class OpenLibraryApi {
  OpenLibraryApi(this.client);

  final http.Client client;

  Future<List<Book>> search(String query) async {
    final uri = Uri.https('openlibrary.org', '/search.json', {
      'q': query,
      'fields': 'key,title,author_name,first_publish_year,cover_i',
      'limit': '20',
    });
    final json = await getJson(client, uri, service: 'Open Library');
    final docs = json['docs'];
    if (docs is! List) {
      throw const ApiException('Open Library returned no book results.');
    }
    return docs.whereType<Map<String, dynamic>>().map(Book.fromJson).toList();
  }

  Future<BookDetails> getDetails(String workId) async {
    final json = await getJson(
      client,
      Uri.https('openlibrary.org', '/works/$workId.json'),
      service: 'Open Library',
    );
    final searchJson = await getJson(
      client,
      Uri.https('openlibrary.org', '/search.json', {
        'q': 'key:/works/$workId',
        'fields': 'key,first_publish_year',
        'limit': '1',
      }),
      service: 'Open Library',
    );
    final summary = switch (json['description']) {
      final String text => text,
      {'value': final String text} => text,
      _ => 'No description yet.',
    };
    final covers = json['covers'];
    final coverId = covers is List && covers.isNotEmpty
        ? covers.first as int?
        : null;
    final searchResults = searchJson['docs'];
    final year = searchResults is List && searchResults.isNotEmpty
        ? (searchResults.first as Map<String, dynamic>)['first_publish_year']
              as int?
        : null;
    return BookDetails(
      title: json['title'] as String? ?? 'Book details',
      summary: summary,
      coverId: coverId,
      year: year,
    );
  }
}
