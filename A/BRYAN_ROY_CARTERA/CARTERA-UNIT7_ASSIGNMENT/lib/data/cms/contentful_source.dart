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
    // Build Contentful API request.
    final uri = Uri.https(
      'cdn.contentful.com',
      '/spaces/$spaceId/environments/$environment/entries',
      {
        'content_type': 'fairEvent',
        'order': 'fields.startsAt',
        'limit': '100',
      },
    );

    // Authorization header.
    final headers = <String, String>{
      'Authorization': 'Bearer $token',
    };

    // Get JSON response.
    final responseJson = await getJson(
      client,
      uri,
      cms: name,
      headers: headers,
    );

    // Convert JSON response into a Map.
    if (responseJson is! Map<String, dynamic>) {
      throw CmsException('Invalid response from Contentful.');
    }

    final items = responseJson['items'] as List<dynamic>;

    // Convert Contentful entries into FairEvent objects.
    return items.map((item) {
      final sys = item['sys'] as Map<String, dynamic>;
      final fields = item['fields'] as Map<String, dynamic>;

      return FairEvent(
        id: sys['id'] as String,
        title: fields['title'] as String? ?? '',
        orgId: fields['orgId'] as String? ?? '',
        startsAt: DateTime.parse(fields['startsAt'] as String),
        venue: fields['venue'] as String? ?? '',
        description: fields['description'] as String? ?? '',
        cancelled: fields['cancelled'] as bool? ?? false,
      );
    }).toList();
  }
}
