import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import '../lib/shelf_data.dart';
import '../lib/shelf_screen.dart';

http.Response answer(Object value) => http.Response(jsonEncode(value), 200);

class FakePicks implements PickSource {
  int calls = 0;
  bool fail = false;
  List<Pick> picks = [];

  @override
  Future<List<Pick>> fetchPicks() async {
    calls++;
    if (fail) throw const ApiException('Test connection failed');
    return picks;
  }
}

void main() {
  test('Book ID is normalized and optional metadata may be absent', () {
    final book = Book.fromJson({'key': '/works/OL27482W', 'title': 'A book'});
    expect(book.workId, 'OL27482W');
    expect(book.authors, isEmpty);
    expect(book.year, isNull);
    expect(coverUrl(book.coverId), isNull);
  });

  test(
    'Book search encodes the query and requests the required fields',
    () async {
      final client = MockClient((request) async {
        expect(request.url.host, 'openlibrary.org');
        expect(request.url.path, '/search.json');
        expect(request.url.queryParameters['q'], 'the hobbit');
        expect(request.url.queryParameters['fields'], contains('cover_i'));
        expect(request.url.queryParameters['limit'], '20');
        return answer({'docs': []});
      });
      addTearDown(client.close);
      expect(await OpenLibraryApi(client).search('the hobbit'), isEmpty);
    },
  );

  for (final description in [
    'A plain summary',
    {'type': '/type/text', 'value': 'A plain summary'},
  ]) {
    test('Book details handles description shape: $description', () async {
      final client = MockClient((request) async {
        expect(request.url.path, '/works/OL27482W.json');
        return answer({
          'title': 'A book',
          'description': description,
          'covers': [-1, 123],
          'first_publish_date': '1937',
        });
      });
      addTearDown(client.close);
      final detail = await OpenLibraryApi(client).details('OL27482W');
      expect(detail.summary, 'A plain summary');
      expect(detail.imageUrl, contains('/123-M.jpg'));
      expect(detail.year, '1937');
    });
  }

  test('Book details can obtain a missing year from search', () async {
    final client = MockClient((request) async {
      if (request.url.path == '/works/OL27482W.json') {
        return answer({'title': 'A book'});
      }
      expect(request.url.queryParameters['q'], 'key:/works/OL27482W');
      return answer({
        'docs': [
          {'first_publish_year': 1937},
        ],
      });
    });
    addTearDown(client.close);
    final detail = await OpenLibraryApi(client).details('OL27482W');
    expect(detail.year, '1937');
    expect(detail.summary, 'No description yet.');
  });

  test('OMDb not found is an empty result despite HTTP 200', () async {
    final client = MockClient((request) async {
      expect(request.url.queryParameters['type'], 'movie');
      return answer({'Response': 'False', 'Error': 'Movie not found!'});
    });
    addTearDown(client.close);
    expect(await OmdbApi(client, key: 'test').search('unknown'), isEmpty);
  });

  test('OMDb invalid key remains an error despite HTTP 200', () async {
    final client = MockClient(
      (_) async => answer({'Response': 'False', 'Error': 'Invalid API key!'}),
    );
    addTearDown(client.close);
    await expectLater(
      OmdbApi(client, key: 'wrong').search('movie'),
      throwsA(
        isA<ApiException>().having(
          (error) => error.message,
          'message',
          contains('Invalid API key'),
        ),
      ),
    );
  });

  test('OMDb N/A poster becomes null', () {
    final movie = Movie.fromJson({
      'imdbID': 'tt0816692',
      'Title': 'Interstellar',
      'Year': '2014',
      'Poster': 'N/A',
    });
    expect(movie.poster, isNull);
  });

  test('Missing OMDb key sends no request', () async {
    final client = MockClient(
      (_) async => throw StateError('Unexpected request'),
    );
    addTearDown(client.close);
    await expectLater(
      OmdbApi(client, key: '').search('movie'),
      throwsA(isA<ApiException>()),
    );
  });

  test('Movie details uses ID and short plot', () async {
    final client = MockClient((request) async {
      expect(request.url.queryParameters['i'], 'tt0816692');
      expect(request.url.queryParameters['plot'], 'short');
      return answer({
        'Response': 'True',
        'Title': 'Interstellar',
        'Year': '2014',
        'Plot': 'A space journey.',
        'Poster': 'N/A',
      });
    });
    addTearDown(client.close);
    final detail = await OmdbApi(client, key: 'test').details('tt0816692');
    expect(detail.summary, 'A space journey.');
  });

  test('Contentful requests pick and maps fields and missing note', () async {
    final client = MockClient((request) async {
      expect(request.url.path, '/spaces/space/environments/master/entries');
      expect(request.url.queryParameters['content_type'], 'pick');
      expect(request.headers['Authorization'], 'Bearer delivery');
      return answer({
        'items': [
          {
            'sys': {'id': 'p1'},
            'fields': {
              'title': 'A pick',
              'kind': 'book',
              'externalId': 'OL27482W',
            },
          },
        ],
      });
    });
    addTearDown(client.close);
    final picks = await ContentfulPickSource(
      client,
      spaceId: 'space',
      token: 'delivery',
    ).fetchPicks();
    expect(picks.single.note, '');
    expect(picks.single.externalId, 'OL27482W');
  });

  testWidgets(
    'Search waits 500 ms, cancels old timer, and ignores short text',
    (tester) async {
      final queries = <String>[];
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ShelfSearchPage(
              label: 'Books',
              search: (query) async {
                queries.add(query);
                return const [];
              },
            ),
          ),
        ),
      );
      await tester.enterText(find.byType(TextField), 'ho');
      await tester.pump(const Duration(milliseconds: 600));
      expect(queries, isEmpty);
      await tester.enterText(find.byType(TextField), 'hob');
      await tester.pump(const Duration(milliseconds: 400));
      await tester.enterText(find.byType(TextField), 'hobbit');
      await tester.pump(const Duration(milliseconds: 499));
      expect(queries, isEmpty);
      await tester.pump(const Duration(milliseconds: 1));
      await tester.pump();
      expect(queries, ['hobbit']);
      expect(tester.takeException(), isNull);
      expect(find.text('Nothing found.'), findsOneWidget);
    },
  );

  testWidgets('Missing movie key shows instructions without a search field', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ShelfSearchPage(
            label: 'Movies',
            configured: false,
            search: (_) async => throw StateError('Unexpected request'),
          ),
        ),
      ),
    );
    expect(find.byType(TextField), findsNothing);
    expect(find.textContaining('OMDB_KEY'), findsOneWidget);
  });

  testWidgets('Picks loads once, shows empty/error/data, and refresh reloads', (
    tester,
  ) async {
    final source = FakePicks();
    final client = MockClient((_) async => answer({}));
    addTearDown(client.close);
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MyPicksPage(
            source: source,
            books: OpenLibraryApi(client),
            movies: OmdbApi(client),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(source.calls, 1);
    expect(find.textContaining('No picks yet'), findsOneWidget);
    source.fail = true;
    tester.state<RefreshIndicatorState>(find.byType(RefreshIndicator)).show();
    await tester.pumpAndSettle();
    expect(find.text('Test connection failed'), findsOneWidget);
    source.fail = false;
    source.picks = const [
      Pick(
        id: 'p',
        title: 'My recommendation',
        kind: 'book',
        externalId: 'OL27482W',
        note: 'A new note from the CMS',
      ),
    ];
    await tester.tap(find.text('Retry'));
    await tester.pumpAndSettle();
    expect(source.calls, 3);
    expect(find.text('A new note from the CMS'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
