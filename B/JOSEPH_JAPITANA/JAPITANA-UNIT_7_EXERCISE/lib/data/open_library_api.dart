import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/book.dart';
import '../models/pick_details.dart';
import 'api_exception.dart';

class OpenLibraryApi {
  OpenLibraryApi({http.Client? client}) : client = client ?? http.Client();

  final http.Client client;

  Future<http.Response> _get(Uri uri) async {
    try {
      return await client.get(uri).timeout(const Duration(seconds: 10));
    } on TimeoutException {
      throw const ApiException('Open Library took too long. Try again.');
    } on http.ClientException {
      throw const ApiException(
        'No connection. Check your internet and try again.',
      );
    }
  }

  Future<List<Book>> search(String query) async {
    // Uri.https encodes spaces and special characters for you.
    final uri = Uri.https('openlibrary.org', '/search.json', {
      'q': query,
      'fields': 'key,title,author_name,first_publish_year,cover_i',
      'limit': '20',
    });

    final response = await _get(uri);

    if (response.statusCode == 422) {
      throw const ApiException('Try a more specific search.');
    }
    if (response.statusCode != 200) {
      throw ApiException('Open Library answered ${response.statusCode}.');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final docs = (json['docs'] as List<dynamic>?) ?? const [];
    return [
      for (final doc in docs) Book.fromJson(doc as Map<String, dynamic>),
    ];
  }

  Future<PickDetails> fetchWork(String workId) async {
    final response = await _get(
      Uri.https('openlibrary.org', '/works/$workId.json'),
    );

    if (response.statusCode == 404) {
      throw const ApiException('Open Library has no details for this book.');
    }
    if (response.statusCode != 200) {
      throw ApiException('Open Library answered ${response.statusCode}.');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;

    // The description is either plain text or an object like
    // {"type": "/type/text", "value": "..."}. It can also be missing.
    final description = switch (json['description']) {
      String text => text,
      {'value': String text} => text,
      _ => null,
    };

    final coverId = (json['covers'] as List<dynamic>?)
        ?.whereType<int>()
        .where((id) => id > 0)
        .firstOrNull;
    final date = json['first_publish_date'] as String?;

    return PickDetails(
      title: json['title'] as String? ?? 'Untitled',
      subtitle: date == null ? null : 'First published $date',
      description: description?.trim(),
      imageUrl: coverId == null
          ? null
          : 'https://covers.openlibrary.org/b/id/$coverId-L.jpg',
    );
  }
}