import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/pick.dart';
import 'api_exception.dart';

abstract class PickSource {
  Future<List<Pick>> fetchPicks();
}

class ContentfulPickSource implements PickSource {
  static const _space = String.fromEnvironment('CMS_SPACE');
  static const _token = String.fromEnvironment('CMS_TOKEN');

  @override
  Future<List<Pick>> fetchPicks() async {
    if (_space.isEmpty || _token.isEmpty) {
      throw ApiException(
        'CMS_SPACE or CMS_TOKEN is missing. Run with --dart-define-from-file=cms.json',
      );
    }
    final uri = Uri.https(
      'cdn.contentful.com',
      '/spaces/$_space/environments/master/entries',
      {'content_type': 'pick'},
    );
    final response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $_token'},
    );

    switch (response.statusCode) {
      case 200:
        break;
      case 401:
      case 403:
        throw ApiException(
          'The CMS token is wrong. Use the Content Delivery token.',
        );
      case 404:
        throw ApiException('CMS not found. Check CMS_SPACE.');
      default:
        throw ApiException('CMS error (${response.statusCode}).');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final items = (json['items'] as List<dynamic>?) ?? const [];
    return items.map((i) => Pick.fromJson(i as Map<String, dynamic>)).toList();
  }
}
