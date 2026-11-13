import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'api_exception.dart';
import 'config.dart';
import 'message_view.dart';
import 'pick.dart';
import 'pick_detail_screen.dart';

class PicksTab extends StatefulWidget {
  const PicksTab({super.key});

  @override
  State<PicksTab> createState() => _PicksTabState();
}

class _PicksTabState extends State<PicksTab>
    with AutomaticKeepAliveClientMixin {
  late final PickSource _source;
  Future<List<Pick>>? _future;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    if (cmsConfigured) {
      _source = createPickSource(http.Client());
      _future = _source.fetchPicks(); // started once, here, not in build()
    }
  }

  Future<void> _refresh() async {
    final next = _source.fetchPicks();
    setState(() {
      _future = next;
    });
    try {
      await next; // keeps the spinner until the CMS answers
    } catch (_) {
      // The FutureBuilder shows the error.
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final future = _future;
    if (future == null) {
      return const MessageView(
        icon: Icons.cloud_off_outlined,
        message:
            'Connect your CMS to see my picks.\n\n'
            'Run the app with:\n'
            'flutter run --dart-define=CMS_SPACE=your-space-id '
            '--dart-define=CMS_TOKEN=your-delivery-token',
      );
    }

    return FutureBuilder<List<Pick>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }

        // Pull to refresh also works on the error and empty states, so they
        // are scrollable lists too.
        if (snapshot.hasError) {
          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(
                  height: 400,
                  child: MessageView(
                    icon: Icons.error_outline,
                    message: errorText(snapshot.error),
                    actionLabel: 'Try again',
                    onAction: _refresh,
                  ),
                ),
              ],
            ),
          );
        }

        final picks = snapshot.data!;
        if (picks.isEmpty) {
          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: const [
                SizedBox(
                  height: 400,
                  child: MessageView(
                    icon: Icons.bookmark_border,
                    message: 'No picks yet. Publish one in your CMS.',
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: _refresh,
          child: ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: picks.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final pick = picks[index];
              return ListTile(
                leading: Icon(
                  pick.kind == PickKind.book ? Icons.menu_book : Icons.movie,
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
