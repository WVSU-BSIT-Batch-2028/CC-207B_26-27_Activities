
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/pick.dart';

abstract class PickSource {
  Future<List<Pick>> fetchPicks();
}

class ContentfulApi implements PickSource {
  static const String _spaceId =
      String.fromEnvironment('CONTENTFUL_SPACE_ID');

  static const String _accessToken =
      String.fromEnvironment('CONTENTFUL_ACCESS_TOKEN');

  @override
  Future<List<Pick>> fetchPicks() async {
    if (_spaceId.isEmpty || _accessToken.isEmpty) {
      throw Exception('Contentful credentials are missing.');
    }

    final uri = Uri.https(
      'cdn.contentful.com',
      '/spaces/$_spaceId/environments/master/entries',
      {
        'access_token': _accessToken,
        'content_type': 'pick',
      },
    );

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Failed to load picks: ${response.statusCode}');
    }

    final data = jsonDecode(response.body);
    final List items = data['items'] ?? [];

    return items.map((item) {
      final fields = item['fields'] as Map<String, dynamic>;

      return Pick(
        title: _getField(fields, 'title'),
        kind: _getField(fields, 'kind'),
        externalId: _getField(fields, 'externalId'),
        note: _getField(fields, 'note'),
      );
    }).toList();
  }

  String _getField(Map<String, dynamic> fields, String name) {
    final value = fields[name];

    if (value == null) return '';

    if (value is Map) {
      return value.values.first.toString();
    }

    return value.toString();
  }
}
