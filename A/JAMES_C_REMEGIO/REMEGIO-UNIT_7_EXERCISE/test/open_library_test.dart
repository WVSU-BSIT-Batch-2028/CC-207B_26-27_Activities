import 'package:cc207b_unit5/api/open_library_api.dart';
import 'package:cc207b_unit5/models/book.dart';
import 'package:cc207b_unit5/models/book_details.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  test('work id is the last piece of the Open Library key', () {
    final Book book = Book.fromJson(<String, dynamic>{
      'key': '/works/OL27482W',
      'title': 'The Hobbit',
      'author_name': <String>['J.R.R. Tolkien'],
      'first_publish_year': 1937,
      'cover_i': 14627509,
    });

    expect(book.workId, 'OL27482W');
    expect(book.title, 'The Hobbit');
    expect(book.authors, <String>['J.R.R. Tolkien']);
    expect(book.year, 1937);
    expect(book.coverId, 14627509);
    expect(openLibraryCoverUrl(14627509),
        'https://covers.openlibrary.org/b/id/14627509-M.jpg');
  });

  test('missing author_name and cover_i stay empty and null', () {
    final Book book = Book.fromJson(<String, dynamic>{
      'key': '/works/OL1W',
      'title': 'A work with no author listed',
    });

    expect(book.workId, 'OL1W');
    expect(book.authors, isEmpty);
    expect(book.authorLabel, 'Unknown author');
    expect(book.year, isNull);
    expect(book.yearLabel, 'Year unknown');
    expect(book.coverId, isNull);
  });

  test('description accepts a string and an object with value', () {
    expect(
      descriptionFromOpenLibrary('A plain summary.'),
      'A plain summary.',
    );
    expect(
      descriptionFromOpenLibrary(<String, dynamic>{
        'type': '/type/text',
        'value': 'A wrapped summary.',
      }),
      'A wrapped summary.',
    );
    expect(descriptionFromOpenLibrary(null), 'No description yet.');
    expect(descriptionFromOpenLibrary('   '), 'No description yet.');
    expect(
      descriptionFromOpenLibrary(<String, dynamic>{'value': ''}),
      'No description yet.',
    );
    expect(
      descriptionFromOpenLibrary(<String, dynamic>{'value': 12}),
      'No description yet.',
    );
  });

  test('work details use cover ids and do not invent a year', () {
    final BookDetails withDate = BookDetails.fromWorkJson(<String, dynamic>{
      'title': 'Noli Me Tangere',
      'description': 'Ibarra returns home.',
      'first_publish_date': '1912',
      'covers': <Object>[-1, 5738053, 1845937],
      'created': <String, String>{
        'type': '/type/datetime',
        'value': '2009-10-13T02:46:28.838662',
      },
    });
    expect(withDate.year, 1912);
    expect(withDate.coverId, 5738053);
    expect(withDate.summary, 'Ibarra returns home.');

    final BookDetails noDate = BookDetails.fromWorkJson(<String, dynamic>{
      'title': 'No date',
      'description': <String, String>{'value': 'Wrapped.'},
      'created': <String, String>{'value': '2009-10-13T02:46:28.838662'},
    });
    expect(noDate.year, isNull);
    expect(noDate.coverId, isNull);
    expect(noDate.summary, 'Wrapped.');
    expect(
        yearFromOpenLibraryWork(<String, dynamic>{
          'first_publish_date': 'January 1938',
        }),
        1938);
  });

  test('search builds the Open Library URL and reads docs', () async {
    late http.Request sent;
    final http.Client client = MockClient((http.Request request) async {
      sent = request;
      return http.Response(
        '''
        {"docs":[{"key":"/works/OL27482W","title":"The Hobbit","author_name":["J.R.R. Tolkien"],"first_publish_year":1937,"cover_i":14627509}]}
        ''',
        200,
      );
    });
    final OpenLibraryApi api = OpenLibraryApi(client: client);
    final List<Book> books = await api.search('the hobbit');

    expect(sent.url.host, 'openlibrary.org');
    expect(sent.url.path, '/search.json');
    expect(sent.url.queryParameters['q'], 'the hobbit');
    expect(
      sent.url.queryParameters['fields'],
      'key,title,author_name,first_publish_year,cover_i',
    );
    expect(sent.url.queryParameters['limit'], '20');
    expect(books.single.workId, 'OL27482W');
    api.close();
  });
}
