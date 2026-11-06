import '../models/fair_event.dart';
import 'event_source.dart';

class EventLoad {
  const EventLoad(this.events, {this.savedCopy = false});

  final List<FairEvent> events;

  final bool savedCopy;
}

class EventRepository {
  EventRepository(this.source);

  final EventSource source;

  List<FairEvent>? _lastGood;

  Future<EventLoad> load() async {
    try {
      final events = await source.fetchEvents();
      _lastGood = events;
      return EventLoad(events);
    } catch (error) {
      final saved = _lastGood;
      if (saved != null) return EventLoad(saved, savedCopy: true);
      if (error is CmsException) rethrow;
      throw CmsException(
        'Could not read the events from ${source.name}: $error',
      );
    }
  }

  Future<EventLoad> loadForOrg(String orgId) async {
    final all = await load();
    return EventLoad(
      all.events.where((e) => e.orgId == orgId).toList(),
      savedCopy: all.savedCopy,
    );
  }
}
