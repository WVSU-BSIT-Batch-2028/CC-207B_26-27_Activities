import 'package:flutter/material.dart';

import '../models/pick.dart';
import '../services/pick_source.dart';
import 'pick_detail_screen.dart';

class MyPicksScreen extends StatefulWidget {
  final PickSource source;

  const MyPicksScreen({
    super.key,
    this.source = const ContentfulPickSource(),
  });

  @override
  State<MyPicksScreen> createState() => _MyPicksScreenState();
}

class _MyPicksScreenState extends State<MyPicksScreen> {
  late Future<List<Pick>> _picksFuture;

  @override
  void initState() {
    super.initState();
    // Start the CMS request here, not in build(), so rebuilds do not refetch.
    _picksFuture = widget.source.fetchPicks();
  }

  Future<void> _refresh() async {
    final nextRequest = widget.source.fetchPicks();
    setState(() => _picksFuture = nextRequest);
    try {
      await nextRequest;
    } catch (_) {
      // FutureBuilder displays the error state; RefreshIndicator can finish.
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refresh,
      child: FutureBuilder<List<Pick>>(
        future: _picksFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: const [
                SizedBox(height: 180),
                Center(child: CircularProgressIndicator()),
                SizedBox(height: 16),
                Center(child: Text('Loading your picks…')),
              ],
            );
          }

          if (snapshot.hasError) {
            return ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(24),
              children: [
                const SizedBox(height: 60),
                const Icon(Icons.cloud_off_outlined, size: 48),
                const SizedBox(height: 12),
                const Text(
                  'Could not load your picks',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Text('${snapshot.error}', textAlign: TextAlign.center),
                const SizedBox(height: 8),
                const Text(
                  'Pull down to try again.',
                  textAlign: TextAlign.center,
                ),
              ],
            );
          }

          final picks = snapshot.data ?? const <Pick>[];
          if (picks.isEmpty) {
            return ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(24),
              children: const [
                SizedBox(height: 70),
                Icon(Icons.bookmark_border, size: 48),
                SizedBox(height: 12),
                Text(
                  'No picks yet',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 8),
                Text(
                  'Publish book and movie picks in your CMS, then pull down to refresh.',
                  textAlign: TextAlign.center,
                ),
              ],
            );
          }

          return ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
            itemCount: picks.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final pick = picks[index];
              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    child: Icon(
                      pick.isBook
                          ? Icons.menu_book_outlined
                          : pick.isMovie
                              ? Icons.movie_outlined
                              : Icons.bookmark_outline,
                    ),
                  ),
                  title: Text(pick.title),
                  subtitle: Text(pick.note.isEmpty ? 'No note added.' : pick.note),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => PickDetailScreen(pick: pick),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
