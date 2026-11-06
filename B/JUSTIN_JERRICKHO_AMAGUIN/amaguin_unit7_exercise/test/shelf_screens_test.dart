import 'dart:async';
import 'dart:convert';
import 'dart:ui' show PointerDeviceKind;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'package:amaguin_unit7_exercise/models/pick.dart';
import 'package:amaguin_unit7_exercise/models/shelf_detail.dart';
import 'package:amaguin_unit7_exercise/screens/movie_search_screen.dart';
import 'package:amaguin_unit7_exercise/screens/my_picks_screen.dart';
import 'package:amaguin_unit7_exercise/screens/pick_detail_screen.dart';
import 'package:amaguin_unit7_exercise/services/api_exception.dart';
import 'package:amaguin_unit7_exercise/services/omdb_api.dart';
import 'package:amaguin_unit7_exercise/services/pick_source.dart';

Widget app(Widget screen) => MaterialApp(home: Scaffold(body: screen));
const pick = Pick(
  title: 'The Hobbit',
  kind: PickKind.book,
  externalId: 'OL27482W',
  note: 'An adventure worth reading.',
);

class CallbackSource implements PickSource {
  CallbackSource(this.load);
  final Future<List<Pick>> Function() load;
  @override
  Future<List<Pick>> fetchPicks() => load();
}

void main() {
  testWidgets('Movies explains missing configuration and does not search', (
    tester,
  ) async {
    await tester.pumpWidget(app(const MovieSearchScreen(apiKey: '')));
    expect(find.textContaining('OMDB_KEY'), findsOneWidget);
    expect(find.byType(TextField), findsNothing);
  });

  testWidgets('Movies debounces, shows a poster fallback, and copies IMDb ID', (
    tester,
  ) async {
    final queries = <String>[];
    String? copied;
    final api = OmdbApi(
      key: 'test',
      client: MockClient((request) async {
        queries.add(request.url.queryParameters['s']!);
        return http.Response(
          jsonEncode({
            'Response': 'True',
            'Search': [
              {
                'Title': 'Interstellar',
                'Year': '2014',
                'imdbID': 'tt0816692',
                'Poster': 'N/A',
              },
            ],
          }),
          200,
        );
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
    await tester.pumpWidget(app(MovieSearchScreen(api: api)));
    await tester.enterText(find.byType(TextField), 'in');
    await tester.pump(const Duration(milliseconds: 600));
    expect(queries, isEmpty);
    await tester.enterText(find.byType(TextField), 'interstellar');
    await tester.pump(const Duration(milliseconds: 499));
    expect(queries, isEmpty);
    await tester.pump(const Duration(milliseconds: 1));
    await tester.pumpAndSettle();
    expect(queries, ['interstellar']);
    expect(find.text('Interstellar'), findsOneWidget);
    expect(find.byIcon(Icons.movie_outlined), findsOneWidget);
    await tester.tap(find.byTooltip('Copy ID for Interstellar'));
    await tester.pump();
    expect(copied, 'tt0816692');
    expect(find.text('Copied ID: tt0816692'), findsOneWidget);
  });

  testWidgets(
    'Picks requests once in initState and pull to refresh changes its note',
    (tester) async {
      var calls = 0;
      Pick? opened;
      final source = CallbackSource(() async {
        calls++;
        return [
          Pick(
            title: pick.title,
            kind: pick.kind,
            externalId: pick.externalId,
            note: 'Note $calls',
          ),
        ];
      });
      await tester.pumpWidget(
        app(MyPicksScreen(source: source, onOpen: (p) => opened = p)),
      );
      await tester.pumpAndSettle();
      expect(calls, 1);
      expect(find.text('Note 1'), findsOneWidget);
      await tester.tap(find.text('The Hobbit'));
      expect(opened?.externalId, pick.externalId);
      await tester.drag(find.byType(ListView), const Offset(0, 350));
      await tester.pumpAndSettle();
      expect(calls, 2);
      expect(find.text('Note 2'), findsOneWidget);
      await tester.drag(
        find.byType(ListView),
        const Offset(0, 350),
        kind: PointerDeviceKind.mouse,
      );
      await tester.pumpAndSettle();
      expect(calls, 3);
      expect(find.text('Note 3'), findsOneWidget);
    },
  );

  testWidgets('Picks shows loading, error, retry, and empty states', (
    tester,
  ) async {
    final pending = Completer<List<Pick>>();
    var calls = 0;
    final source = CallbackSource(() {
      calls++;
      return calls == 1 ? pending.future : Future.value([]);
    });
    await tester.pumpWidget(app(MyPicksScreen(source: source)));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    pending.completeError(const ApiException('Offline'));
    await tester.pumpAndSettle();
    expect(find.text('Offline'), findsOneWidget);
    await tester.tap(find.text('Retry'));
    await tester.pumpAndSettle();
    expect(find.textContaining('No picks yet'), findsOneWidget);
    expect(find.byType(RefreshIndicator), findsOneWidget);
  });

  testWidgets(
    'Details retries a failure and displays API data with the CMS note',
    (tester) async {
      var calls = 0;
      await tester.pumpWidget(
        app(
          PickDetailScreen(
            pick: pick,
            loadDetails: () async {
              calls++;
              if (calls == 1) throw const ApiException('Offline');
              return const ShelfDetail(
                title: 'The Hobbit from API',
                year: '1937',
                summary: 'A journey across Middle-earth.',
              );
            },
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Offline'), findsOneWidget);
      await tester.tap(find.text('Retry'));
      await tester.pumpAndSettle();
      expect(find.text('The Hobbit from API'), findsOneWidget);
      expect(find.text(pick.note), findsOneWidget);
      expect(find.text('A journey across Middle-earth.'), findsOneWidget);
      expect(find.text('1937'), findsOneWidget);
    },
  );
}
