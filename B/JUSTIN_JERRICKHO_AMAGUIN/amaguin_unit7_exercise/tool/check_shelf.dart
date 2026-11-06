import 'dart:convert';
import 'dart:io';

import 'package:amaguin_unit7_exercise/models/pick.dart';
import 'package:amaguin_unit7_exercise/services/omdb_api.dart';
import 'package:amaguin_unit7_exercise/services/open_library_api.dart';
import 'package:amaguin_unit7_exercise/services/pick_source.dart';

Future<void> main() async {
  final file = File('cms.json');
  if (!await file.exists()) {
    stderr.writeln(
      'Create cms.json with your Contentful settings and OMDb key first.',
    );
    exitCode = 1;
    return;
  }
  final config = jsonDecode(await file.readAsString()) as Map<String, dynamic>;
  String setting(String name) => config[name] as String? ?? '';
  final books = OpenLibraryApi();
  final movies = OmdbApi(key: setting('OMDB_KEY'));
  final picks = ContentfulPickSource(
    space: setting('CMS_SPACE'),
    token: setting('CMS_TOKEN'),
    environment: setting('CMS_ENVIRONMENT').isEmpty
        ? 'master'
        : setting('CMS_ENVIRONMENT'),
  );
  try {
    final bookResults = await books.search('The Hobbit');
    final movieResults = await movies.search('Interstellar');
    if (bookResults.isEmpty || movieResults.isEmpty) {
      throw const ApiException('A live search returned no results.');
    }
    stdout.writeln('PASS Open Library and OMDb live searches');
    final published = await picks.fetchPicks();
    final bookCount = published.where((p) => p.kind == PickKind.book).length;
    final movieCount = published.where((p) => p.kind == PickKind.movie).length;
    if (bookCount < 2 ||
        movieCount < 2 ||
        published.any((p) => p.note.trim().isEmpty)) {
      throw const ApiException(
        'Publish at least two book picks and two movie picks, each with a note.',
      );
    }
    stdout.writeln(
      'PASS Contentful: $bookCount published book picks and $movieCount published movie picks',
    );
    for (final pick in published) {
      final detail = pick.kind == PickKind.book
          ? await books.details(pick.externalId)
          : await movies.details(pick.externalId);
      stdout.writeln(
        'PASS ${pick.externalId}: ${detail.title} (${detail.year ?? 'year unavailable'})',
      );
    }
    stdout.writeln('All live Shelf checks passed.');
  } on ApiException catch (error) {
    stderr.writeln('FAIL ${error.message}');
    exitCode = 1;
  } catch (_) {
    stderr.writeln(
      'FAIL Check the configuration and API response field types.',
    );
    exitCode = 1;
  } finally {
    books.close();
    movies.close();
    picks.close();
  }
}
