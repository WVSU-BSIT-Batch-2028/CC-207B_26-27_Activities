import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/pick.dart';
import 'api_exception.dart';

abstract class PickSource {
  Future<List<Pick>> fetchPicks();
}

class ContentfulPickSource implements PickSource {
  final http.Client client;
  final String spaceId;
  final String token;

  ContentfulPickSource(
    this.client, {
    required this.spaceId,
    required this.token,
  });

  @override
  Future<List<Pick>> fetchPicks() async {
    if (spaceId.isEmpty || token.isEmpty) {
      throw const ApiException('Contentful Space ID or Token is missing.');
    }

    final uri = Uri.https(
      'cdn.contentful.com',
      '/spaces/$spaceId/environments/master/entries',
      {
        'content_type': 'pick',
        'access_token': token,
      },
    );

    final response = await client.get(uri);
    if (response.statusCode == 401 || response.statusCode == 403) {
      throw const ApiException('Invalid Contentful access token.');
    } else if (response.statusCode == 404) {
      throw const ApiException('Contentful space or content type not found.');
    } else if (response.statusCode >= 500) {
      throw const ApiException('Contentful server error. Try again later.');
    } else if (response.statusCode != 200) {
      throw ApiException('Contentful error (${response.statusCode})');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final items = json['items'] as List<dynamic>? ?? [];
    return items
        .map((entry) => Pick.fromContentful(entry as Map<String, dynamic>))
        .toList();
  }
}

