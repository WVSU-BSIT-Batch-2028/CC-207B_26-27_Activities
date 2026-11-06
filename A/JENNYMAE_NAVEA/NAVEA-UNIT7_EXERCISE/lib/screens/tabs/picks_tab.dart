import 'package:flutter/material.dart';

import '../../data/contentful_pick_source.dart';
import '../../data/pick_source.dart';
import '../../models/pick.dart';
import '../pick_detail_screen.dart';

class PicksTab extends StatefulWidget {
  const PicksTab({super.key, this.source});

  final PickSource? source;

  @override
  State<PicksTab> createState() => _PicksTabState();
}

class _PicksTabState extends State<PicksTab> {
  late final PickSource _source = widget.source ?? createPickSource();
  late Future<List<Pick>> _picksFuture;

  @override
  void initState() {
    super.initState();
    _picksFuture = _loadPicks();
  }

  Future<List<Pick>> _loadPicks() async => _source.fetchPicks();

  Future<void> _refresh() async {
    final future = _loadPicks();
    setState(() {
      _picksFuture = future;
    });
    try {
      await future;
    } catch (_) {
      // FutureBuilder displays the load error.
    }
  }

  @override
  void dispose() {
    if (widget.source == null && _source is ContentfulPickSource) {
      _source.close();
    }
    super.dispose();
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
              ],
            );
          }
          if (snapshot.hasError) {
            return ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                const SizedBox(height: 120),
                Center(child: Text('Could not load picks: ${snapshot.error}')),
              ],
            );
          }

          final picks = snapshot.data ?? const <Pick>[];
          if (picks.isEmpty) {
            return ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: const [
                SizedBox(height: 120),
                Center(child: Text('No picks added in CMS yet.')),
              ],
            );
          }

          return ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: picks.length,
            itemBuilder: (context, index) {
              final pick = picks[index];
              return ListTile(
                leading: Icon(pick.kind == 'book' ? Icons.menu_book_outlined : Icons.movie),
                title: Text(pick.title),
                subtitle: Text(
                  pick.note,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => PickDetailScreen(pick: pick),
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
