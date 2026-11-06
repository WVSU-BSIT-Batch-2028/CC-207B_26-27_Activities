import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/pick.dart';
import 'pick_source.dart';

const contentfulSpaceId =
    String.fromEnvironment('CONTENTFUL_SPACE_ID');

const contentfulToken =
    String.fromEnvironment('CONTENTFUL_DELIVERY_TOKEN');

const contentfulEnvironment =
    String.fromEnvironment(
  'CONTENTFUL_ENVIRONMENT',
  defaultValue: 'master',
);

class ContentfulPickSource implements PickSource {
  @override
  Future<List<Pick>> fetchPicks() async {
    if (contentfulSpaceId.isEmpty || contentfulToken.isEmpty) {
      throw Exception('Contentful credentials are missing.');
    }

    final uri = Uri.https(
      'cdn.contentful.com',
      '/spaces/$contentfulSpaceId/environments/$contentfulEnvironment/entries',
      {
        'content_type': 'pick',
        'limit': '100',
      },
    );

    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $contentfulToken',
      },
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to load Picks: ${response.statusCode} ${response.body}',
      );
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final items = data['items'] as List<dynamic>? ?? [];

    return items
        .map((item) => Pick.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}