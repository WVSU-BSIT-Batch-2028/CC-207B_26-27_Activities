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

// EXPLAIN E5: It is a feature, not a bug. Showing the last good list with a
// banner is better than an empty screen, and the banner warns it may be old.
// But _lastGood only lives in memory, so if the app is closed and reopened with
// no internet, the copy is gone and the user just sees an error. Saving the
// list to the device (e.g. shared_preferences or a file) would fix that.
  List<FairEvent>? _lastGood;

  Future<EventLoad> load() async {
    try {
      final events = await source.fetchEvents();
      _lastGood = events;
      return EventLoad(events);
    } catch (error) {
           final saved = _lastGood;
      if (saved != null) {
        return EventLoad(saved, savedCopy: true);
      }
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
