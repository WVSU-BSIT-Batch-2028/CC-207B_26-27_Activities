import 'package:flutter/material.dart';

import '../models/pick.dart';
import '../services/contentful_pick_source.dart';
import 'pick_detail_screen.dart';

class MyPicksScreen extends StatefulWidget {
  const MyPicksScreen({super.key});

  @override
  State<MyPicksScreen> createState() => _MyPicksScreenState();
}

class _MyPicksScreenState extends State<MyPicksScreen> {
  final PickSource _pickSource = ContentfulPickSource();

  late Future<List<Pick>> _picksFuture;

  @override
  void initState() {
    super.initState();
    _loadPicks();
  }

  void _loadPicks() {
    _picksFuture = _pickSource.fetchPicks();
  }

  Future<void> _refreshPicks() async {
    setState(() {
      _loadPicks();
    });

    await _picksFuture;
  }

  void _openPickDetails(Pick pick) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PickDetailScreen(pick: pick)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Pick>>(
      future: _picksFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 50, color: Colors.red),
                  const SizedBox(height: 12),
                  const Text(
                    'Unable to load your picks.',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text('${snapshot.error}', textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _refreshPicks,
                    child: const Text('Try Again'),
                  ),
                ],
              ),
            ),
          );
        }

        final picks = snapshot.data ?? [];

        if (picks.isEmpty) {
          return RefreshIndicator(
            onRefresh: _refreshPicks,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: const [
                SizedBox(height: 150),
                Icon(Icons.bookmark_border, size: 60, color: Colors.grey),
                SizedBox(height: 12),
                Center(
                  child: Text('No picks yet.', style: TextStyle(fontSize: 16)),
                ),
                SizedBox(height: 8),
                Center(
                  child: Text(
                    'Your saved books and movies will appear here.',
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: _refreshPicks,
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(12),
            itemCount: picks.length,
            itemBuilder: (context, index) {
              final pick = picks[index];
              final isBook = pick.kind == 'book';

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: CircleAvatar(
                    child: Icon(isBook ? Icons.menu_book : Icons.movie),
                  ),
                  title: Text(pick.title),
                  subtitle: Text(
                    '${isBook ? 'Book' : 'Movie'}\n'
                    '${pick.note.isEmpty ? 'No note added.' : pick.note}',
                  ),
                  isThreeLine: true,
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    _openPickDetails(pick);
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }
}
