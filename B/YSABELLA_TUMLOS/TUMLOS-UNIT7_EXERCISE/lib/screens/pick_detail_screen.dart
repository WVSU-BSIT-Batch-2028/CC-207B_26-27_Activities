import 'package:flutter/material.dart';

import '../models/details.dart';
import '../models/pick.dart';
import '../services/api_exception.dart';
import '../services/omdb_api.dart';
import '../services/open_library_api.dart';
import '../widgets/aurora_background.dart';
import '../widgets/glass_bar_background.dart';
import '../widgets/glass_fill.dart';
import '../widgets/glass_title.dart';
import '../widgets/network_cover.dart';
import '../widgets/section_heading.dart';

class PickDetailScreen extends StatefulWidget {
  const PickDetailScreen({super.key, required this.pick});

  final Pick pick;

  @override
  State<PickDetailScreen> createState() => _PickDetailScreenState();
}

class _PickDetailScreenState extends State<PickDetailScreen> {
  late Future<Details> _details;

  @override
  void initState() {
    super.initState();
    _details = widget.pick.isBook
        ? const OpenLibraryApi().details(widget.pick.externalId)
        : const OmdbApi().details(widget.pick.externalId);
  }

  Widget _card({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: GlassFill(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionHeading(title, icon: icon),
            const SizedBox(height: 14),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildSummary(AsyncSnapshot<Details> snapshot) {
    final theme = Theme.of(context);

    if (snapshot.connectionState != ConnectionState.done) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(12),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (snapshot.hasError) {
      return Text(
        describeError(snapshot.error!),
        style: theme.textTheme.bodyLarge?.copyWith(
          color: theme.colorScheme.error,
        ),
      );
    }

    return Text(
      snapshot.data!.summary,
      style: theme.textTheme.bodyLarge?.copyWith(height: 1.5),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final pick = widget.pick;

    return AuroraBackground(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: GlassTitle(pick.title),
          flexibleSpace: const GlassBarBackground(),
        ),
        body: FutureBuilder<Details>(
          future: _details,
          builder: (context, snapshot) {
            return Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 640),
                child: ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    Center(
                      child: NetworkCover(
                        url: snapshot.data?.imageUrl,
                        width: 200,
                        height: 300,
                        icon: pick.isBook
                            ? Icons.menu_book_rounded
                            : Icons.movie_rounded,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      pick.title,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 18),
                    _card(
                      title: 'My note',
                      icon: Icons.sticky_note_2_rounded,
                      child: Text(
                        pick.note.isEmpty ? 'No note yet.' : pick.note,
                        style: theme.textTheme.bodyLarge?.copyWith(height: 1.5),
                      ),
                    ),
                    const SizedBox(height: 18),
                    _card(
                      title: 'Summary',
                      icon: Icons.notes_rounded,
                      child: _buildSummary(snapshot),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
