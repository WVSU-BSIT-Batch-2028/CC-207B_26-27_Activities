import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'package:amaguin_unit7_exercise/models/book.dart';
import 'package:amaguin_unit7_exercise/services/open_library_api.dart';

void main() {
  test('Book extracts work ID and handles missing optional fields', () {
    final book = Book.fromJson({
      'key': '/works/OL27482W',
      'title': 'The Hobbit',
    });
    expect(book.workId, 'OL27482W');
    expect(book.authors, isEmpty);
    expect(book.year, isNull);
    expect(book.coverId, isNull);
    expect(book.coverUrl, isNull);
  });

  test('Book parses authors, year, and cover URL', () {
    final book = Book.fromJson({
      'key': 'OL27482W',
      'title': 'The Hobbit',
      'author_name': ['J. R. R. Tolkien'],
      'first_publish_year': 1937,
      'cover_i': 123,
    });
    expect(book.authors, ['J. R. R. Tolkien']);
    expect(book.year, 1937);
    expect(
      book.coverUrl,
      'https://covers.openlibrary.org/b/id/123-M.jpg?default=false',
    );
  });

  test(
    'Search builds the encoded request and converts docs to books',
    () async {
      final api = OpenLibraryApi(
        client: MockClient((request) async {
          expect(request.url.scheme, 'https');
          expect(request.url.host, 'openlibrary.org');
          expect(request.url.path, '/search.json');
          expect(request.url.queryParameters['q'], 'the hobbit');
          expect(
            request.url.queryParameters['fields'],
            'key,title,author_name,first_publish_year,cover_i',
          );
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
      addTearDown(api.close);
      expect((await api.search(' the hobbit ')).single.workId, 'OL27482W');
    },
  );

  test('Search returns an empty list when no books match', () async {
    final api = OpenLibraryApi(
      client: MockClient((_) async => http.Response('{"docs":[]}', 200)),
    );
    addTearDown(api.close);
    expect(await api.search('missing'), isEmpty);
  });

  for (final status in [404, 429, 503]) {
    test('HTTP $status is reported as an API error', () async {
      final api = OpenLibraryApi(
        client: MockClient((_) async => http.Response('error', status)),
      );
      addTearDown(api.close);
      await expectLater(api.search('hobbit'), throwsA(isA<ApiException>()));
    });
  }

  test('Invalid JSON or a missing docs list gives a readable error', () async {
    for (final body in ['<html>error</html>', '{}']) {
      final api = OpenLibraryApi(
        client: MockClient((_) async => http.Response(body, 200)),
      );
      addTearDown(api.close);
      await expectLater(api.search('hobbit'), throwsA(isA<ApiException>()));
    }
  });

  test('Connection failures give a readable error', () async {
    final api = OpenLibraryApi(
      client: MockClient((_) async {
        throw http.ClientException('Offline');
      }),
    );
    addTearDown(api.close);
    await expectLater(
      api.search('hobbit'),
      throwsA(
        isA<ApiException>().having(
          (error) => error.message,
          'message',
          contains('internet connection'),
        ),
      ),
    );
  });
}
