import 'package:flutter/material.dart';

import '../api/api_exception.dart';
import '../cms/contentful_pick_source.dart';
import '../cms/pick_source.dart';
import '../models/pick.dart';
import '../widgets/state_message.dart';
import 'pick_detail_screen.dart';

/// Recommendations from the CMS. The first request starts in [initState].
class PicksScreen extends StatefulWidget {
  const PicksScreen({super.key, this.source});

  final PickSource? source;

  @override
  State<PicksScreen> createState() => _PicksScreenState();
}

class _PicksScreenState extends State<PicksScreen>
    with AutomaticKeepAliveClientMixin {
  late final PickSource _source;
  late final bool _ownsSource;
  late Future<List<Pick>> _future;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _ownsSource = widget.source == null;
    _source = widget.source ?? ContentfulPickSource();
    _future = _source.fetchPicks();
  }

  @override
  void dispose() {
    final PickSource source = _source;
    if (_ownsSource && source is ContentfulPickSource) {
      source.close();
    }
    super.dispose();
  }

  Future<void> _refresh() async {
    final Future<List<Pick>> future = _source.fetchPicks();
    setState(() {
      _future = future;
    });
    try {
      await future;
    } on Object {
      // The FutureBuilder renders the error, including after a pull.
    }
  }

  void _retry() {
    _refresh();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
      onRefresh: _refresh,
      child: FutureBuilder<List<Pick>>(
        future: _future,
        builder: (BuildContext context, AsyncSnapshot<List<Pick>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting ||
              snapshot.connectionState == ConnectionState.none) {
            return const ScrollFill(
              child: StateMessage(
                icon: Icons.shelves,
                text: 'Loading your picks…',
                showSpinner: true,
              ),
            );
          }
          if (snapshot.hasError) {
            return ScrollFill(
              child: StateMessage(
                icon: Icons.cloud_off,
                text: messageOf(snapshot.error!),
                action: FilledButton(
                  onPressed: _retry,
                  child: const Text('Try again'),
                ),
              ),
            );
          }
          final List<Pick> picks = snapshot.data ?? const <Pick>[];
          if (picks.isEmpty) {
            return const ScrollFill(
              child: StateMessage(
                icon: Icons.shelves,
                text:
                    'Nothing on your shelf yet. Publish a Pick in Contentful, then pull to refresh.',
              ),
            );
          }
          return ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
            itemCount: picks.length,
            separatorBuilder: (BuildContext context, int index) =>
                const SizedBox(height: 12),
            itemBuilder: (BuildContext context, int index) {
              return Align(
                alignment: Alignment.topCenter,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 720),
                  child: _PickTile(pick: picks[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _PickTile extends StatelessWidget {
  const _PickTile({required this.pick});

  final Pick pick;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool book = pick.isBook;
    return Card(
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (BuildContext context) => PickDetailScreen(pick: pick),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              CircleAvatar(
                backgroundColor: book
                    ? theme.colorScheme.secondaryContainer
                    : theme.colorScheme.tertiaryContainer,
                foregroundColor: book
                    ? theme.colorScheme.onSecondaryContainer
                    : theme.colorScheme.onTertiaryContainer,
                child: Icon(book ? Icons.menu_book : Icons.movie),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      pick.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      pick.note.isEmpty
                          ? 'No recommendation note yet.'
                          : pick.note,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        height: 1.35,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: theme.colorScheme.outline),
            ],
          ),
        ),
      ),
    );
  }
}
