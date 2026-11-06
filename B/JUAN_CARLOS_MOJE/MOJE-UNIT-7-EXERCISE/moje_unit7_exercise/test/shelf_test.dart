import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:moje_unit7_exercise/shelf/data.dart';
import 'package:moje_unit7_exercise/shelf/shelf_screen.dart';

class TestPicks implements PickSource {
  int calls = 0;
  @override
  Future<List<Pick>> fetchPicks() async {
    calls++;
    return [
      Pick(
        title: 'My book',
        kind: 'book',
        externalId: 'OL27482W',
        note: 'Note $calls',
      ),
    ];
  }
}

void main() {
  test(
    'Books normalize work IDs and missing fields; query is encoded',
    () async {
      final api = OpenLibraryApi(
        MockClient((request) async {
          expect(request.url.queryParameters['q'], 'the hobbit & dragons');
          expect(request.url.queryParameters['limit'], '20');
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
      final books = await api.search('the hobbit & dragons');
      expect(books.single.workId, 'OL27482W');
      expect(books.single.authors, isEmpty);
      expect(books.single.cover, isNull);
      expect(books.single.year, isNull);
    },
  );

  test('Book details support both description shapes', () async {
    for (final description in [
      'A story',
      {'value': 'A story'},
    ]) {
      final api = OpenLibraryApi(
        MockClient(
          (request) async => http.Response(
            jsonEncode({
              'title': 'Book',
              'description': description,
              'covers': [-1, 42],
            }),
            200,
          ),
        ),
      );
      final detail = await api.details('OL27482W');
      expect(detail.summary, 'A story');
      expect(detail.image, contains('/42-L.jpg'));
    }
  });

  test('OMDb separates empty search, invalid key, and absent poster', () async {
    final empty = OmdbApi(
      MockClient(
        (_) async => http.Response(
          '{"Response":"False","Error":"Movie not found!"}',
          200,
        ),
      ),
      key: 'test',
    );
    expect(await empty.search('unknown'), isEmpty);
    final invalid = OmdbApi(
      MockClient(
        (_) async => http.Response(
          '{"Response":"False","Error":"Invalid API key!"}',
          200,
        ),
      ),
      key: 'test',
    );
    await expectLater(invalid.search('movie'), throwsA(isA<ApiException>()));
    final noKey = OmdbApi(
      MockClient((_) async => throw StateError('Must not request')),
      key: '',
    );
    expect(() => noKey.details('tt0816692'), throwsA(isA<ApiException>()));
    expect(
      Movie.fromJson({
        'imdbID': 'tt1',
        'Title': 'Movie',
        'Year': '2000',
        'Poster': 'N/A',
      }).poster,
      isNull,
    );
  });

  test('Network status and malformed JSON produce readable errors', () async {
    for (final response in [
      http.Response('offline', 503),
      http.Response('not json', 200),
    ]) {
      await expectLater(
        getJson(MockClient((_) async => response), Uri.https('example.com')),
        throwsA(isA<ApiException>()),
      );
    }
  });

  test(
    'Contentful uses published pick fields and reloads changed notes',
    () async {
      int calls = 0;
      final source = ContentfulPickSource(
        MockClient((request) async {
          calls++;
          expect(request.url.host, 'cdn.contentful.com');
          expect(request.url.queryParameters['content_type'], 'pick');
          expect(request.headers['Authorization'], 'Bearer delivery-test');
          return http.Response(
            jsonEncode({
              'total': 1,
              'items': [
                {
                  'fields': {
                    'title': 'My pick',
                    'kind': 'book',
                    'externalId': 'OL27482W',
                    'note': 'Revision $calls',
                  },
                },
              ],
            }),
            200,
          );
        }),
        spaceId: 'test',
        token: 'delivery-test',
      );
      expect((await source.fetchPicks()).single.note, 'Revision 1');
      expect((await source.fetchPicks()).single.note, 'Revision 2');
    },
  );

  testWidgets('Search debounces, clears stale results and copies IDs', (
    tester,
  ) async {
    final queries = <String>[];
    final old = Completer<List<SearchItem>>();
    String? copied;
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async {
        if (call.method == 'Clipboard.setData') {
          copied = (call.arguments as Map)['text'] as String;
        }
        return null;
      },
    );
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SearchTab(
            label: 'Books',
            search: (q) {
              queries.add(q);
              if (q == 'old') return old.future;
              return Future.value([
                const SearchItem(
                  id: 'OL1W',
                  title: 'New result',
                  subtitle: 'Author',
                ),
              ]);
            },
          ),
        ),
      ),
    );
    await tester.enterText(find.byType(TextField), 'ab');
    await tester.pump(const Duration(milliseconds: 600));
    expect(queries, isEmpty);
    await tester.enterText(find.byType(TextField), 'old');
    await tester.pump(const Duration(milliseconds: 499));
    expect(queries, isEmpty);
    await tester.pump(const Duration(milliseconds: 1));
    expect(queries, ['old']);
    await tester.enterText(find.byType(TextField), 'new');
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump();
    old.complete([
      const SearchItem(id: 'old', title: 'Stale result', subtitle: 'Old'),
    ]);
    await tester.pumpAndSettle();
    expect(find.text('New result'), findsOneWidget);
    expect(find.text('Stale result'), findsNothing);
    await tester.tap(find.byTooltip('Copy ID'));
    await tester.pumpAndSettle();
    expect(copied, 'OL1W');
    await tester.tap(find.byTooltip('Clear search'));
    await tester.pumpAndSettle();
    expect(find.text('New result'), findsNothing);
    await tester.enterText(find.byType(TextField), 'pending');
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 1));
    expect(queries, ['old', 'new']);
  });

  testWidgets('Picks request once, refresh note, then load book details', (
    tester,
  ) async {
    final source = TestPicks();
    final client = MockClient(
      (_) async => http.Response(
        '{"title":"API book","description":{"value":"API summary"}}',
        200,
      ),
    );
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PicksTab(
            source: source,
            books: OpenLibraryApi(client),
            movies: OmdbApi(client, key: ''),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(source.calls, 1);
    expect(find.text('Note 1'), findsOneWidget);
    await tester.tap(find.byTooltip('Refresh picks'));
    await tester.pumpAndSettle();
    expect(find.text('Note 2'), findsOneWidget);
    await tester.tap(find.text('My book'));
    await tester.pumpAndSettle();
    expect(find.text('API summary'), findsOneWidget);
    expect(find.text('Note 2'), findsOneWidget);
  });

  testWidgets('Movies show setup instructions without making a search', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: ShelfScreen()));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Movies'));
    await tester.pumpAndSettle();
    expect(find.text('Connect movie search'), findsOneWidget);
    expect(find.byType(TextField), findsNothing);
  });
}
