import 'package:flutter/material.dart';
import '../models/pick.dart';
import '../services/pick_source.dart';
import 'pick_detail_screen.dart';

class MyPicksTab extends StatefulWidget {
  final PickSource? pickSource;

  const MyPicksTab({super.key, this.pickSource});

  @override
  State<MyPicksTab> createState() => _MyPicksTabState();
}

class _MyPicksTabState extends State<MyPicksTab> {
  late final PickSource _pickSource;
  late Future<List<Pick>> _picksFuture;

  @override
  void initState() {
    super.initState();
    _pickSource = widget.pickSource ?? ContentfulPickSource();
    // Requirement Part D.c: The request starts in initState, not in build()
    _picksFuture = _pickSource.fetchPicks();
  }

  Future<void> _refreshPicks() async {
    setState(() {
      _picksFuture = _pickSource.fetchPicks();
    });
    await _picksFuture;
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refreshPicks,
      child: FutureBuilder<List<Pick>>(
        future: _picksFuture,
        builder: (context, snapshot) {
          // State 1: Loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // State 2: Error
          if (snapshot.hasError) {
            return Center(
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.cloud_off, size: 56, color: Colors.red),
                    const SizedBox(height: 12),
                    Text(
                      'Failed to load picks: ${snapshot.error}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: () {
                        setState(() {
                          _picksFuture = _pickSource.fetchPicks();
                        });
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          final picks = snapshot.data ?? [];

          // State 3: Empty
          if (picks.isEmpty) {
            return Center(
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.collections_bookmark_outlined,
                        size: 56, color: Colors.grey),
                    SizedBox(height: 12),
                    Text(
                      'No picks found.',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Add picks in your CMS and pull down to refresh.',
                      style: TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            );
          }

          // State 4: List
          return ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: picks.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final pick = picks[index];
              return ListTile(
                leading: Icon(
                  pick.isBook ? Icons.book : Icons.movie,
                  size: 28,
                  color: Theme.of(context).colorScheme.primary,
                ),
                title: Text(
                  pick.title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  pick.note,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => PickDetailScreen(pick: pick),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

