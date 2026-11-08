import 'package:http/http.dart' as http;

import '../../models/fair_event.dart';
import '../event_source.dart';

/// Contentful (hosted headless CMS), Content Delivery API.
///
/// Content model in the configured space: "Fair Event" with the API
/// identifier codeCampusChallenge.
/// Fields (field ID: type): title: Short text, orgId: Short text,
/// startsAt: Date and time, venue: Short text, description: Long text,
/// cancelled: Boolean.
///
/// Contentful answers:
/// { "sys": { "type": "Array" }, "total": 9, "skip": 0, "limit": 100,
///   "items": [ { "sys": { "id": "3xYz...", "type": "Entry", ... },
///                "fields": { "title": "Hour of Code", "orgId": "csc",
///                            "startsAt": "2026-11-08T13:00+08:00",
///                            "venue": "CICT Lab 2" } } ] }
/// A field left empty is not sent at all, so fields['description'] is null.
class ContentfulEventSource implements EventSource {
  ContentfulEventSource(
    this.client, {
    required this.spaceId,
    required this.token,
    this.environment = 'master',
  });

  final http.Client client;
  final String spaceId;

  /// The Content Delivery API access token (read-only, published entries).
  /// Never the Content Management token.
  final String token;
  final String environment;

  @override
  String get name => 'Contentful';

  @override
  Future<List<FairEvent>> fetchEvents() async {
    // The configured Contentful space uses codeCampusChallenge as the API id.
    //   Headers: 'Authorization': 'Bearer $token'
    final uri = Uri.https(
      'cdn.contentful.com',
      '/spaces/$spaceId/environments/$environment/entries',
      {
        'content_type': 'codeCampusChallenge',
        'order': 'fields.startsAt',
        'limit': '100',
      },
    );
    final headers = <String, String>{'Authorization': 'Bearer $token'};
    final json = await getJson(client, uri, cms: name, headers: headers);

    final items = (json as Map<String, dynamic>)['items'] as List<dynamic>;
    final events = <FairEvent>[];
    for (final rawItem in items) {
      final item = rawItem as Map<String, dynamic>;
      final sys = item['sys'] as Map<String, dynamic>;
      final contentType = sys['contentType'];
      if (contentType is Map<String, dynamic>) {
        final contentTypeSys = contentType['sys'];
        if (contentTypeSys is Map<String, dynamic> &&
            contentTypeSys['id'] != 'codeCampusChallenge') {
          continue;
        }
      }

      final fields = item['fields'] as Map<String, dynamic>;
      events.add(
        FairEvent(
          id: sys['id'] as String,
          orgId: (fields['orgID'] ?? fields['orgId']) as String,
          title: fields['title'] as String,
          startsAt: DateTime.parse(fields['startsAt'] as String),
          venue: fields['venue'] as String,
          description: (fields['description'] as String?) ?? '',
          cancelled: (fields['cancelled'] as bool?) ?? false,
        ),
      );
    }
    events.sort((a, b) => a.startsAt.compareTo(b.startsAt));
    return events;
  }
}
