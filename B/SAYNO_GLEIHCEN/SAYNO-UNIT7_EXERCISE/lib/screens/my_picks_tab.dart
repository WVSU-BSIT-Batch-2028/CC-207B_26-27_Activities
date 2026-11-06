import 'package:flutter/material.dart';

import '../config.dart';
import '../data/pick_source.dart';
import '../models/pick.dart';
import '../screens/pick_detail_screen.dart';

class MyPicksTab extends StatefulWidget {
  const MyPicksTab({super.key});

  @override
  State<MyPicksTab> createState() => _MyPicksTabState();
}

class _MyPicksTabState extends State<MyPicksTab> {
  final PickSource _source = SanityPickSource(projectId: cmsProject);
  late Future<List<Pick>> _future;

  @override
  void initState() {
    super.initState();
    // The request starts here, once, and not in build().
    _future = _source.fetchPicks();
  }

  Future<void> _refresh() async {
    setState(() {
      _future = _source.fetchPicks();
    });
    try {
      await _future; // the spinner stays until the CMS answers
    } catch (_) {
      // The FutureBuilder already shows the error.
    }
  }

  Widget _message(IconData icon, String text, {Widget? action}) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48),
            const SizedBox(height: 16),
            Text(text, textAlign: TextAlign.center),
            if (action != null) ...[const SizedBox(height: 16), action],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Pick>>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return _message(
            Icons.cloud_off,
            '${snapshot.error}',
            action: FilledButton.icon(
              onPressed: _refresh,
              icon: const Icon(Icons.refresh),
              label: const Text('Try again'),
            ),
          );
        }
        final picks = snapshot.data!;
        return RefreshIndicator(
          onRefresh: _refresh,
          child: picks.isEmpty
              ? ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    const SizedBox(height: 120),
                    _message(Icons.favorite_outline, 'No picks yet.'),
                  ],
                )
              : ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: picks.length,
                  separatorBuilder: (context, i) => const Divider(height: 1),
                  itemBuilder: (context, i) {
                    final pick = picks[i];
                    return ListTile(
                      leading: Icon(
                        pick.kind == PickKind.book
                            ? Icons.menu_book
                            : Icons.movie,
                      ),
                      title: Text(pick.title),
                      subtitle: Text(pick.note),
                      // D(d): tapping opens the detail screen (next step)
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PickDetailScreen(pick: pick),
                        ),
                      ),                    
                    );
                  },
                ),
        );
      },
    );
  }
}