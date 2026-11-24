import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:tamano_unit7_exercise/main.dart';
import 'package:tamano_unit7_exercise/models/book.dart';
import 'package:tamano_unit7_exercise/models/movie.dart';
import 'package:tamano_unit7_exercise/models/pick.dart';
import 'package:tamano_unit7_exercise/screens/book_search_tab.dart';
import 'package:tamano_unit7_exercise/screens/movie_search_tab.dart';
import 'package:tamano_unit7_exercise/screens/my_picks_tab.dart';
import 'package:tamano_unit7_exercise/screens/shelf_screen.dart';

void main() {
  testWidgets(
      'Unit 7 Exercise: Profile, Pet, Gallery, Shelf, and Tab navigation test',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    // 1. Build app
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // --- Profile Screen Checks ---
    expect(find.textContaining('Vincent John'), findsWidgets);
    expect(find.text('My Biography'), findsOneWidget);
    expect(find.text('My Hobbies'), findsOneWidget);
    expect(find.byType(Wrap), findsOneWidget);
    expect(find.byType(Chip), findsAtLeastNWidgets(5));

    // --- Tab Navigation & IndexedStack Checks ---
    // Switch to Pet tab by tapping label
    await tester.tap(find.text('My Pet'));
    await tester.pumpAndSettle();

    expect(find.widgetWithText(AppBar, 'My Pet'), findsOneWidget);
    expect(find.textContaining('has meowed 0 times'), findsOneWidget);

    // Switch to Gallery tab
    await tester.tap(find.text('Gallery'));
    await tester.pumpAndSettle();
    expect(find.widgetWithText(AppBar, 'My Gallery'), findsOneWidget);

    // --- Part A: Switch to Shelf Tab ---
    await tester.tap(find.text('Shelf'));
    await tester.pumpAndSettle();

    expect(find.byType(ShelfScreen), findsOneWidget);
    expect(find.widgetWithText(AppBar, 'My Shelf'), findsOneWidget);

    // Verify 3 tabs: My Picks, Books, Movies
    expect(find.text('My Picks'), findsOneWidget);
    expect(find.text('Books'), findsOneWidget);
    expect(find.text('Movies'), findsOneWidget);

    // Verify My Picks loaded
    expect(find.byType(MyPicksTab), findsOneWidget);

    // Switch to Books tab
    await tester.tap(find.text('Books'));
    await tester.pumpAndSettle();
    expect(find.byType(BookSearchTab), findsOneWidget);
    expect(find.text('Search books, e.g. hobbit'), findsOneWidget);

    // Switch to Movies tab
    await tester.tap(find.text('Movies'));
    await tester.pumpAndSettle();
    expect(find.byType(MovieSearchTab), findsOneWidget);
  });

  test('Book model parses JSON correctly', () {
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
    expect(book.coverUrl, contains('14627509-M.jpg'));
  });

  test('Movie model parses JSON correctly and treats N/A as null poster', () {
    final json = {
      'Title': 'Interstellar',
      'Year': '2014',
      'imdbID': 'tt0816692',
      'Poster': 'N/A',
    };

    final movie = Movie.fromJson(json);
    expect(movie.title, equals('Interstellar'));
    expect(movie.year, equals('2014'));
    expect(movie.imdbId, equals('tt0816692'));
    expect(movie.poster, isNull);
  });

  test('Pick model parses Contentful item correctly', () {
    final item = {
      'sys': {'id': 'entry123'},
      'fields': {
        'title': 'The Hobbit',
        'kind': 'book',
        'externalId': 'OL27482W',
        'note': 'My favorite book.',
      },
    };

    final pick = Pick.fromContentful(item);
    expect(pick.id, equals('entry123'));
    expect(pick.title, equals('The Hobbit'));
    expect(pick.isBook, isTrue);
    expect(pick.isMovie, isFalse);
    expect(pick.externalId, equals('OL27482W'));
    expect(pick.note, equals('My favorite book.'));
  });
}
