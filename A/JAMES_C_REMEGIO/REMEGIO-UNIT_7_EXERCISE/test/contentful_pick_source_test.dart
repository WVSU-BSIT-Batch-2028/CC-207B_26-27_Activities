import 'dart:convert';

import 'package:cc207b_unit5/api/api_exception.dart';
import 'package:cc207b_unit5/cms/contentful_pick_source.dart';
import 'package:cc207b_unit5/models/pick.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  test('Contentful items become picks, and a missing note is empty', () async {
    late http.Request sent;
    final http.Client client = MockClient((http.Request request) async {
      sent = request;
      return http.Response(_payload, 200);
    });
    final ContentfulPickSource source = ContentfulPickSource(
      client: client,
      spaceId: 'space-id',
      token: 'delivery-token',
    );

    final List<Pick> picks = await source.fetchPicks();

    expect(sent.method, 'GET');
    expect(sent.url.host, 'cdn.contentful.com');
    expect(
      sent.url.path,
      '/spaces/space-id/environments/master/entries',
    );
    expect(sent.url.queryParameters['content_type'], 'pick');
    expect(sent.url.queryParameters['order'], 'sys.createdAt');
    expect(sent.headers['Authorization'], 'Bearer delivery-token');
    expect(picks, hasLength(2));
    expect(picks[0].id, 'hobbitEntry');
    expect(picks[0].title, 'The Hobbit');
    expect(picks[0].kind, 'book');
    expect(picks[0].externalId, 'OL27482W');
    expect(picks[0].note, 'A quest into Middle-earth.');
    expect(picks[1].kind, 'movie');
    expect(picks[1].note, isEmpty);
    expect(picks[1].externalId, 'tt0816692');
    source.close();
  });

  test('an empty items list is a successful empty shelf', () async {
    final http.Client client = MockClient(
      (http.Request request) async => http.Response('{"items": []}', 200),
    );
    final List<Pick> picks = await ContentfulPickSource(
      client: client,
      spaceId: 'space-id',
      token: 'delivery-token',
    ).fetchPicks();
    expect(picks, isEmpty);
  });

  test('a missing pick content type explains what to create', () async {
    final http.Client client = MockClient(
      (http.Request request) async => http.Response(
        jsonEncode(<String, Object>{
          'sys': <String, String>{'type': 'Error', 'id': 'InvalidQuery'},
          'details': <String, Object>{
            'errors': <Object>[
              <String, String>{'name': 'unknownContentType', 'value': 'pick'},
            ],
          },
        }),
        400,
      ),
    );

    await expectLater(
      ContentfulPickSource(
        client: client,
        spaceId: 'space-id',
        token: 'delivery-token',
      ).fetchPicks(),
      throwsA(
        isA<ApiException>().having(
          (ApiException error) => error.message,
          'message',
          contains('content type'),
        ),
      ),
    );
  });

  test('missing configuration does not send a request', () async {
    final http.Client client = MockClient((http.Request request) async {
      fail('Contentful was called without a space or token');
    });
    await expectLater(
      ContentfulPickSource(client: client, spaceId: '', token: '').fetchPicks(),
      throwsA(
        isA<ApiException>().having(
          (ApiException error) => error.message,
          'message',
          contains('cms.json'),
        ),
      ),
    );
  });

  test('kind must be book or movie', () {
    expect(
      () => pickFromContentfulItem(<String, Object>{
        'sys': <String, String>{'id': 'bad'},
        'fields': <String, String>{
          'title': 'Notes',
          'kind': 'song',
          'externalId': 'abc',
        },
      }),
      throwsA(
        isA<ApiException>().having(
          (ApiException error) => error.message,
          'message',
          contains('book or movie'),
        ),
      ),
    );
  });
}

const String _payload = '''
{
  "items": [
    {
      "sys": {"id": "hobbitEntry", "type": "Entry"},
      "fields": {
        "title": "The Hobbit",
        "kind": "book",
        "externalId": "OL27482W",
        "note": "A quest into Middle-earth."
      }
    },
    {
      "sys": {"id": "interstellarEntry", "type": "Entry"},
      "fields": {
        "title": "Interstellar",
        "kind": "Movie",
        "externalId": "tt0816692"
      }
    }
  ]
}
''';
