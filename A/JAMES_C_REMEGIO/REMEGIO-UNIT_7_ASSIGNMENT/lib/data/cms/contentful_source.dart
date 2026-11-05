import 'package:http/http.dart' as http;

import '../../models/fair_event.dart';
import '../event_source.dart';

/// Contentful (hosted headless CMS), Content Delivery API.
///
/// Content model: "Fair Event" with the API identifier fairEvent.
/// Fields (field ID: type): title: Short text, orgId: Short text,
/// startsAt: Date and time, venue: Short text, description: Long text,
/// cancelled: Boolean.
///
/// Contentful answers:
/// { "sys": { "type": "Array" }, "total": 9, "skip": 0, "limit": 100,
///   "items": [ { "sys": { "id": "3xYz...", "type": "Entry", ... },
///                "fields": { "title": "Hour of Code", "orgId": "csc",
///                            "startsAt": "2026-11-08T13:00+08:00",
///                            "venue": "CICT Lab 2" } } ] }
/// A field left empty is not sent at all, so fields['description'] is null.
class ContentfulEventSource implements EventSource {
  ContentfulEventSource(
    this.client, {
    required this.spaceId,
    required this.token,
    this.environment = 'master',
  });

  final http.Client client;
  final String spaceId;

  /// The Content Delivery API access token (read-only, published entries).
  /// Never the Content Management token.
  final String token;
  final String environment;

  @override
  String get name => 'Contentful';

  @override
  Future<List<FairEvent>> fetchEvents() async {
    // Content Delivery API (cdn.contentful.com) returns published entries
    // only. Drafts stay on the Preview API, which this app never calls.
    final uri = Uri.https(
      'cdn.contentful.com',
      '/spaces/$spaceId/environments/$environment/entries',
      {'content_type': 'fairEvent', 'order': 'fields.startsAt', 'limit': '100'},
    );
    final headers = {'Authorization': 'Bearer $token'};
    // EXPLAIN E3: Open one of the other two CMS files and compare. Which
    // lines differ, and which are the same? Why is the parsing the part
    // that changes most from one CMS to another?
    final json = await getJson(client, uri, cms: name, headers: headers);
    return _eventsFromContentful(json);
  }
}

List<FairEvent> _eventsFromContentful(Object? json) {
  if (json is! Map) {
    throw const CmsException(
      'Contentful sent a response that is not an event list. '
      'Check the URL and the content type name.',
    );
  }
  final items = json['items'];
  if (items is! List) {
    throw const CmsException(
      'Contentful response has no items list. '
      'Check that the content type id is fairEvent.',
    );
  }
  return [for (final item in items) _eventFromItem(item)];
}

FairEvent _eventFromItem(Object? item) {
  if (item is! Map) {
    throw const CmsException(
      'Contentful sent an event that is not a JSON object.',
    );
  }
  final sys = item['sys'];
  final fields = item['fields'];
  final id = sys is Map ? sys['id'] : null;
  if (id is! String || id.isEmpty) {
    throw const CmsException('Contentful entry is missing an id.');
  }
  if (fields is! Map) {
    throw CmsException('Contentful entry $id is missing its fields.');
  }
  final fieldMap = Map<String, dynamic>.from(fields);
  return FairEvent(
    id: id,
    orgId: _text(fieldMap, 'orgId'),
    title: _text(fieldMap, 'title'),
    startsAt: _startsAt(fieldMap, id),
    venue: _text(fieldMap, 'venue'),
    description: _text(fieldMap, 'description'),
    cancelled: _flag(fieldMap, 'cancelled'),
  );
}

/// A short or long text field. Contentful omits it entirely when it is empty.
String _text(Map<String, dynamic> fields, String key) {
  final value = fields[key];
  if (value == null) return '';
  if (value is String) return value;
  throw CmsException(
    'Contentful field $key was not text. Check the Fair Event content type.',
  );
}

/// Boolean fields are omitted when left empty. That means not cancelled.
bool _flag(Map<String, dynamic> fields, String key) {
  final value = fields[key];
  if (value == null) return false;
  if (value is bool) return value;
  throw CmsException(
    'Contentful field $key was not true or false. '
    'Check the Fair Event content type.',
  );
}

/// Required. A missing or unreadable date is an error, never a guessed time.
DateTime _startsAt(Map<String, dynamic> fields, String id) {
  final value = fields['startsAt'];
  if (value is! String || value.isEmpty) {
    throw CmsException(
      'Contentful entry $id is missing startsAt. '
      'Add a date and time, then publish the entry again.',
    );
  }
  try {
    return DateTime.parse(value);
  } on FormatException {
    throw CmsException(
      'Contentful entry $id has a startsAt value that is not a date: $value',
    );
  }
}
