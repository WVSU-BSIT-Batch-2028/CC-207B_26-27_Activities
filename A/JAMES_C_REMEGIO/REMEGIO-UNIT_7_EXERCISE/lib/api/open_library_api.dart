import 'package:http/http.dart' as http;

import '../models/book.dart';
import '../models/book_details.dart';
import 'api_exception.dart';
import 'http_json.dart';

/// Open Library search and work details. No API key.
class OpenLibraryApi {
  OpenLibraryApi({http.Client? client})
      : _client = client ?? http.Client(),
        _ownsClient = client == null;

  final http.Client _client;
  final bool _ownsClient;

  static const Map<String, String> _headers = <String, String>{
    'User-Agent': 'remegio_unit7_exercise (CC 207B student project)',
    'Accept': 'application/json',
  };

  Future<List<Book>> search(String query) async {
    final Uri uri = Uri.https('openlibrary.org', '/search.json', {
      'q': query.trim(),
      'fields': 'key,title,author_name,first_publish_year,cover_i',
      'limit': '20',
    });
    final Map<String, dynamic> json = await getJsonMap(
      _client,
      uri,
      service: 'Open Library',
      headers: _headers,
    );
    return booksFromSearch(json);
  }

  Future<BookDetails> fetchWork(String workId) async {
    final String id = workId.trim();
    if (id.isEmpty) {
      throw const ApiException('This book has no work ID.');
    }
    final Uri uri = Uri.https('openlibrary.org', '/works/$id.json');
    final Map<String, dynamic> json = await getJsonMap(
      _client,
      uri,
      service: 'Open Library',
      headers: _headers,
    );
    return BookDetails.fromWorkJson(json);
  }

  void close() {
    if (_ownsClient) _client.close();
  }
}

/// Reads the `docs` array. A missing `docs` list is an error, not an empty shelf.
List<Book> booksFromSearch(Object? json) {
  if (json is! Map) {
    throw const ApiException(
      'Open Library sent a response the app could not read.',
    );
  }
  final Object? docs = json['docs'];
  if (docs is! List) {
    throw const ApiException(
      'Open Library sent a response the app could not read.',
    );
  }
  final List<Book> books = <Book>[];
  for (final Object? doc in docs) {
    if (doc is! Map) {
      throw const ApiException(
        'Open Library sent a book the app could not read.',
      );
    }
    try {
      books.add(Book.fromJson(Map<String, dynamic>.from(doc)));
    } on TypeError {
      throw const ApiException(
        'Open Library sent a book the app could not read.',
      );
    }
  }
  return books;
}
