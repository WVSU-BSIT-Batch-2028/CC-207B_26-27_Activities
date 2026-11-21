import 'package:http/http.dart' as http;

import '../models/pick.dart';
import 'api_exception.dart';

abstract interface class PickSource {
  String get name;

  Future<List<Pick>> fetchPicks();
}

class ContentfulPickSource implements PickSource {
  ContentfulPickSource(
    this.client, {
    required this.spaceId,
    required this.token,
    this.environment = 'master',
  });

  final http.Client client;
  final String spaceId;
  final String token;
  final String environment;

  @override
  String get name => 'Contentful';

  @override
  Future<List<Pick>> fetchPicks() async {
    if (spaceId.isEmpty || token.isEmpty) {
      throw const ApiException(
        'No CMS set. Run with --dart-define=CMS_SPACE=... and --dart-define=CMS_TOKEN=...',
      );
    }
    final uri = Uri.https(
      'cdn.contentful.com',
      '/spaces/$spaceId/environments/$environment/entries',
      {'content_type': 'pick', 'order': 'sys.createdAt', 'limit': '100'},
    );
    final json =
        await getJson(
              client,
              uri,
              name: name,
              headers: {'Authorization': 'Bearer $token'},
            )
            as Map<String, dynamic>;
    final items = json['items'] as List<dynamic>? ?? const [];
    return [
      for (final item in items.cast<Map<String, dynamic>>())
        Pick(
          id: item['sys']['id'] as String,
          title: item['fields']['title'] as String? ?? '',
          kind: (item['fields']['kind'] as String? ?? '').trim().toLowerCase() ==
                  'movie'
              ? PickKind.movie
              : PickKind.book,
          externalId: (item['fields']['externalId'] as String? ?? '').trim(),
          note: item['fields']['note'] as String? ?? '',
        ),
    ];
  }
}
