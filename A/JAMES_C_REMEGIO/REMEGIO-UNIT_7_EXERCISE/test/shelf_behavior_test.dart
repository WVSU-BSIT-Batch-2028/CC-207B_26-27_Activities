import 'dart:async';

import 'package:cc207b_unit5/api/open_library_api.dart';
import 'package:cc207b_unit5/cms/pick_source.dart';
import 'package:cc207b_unit5/models/book.dart';
import 'package:cc207b_unit5/models/pick.dart';
import 'package:cc207b_unit5/screens/books_screen.dart';
import 'package:cc207b_unit5/screens/movies_screen.dart';
import 'package:cc207b_unit5/screens/picks_screen.dart';
import 'package:cc207b_unit5/screens/shelf_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('book search debounces and a cleared query ignores the old hit', (
    WidgetTester tester,
  ) async {
    final _PendingBooks api = _PendingBooks();
    await tester.pumpWidget(
      MaterialApp(home: Scaffold(body: BooksScreen(api: api))),
    );

    await tester.enterText(find.byType(TextField), 'ho');
    await tester.pump(const Duration(milliseconds: 500));
    expect(api.queries, isEmpty);
    expect(find.text('Type at least 3 letters to search Open Library.'),
        findsOneWidget);

    await tester.enterText(find.byType(TextField), 'hob');
    await tester.pump(const Duration(milliseconds: 400));
    await tester.enterText(find.byType(TextField), 'hobbit');
    await tester.pump(const Duration(milliseconds: 499));
    expect(api.queries, isEmpty);
    await tester.pump(const Duration(milliseconds: 1));
    expect(api.queries, <String>['hobbit']);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.enterText(find.byType(TextField), '');
    await tester.pump();
    api.completers['hobbit']!.complete(<Book>[_hobbit]);
    await tester.pump();
    expect(find.text('The Hobbit'), findsNothing);
    expect(
      find.text('Type at least 3 letters to search Open Library.'),
      findsOneWidget,
    );

    await tester.enterText(find.byType(TextField), '  hob');
    await tester.pump(const Duration(milliseconds: 500));
    expect(api.queries, <String>['hobbit', 'hob']);
  });

  testWidgets('a book result copies its work id', (WidgetTester tester) async {
    final List<String?> copied = <String?>[];
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (MethodCall call) async {
        if (call.method == 'Clipboard.setData') {
          final Map<Object?, Object?> args =
              call.arguments as Map<Object?, Object?>;
          copied.add(args['text'] as String?);
        }
        return null;
      },
    );
    addTearDown(() {
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        null,
      );
    });

    await tester.pumpWidget(
      MaterialApp(home: Scaffold(body: BooksScreen(api: _ReadyBooks()))),
    );
    await tester.enterText(find.byType(TextField), 'hobbit');
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump();

    expect(find.text('The Hobbit'), findsOneWidget);
    expect(find.text('J.R.R. Tolkien'), findsOneWidget);
    expect(find.text('1937'), findsOneWidget);

    await tester.tap(find.byTooltip('Copy work ID'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(copied, <String>['OL27482W']);
    expect(find.text('Copied OL27482W'), findsOneWidget);
  });

  testWidgets('Movies explains the missing key and does not show a search box',
      (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: MoviesScreen(apiKey: ''))),
    );
    expect(find.text('OMDb needs an API key'), findsOneWidget);
    expect(find.textContaining('OMDB_KEY'), findsOneWidget);
    expect(find.byType(TextField), findsNothing);
  });

  testWidgets('My Picks loads once, then again when pulled to refresh', (
    WidgetTester tester,
  ) async {
    final _ScriptedPicks source = _ScriptedPicks(<List<Pick>>[
      <Pick>[_pick('A first note.')],
      <Pick>[_pick('A refreshed note.')],
    ]);
    await tester.pumpWidget(
      MaterialApp(home: Scaffold(body: PicksScreen(source: source))),
    );
    await tester.pumpAndSettle();

    expect(source.calls, 1);
    expect(find.text('The Hobbit'), findsOneWidget);
    expect(find.text('A first note.'), findsOneWidget);

    await tester.pump();
    expect(source.calls, 1, reason: 'A rebuild must not fetch again');

    await tester.fling(find.byType(ListView), const Offset(0, 400), 1200);
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    await tester.pump(const Duration(seconds: 1));

    expect(source.calls, 2);
    expect(find.text('A refreshed note.'), findsOneWidget);
    expect(find.text('A first note.'), findsNothing);
  });

  testWidgets('an empty shelf can still be pulled to refresh', (
    WidgetTester tester,
  ) async {
    final _ScriptedPicks source = _ScriptedPicks(<List<Pick>>[
      const <Pick>[],
      <Pick>[_pick('Now there is a note.')],
    ]);
    await tester.pumpWidget(
      MaterialApp(home: Scaffold(body: PicksScreen(source: source))),
    );
    await tester.pumpAndSettle();
    expect(find.textContaining('Nothing on your shelf'), findsOneWidget);

    await tester.fling(find.byType(ListView), const Offset(0, 400), 1200);
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    await tester.pump(const Duration(seconds: 1));

    expect(source.calls, 2);
    expect(find.text('Now there is a note.'), findsOneWidget);
  });

  testWidgets('shelf tabs keep a book search when leaving and coming back', (
    WidgetTester tester,
  ) async {
    final _ReadyBooks books = _ReadyBooks();
    await tester.pumpWidget(
      MaterialApp(
        home: ShelfScreen(
          pickSource: _EmptyPicks(),
          booksApi: books,
          apiKey: '',
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Books'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'hobbit');
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump();
    expect(find.text('The Hobbit'), findsOneWidget);

    await tester.tap(find.text('Movies'));
    await tester.pumpAndSettle();
    expect(find.text('OMDb needs an API key'), findsOneWidget);

    await tester.tap(find.text('Books'));
    await tester.pumpAndSettle();
    expect(find.text('The Hobbit'), findsOneWidget);
    expect(books.queries, <String>['hobbit']);
  });
}

const Book _hobbit = Book(
  workId: 'OL27482W',
  title: 'The Hobbit',
  authors: <String>['J.R.R. Tolkien'],
  year: 1937,
  coverId: 14627509,
);

Pick _pick(String note) {
  return Pick(
    id: 'hobbit',
    title: 'The Hobbit',
    kind: 'book',
    externalId: 'OL27482W',
    note: note,
  );
}

class _PendingBooks extends OpenLibraryApi {
  _PendingBooks() : super(client: _SilentClient());

  final Map<String, Completer<List<Book>>> completers =
      <String, Completer<List<Book>>>{};
  final List<String> queries = <String>[];

  @override
  Future<List<Book>> search(String query) {
    queries.add(query);
    final Completer<List<Book>> completer = Completer<List<Book>>();
    completers[query] = completer;
    return completer.future;
  }

  @override
  void close() {}
}

class _ReadyBooks extends OpenLibraryApi {
  _ReadyBooks() : super(client: _SilentClient());

  final List<String> queries = <String>[];

  @override
  Future<List<Book>> search(String query) async {
    queries.add(query);
    return <Book>[
      const Book(
        workId: 'OL27482W',
        title: 'The Hobbit',
        authors: <String>['J.R.R. Tolkien'],
        year: 1937,
        coverId: null,
      ),
    ];
  }

  @override
  void close() {}
}

class _ScriptedPicks implements PickSource {
  _ScriptedPicks(this.pages);

  final List<List<Pick>> pages;
  int calls = 0;

  @override
  Future<List<Pick>> fetchPicks() async {
    final int index = calls >= pages.length ? pages.length - 1 : calls;
    calls += 1;
    return pages[index];
  }
}

class _EmptyPicks implements PickSource {
  @override
  Future<List<Pick>> fetchPicks() async => const <Pick>[];
}

class _SilentClient extends http.BaseClient {
  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    return Future<http.StreamedResponse>.error(
        StateError('unexpected network'));
  }
}
