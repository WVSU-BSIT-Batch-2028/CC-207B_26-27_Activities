import '../models/fair_event.dart';
import 'event_source.dart';

/// What one load gives the screens.
class EventLoad {
  const EventLoad(this.events, {this.savedCopy = false});

  final List<FairEvent> events;

  /// True when the CMS could not be reached and these are the events from
  /// the last good load.
  final bool savedCopy;
}

/// Sits between the screens and the source. Keeps the last good list so the
/// app still shows something when the internet drops.
class EventRepository {
  EventRepository(this.source);

  final EventSource source;

  // EXPLAIN E5: Offline, the app shows the events it loaded earlier, with a
  // banner. Is that a bug or a feature? This copy lives in memory only: what
  // happens if the user closes the app and opens it again with no internet?
  //It's a feature the users still see the events rather than error when offline.
  //_lastGood is memory-only, so closing and reopening the app offline leaves no saved copy and shows an error.
  List<FairEvent>? _lastGood;

  Future<EventLoad> load() async {
    try {
      final events = await source.fetchEvents();
      // TODO 4: Save events in _lastGood, then return EventLoad(events).
      _lastGood = events;
      return EventLoad(events);
    } catch (error) {
      // TODO 5: If there is a saved copy, return it with savedCopy: true.
      final saved = _lastGood;
      if (saved != null) return EventLoad(saved, savedCopy: true);
      // Only when there is none, let the error through (the code below).
      if (error is CmsException) rethrow;
      // Usually a field name that does not match your CMS (a null where a
      // String was expected). The message tells you which type was wrong.
      throw CmsException(
        'Could not read the events from ${source.name}: $error',
      );
    }
  }

  /// The events of one org.
  Future<EventLoad> loadForOrg(String orgId) async {
    final all = await load();
    return EventLoad(
      all.events.where((e) => e.orgId == orgId).toList(),
      savedCopy: all.savedCopy,
    );
  }
}
