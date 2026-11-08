import 'package:http/http.dart' as http;

import '../../models/fair_event.dart';
import '../event_source.dart';

/// Strapi 5 (headless CMS), REST API.
///
/// Content-Type Builder: collection type "Fair Event"
/// (API ID: fair-event, so the URL uses the plural fair-events).
/// Fields: title (Short text), orgId (Short text), startsAt (Datetime),
/// venue (Short text), description (Long text), cancelled (Boolean).
///
/// Strapi 5 answers:
/// { "data": [ { "id": 2, "documentId": "k7f2a9", "title": "Hour of Code",
///               "orgId": "csc", "startsAt": "2026-11-08T05:00:00.000Z",
///               "venue": "CICT Lab 2", "description": null,
///               "cancelled": false, "publishedAt": "..." } ],
///   "meta": { "pagination": { ... } } }
class StrapiEventSource implements EventSource {
  StrapiEventSource(this.client, {required this.baseUrl, this.token = ''});

  final http.Client client;

  /// Your server, e.g. http://localhost:1337 (no slash at the end).
  final String baseUrl;

  /// Empty when the Public role may read fair-events.
  final String token;

  @override
  String get name => 'Strapi';

  @override
  Future<List<FairEvent>> fetchEvents() async {
    // TODO 2 (Strapi): Build the request.
    //   URL:     $baseUrl/api/fair-events
    //   Query:   sort=startsAt:asc and pagination[pageSize]=100
    //            (use Uri.parse(...).replace(queryParameters: {...}))
    //   Headers: 'Authorization': 'Bearer $token', only when token is not empty
    final uri = Uri.parse('$baseUrl/api/fair-events').replace(
      queryParameters: {
        'sort': 'startsAt:asc',
        'pagination[pageSize]': '100',
      },
    );
    final headers = <String, String>{};
    if (token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    final json = await getJson(client, uri, cms: name, headers: headers);

    final items = (json as Map<String, dynamic>)['data'] as List<dynamic>;
    return [
      for (final item in items)
        FairEvent(
          id: (item as Map<String, dynamic>)['documentId'] as String,
          orgId: item['orgId'] as String,
          title: item['title'] as String,
          startsAt: DateTime.parse(item['startsAt'] as String),
          venue: item['venue'] as String,
          description: (item['description'] as String?) ?? '',
          cancelled: item['cancelled'] as bool? ?? false,
        ),
    ];
  }
}
