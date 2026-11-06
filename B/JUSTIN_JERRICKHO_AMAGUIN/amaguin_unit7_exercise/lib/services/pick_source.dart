import 'package:http/http.dart' as http;

import '../models/pick.dart';
import 'http_json.dart';
import 'api_exception.dart';

abstract interface class PickSource {
  Future<List<Pick>> fetchPicks();
}

class ContentfulPickSource implements PickSource {
  ContentfulPickSource({
    required this.space,
    required this.token,
    this.environment = 'master',
    http.Client? client,
  }) : _client = client ?? http.Client();

  final String space;
  final String token;
  final String environment;
  final http.Client _client;

  @override
  Future<List<Pick>> fetchPicks() async {
    if (space.trim().isEmpty || token.trim().isEmpty) {
      throw const ApiException(
        'Add CMS_SPACE and CMS_TOKEN to cms.json, then restart with --dart-define-from-file=cms.json.',
      );
    }
    final json = await getJson(
      _client,
      Uri.https(
        'cdn.contentful.com',
        '/spaces/$space/environments/$environment/entries',
        {'content_type': 'pick', 'order': 'sys.createdAt', 'limit': '1000'},
      ),
      headers: {'Authorization': 'Bearer $token'},
    );
    final items = json['items'];
    if (items is! List) {
      throw const ApiException('Contentful returned an unexpected response.');
    }
    return items
        .map(
          (item) => Pick.fromJson(
            (item as Map<String, dynamic>)['fields'] as Map<String, dynamic>? ??
                const {},
          ),
        )
        .toList();
  }

  void close() => _client.close();
}
