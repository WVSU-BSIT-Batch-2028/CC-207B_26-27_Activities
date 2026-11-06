import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/pick.dart';
import 'pick_source.dart';
import 'api_exception.dart';

class ContentfulPickSource implements PickSource {
  ContentfulPickSource({
    required this.spaceId,
    required this.environment,
    required this.deliveryToken,
    http.Client? client,
  }) : _client = client ?? http.Client();

  final String spaceId;
  final String environment;
  final String deliveryToken;
  final http.Client _client;

  @override
  Future<List<Pick>> fetchPicks() async {
    final uri = Uri.https(
      'cdn.contentful.com',
      '/spaces/$spaceId/environments/$environment/entries',
      {
        'access_token': deliveryToken,
        'content_type': 'pick',
        'limit': '100',
      },
    );

    final response = await _client.get(uri);
    if (response.statusCode != 200) {
      throw ApiException('Contentful request failed (${response.statusCode}).');
    }

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final items = body['items'] as List<dynamic>;

    return items
        .map((item) => Pick.fromContentful(
              Map<String, dynamic>.from(item as Map),
            ))
        .toList();
  }
}
