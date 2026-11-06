import 'dart:ui' show PointerDeviceKind;

import 'package:flutter/material.dart';

import '../config.dart' as config;
import '../models/pick.dart';
import '../services/pick_source.dart';
import '../widgets/shelf_status.dart';
import 'pick_detail_screen.dart';

class MyPicksScreen extends StatefulWidget {
  const MyPicksScreen({super.key, this.source, this.onOpen});

  final PickSource? source;
  final ValueChanged<Pick>? onOpen;

  @override
  State<MyPicksScreen> createState() => _MyPicksScreenState();
}

class _MyPicksScreenState extends State<MyPicksScreen>
    with AutomaticKeepAliveClientMixin {
  late final PickSource _source;
  late Future<List<Pick>> _picks;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _source =
        widget.source ??
        ContentfulPickSource(
          space: config.cmsSpace,
          token: config.cmsToken,
          environment: config.cmsEnvironment,
        );
    _picks = _source.fetchPicks();
    _picks.ignore();
  }

  Future<void> _refresh() async {
    final next = _source.fetchPicks();
    setState(() {
      _picks = next;
    });
    // FutureBuilder displays failures; the refresh indicator must still finish.
    try {
      await next;
    } catch (_) {}
  }

  void _open(Pick pick) {
    if (widget.onOpen != null) {
      widget.onOpen!(pick);
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => PickDetailScreen(pick: pick)),
    );
  }

  @override
  void dispose() {
    if (widget.source == null) (_source as ContentfulPickSource).close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ScrollConfiguration(
      // Allow the same pull-to-refresh gesture when running in desktop Chrome.
      behavior: ScrollConfiguration.of(context).copyWith(
        dragDevices: {
          ...ScrollConfiguration.of(context).dragDevices,
          PointerDeviceKind.mouse,
        },
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 8, 0),
            child: Row(
              children: [
                const Expanded(child: Text('Recommendations from Contentful')),
                IconButton(
                  tooltip: 'Refresh picks',
                  onPressed: _refresh,
                  icon: const Icon(Icons.refresh),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Pick>>(
              future: _picks,
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const Center(child: CircularProgressIndicator());
                }
                final picks = snapshot.data ?? const <Pick>[];
                return RefreshIndicator(
                  onRefresh: _refresh,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      if (snapshot.hasError || picks.isEmpty) {
                        return ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: [
                            SizedBox(
                              height: constraints.maxHeight,
                              child: ShelfStatus(
                                message: snapshot.hasError
                                    ? '${snapshot.error}'
                                    : 'No picks yet. Publish your recommendations in Contentful, then pull to refresh.',
                                icon: snapshot.hasError
                                    ? Icons.error_outline
                                    : Icons.bookmarks_outlined,
                                onRetry: snapshot.hasError ? _refresh : null,
                              ),
                            ),
                          ],
                        );
                      }
                      return ListView.separated(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(8),
                        itemCount: picks.length,
                        separatorBuilder: (_, _) => const Divider(),
                        itemBuilder: (context, index) {
                          final pick = picks[index];
                          return ListTile(
                            leading: Icon(
                              pick.kind == PickKind.book
                                  ? Icons.menu_book
                                  : Icons.movie_outlined,
                            ),
                            title: Text(pick.title),
                            subtitle: Text(pick.note),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () => _open(pick),
                          );
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
