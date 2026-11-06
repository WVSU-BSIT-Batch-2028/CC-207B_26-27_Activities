
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/pick.dart';
import 'pick_source.dart';

class ContentfulApi implements PickSource {
  final String _spaceId =
      const String.fromEnvironment('CMS_SPACE');

  final String _token =
      const String.fromEnvironment('CMS_TOKEN');

  @override
  Future<List<Pick>> fetchPicks() async {
    if (_spaceId.isEmpty || _token.isEmpty) {
      throw Exception('Contentful configuration is missing.');
    }

    final uri = Uri.https(
      'cdn.contentful.com',
      '/spaces/$_spaceId/environments/master/entries',
      {
        'content_type': 'pick',
      },
    );

    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $_token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to load picks: ${response.statusCode}',
      );
    }

    final json = jsonDecode(response.body)
        as Map<String, dynamic>;

    final items = json['items'] as List<dynamic>;

    return items.map((item) {
      final fields = item['fields'] as Map<String, dynamic>;

      String getField(String name) {
        final value = fields[name];

        if (value is Map<String, dynamic>) {
          return value.values.first.toString();
        }

        return value?.toString() ?? '';
      }

      return Pick.fromJson({
        'title': getField('title'),
        'kind': getField('kind'),
        'externalId': getField('externalId'),
        'note': getField('note'),
      });
    }).toList();
  }
}
