import 'package:flutter/material.dart';

import '../data/pick_source.dart';
import '../models/pick.dart';
import 'pick_detail_screen.dart';

class MyPicksScreen extends StatefulWidget {
  const MyPicksScreen({super.key, this.source = const ContentfulPickSource()});

  final PickSource source;

  @override
  State<MyPicksScreen> createState() => _MyPicksScreenState();
}

class _MyPicksScreenState extends State<MyPicksScreen> {
  late Future<List<Pick>> _picks;

  @override
  void initState() {
    super.initState();
    _picks = widget.source.fetchPicks();
  }

  Future<void> _refresh() async {
    final request = widget.source.fetchPicks();
    setState(() {
      _picks = request;
    });
    await request;
  }

  Widget _message(String text, {IconData? icon}) => ListView(
    physics: const AlwaysScrollableScrollPhysics(),
    children: [
      const SizedBox(height: 120),
      if (icon != null) Icon(icon, size: 40),
      Padding(
        padding: const EdgeInsets.all(24),
        child: Text(text, textAlign: TextAlign.center),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) => RefreshIndicator(
    onRefresh: _refresh,
    child: FutureBuilder<List<Pick>>(
      future: _picks,
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
          return _message(
            'Could not load picks: ${snapshot.error}\nPull to refresh.',
            icon: Icons.error_outline,
          );
        }
        final picks = snapshot.data ?? const <Pick>[];
        if (picks.isEmpty) {
          return _message(
            'No picks yet. Publish books and movies in Contentful, then pull to refresh.',
            icon: Icons.collections_bookmark_outlined,
          );
        }
        return ListView.separated(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(12),
          itemCount: picks.length,
          separatorBuilder: (context, index) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final pick = picks[index];
            final isBook = pick.kind == PickKind.book;
            return ListTile(
              leading: CircleAvatar(
                child: Icon(
                  isBook ? Icons.menu_book_outlined : Icons.movie_outlined,
                ),
              ),
              title: Text(pick.title),
              subtitle: Text(pick.note),
              isThreeLine: pick.note.length > 50,
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => PickDetailScreen(pick: pick),
                ),
              ),
            );
          },
        );
      },
    ),
  );
}
