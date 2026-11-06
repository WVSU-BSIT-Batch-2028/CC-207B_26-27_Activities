import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:acebuche_unit7_exercise/shelf.dart';

void main() {
  testWidgets(
    'book debounce starts search without returning Future from setState',
    (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: SearchTab(movie: false))),
      );
      await tester.enterText(find.byType(TextField), 'The Hobbit');
      await tester.pump(const Duration(milliseconds: 501));
      expect(tester.takeException(), isNull);
      expect(find.text('Type at least 3 characters to search.'), findsNothing);
      await tester.pumpAndSettle();
      await tester.pumpWidget(const SizedBox());
    },
  );
  test('Book accepts omitted optional fields and strips work path', () {
    final book = Book.fromJson({
      'key': '/works/OL27482W',
      'title': 'The Hobbit',
    });
    expect(book.workId, 'OL27482W');
    expect(book.authors, isEmpty);
    expect(book.coverId, isNull);
    expect(book.year, isNull);
  });
  test('Pick rejects IDs for the wrong API', () {
    expect(
      () => Pick.fromJson({'kind': 'book', 'externalId': 'tt0816692'}),
      throwsA(isA<ApiException>()),
    );
    final pick = Pick.fromJson({
      'title': 'Interstellar',
      'kind': 'movie',
      'externalId': 'tt0816692',
      'note': 'A recommendation',
    });
    expect(pick.note, 'A recommendation');
  });
}
