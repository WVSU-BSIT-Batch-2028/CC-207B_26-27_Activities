import 'dart:convert';

import 'package:delacruz_unit5_exercise/data/media_apis.dart';
import 'package:delacruz_unit5_exercise/data/pick_source.dart';
import 'package:delacruz_unit5_exercise/main.dart';
import 'package:delacruz_unit5_exercise/models/book.dart';
import 'package:delacruz_unit5_exercise/models/movie.dart';
import 'package:delacruz_unit5_exercise/models/pick.dart';
import 'package:delacruz_unit5_exercise/screens/book_search_screen.dart';
import 'package:delacruz_unit5_exercise/screens/my_picks_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

class _MutablePickSource implements PickSource {
  String note = 'Original note';

  @override
  Future<List<Pick>> fetchPicks() async => [
    Pick(
      title: 'The Hobbit',
      kind: PickKind.book,
      externalId: 'OL27482W',
      note: note,
    ),
  ];
}

void main() {
  testWidgets('Shelf is the fourth destination and has three inner tabs', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(800, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(const ProfilePetApp());

    expect(find.text('Gallery'), findsOneWidget);
    await tester.tap(find.text('My Shelf'));
    await tester.pumpAndSettle();
    expect(find.text('My Picks'), findsOneWidget);
    expect(find.text('Books'), findsOneWidget);
    expect(find.text('Movies'), findsOneWidget);

    await tester.tap(find.text('Books'));
    await tester.pumpAndSettle();
    expect(find.text('Search books'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  test('Book parsing keeps only the work ID and tolerates missing fields', () {
    final book = Book.fromJson({
      'key': '/works/OL27482W',
      'title': 'The Hobbit',
    });

    expect(book.workId, 'OL27482W');
    expect(book.authors, isEmpty);
    expect(book.year, isNull);
    expect(book.coverUrl, isNull);
  });

  test('Open Library search uses the requested query and fields', () async {
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
                'cover_i': 42,
              },
            ],
          }),
          200,
        );
      }),
    );

    final books = await api.search('the hobbit');

    expect(requestUri.host, 'openlibrary.org');
    expect(requestUri.queryParameters['q'], 'the hobbit');
    expect(
      requestUri.queryParameters['fields'],
      'key,title,author_name,first_publish_year,cover_i',
    );
    expect(books.single.workId, 'OL27482W');
    expect(books.single.author, 'J.R.R. Tolkien');
  });

  test('OMDb not-found responses return an empty list', () async {
    final api = OmdbApi(
      key: 'test-key',
      client: MockClient(
        (_) async => http.Response(
          jsonEncode({'Response': 'False', 'Error': 'Movie not found!'}),
          200,
        ),
      ),
    );

    expect(await api.search('missing movie'), isEmpty);
  });

  test('Movie parsing treats an N/A poster as unavailable', () {
    final movie = Movie.fromJson({
      'imdbID': 'tt0816692',
      'Title': 'Interstellar',
      'Year': '2014',
      'Poster': 'N/A',
    });

    expect(movie.posterUrl, isNull);
    expect(movie.year, '2014');
  });

  test(
    'Contentful reads localized pick fields and sends a delivery token',
    () async {
      late http.Request request;
      final source = ContentfulPickSource(
        spaceId: 'space123',
        environment: 'master',
        deliveryToken: 'delivery-token',
        client: MockClient((incoming) async {
          request = incoming;
          return http.Response(
            jsonEncode({
              'items': [
                {
                  'fields': {
                    'title': {'en-US': 'The Hobbit'},
                    'kind': {'en-US': 'book'},
                    'externalId': {'en-US': 'OL27482W'},
                    'note': {'en-US': 'A timeless adventure.'},
                  },
                },
              ],
            }),
            200,
          );
        }),
      );

      final picks = await source.fetchPicks();

      expect(request.url.host, 'cdn.contentful.com');
      expect(request.url.queryParameters['content_type'], 'pick');
      expect(request.headers['Authorization'], 'Bearer delivery-token');
      expect(picks.single.externalId, 'OL27482W');
      expect(picks.single.note, 'A timeless adventure.');
    },
  );

  testWidgets('Book search waits for the debounce before requesting', (
    tester,
  ) async {
    var requestCount = 0;
    final api = OpenLibraryApi(
      client: MockClient((request) async {
        requestCount++;
        return http.Response(jsonEncode({'docs': []}), 200);
      }),
    );
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: BookSearchScreen(api: api)),
      ),
    );

    await tester.enterText(find.byType(TextField), 'hobbit');
    await tester.pump(const Duration(milliseconds: 499));
    expect(requestCount, 0);
    await tester.pump(const Duration(milliseconds: 1));
    await tester.pumpAndSettle();
    expect(requestCount, 1);
    expect(find.text('Nothing found.'), findsOneWidget);
  });

  testWidgets('My Picks reloads updated notes on pull-to-refresh', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(800, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final source = _MutablePickSource();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: MyPicksScreen(source: source)),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Original note'), findsOneWidget);

    source.note = 'Updated note';
    await tester.drag(find.byType(ListView), const Offset(0, 500));
    await tester.pumpAndSettle();

    expect(find.text('Updated note'), findsOneWidget);
    expect(find.text('Original note'), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
