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
      final List<FairEvent> events = await source.fetchEvents();

      _lastGood = events;

      return EventLoad(events);
    } catch (error) {
      if (_lastGood != null) {
        return EventLoad(
          _lastGood!,
          savedCopy: true,
        );
      }

      if (error is CmsException) {
        rethrow;
      }

      throw CmsException(
        'Could not read the events from ${source.name}: $error',
      );
    }
  }

  Future<EventLoad> loadForOrg(String orgId) async {
    final EventLoad all = await load();

    return EventLoad(
      all.events.where((event) => event.orgId == orgId).toList(),
      savedCopy: all.savedCopy,
    );
  }
}