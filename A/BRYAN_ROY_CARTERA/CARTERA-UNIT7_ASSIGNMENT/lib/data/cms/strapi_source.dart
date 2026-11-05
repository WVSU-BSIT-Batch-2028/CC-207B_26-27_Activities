import 'package:http/http.dart' as http;

import '../../models/fair_event.dart';
import '../event_source.dart';

class StrapiEventSource implements EventSource {
  StrapiEventSource(
    this.client, {
    required this.baseUrl,
    this.token = '',
  });

  final http.Client client;
  final String baseUrl;
  final String token;

  @override
  String get name => 'Strapi';

  @override
  Future<List<FairEvent>> fetchEvents() async {
    // Build the Strapi API request.
    final uri = Uri.parse('$baseUrl/api/fair-events').replace(
      queryParameters: {
        'sort': 'startsAt:asc',
        'pagination[pageSize]': '100',
      },
    );

    // Add authorization only when a token is provided.
    final headers = <String, String>{};

    if (token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    // Get JSON response.
    final responseJson = await getJson(
      client,
      uri,
      cms: name,
      headers: headers,
    );

    // Check and convert JSON response.
    if (responseJson is! Map<String, dynamic>) {
      throw CmsException('Invalid response from Strapi.');
    }

    final data = responseJson['data'] as List<dynamic>;

    // Convert Strapi entries into FairEvent objects.
    return data.map((item) {
      final event = item as Map<String, dynamic>;

      return FairEvent(
        id: event['documentId'] as String,
        title: event['title'] as String? ?? '',
        orgId: event['orgId'] as String? ?? '',
        startsAt: DateTime.parse(event['startsAt'] as String),
        venue: event['venue'] as String? ?? '',
        description: event['description'] as String? ?? '',
        cancelled: event['cancelled'] as bool? ?? false,
      );
    }).toList();
  }
}
