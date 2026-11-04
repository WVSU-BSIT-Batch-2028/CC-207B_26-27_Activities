
import 'package:http/http.dart' as http;

import '../../models/fair_event.dart';
import '../event_source.dart';

/// Sanity (hosted headless CMS), HTTP Query API with GROQ.
class SanityEventSource implements EventSource {
  SanityEventSource(
    this.client, {
    required this.projectId,
    this.dataset = 'production',
    this.token = '',
  });

  final http.Client client;
  final String projectId;
  final String dataset;
  final String token;

  /// The query, in GROQ: all fairEvent documents, oldest first,
  /// with only the fields the app needs.
  static const query =
      '*[_type == "fairEvent"] | order(startsAt asc) '
      '{_id, title, orgId, startsAt, venue, description, cancelled}';

  @override
  String get name => 'Sanity';

  @override
  Future<List<FairEvent>> fetchEvents() async {
    final uri = Uri.https(
      '$projectId.apicdn.sanity.io',
      '/v2025-02-19/data/query/$dataset',
      {'query': query},
    );

    final headers = <String, String>{};
    if (token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    final json =
        await getJson(client, uri, cms: name, headers: headers)
            as Map<String, dynamic>;

    final items = json['result'] as List<dynamic>;

    return items.map((item) {
      final event = item as Map<String, dynamic>;

      return FairEvent(
        id: event['_id'] as String,
        orgId: event['orgId'] as String? ?? '',
        title: event['title'] as String? ?? '',
        startsAt: DateTime.parse(event['startsAt'] as String),
        venue: event['venue'] as String? ?? '',
        description: event['description'] as String? ?? '',
        cancelled: event['cancelled'] as bool? ?? false,
      );
    }).toList();
  }
}
