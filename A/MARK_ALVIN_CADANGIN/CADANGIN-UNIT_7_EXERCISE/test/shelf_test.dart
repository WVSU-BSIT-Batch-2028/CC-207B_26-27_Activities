import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'package:cadangin_unit7_exercise/main.dart';
import 'package:cadangin_unit7_exercise/models/book.dart';
import 'package:cadangin_unit7_exercise/models/movie.dart';
import 'package:cadangin_unit7_exercise/models/pick.dart';
import 'package:cadangin_unit7_exercise/services/api_exception.dart';
import 'package:cadangin_unit7_exercise/services/omdb_api.dart';
import 'package:cadangin_unit7_exercise/services/open_library_api.dart';
import 'package:cadangin_unit7_exercise/services/pick_source.dart';

void main() {
  group('Unit 7 Models Tests', () {
    test('Book.fromJson parses Open Library work JSON correctly', () {
      final json = {
        'key': '/works/OL27482W',
        'title': 'The Hobbit',
        'author_name': ['J.R.R. Tolkien'],
        'first_publish_year': 1937,
        'cover_i': 14627509,
      };

      final book = Book.fromJson(json);
      expect(book.workId, equals('OL27482W'));
      expect(book.title, equals('The Hobbit'));
      expect(book.authors, contains('J.R.R. Tolkien'));
      expect(book.year, equals(1937));
      expect(book.coverId, equals(14627509));
      expect(book.coverUrl,
          equals('https://covers.openlibrary.org/b/id/14627509-M.jpg'));
    });

    test('Movie.fromJson parses OMDb JSON correctly', () {
      final json = {
        'Title': 'Interstellar',
        'Year': '2014',
        'imdbID': 'tt0816692',
        'Poster': 'https://m.media-amazon.com/images/poster.jpg',
      };

      final movie = Movie.fromJson(json);
      expect(movie.imdbId, equals('tt0816692'));
      expect(movie.title, equals('Interstellar'));
      expect(movie.year, equals('2014'));
      expect(movie.posterUrl,
          equals('https://m.media-amazon.com/images/poster.jpg'));
    });

    test('Movie.fromJson treats Poster "N/A" as null posterUrl', () {
      final json = {
        'Title': 'Some Movie',
        'Year': '2020',
        'imdbID': 'tt1234567',
        'Poster': 'N/A',
      };

      final movie = Movie.fromJson(json);
      expect(movie.posterUrl, isNull);
    });

    test('Pick.fromContentful parses Contentful entry correctly', () {
      final entry = {
        'sys': {'id': 'entry123'},
        'fields': {
          'title': 'The Hobbit',
          'kind': 'book',
          'externalId': 'OL27482W',
          'note': 'Fantasy classic',
        },
      };

      final pick = Pick.fromContentful(entry);
      expect(pick.id, equals('entry123'));
      expect(pick.title, equals('The Hobbit'));
      expect(pick.kind, equals('book'));
      expect(pick.externalId, equals('OL27482W'));
      expect(pick.note, equals('Fantasy classic'));
      expect(pick.isBook, isTrue);
      expect(pick.isMovie, isFalse);
    });
  });

  group('Unit 7 API Services Tests', () {
    test('OpenLibraryApi search returns books', () async {
      final client = MockClient((request) async {
        expect(request.url.host, equals('openlibrary.org'));
        expect(request.url.path, equals('/search.json'));
        expect(request.url.queryParameters['q'], equals('hobbit'));

        final body = jsonEncode({
          'docs': [
            {
              'key': '/works/OL27482W',
              'title': 'The Hobbit',
              'author_name': ['J.R.R. Tolkien'],
              'first_publish_year': 1937,
              'cover_i': 14627509,
            }
          ]
        });
        return http.Response(body, 200);
      });

      final api = OpenLibraryApi(client);
      final results = await api.search('hobbit');
      expect(results.length, equals(1));
      expect(results.first.title, equals('The Hobbit'));
    });

    test('OpenLibraryApi getDetails parses string and map descriptions',
        () async {
      final clientStringDesc = MockClient((request) async {
        return http.Response(
            jsonEncode({
              'title': 'Test Book',
              'description': 'Plain string description',
            }),
            200);
      });

      final api1 = OpenLibraryApi(clientStringDesc);
      final detail1 = await api1.getDetails('OL1W');
      expect(detail1.description, equals('Plain string description'));

      final clientMapDesc = MockClient((request) async {
        return http.Response(
            jsonEncode({
              'title': 'Test Book 2',
              'description': {'type': 'text', 'value': 'Object description'},
            }),
            200);
      });

      final api2 = OpenLibraryApi(clientMapDesc);
      final detail2 = await api2.getDetails('OL2W');
      expect(detail2.description, equals('Object description'));
    });

    test('OmdbApi search handles Movie not found as empty list', () async {
      final client = MockClient((request) async {
        return http.Response(
            jsonEncode({'Response': 'False', 'Error': 'Movie not found!'}),
            200);
      });

      final api = OmdbApi(apiKey: 'dummyKey', client: client);
      final results = await api.search('nonexistentmoviexyz');
      expect(results, isEmpty);
    });

    test('OmdbApi search throws on API error', () async {
      final client = MockClient((request) async {
        return http.Response(
            jsonEncode({'Response': 'False', 'Error': 'Invalid API key!'}),
            200);
      });

      final api = OmdbApi(apiKey: 'badKey', client: client);
      expect(() => api.search('movie'), throwsA(isA<ApiException>()));
    });

    test('ContentfulPickSource parses entries and handles status codes',
        () async {
      final client = MockClient((request) async {
        expect(request.url.host, equals('cdn.contentful.com'));
        final body = jsonEncode({
          'items': [
            {
              'sys': {'id': 'p1'},
              'fields': {
                'title': 'Dune',
                'kind': 'book',
                'externalId': 'OL893414W',
                'note': 'Epic',
              }
            }
          ]
        });
        return http.Response(body, 200);
      });

      final source = ContentfulPickSource(client,
          spaceId: 'space1', token: 'token1');
      final picks = await source.fetchPicks();
      expect(picks.length, equals(1));
      expect(picks.first.title, equals('Dune'));
    });
  });

  group('Unit 7 UI & Navigation Tests', () {
    testWidgets(
        'HomeShell includes Shelf destination and navigates to ShelfScreen',
        (WidgetTester tester) async {
      await tester.pumpWidget(const CadanginExerciseApp());
      await tester.pumpAndSettle();

      final shelfTab = find.text('Shelf');
      expect(shelfTab, findsOneWidget);

      await tester.tap(shelfTab);
      await tester.pumpAndSettle();

      expect(find.text('My Shelf'), findsOneWidget);
      expect(find.text('My Picks'), findsOneWidget);
      expect(find.text('Books'), findsOneWidget);
      expect(find.text('Movies'), findsOneWidget);
    });
  });
}
