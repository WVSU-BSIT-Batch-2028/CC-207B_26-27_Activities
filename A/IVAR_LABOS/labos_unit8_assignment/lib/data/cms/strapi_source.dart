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
    // DONE 2 (Strapi): Build the request.
    //   URL:     $baseUrl/api/fair-events
    //   Query:   sort=startsAt:asc and pagination[pageSize]=100
    //            (use Uri.parse(...).replace(queryParameters: {...}))
    //   Headers: 'Authorization': 'Bearer $token', only when token is not empty
    final uri = Uri.parse('$baseUrl/api/fair-events').replace(
      queryParameters: {'sort': 'startsAt:asc', 'pagination[pageSize]': '100'},
    );
    final headers = <String, String>{
      if (token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
    // EXPLAIN E3: Open one of the other two CMS files and compare. Which
    // lines differ, and which are the same? Why is the parsing the part
    // that changes most from one CMS to another?
    //
    // ANSWER E3: The same in all three: build a Uri and the headers, call
    // getJson(), then loop over the list and build FairEvent objects. What
    // differs is the URL and query parameter names (sort/pagination vs
    // order/limit vs a GROQ query), whether the Authorization header is always
    // sent, and above all the JSON shape: Strapi has data[] with documentId,
    // Contentful has items[] with sys.id and fields{}, Sanity has result[] with
    // _id. Parsing changes the most because each CMS wraps and names the same
    // data differently, while the request and the HTTP errors are the same.
    final json = await getJson(client, uri, cms: name, headers: headers);

    // DONE 3 (Strapi): Turn the JSON into a List<FairEvent>.
    //   The list is in json['data']. For each item use documentId as the id.
    //   description can be null and cancelled can be null: use ?? '' and ?? false.
    //   startsAt is a String: DateTime.parse(...)
    final data = (json as Map<String, dynamic>)['data'] as List<dynamic>;
    return [
      for (final item in data.cast<Map<String, dynamic>>())
        FairEvent(
          id: item['documentId'] as String,
          orgId: item['orgId'] as String,
          title: item['title'] as String,
          startsAt: DateTime.parse(item['startsAt'] as String),
          venue: item['venue'] as String,
          description: (item['description'] as String?) ?? '',
          cancelled: (item['cancelled'] as bool?) ?? false,
        ),
    ];
  }
}
