import 'package:flutter/material.dart';

import '../models/pick.dart';
import '../services/api_exception.dart';
import '../services/contentful_pick_source.dart';
import '../services/pick_source.dart';
import '../widgets/message_view.dart';
import '../widgets/shelf_card.dart';
import 'pick_detail_screen.dart';

class PicksTab extends StatefulWidget {
  const PicksTab({super.key});

  @override
  State<PicksTab> createState() => _PicksTabState();
}

class _PicksTabState extends State<PicksTab>
    with AutomaticKeepAliveClientMixin {
  final PickSource _source = const ContentfulPickSource();
  late Future<List<Pick>> _picks;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _picks = _source.fetchPicks();
  }

  Future<void> _refresh() async {
    final future = _source.fetchPicks();
    try {
      await future;
    } catch (_) {}
    if (!mounted) return;
    setState(() {
      _picks = future;
    });
  }

  Widget _scrollMessage(IconData icon, String text) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        const SizedBox(height: 80),
        MessageView(icon: icon, text: text),
      ],
    );
  }

  Widget _buildPick(Pick pick) {
    final scheme = Theme.of(context).colorScheme;

    return ShelfCard(
      leading: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: scheme.primaryContainer.withValues(alpha: 0.6),
        ),
        child: Icon(
          pick.isBook ? Icons.menu_book_rounded : Icons.movie_rounded,
          color: scheme.primary,
        ),
      ),
      title: pick.title,
      subtitle: pick.note,
      subtitleLines: 3,
      trailing: const Icon(Icons.chevron_right_rounded),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => PickDetailScreen(pick: pick)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 720),
        child: RefreshIndicator(
          onRefresh: _refresh,
          child: FutureBuilder<List<Pick>>(
            future: _picks,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return _scrollMessage(
                  Icons.error_outline_rounded,
                  '${describeError(snapshot.error!)}\n\nPull down to try again.',
                );
              }

              final picks = snapshot.data!;
              if (picks.isEmpty) {
                return _scrollMessage(
                  Icons.bookmarks_outlined,
                  'No picks yet. Publish some entries in Contentful, '
                  'then pull down to refresh.',
                );
              }

              return ListView.separated(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                itemCount: picks.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 10),
                itemBuilder: (context, index) => _buildPick(picks[index]),
              );
            },
          ),
        ),
      ),
    );
  }
}
