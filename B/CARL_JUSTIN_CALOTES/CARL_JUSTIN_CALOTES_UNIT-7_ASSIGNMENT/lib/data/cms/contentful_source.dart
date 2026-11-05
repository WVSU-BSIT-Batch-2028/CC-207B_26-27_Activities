
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
    // TODO 2: Build the Contentful Delivery API request.
    final uri = Uri.https(
      'cdn.contentful.com',
      '/spaces/$spaceId/environments/$environment/entries',
      {
        'content_type': 'fairEvent',
        'order': 'fields.startsAt',
        'limit': '100',
      },
    );

    final headers = <String, String>{
      'Authorization': 'Bearer $token',
    };

    final json = await getJson(client, uri, cms: name, headers: headers);

    // TODO 3: Convert Contentful entries into FairEvent objects.
    final response = json as Map<String, dynamic>;
    final items = response['items'] as List<dynamic>;

    return items.map((item) {
      final entry = item as Map<String, dynamic>;
      final fields = entry['fields'] as Map<String, dynamic>;
      final sys = entry['sys'] as Map<String, dynamic>;

      return FairEvent(
        id: sys['id'] as String,
        orgId: fields['orgId'] as String,
        title: fields['title'] as String,
        startsAt: DateTime.parse(fields['startsAt'] as String),
        venue: fields['venue'] as String,
        description: fields['description'] as String? ?? '',
        cancelled: fields['cancelled'] as bool? ?? false,
      );
    }).toList();
  }
}
