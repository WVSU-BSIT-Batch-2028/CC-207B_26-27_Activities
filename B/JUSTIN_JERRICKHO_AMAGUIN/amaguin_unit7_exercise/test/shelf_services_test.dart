import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'package:amaguin_unit7_exercise/models/movie.dart';
import 'package:amaguin_unit7_exercise/models/pick.dart';
import 'package:amaguin_unit7_exercise/services/omdb_api.dart';
import 'package:amaguin_unit7_exercise/services/open_library_api.dart';
import 'package:amaguin_unit7_exercise/services/pick_source.dart';

http.Response response(Object json, [int status = 200]) =>
    http.Response(jsonEncode(json), status);

void main() {
  test('Movie treats N/A posters as missing', () {
    final movie = Movie.fromJson({
      'Title': 'Interstellar',
      'imdbID': 'tt0816692',
      'Year': '2014',
      'Poster': 'N/A',
    });
    expect(movie.posterUrl, isNull);
    expect(movie.year, '2014');
  });

  test('OMDb search encodes the query and filters for movies', () async {
    final api = OmdbApi(
      key: 'test-key',
      client: MockClient((request) async {
        expect(request.url.scheme, 'https');
        expect(request.url.host, 'www.omdbapi.com');
        expect(request.url.queryParameters['s'], 'the movie');
        expect(request.url.queryParameters['type'], 'movie');
        expect(request.url.queryParameters['apikey'], 'test-key');
        return response({
          'Response': 'True',
          'Search': [
            {
              'Title': 'The Movie',
              'imdbID': 'tt1234567',
              'Year': '2020',
              'Poster': 'N/A',
            },
          ],
        });
      }),
    );
    addTearDown(api.close);
    expect((await api.search(' the movie ')).single.imdbId, 'tt1234567');
  });

  test('OMDb not found is empty while an invalid key is an error', () async {
    final empty = OmdbApi(
      key: 'test',
      client: MockClient(
        (_) async =>
            response({'Response': 'False', 'Error': 'Movie not found!'}),
      ),
    );
    final invalid = OmdbApi(
      key: 'bad',
      client: MockClient(
        (_) async =>
            response({'Response': 'False', 'Error': 'Invalid API key!'}),
      ),
    );
    addTearDown(empty.close);
    addTearDown(invalid.close);
    expect(await empty.search('missing'), isEmpty);
    await expectLater(
      invalid.search('movie'),
      throwsA(
        isA<ApiException>().having(
          (e) => e.message,
          'message',
          'Invalid API key!',
        ),
      ),
    );
  });

  test('Missing OMDb key fails without a network call', () async {
    final api = OmdbApi(
      key: '',
      client: MockClient((_) async {
        fail('No request should run without a key');
      }),
    );
    addTearDown(api.close);
    await expectLater(api.search('movie'), throwsA(isA<ApiException>()));
  });

  test('Movie details requests the IMDb ID and short plot', () async {
    final api = OmdbApi(
      key: 'test',
      client: MockClient((request) async {
        expect(request.url.queryParameters['i'], 'tt0816692');
        expect(request.url.queryParameters['plot'], 'short');
        return response({
          'Response': 'True',
          'Title': 'Interstellar',
          'Year': '2014',
          'Plot': 'A space journey.',
          'Poster': 'N/A',
        });
      }),
    );
    addTearDown(api.close);
    final detail = await api.details('tt0816692');
    expect(detail.summary, 'A space journey.');
    expect(detail.imageUrl, isNull);
  });

  for (final description in <dynamic>[
    'An adventure.',
    {'value': 'An adventure.'},
    null,
  ]) {
    test(
      'Book details handles description $description and indexed year',
      () async {
        final api = OpenLibraryApi(
          client: MockClient((request) async {
            if (request.url.path == '/works/OL27482W.json') {
              return response({
                'title': 'The Hobbit',
                'description': description,
                'covers': [-1, 123],
              });
            }
            expect(request.url.queryParameters['q'], 'key:/works/OL27482W');
            return response({
              'docs': [
                {
                  'key': '/works/OL27482W',
                  'title': 'The Hobbit',
                  'first_publish_year': 1937,
                },
              ],
            });
          }),
        );
        addTearDown(api.close);
        final detail = await api.details('OL27482W');
        expect(
          detail.summary,
          description == null ? 'No description yet.' : 'An adventure.',
        );
        expect(detail.year, '1937');
        expect(detail.imageUrl, contains('/123-L.jpg'));
      },
    );
  }

  test(
    'Contentful reads fields using pick type and a delivery-token header',
    () async {
      var calls = 0;
      final source = ContentfulPickSource(
        space: 'space',
        token: 'delivery',
        client: MockClient((request) async {
          calls++;
          expect(request.url.host, 'cdn.contentful.com');
          expect(request.url.path, '/spaces/space/environments/master/entries');
          expect(request.url.queryParameters['content_type'], 'pick');
          expect(request.headers['Authorization'], 'Bearer delivery');
          return response({
            'items': [
              {
                'fields': {
                  'title': 'The Hobbit',
                  'kind': 'book',
                  'externalId': 'OL27482W',
                  'note': 'Note $calls',
                },
              },
            ],
          });
        }),
      );
      addTearDown(source.close);
      expect((await source.fetchPicks()).single.note, 'Note 1');
      expect((await source.fetchPicks()).single.note, 'Note 2');
    },
  );

  test('Contentful reports denied access and missing settings', () async {
    final denied = ContentfulPickSource(
      space: 'space',
      token: 'bad',
      client: MockClient((_) async => response({}, 401)),
    );
    final missing = ContentfulPickSource(
      space: '',
      token: '',
      client: MockClient((_) async {
        fail('No request should run without settings');
      }),
    );
    addTearDown(denied.close);
    addTearDown(missing.close);
    await expectLater(denied.fetchPicks(), throwsA(isA<ApiException>()));
    await expectLater(missing.fetchPicks(), throwsA(isA<ApiException>()));
  });

  test(
    'Pick validates its kind and external ID and tolerates a missing note',
    () {
      expect(
        Pick.fromJson({'kind': 'book', 'externalId': 'OL27482W'}).note,
        '',
      );
      expect(
        () => Pick.fromJson({'kind': 'video', 'externalId': '123'}),
        throwsA(isA<ApiException>()),
      );
      expect(
        () => Pick.fromJson({'kind': 'movie', 'externalId': 'OL27482W'}),
        throwsA(isA<ApiException>()),
      );
    },
  );
}
