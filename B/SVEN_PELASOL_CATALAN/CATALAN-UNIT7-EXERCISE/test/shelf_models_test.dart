import 'package:flutter_test/flutter_test.dart';
import 'package:catalan_unit7_exercise/models/book.dart';
import 'package:catalan_unit7_exercise/models/pick.dart';

void main() {
  group('Book.fromJson', () {
    test('keeps only the Open Library work ID segment', () {
      final book = Book.fromJson(<String, dynamic>{
        'key': '/works/OL27482W',
        'title': 'The Hobbit',
        'author_name': <String>['J.R.R. Tolkien'],
        'first_publish_year': 1937,
        'cover_i': 14627509,
      });

      expect(book.workId, 'OL27482W');
      expect(book.title, 'The Hobbit');
      expect(book.authors.first, 'J.R.R. Tolkien');
      expect(book.year, 1937);
      expect(book.coverId, 14627509);
    });

    test('handles missing authors and covers', () {
      final book = Book.fromJson(<String, dynamic>{
        'key': '/works/OL123W',
        'title': 'A book without optional search fields',
      });

      expect(book.workId, 'OL123W');
      expect(book.authors, isEmpty);
      expect(book.year, isNull);
      expect(book.coverId, isNull);
    });
  });

  group('Pick.fromJson', () {
    test('reads Contentful fields', () {
      final pick = Pick.fromJson(<String, dynamic>{
        'fields': <String, dynamic>{
          'title': 'The Hobbit',
          'kind': 'book',
          'externalId': 'OL27482W',
          'note': 'A favourite fantasy adventure.',
        },
      });

      expect(pick.title, 'The Hobbit');
      expect(pick.kind, 'book');
      expect(pick.externalId, 'OL27482W');
      expect(pick.note, 'A favourite fantasy adventure.');
      expect(pick.isBook, isTrue);
      expect(pick.isMovie, isFalse);
    });

    test('normalizes kind and handles absent note', () {
      final pick = Pick.fromJson(<String, dynamic>{
        'fields': <String, dynamic>{
          'title': 'Interstellar',
          'kind': 'MOVIE',
          'externalId': 'tt0816692',
        },
      });

      expect(pick.kind, 'movie');
      expect(pick.isMovie, isTrue);
      expect(pick.note, isEmpty);
    });
  });
}
