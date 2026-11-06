import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models.dart';

abstract interface class PickSource {
  Future<List<Pick>> fetchPicks();
}

class ContentfulPickSource implements PickSource {
  final String spaceId;
  final String accessToken;
  final http.Client client;

  ContentfulPickSource({
    required this.spaceId,
    required this.accessToken,
    http.Client? client,
  }) : client = client ?? http.Client();

  @override
  Future<List<Pick>> fetchPicks() async {
    final uri = Uri.https(
      'cdn.contentful.com',
      '/spaces/$spaceId/environments/master/entries',
      {
        'access_token': accessToken,
        'content_type': 'pick',
      },
    );

    final response = await client.get(uri);
    if (response.statusCode != 200) {
      throw Exception('CMS error (${response.statusCode})');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final items = json['items'] as List<dynamic>;

    return items.map((item) {
      final fields = item['fields'] as Map<String, dynamic>;
      final sys = item['sys'] as Map<String, dynamic>;
      return Pick(
        id: sys['id'] as String,
        title: fields['title'] as String? ?? 'Untitled',
        kind: fields['kind'] as String? ?? 'book',
        externalId: fields['externalId'] as String? ?? '',
        note: fields['note'] as String? ?? '',
      );
    }).toList();
  }
}