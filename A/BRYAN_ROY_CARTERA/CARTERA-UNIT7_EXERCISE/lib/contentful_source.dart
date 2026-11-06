
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'pick.dart';

abstract class PickSource {
  Future<List<Pick>> fetchPicks();
}

const String contentfulSpaceId =
    String.fromEnvironment('CONTENTFUL_SPACE_ID');

const String contentfulAccessToken =
    String.fromEnvironment('CONTENTFUL_ACCESS_TOKEN');

const String contentfulEnvironment =
    String.fromEnvironment(
  'CONTENTFUL_ENVIRONMENT',
  defaultValue: 'master',
);

class ContentfulPickSource implements PickSource {
  @override
  Future<List<Pick>> fetchPicks() async {
    if (contentfulSpaceId.isEmpty || contentfulAccessToken.isEmpty) {
      throw Exception(
        'Missing Contentful Space ID or Access Token. '
        'Check your cms.json file.',
      );
    }

    final uri = Uri.https(
      'cdn.contentful.com',
      '/spaces/$contentfulSpaceId/environments/'
          '$contentfulEnvironment/entries',
      {
        'access_token': contentfulAccessToken,
        'content_type': 'pick',
      },
    );

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception(
        'Contentful error: ${response.statusCode}\n'
        '${response.body}',
      );
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final items = data['items'] as List<dynamic>? ?? [];

    return items
        .where((item) => item is Map<String, dynamic>)
        .map((item) {
          final entry = item as Map<String, dynamic>;
          final fields =
              entry['fields'] as Map<String, dynamic>? ?? {};

          return Pick(
            id: entry['sys']?['id']?.toString() ?? '',
            title: _readField(fields['title']),
            kind: _readField(fields['kind']).toLowerCase().trim(),
            externalId: _readField(fields['externalId'])
                .trim()
                .replaceAll(' ', ''),
            note: _readField(fields['note']),
          );
        })
        .toList();
  }

  String _readField(dynamic value) {
    if (value == null) return '';

    if (value is Map<String, dynamic>) {
      if (value.containsKey('en-US')) {
        return _readField(value['en-US']);
      }

      if (value.containsKey('value')) {
        return _readField(value['value']);
      }

      if (value.isNotEmpty) {
        return _readField(value.values.first);
      }
    }

    return value.toString();
  }
}
