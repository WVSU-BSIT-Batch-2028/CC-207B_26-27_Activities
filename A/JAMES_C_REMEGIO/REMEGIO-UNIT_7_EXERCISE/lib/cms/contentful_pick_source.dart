import 'package:http/http.dart' as http;

import '../api/api_exception.dart';
import '../api/http_json.dart';
import '../config.dart';
import '../models/pick.dart';
import 'pick_source.dart';

/// Contentful Content Delivery API for the `pick` content type.
///
/// Uses the same space, delivery token, and `items` / `sys` / `fields` shape
/// as the Unit 7 assignment. The token can read published entries only.
class ContentfulPickSource implements PickSource {
  ContentfulPickSource({
    http.Client? client,
    this.spaceId = cmsSpace,
    this.token = cmsToken,
    this.environment = 'master',
  })  : _client = client ?? http.Client(),
        _ownsClient = client == null;

  final http.Client _client;
  final bool _ownsClient;
  final String spaceId;
  final String token;
  final String environment;

  @override
  Future<List<Pick>> fetchPicks() async {
    if (spaceId.isEmpty || token.isEmpty) {
      throw const ApiException(
        'Contentful is not configured. Copy cms.example.json to cms.json, '
        'add the space id and Content Delivery API token, then run '
        'flutter run --dart-define-from-file=cms.json.',
      );
    }
    final Uri uri = Uri.https(
      'cdn.contentful.com',
      '/spaces/$spaceId/environments/$environment/entries',
      <String, String>{
        'content_type': 'pick',
        'order': 'sys.createdAt',
        'limit': '100',
      },
    );
    final Object? json = await getJson(
      _client,
      uri,
      service: 'Contentful',
      headers: <String, String>{'Authorization': 'Bearer $token'},
    );
    return picksFromContentful(json);
  }

  void close() {
    if (_ownsClient) _client.close();
  }
}

/// Contentful's published-entry list. An empty `items` array is a real empty shelf.
List<Pick> picksFromContentful(Object? json) {
  if (json is! Map) {
    throw const ApiException(
      'Contentful sent a response that is not a pick list. '
      'Check the URL and the content type name.',
    );
  }
  final Object? items = json['items'];
  if (items is! List) {
    throw const ApiException(
      'Contentful response has no items list. '
      'Check that the content type id is pick.',
    );
  }
  return <Pick>[for (final Object? item in items) pickFromContentfulItem(item)];
}

Pick pickFromContentfulItem(Object? item) {
  if (item is! Map) {
    throw const ApiException(
        'Contentful sent a pick that is not a JSON object.');
  }
  final Object? sys = item['sys'];
  final Object? fields = item['fields'];
  final Object? id = sys is Map ? sys['id'] : null;
  if (id is! String || id.isEmpty) {
    throw const ApiException('Contentful entry is missing an id.');
  }
  if (fields is! Map) {
    throw ApiException('Contentful entry $id is missing its fields.');
  }
  final Map<String, dynamic> fieldMap = Map<String, dynamic>.from(fields);
  return Pick(
    id: id,
    title: _requiredText(fieldMap, 'title', id),
    kind: _kind(fieldMap, id),
    externalId: _requiredText(fieldMap, 'externalId', id),
    note: _optionalText(fieldMap, 'note'),
  );
}

String _requiredText(Map<String, dynamic> fields, String key, String id) {
  final String text = _optionalText(fields, key);
  if (text.isEmpty) {
    throw ApiException(
      'Contentful entry $id is missing $key. Fill it in and publish again.',
    );
  }
  return text;
}

/// Long text and short text are strings. Rich text is a map, which this app rejects.
String _optionalText(Map<String, dynamic> fields, String key) {
  final Object? value = fields[key];
  if (value == null) return '';
  if (value is String) return value.trim();
  throw ApiException(
    'Contentful field $key was not plain text. Use Short text or Long text, not Rich text.',
  );
}

String _kind(Map<String, dynamic> fields, String id) {
  final Object? value = fields['kind'];
  if (value is! String || value.trim().isEmpty) {
    throw ApiException(
      'Contentful entry $id is missing kind. Use book or movie.',
    );
  }
  final String kind = value.trim().toLowerCase();
  if (kind != 'book' && kind != 'movie') {
    throw ApiException(
      'Contentful entry $id has kind "$value". It must be book or movie.',
    );
  }
  return kind;
}
