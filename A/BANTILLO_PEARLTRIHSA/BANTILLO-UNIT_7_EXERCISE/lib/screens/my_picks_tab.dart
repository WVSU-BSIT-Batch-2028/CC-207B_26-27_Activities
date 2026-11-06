import 'package:flutter/material.dart';

import '../models/pick.dart';
import '../services/contentful_pick_source.dart';
import 'pick_detail_screen.dart';

class MyPicksTab extends StatefulWidget {
  const MyPicksTab({super.key});

  @override
  State<MyPicksTab> createState() => _MyPicksTabState();
}

class _MyPicksTabState extends State<MyPicksTab> {
  final ContentfulPickSource _source = ContentfulPickSource();

  late Future<List<Pick>> _picksFuture;

  @override
  void initState() {
    super.initState();
    _picksFuture = _source.fetchPicks();
  }

  Future<void> _refreshPicks() async {
    setState(() {
      _picksFuture = _source.fetchPicks();
    });

    await _picksFuture;
  }

  Widget _buildPicksList(List<Pick> picks) {
    if (picks.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: const [
          SizedBox(height: 150),
          Center(child: Text('You have no saved picks yet.')),
        ],
      );
    }

    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: picks.length,
      itemBuilder: (context, index) {
        final pick = picks[index];

        final isBook = pick.kind.toLowerCase() == 'book';

        return Column(
          children: [
            ListTile(
              leading: Icon(
                isBook ? Icons.menu_book : Icons.movie_outlined,
                size: 32,
              ),
              title: Text(pick.title),
              subtitle: Text(pick.note),
              isThreeLine: true,
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PickDetailScreen(pick: pick),
                  ),
                );
              },
            ),
            if (index != picks.length - 1)
              const Divider(
                height: 1,
                thickness: 1,
                indent: 16,
                endIndent: 16,
                color: Color(0xFFE8DDE3),
              ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refreshPicks,
      child: FutureBuilder<List<Pick>>(
        future: _picksFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: const [
                SizedBox(height: 180),
                Center(child: CircularProgressIndicator()),
              ],
            );
          }

          if (snapshot.hasError) {
            return ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                const SizedBox(height: 150),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        const Icon(Icons.error_outline, size: 40),
                        const SizedBox(height: 12),
                        Text(
                          'Could not load your Picks.\n${snapshot.error}',
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _picksFuture = _source.fetchPicks();
                            });
                          },
                          child: const Text('Try again'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }

          return _buildPicksList(snapshot.data ?? []);
        },
      ),
    );
  }
}
