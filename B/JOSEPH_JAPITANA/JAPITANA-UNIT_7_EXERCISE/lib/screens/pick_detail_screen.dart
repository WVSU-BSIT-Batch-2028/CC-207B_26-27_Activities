import 'package:flutter/material.dart';

import '../data/omdb_api.dart';
import '../data/open_library_api.dart';
import '../models/pick.dart';
import '../models/pick_details.dart';

class PickDetailScreen extends StatefulWidget {
  const PickDetailScreen({super.key, required this.pick});

  final Pick pick;

  @override
  State<PickDetailScreen> createState() => _PickDetailScreenState();
}

class _PickDetailScreenState extends State<PickDetailScreen> {
  late final Future<PickDetails> _details;

  @override
  void initState() {
    super.initState();
    _details = widget.pick.isBook
        ? OpenLibraryApi().fetchWork(widget.pick.externalId)
        : OmdbApi().fetchDetails(widget.pick.externalId);
  }

  @override
  Widget build(BuildContext context) {
    final pick = widget.pick;
    return Scaffold(
      appBar: AppBar(title: Text(pick.title)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (pick.note.isNotEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('My note',
                        style: Theme.of(context).textTheme.labelLarge),
                    const SizedBox(height: 4),
                    Text(pick.note),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 16),
          FutureBuilder<PickDetails>(
            future: _details,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const Padding(
                  padding: EdgeInsets.all(32),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              if (snapshot.hasError) {
                return Text('${snapshot.error}', textAlign: TextAlign.center);
              }
              return _buildDetails(context, snapshot.data!);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDetails(BuildContext context, PickDetails d) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (d.imageUrl != null)
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                d.imageUrl!,
                height: 280,
                semanticLabel: 'Cover of ${d.title}',
                errorBuilder: (context, error, stack) =>
                    const SizedBox.shrink(),
              ),
            ),
          ),
        const SizedBox(height: 16),
        Text(d.title, style: theme.textTheme.headlineSmall),
        if (d.subtitle != null) ...[
          const SizedBox(height: 4),
          Text(d.subtitle!, style: theme.textTheme.bodyMedium),
        ],
        const SizedBox(height: 16),
        Text(d.description ?? 'No description available.'),
      ],
    );
  }
}