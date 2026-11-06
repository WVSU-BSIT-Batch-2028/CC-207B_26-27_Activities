import 'dart:convert';

import 'package:benjamin_unit7_exercise/main.dart';
import 'package:benjamin_unit7_exercise/shelf/data/api_exception.dart';
import 'package:benjamin_unit7_exercise/shelf/data/contentful_pick_source.dart';
import 'package:benjamin_unit7_exercise/shelf/data/omdb_api.dart';
import 'package:benjamin_unit7_exercise/shelf/data/open_library_api.dart';
import 'package:benjamin_unit7_exercise/shelf/models/book.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  test('Book.fromJson keeps the work ID and handles missing authors', () {
    final book = Book.fromJson({
      'key': '/works/OL27482W',
      'title': 'The Hobbit',
      'first_publish_year': 1937,
      'cover_i': 14627509,
    });

    expect(book.workId, 'OL27482W');
    expect(book.title, 'The Hobbit');
    expect(book.authors, isEmpty);
    expect(book.year, 1937);
    expect(book.coverUrl, 'https://covers.openlibrary.org/b/id/14627509-M.jpg');
  });

  test('Open Library search builds the URL and parses results', () async {
    late http.Request sent;
    final client = MockClient((request) async {
      sent = request;
      return http.Response(
        jsonEncode({
          'docs': [
            {
              'key': '/works/OL27482W',
              'title': 'The Hobbit',
              'author_name': ['J.R.R. Tolkien'],
              'first_publish_year': 1937,
              'cover_i': 14627509,
            },
          ],
        }),
        200,
      );
    });

    final books = await OpenLibraryApi(client).search('the hobbit');

    expect(sent.url.host, 'openlibrary.org');
    expect(sent.url.path, '/search.json');
    expect(sent.url.queryParameters['q'], 'the hobbit');
    expect(sent.url.queryParameters['limit'], '20');
    expect(books.single.workId, 'OL27482W');
    expect(books.single.authors.single, 'J.R.R. Tolkien');
  });

  test('Open Library details handles object descriptions', () async {
    final client = MockClient((request) async {
      return http.Response(
        jsonEncode({
          'title': 'The Hobbit',
          'first_publish_date': 'September 21, 1937',
          'covers': [14627509],
          'description': {
            'type': '/type/text',
            'value': 'A hobbit goes on a quest.',
          },
        }),
        200,
      );
    });

    final details = await OpenLibraryApi(client).fetchDetails('OL27482W');

    expect(details.title, 'The Hobbit');
    expect(details.year, '1937');
    expect(details.summary, 'A hobbit goes on a quest.');
    expect(
      details.coverUrl,
      'https://covers.openlibrary.org/b/id/14627509-L.jpg',
    );
  });

  test('Open Library details handles string descriptions', () async {
    final client = MockClient(
      (request) async => http.Response(
        jsonEncode({
          'title': 'Another Book',
          'first_publish_date': '2001',
          'covers': <int>[],
          'description': 'A description stored as text.',
        }),
        200,
      ),
    );

    final details = await OpenLibraryApi(client).fetchDetails('OL123W');

    expect(details.summary, 'A description stored as text.');
    expect(details.year, '2001');
  });

  test('OMDb treats a movie not found response as an empty result', () async {
    final client = MockClient(
      (request) async => http.Response(
        jsonEncode({'Response': 'False', 'Error': 'Movie not found!'}),
        200,
      ),
    );

    final movies = await OmdbApi(client, apiKey: 'test-key').search('no movie');

    expect(movies, isEmpty);
  });

  test('OMDb reports API errors and treats N/A as no poster', () async {
    final badKeyClient = MockClient(
      (request) async => http.Response(
        jsonEncode({'Response': 'False', 'Error': 'Invalid API key!'}),
        200,
      ),
    );
    await expectLater(
      OmdbApi(badKeyClient, apiKey: 'bad-key').search('Interstellar'),
      throwsA(isA<ApiException>()),
    );

    final movieClient = MockClient(
      (request) async => http.Response(
        jsonEncode({
          'Response': 'True',
          'Search': [
            {
              'Title': 'Interstellar',
              'Year': '2014',
              'imdbID': 'tt0816692',
              'Poster': 'N/A',
            },
          ],
        }),
        200,
      ),
    );
    final movies = await OmdbApi(
      movieClient,
      apiKey: 'test-key',
    ).search('Interstellar');

    expect(movies.single.imdbId, 'tt0816692');
    expect(movies.single.posterUrl, isNull);
  });

  test('OMDb loads details by ID with a short plot', () async {
    late http.Request sent;
    final client = MockClient((request) async {
      sent = request;
      return http.Response(
        jsonEncode({
          'Response': 'True',
          'Title': 'Interstellar',
          'Year': '2014',
          'Plot': 'A team travels through a wormhole.',
          'Poster': 'https://example.test/interstellar.jpg',
        }),
        200,
      );
    });

    final details = await OmdbApi(client, apiKey: 'test-key').fetchDetails(
      'tt0816692',
    );

    expect(sent.url.queryParameters['i'], 'tt0816692');
    expect(sent.url.queryParameters['plot'], 'short');
    expect(details.title, 'Interstellar');
    expect(details.year, '2014');
    expect(details.summary, 'A team travels through a wormhole.');
  });

  test(
    'Contentful returns picks and sends the read token in a header',
    () async {
      late http.Request sent;
      final client = MockClient((request) async {
        sent = request;
        return http.Response(
          jsonEncode({
            'items': [
              {
                'sys': {'id': 'pick-1'},
                'fields': {
                  'title': 'The Hobbit',
                  'kind': 'book',
                  'externalId': 'OL27482W',
                  'note': 'A favorite fantasy adventure.',
                },
              },
            ],
          }),
          200,
        );
      });

      final picks = await ContentfulPickSource(
        client,
        spaceId: 'space-id',
        token: 'delivery-token',
      ).fetchPicks();

      expect(sent.url.host, 'cdn.contentful.com');
      expect(sent.url.path, '/spaces/space-id/environments/master/entries');
      expect(sent.url.queryParameters['content_type'], 'pick');
      expect(sent.headers['Authorization'], 'Bearer delivery-token');
      expect(picks.single.title, 'The Hobbit');
      expect(picks.single.externalId, 'OL27482W');
      expect(picks.single.note, 'A favorite fantasy adventure.');
    },
  );

  testWidgets('Shelf is a fourth destination with its three tabs', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('Shelf'), findsOneWidget);

    await tester.tap(find.text('Shelf'));
    await tester.pumpAndSettle();

    expect(find.text('My Shelf'), findsOneWidget);
    expect(find.text('My Picks'), findsOneWidget);
    expect(find.text('Books'), findsOneWidget);
    expect(find.text('Movies'), findsOneWidget);
  });
}
