import 'package:flutter/material.dart';

import '../data/event_repository.dart';
import '../widgets/event_tile.dart';
import '../widgets/state_message.dart';

/// "What's On": every event of every org, from the CMS.
class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key, required this.repository});

  final EventRepository repository;

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  // EXPLAIN E6: build() can run many times (setState, rotation, keyboard, parent
  // rebuilds). If load() were called inside build(), every rebuild would send a
  // new request and reset the FutureBuilder to loading. Starting it in initState
  // sends exactly one request when the screen opens, and _refresh sends another
  // only when the user asks.
  late Future<EventLoad> _future;

  @override
  void initState() {
    super.initState();
    _future = widget.repository.load();
  }

  Future<void> _refresh() async {
    setState(() {
      _future = widget.repository.load();
    });
    try {
      await _future;
    } catch (_) {
      // The FutureBuilder already shows the error, so do nothing here.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("What's On"),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            icon: const Icon(Icons.refresh),
            onPressed: _refresh,
          ),
        ],
      ),
      body: FutureBuilder<EventLoad>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done &&
              !snapshot.hasData) {
            return const StateMessage(
              icon: Icons.hourglass_top,
              text: 'Loading events...',
              showSpinner: true,
            );
          }
          if (snapshot.hasError) {
            return StateMessage(
              icon: Icons.cloud_off,
              text: '${snapshot.error}',
              action: FilledButton.icon(
                onPressed: _refresh,
                icon: const Icon(Icons.refresh),
                label: const Text('Try again'),
              ),
            );
          }
          return _buildEvents(snapshot.data!);
        },
      ),
    );
  }

  Widget _buildEvents(EventLoad load) {
        final events = [...load.events]
      ..sort((a, b) => a.startsAt.compareTo(b.startsAt));

  // EXPLAIN E7: RefreshIndicator only shows its spinner while the Future from
// onRefresh is still pending. If _refresh returned right away, the spinner would
// flash and vanish before the CMS answered, so the user would see no sign that
// anything was loading and the list would change later with no explanation.
    return RefreshIndicator(
      onRefresh: _refresh,
      child: ListView(
        // Lets you pull to refresh even when the list is short.
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          // TODO 8: When load.savedCopy is true, show a MaterialBanner at the
                      if (load.savedCopy)
              MaterialBanner(
                content: const Text(
                  'No connection. Showing the events saved earlier.',
                ),
                actions: [
                  TextButton(
                    onPressed: _refresh,
                    child: const Text('Retry'),
                  ),
                ],
              ),
 if (events.isEmpty)
              const Padding(
                padding: EdgeInsets.only(top: 120),
                child: StateMessage(
                  icon: Icons.event_note,
                  text: 'No events yet. Org officers can add them in the CMS.',
                ), // StateMessage
              ) // Padding
            else
              for (final event in events) EventTile(event: event),
          ],
      ),
    );
  }
}
