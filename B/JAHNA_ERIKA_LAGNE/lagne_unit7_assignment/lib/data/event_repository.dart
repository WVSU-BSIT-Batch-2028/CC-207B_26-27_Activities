
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

  List<FairEvent>? _lastGood;

  Future<EventLoad> load() async {
    try {
      final events = await source.fetchEvents();

      // TODO 4: Save the latest successful events.
      _lastGood = events;

      return EventLoad(events);
    } catch (error) {
      // TODO 5: Use the saved events if the CMS is unavailable.
      if (_lastGood != null) {
        return EventLoad(_lastGood!, savedCopy: true);
      }

      if (error is CmsException) rethrow;

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
