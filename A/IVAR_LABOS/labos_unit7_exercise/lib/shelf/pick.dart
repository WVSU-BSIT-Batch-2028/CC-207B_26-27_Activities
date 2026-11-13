import 'package:http/http.dart' as http;

import 'api_exception.dart';

enum PickKind { book, movie }

/// A recommendation from the CMS. It only keeps the ID of the book or movie
/// and my note; the cover, year and summary come from the API.
class Pick {
  const Pick({
    required this.id,
    required this.title,
    required this.kind,
    required this.externalId,
    required this.note,
  });

  final String id;
  final String title;
  final PickKind kind;
  final String externalId;
  final String note;
}

abstract class PickSource {
  Future<List<Pick>> fetchPicks();
}

class ContentfulPickSource implements PickSource {
  ContentfulPickSource(
    this._client, {
    required this.spaceId,
    required this.token,
    this.environment = 'master',
  });

  final http.Client _client;
  final String spaceId;
  final String token;
  final String environment;

  @override
  Future<List<Pick>> fetchPicks() async {
    final uri = Uri.https(
      'cdn.contentful.com',
      '/spaces/$spaceId/environments/$environment/entries',
      {'content_type': 'pick', 'order': 'sys.createdAt', 'limit': '100'},
    );
    final json =
        await getJson(
              _client,
              uri,
              who: 'Contentful',
              headers: {'Authorization': 'Bearer $token'},
            )
            as Map<String, dynamic>;

    try {
      final items = json['items'] as List<dynamic>;
      return [
        for (final item in items.cast<Map<String, dynamic>>()) _parse(item),
      ];
    } on TypeError {
      throw const ApiException(
        'A pick in Contentful is missing a field. '
        'Check title, kind, externalId and note.',
      );
    }
  }

  Pick _parse(Map<String, dynamic> item) {
    final fields = item['fields'] as Map<String, dynamic>;
    final title = fields['title'] as String;
    final kindText = (fields['kind'] as String).trim().toLowerCase();
    final kind = switch (kindText) {
      'book' => PickKind.book,
      'movie' => PickKind.movie,
      _ => throw ApiException(
        'The pick "$title" has the kind "$kindText". Use book or movie.',
      ),
    };
    return Pick(
      id: (item['sys'] as Map<String, dynamic>)['id'] as String,
      title: title,
      kind: kind,
      externalId: (fields['externalId'] as String).trim(),
      note: (fields['note'] as String?) ?? '',
    );
  }
}
