import 'dart:convert';

import 'package:http/http.dart' as http;

import 'api_exception.dart';
import 'config.dart';
import 'http_helper.dart';
import 'pick.dart';
import 'pick_source.dart';

/// Picks from Contentful (content type ID: pick), Content Delivery API.
/// Same URL style, Bearer token and JSON shape as the Unit 7 assignment.
class ContentfulPickSource implements PickSource {
  ContentfulPickSource(
    this.client, {
    this.spaceId = cmsSpace,
    this.token = cmsToken,
    this.environment = 'master',
  });

  final http.Client client;
  final String spaceId;
  final String token;
  final String environment;

  @override
  Future<List<Pick>> fetchPicks() async {
    if (spaceId.isEmpty || token.isEmpty) {
      throw const ApiException(
        'The CMS is not set. Run with --dart-define-from-file=cms.json',
      );
    }
    final uri = Uri.https(
      'cdn.contentful.com',
      '/spaces/$spaceId/environments/$environment/entries',
      {'content_type': 'pick', 'limit': '100'},
    );
    final body = await fetchBody(
      client,
      uri,
      name: 'Contentful',
      headers: {'Authorization': 'Bearer $token'},
    );
    final json = jsonDecode(body) as Map<String, dynamic>;
    final items = json['items'] as List<dynamic>? ?? const [];
    final picks = <Pick>[];
    for (final item in items) {
      final entry = item as Map<String, dynamic>;
      final sys = entry['sys'] as Map<String, dynamic>? ?? const {};
      // Contentful leaves out empty fields, so a missing one becomes ''.
      final fields = entry['fields'] as Map<String, dynamic>? ?? const {};
      picks.add(
        Pick(
          id: sys['id'] as String? ?? '',
          title: fields['title'] as String? ?? '',
          kind: fields['kind'] as String? ?? '',
          externalId: fields['externalId'] as String? ?? '',
          note: fields['note'] as String? ?? '',
        ),
      );
    }
    return picks;
  }
}

