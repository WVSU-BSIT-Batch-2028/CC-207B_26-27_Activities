import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'package:amaguin_unit7_exercise/screens/book_search_screen.dart';
import 'package:amaguin_unit7_exercise/services/open_library_api.dart';

Widget app(OpenLibraryApi api) => MaterialApp(
  home: Scaffold(body: BookSearchScreen(api: api)),
);

http.Response result(String title) => http.Response(
  jsonEncode({
    'docs': [
      {'key': '/works/OL27482W', 'title': title},
    ],
  }),
  200,
);

void main() {
  testWidgets(
    'Search waits 500 ms, ignores short input, and rejects stale results',
    (tester) async {
      final queries = <String>[];
      final pending = <Completer<http.Response>>[];
      final api = OpenLibraryApi(
        client: MockClient((request) {
          queries.add(request.url.queryParameters['q']!);
          final response = Completer<http.Response>();
          pending.add(response);
          return response.future;
        }),
      );
      addTearDown(api.close);
      await tester.pumpWidget(app(api));

      await tester.enterText(find.byType(TextField), 'ha');
      await tester.pump(const Duration(milliseconds: 600));
      expect(queries, isEmpty);
      await tester.enterText(find.byType(TextField), 'hob');
      await tester.pump(const Duration(milliseconds: 300));
      await tester.enterText(find.byType(TextField), ' hobbit ');
      await tester.pump(const Duration(milliseconds: 499));
      expect(queries, isEmpty);
      await tester.pump(const Duration(milliseconds: 1));
      await tester.pump();
      expect(queries, ['hobbit']);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.enterText(find.byType(TextField), 'dune');
      pending.first.complete(result('Old result'));
      await tester.pump();
      expect(find.text('Old result'), findsNothing);
      await tester.pump(const Duration(milliseconds: 500));
      pending.last.complete(result('New result'));
      await tester.pumpAndSettle();
      expect(queries, ['hobbit', 'dune']);
      expect(find.text('New result'), findsOneWidget);

      await tester.enterText(find.byType(TextField), 'a');
      await tester.pumpAndSettle();
      expect(find.text('New result'), findsNothing);
      expect(queries.length, 2);
    },
  );

  testWidgets(
    'Search displays errors, retries, empty results, fallbacks, and copies the ID',
    (tester) async {
      var requests = 0;
      String? copied;
      final api = OpenLibraryApi(
        client: MockClient((_) async {
          requests++;
          if (requests == 1) return http.Response('Unavailable', 503);
          if (requests == 2) return http.Response('{"docs":[]}', 200);
          return result('The Hobbit');
        }),
      );
      addTearDown(api.close);
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        (call) async {
          if (call.method == 'Clipboard.setData') {
            copied = (call.arguments as Map)['text'] as String;
          }
          return null;
        },
      );
      addTearDown(
        () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
          SystemChannels.platform,
          null,
        ),
      );

      await tester.pumpWidget(app(api));
      await tester.enterText(find.byType(TextField), 'hobbit');
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pumpAndSettle();
      expect(find.textContaining('unavailable'), findsOneWidget);
      await tester.tap(find.text('Retry'));
      await tester.pumpAndSettle();
      expect(find.text('Nothing found'), findsOneWidget);

      await tester.enterText(find.byType(TextField), 'the hobbit');
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pumpAndSettle();
      expect(find.text('The Hobbit'), findsOneWidget);
      expect(
        find.textContaining('Unknown author · Unknown year'),
        findsOneWidget,
      );
      expect(find.byIcon(Icons.menu_book), findsOneWidget);
      await tester.tap(find.byTooltip('Copy ID for The Hobbit'));
      await tester.pump();
      expect(copied, 'OL27482W');
      expect(find.text('Copied ID: OL27482W'), findsOneWidget);
    },
  );

  testWidgets('Leaving the screen cancels a pending debounce', (tester) async {
    var requests = 0;
    final api = OpenLibraryApi(
      client: MockClient((_) async {
        requests++;
        return result('The Hobbit');
      }),
    );
    addTearDown(api.close);
    await tester.pumpWidget(app(api));
    await tester.enterText(find.byType(TextField), 'hobbit');
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(milliseconds: 600));
    expect(requests, 0);
    expect(tester.takeException(), isNull);
  });
}
