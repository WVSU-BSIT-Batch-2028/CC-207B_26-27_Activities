import 'dart:convert';

import 'package:anas_unit7_exercise/data/contentful_pick_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  test('requests published picks and parses Contentful fields', () async {
    late http.Request request;
    final client = MockClient((sent) async {
      request = sent;
      return http.Response(
        jsonEncode({
          'items': [
            {
              'sys': {
                'id': 'pick-1',
                'contentType': {
                  'sys': {'id': 'pick'},
                },
              },
              'fields': {
                'title': 'The Hobbit',
                'kind': 'book',
                'externalId': 'OL27482W',
                'note': 'A favorite adventure.',
              },
            },
          ],
        }),
        200,
      );
    });

    final picks = await ContentfulPickSource(
      client,
      spaceId: 'space123',
      deliveryToken: 'delivery-token',
    ).fetchPicks();

    expect(request.method, 'GET');
    expect(request.url.host, 'cdn.contentful.com');
    expect(request.url.path, '/spaces/space123/environments/master/entries');
    expect(request.url.queryParameters['content_type'], 'pick');
    expect(request.url.queryParameters['access_token'], 'delivery-token');
    expect(picks, hasLength(1));
    expect(picks.single.title, 'The Hobbit');
    expect(picks.single.kind.name, 'book');
    expect(picks.single.externalId, 'OL27482W');
    expect(picks.single.note, 'A favorite adventure.');
  });

  test('reports Contentful authorization and configuration errors', () async {
    final source = ContentfulPickSource(
      MockClient((_) async => http.Response('unauthorized', 401)),
      spaceId: 'bad-space',
      deliveryToken: 'bad-token',
    );

    await expectLater(source.fetchPicks(), throwsA(isA<Exception>()));
  });
}
