import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/pick.dart';
import 'open_library_api.dart' show ApiException;

/// The screens only know this interface, not which CMS is behind it.
abstract interface class PickSource {
  Future<List<Pick>> fetchPicks();
}

/// Sanity (HTTP Query API with GROQ), type name 'pick'.
class SanityPickSource implements PickSource {
  SanityPickSource({
    required this.projectId,
    this.dataset = 'production',
    http.Client? client,
  }) : client = client ?? http.Client();

  final String projectId;
  final String dataset;
  final http.Client client;

  static const query =
      '*[_type == "pick"] | order(_createdAt asc) '
      '{_id, title, kind, externalId, note}';

  @override
  Future<List<Pick>> fetchPicks() async {
    if (projectId.isEmpty) {
      throw const ApiException(
        'No CMS project yet. Run with --dart-define-from-file=cms.json',
      );
    }
    final uri = Uri.https(
      '$projectId.apicdn.sanity.io',
      '/v2025-02-19/data/query/$dataset',
      {'query': query},
    );

    final http.Response response;
    try {
      response = await client.get(uri).timeout(const Duration(seconds: 10));
    } on TimeoutException {
      throw const ApiException('Sanity took too long. Try again.');
    } on http.ClientException {
      throw const ApiException('No connection. Check your internet.');
    }

    final code = response.statusCode;
    if (code == 404) {
      throw const ApiException('Sanity could not find the picks (404).');
    }
    if (code >= 500) {
      throw ApiException('Sanity is having problems ($code). Try again later.');
    }
    if (code != 200) {
      throw ApiException('Sanity answered $code.');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final result = json['result'] as List<dynamic>? ?? const [];
    return [
      for (final item in result.cast<Map<String, dynamic>>())
        Pick(
          id: item['_id'] as String,
          title: item['title'] as String? ?? '',
          kind: item['kind'] == 'movie' ? PickKind.movie : PickKind.book,
          externalId: item['externalId'] as String? ?? '',
          note: item['note'] as String? ?? '',
        ),
    ];
  }
}