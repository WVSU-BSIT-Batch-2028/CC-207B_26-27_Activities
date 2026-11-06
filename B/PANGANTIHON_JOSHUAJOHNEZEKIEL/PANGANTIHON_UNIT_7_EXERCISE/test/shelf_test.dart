import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:pangantihon_unit7_exercise/data/book.dart';
import 'package:pangantihon_unit7_exercise/data/omdb_api.dart';
import 'package:pangantihon_unit7_exercise/data/open_library_api.dart';
import 'package:pangantihon_unit7_exercise/data/pick.dart';
import 'package:pangantihon_unit7_exercise/data/pick_source.dart';
import 'package:pangantihon_unit7_exercise/data/strapi_pick_source.dart';
import 'package:pangantihon_unit7_exercise/screens/pick_list_tab.dart';

void main() {
  test('Book.fromJson keeps only the work ID and allows missing authors', () {
    final book = Book.fromJson({
      'key': '/works/OL27482W',
      'title': 'The Hobbit',
      'first_publish_year': 1937,
      'cover_i': 14627509,
    });

    expect(book.workId, 'OL27482W');
    expect(book.authors, isEmpty);
    expect(book.year, 1937);
    expect(book.coverId, 14627509);
  });

  test('Open Library search builds a query and parses results', () async {
    final client = MockClient((request) async {
      expect(request.url.host, 'openlibrary.org');
      expect(request.url.path, '/search.json');
      expect(request.url.queryParameters['q'], 'Sherlock Holmes');
      expect(request.url.queryParameters['limit'], '20');
      return http.Response(
        jsonEncode({
          'docs': [
            {
              'key': '/works/OL262421W',
              'title': 'The Adventures of Sherlock Holmes',
              'author_name': ['Arthur Conan Doyle'],
              'first_publish_year': 1892,
            },
          ],
        }),
        200,
      );
    });

    final books = await OpenLibraryApi(client).search('Sherlock Holmes');
    expect(books.single.workId, 'OL262421W');
    expect(books.single.authors.single, 'Arthur Conan Doyle');
    client.close();
  });

  test('OMDb not-found responses return an empty list', () async {
    final client = MockClient(
      (_) async => http.Response(
        jsonEncode({'Response': 'False', 'Error': 'Movie not found!'}),
        200,
      ),
    );

    expect(
      await OmdbApi(client, apiKey: 'test-key').search('no movie'),
      isEmpty,
    );
    client.close();
  });

  test('OMDb 401 explains the rejected API key', () async {
    final client = MockClient((_) async => http.Response('{}', 401));
    final api = OmdbApi(client, apiKey: 'inactive-key');

    await expectLater(
      api.search('Interstellar'),
      throwsA(
        isA<Exception>().having(
          (error) => error.toString(),
          'message',
          contains('OMDb rejected the API key'),
        ),
      ),
    );
    client.close();
  });

  test('Strapi source parses Strapi 5 and Strapi 4 pick records', () async {
    final client = MockClient((request) async {
      expect(request.url.path, '/api/picks');
      expect(request.url.queryParameters['pagination[pageSize]'], '100');
      expect(request.headers['authorization'], 'Bearer read-only-token');
      return http.Response(
        jsonEncode({
          'data': [
            {
              'documentId': 'one',
              'title': 'A book',
              'kind': 'book',
              'externalId': 'OL123W',
              'note': 'A note.',
            },
            {
              'id': 2,
              'attributes': {
                'title': 'A movie',
                'kind': 'movie',
                'externalId': 'tt1234567',
                'note': 'Another note.',
              },
            },
          ],
        }),
        200,
      );
    });

    final source = StrapiPickSource(
      client,
      baseUrl: 'http://localhost:1337/',
      token: 'read-only-token',
    );
    final picks = await source.fetchPicks();
    expect(picks, hasLength(2));
    expect(picks.first.kind, PickKind.book);
    expect(picks.last.kind, PickKind.movie);
    expect(picks.last.externalId, 'tt1234567');
    client.close();
  });

  testWidgets('Picks refresh to show an updated Strapi note', (tester) async {
    final source = _MemoryPickSource();
    final client = MockClient((request) async {
      if (request.url.path == '/works/OL262421W.json') {
        return http.Response(
          jsonEncode({
            'title': 'The Adventures of Sherlock Holmes',
            'covers': [123],
            'description': {'value': 'A collection of detective stories.'},
          }),
          200,
        );
      }
      if (request.url.path == '/search.json') {
        return http.Response(
          jsonEncode({
            'docs': [
              {'first_publish_year': 1892},
            ],
          }),
          200,
        );
      }
      return http.Response('{}', 404);
    });

    await tester.pumpWidget(
      MaterialApp(
        home: PickListTab(
          source: source,
          books: OpenLibraryApi(client),
          movies: OmdbApi(client, apiKey: 'test-key'),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('A recommendation.'), findsOneWidget);

    source.note = 'Updated in Strapi.';
    await tester.drag(find.byType(ListView), const Offset(0, 400));
    await tester.pumpAndSettle();
    expect(find.text('Updated in Strapi.'), findsOneWidget);

    await tester.tap(find.text('Sherlock Holmes'));
    await tester.pumpAndSettle();
    expect(find.text('The Adventures of Sherlock Holmes'), findsWidgets);
    expect(find.text('Updated in Strapi.'), findsOneWidget);
    expect(find.text('A collection of detective stories.'), findsOneWidget);
    client.close();
  });

}

class _MemoryPickSource implements PickSource {
  String note = 'A recommendation.';

  @override
  Future<List<Pick>> fetchPicks() async => [
    Pick(
      title: 'Sherlock Holmes',
      kind: PickKind.book,
      externalId: 'OL262421W',
      note: note,
    ),
  ];
}
