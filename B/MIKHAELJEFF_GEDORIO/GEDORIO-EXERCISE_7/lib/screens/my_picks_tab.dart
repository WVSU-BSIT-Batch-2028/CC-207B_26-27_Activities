import 'package:flutter/material.dart';

import '../models/pick.dart';
import '../services/strapi_pick_source.dart';
import 'pick_detail_screen.dart';

class MyPicksTab extends StatefulWidget {
  const MyPicksTab({super.key});

  @override
  State<MyPicksTab> createState() => _MyPicksTabState();
}

class _MyPicksTabState extends State<MyPicksTab> {
  final StrapiPickSource _source = StrapiPickSource();

  late Future<List<Pick>> _picksFuture;

  @override
  void initState() {
    super.initState();
    _picksFuture = _source.fetchPicks();
  }

  Future<void> _reload() async {
    final future = _source.fetchPicks();

    setState(() {
      _picksFuture = future;
    });

    await future;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Pick>>(
      future: _picksFuture,
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
                const Icon(Icons.wifi_off, size: 48),
                const SizedBox(height: 12),
                const Text('Unable to load your picks.'),
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: _reload,
                  child: const Text('Try again'),
                ),
              ],
            ),
          );
        }

        final picks = snapshot.data ?? [];

        if (picks.isEmpty) {
          return RefreshIndicator(
            onRefresh: _reload,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: const [
                SizedBox(height: 120),
                Icon(Icons.inbox, size: 48),
                SizedBox(height: 12),
                Center(
                  child: Text('You have no picks yet.'),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: _reload,
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: picks.length,
            itemBuilder: (context, index) {
              final pick = picks[index];

              return ListTile(
                leading: Icon(
                  pick.kind == 'book'
                      ? Icons.menu_book
                      : Icons.movie,
                ),
                title: Text(pick.title),
                subtitle: Text(pick.note),
                isThreeLine: true,
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