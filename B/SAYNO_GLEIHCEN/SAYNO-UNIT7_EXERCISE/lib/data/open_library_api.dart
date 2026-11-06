import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/book.dart';
import '../models/pick_details.dart';

/// A problem the user should read: no internet, a bad answer, and so on.
class ApiException implements Exception {
  const ApiException(this.message);

  final String message;

  @override
  String toString() => message;
}

class OpenLibraryApi {
  OpenLibraryApi({http.Client? client}) : client = client ?? http.Client();

  final http.Client client;

  Future<Map<String, dynamic>> _getJson(Uri uri) async {
    final http.Response response;
    try {
      response = await client.get(uri).timeout(const Duration(seconds: 10));
    } on TimeoutException {
      throw const ApiException('Open Library took too long. Try again.');
    } on http.ClientException {
      throw const ApiException('No connection. Check your internet.');
    }
    if (response.statusCode != 200) {
      throw ApiException('Open Library answered ${response.statusCode}.');
    }
    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  Future<List<Book>> search(String query) async {
    // Uri.https encodes the spaces for you.
    final uri = Uri.https('openlibrary.org', '/search.json', {
      'q': query,
      'fields': 'key,title,author_name,first_publish_year,cover_i',
      'limit': '20',
    });
    final json = await _getJson(uri);
    final docs = json['docs'] as List<dynamic>? ?? const [];
    return [
      for (final doc in docs) Book.fromJson(doc as Map<String, dynamic>),
    ];
  }

  /// Details of one book by its work ID, e.g. OL27482W.
  Future<PickDetails> details(String workId) async {
    final json = await _getJson(Uri.https('openlibrary.org', '/works/$workId.json'));

    // The description comes in two shapes; a switch handles both.
    final description = switch (json['description']) {
      final String text => text, // "description": "..."
      {'value': final String text} => text, // "description": {"type":..., "value":...}
      _ => 'No description yet.',
    };

    final covers = json['covers'] as List<dynamic>?;
    final coverId = (covers == null || covers.isEmpty) ? null : covers.first;

    return PickDetails(
      title: json['title'] as String? ?? '',
      summary: description,
      imageUrl: coverId == null
          ? null
          : 'https://covers.openlibrary.org/b/id/$coverId-L.jpg',
    );
  }
}