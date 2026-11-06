import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/pick.dart';
import 'pick_source.dart';

class ContentfulPickSource implements PickSource {
  static const String _spaceId =
      String.fromEnvironment('CMS_SPACE');

  static const String _token =
      String.fromEnvironment('CMS_TOKEN');

  static const String _environment =
      String.fromEnvironment(
    'CMS_ENVIRONMENT',
    defaultValue: 'master',
  );

  @override
  Future<List<Pick>> fetchPicks() async {
    if (_spaceId.isEmpty || _token.isEmpty) {
      throw Exception(
        'Contentful configuration is missing.',
      );
    }

    final uri = Uri.https(
      'cdn.contentful.com',
      '/spaces/$_spaceId/environments/$_environment/entries',
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
        'Failed to load picks. Status code: ${response.statusCode}',
      );
    }

    final data = jsonDecode(response.body)
        as Map<String, dynamic>;

    final items = data['items'] as List<dynamic>? ?? [];

    return items.map((item) {
      final fields =
          item['fields'] as Map<String, dynamic>;

      return Pick.fromJson(fields);
    }).toList();
  }
}
