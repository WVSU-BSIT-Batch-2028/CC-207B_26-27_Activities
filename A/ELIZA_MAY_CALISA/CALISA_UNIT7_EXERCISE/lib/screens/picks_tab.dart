import 'package:flutter/material.dart';

import '../data/api_exception.dart';
import '../data/pick_source.dart';
import '../models/pick.dart';
import '../widgets/error_view.dart';
import 'pick_detail_screen.dart';

class PicksTab extends StatefulWidget {
  const PicksTab({super.key});

  @override
  State<PicksTab> createState() => _PicksTabState();
}

class _PicksTabState extends State<PicksTab>
    with AutomaticKeepAliveClientMixin {
  final PickSource _source = ContentfulPickSource();
  late Future<List<Pick>> _future;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _future = _source.fetchPicks(); // started here, not in build()
  }

  Future<void> _refresh() async {
    final next = _source.fetchPicks();
    setState(() {
      _future = next;
    });
    try {
      await next; // the spinner stays until the load ends
    } catch (_) {
      // the FutureBuilder shows the error
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder<List<Pick>>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return ErrorView(
            message: messageOf(snapshot.error!),
            onRetry: _refresh,
          );
        }
        final picks = snapshot.data!;
        // A ListView even when empty, so pull to refresh still works.
        return RefreshIndicator(
          onRefresh: _refresh,
          child: picks.isEmpty
              ? ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: const [
                    SizedBox(height: 120),
                    Center(child: Text('No picks yet.')),
                  ],
                )
              : ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: picks.length,
                  itemBuilder: (context, i) {
                    final pick = picks[i];
                    return ListTile(
                      leading: Icon(
                        pick.isBook ? Icons.menu_book : Icons.movie,
                      ),
                      title: Text(pick.title),
                      subtitle: Text(
                        pick.note,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: const Icon(Icons.chevron_right),
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
