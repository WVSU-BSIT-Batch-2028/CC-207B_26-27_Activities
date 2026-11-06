import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/pick.dart';

abstract class PickSource {
  Future<List<Pick>> fetchPicks();
}

class ContentfulPickSource implements PickSource {
  static const String spaceId = 'y9l8rb7doxmn';
  static const String environment = 'master';

  final String accessToken = const String.fromEnvironment('CONTENTFUL_TOKEN');

  @override
  Future<List<Pick>> fetchPicks() async {
    if (accessToken.isEmpty) {
      throw Exception('Contentful access token is missing.');
    }

    final uri = Uri.https(
      'cdn.contentful.com',
      '/spaces/$spaceId/environments/$environment/entries',
      {'content_type': 'pick', 'access_token': accessToken},
    );

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to load picks: ${response.statusCode}\n${response.body}',
      );
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;

    final List<dynamic> items = data['items'] ?? [];

    return items
        .map((item) => Pick.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
