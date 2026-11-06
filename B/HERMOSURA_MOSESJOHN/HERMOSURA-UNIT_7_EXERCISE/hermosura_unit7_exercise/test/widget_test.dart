import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'dart:convert';

import 'package:hermosura_unit7_exercise/main.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  testWidgets('navigation switches between Profile and My Pet', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(320, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MyApp());

    expect(find.text('Moses John Hermosura'), findsNWidgets(2));
    expect(find.text('My Pet'), findsOneWidget);
    expect(find.text('Course'), findsOneWidget);
    expect(find.text('BSIT'), findsOneWidget);
    expect(find.text('West Visayas State University'), findsOneWidget);
    expect(find.text('Tilap'), findsOneWidget);
    expect(find.byType(InfoTile), findsNWidgets(5));
    expect(find.text('Sagad mag standing sa modern jeep'), findsOneWidget);
    expect(find.text('My Biography'), findsOneWidget);
    expect(find.text('My Hobbies'), findsOneWidget);
    expect(find.byType(Chip), findsNWidgets(5));
    expect(find.text('My Class Schedule'), findsOneWidget);
    expect(find.byType(Table), findsOneWidget);
    expect(
      find.textContaining('I am Moses, 20, and currently a 3rd Year BSIT'),
      findsOneWidget,
    );
    expect(
      find.bySemanticsLabel('Photo of Moses John Hermosura'),
      findsOneWidget,
    );
    expect(
      tester.widget<NavigationBar>(find.byType(NavigationBar)).selectedIndex,
      0,
    );

    await tester.tap(find.text('My Pet').last);
    await tester.pump();
    expect(
      tester.widget<NavigationBar>(find.byType(NavigationBar)).selectedIndex,
      1,
    );
    expect(find.text('Tilap is my pet cat'), findsOneWidget);
    expect(find.text('Reset count'), findsOneWidget);
    expect(find.bySemanticsLabel('Photo of Tilap, my cat'), findsOneWidget);

    final photoFinder = find.bySemanticsLabel('Photo of Tilap, my cat');

    Future<void> doubleTapPhoto() async {
      final position = tester.getCenter(photoFinder);
      final firstTap = await tester.startGesture(position);
      await firstTap.up();
      await tester.pump(const Duration(milliseconds: 50));
      final secondTap = await tester.startGesture(position);
      await secondTap.up();
      await tester.pump();
    }

    await doubleTapPhoto();
    expect(find.byIcon(Icons.favorite), findsOneWidget);
    await doubleTapPhoto();
    expect(find.byIcon(Icons.favorite), findsNothing);
    await tester.pump(const Duration(milliseconds: 400));

    await tester.tap(find.text('Profile').last);
    await tester.pump();
    expect(
      tester.widget<NavigationBar>(find.byType(NavigationBar)).selectedIndex,
      0,
    );
  });
  test('Book.fromJson keeps only the ID and handles missing fields', () {
    final book = Book.fromJson({
      'key': '/works/OL27482W',
      'title': 'The Hobbit',
    });
    expect(book.workId, 'OL27482W');
    expect(book.authors, isEmpty);
    expect(book.year, isNull);
    expect(book.coverId, isNull);
  });
  test('Movie.fromJson treats a Poster of N/A as no poster', () {
    final movie = Movie.fromJson({
      'Title': 'Interstellar',
      'Year': '2014',
      'imdbID': 'tt0816692',
      'Poster': 'N/A',
    });
    expect(movie.imdbId, 'tt0816692');
    expect(movie.poster, isNull);
  });
  test('ContentfulPickSource turns Contentful JSON into Picks', () async {
    final client = MockClient((request) async {
      expect(request.url.queryParameters['content_type'], 'pick');
      expect(request.headers['Authorization'], 'Bearer t');
      return http.Response(
        jsonEncode({
          'items': [
            {
              'sys': {'id': 'a1'},
              'fields': {
                'title': 'The Hobbit',
                'kind': 'book',
                'externalId': 'OL27482W',
                'note': 'Great',
              },
            },
          ],
        }),
        200,
      );
    });
    final picks = await ContentfulPickSource(
      client,
      spaceId: 's',
      token: 't',
    ).fetchPicks();
    expect(picks.single.externalId, 'OL27482W');
    expect(picks.single.isBook, isTrue);
  });
}
