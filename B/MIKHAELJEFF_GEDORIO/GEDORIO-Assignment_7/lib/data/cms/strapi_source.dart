
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
    // TODO 2 completed: Build the Strapi request.
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

    // TODO 3 completed: Convert Strapi JSON into FairEvent objects.
    final json = await getJson(client, uri, cms: name, headers: headers)
        as Map<String, dynamic>;

    final data = json['data'] as List<dynamic>;

    return data.map((item) {
      final event = item as Map<String, dynamic>;

      return FairEvent(
        id: event['documentId'] as String,
        orgId: event['orgId'] as String,
        title: event['title'] as String,
        startsAt: DateTime.parse(event['startsAt'] as String),
        venue: event['venue'] as String,
        description: event['description'] as String? ?? '',
        cancelled: event['cancelled'] as bool? ?? false,
      );
    }).toList();
  }
}
