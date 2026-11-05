import 'package:flutter/material.dart';

import '../data/event_repository.dart';
import '../widgets/event_tile.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({
    super.key,
    required this.repository,
  });

  final EventRepository repository;

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
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

    await _future;
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
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.cloud_off,
                    size: 48,
                  ),
                  const SizedBox(height: 12),
                  const Text('Could not load events.'),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: _refresh,
                    child: const Text('Try again'),
                  ),
                ],
              ),
            );
          }

          final result = snapshot.data;

          if (result == null) {
            return const Center(
              child: Text('No events available.'),
            );
          }

          final events = [...result.events]
            ..sort(
              (a, b) => a.startsAt.compareTo(b.startsAt),
            );

          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                if (result.savedCopy)
                  MaterialBanner(
                    content: const Text(
                      'You are offline. Showing saved events.',
                    ),
                    leading: const Icon(Icons.cloud_off),
                    actions: [
                      TextButton(
                        onPressed: _refresh,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),

                if (events.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(32),
                    child: Center(
                      child: Text('No events available.'),
                    ),
                  )
                else
                  ...events.map(
                    (event) => EventTile(
                      event: event,
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}