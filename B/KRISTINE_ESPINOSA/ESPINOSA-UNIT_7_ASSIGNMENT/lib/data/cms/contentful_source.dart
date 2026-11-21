import 'package:http/http.dart' as http;

import '../../models/fair_event.dart';
import '../event_source.dart';

class ContentfulEventSource implements EventSource {
  ContentfulEventSource(
    this.client, {
    required this.spaceId,
    required this.token,
    this.environment = 'master',
  });

  final http.Client client;
  final String spaceId;

  final String token;
  final String environment;

  @override
  String get name => 'Contentful';

  @override
  Future<List<FairEvent>> fetchEvents() async {
    final uri = Uri.https(
      'cdn.contentful.com',
      '/spaces/$spaceId/environments/$environment/entries',
      {
        'content_type': 'fairEvent',
        'order': 'fields.startsAt',
        'limit': '100',
      },
    );
    final headers = <String, String>{'Authorization': 'Bearer $token'};
    final json = await getJson(client, uri, cms: name, headers: headers);

    final items = (json as Map<String, dynamic>)['items'] as List<dynamic>;
    return [
      for (final item in items.cast<Map<String, dynamic>>())
        FairEvent(
          id: item['sys']['id'] as String,
          orgId: item['fields']['orgId'] as String? ?? '',
          title: item['fields']['title'] as String? ?? '',
          startsAt: DateTime.parse(item['fields']['startsAt'] as String),
          venue: item['fields']['venue'] as String? ?? '',
          description: item['fields']['description'] as String? ?? '',
          cancelled: item['fields']['cancelled'] as bool? ?? false,
        ),
    ];
  }
}
