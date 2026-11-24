import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pick.dart';

abstract class PickSource {
  Future<List<Pick>> fetchPicks();
}

class ContentfulPickSource implements PickSource {
  final String spaceId;
  final String token;
  final String environment;
  final http.Client _client;

  ContentfulPickSource({
    String? spaceId,
    String? token,
    String? environment,
    http.Client? client,
  })  : spaceId = (spaceId != null && spaceId.isNotEmpty)
            ? spaceId
            : const String.fromEnvironment('CMS_SPACE_ID',
                defaultValue: 'a9iyylcfbwl9'),
        token = (token != null && token.isNotEmpty)
            ? token
            : const String.fromEnvironment('CMS_TOKEN',
                defaultValue:
                    'bcwq41k3bJ4VrEnaBRAN-jQrZAP6rn4xvJBL_Jj6nNw'),
        environment = (environment != null && environment.isNotEmpty)
            ? environment
            : const String.fromEnvironment('CMS_ENV', defaultValue: 'master'),
        _client = client ?? http.Client();

  @override
  Future<List<Pick>> fetchPicks() async {
    // Try both tokens in case one has different environment permissions
    final tokensToTry = <String>{
      token.trim(),
      '9Zo3rEzErNz14qTel5WqhR7Y9W9jAZt58zj-dVBTgEo',
      'bcwq41k3bJ4VrEnaBRAN-jQrZAP6rn4xvJBL_Jj6nNw',
    }.toList();

    for (final t in tokensToTry) {
      if (t.isEmpty) continue;
      try {
        final uri = Uri.https(
          'cdn.contentful.com',
          '/spaces/$spaceId/environments/$environment/entries',
          {
            'content_type': 'pick',
            'access_token': t,
          },
        );

        final response = await _client.get(
          uri,
          headers: {'Authorization': 'Bearer $t'},
        );

        if (response.statusCode == 200) {
          final json = jsonDecode(response.body) as Map<String, dynamic>;
          final items = (json['items'] as List<dynamic>?) ?? [];
          final picks = items
              .map((item) => Pick.fromContentful(item as Map<String, dynamic>))
              .toList();

          if (picks.isNotEmpty) {
            return picks;
          }
        }
      } catch (_) {
        // Try next token or fallback
      }
    }

    // Default fallback sample picks if CMS has no published picks yet or network is down
    return fallbackPicks;
  }

  static const List<Pick> fallbackPicks = [
    Pick(
      id: 'pick-1',
      title: 'Noli Me Tangere',
      kind: 'book',
      externalId: 'OL1942004W',
      note: 'Every Filipino should read it once, outside of class.',
    ),
    Pick(
      id: 'pick-2',
      title: 'The Hobbit',
      kind: 'book',
      externalId: 'OL27482W',
      note: 'The first fantasy book I finished in one weekend.',
    ),
    Pick(
      id: 'pick-3',
      title: 'Interstellar',
      kind: 'movie',
      externalId: 'tt0816692',
      note: 'Watch it for the soundtrack. Bring tissue.',
    ),
    Pick(
      id: 'pick-4',
      title: 'Inception',
      kind: 'movie',
      externalId: 'tt1375666',
      note: 'A cinematic masterpiece in storytelling and visual effects.',
    ),
  ];
}
