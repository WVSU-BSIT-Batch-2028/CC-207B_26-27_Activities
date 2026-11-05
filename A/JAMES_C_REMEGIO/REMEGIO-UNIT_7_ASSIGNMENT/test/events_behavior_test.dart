// Extra checks the starter tests do not cover. These do not replace them.
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:org_fair/data/event_repository.dart';
import 'package:org_fair/data/event_source.dart';
import 'package:org_fair/models/fair_event.dart';

import 'helpers.dart';

FairEvent event({
  required String id,
  required String orgId,
  required String title,
  required DateTime startsAt,
}) {
  return FairEvent(
    id: id,
    orgId: orgId,
    title: title,
    startsAt: startsAt,
    venue: 'Lab',
  );
}

void main() {
  test('malformed JSON on a 200 becomes a CmsException', () {
    expect(
      () => decodeOrThrow(http.Response('{not json', 200), 'Contentful'),
      throwsA(
        isA<CmsException>().having(
          (error) => error.message,
          'message',
          allOf(contains('Contentful'), contains('not valid JSON')),
        ),
      ),
    );
  });

  test('a successful empty load replaces the saved events', () async {
    final source = FakeEventSource([
      event(
        id: 'old',
        orgId: 'csc',
        title: 'Old',
        startsAt: DateTime.utc(2026, 11, 8),
      ),
    ]);
    final repository = EventRepository(source);

    await repository.load();
    source.events = [];
    final empty = await repository.load();
    expect(empty.savedCopy, isFalse);
    expect(empty.events, isEmpty);

    source.failWith = const CmsException('No connection.');
    final saved = await repository.load();
    expect(saved.savedCopy, isTrue);
    expect(saved.events, isEmpty);
  });

  test('saved copies keep the organization filter', () async {
    final source = FakeEventSource([
      event(
        id: 'csc-1',
        orgId: 'csc',
        title: 'CSC event',
        startsAt: DateTime.utc(2026, 11, 8),
      ),
      event(
        id: 'itso-1',
        orgId: 'itso',
        title: 'ITSO event',
        startsAt: DateTime.utc(2026, 11, 12),
      ),
    ]);
    final repository = EventRepository(source);
    await repository.load();

    source.failWith = const CmsException('No connection.');
    final csc = await repository.loadForOrg('csc');
    expect(csc.savedCopy, isTrue);
    expect(csc.events.map((item) => item.id), ['csc-1']);
  });

  test('sorting returns a new list and leaves the input alone', () {
    final original = [
      event(
        id: 'later',
        orgId: 'csc',
        title: 'Later',
        startsAt: DateTime.utc(2026, 11, 20),
      ),
      event(
        id: 'sooner',
        orgId: 'csc',
        title: 'Sooner',
        startsAt: DateTime.utc(2026, 11, 10),
      ),
    ];
    final sorted = sortedByStart(original);
    expect(sorted.map((item) => item.id), ['sooner', 'later']);
    expect(original.map((item) => item.id), ['later', 'sooner']);
  });

  test(
    'sorting the list given to the screen does not change the saved copy',
    () async {
      final source = FakeEventSource([
        event(
          id: 'later',
          orgId: 'csc',
          title: 'Later',
          startsAt: DateTime.utc(2026, 11, 20),
        ),
        event(
          id: 'sooner',
          orgId: 'csc',
          title: 'Sooner',
          startsAt: DateTime.utc(2026, 11, 10),
        ),
      ]);
      final repository = EventRepository(source);
      final first = await repository.load();
      final originalFirst = first.events.first.id;
      first.events.sort((a, b) => a.title.compareTo(b.title));

      source.failWith = const CmsException('No connection.');
      final saved = await repository.load();
      expect(saved.events.first.id, originalFirst);
      expect(saved.savedCopy, isTrue);
    },
  );
}
