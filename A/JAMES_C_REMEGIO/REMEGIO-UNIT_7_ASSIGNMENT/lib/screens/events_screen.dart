import 'package:flutter/material.dart';

import '../data/event_repository.dart';
import '../models/fair_event.dart';
import '../widgets/event_tile.dart';
import '../widgets/saved_copy_banner.dart';
import '../widgets/state_message.dart';

/// "What's On": every event of every org, from the CMS.
class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key, required this.repository});

  final EventRepository repository;

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  // EXPLAIN E6: The request starts in initState, and again only in
  // _refresh. Why not write future: widget.repository.load() inside build()?
  // How many requests would the app send, and when?
  late Future<EventLoad> _future;

  @override
  void initState() {
    super.initState();
    _future = widget.repository.load();
  }

  Future<void> _refresh() async {
    late final Future<EventLoad> next;
    setState(() {
      next = widget.repository.load();
      _future = next;
    });
    try {
      await next;
    } catch (_) {
      // A first-time failure stays in the Future. FutureBuilder shows it.
      // A later failure resolves with the saved copy instead of throwing.
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
    // Copy first. Sorting this list must not reorder the repository's list.
    final events = sortedByStart(load.events);

    // EXPLAIN E7: RefreshIndicator calls onRefresh and hides its spinner
    // when the Future it gets back completes. What would the user see if
    // _refresh returned right away, before the CMS answered?
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth > 760 ? 760.0 : constraints.maxWidth;
        return Align(
          alignment: Alignment.topCenter,
          child: SizedBox(
            width: width,
            height: constraints.maxHeight,
            child: RefreshIndicator(
              onRefresh: _refresh,
              child: ListView(
                // Lets you pull to refresh even when the list is short.
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 24),
                children: [
                  const _EventsIntro(),
                  if (load.savedCopy) SavedCopyBanner(onRetry: _refresh),
                  if (events.isEmpty)
                    const Padding(
                      padding: EdgeInsets.only(top: 80),
                      child: StateMessage(
                        icon: Icons.event_note,
                        text:
                            'No events yet. Org officers can add them in the CMS.',
                      ),
                    )
                  else
                    for (final event in events) EventTile(event: event),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _EventsIntro extends StatelessWidget {
  const _EventsIntro();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(
        'Published events, earliest first. Pull down to refresh.',
        style: Theme.of(
          context,
        ).textTheme.bodyMedium?.copyWith(color: colors.onSurfaceVariant),
      ),
    );
  }
}
