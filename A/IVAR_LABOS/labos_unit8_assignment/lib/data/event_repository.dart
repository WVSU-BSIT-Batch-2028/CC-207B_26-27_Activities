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
  //
  // ANSWER E5: It is a feature. Old events with a banner that says so are more
  // useful than an empty error screen, and the banner keeps it honest. But the
  // copy is only in memory (_lastGood), so if the user closes the app and
  // opens it again with no internet, _lastGood is null again and the app can
  // only show the error. To fix it, the list would have to be saved on the
  // phone (a file, shared_preferences or a database) and read back on start.
  List<FairEvent>? _lastGood;

  Future<EventLoad> load() async {
    try {
      final events = await source.fetchEvents();
      _lastGood = events;
      return EventLoad(events);
    } catch (error) {
      final saved = _lastGood;
      if (saved != null) return EventLoad(saved, savedCopy: true);
      // Only when there is none, the error goes through (the code below).
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
