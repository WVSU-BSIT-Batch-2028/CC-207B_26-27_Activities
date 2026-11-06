import 'package:flutter/material.dart';

import '../models/pick.dart';
import '../services/pick_source.dart';
import '../services/contentful_pick_source.dart';
import 'pick_detail_screen.dart';


class MyPicksScreen extends StatefulWidget {
  const MyPicksScreen({super.key});

  @override
  State<MyPicksScreen> createState() => _MyPicksScreenState();
}

class _MyPicksScreenState extends State<MyPicksScreen> {
  final PickSource _source = ContentfulPickSource();

  late Future<List<Pick>> _picksFuture;

  @override
  void initState() {
    super.initState();

    // Load picks when the screen is first created.
    _picksFuture = _source.fetchPicks();
  }

  Future<void> _refreshPicks() async {
    final future = _source.fetchPicks();

    setState(() {
      _picksFuture = future;
    });

    try {
      await future;
    } catch (_) {
      // FutureBuilder will display the error state.
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Pick>>(
      future: _picksFuture,
      builder: (context, snapshot) {
        // Loading state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        // Error state
        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 48,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Failed to load your picks.',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${snapshot.error}',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: _refreshPicks,
                    child: const Text('Try again'),
                  ),
                ],
              ),
            ),
          );
        }

        final picks = snapshot.data ?? [];

        // Empty state
        if (picks.isEmpty) {
          return RefreshIndicator(
            onRefresh: _refreshPicks,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: const [
                SizedBox(height: 150),
                Icon(
                  Icons.bookmark_border,
                  size: 60,
                ),
                SizedBox(height: 12),
                Center(
                  child: Text('You have no saved picks yet.'),
                ),
                SizedBox(height: 300),
              ],
            ),
          );
        }

        // Success state
        return RefreshIndicator(
          onRefresh: _refreshPicks,
          child: ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: picks.length,
            separatorBuilder: (context, index) =>
                const Divider(height: 1),
            itemBuilder: (context, index) {
              final pick = picks[index];

              final isBook = pick.kind.toLowerCase() == 'book';

              return ListTile(
                leading: Icon(
                  isBook ? Icons.menu_book : Icons.movie,
                  size: 36,
                ),
                title: Text(pick.title),
                subtitle: Text(
                  pick.note.isEmpty
                      ? 'No note provided.'
                      : pick.note,
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PickDetailScreen(pick: pick),
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
