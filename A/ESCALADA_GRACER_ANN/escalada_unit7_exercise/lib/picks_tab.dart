import 'package:flutter/material.dart';
import 'books_tab.dart';
import 'item_details.dart';
import 'movies_tab.dart';
import 'picks.dart';

class PicksTab extends StatefulWidget {
  const PicksTab({super.key});

  @override
  State<PicksTab> createState() => _PicksTabState();
}

class _PicksTabState extends State<PicksTab> {
  final PickSource source = StrapiPickSource();
  late Future<List<Pick>> _picks;

  @override
  void initState() {
    super.initState();
    _picks = source.fetchPicks();
  }

  Future<void> _refresh() async {
    final future = source.fetchPicks();
    setState(() {
      _picks = future;
    });
    try {
      await future;
    } catch (_) {
      // the FutureBuilder shows the error
    }
  }

  // A scrollable message, so pull to refresh also works on empty/error states.
  Widget _message(String text) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        const SizedBox(height: 120),
        Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(text, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refresh,
      child: FutureBuilder<List<Pick>>(
        future: _picks,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return _message('Error: ${snapshot.error}\nPull down to retry.');
          }
          final picks = snapshot.data!;
          if (picks.isEmpty) {
            return _message('No picks yet.');
          }
          return ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              for (final pick in picks)
                ListTile(
                  leading: Icon(
                    pick.kind == 'book' ? Icons.menu_book : Icons.movie,
                  ),
                  title: Text(pick.title),
                  subtitle: Text(pick.note),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PickDetailScreen(pick: pick),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class PickDetailScreen extends StatefulWidget {
  final Pick pick;

  const PickDetailScreen({super.key, required this.pick});

  @override
  State<PickDetailScreen> createState() => _PickDetailScreenState();
}

class _PickDetailScreenState extends State<PickDetailScreen> {
  late Future<ItemDetails> _details;

  @override
  void initState() {
    super.initState();
    _details = widget.pick.kind == 'book'
        ? OpenLibraryApi().details(widget.pick.externalId)
        : OmdbApi().details(widget.pick.externalId);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(widget.pick.title)),
      body: FutureBuilder<ItemDetails>(
        future: _details,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: theme.textTheme.bodyMedium,
              ),
            );
          }
          final details = snapshot.data!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: details.imageUrl == null
                      ? Icon(
                          widget.pick.kind == 'book'
                              ? Icons.menu_book
                              : Icons.movie,
                          size: 96,
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            details.imageUrl!,
                            height: 300,
                            fit: BoxFit.cover,
                            semanticLabel: 'Image of ${details.title}',
                          ),
                        ),
                ),
                const SizedBox(height: 16),
                Text(details.title, style: theme.textTheme.headlineSmall),
                const SizedBox(height: 8),
                                Text('Why I recommend this', style: theme.textTheme.titleMedium),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.format_quote,
                        size: 48,
                        color: theme.colorScheme.outline,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          widget.pick.note,
                          style: theme.textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text('Summary', style: theme.textTheme.titleMedium),
                Text(details.summary, style: theme.textTheme.bodyMedium),
              ],
            ),
          );
        },
      ),
    );
  }
}