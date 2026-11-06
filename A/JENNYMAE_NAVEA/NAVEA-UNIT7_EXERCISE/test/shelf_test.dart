import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:navea_unit7_exercise/data/contentful_pick_source.dart';
import 'package:navea_unit7_exercise/data/omdb_api.dart';
import 'package:navea_unit7_exercise/data/open_library_api.dart';
import 'package:navea_unit7_exercise/data/pick_source.dart';
import 'package:navea_unit7_exercise/home_shell.dart';
import 'package:navea_unit7_exercise/models/book.dart';
import 'package:navea_unit7_exercise/models/pick.dart';
import 'package:navea_unit7_exercise/screens/shelf_screen.dart';
import 'package:navea_unit7_exercise/screens/tabs/book_search_tab.dart';
import 'package:navea_unit7_exercise/screens/tabs/movie_search_tab.dart';

void main() {
  test(
    'Book.fromJson keeps the work ID and handles missing optional fields',
    () {
      final book = Book.fromJson({
        'key': '/works/OL27482W',
        'title': 'The Hobbit',
      });

      expect(book.workId, 'OL27482W');
      expect(book.authors, isEmpty);
      expect(book.year, isNull);
      expect(book.coverId, isNull);
    },
  );

  test('Open Library search requests fields and parses results', () async {
    late Uri requestUri;
    final api = OpenLibraryApi(
      client: MockClient((request) async {
        requestUri = request.url;
        return http.Response(
          jsonEncode({
            'docs': [
              {
                'key': '/works/OL27482W',
                'title': 'The Hobbit',
                'author_name': ['J.R.R. Tolkien'],
                'first_publish_year': 1937,
                'cover_i': 123,
              },
            ],
          }),
          200,
        );
      }),
    );
    addTearDown(api.close);

    final books = await api.search('the hobbit');

    expect(requestUri.host, 'openlibrary.org');
    expect(requestUri.queryParameters['q'], 'the hobbit');
    expect(requestUri.queryParameters['limit'], '20');
    expect(books.single.workId, 'OL27482W');
    expect(books.single.authors.single, 'J.R.R. Tolkien');
  });

  test(
    'Open Library details accepts string and localized descriptions',
    () async {
      final responses = [
        {'title': 'The Hobbit', 'description': 'A fantasy adventure.'},
        {
          'title': 'Another Book',
          'covers': [42],
          'description': {'type': 'text', 'value': 'A second description.'},
        },
      ];
      var responseIndex = 0;
      final api = OpenLibraryApi(
        client: MockClient((_) async {
          return http.Response(jsonEncode(responses[responseIndex++]), 200);
        }),
      );
      addTearDown(api.close);

      final first = await api.getDetails('OL1W');
      final second = await api.getDetails('OL2W');

      expect(first.description, 'A fantasy adventure.');
      expect(second.description, 'A second description.');
      expect(second.coverId, 42);
    },
  );

  testWidgets('Book search waits for debounce then shows API results', (
    tester,
  ) async {
    var requests = 0;
    final api = OpenLibraryApi(
      client: MockClient((_) async {
        requests++;
        return http.Response(
          jsonEncode({
            'docs': [
              {'key': '/works/OL27482W', 'title': 'The Hobbit'},
            ],
          }),
          200,
        );
      }),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: BookSearchTab(api: api)),
      ),
    );
    await tester.enterText(find.byType(TextField), 'hobbit');
    await tester.pump(const Duration(milliseconds: 499));
    expect(requests, 0);

    await tester.pump(const Duration(milliseconds: 1));
    await tester.pumpAndSettle();
    expect(requests, 1);
    expect(find.text('The Hobbit'), findsOneWidget);
    expect(tester.takeException(), isNull);
    api.close();
  });

  test(
    'OMDb not-found search is an empty result and key errors are surfaced',
    () async {
      final api = OmdbApi(
        apiKey: 'test-key',
        client: MockClient(
          (_) async => http.Response(
            jsonEncode({'Response': 'False', 'Error': 'Movie not found!'}),
            200,
          ),
        ),
      );
      addTearDown(api.close);
      expect(await api.search('no such movie'), isEmpty);

      final noKeyApi = OmdbApi(
        apiKey: '',
        client: MockClient((_) async {
          fail('A request must not be sent without a key.');
        }),
      );
      addTearDown(noKeyApi.close);
      await expectLater(noKeyApi.search('movie'), throwsA(isA<Exception>()));
    },
  );

  test(
    'OMDb details request uses the external ID and parses the plot',
    () async {
      late Uri requestUri;
      final api = OmdbApi(
        apiKey: 'test-key',
        client: MockClient((request) async {
          requestUri = request.url;
          return http.Response(
            jsonEncode({
              'Response': 'True',
              'imdbID': 'tt0816692',
              'Title': 'Interstellar',
              'Year': '2014',
              'Poster': 'N/A',
              'Plot': 'A team travels through a wormhole.',
            }),
            200,
          );
        }),
      );
      addTearDown(api.close);

      final movie = await api.getDetails('tt0816692');

      expect(requestUri.queryParameters['i'], 'tt0816692');
      expect(requestUri.queryParameters['plot'], 'short');
      expect(movie.plot, 'A team travels through a wormhole.');
      expect(movie.poster, 'N/A');
    },
  );

  testWidgets('Movie search waits for debounce then shows API results', (
    tester,
  ) async {
    var requests = 0;
    final api = OmdbApi(
      apiKey: 'test-key',
      client: MockClient((_) async {
        requests++;
        return http.Response(
          jsonEncode({
            'Response': 'True',
            'Search': [
              {
                'imdbID': 'tt0816692',
                'Title': 'Interstellar',
                'Year': '2014',
                'Poster': 'N/A',
              },
            ],
          }),
          200,
        );
      }),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: MovieSearchTab(api: api)),
      ),
    );
    await tester.enterText(find.byType(TextField), 'interstellar');
    await tester.pump(const Duration(milliseconds: 499));
    expect(requests, 0);

    await tester.pump(const Duration(milliseconds: 1));
    await tester.pumpAndSettle();
    expect(requests, 1);
    expect(find.text('Interstellar'), findsOneWidget);
    expect(tester.takeException(), isNull);
    api.close();
  });

  test('Contentful pick source parses pick fields and bearer auth', () async {
    late http.Request request;
    final source = ContentfulPickSource(
      spaceId: 'space',
      token: 'delivery-token',
      client: MockClient((sent) async {
        request = sent;
        return http.Response(
          jsonEncode({
            'items': [
              {
                'sys': {'id': 'entry-id'},
                'fields': {
                  'title': 'The Hobbit',
                  'kind': 'book',
                  'externalId': 'OL27482W',
                  'note': 'A wonderful adventure.',
                },
              },
            ],
          }),
          200,
        );
      }),
    );
    addTearDown(source.close);

    final picks = await source.fetchPicks();

    expect(request.url.path, '/spaces/space/environments/master/entries');
    expect(request.url.queryParameters['content_type'], 'pick');
    expect(request.headers['Authorization'], 'Bearer delivery-token');
    expect(picks.single.kind, 'book');
    expect(picks.single.externalId, 'OL27482W');
    expect(picks.single.note, 'A wonderful adventure.');
  });

  testWidgets('Shelf has three tabs and My Picks shows CMS results', (
    tester,
  ) async {
    final source = _FakePickSource([
      const Pick(
        id: '1',
        title: 'The Hobbit',
        kind: 'book',
        externalId: 'OL27482W',
        note: 'A wonderful adventure.',
      ),
    ]);

    await tester.pumpWidget(
      MaterialApp(home: ShelfScreen(picksSource: source)),
    );
    await tester.pumpAndSettle();

    expect(find.text('My Picks'), findsOneWidget);
    expect(find.text('Books'), findsOneWidget);
    expect(find.text('Movies'), findsOneWidget);
    expect(find.text('The Hobbit'), findsOneWidget);
  });

  testWidgets('My Picks refresh shows an updated CMS note', (tester) async {
    final source = _FakePickSource([
      const Pick(
        id: '1',
        title: 'The Hobbit',
        kind: 'book',
        externalId: 'OL27482W',
        note: 'An adventure.',
      ),
    ]);
    await tester.pumpWidget(
      MaterialApp(home: ShelfScreen(picksSource: source)),
    );
    await tester.pumpAndSettle();
    expect(find.text('An adventure.'), findsOneWidget);

    source.picks = [
      const Pick(
        id: '1',
        title: 'The Hobbit',
        kind: 'book',
        externalId: 'OL27482W',
        note: 'A new note from Contentful.',
      ),
    ];
    final refresh = tester
        .state<RefreshIndicatorState>(find.byType(RefreshIndicator))
        .show();
    await tester.pumpAndSettle();
    await refresh;

    expect(source.calls, 2);
    expect(find.text('A new note from Contentful.'), findsOneWidget);
  });

  testWidgets('Home navigation includes the Shelf page', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: HomeShell()));
    await tester.pump();

    expect(find.text('Shelf'), findsOneWidget);
    await tester.tap(find.text('Shelf'));
    await tester.pumpAndSettle();

    expect(find.text('My Shelf'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

class _FakePickSource implements PickSource {
  _FakePickSource(this.picks);

  List<Pick> picks;
  int calls = 0;

  @override
  Future<List<Pick>> fetchPicks() async {
    calls++;
    return picks;
  }
}
